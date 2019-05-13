// Agent synapsis

/* Initial beliefs and rules */
synapsis_body_base_name("synapsis_").

/* Initial goals */

/* Plans */

+joined(W,_) <-
  .print("Entrato nel workspace ",W).

+focused(W,A,ArtId) <-
  .print("Focused --> Workspace: ", W, " - Artifact: ", A ," - ArtifactId: ", ArtID).

+synapsis_body_status(C) <-
   if (C = true){
      .print("SYNAPSIS: (middleware) COLLEGATO")
   } else {
      .print("SYNAPSIS: (middleware) NON COLLEGATO")
   }.

+!createSynapsisBody: 
   synapsis_url(U) & 
   synapsis_endpoint_path(P) & 
   synapsis_body_class(C) & 
   synapsis_body_base_name(N) & 
   reconnection_attempts(V) <-
   .my_name(Me)
   .concat(N,Me,ArtifactName);
   makeArtifact(ArtifactName,C,[Me,U,P,V],Id);
   focus(Id).
   
-!createSynapsisBody <-
   .print("Creazione di SynapsisBody fallita").

