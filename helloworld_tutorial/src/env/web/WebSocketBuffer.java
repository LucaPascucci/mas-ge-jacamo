package web;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.LinkedList;

import javax.websocket.ClientEndpoint;
import javax.websocket.CloseReason;
import javax.websocket.ContainerProvider;
import javax.websocket.DeploymentException;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.WebSocketContainer;

import cartago.*;

public class WebSocketBuffer extends Artifact {

	private LinkedList<String> buffer;
	private Socket socket;

	void init() {
		defineObsProperty("online",false);
		defineObsProperty("n_messages",0);
		this.buffer = new LinkedList<>();
		this.socket = new Socket(); //start websocket client
	}

	@OPERATION
	void sendMessageToMiddleware(String message) {
		if (this.socket.sendMessage(message)) {
			this.signal("message_sent");
		} else {
			//TODO far fallire il piano
			this.failed("message_not_sent");
			//failed("incBounded failed","incBounded_failed","max_value_reached",this.maxValue);
		}
	}
	
	/*
	 * Operation execution resume: When an agent executes a guarded operation whose guard is false, 
	 * the operation execution is suspended until the guard is evaluated to true.
	 * Mutual exclusion: Mutual exclusion and atomicity are enforce, 
	 * anyway a suspended guarded operation is reactivated and executed only if (when) no operations are in execution.
	 */
	@GUARD 
	boolean itemAvailable() { 
		return this.buffer.size() > 0; 
	}
	
	@OPERATION
	void put(String message){
		this.buffer.add(message);
		getObsProperty("n_messages").updateValue(this.buffer.size());
	}
	
	@OPERATION//(guard="itemAvailable")
	void get(OpFeedbackParam<String> res) {
		String message = buffer.removeFirst();
		res.set(message);
		getObsProperty("n_messages").updateValue(this.buffer.size());
	}

	@ClientEndpoint
	public class Socket{
		//CountDownLatch latch = new CountDownLatch(1); //TODO utile?
		private Session session;

		public Socket() {
			String dest = "ws://localhost:8080/ChatServer_war_exploded/ws";
			WebSocketContainer container = ContainerProvider.getWebSocketContainer();
			try {
				container.connectToServer(this, new URI(dest));
			} catch (DeploymentException | IOException | URISyntaxException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		@OnOpen
		public void onOpen(Session session) {
			//System.out.println("Connected to server");
			this.session = session;
			//latch.countDown();
			ObsProperty prop = getObsProperty("online");
			prop.updateValue(true);
		}

		@OnMessage
		public void onMessage(String message, Session session) {
			put(message);
			//System.out.println("Message received from server:" + message);
			//ObsProperty prop = getObsProperty("onMessage");
			//prop.updateValue(message);
			
		}

		
		//Problema!!! non riceve tutti i messaggi che manda il server
		@OnClose
		public void onClose(CloseReason reason, Session session) {
			ObsProperty prop = getObsProperty("online");
			prop.updateValue(false);
			System.out.println("Closing a WebSocket due to " + reason.getReasonPhrase());
		}

		/*public CountDownLatch getLatch() {
			return latch;
		}*/

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

