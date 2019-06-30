package synapsisJaCaMo;

import java.io.IOException;

import java.net.URI;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

import cartago.Artifact;
import cartago.OPERATION;

public abstract class SynapsisBody extends Artifact {

   private SynapsisWebSocket webSocket;
   private SynapsisBodyInfo bodyInfo;

   protected void init(final String name, final String url, final int reconnectionAttempts) {
      this.bodyInfo = new SynapsisBodyInfo(name);
      
      this.defineObsProperty(Shared.SYNAPSIS_COUNTERPART_STATUS_BELIEF, name, false);

      this.webSocket = new SynapsisWebSocket(url, reconnectionAttempts);
   }
   
   //FIXME dovrebbe essere il metodo richiamato prima della distruzione dell'artefatto??
   protected void stop() {
      this.printLog("dispose");
      //Invio la richiesta di eliminare la propria mock entity (anche se non presente) per evitare di lasciarla attiva nel middleware
      this.deleteMyMockEntity();
   }
   
   protected void doAction(final String action, final ArrayList<Object> params) {
      this.webSocket.sendMessage(new Message(this.bodyInfo.entityName, this.bodyInfo.entityName, action, params));
   }
   
   @OPERATION
   protected void createMyMockEntity(final String className) {
      this.createMockEntity(className, this.bodyInfo.entityName);
   }
   
   @OPERATION
   protected void deleteMyMockEntity() {
      this.deleteMockEntity(this.bodyInfo.entityName);
   }
   
   public abstract void counterpartEntityReady();
  
   public abstract void counterpartEntityUnready();
   
   public abstract void parsePerception(final String content, ArrayList<Object> params);
   
   private void createMockEntity(final String className, final String entityName) {
      Message message = new Message(this.bodyInfo.entityName, Shared.SYNAPSIS_MIDDLEWARE, Shared.SYNAPSIS_MIDDLEWARE_CREATE_MOCK);
      message.addParameter(className);
      message.addParameter(entityName);
      message.addParameter(Shared.ENTITY_BODY_KEY);
      this.webSocket.sendMessage(message);
   }

   private void deleteMockEntity(final String entityName) {
      Message message = new Message(this.bodyInfo.entityName, Shared.SYNAPSIS_MIDDLEWARE, Shared.SYNAPSIS_MIDDLEWARE_DELETE_MOCK);
      message.addParameter(entityName);
      message.addParameter(Shared.ENTITY_BODY_KEY);
      this.webSocket.sendMessage(message);
   }

   private void incomingMessage(final Message message) {
      // Begins an external use session of the artifact. Method to be called by external threads (not agents) before starting calling methods on the artifact.
      this.beginExternalSession();

      // Prelevo i parametri e li converto in array di Object cosi da renderli facilmente utilizzabili su JASON
      Object[] params = new Object[message.getParameters().size()];
      params = message.getParameters().toArray(params);

      if (this.hasObsProperty(message.getContent())) {
         this.updateObsProperty(message.getContent(), params);
      } else {
         this.defineObsProperty(message.getContent(), params);
      }
      
      this.parsePerception(message.getContent(), message.getParameters());

      // Ends an external use session. Method to be called to close a session started by a thread to finalize the state.
      this.endExternalSession(true);
   }

   private void changeCounterpartStatus(final boolean status) {
      this.beginExternalSession();
      this.updateObsProperty(Shared.SYNAPSIS_COUNTERPART_STATUS_BELIEF, bodyInfo.entityName, status);
      if (status) {
         this.counterpartEntityReady();
      } else {
         this.counterpartEntityUnready();
      }
      this.endExternalSession(true);
   }

   protected void printLog(final String log) {
      this.beginExternalSession();
      String time = new SimpleDateFormat("HH:mm:ss").format(new Date()); // 12:08:43
      this.log("[SynapsisBody - " + this.bodyInfo.entityName + " - " + time + "]: " + log);
      this.endExternalSession(true);
   }

   @ClientEndpoint
   protected class SynapsisWebSocket extends ReconnectHandler {

      private ClientManager clientManager = ClientManager.createClient();
      private Session session;
      private ConcurrentLinkedQueue<Message> messagesToSendToBody = new ConcurrentLinkedQueue<>();
      private ConcurrentLinkedQueue<Message> messagesToSendToMiddleware = new ConcurrentLinkedQueue<>();
      private int reconnectionAttempts;

      public SynapsisWebSocket(final String url, final int reconnectionAttempts) {
         this.reconnectionAttempts = reconnectionAttempts;

         try {
            clientManager.getProperties().put(ClientProperties.RECONNECT_HANDLER, SynapsisWebSocket.this);
            
            // La connessione avviene in un thread separato rispetto a quello dell'artefatto
            this.clientManager.asyncConnectToServer(SynapsisWebSocket.this, new URI(url + Shared.SYNAPSIS_ENDPOINT_PATH + Shared.ENTITY_MIND_KEY + "/" + bodyInfo.entityName));
            // this.clientManager.asyncConnectToServer(SynapsisWebSocket.this, new URI("ws://synapsis-middleware.herokuapp.com/"+ Shared.SYNAPSIS_ENDPOINT_PATH + Shared.ENTITY_MIND_KEY + "/" + bodyInfo.entityName));
         
         } catch (DeploymentException | URISyntaxException e1) {
            e1.printStackTrace();
         }
      }

