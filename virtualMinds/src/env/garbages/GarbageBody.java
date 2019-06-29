// CArtAgO artifact code for project virtualMinds

package garbages;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Objects;

import synapsisJaCaMo.SynapsisBody;

public class GarbageBody extends SynapsisBody {
   
   private static final String GARBAGE_STATUS = "garbage_status";
   private static final String GARBAGE_TYPE = "garbage_type";

   protected void init(final String name, final String url, final int reconnectionAttempts, Objects[] params) {
      super.init(name, url, reconnectionAttempts);
      this.createMyMockEntity("GarbageMock");
      this.defineObsProperty(GARBAGE_STATUS, false, "");
      this.defineObsProperty(GARBAGE_TYPE,params[1]);
      
      this.doAction(GARBAGE_TYPE, new ArrayList<>(Arrays.asList(params[1])));
   }
   
}