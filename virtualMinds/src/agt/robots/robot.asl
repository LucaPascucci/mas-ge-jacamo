/* Initial beliefs and rules */

/* Initial goals */

/* Beliefs dinamici */

+synapsis_counterpart_status(Name, C): .my_name(Me) & .substring(Me,Name) <-
   ?my_synapsis_mind_ID(MyArtID);
   if (C == true){
      synapsisLog("Controparte collegata -> Mettiamoci al lavoro!!!")[artifact_id(MyArtID)];
      !!recycle;
   } else {
      .drop_all_intentions;
      synapsisLog("Controparte non collegata")[artifact_id(MyArtID)];
   }.

+picked_up_by(C, Name) <-
   ?my_synapsis_mind_ID(MyArtID);
   if (C == true){
      synapsisLog("Attenzione! Spazzatura prelevata da -> ", Name) [artifact_id(MyArtID)];
      ?robot_type(Type);
      if (.substring(Type,Name)){
         synapsisLog("Nessun problema l'ho presa io -> ", Me) [artifact_id(MyArtID)];
      } else {
         ?found(Garbage);
         !stopFocusExternalSynapsisMind(Garbage);
         removeAllRuntimeObservableProperties [artifact_id(MyArtID)];
         .drop_all_intentions;
         stopAction [artifact_id(MyArtID)];
      }
   }.
     
+stopped <-
   .wait(500);
   !!recycle.
   
+found(Name) <-
   ?my_synapsis_mind_ID(MyArtID);
   synapsisLog("Ho visto questa entità -> ", Name)[artifact_id(MyArtID)];
   !focusExternalSynapsisMind(Name);
   synapsisLog("Vado verso l'entità vista -> ",Name)[artifact_id(MyArtID)];
   goToAction(Name)[artifact_id(MyArtID)]. // azione per andare verso l'entità (in questo caso è la spazzatura)

+arrived_to(Name) <-
   ?my_synapsis_mind_ID(MyArtID);
   synapsisLog("Sono arrivato a questa entità -> ", Name)[artifact_id(MyArtID)];
   !!recycle.
   
+picked(Name) <-
   ?my_synapsis_mind_ID(MyArtID);
   synapsisLog("Ho raccolto questa entità -> ", Name)[artifact_id(MyArtID)];
   synapsisLog("Cerco un bidone")[artifact_id(MyArtID)];
   searchAction("bin") [artifact_id(MyArtID)].

+released(Name) <-
   ?my_synapsis_mind_ID(MyArtID);
   synapsisLog("Ho rilasciato questa entità -> ", Name)[artifact_id(MyArtID)];
   synapsisLog("Riciclo la spazzatura -> ", Name)[artifact_id(MyArtID)];
   recycleMe; // operazione dell'artefatto Garbage
   removeAllRuntimeObservableProperties[artifact_id(MyArtID)];
   !stopFocusExternalSynapsisMind(Name);
   .wait(2000);
   !!recycle.

/* Plans */

+!recycle: picked(Garbage) & found(Bin) & arrived_to(Bin) & robot_type(Type) & bin_type(Type) <- 
   ?my_synapsis_mind_ID(MyArtID);
   synapsisLog("Stessa tipologia di bidone -> ", Bin)[artifact_id(MyArtID)];
   releaseAction(Garbage)[artifact_id(MyArtID)];
   !stopFocusExternalSynapsisMind(Bin).
   
+!recycle: picked(Garbage) & found(Name) & arrived_to(Name) & robot_type(Type) & bin_type(OtherType) <-
   ?my_synapsis_mind_ID(MyArtID);
   synapsisLog("Il bidone non è della mia stessa tipologia' -> ",Name)[artifact_id(MyArtID)];
   !stopFocusExternalSynapsisMind(Name);
   removeRuntimeObservableProperty("found")[artifact_id(MyArtID)];
   removeRuntimeObservableProperty("arrived_to")[artifact_id(MyArtID)];
   synapsisLog("Cerco un bidone")[artifact_id(MyArtID)];
   searchAction("bin") [artifact_id(MyArtID)].
   
+!recycle: found(Name) & arrived_to(Name) & robot_type(Type) & garbage_type(Type) <-
   ?my_synapsis_mind_ID(MyArtID);
   synapsisLog("Stessa tipologia di spazzatura -> ", Name)[artifact_id(MyArtID)];
   pickUpAction(Name)[artifact_id(MyArtID)]. // azione per prendere spazzatura

+!recycle: found(Name) & arrived_to(Name) & robot_type(Type) & garbage_type(OtherType) <-
   ?my_synapsis_mind_ID(MyArtID);
   synapsisLog("La spazzatura non è della mia stessa tipologia' -> ",Name)[artifact_id(MyArtID)];
   !stopFocusExternalSynapsisMind(Name);
   removeRuntimeObservableProperty("found")[artifact_id(MyArtID)];
   removeRuntimeObservableProperty("arrived_to")[artifact_id(MyArtID)];
   synapsisLog("Cerco della spazzatura")[artifact_id(MyArtID)];
   searchAction("garbage")[artifact_id(MyArtID)].

+!recycle <-
   ?my_synapsis_mind_ID(MyArtID);
   synapsisLog("Sono libero... cerco della spazzatura")[artifact_id(MyArtID)];
   searchAction("garbage")[artifact_id(MyArtID)]. //azione per cercare spazzatura

// inclusione dell'asl che contenente belief e plan di base per synapsis. è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsis/synapsis_base_agent.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
