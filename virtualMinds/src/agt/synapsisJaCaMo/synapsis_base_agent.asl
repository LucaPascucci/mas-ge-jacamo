// Synapsis base agent --> Agente che deve essere incluso per creare ed utilizzare Synapsis Body

/* Initial beliefs and rules */
synapsis_body_base_name("synapsis_body_").

/* Beliefs di esempio da aggiungere nell'agente che estende per definire gli artefatti
 * 
 * synapsis_url("ws://localhost:9000").
 * synapsis_body_class("package.class").
 * reconnection_attempts(5).
 * 
 */

/* Esempio di goal per avviare la creazione  
 * 
 * !createSynapsisBody.
 */

/* Plans */  

+synapsis_body_status(C): C = true <-
   !logMessage("Synapsis Body pronto");
   !!startMind.
  
//Va sovrascritto per ogni agente che vuole utilizzare i Synapsis Body
+!startMind <-
   .my_name(Me);
   !logMessage("Sovrascrivere plan +!startMind").

+!createSynapsisBody : 
   synapsis_url(Url) & 
   synapsis_body_class(Class) & 
   synapsis_body_base_name(Name) & 
   reconnection_attempts(Attempts) <-
   .my_name(Me);
   .concat(Name,Me,ArtifactName);
   makeArtifact(ArtifactName,Class,[Me,Url,Attempts],Id);
   focus(Id).
   
-!createSynapsisBody : synapsis_body_base_name(Name) <-
   .my_name(Me)
   .concat(Name,Me,ArtifactName);
   .concat("Creazione dell'artefatto ", ArtifactName, " fallita!!", Message)
   !logMessage(Message).
   
+!logMessage(Message) <- 
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: ", Message).
   
-!logMessage <-
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: Errore durante il log").