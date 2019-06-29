// Synapsis base agent --> Agente che deve essere incluso per creare ed utilizzare Synapsis Body

/* Initial beliefs and rules */
synapsis_base_name("synapsis_").

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
 
//Va sovrascritto per ogni agente che vuole utilizzare i Synapsis Body
+synapsis_counterpart_status(C) <-
   !logMessage("Sovrascrivere belief --> +synapsis_counterpart_status(C)");
   if (C == true){
      !logMessage("Controparte collegata");
   } else {
      !logMessage("Controparte non collegata");
   }.

/* Plans */

+!createSynapsisBody(CustomParams):
   synapsis_base_name(BaseName) & 
   synapsis_url(Url) & 
   synapsis_body_class(Class) & 
   reconnection_attempts(Attempts) <-
   .my_name(Me);
   .concat(BaseName,Me,ArtifactName);
   makeArtifact(ArtifactName,Class,[Me,Url,Attempts,CustomParams],Id);
   focus(Id).
   
-!createSynapsisBody : synapsis_base_name(BaseName) <-
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
   
+!logMessage(Message) <- 
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: ", Message).
   
-!logMessage <-
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: Errore durante il log").
  
/*   
+!createMockEntity(ClassName, EntityName): focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <- 
   .concat("Inviata richiesta di creazione entità mock: ", EntityName, " -> classe: ", ClassName, Message);
   !logMessage(Message);
   .term2string(EntityName,EntityNameString);
   createMockEntity(ClassName, EntityNameString).
   
-!createMockEntity(ClassName, EntityName) <-
   !!createMockEntity(ClassName, EntityName).
*/

/* 
+!createMockEntities(ClassName, EntityName, NumberOfEntities): focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <- 
   .concat("Inviata richiesta di creazione di ", NumberOfEntities , " entità mock: ", EntityName, " -> classe: ", ClassName, Message);
   !logMessage(Message);
   .term2string(EntityName,EntityNameString);
   createMockEntities(ClassName, EntityNameString, NumberOfEntities).

-!createMockEntities(ClassName, EntityName, NumberOfEntities) <-
   !!createMockEntities(ClassName, EntityName, NumberOfEntities).
*/
   
/* 
+!deleteMockEntity(EntityName): focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <- 
   .concat("Inviata richiesta di eliminazione entità mock: ", EntityName, Message);
   !logMessage(Message);
   .term2string(EntityName,EntityNameString);
   deleteMockEntity(EntityNameString).
   
-!deleteMockEntity(EntityName) <-
   !!deleteMockEntity(EntityName).
*/

/* 
+!deleteMockEntities(EntityName, NumberOfEntities): focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <- 
   .concat("Inviata richiesta di creazione di ", NumberOfEntities , " entità mock: ", EntityName, Message);
   !logMessage(Message);
   .term2string(EntityName,EntityNameString);
   deleteMockEntities(EntityNameString).
   
-!deleteMockEntities(EntityName,NumberOfEntities) <-
   !!deleteMockEntity(EntityName,NumberOfEntities).   
*/
   