// CArtAgO artifact code for project virtualMinds

package garbages;

import java.util.ArrayList;
import java.util.Arrays;

import synapsisJaCaMo.SynapsisBody;

public class GarbageBody extends SynapsisBody {
   
   private static final String GARBAGE_STATUS = "garbage_status";
   private static final String GARBAGE_TYPE = "garbage_type";
   
   private static final String MOCK_CLASS = "GarbageMock";

   protected void init(final String name, final String url, final int reconnectionAttempts, final Object[] params) {
      this.defineObsProperty(GARBAGE_STATUS, false, "");
      this.defineObsProperty(GARBAGE_TYPE, params[0]); // prendo la tipologia di spazzatura dai parametri custom
     
      super.init(name, url, reconnectionAttempts);
      this.createMyMockEntity(MOCK_CLASS);
   }

   @Override
   public void counterpartEntityReady() {
      if (this.hasObsProperty(GARBAGE_TYPE)) {
         String type = this.getObsProperty(GARBAGE_TYPE).stringValue();
         this.doAction(GARBAGE_TYPE, new ArrayList<>(Arrays.asList(type)));
      }
   }

   @Override
   public void counterpartEntityUnready() {}

   @Override
   public void parsePerception(String content, ArrayList<Object> params) {}
   
}