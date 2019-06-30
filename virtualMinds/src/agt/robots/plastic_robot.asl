/* Beliefs per synapsis */
synapsis_url("ws://localhost:9000/").
reconnection_attempts(5).
synapsis_body_class("robots.RobotBody").

/* Initial goals */

!createSynapsisBody(["plastic"]).
!createMySynapsisMockEntity("PlasticRobotMock").

/* Beliefs dinamici */

+synapsis_counterpart_status(Name, C): .my_name(Me) & .substring(Me,Name) <-
   if (C == true){
      !logMessage("Controparte collegata -> Mettiamoci al lavoro!!!");
      !!recycle;
   } else {
      !logMessage("Controparte non collegata");
      //TODO fermare operazioni?
   }.

+garbage_status(C, Name) <-
   if (C == true){
      .concat("Attenzione spazzatura prelevata da ", Name, Message);
      !logMessage(Message);
      .my_name(Me);
      if (not .substring(Me,Name)){
         //.drop_all_intentions; //TODO controllare se è necessario
         stop; //fermo il body
         ?found_garbage(Garbage);
         !unfocusExternalSynapsisBody(Garbage);
         -found_garbage(_);
         !!recycle;
      };
   }.

+hand_garbage(Name) <-
   !!recycle. 
   
+found_garbage(Name) <-
   .concat("Ho visto della spazzatura -> ", Name, Message);
   !logMessage(Message);
   !focusExternalSynapsisBody(Name);
   !!recycle.

+found_bin(Name) <-
   .concat("Ho visto un bidone della spazzatura -> ", Name, Message);
   !logMessage(Message);
   !focusExternalSynapsisBody(Name);
   !!recycle.
   
+arrived_to(Name) <-
   .concat("Arrivato a destinazione ->", Name, Message);
   !logMessage(Message);
   !!recycle.

/* Plans */
   
+!recycle: hand_garbage(Garbage) & found_bin(Bin) & arrived_to(Bin) <- 
   !logMessage("Sono arrivato al bidone con la spazzatura in mano --> devo riciclare").

//FIXME continuare da questo plan
+!recycle: hand_garbage(Garbage) & found_bin(Bin) <-
   .print("Ho in mano la spazzatura ", Garbage, " ed ho visto il bidone ", Bin).
   //Controllo tipologia bidone (attraberso il nome)
      //giusta --> Azione goto (bidone)
      //non giusta --> rimuovo belief found_bin + riattivo plan "RICICLA"

+!recycle: hand_garbage(Garbage) <-
   .concat("Ho preso la spazzatua -> ", Garbage, Message);
   !logMessage(Message);
   searchBin.

+!recycle: found_garbage(Garbage) & arrived_to(Garbage) <-
   .concat("Controllo la spazzatura ", Garbage, Message);
   !logMessage(Message);
   ?garbage_type(GarbageType);
   ?robot_type(RobotType);
   if (GarbageType == RobotType){ //Controllo tipologia
      pickUpGarbage(Garbage); // Azione pickup (Il GameObject spazzatura attraverso il perceive deve impostare il suo stato come occupato)
   } else { //non giusta --> unfocus + rimuovo belief found_garbage(_) e arrived_to(_) + riattivo plan "RICICLA"
      -found_garbage(_);
      -arrived_to(_);
      !unfocusExternalSynapsisBody(Garbage);
      !!recycle;
   }.
   
+!recycle: found_garbage(Garbage) <-
   !logMessage("Vado verso la spazzatura vista in precedenza");
   goTo(Garbage).
       
-!recycle <-
   !logMessage("Sono libero... cerco della spazzatura");
   searchGarbage. //azione per cercare spazzatura
   

// inclusione dell'asl che contenente belief e plan di base per synapsis. è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsisJaCaMo/synapsis_base_agent.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
