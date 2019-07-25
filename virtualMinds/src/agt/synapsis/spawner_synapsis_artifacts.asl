// Synapsis body spawner --> Agente permette la creazione di n artefatti body

/* Initial beliefs and rules */
synapsis_base_name("synapsis_").

/* Beliefs di esempio da aggiungere nell'agente che estende per definire gli artefatti
 * 
 * synapsis_mind_base_name("test").
 * 
 * synapsis_url("ws://localhost:9000").
 * synapsis_mind_class("package.JavaClass").
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
      !logMessage("Conclusa creazione SynapsisArtifacts con parametri custom");
   } else {
      !createSynapsisMind(N,Params);
      !spawnSynapsisArtifact(N-1,Params);
   }.
   
-!spawnSynapsisArtifact(N,Params) <-
   !logMessage("Errore durante la creazione di SynapsisArtifacts con parametri custom").
 
+!spawnSynapsisArtifact(N): N >= 0 <-
   if (N = 0){
      !logMessage("Conclusa creazione SynapsisBodies");
   } else {
      !createSynapsisMind(N);
      !spawnSynapsisArtifact(N-1);
   }.

-!spawnSynapsisArtifact(N) <-
   !logMessage("Errore durante la creazione di SynapsisArtifacts").
   
+!createSynapsisMind(N,Params): synapsis_url(Url) & synapsis_mind_class(Class) & synapsis_mind_base_name(MindBaseName) & reconnection_attempts(Attempts) <-
   ?synapsis_base_name(BaseName);
   .concat(MindBaseName,N,SynapsisMindName);
   .concat(BaseName,SynapsisMindName,ArtifactName);
   makeArtifact(ArtifactName,Class,[SynapsisMindName,Url,Attempts,Params],Id);
   .concat("Creato ", SynapsisMindName, Message);
   !logMessage(Message).
   
-!createSynapsisMind(N,Params) <-
   .concat("Errore durante la creazione dell'artefatto SynapsisArtifacts-", N, " con parametri custom", Message);
   !logMessage(Message).
   
+!createSynapsisMind(N): synapsis_url(Url) & synapsis_mind_class(Class) & synapsis_mind_base_name(MindBaseName) & reconnection_attempts(Attempts) <-
   ?synapsis_base_name(BaseName);
   .concat(MindBaseName,N,SynapsisMindName);
   .concat(BaseName,SynapsisMindName,ArtifactName);
   makeArtifact(ArtifactName,Class,[SynapsisMindName,Url,Attempts],Id);
   .concat("Creato ", SynapsisMindName, Message);
   !logMessage(Message).

-!createSynapsisMind(N) <-
   .concat("Errore durante la creazione dell'artefatto SynapsisArtifacts-", N, Message);
   !logMessage(Message).
   
+!logMessage(Message) <- 
   .time(H,M,S);
   .my_name(Me);
   .print(H, ":", M, ":", S," - [Synapsis - ", Me, "]: ", Message).
   
-!logMessage <-
   .time(H,M,S);
   .my_name(Me);
   .print(H, ":", M, ":", S," - [Synapsis - ", Me, "]: Errore durante il log").