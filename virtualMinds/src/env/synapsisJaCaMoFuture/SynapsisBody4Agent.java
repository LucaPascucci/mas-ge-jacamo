package synapsisJaCaMoFuture;

import java.util.ArrayList;

import synapsisJaCaMo.SynapsisBody;

public class SynapsisBody4Agent extends SynapsisBody {
   
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
