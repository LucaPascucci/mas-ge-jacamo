package robots;

import java.util.ArrayList;

import synapsis.SynapsisMind;

public class RobotMind extends SynapsisMind {
   
   private static final String ROBOT_TYPE = "robot_type";
 
   protected void init(final String agentName, final String url, final int reconnectionAttempts, final Object[] params) {
      this.defineObsProperty(ROBOT_TYPE, params[0]); // prendo la tipologia di spazzatura dai parametri custom
      super.init(agentName, url, reconnectionAttempts);
   }
   
   @Override
   public void counterpartEntityReady() {
      if (this.hasObsProperty(ROBOT_TYPE)) {
         String type = this.getObsProperty(ROBOT_TYPE).stringValue();
         this.doAction(ROBOT_TYPE, type);
      }
   }

   @Override
   public void counterpartEntityUnready() {}

   @Override
   public void parseIncomingPerception(String sender, String perception, ArrayList<Object> params) {}

}
