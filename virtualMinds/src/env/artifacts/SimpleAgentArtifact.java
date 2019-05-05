package artifacts;

import java.util.ArrayList;
import java.util.LinkedList;

import cartago.*;
import webSocketLibrary.VirtualMindWebSocket;
import webSocketLibrary.Message;

public class SimpleAgentArtifact extends VirtualMindWebSocket {

   protected void init(final String agentName, final String url, final String endpointPath) {
      super.init(agentName, url, endpointPath);
   }

   @OPERATION
   void azionePersonalizzata() {
      Message message = new Message(this.agentName, this.agentName, "Azione Personalizzata", new ArrayList<>(),
            new LinkedList<Long>());
      this.sendAction(message);
   }

}