      @OnOpen
      public void onOpen(Session session) { // Tyrus utilizza un thread secondario
         bodyInfo.currentReconnectionAttempt = 0;
         bodyInfo.synapsisStatus = ConnectionStatus.CONNECTED;
         this.session = session;
         this.rifleMessagesToSendToMiddleware();
      }

      @OnMessage
      public void onMessage(String JSONmessage, Session session) { // Tyrus utilizza un thread secondario
         long currentMills = System.currentTimeMillis();
         Message message = Message.buildMessage(JSONmessage);
         message.addTimeStat(currentMills);
         // printLog("onMessage: " + message.toString());

         if (message.getSender().equals(Shared.SYNAPSIS_MIDDLEWARE)) {
            switch (message.getContent()) {
            case Shared.COUNTERPART_READY:
               bodyInfo.bodyStatus = ConnectionStatus.CONNECTED;
               this.rifleMessagesToSendToBody();
               changeCounterpartStatus(true);
               break;
            case Shared.COUNTERPART_UNREADY:
               changeCounterpartStatus(false);
               bodyInfo.bodyStatus = ConnectionStatus.DISCONNECTED;
            }
         } else {
            incomingMessage(message);
         }
      }

      @OnClose
      public void onClose(CloseReason reason, Session session) { // Tyrus utilizza un thread secondario
         changeCounterpartStatus(false);
         bodyInfo.synapsisStatus = ConnectionStatus.DISCONNECTED;
         bodyInfo.bodyStatus = ConnectionStatus.DISCONNECTED;
         printLog("onClose: Sessione: " + session.getId() + " - messaggio: " + reason.getReasonPhrase());
      }

      @OnError
      public void onError(Session session, Throwable error) { // Tyrus utilizza un thread secondario
         changeCounterpartStatus(false);
         bodyInfo.synapsisStatus = ConnectionStatus.DISCONNECTED;
         bodyInfo.bodyStatus = ConnectionStatus.DISCONNECTED;
         printLog("OnError: Sessione:" + session.getId() + " - messaggio: " + error.getMessage());
         // error.printStackTrace();
      }

      public void sendMessage(final Message message) {
         try { 
            switch (message.getReceiver()) {
            case Shared.SYNAPSIS_MIDDLEWARE:
               if (ConnectionStatus.CONNECTED.equals(bodyInfo.synapsisStatus)) {
                  message.addTimeStat(System.currentTimeMillis());
                  this.session.getBasicRemote().sendText(message.toString());
               } else {
                  this.messagesToSendToMiddleware.add(message);
               }
               break;
            default:
               if (ConnectionStatus.CONNECTED.equals(bodyInfo.bodyStatus)) {
                  message.addTimeStat(System.currentTimeMillis());
                  this.session.getBasicRemote().sendText(message.toString());
               } else {
                  this.messagesToSendToBody.add(message);
               }
               break;
            }
         } catch (IOException e) {
            if (Shared.SYNAPSIS_MIDDLEWARE.equals(message.getReceiver())) {
               this.messagesToSendToMiddleware.add(message);
            } else {
               this.messagesToSendToBody.add(message);
            }
            e.printStackTrace();
         }
      }

      private void rifleMessagesToSendToBody() {
         // printLog("Invio al body tutti i messaggi in attesa...");
         for (Iterator<Message> iterator = messagesToSendToBody.iterator(); iterator.hasNext();) {
            this.sendMessage(iterator.next());
            iterator.remove();
         }
      }

      private void rifleMessagesToSendToMiddleware() {
         // printLog("Invio al middleware tutti i messaggi in attesa...");
         for (Iterator<Message> iterator = messagesToSendToMiddleware.iterator(); iterator.hasNext();) {
            this.sendMessage(iterator.next());
            iterator.remove();
         }
      }
      
      // XXX: Il delay tra una riconnessione di default è 5 secondi

      @Override
      // Invocato dopo il metodo onClose della WebSocket
      public boolean onDisconnect(CloseReason closeReason) {
         bodyInfo.currentReconnectionAttempt++;
         if (this.reconnectionAttempts >= bodyInfo.currentReconnectionAttempt) {
            printLog("onDisconnect - messaggio: " + closeReason.getReasonPhrase() + " --> Tentativo riconnessione " + bodyInfo.currentReconnectionAttempt);
            return true;
         } else {
            return false;
         }
      }

      @Override
      // Invocato dopo Connect o AsyncConnect
      public boolean onConnectFailure(Exception exception) {
         bodyInfo.currentReconnectionAttempt++;
         if (this.reconnectionAttempts >= bodyInfo.currentReconnectionAttempt) {
            printLog("onConnectFailure - messaggio: " + exception.toString() + " --> Tentativo riconnesione " + bodyInfo.currentReconnectionAttempt);
            // exception.printStackTrace();
            return true;
         } else {
            return false;
         }
      }
   }
}
