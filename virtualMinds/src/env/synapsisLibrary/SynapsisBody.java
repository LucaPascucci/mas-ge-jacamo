package synapsisLibrary;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.concurrent.ConcurrentLinkedQueue;

import javax.websocket.ClientEndpoint;
import javax.websocket.CloseReason;
import javax.websocket.DeploymentException;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;

import org.glassfish.tyrus.client.ClientManager;
import org.glassfish.tyrus.client.ClientManager.ReconnectHandler;
import org.glassfish.tyrus.client.ClientProperties;

import cartago.*;

public abstract class SynapsisBody extends Artifact {

   private static final String SYNAPSIS_BODY_STATUS = "synapsis_body_status";

   private SynapsisWebSocket webSocket;

   public String agentName;

   protected void init(final String agentName, final String url, final String endpointPath,
         final int reconnectionAttempts) {
      this.agentName = agentName;
      this.defineObsProperty(SYNAPSIS_BODY_STATUS, false);

      this.webSocket = new SynapsisWebSocket(url, endpointPath, reconnectionAttempts);
   }
   
   protected void doAction(String action, ArrayList<Object> params) {
      this.webSocket.sendMessage(new Message(this.agentName, this.agentName, action, params));
   }

   private void incomingMessage(Message message) {
      /*
       * Begins an external use session of the artifact. Method to be called by
       * external threads (not agents) before starting calling methods on the
       * artifact.
       */
      this.beginExternalSession();
      
      // Prelevo i parametri e li converto in array di Object
      Object[] params = new Object[message.getParameters().size()];
      params = message.getParameters().toArray(params);
      
      //TODO parsing ricorsivo dei parametri?
      
      if (this.hasObsProperty(message.getContent())){
         this.updateObsProperty(message.getContent(), params);
      }else {
         this.defineObsProperty(message.getContent(), params);
      }
      
      /*
       * Ends an external use session. Method to be called to close a session started
       * by a thread to finalize the state.
       */
      this.endExternalSession(true);

   }

   private void changeBodyStatus(boolean status) {
      this.beginExternalSession();
      this.updateObsProperty(SYNAPSIS_BODY_STATUS, status);
      this.endExternalSession(true);
   }

   private void printLog(String log) {
      this.beginExternalSession();
      System.out.println("[SynapsisBody - " + this.agentName + "] " + log);
      this.endExternalSession(true);
   }

   @ClientEndpoint
   public class SynapsisWebSocket extends ReconnectHandler {
      
      private static final String SYNAPSIS_MIDDLEWARE = "SynapsisMiddleware";
      private static final String SYNAPSIS_MIDDLEWARE_ROOM_READY = "RoomReady";
      private static final String SYNAPSIS_MIDDLEWARE_ROOM_UNREADY = "RoomUnready";
      private static final String ENTITY_PATH = "brain/";
      private ClientManager clientManager;
      private Session session;
      private ConnectionStatus status;
      private ConcurrentLinkedQueue<Message> messagesToSend;
      private int reconnectionAttempts;
      private int attempt;

      public SynapsisWebSocket(final String url, final String endpointPath, final int reconnectionAttempts) {
         this.status = ConnectionStatus.SYNAPSIS_DISCONNECTED;
         this.clientManager = ClientManager.createClient();
         this.messagesToSend = new ConcurrentLinkedQueue<>();
         this.reconnectionAttempts = reconnectionAttempts;
         this.attempt = 0;
         
         try {
            clientManager.getProperties().put(ClientProperties.RECONNECT_HANDLER,SynapsisWebSocket.this);
            // La connessione avviene in un thread separato rispetto a quello dell'artefatto
            this.clientManager.asyncConnectToServer(SynapsisWebSocket.this, new URI(url + endpointPath + ENTITY_PATH + agentName));
            //this.clientManager.asyncConnectToServer(this, new URI("ws://localhost:8025/synapsis/service/brain/test1"));
         } catch (DeploymentException | URISyntaxException e1) {
            e1.printStackTrace();
            // TODO quindi?? cosa faccio??
         }
      }

      @OnOpen
      public void onOpen(Session session) { // Tyrus utilizza un thread secondario
         this.session = session;
         this.attempt = 0;
         this.status = ConnectionStatus.SYNAPSIS_CONNECTED;
         changeBodyStatus(true);
      }

      @OnMessage
      public void onMessage(String JSONmessage, Session session) { // Tyrus utilizza un thread secondario per la ricezione di messaggi
         Message message = Message.buildMessage(JSONmessage);

         if (message.getSender().equals(SYNAPSIS_MIDDLEWARE)) {
            switch (message.getContent()) {
            case SYNAPSIS_MIDDLEWARE_ROOM_READY:
               this.status = ConnectionStatus.SYNAPSIS_BODY_CONNECTED;
               this.rifleMessagesToSend();
               break;
            case SYNAPSIS_MIDDLEWARE_ROOM_UNREADY:
               this.status = ConnectionStatus.SYNAPSIS_BODY_DISCONNECTED;
            }
         } else {
            incomingMessage(message);
         }
      }

      @OnClose
      public void onClose(CloseReason reason, Session session) { // Tyrus utilizza un thread secondario
         this.status = ConnectionStatus.SYNAPSIS_DISCONNECTED;
         changeBodyStatus(false);
         printLog("onClose: Sessione: " + session.getId() + " - messaggio: " + reason.getReasonPhrase());
      }

      @OnError
      public void onError(Session session, Throwable error) { // Tyrus utilizza un thread secondario
         this.status = ConnectionStatus.SYNAPSIS_DISCONNECTED;
         changeBodyStatus(false);
         printLog("OnError: Sessione:" + session.getId() + " - messaggio: " + error.getMessage());
         error.printStackTrace();
      }

      public void sendMessage(final Message message) {
         if (this.status.equals(ConnectionStatus.SYNAPSIS_BODY_CONNECTED)) {
            message.addTimeStat(System.currentTimeMillis());
            try {
               this.session.getBasicRemote().sendText(message.toString());
            } catch (IOException e) {
               this.messagesToSend.add(message);
               e.printStackTrace(); //Cosa succedee? //TODO guardare su tyrus

            }
         } else {
            this.messagesToSend.add(message);
         }
      }

      private void rifleMessagesToSend() {
         printLog("Invio di tutti i messaggi in attesa...");
         for (Iterator<Message> iterator = messagesToSend.iterator(); iterator.hasNext();) {
            this.sendMessage(iterator.next());
            iterator.remove();
         }
      }

      @Override
      // Invocato dopo il metodo onClose della WebSocket
      public boolean onDisconnect(CloseReason closeReason) {
         this.attempt++;
         if (this.reconnectionAttempts >= this.attempt) {
            printLog("onDisconnect - messaggio: " + closeReason.getReasonPhrase() +" --> Tentativo riconnessione " + this.attempt);
            return true;
         } else {
            return false;
         }
      }

      @Override
      //Invocato dopo Connect o AsyncConnect
      public boolean onConnectFailure(Exception exception) {
         this.attempt++;
         if (this.reconnectionAttempts >= this.attempt) {
            printLog("onConnectFailure - messaggio: " + exception.toString() + " --> Tentativo riconnesione " + this.attempt);
            exception.printStackTrace();
            return true;
         } else {   
         return false;
         }
      }

   }
}
