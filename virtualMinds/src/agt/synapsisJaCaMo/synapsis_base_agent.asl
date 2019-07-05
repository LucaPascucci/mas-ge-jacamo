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
   ?my_synapsis_body_ID(ArtId);
   synapsisLog("Sovrascrivere belief --> +synapsis_counterpart_status(Name,C): .my_name(Me) & .substring(Me,Name)") [artifact_id(ArtId)];
   if (C == true){
      synapsisLog("Controparte collegata") [artifact_id(ArtId)];
   } else {
      synapsisLog("Controparte non collegata") [artifact_id(ArtId)];
   }.

/* Plans */

+!createSynapsisBody(Params): synapsis_url(Url) & synapsis_body_class(Class) & reconnection_attempts(Attempts) <-
   ?synapsis_base_name(BaseName);
   .my_name(Me);
   .concat(BaseName,Me,ArtifactName);
   makeArtifact(ArtifactName,Class,[Me,Url,Attempts,Params],ArtId);
   +my_synapsis_body_ID(ArtId);
   focus(ArtId).
   
-!createSynapsisBody(Params) <-
   ?synapsis_base_name(BaseName);
   .my_name(Me);
   .concat(BaseName,Me,ArtifactName);
   .print("Creazione dell'artefatto ", ArtifactName, " fallita!!", Message).
   
+!createSynapsisBody: synapsis_url(Url) & synapsis_body_class(Class) & reconnection_attempts(Attempts) <-
   ?synapsis_base_name(BaseName);
   .my_name(Me);
   .concat(BaseName,Me,ArtifactName);
   makeArtifact(ArtifactName,Class,[Me,Url,Attempts],ArtId);
   +my_synapsis_body_ID(ArtId);
   focus(ArtId).
   
-!createSynapsisBody <-
   ?synapsis_base_name(BaseName);
   .my_name(Me);
   .concat(BaseName,Me,ArtifactName);
   .print("Creazione dell'artefatto ", ArtifactName, " fallita!!", Message).
   
+!createMySynapsisMockEntity(MockClassName): focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <-
   ?my_synapsis_body_ID(ArtId);
   .my_name(Me);
   createMyMockEntity(MockClassName) [artifact_id(ArtId)];
   synapsisLog("Inviata richiesta di creazione entità mock:", Me , "-> classe:", MockClassName) [artifact_id(ArtId)].
   
-!createMySynapsisMockEntity(MockClassName) <-
   !!createMySynapsisMockEntity(MockClassName).

+!deleteMySynapsisMockEntity: focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <-
   ?my_synapsis_body_ID(ArtId);
   deleteMyMockEntity [artifact_id(ArtId)];
   .my_name(Me);
   synapsisLog("Inviata richiesta di eliminazione entità mock ->", Me) [artifact_id(ArtId)].

-!deleteMySynapsisMockEntity <-
   !!deleteMySynapsisMockEntity.
   
+!focusExternalSynapsisBody(EntityName) <-
   ?synapsis_base_name(BaseName);
   .concat(BaseName,EntityName,ArtifactName);
   lookupArtifact(ArtifactName,Id);
   focus(Id).
    
-!focusExternalSynapsisBody(EntityName) <-
   ?my_synapsis_body_ID(ArtId);
   synapsisLog("Errore durante il focus del SynapsisBody -> ", EntityName) [artifact_id(ArtId)].

+!stopFocusExternalSynapsisBody(EntityName) <-
   ?synapsis_base_name(BaseName);
   .concat(BaseName,EntityName,ArtifactName);
   lookupArtifact(ArtifactName,Id);
   stopFocus(Id). //XXX lo stopFocus non rimuove correttamente il belief --> focused(_,ArtifactName,_)
    
-!stopFocusExternalSynapsisBody(EntityName) <-
   ?my_synapsis_body_ID(ArtId);
   synapsisLog("Errore durante lo stop focus del SynapsisBody ->", EntityName) [artifact_id(ArtId)].