// Synapsis base agent --> Agente che deve essere incluso per creare ed utilizzare Synapsis Body

/* Initial beliefs and rules */
synapsis_body_base_name("synapsis_body_").

/* Initial goals */

/* Plans */  

+synapsis_body_status(C): C = true <-
   .print("Synapsis Body pronto");
   !!startMind.
  
//Va sovrascritto per ogni agente che vuole utilizzare i Synapsis Body
+!startMind <-
   .my_name(Me);
   .print("Sovrascrivere plan +!startMind nell'agente ", Me).

+!createSynapsisBody : 
   synapsis_url(U) & 
   synapsis_body_class(C) & 
   synapsis_body_base_name(N) & 
   reconnection_attempts(V) <-
   .my_name(Me)
   .concat(N,Me,ArtifactName);
   makeArtifact(ArtifactName,C,[Me,U,V],Id);
   focus(Id).
   
-!createSynapsisBody : synapsis_body_base_name(N) <-
   .my_name(Me)
   .concat(N,Me,ArtifactName);
   .print("Creazione dell'artefatto ", N ," fallita!!").

