package web;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.LinkedList;

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

public class WebSocket extends Artifact {

	private LinkedList<String> buffer;
	private LinkedList<Message> messagesIN;
	private MyWebSocket socket;
	private String agentName;

	void init(String agentName) {
		this.agentName = agentName;
		this.defineObsProperty("online",false);
		this.defineObsProperty("linked_to_body",false);
		this.defineObsProperty("n_messages",0);
		this.defineObsProperty("n_messages_obj", 0);
		this.buffer = new LinkedList<>();
		this.messagesIN = new LinkedList<>();
		this.socket = new MyWebSocket(this.agentName);
		
		//System.out.println("Artifact -> ID: " + this.getId().getId() + " - name: " + this.getId().getName());
	}
	
	@OPERATION
	void action(String content) { //TODO aggiungere parametri dinamici
		Message message = new Message(this.agentName,this.agentName,content,new ArrayList<>(),new LinkedList<>());
		if (this.socket.sendMessage(message)) {
			this.signal("message_sent");
		} else {
			//TODO far fallire il piano dell'agente
			this.failed("message_not_sent");
		}
	}
	
	@OPERATION
	void action(String content,int value) { //TODO aggiungere parametri dinamici
		Message message = new Message(this.agentName,this.agentName,content,new ArrayList<>(value),new LinkedList<>());
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
	
	/**
	 * Preleva il primo messaggio
	 * @param res messaggio prelevato
	 */
	@OPERATION
	void getAnswer(OpFeedbackParam<Object> res) {
		Message message = this.messagesIN.removeFirst();
		//TODO passare - content + parametri 
		res.set(message);
		this.signal(message.getContent(),message.getParameters());
	}
	
	@OPERATION(guard="MessageAvailable")
	void getAnswerWithGuard(OpFeedbackParam<Object> res) {
		Message message = this.messagesIN.removeFirst();
		//TODO passare - content + parametri
		this.signal(message.getContent());
		this.signal(message.getContent(),message.getParameters());
		res.set(message);
	}
	@OPERATION(guard="MessageAvailable")
	void getStringAnswerWithGuard(OpFeedbackParam<String> res) {
		Message message = this.messagesIN.removeFirst();
		//TODO passare - content + parametri
		this.signal(message.getContent());
		this.signal(message.getContent(),message.getParameters());
		res.set(message.toString());
	}
	
	@GUARD
	  boolean MessageAvailable(OpFeedbackParam<Object> res){
	    return this.messagesIN.size() > 0;
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
		this.buffer.add(message);
		this.updateObsProperty("n_messages", this.buffer.size()); //Aggiorna la proprietà osservabile -> porta ad una modifica alla BB dell'agente che monitora l'artefatto
		/*
		 * Ends an external use session. 
		 * Method to be called to close a session started by a thread to finalize the state.
		 */
		this.endExternalSession(true);	
	}
	
	void addMessage(Message message) {
		/*
		 * Begins an external use session of the artifact. 
		 * Method to be called by external threads (not agents) 
		 * before starting calling methods on the artifact.
		 */
		this.beginExternalSession();
		this.messagesIN.add(message);
		this.updateObsProperty("n_messages_obj", this.messagesIN.size()); //Aggiorna la proprietà osservabile -> porta ad una modifica alla BB dell'agente che monitora l'artefatto
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
	
	void linkedToBody(boolean status) {
		this.beginExternalSession();
		this.updateObsProperty("linked_to_body", status);
		this.endExternalSession(true);
	}
	

	@ClientEndpoint
	public class MyWebSocket {
		
		private static final String ENDPOINT_PATH = "/middleware-service";
		private static final String ENTITY_PATH = "/brain";
		private Session session;
		private String name;
		
		private int counter;
		private long U_t_M;
		private long MC;
		private long M_t_J;

		public MyWebSocket(final String name) {
			this.name = name;
			String dest = "ws://localhost:8025/middleware" + ENDPOINT_PATH + ENTITY_PATH + "/" + name;
			
			//Utilizzando ClientManager-> asyncConnectToServer la connessione avviene in un thread separato permettendo l'uscita dal flusso di controllo dell'artefatto
			ClientManager client = ClientManager.createClient();
			
			//TODO ritorna null??
			System.out.println("SHARED_CONTAINER: " + client.getProperties().get(ClientProperties.SHARED_CONTAINER));
			
			try {
				/*final Future<Session> future = */client.asyncConnectToServer(this, new URI(dest));
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
			changeOnlineStatus(true);
			//updateObsProperty("online",true); //utilizzare questa modalità nel caso la websocket venga creata dentro lo stesso flusso di controllo dell'artefatto
		}

		//Tyrus utilizza un flusso di controllo separato per la ricezione di messaggi quindi
		@OnMessage
		public void onMessage(String message, Session session) {
			Message msgObj = Message.buildMessage(message);
			//System.out.println(message);
			
			switch (msgObj.getContent()) {
			case "START":
				linkedToBody(true);
				break;
			case "STOP":
				linkedToBody(false);
				break;
			case "lastmessage":
				//this.printDelays(splittedMsg, currentMillis);
				//this.printAverage();
				//addMessage(msgObj.getContent());
				break;
			default:
				//this.printDelays(splittedMsg, currentMillis);
				addMessage(msgObj);
				//addMessage(msgObj.getContent());
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
		
		public boolean sendMessage(final String message) {
			try {
				this.session.getBasicRemote().sendText(message + "|" + System.currentTimeMillis() );
				return true;
			} catch (IOException e) {
				e.printStackTrace();
			}
			return false;
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
		
		private void printDelays(final String splittedMsg[], final long receivingTime) {
			long unityToMiddleware = Long.parseLong(splittedMsg[2]) - Long.parseLong(splittedMsg[1]);
			long middlewareComputation = Long.parseLong(splittedMsg[3]) - Long.parseLong(splittedMsg[2]);
			long middlewareToJacamo = receivingTime - Long.parseLong(splittedMsg[3]);
			
			//System.out.println("U_to_M: " + unityToMiddleware + " -> M: " + middlewareComputation + " -> M_to_J: " + middlewareToJacamo + "\n");
			
			this.U_t_M += unityToMiddleware;
			this.MC += middlewareComputation;
			this.M_t_J += middlewareToJacamo;
			this.counter++;
		}
		
		private void printAverage() {
			
			double avgUM = (double)this.U_t_M / this.counter;
			double avgMC = (double)this.MC / this.counter;
			double avgMJ = (double)this.M_t_J / this.counter;
			System.out.println(this.name + ": AVERAGE(" + this.counter + ")- U_to_M: " + avgUM + " -> M: " + avgMC + " -> M_to_J: " + avgMJ + "\n");
		}
	}
}

