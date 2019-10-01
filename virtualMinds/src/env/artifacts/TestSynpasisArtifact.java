package artifacts;

import java.util.ArrayList;

import cartago.OPERATION;
import synapsis.SynapsisMind;

public class TestSynpasisArtifact extends SynapsisMind {

   private int counter = 0;

   protected void init(final String name, final String url, final int reconnectionAttempts, final Object[] params) {
      super.init(name, url, reconnectionAttempts);
   }

   /**
    * Esempio di operazione custo
    */
   @OPERATION
   void azionePersonalizzata() {
      this.doAction("Azione", this.counter);
      this.counter++;
   }

   /**
    * Metodo invocato al collegamento con l'entità corpo
    */
   @Override
   public void counterpartEntityReady() {}

   /**
    * Metodo invocato alla disconnessione con l'entità corpo
    */
   @Override
   public void counterpartEntityUnready() {}

   /**
    * Metodo invocato per ogni messaggio (percezione) ricevuto
    */
   @Override
   public void parseIncomingPerception(String sender, String perception, ArrayList<Object> params) {}

}
