/* Beliefs per synapsis */
synapsis_url("ws://localhost:9000/").
reconnection_attempts(5).
synapsis_body_class("robots.RobotBody").

/* Initial goals */

!createSynapsisBody(["plastic"]).
!createMySynapsisMockEntity("PlasticRobotMock").

/* Beliefs dinamici */

+synapsis_counterpart_status(Name, C): .my_name(Me) & .substring(Me,Name) <-
   ?my_synapsis_body_ID(ArtId);
   if (C == true){
      synapsisLog("Controparte collegata -> Mettiamoci al lavoro!!!")[artifact_id(ArtId)];
      !!recycle;
   } else {
      synapsisLog("Controparte non collegata")[artifact_id(ArtId)];
   }.

//TODO prelevare ArtId di questo belief e se necessario effettuare "stopfocus..."
/*
+garbage_status(C, Name) <-
   ?my_synapsis_body_ID(ArtId);
   if (C == true){
      synapsisLog("Attenzione! Spazzatura prelevata da -> ", Name) [artifact_id(ArtId)];
      .my_name(Me);
      if (not .substring(Me,Name)){ //TODO questo controllo non va bene 
         .drop_all_intentions; //TODO controllare se è necessario
         stopAction [artifact_id(ArtId)]; //fermo il body
         removeRuntimeObsProperty("found_garbage") [artifact_id(ArtId)];
         !!recycle;
      };
   }.
*/
   
   
+found(Name) <-
   ?my_synapsis_body_ID(MyArtID);
   synapsisLog("Ho visto questa entità -> ", Name)[artifact_id(MyArtID)];
   !!recycle.

+arrived_to(Name) <-
   ?my_synapsis_body_ID(MyArtID);
   synapsisLog("Sono arrivato a questa entità -> ", Name)[artifact_id(MyArtID)];
   !!recycle.
   
+picked(Name) <-
   ?my_synapsis_body_ID(MyArtID);
   synapsisLog("Ho raccolto questa entità -> ", Name)[artifact_id(MyArtID)];
   !!recycle.

+released(Name) <-
   ?my_synapsis_body_ID(MyArtID);
   synapsisLog("Ho rilasciato questa entità -> ", Name)[artifact_id(MyArtID)];
   removeAllRuntimeObsProperties[artifact_id(ArtId)].

/* Plans */

+!recycle: picked(Garbage) & found(Bin) & arrived_to(Bin) & robot_type(Type) & bin_type(Type) <- //Controllo tipologia bidone
   ?my_synapsis_body_ID(MyArtID);
   synapsisLog("Stessa tipologia di bidone -> ", Bin)[artifact_id(MyArtID)]; //FIXME sull'artefatto bin?? non ha senso
   releaseAction(Garbage)[artifact_id(MyArtID)]; //FIXME sull'artefatto bin?? non ha senso
   synapsisLog("Riciclo la spazzatura -> ", Garbage)[artifact_id(MyArtID)]; //FIXME sull'artefatto bin?? non ha senso
   recycleMe; // operazione dell'artefatto Garbage
   !stopFocusExternalSynapsisBody(Bin);
   !stopFocusExternalSynapsisBody(Garbage).
   
+!recycle: found(Name) & arrived_to(Name) & picked(Name) <-
   ?my_synapsis_body_ID(MyArtID);
   synapsisLog("Cerco il bidone")[artifact_id(MyArtID)];
   searchAction("bin") [artifact_id(MyArtID)].
   
+!recycle: found(Name) & arrived_to(Name) & robot_type(Type) & garbage_type(Type) <- //Controllo tipologia spazzatura
   ?my_synapsis_body_ID(MyArtID);
   synapsisLog("Stessa tipologia di spazzatura -> ", Name)[artifact_id(MyArtID)]; //FIXME sull'artefatto bin?? non ha senso
   pickUpAction(Name)[artifact_id(MyArtID)]. // azione per prendere spazzatura
   
+!recycle: found(Name) <-
   ?my_synapsis_body_ID(MyArtID);
   synapsisLog("Vado verso l'entità vista -> ",Name)[artifact_id(MyArtID)];
   !focusExternalSynapsisBody(Name);
   goToAction(Name)[artifact_id(MyArtID)]. // azione per andare verso l'entità (in questo caso è la spazzatura)
   
-!recycle: found(Name) & arrived_to(Name) <-
   ?my_synapsis_body_ID(MyArtID);
   synapsisLog("L'entità non è della mia stessa tipologia' -> ",Name)[artifact_id(MyArtID)];
   !stopFocusExternalSynapsisBody(Name);
   removeRuntimeObsProperty("found")[artifact_id(MyArtID)];
   removeRuntimeObsProperty("arrived_to")[artifact_id(MyArtID)];
   !!recycle.
       
-!recycle <-
   ?my_synapsis_body_ID(MyArtID);
   synapsisLog("Sono libero... cerco della spazzatura")[artifact_id(MyArtID)];
   searchAction("garbage")[artifact_id(MyArtID)]. //azione per cercare spazzatura
 

// inclusione dell'asl che contenente belief e plan di base per synapsis. è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsisJaCaMo/synapsis_base_agent.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
