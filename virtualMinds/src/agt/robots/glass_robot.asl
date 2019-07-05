/* Beliefs per synapsis */
synapsis_url("ws://localhost:9000/").
reconnection_attempts(5).
synapsis_body_class("robots.RobotBody").

/* Initial goals */

!createSynapsisBody(["glass"]).
!createMySynapsisMockEntity("GlassRobotMock").

/* Beliefs dinamici */

+synapsis_counterpart_status(Name, C): .my_name(Me) & .substring(Me,Name) <-
   ?my_synapsis_body_ID(ArtId);
   if (C == true){
      synapsisLog("Controparte collegata -> Mettiamoci al lavoro!!!") [artifact_id(ArtId)];
      !!recycle;
   } else {
      synapsisLog("Controparte non collegata") [artifact_id(ArtId)];
   }.

+garbage_status(C, Name) <-
   ?my_synapsis_body_ID(ArtId);
   if (C == true){
      synapsisLog("Attenzione spazzatura prelevata da", Name) [artifact_id(ArtId)];
      .my_name(Me);
      if (not .substring(Me,Name)){
         .drop_all_intentions;
         stopAction [artifact_id(ArtId)]; //fermo il body
         ?found_garbage(Garbage);
         !stopFocusExternalSynapsisBody(Garbage);
         removeRuntimeObsProperty("found_garbage") [artifact_id(ArtId)];
         !!recycle;
      };
   }.

+hand_garbage(Name) <-
   !!recycle. 
   
+found_garbage(Name) <-
   ?my_synapsis_body_ID(ArtId);
   synapsisLog("Ho visto della spazzatura ->", Name) [artifact_id(ArtId)];
   !focusExternalSynapsisBody(Name);
   !!recycle.

+found_bin(Name) <-
   ?my_synapsis_body_ID(ArtId);
   synapsisLog("Ho visto un bidone della spazzatura ->", Name) [artifact_id(ArtId)];
   !focusExternalSynapsisBody(Name);
   !!recycle.
   
+arrived_to(Name) <-
   ?my_synapsis_body_ID(ArtId);
   synapsisLog("Arrivato a destinazione ->", Name) [artifact_id(ArtId)];
   !!recycle.

/* Plans */
   
+!recycle: hand_garbage(Garbage) & found_bin(Bin) & arrived_to(Bin) <- 
   ?my_synapsis_body_ID(ArtId);
   synapsisLog("Sono arrivato al bidone con la spazzatura in mano --> devo riciclare") [artifact_id(ArtId)];
   recycleMe;
   !stopFocusExternalSynapsisBody(Garbage);
   removeRuntimeObsProperty("hand_garbage") [artifact_id(ArtId)];
   removeRuntimeObsProperty("found_garbage") [artifact_id(ArtId)];
   removeRuntimeObsProperty("arrived_to") [artifact_id(ArtId)];
   !!recycle.

+!recycle: hand_garbage(Garbage) & found_bin(Bin) <-
   ?my_synapsis_body_ID(ArtId);
   synapsisLog("Ho in mano la spazzatura", Garbage, "ed ho visto il bidone", Bin) [artifact_id(ArtId)];
   ?bin_type(BinType);
   ?robot_type(RobotType);
   if (RobotType == BinType) { //Controllo tipologia bidone
      goTo(Bin) [artifact_id(ArtId)]; //giusta --> Azione goto
   } else { //Bidone trovato non corrisponde per la tipologia di spazzatura --> rimuovo belief found_bin + riattivo plan "RICICLA"
      !stopFocusExternalSynapsisBody(Bin);
      removeRuntimeObsProperty("found_bin") [artifact_id(ArtId)];
      !!recycle;
   }.

+!recycle: hand_garbage(Garbage) <-
   ?my_synapsis_body_ID(ArtId);
   synapsisLog("Ho preso la spazzatua ->", Garbage) [artifact_id(ArtId)];
   searchBin.

+!recycle: found_garbage(Garbage) & arrived_to(Garbage) <-
   ?my_synapsis_body_ID(ArtId);
   synapsisLog("Controllo la spazzatura ->", Garbage) [artifact_id(ArtId)];
   ?garbage_type(GarbageType);
   ?robot_type(RobotType);
   if (RobotType == GarbageType){ //Controllo tipologia
      pickUpGarbage(Garbage); // Azione pickup (Il GameObject spazzatura attraverso il perceive deve impostare il suo stato come occupato)
   } else { //non giusta --> unfocus + rimuovo belief found_garbage(_) e arrived_to(_) + riattivo plan "RICICLA"
      !stopFocusExternalSynapsisBody(Garbage);
      removeRuntimeObsProperty("found_garbage") [artifact_id(ArtId)];
      removeRuntimeObsProperty("arrived_to") [artifact_id(ArtId)];
      !!recycle;
   }.
   
+!recycle: found_garbage(Garbage) <-
   ?my_synapsis_body_ID(ArtID);
   synapsisLog("Vado verso la spazzatura vista in precedenza") [artifact_id(ArtID)];
   goTo(Garbage) [artifact_id(ArtID)].
       
-!recycle <-
   ?my_synapsis_body_ID(ArtID);
   synapsisLog("Sono libero... cerco della spazzatura")[artifact_id(ArtID)];
   searchGarbage. //azione per cercare spazzatura

// inclusione dell'asl che contenente belief e plan di base per synapsis. è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsisJaCaMo/synapsis_base_agent.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }