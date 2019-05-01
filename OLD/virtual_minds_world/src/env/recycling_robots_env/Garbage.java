// CArtAgO artifact code for project helloworld_tutorial

package recycling_robots_env;

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

import cartago.*;

public class Garbage extends Artifact {

	private String garbageType;
	
	private MyWebSocket socket;

	void init(String type) {
		this.garbageType = type;
		this.defineObsProperty("busy", false);
		this.socket = new MyWebSocket(this.getId().getName());
		
		//System.out.println("Artifact -> ID: " + this.getId().getId() + " - name: " + this.getId().getName());
	}
	
	@OPERATION
	void setGarbageBusy(boolean busy){
		if (this.getObsProperty("busy").booleanValue() == busy) {
			this.failed("artifact_already_busy");
		}
		this.updateObsProperty("busy", busy);
	}
	
	@OPERATION
	void getGarbageType(OpFeedbackParam<String> res) {
		res.set(this.garbageType);
	}
	
	//TODO creare metodo per distruggere artefatto

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
			   client.asyncConnectToServer(this, new URI(dest));
			} catch (DeploymentException | URISyntaxException e1) {
				e1.printStackTrace();
			}

		}

		//Utilizza lo stesso flusso di controllo utilizzato dalla connect to server
		@OnOpen
		public void onOpen(Session session) {
			this.session = session;
		}

		//Tyrus utilizza un flusso di controllo separato per la ricezione di messaggi quindi
		@OnMessage
		public void onMessage(String message, Session session) {
			String splittedMsg[] = message.split(Pattern.quote("|"));
			String content = splittedMsg[0];
			if ("START".equals(content)) {
				this.sendMessage(garbageType);
			} else if ("STOP".equals(content)){
				
			} else {
				
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
				this.session.getBasicRemote().sendText(message + "|" + System.currentTimeMillis() );
				return true;
			} catch (IOException e) {
				e.printStackTrace();
			}
			return false;
		}
	}
}

