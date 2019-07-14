// CArtAgO artifact code for project virtualMinds

package garbages;

import java.util.ArrayList;

import cartago.OPERATION;
import synapsisJaCaMo.SynapsisBody;

public class GarbageBody extends SynapsisBody {
   
   private static final String PICKED_UP_BY = "picked_up_by";
   private static final String GARBAGE_TYPE = "garbage_type";
   
   private static final String MOCK_CLASS = "GarbageMock";

   protected void init(final String name, final String url, final int reconnectionAttempts, final Object... params) {
      this.defineObsProperty(PICKED_UP_BY, false, "");
      this.defineObsProperty(GARBAGE_TYPE, params[0]); // prendo la tipologia di spazzatura dai parametri custom
     
      super.init(name, url, reconnectionAttempts);
      this.createMyMockEntity(MOCK_CLASS);
   }
   
   @OPERATION
   void recycleMe() {
      this.doAction("recycle_me", new ArrayList<>());
      //TODO avviare la distruzione dell'artefatto
      //this.selfDestruction();
   }

   @Override
   public void counterpartEntityReady() {
      if (this.hasObsProperty(GARBAGE_TYPE)) {
         String type = this.getObsProperty(GARBAGE_TYPE).stringValue();
         this.doAction(GARBAGE_TYPE, type);
      }
   }

   @Override
   public void counterpartEntityUnready() {}

   @Override
   public void parseIncomingPerception(String content, ArrayList<Object> params) {}
}