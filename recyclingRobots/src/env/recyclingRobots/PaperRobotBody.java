// CArtAgO artifact code for project recyclingRobots

package recyclingRobots;

import cartago.*;
import synapsisLibrary.SynapsisBody;

public class PaperRobotBody extends SynapsisBody {
   
   protected void init(final String agentName, final String url, final String endpointPath, final int reconnectionAttempts) {
      super.init(agentName, url, endpointPath, reconnectionAttempts);
   }
   
   @OPERATION
   void nulla() {}

}

