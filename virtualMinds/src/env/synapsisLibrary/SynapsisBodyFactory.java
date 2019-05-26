// CArtAgO artifact code for project virtualMinds

package synapsisLibrary;

import cartago.*;

public class SynapsisBodyFactory extends Artifact {

   private final static String SYNAPSIS_BODY_BASE_NAME = "synapsis_";
   
   void init() {}

   @OPERATION
   void createSynapsisBody(final String agentName, final String synapsisUrl, final String synapsisEndpointPath, final int reconnectionAttempts, final String synapsisBodyClass, OpFeedbackParam<ArtifactId> res) {
     ArtifactConfig config = new ArtifactConfig(agentName,synapsisUrl,synapsisEndpointPath,reconnectionAttempts);
      try {
         res.set(this.makeArtifact(SYNAPSIS_BODY_BASE_NAME + agentName, synapsisBodyClass, config));
      } catch (OperationException e) {
         e.printStackTrace();
      }
   }
}
