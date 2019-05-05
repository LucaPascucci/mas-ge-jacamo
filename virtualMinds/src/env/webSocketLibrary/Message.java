package webSocketLibrary;

import java.util.ArrayList;
import java.util.LinkedList;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;

/**
 * Classe che rappresenta il messaggio scambiato con il middleware
 */
public class Message {

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
   public Message(final String sender, final String receiver, final String content,
         final ArrayList<Object> parameters) {
      this.sender = sender;
      this.receiver = receiver;
      this.content = content;
      this.parameters = parameters;
      this.timeStats = new LinkedList<Long>();
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
   public Message(final String sender, final String receiver, final String content, final ArrayList<Object> parameters,
         final LinkedList<Long> timeStats) {
      this.sender = sender;
      this.receiver = receiver;
      this.content = content;
      this.parameters = parameters;
      this.timeStats = timeStats;
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
   public void setSender(String sender) {
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
   public void setReceiver(String receiver) {
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
    * @param content contenuto messaggio
    */
   public void setContent(String content) {
      this.content = content;
   }

   /**
    * Ottieni la lista di parametri collegati al contenuto
    * @return lista di parametri
    */
   public ArrayList<Object> getParameters() {
      return parameters;
   }

   /**
    * 
    * @param parameters
    */
   public void setParameters(ArrayList<Object> parameters) {
      this.parameters = parameters;
   }

   public LinkedList<Long> getTimeStats() {
      return timeStats;
   }

   public void setTimeStats(LinkedList<Long> timeStats) {
      this.timeStats = timeStats;
   }

   public void addTimeStat(long time) {
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
   public static Message buildMessage(String JsonMessage) {
      return new Gson().fromJson(JsonMessage, Message.class);
   }

}
