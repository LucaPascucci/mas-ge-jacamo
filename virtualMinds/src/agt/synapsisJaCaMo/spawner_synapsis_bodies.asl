// Synapsis body spawner --> Agente permette la creazione di n artefatti body

/* Initial beliefs and rules */
synapsis_body_base_name("synapsis_body_").

/* Beliefs di esempio da aggiungere nell'agente che estende per definire gli artefatti
 * 
 * synapsis_artifact_base_name("garbage").
 * 
 * synapsis_url("ws://localhost:9000").
 * synapsis_body_class("package.class").
 * reconnection_attempts(5).
 * 
 */

/* Goal di esempio per avviare la creazione di artefatti
 * 
 * !spawnSynapsisBody(3). --> crea 3 SynapsisBody
 * 
 */

/* Plans */

+!spawnSynapsisBody(N): N > 0 <-
   !!createSynapsisBody(N);
   !spawnSynapsisBody(N-1).

+!createSynapsisBody(N): 
   synapsis_url(Url) & 
   synapsis_body_class(Class) & 
   synapsis_body_base_name(Default) & 
   synapsis_artifact_base_name(Name) &
   reconnection_attempts(Attempts) <-
   .concat(Name,N,SynapsisBodyName);
   .concat(Default,SynapsisBodyName,ArtifactName);
   makeArtifact(ArtifactName,Class,[SynapsisBodyName,Url,Attempts],Id);
   .concat("Creato ", SynapsisBodyName, Message);
   !logMessage(Message).

+!spawnSynapsisBody(0) <-
   !logMessage("Conclusa creazione synapsis bodies").

-!spawnSynapsisBody(N) <-
   !logMessage("Errore durante la creazione di synapsis bodies").
   
+!logMessage(Message) <- 
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: ", Message).
   
-!logMessage <-
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: Errore durante il log").