package robots;

import java.util.ArrayList;

import cartago.OPERATION;
import synapsisJaCaMo.SynapsisBody;

public class RobotBody extends SynapsisBody {
   
   private static final String ROBOT_TYPE = "robot_type";
   
   private static final String SEARCH_GARBAGE = "search_garbage";
   private static final String PICK_UP_GARBAGE = "pick_up_garbage";
   private static final String RECYCLE_GARBAGE = "recycle_garbage";
   private static final String SEARCH_BIN = "search_bin";
   
   protected void init(final String agentName, final String url, final int reconnectionAttempts, final Object[] params) {
      this.defineObsProperty(ROBOT_TYPE, params[0]); // prendo la tipologia di spazzatura dai parametri custom
      super.init(agentName, url, reconnectionAttempts);
   }
   
   @OPERATION
   void searchGarbage() {
      this.doAction(SEARCH_GARBAGE);
   }
   
   @OPERATION
   void searchBin() {
      this.doAction(SEARCH_BIN);
   }
   
   @OPERATION
   void pickUpGarbage(String entityName) {
      this.doAction(PICK_UP_GARBAGE,entityName);
   }
   
   @OPERATION
   void recycleGarbage(String entityName) {
      this.doAction(RECYCLE_GARBAGE, entityName);
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
   public void parseIncomingPerception(String content, ArrayList<Object> params) {}

}
