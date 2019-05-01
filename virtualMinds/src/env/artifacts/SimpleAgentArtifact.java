package artifacts;
import java.util.ArrayList;
import java.util.LinkedList;

import cartago.*;
import webSocketLibrary.AbstractWebSocket;
import webSocketLibrary.Message;

public class SimpleAgentArtifact extends AbstractWebSocket {

	protected void init(String agentName) {
		super.init(agentName);
	}
	
	@OPERATION
	void azionePersonalizzata() {
		Message message = new Message(this.agentName,this.agentName,"Azione Personalizzata",new ArrayList<>(),new LinkedList<Long>());
		this.sendAction(message);
	}

}

