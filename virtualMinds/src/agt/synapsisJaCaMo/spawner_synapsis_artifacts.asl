// Synapsis body spawner --> Agente permette la creazione di n artefatti body

/* Initial beliefs and rules */
synapsis_base_name("synapsis_").

/* Beliefs di esempio da aggiungere nell'agente che estende per definire gli artefatti
 * 
 * synapsis_body_base_name("garbage").
 * 
 * synapsis_url("ws://localhost:9000").
 * synapsis_body_class("package.class").
 * reconnection_attempts(5).
 * 
 */

/* Goal di esempio per avviare la creazione di artefatti
 * 
 * !spawnSynapsisArtifact(3). --> crea 3 artefatti SynapsisBody
 * 
 */

/* Plans */

+!spawnSynapsisArtifact(N,Params): N > 0 <-
   !createSynapsisBody(N,Params);
   !spawnSynapsisArtifact(N-1,Params).

+!spawnSynapsisArtifact(N,Params): N = 0 <-
   !logMessage("Conclusa creazione synapsis bodies").

-!spawnSynapsisArtifact <-
   !logMessage("Errore durante la creazione di synapsis bodies").
   
+!createSynapsisBody(N,Params): 
   synapsis_url(Url) & 
   synapsis_body_class(Class) & 
   synapsis_body_base_name(BodyBaseName) & 
   synapsis_base_name(BaseName) &
   reconnection_attempts(Attempts) 
   <-
   .concat(BodyBaseName,N,SynapsisBodyName);
   .concat(BaseName,SynapsisBodyName,ArtifactName);
   makeArtifact(ArtifactName,Class,[SynapsisBodyName,Url,Attempts,Params],Id);
   .concat("Creato ", SynapsisBodyName, Message);
   !logMessage(Message).

-!createSynapsisBody(N,Params) <-
   !logMessage("Errore durante la creazione di un synapsis body").
   
+!logMessage(Message) <- 
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: ", Message).
   
-!logMessage <-
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: Errore durante il log").