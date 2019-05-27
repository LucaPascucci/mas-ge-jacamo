package artifacts;

import java.util.ArrayList;

import cartago.*;
import synapsisJaCaMo.SynapsisBody;

public class PlasticRobotBody extends SynapsisBody {
   
   protected void init(final String agentName, final String url, final String endpointPath, final int reconnectionAttempts) {
      super.init(agentName, url, endpointPath, reconnectionAttempts);
   }
   
   @OPERATION
   void searchGarbage() {
      this.doAction("Cerca spazzatura", new ArrayList<>());
   }
}

