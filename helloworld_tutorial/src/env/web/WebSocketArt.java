package web;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.LinkedList;
import java.util.concurrent.Future;

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

import cartago.*;

public class WebSocketArt extends Artifact {

	private LinkedList<String> buffer;
	private MyWebSocket socket;

	void init() {
		this.defineObsProperty("online",false);
		this.defineObsProperty("n_messages",0);
		this.buffer = new LinkedList<>();
		this.socket = new MyWebSocket();
	}
	
	@OPERATION
	void registerBrain(String message) {
		if (this.socket.sendMessage(message)) {
			this.signal("message_sent");
		} else {
			//TODO far fallire il piano dell'agente
			this.failed("message_not_sent");
		}
	}

	@OPERATION
	void sendMessageToBody(String message) {
		if (this.socket.sendMessage(message)) {
			this.signal("message_sent");
		} else {
			//TODO far fallire il piano dell'agente
			this.failed("message_not_sent");
		}
	}

	/**
	 * Preleva il primo messaggio del buffer
	 * @param res messaggio prelevato
	 */
	@OPERATION
	void get(OpFeedbackParam<String> res) {
		String message = this.buffer.removeFirst();
		res.set(message);
	}
	
	//Internal Operation = utile per definire del codice asincrono eseguito dentro l'artefatto 
	@INTERNAL_OPERATION
	void addMessageInternal(String message) {
		this.buffer.add(message);
	}
	
	void addMessage(String message) {
		/*
		 * Start the execution of an internal operation. 
		 * The execution/success semantics of the new operation 
		 * is completely independent from current operation.
		 */
		//TODO NON va bene perchè essendo asincrona non sappiamo quando realmente viene eseguita
		//this.execInternalOp("addMessageInternal", message); //Metodo per eseguire una internal operation 
		
		/*
		 * Begins an external use session of the artifact. 
		 * Method to be called by external threads (not agents) 
		 * before starting calling methods on the artifact.
		 */
		this.beginExternalSession();
		this.buffer.add(message); //TODO potrebbe causare un blocco
		this.updateObsProperty("n_messages", this.buffer.size()); //Aggiorna la proprietà osservabile -> porta ad una modifica alla BB dell'agente che monitora l'artefatto
		/*
		 * Ends an external use session. 
		 * Method to be called to close a session started by a thread to finalize the state.
		 */
		this.endExternalSession(true);	
	}
	
	void changeOnlineStatus(boolean status) {
		this.beginExternalSession();
		this.updateObsProperty("online",status);
		this.endExternalSession(true);
	}
	

	@ClientEndpoint
	public class MyWebSocket {
		private Session session;

		public MyWebSocket() {
			String dest = "ws://localhost:8025/middleware/middleware-service";
			/*
			 * Utilizzando ClientManager-> asyncConnectToServer la connessione avviene in un 
			 * thread separato permettendo l'uscita dal flusso di controllo dell'artefatto
			 */
			ClientManager client = ClientManager.createClient(); 
			//TODO ritorna null
			System.out.println("SHARED_CONTAINER: " + client.getProperties().get(ClientProperties.SHARED_CONTAINER));
			
			try {
				final Future<Session> future = client.asyncConnectToServer(this, new URI(dest));
			} catch (DeploymentException | URISyntaxException e1) {
				e1.printStackTrace();
			}
			
			/*
			 * Utilizzando WebSocketContainer -> connectToServer la connessione avviene nello 
			 * flusso di controllo dell'artefatto
			 */
			/*WebSocketContainer container = ContainerProvider.getWebSocketContainer();
			try {
				container.connectToServer(this, new URI(dest));
			} catch (DeploymentException | IOException | URISyntaxException e) {
				e.printStackTrace();
			}*/
			
		}
		
		//Utilizza lo stesso flusso di controllo utilizzato dalla connect to server
		@OnOpen
		public void onOpen(Session session) {
			this.session = session;
			//updateObsProperty("online",true); //utilizzare questa modalità nel caso la websocket venga creata dentro lo stesso flusso di controllo dell'artefatto
			changeOnlineStatus(true);
		}

		//Tyrus utilizza un thread separato per la ricezione di messaggi quindi
		@OnMessage
		public void onMessage(String message, Session session) {
			addMessage(message);
		}

		@OnClose
		public void onClose(CloseReason reason, Session session) {
			System.out.println("Closing a WebSocket due to " + reason.getReasonPhrase());
			changeOnlineStatus(false);
		}
		
		@OnError
		public void onError(Session session, Throwable thr) {
			System.out.println("OnError " + session.getId());
		}
		
		public boolean sendMessage(String message) {
			try {
				this.session.getBasicRemote().sendText(message);
				//TODO se necessario è possibile utilizzare una send ASINCRONA
				//Future<Void> future = this.session.getAsyncRemote().sendText(message);
				return true;
			} catch (IOException e) {
				e.printStackTrace();
			}
			return false;
		}
	}
}

