package synapsisJaCaMo;

import java.util.ArrayList;
import java.util.LinkedList;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;

/**
 * Classe che rappresenta il messaggio scambiato con il middleware
 */
class Message {

   /**
    * Mittente
    */
   @SerializedName("Sender")
   private String sender;

   /**
    * Destinatario
    */
   @SerializedName("Receiver")
   private String receiver;

   /**
    * Breve descrizione del messaggio
    */
   @SerializedName("Content")
   private String content;

   /**
    * Lista di parametri collegati al contenuto
    */
   @SerializedName("Parameters")
   private ArrayList<Object> parameters;

   /**
    * Lista che memorizza i tempi di invio e ricezione del messaggio
    */
   @SerializedName("TimeStats")
   private LinkedList<Long> timeStats;

   /**
    * Costruttore
    * 
    * @param sender     Mittente
    * @param receiver   Destinatario
    * @param content    Breve contenuto del messaggio
    * @param parameters Lista di parametri collegati al contenuto
    */
   public Message(final String sender, final String receiver, final String content, final ArrayList<Object> parameters) {
      this.setSender(sender);
      this.setReceiver(receiver);
      this.setContent(content);
      this.setParameters(parameters);
      this.setTimeStats(new LinkedList<Long>());
   }

   /**
    * Costruttore
    * 
    * @param sender     Mittente
    * @param receiver   Destinatario
    * @param content    Breve contenuto del messaggio
    * @param parameters Lista di parametri collegati al contenuto
    * @param timeStats  Lista che memorizza i tempi di invio e ricezione del
    *                   messaggio
    */
   public Message(final String sender, final String receiver, final String content, final ArrayList<Object> parameters, final LinkedList<Long> timeStats) {
      this.setSender(sender);
      this.setReceiver(receiver);
      this.setContent(content);
      this.setParameters(parameters);
      this.setTimeStats(timeStats);
   }

   /**
    * Ottieni nome mittente
    * 
    * @return nome mittente
    */
   public String getSender() {
      return sender;
   }

   /**
    * Imposta nome mittente
    * 
    * @param sender nome mittente
    */
   public void setSender(final String sender) {
      this.sender = sender;
   }

   /**
    * Ottieni nome destinatario
    * 
    * @return nome destinatario
    */
   public String getReceiver() {
      return receiver;
   }

   /**
    * Imposta nome destinatario
    * 
    * @param receiver nome destinatario
    */
   public void setReceiver(final String receiver) {
      this.receiver = receiver;
   }

   /**
    * Ottieni contenuto messaggio
    * 
    * @return contenuto messaggio
    */
   public String getContent() {
      return content;
   }

   /**
    * Imposta contenuto messaggio
    * 
    * @param content contenuto messaggio
    */
   public void setContent(final String content) {
      this.content = content;
   }

   /**
    * Ottieni la lista di parametri collegati al contenuto
    * 
    * @return lista di parametri
    */
   public ArrayList<Object> getParameters() {
      return parameters;
   }

   /**
    * Imposta la lista dei parametri collegati al contenuto
    * 
    * @param lista di parametri
    */
   public void setParameters(final ArrayList<Object> parameters) {
      this.parameters = parameters;
   }

   /**
    * Ottieni la lista delle statistiche temporali del messaggio
    * 
    * @return lista delle statistiche temporali
    */
   public LinkedList<Long> getTimeStats() {
      return timeStats;
   }

   /**
    * Imposta la lista delle statistiche temporali del messaggio
    * 
    * @param lista delle statistiche temporali
    */
   public void setTimeStats(final LinkedList<Long> timeStats) {
      this.timeStats = timeStats;
   }

   /**
    * Aggiungi un parametro collegato al contenuto del messaggio
    * 
    * @param parametro da aggiungere
    */
   public void addParameter(final Object param) {
      this.parameters.add(param);
   }

   /**
    * Aggiungi una statistica temporale al messaggio
    * 
    * @param statistica temporale
    */
   public void addTimeStat(final long time) {
      this.timeStats.add(time);
   }

   /**
    * Converte il messaggio in stringa (formato JSON)
    */
   @Override
   public String toString() {
      return new Gson().toJson(this);
   }

   /**
    * Metodo per costruire l'oggetto Messaggio a partire dalla stringa che lo
    * rappresenta
    * 
    * @param JsonMessage stringa che rappresenta il messaggio
    * @return Oggetto Messaggio costruito
    */
   public static Message buildMessage(final String JsonMessage) {
      return new Gson().fromJson(JsonMessage, Message.class);
   }

   // Contenuto array --> [timestamp invio entità, timestamp ricezione su Synapsis,
   // timestamp invio da Synapsis, timestamp ricezione entità]

   private long getTimeFromSenderToSynapsis() {
      return (this.timeStats.get(1) - this.timeStats.getFirst());
   }

   private long getSynapsisComputation() {
      return (this.timeStats.get(2) - this.timeStats.get(1));
   }

   private long getTimeFromSynapsisToReceiver() {
      return (this.timeStats.getLast() - this.timeStats.get(2));
   }

   private long getTotalTime() {
      return (this.timeStats.getLast() - this.timeStats.getFirst());
   }

   // S2S = Sender to Synapsis
   // SC = Synapsis Computation
   // S2R = Synapsis to Receiver

   public String getCalculatedTimeStats() {
      return "Message TimeStats -> Total: " + this.getTotalTime() + " mills - S2S: " + this.getTimeFromSenderToSynapsis() + " mills - SC: "
            + this.getSynapsisComputation() + " mills - S2R: " + this.getTimeFromSynapsisToReceiver() + " mills";
   }

}
