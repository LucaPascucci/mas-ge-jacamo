package artifacts;

import java.util.ArrayList;

import cartago.*;
import synapsisJaCaMo.SynapsisBody;

public class PlasticRobotBody extends SynapsisBody {
   
   protected void init(final String agentName, final String url, final int reconnectionAttempts) {
      super.init(agentName, url, reconnectionAttempts);
   }
   
   @OPERATION
   void searchGarbage() {
      this.doAction("Cerca spazzatura", new ArrayList<>());
   }
}

