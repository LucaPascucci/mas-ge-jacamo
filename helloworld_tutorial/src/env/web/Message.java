package web;

public class Message {
	
	private String sender;
	private String receiver;
	
	private String content;
	
	//private String signature;
	
	private long sendingTime;
	private long receivingServerTime;
	private long sendingServerTime;
	
	public Message(final String sender,final String receiver, final String content) {
		this.sender = sender;
		this.receiver = receiver;
		this.content = content;
		System.currentTimeMillis();
	}
	
	public Message (final String content) {
		
	}
	
}
