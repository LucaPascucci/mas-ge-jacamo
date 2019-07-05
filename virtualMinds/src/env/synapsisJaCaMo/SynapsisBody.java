package synapsisJaCaMo;

import java.io.IOException;

import java.net.URI;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
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
   protected SynapsisBodyInfo bodyInfo;

   private ArrayList<String> runtimeObsProperties = new ArrayList<String>();

   protected void init(final String name, final String url, final int reconnectionAttempts) {
      this.bodyInfo = new SynapsisBodyInfo(name);

      this.defineObsProperty(Shared.SYNAPSIS_COUNTERPART_STATUS_BELIEF, name, false);

      this.webSocket = new SynapsisWebSocket(url, reconnectionAttempts);
   }

   //XXX: Per essere sicuri di utilizzare le OPERATION del proprio SynapsisBody è necessario specificare [artifact_id(Art_Id)] dopo l'operazione che si vuole utilizzare (lato .asl)
   @OPERATION
   public void goTo(final String entityName) {
      this.sendAction(Shared.GO_TO_ACTION, new ArrayList<>(Arrays.asList(entityName)));
   }

   @OPERATION
   public void doAction(final String action, final Object... params) {
      if (params.length > 0) {
         this.sendAction(action, new ArrayList<>(Arrays.asList(params)));
      } else {
         this.sendAction(action, new ArrayList<>());
      }
   }

   @OPERATION
   public void stopAction() {
      this.sendAction(Shared.STOP_ACTION, new ArrayList<>());
   }
   
   @OPERATION
   public void removeRuntimeObsProperty(final String property) {
      if (this.hasObsProperty(property)) {
         this.runtimeObsProperties.remove(property);
         this.removeObsProperty(property);
      }
   }

   @OPERATION
   public void removeAllRuntimeObsProperties() {
      for (String property : this.runtimeObsProperties) {
         this.removeRuntimeObsProperty(property);
      }
   }
   
   @OPERATION
   public void createMyMockEntity(final String className) {
      Message message = new Message(this.bodyInfo.getEntityName(), Shared.SYNAPSIS_MIDDLEWARE, Shared.SYNAPSIS_MIDDLEWARE_CREATE_MOCK);
      message.addParameter(className);
      this.webSocket.sendMessage(message);
   }

   @OPERATION
   public void deleteMyMockEntity() {
      Message message = new Message(this.bodyInfo.getEntityName(), Shared.SYNAPSIS_MIDDLEWARE, Shared.SYNAPSIS_MIDDLEWARE_DELETE_MOCK);
      this.webSocket.sendMessage(message);
   }

   @OPERATION
   protected void synapsisLog(final Object... params) {
      String log = "";
      for (Object object : params) {
         log += (String) object + " ";
      }
      log = log.trim();
      this.synapsisBodyLog(log);
   }

   //FIXME dovrebbe essere il metodo richiamato prima della distruzione dell'artefatto??
   @Override
   protected void dispose() {
      this.synapsisBodyLog("dispose");
      this.deleteMyMockEntity(); //Invio la richiesta di eliminare la propria mock entity (anche se non presente) per evitare di lasciarla attiva nel middleware
   }
   
   private void synapsisBodyLog(final String log) {
      this.beginExternalSession();
      String time = new SimpleDateFormat("HH:mm:ss").format(new Date()); // 12:08:43
      this.log(time + " - [Synapsis - " + this.bodyInfo.getEntityName() + "]: " + log);
      this.endExternalSession(true);
   }

   public abstract void counterpartEntityReady();

   public abstract void counterpartEntityUnready();

   public abstract void parseIncomingPerception(final String perception, final ArrayList<Object> params);
   
   private void sendAction(final String action, final ArrayList<Object> params) {
      this.webSocket.sendMessage(new Message(this.bodyInfo.getEntityName(), this.bodyInfo.getEntityName(), action, params));
   }

   private void incomingMessage(final Message message) {
      // Begins an external use session of the artifact. Method to be called by external threads (not agents) before starting calling methods on the artifact.
      this.beginExternalSession();

      // Prelevo i parametri e li converto in array di Object cosi da renderli facilmente utilizzabili su JASON
      Object[] params = new Object[message.getParameters().size()];
      params = message.getParameters().toArray(params);

      // Definizione o aggiornamento delle proprietà osservabili
      if (this.hasObsProperty(message.getContent())) {
         this.updateObsProperty(message.getContent(), params);
      } else {
         this.defineObsProperty(message.getContent(), params);
      }
      this.runtimeObsProperties.add(message.getContent()); //Aggiungo la nuova proprietà alla lista delle osservabili 

      this.parseIncomingPerception(message.getContent(), message.getParameters());

      // Ends an external use session. Method to be called to close a session started by a thread to finalize the state.
      this.endExternalSession(true);
   }

   private void changeCounterpartStatus(final boolean status) {
      this.beginExternalSession();
      this.updateObsProperty(Shared.SYNAPSIS_COUNTERPART_STATUS_BELIEF, bodyInfo.getEntityName(), status);
      if (status) {
         this.counterpartEntityReady();
      } else {
         this.counterpartEntityUnready();
      }
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
            this.clientManager.asyncConnectToServer(SynapsisWebSocket.this, new URI(url + Shared.SYNAPSIS_ENDPOINT_PATH + Shared.ENTITY_MIND_KEY + "/" + bodyInfo.getEntityName()));
            // this.clientManager.asyncConnectToServer(SynapsisWebSocket.this, new URI("ws://synapsis-middleware.herokuapp.com/"+ Shared.SYNAPSIS_ENDPOINT_PATH + Shared.ENTITY_MIND_KEY + "/" + bodyInfo.entityName));

         } catch (DeploymentException | URISyntaxException e1) {
            e1.printStackTrace();
         }
      }

      @OnOpen
      public void onOpen(final Session session) { // Tyrus utilizza un thread secondario
         bodyInfo.setCurrentReconnectionAttempt(0);
         bodyInfo.setSynapsisStatus(ConnectionStatus.CONNECTED);
         this.session = session;
         this.rifleMessagesToSendToMiddleware();
      }

      @OnMessage
      public void onMessage(final String msg, final Session session) { // Tyrus utilizza un thread secondario
         long currentMills = System.currentTimeMillis();
         Message message = Message.buildMessage(msg);
         message.addTimeStat(currentMills);
         bodyInfo.addNewMessage(message); //Aggiorno le statistiche di ricezione

         if (message.getSender().equals(Shared.SYNAPSIS_MIDDLEWARE)) {
            switch (message.getContent()) {
            case Shared.COUNTERPART_READY:
               bodyInfo.setBodyStatus(ConnectionStatus.CONNECTED);
               this.rifleMessagesToSendToBody();
               changeCounterpartStatus(true);
               break;
            case Shared.COUNTERPART_UNREADY:
               changeCounterpartStatus(false);
               bodyInfo.setBodyStatus(ConnectionStatus.DISCONNECTED);
            }
         } else {
            incomingMessage(message);
         }
      }

      @OnClose
      public void onClose(final CloseReason reason, final Session session) { // Tyrus utilizza un thread secondario
         changeCounterpartStatus(false);
         bodyInfo.setSynapsisStatus(ConnectionStatus.DISCONNECTED);
         bodyInfo.setBodyStatus(ConnectionStatus.DISCONNECTED);
         synapsisBodyLog("onClose: Sessione: " + session.getId() + " - messaggio: " + reason.getReasonPhrase());
      }

      @OnError
      public void onError(final Session session, final Throwable error) { // Tyrus utilizza un thread secondario
         changeCounterpartStatus(false);
         bodyInfo.setSynapsisStatus(ConnectionStatus.DISCONNECTED);
         bodyInfo.setBodyStatus(ConnectionStatus.DISCONNECTED);
         synapsisBodyLog("OnError: Sessione:" + session.getId() + " - messaggio: " + error.getMessage());
         // error.printStackTrace();
      }

      public void sendMessage(final Message message) {
         try { 
            switch (message.getReceiver()) {
            case Shared.SYNAPSIS_MIDDLEWARE:
               if (ConnectionStatus.CONNECTED.equals(bodyInfo.getSynapsisStatus())) {
                  message.addTimeStat(System.currentTimeMillis()); //timeStat di invio
                  this.session.getBasicRemote().sendText(message.toString());
               } else {
                  this.messagesToSendToMiddleware.add(message);
               }
               break;
            default:
               if (ConnectionStatus.CONNECTED.equals(bodyInfo.getBodyStatus())) {
                  message.addTimeStat(System.currentTimeMillis()); //timeStat di invio
                  this.session.getBasicRemote().sendText(message.toString());
               } else {
                  this.messagesToSendToBody.add(message);
               }
               break;
            }
         } catch (IOException e) {
            message.clearTimeStats(); //rimuovo il tempo di invio
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
         for (Iterator<Message> iterator = this.messagesToSendToBody.iterator(); iterator.hasNext();) {
            this.sendMessage(iterator.next());
            iterator.remove();
         }
      }

      private void rifleMessagesToSendToMiddleware() {
         // printLog("Invio al middleware tutti i messaggi in attesa...");
         for (Iterator<Message> iterator = this.messagesToSendToMiddleware.iterator(); iterator.hasNext();) {
            this.sendMessage(iterator.next());
            iterator.remove();
         }
      }

      // XXX: Il delay tra una riconnessione di default è 5 secondi

      @Override
      // Invocato dopo il metodo onClose della WebSocket
      public boolean onDisconnect(final CloseReason closeReason) {
         bodyInfo.setCurrentReconnectionAttempt(bodyInfo.getCurrentReconnectionAttempt() + 1);
         if (this.reconnectionAttempts >= bodyInfo.getCurrentReconnectionAttempt()) {
            synapsisBodyLog("onDisconnect - messaggio: " + closeReason.getReasonPhrase() + " --> Tentativo riconnessione " + bodyInfo.getCurrentReconnectionAttempt());
            return true;
         } else {
            return false;
         }
      }

      @Override
      // Invocato dopo Connect o AsyncConnect
      public boolean onConnectFailure(final Exception exception) {
         bodyInfo.setCurrentReconnectionAttempt(bodyInfo.getCurrentReconnectionAttempt() + 1);
         if (this.reconnectionAttempts >= bodyInfo.getCurrentReconnectionAttempt()) {
            synapsisBodyLog("onConnectFailure - messaggio: " + exception.toString() + " --> Tentativo riconnesione " + bodyInfo.getCurrentReconnectionAttempt());
            // exception.printStackTrace();
            return true;
         } else {
            return false;
         }
      }
   }
}
