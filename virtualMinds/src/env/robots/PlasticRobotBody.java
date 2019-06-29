package robots;

import java.util.ArrayList;
import java.util.Arrays;

import cartago.*;
import synapsisJaCaMo.SynapsisBody;

public class PlasticRobotBody extends SynapsisBody {
   
   protected void init(final String agentName, final String url, final int reconnectionAttempts) {
      super.init(agentName, url, reconnectionAttempts);
   }
   
   @OPERATION
   void searchGarbage() {
      this.doAction("search_garbage", new ArrayList<>());
   }
   
   @OPERATION
   void goTo(String entityName) {
      this.doAction("go_to", new ArrayList<>(Arrays.asList(entityName)));
   }
}

