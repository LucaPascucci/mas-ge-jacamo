package web;

import java.util.ArrayList;
import java.util.LinkedList;

import com.google.gson.Gson;

public class Message {

	private String Sender;
	private String Receiver;
	private String Content;
	private ArrayList<Object> Parameters;
	private LinkedList<Long> TimeStats;
	
	private static Gson gson = new Gson();

	public Message(final String sender, final String receiver, final String content, final ArrayList<Object> parameters, final LinkedList<Long> timeStats) {
		Sender = sender;
		Receiver = receiver;
		Content = content;
		Parameters = parameters;
		TimeStats = timeStats;
	}

	public String getSender() {
		return Sender;
	}

	public void setSender(String sender) {
		Sender = sender;
	}

	public String getReceiver() {
		return Receiver;
	}

	public void setReceiver(String receiver) {
		Receiver = receiver;
	}

	public String getContent() {
		return Content;
	}

	public void setContent(String content) {
		Content = content;
	}

	public ArrayList<Object> getParameters() {
		return Parameters;
	}

	public void setParameters(ArrayList<Object> parameters) {
		Parameters = parameters;
	}

	public LinkedList<Long> getTimeStats() {
		return TimeStats;
	}

	public void setTimeStats(LinkedList<Long> timeStats) {
		TimeStats = timeStats;
	}

	public void addTimeStat(long time){
		TimeStats.add(time);
	}
	
	@Override
    public String toString() {
        return gson.toJson(this);
    }
	
	public static Message buildMessage(String JsonMessage){
        return gson.fromJson(JsonMessage,Message.class);
    }

}
