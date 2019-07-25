package artifacts;

import java.util.ArrayList;

import cartago.OPERATION;
import synapsis.SynapsisMind;

public class SimpleAgentMind extends SynapsisMind {

   private int counter = 0;

   protected void init(final String name, final String url, final int reconnectionAttempts, final Object[] params) {
      super.init(name, url, reconnectionAttempts);
      this.log("Params: " + params.length);
   }

   @OPERATION
   void azionePersonalizzata() {
      this.doAction("Azione", this.counter);
      this.counter++;
   }

   @Override
   public void counterpartEntityReady() {
   }

   @Override
   public void counterpartEntityUnready() {
   }

   @Override
   public void parseIncomingPerception(String content, ArrayList<Object> params) {
   }

}
