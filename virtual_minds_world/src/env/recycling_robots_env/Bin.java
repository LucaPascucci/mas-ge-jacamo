package recycling_robots_env;
// CArtAgO artifact code for project virtual_minds_world

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.concurrent.Future;
import java.util.regex.Pattern;

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

import com.google.gson.Gson;

import cartago.*;
import recycling_robots_env.Garbage.MyWebSocket;
import web.Message;

public class Bin extends Artifact {
	
	private String binType;
	
	private MyWebSocket socket;
	
	void init(final String type) {
		this.binType = type;
		this.socket = new MyWebSocket(this.getId().getName());
	}

	@OPERATION
	void getBinType(OpFeedbackParam<String> res) {
		res.set(this.binType);
	}
	
	@ClientEndpoint
	public class MyWebSocket {

		private static final String ENTITY = "brain";
		private Session session;
		private String name;

		public MyWebSocket(final String name) {
			this.name = name;
			String dest = "ws://localhost:8025/middleware/middleware-service/" + ENTITY + "/" + name;
			/*
			 * Utilizzando ClientManager-> asyncConnectToServer la connessione avviene in un 
			 * thread separato permettendo l'uscita dal flusso di controllo dell'artefatto
			 */
			ClientManager client = ClientManager.createClient(); 

			try {
				final Future<Session> future = client.asyncConnectToServer(this, new URI(dest));
			} catch (DeploymentException | URISyntaxException e1) {
				e1.printStackTrace();
			}

		}

		//Utilizza lo stesso flusso di controllo utilizzato dalla connect to server
		@OnOpen
		public void onOpen(Session session) {
			this.session = session;
		}

		@OnMessage
		public void onMessage(String message, Session session) {
			String splittedMsg[] = message.split(Pattern.quote("|"));
			String content = splittedMsg[0];
			if ("START".equals(content)) {
				this.sendMessage(binType);
			} else if ("STOP".equals(content)){
				
			} else {
				//addMessage(content);
			}
		}

		@OnClose
		public void onClose(CloseReason reason, Session session) {
			System.out.println("Closing a WebSocket due to " + reason.getReasonPhrase());
		}

		@OnError
		public void onError(Session session, Throwable error) {
			System.out.println("OnError " + session.getId() + " - message: " + error.getMessage());
		}

		public boolean sendMessage(final String message) {
			try {
				//è possibile utilizzare anche una send asincrona
				this.session.getBasicRemote().sendText(message + "|" + System.currentTimeMillis() );
				return true;
			} catch (IOException e) {
				e.printStackTrace();
			}
			return false;
		}
	}
}

