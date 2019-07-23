// Synapsis body spawner --> Agente permette la creazione di n artefatti body

/* Initial beliefs and rules */
synapsis_base_name("synapsis_").

/* Beliefs di esempio da aggiungere nell'agente che estende per definire gli artefatti
 * 
 * synapsis_body_base_name("test").
 * 
 * synapsis_url("ws://localhost:9000").
 * synapsis_body_class("package.JavaClass").
 * reconnection_attempts(5).
 */

/* Goal di esempio per avviare la creazione di artefatti
 * 
 * !spawnSynapsisArtifact(3). --> crea 3 artefatti SynapsisBody senza parametri aggiuntivi
 * 
 * oppure
 * 
 * !spawnSynapsisArtifact(3,["testo",1,false]) --> crea 3 artefatti SynapsisBody con parametri aggiuntivi personalizzabili
 */

/* Plans */

+!spawnSynapsisArtifact(N,Params): N >= 0 <-
   if (N = 0){
      !logMessage("Conclusa creazione SynapsisBodies con parametri custom");
   } else {
      !createSynapsisBody(N,Params);
      !spawnSynapsisArtifact(N-1,Params);
   }.
   
-!spawnSynapsisArtifact(N,Params) <-
   !logMessage("Errore durante la creazione di SynapsisBodies con parametri custom").
 
+!spawnSynapsisArtifact(N): N >= 0 <-
   if (N = 0){
      !logMessage("Conclusa creazione SynapsisBodies");
   } else {
      !createSynapsisBody(N);
      !spawnSynapsisArtifact(N-1);
   }.

-!spawnSynapsisArtifact(N) <-
   !logMessage("Errore durante la creazione di SynapsisBodies").
   
+!createSynapsisBody(N,Params): synapsis_url(Url) & synapsis_body_class(Class) & synapsis_body_base_name(BodyBaseName) & reconnection_attempts(Attempts) <-
   ?synapsis_base_name(BaseName);
   .concat(BodyBaseName,N,SynapsisBodyName);
   .concat(BaseName,SynapsisBodyName,ArtifactName);
   makeArtifact(ArtifactName,Class,[SynapsisBodyName,Url,Attempts,Params],Id);
   .concat("Creato ", SynapsisBodyName, Message);
   !logMessage(Message).
   
-!createSynapsisBody(N,Params) <-
   .concat("Errore durante la creazione dell'artefatto SynapsisBody-", N, " con parametri custom", Message);
   !logMessage(Message).
   
+!createSynapsisBody(N): synapsis_url(Url) & synapsis_body_class(Class) & synapsis_body_base_name(BodyBaseName) & reconnection_attempts(Attempts) <-
   ?synapsis_base_name(BaseName);
   .concat(BodyBaseName,N,SynapsisBodyName);
   .concat(BaseName,SynapsisBodyName,ArtifactName);
   makeArtifact(ArtifactName,Class,[SynapsisBodyName,Url,Attempts],Id);
   .concat("Creato ", SynapsisBodyName, Message);
   !logMessage(Message).

-!createSynapsisBody(N) <-
   .concat("Errore durante la creazione dell'artefatto SynapsisBody-", N, Message);
   !logMessage(Message).
   
+!logMessage(Message) <- 
   .time(H,M,S);
   .my_name(Me);
   .print(H, ":", M, ":", S," - [Synapsis - ", Me, "]: ", Message).
   
-!logMessage <-
   .time(H,M,S);
   .my_name(Me);
   .print(H, ":", M, ":", S," - [Synapsis - ", Me, "]: Errore durante il log").