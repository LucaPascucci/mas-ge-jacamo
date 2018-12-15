package web;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.concurrent.CountDownLatch;

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

public class WebSocket extends Artifact {

	private Socket socket;

	void init() {
		defineObsProperty("online",false);
		defineObsProperty("onMessage","");
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

	@ClientEndpoint
	public class Socket{
		CountDownLatch latch = new CountDownLatch(1); //TODO utile?
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
			latch.countDown();
			ObsProperty prop = getObsProperty("online");
			prop.updateValue(true);
		}

		@OnMessage
		public void onMessage(String message, Session session) {
			System.out.println("Message received from server:" + message);
			ObsProperty prop = getObsProperty("onMessage");
			prop.updateValue(message);
			//signal("onMessage", message);
		}

		
		//Problema!!! non riceve tutti i messaggi che manda il server
		@OnClose
		public void onClose(CloseReason reason, Session session) {
			ObsProperty prop = getObsProperty("online");
			prop.updateValue(false);
			//System.out.println("Closing a WebSocket due to " + reason.getReasonPhrase());
		}

		public CountDownLatch getLatch() {
			return latch;
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

