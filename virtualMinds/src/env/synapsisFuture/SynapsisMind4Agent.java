package synapsisFuture;

import java.util.ArrayList;

import synapsis.SynapsisMind;

public class SynapsisMind4Agent extends SynapsisMind {
   
   protected void init(final String name, final String url, final int reconnectionAttempts) {
      super.init(name, url, reconnectionAttempts);
      
   }

   @Override
   public void counterpartEntityReady() {}

   @Override
   public void counterpartEntityUnready() {}

   @Override
   public void parseIncomingPerception(String content, ArrayList<Object> params) {}
}
