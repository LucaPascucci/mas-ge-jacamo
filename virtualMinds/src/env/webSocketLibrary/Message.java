package webSocketLibrary;

import java.util.ArrayList;
import java.util.LinkedList;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;

public class Message {

   @SerializedName("Sender")
   private String sender;

   @SerializedName("Receiver")
   private String receiver;

   @SerializedName("Content")
   private String content;

   @SerializedName("Parameters")
   private ArrayList<Object> parameters;

   @SerializedName("TimeStats")
   private LinkedList<Long> timeStats;

   private static Gson gson = new Gson();

   public Message(final String sender, final String receiver, final String content, final ArrayList<Object> parameters, final LinkedList<Long> timeStats) {
      this.sender = sender;
      this.receiver = receiver;
      this.content = content;
      this.parameters = parameters;
      this.timeStats = timeStats;
   }

   public String getSender() {
      return sender;
   }

   public void setSender(String sender) {
      this.sender = sender;
   }

   public String getReceiver() {
      return receiver;
   }

   public void setReceiver(String receiver) {
      this.receiver = receiver;
   }

   public String getContent() {
      return content;
   }

   public void setContent(String content) {
      this.content = content;
   }

   public ArrayList<Object> getParameters() {
      return parameters;
   }

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

   @Override
   public String toString() {
      return gson.toJson(this);
   }

   public static Message buildMessage(String JsonMessage) {
      return gson.fromJson(JsonMessage, Message.class);
   }

}
