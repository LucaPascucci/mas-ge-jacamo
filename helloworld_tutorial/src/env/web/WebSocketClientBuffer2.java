package web;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.LinkedList;
import java.util.concurrent.ConcurrentLinkedQueue;

import javax.websocket.ClientEndpoint;
import javax.websocket.CloseReason;
import javax.websocket.ContainerProvider;
import javax.websocket.DeploymentException;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.WebSocketContainer;

import cartago.*;

public class WebSocketClientBuffer2 extends Artifact {

	private ConcurrentLinkedQueue<String> buffer;
	private Socket socket;
	private String agent_name;

	void init() {
		defineObsProperty("online",false);
		defineObsProperty("n_messages",0);
		this.buffer = new ConcurrentLinkedQueue<>();
		this.socket = new Socket(); //start websocket client
		this.agent_name = "";
	}
	
	@OPERATION
	void registerBrain(String message) {
		this.agent_name = message;
		if (this.socket.sendMessage(message)) {
			this.signal("message_sent");
		} else {
			//TODO far fallire il piano dell'agente
			this.failed("message_not_sent");
		}
	}

	@OPERATION
	void sendMessageToBody(String message) {
		if (this.socket.sendMessage(this.agent_name + ": " + message)) {
			this.signal("message_sent");
		} else {
			//TODO far fallire il piano dell'agente
			this.failed("message_not_sent");
		}
	}
	
	/*
	 * Operation execution resume: When an agent executes a guarded operation whose guard is false, 
	 * the operation execution is suspended until the guard is evaluated to true.
	 * Mutual exclusion: Mutual exclusion and atomicity are enforce, 
	 * anyway a suspended guarded operation is reactivated and executed only if (when) no operations are in execution.
	 */
	@GUARD 
	boolean itemAvailable(OpFeedbackParam<Object> res) { 
		return this.buffer.size() > 0; 
	}
	
	@OPERATION
	void put(String message) {
		this.buffer.add(message);
		getObsProperty("n_messages").updateValue(this.buffer.size()); //Modifica della proprietà osservabile -> porta ad una modifica alla BB dell'agente che monitora l'artefatto
		this.signal("message_recieved"); //UTILIZZANDO la primitiva signal si riesce a "forzare" l'estrazione del messggio da parte dell'agente
		
		System.out.println("Buffer list size:" + buffer.size() + " -> " + message);
	}
	
	@OPERATION//(guard="itemAvailable")
	void get(OpFeedbackParam<String> res) {
		String message = this.buffer.poll();
		res.set(message);
		//ObsProperty prop = this.getObsProperty("n_messages");
		//prop.updateValue(prop.intValue()-1);
		getObsProperty("n_messages").updateValue(this.buffer.size());
	}

	@ClientEndpoint
	public class Socket{
		private Session session;

		public Socket() {
			String dest = "ws://localhost:8025/middleware/middleware-service";
			WebSocketContainer container = ContainerProvider.getWebSocketContainer();
			try {
				container.connectToServer(this, new URI(dest));
			} catch (DeploymentException | IOException | URISyntaxException e) {
				e.printStackTrace();
			}
		}
		
		@OnOpen
		public void onOpen(Session session) {
			this.session = session;
			ObsProperty prop = getObsProperty("online");
			prop.updateValue(true);
		}

		@OnMessage
		public void onMessage(String message, Session session) {
			//alla ricezione di un messaggio lo inserisco nell'artefatto
			put(message);
		}

		@OnClose
		public void onClose(CloseReason reason, Session session) {
			ObsProperty prop = getObsProperty("online");
			prop.updateValue(false);
			System.out.println("Closing a WebSocket due to " + reason.getReasonPhrase());
		}
		
		@OnError
		public void onError(Session session, Throwable thr) {
			System.out.println("OnError " + session.getId());
		}

		public boolean sendMessage(String str) {
			try {
				this.session.getBasicRemote().sendText(str);
				return true;
			} catch (IOException e) {
				e.printStackTrace();
			}
			return false;
		}
	}
}

