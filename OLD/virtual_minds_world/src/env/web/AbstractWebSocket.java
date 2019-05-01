package web;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.LinkedList;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicInteger;

import javax.websocket.ClientEndpoint;
import javax.websocket.CloseReason;
import javax.websocket.DeploymentException;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;

import org.glassfish.tyrus.client.ClientManager;
import org.glassfish.tyrus.client.ClientProperties;
import org.glassfish.tyrus.container.grizzly.client.GrizzlyClientContainer;

import cartago.*;

public abstract class AbstractWebSocket extends Artifact {

	private static final String ONLINE_STATUS = "online";
	private static final String LINK_TO_BODY_STATUS = "link_to_body";
	private static final String INCOMING_MESSSAGES = "incoming_messages";
	
	private LinkedList<Message> messages;
	private MyWebSocket socket;

	public String agentName;

	void init(String agentName) {
		this.agentName = agentName;
		this.defineObsProperty(ONLINE_STATUS,false);
		this.defineObsProperty(LINK_TO_BODY_STATUS,false);
		this.defineObsProperty(INCOMING_MESSSAGES, 0);
		this.messages = new LinkedList<>();
		this.socket = new MyWebSocket(this.agentName);

		//System.out.println("Abstract_Artifact -> ID: " + this.getId().getId() + " - name: " + this.getId().getName());
	}

	void action(Message message) {
		if (this.socket.sendMessage(message)) {
			this.signal("message_sent");
		} else {
			//TODO far fallire il piano dell'agente
			this.failed("message_not_sent");
		}
	}

	/**
	 * Preleva il primo messaggio
	 * @param res messaggio prelevato
	 */
	@OPERATION
	private void getAnswer(OpFeedbackParam<Object> res) {
		Message message = this.messages.removeFirst();
		res.set(message);
	}

	@OPERATION(guard="MessageAvailable")
	private void getAnswerWithGuard(OpFeedbackParam<Object> res) {
		Message message = this.messages.removeFirst();
		res.set(message);
	}

	@OPERATION(guard="MessageAvailable")
	private void getStringAnswerWithGuard(OpFeedbackParam<String> res) {
		Message message = this.messages.removeFirst();
		res.set(message.toString());
	}

	@GUARD
	private boolean MessageAvailable(OpFeedbackParam<Object> res){
		return this.messages.size() > 0;
	}

	void addMessage(Message message) {
		/*
		 * Begins an external use session of the artifact. 
		 * Method to be called by external threads (not agents) 
		 * before starting calling methods on the artifact.
		 */
		this.beginExternalSession();
		this.messages.add(message);
		this.updateObsProperty(INCOMING_MESSSAGES, this.messages.size()); //Aggiorna la proprietà osservabile -> porta ad una modifica alla BB dell'agente che monitora l'artefatto
		/*
		 * Ends an external use session. 
		 * Method to be called to close a session started by a thread to finalize the state.
		 */
		this.endExternalSession(true);	
	}

	void changeOnlineStatus(boolean status) {
		this.beginExternalSession();
		this.updateObsProperty(ONLINE_STATUS,status);
		this.endExternalSession(true);
	}

	void linkedToBody(boolean status) {
		this.beginExternalSession();
		this.updateObsProperty(LINK_TO_BODY_STATUS, status);
		this.endExternalSession(true);
	}


	@ClientEndpoint
	public class MyWebSocket {

		private static final String ENDPOINT_PATH = "/middleware-service";
		private static final String ENTITY_PATH = "/brain";
		private Session session;
		
		public MyWebSocket(final String name) {
			String dest = "ws://localhost:8025/middleware" + ENDPOINT_PATH + ENTITY_PATH + "/" + name;

			ClientManager clientManager = ClientManager.createClient();
			
			// -------INIZIO-------- Per effettuare riconnessione automatica ---------
			final CountDownLatch onDisconnectLatch = new CountDownLatch(1);
			final CountDownLatch messageLatch = new CountDownLatch(1);
			
			ClientManager.ReconnectHandler reconnectHandler = new ClientManager.ReconnectHandler() {

                private final AtomicInteger disconnectCounter = new AtomicInteger(0);
                private final AtomicInteger connectFailureCounter = new AtomicInteger(0);

                @Override
                public boolean onDisconnect(CloseReason closeReason) {
                    final int i = disconnectCounter.incrementAndGet();
                    if (i <= 3) {
                        System.out.println("### Disconnesso... (Tentativo riconnessione: " + i + ")");
                        return true;
                    } else {
                        onDisconnectLatch.countDown();
                        return false;
                    }
                }
                
                @Override
                public boolean onConnectFailure(Exception exception) {
                    final int i = connectFailureCounter.incrementAndGet();
                    if (i <= 10) {
                        System.out.println("### Connessione fallita... (Tentativo riconnessione: " + i + ") " + exception.getMessage());
                        return true;
                    } else {
                        messageLatch.countDown();
                        return false;
                    }
                }

                @Override
                public long getDelay() {
                    return 2; // secondi
                }

            };
            
            clientManager.getProperties().put(ClientProperties.RECONNECT_HANDLER, reconnectHandler);
            // -----FINE---------- Per effettuare riconnessione automatica ---------
            
			//Ritornava NULL perché JDK client only support shared container, quindi impostare questa proprietà non genera modifiche effettive
            clientManager.getProperties().put(ClientProperties.SHARED_CONTAINER,true);
			System.out.println("SHARED_CONTAINER: " + clientManager.getProperties().get(ClientProperties.SHARED_CONTAINER) + " TIMEOUT: " + clientManager.getProperties().get(ClientProperties.SHARED_CONTAINER_IDLE_TIMEOUT));
			
			try {
				//Utilizzando ClientManager-> asyncConnectToServer la connessione avviene in un thread separato permettendo l'uscita dal flusso di controllo dell'artefatto
				clientManager.asyncConnectToServer(this, new URI(dest));
			} catch (DeploymentException | URISyntaxException e1) {
				e1.printStackTrace();
			}

		}

		// Utilizza lo stesso flusso di controllo utilizzato dalla connect to server
		@OnOpen
		public void onOpen(Session session) {
			this.session = session;
			changeOnlineStatus(true);
			//updateObsProperty("online",true); //utilizzare questa modalità nel caso la websocket venga creata dentro lo stesso flusso di controllo dell'artefatto
		}

		// Tyrus utilizza un flusso di controllo separato per la ricezione di messaggi
		@OnMessage
		public void onMessage(String message, Session session) {
			System.out.println("onMessage " + message);
			Message msgObj = Message.buildMessage(message);
			switch (msgObj.getContent()) {
			case "START":
				linkedToBody(true);
				break;
			case "STOP":
				linkedToBody(false);
				break;
			default:
				addMessage(msgObj);
				break;
			}
		}

		@OnClose
		public void onClose(CloseReason reason, Session session) {
			System.out.println("Closing a WebSocket due to " + reason.getReasonPhrase());
			linkedToBody(false);
			changeOnlineStatus(false);
		}

		@OnError
		public void onError(Session session, Throwable error) {
			System.out.println("OnError session:" + session.getId() + " - message: " + error.getMessage());
			error.printStackTrace();
		}

		public boolean sendMessage(final Message message) {
			try {
				message.addTimeStat(System.currentTimeMillis());
				this.session.getBasicRemote().sendText(message.toString());
				return true;
			} catch (IOException e) {
				e.printStackTrace();
			}
			return false;
		}
	}
}

