package artifacts;

import java.util.ArrayList;

import cartago.*;
import synapsisJaCaMo.SynapsisBody;

public class SimpleAgentBody extends SynapsisBody {
   
   private int counter = 0;

   protected void init(final String agentName, final String url, final int reconnectionAttempts) {
      super.init(agentName, url, reconnectionAttempts);
   }

   @OPERATION
   void azionePersonalizzata() {
      this.doAction("Azione", new ArrayList<>(counter));
      this.counter++;
   }

}
