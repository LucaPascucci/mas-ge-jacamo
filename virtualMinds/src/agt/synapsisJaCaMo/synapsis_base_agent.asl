// Synapsis base agent --> Agente che deve essere incluso per creare ed utilizzare Synapsis Body

/* Initial beliefs and rules */
synapsis_base_name("synapsis_").

/* Beliefs di esempio da aggiungere nell'agente che estende per definire gli artefatti
 * 
 * synapsis_url("ws://localhost:9000").
 * synapsis_body_class("package.class").
 * reconnection_attempts(5).
 */

/* Esempio di goal per avviare la creazione  
 * 
 * !createSynapsisBody. --> creazione dell'artefatto che estende SynapsisBody
 * oppure
 * !createSynapsisBody(["testo",1,false]). --> creazione dell'artefatto che estende SynapsisBody con parametri custom
 */
 
//Va sovrascritto per ogni agente che vuole utilizzare il proprio SynapsisBody
+synapsis_counterpart_status(Name,C): .my_name(Me) & .substring(Me,Name) <-
   !logMessage("Sovrascrivere belief --> +synapsis_counterpart_status(Name,C): .my_name(Me) & .substring(Me,Name)");
   if (C == true){
      !logMessage("Controparte collegata");
   } else {
      !logMessage("Controparte non collegata");
   }.

/* Plans */

+!createSynapsisBody(Params): synapsis_url(Url) & synapsis_body_class(Class) & reconnection_attempts(Attempts) <-
   ?synapsis_base_name(BaseName);
   .my_name(Me);
   .concat(BaseName,Me,ArtifactName);
   makeArtifact(ArtifactName,Class,[Me,Url,Attempts,Params],Id);
   focus(Id).
   
-!createSynapsisBody(Params) <-
   ?synapsis_base_name(BaseName);
   .my_name(Me);
   .concat(BaseName,Me,ArtifactName);
   .concat("Creazione dell'artefatto ", ArtifactName, " fallita!!", Message);
   !logMessage(Message).
   
+!createSynapsisBody: synapsis_url(Url) & synapsis_body_class(Class) & reconnection_attempts(Attempts) <-
   ?synapsis_base_name(BaseName);
   .my_name(Me);
   .concat(BaseName,Me,ArtifactName);
   makeArtifact(ArtifactName,Class,[Me,Url,Attempts],Id);
   focus(Id).
   
-!createSynapsisBody <-
   ?synapsis_base_name(BaseName);
   .my_name(Me);
   .concat(BaseName,Me,ArtifactName);
   .concat("Creazione dell'artefatto ", ArtifactName, " fallita!!", Message);
   !logMessage(Message).
   
+!createMySynapsisMockEntity(MockClassName): focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <-
   .my_name(Me);
   createMyMockEntity(MockClassName);
   .concat("Inviata richiesta di creazione entità mock: ", Me , " -> classe: ", MockClassName, Message);
   !logMessage(Message).
   
-!createMySynapsisMockEntity(MockClassName) <-
   !!createMySynapsisMockEntity(MockClassName).

+!deleteMySynapsisMockEntity: focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <-
   deleteMyMockEntity;
   .my_name(Me);
   .concat("Inviata richiesta di eliminazione entità mock: ", Me, Message);
   !logMessage(Message).

-!deleteMySynapsisMockEntity <-
   !!deleteMySynapsisMockEntity.
   
+!focusExternalSynapsisBody(EntityName) <-
   ?synapsis_base_name(BaseName);
   .concat(BaseName,EntityName,ArtifactName);
   lookupArtifact(ArtifactName,Id);
   focus(Id).
    
-!focusExternalSynapsisBody(EntityName) <-
   .concat("Errore durante il focus del SynapsisBody -> ", EntityName, Message);
   !logMessage(Message).

+!unfocusExternalSynapsisBody(EntityName) <-
   ?synapsis_base_name(BaseName);
   .concat(BaseName,EntityName,ArtifactName);
   lookupArtifact(ArtifactName,Id);
   unfocus(Id).
    
-!unfocusExternalSynapsisBody(EntityName) <-
   .concat("Errore durante l'unfocus del SynapsisBody -> ", EntityName, Message);
   !logMessage(Message).   

   
+!logMessage(Message) <- 
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: ", Message).
   
-!logMessage(Message) <-
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: Errore durante il log").



   