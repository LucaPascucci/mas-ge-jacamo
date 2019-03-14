package web;


import java.util.ArrayList;
import java.util.LinkedList;

import cartago.*;

public class WebSocketAloneAgent extends AbstractWebSocket {

	void init(String agentName) {
		super.init(agentName);
		
		//System.out.println("Artifact -> ID: " + this.getId().getId() + " - name: " + this.getId().getName());
	}
	
	@OPERATION
	void azionePersonalizzata() {
		Message message = new Message(this.agentName,this.agentName,"Azione Personalizzata",new ArrayList<>(),new LinkedList<>());
		this.action(message);
	}
	
	@OPERATION
	void perception(OpFeedbackParam<Object> res) {
		
	}

}

