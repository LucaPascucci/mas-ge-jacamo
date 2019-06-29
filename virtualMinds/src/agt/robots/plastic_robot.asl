/* Beliefs per synapsis */
synapsis_url("ws://localhost:9000/").
reconnection_attempts(5).
synapsis_body_class("robots.PlasticRobotBody").

/* Initial goals */

!createSynapsisBody([]).
!createMySynapsisMockEntity("PlasticRobotMock").

/* Beliefs dinamici */

+synapsis_counterpart_status(C) <-
   if (C == true){
      !logMessage("Controparte collegata -> Inizio a Lavorare");
      !!recycle;
   } else {
      !logMessage("Controparte non collegata");
   }.

+hand_garbage(Name) <-
   !!recycle. 
   
+found_garbage(Name) <- //trovata spazzatura --> Name (gameobject)
   //focus sull'artefatto
   //vado verso di lei
   focus(Name);
   !!recycle. 

+found_bin(Name) <-
   !!recycle.
   
+arrived_to(Name) <-
   !!recycle.

/* Plans */
   
+!recycle: hand_garbage(Garbage) & found_bin(Bin) & arrived_to(Bin) <- 
   .print("Sono arrivato al bidone con la spazzatura in mano --> devo riciclare").

+!recycle: hand_garbage(Garbage) & found_bin(Bin) <-
   .print("Ho in mano la spazzatura ", Garbage, " ed ho visto il bidone ", Bin).
   //Controllo tipologia bidone (attraberso il nome)
      //giusta --> Azione goto (bidone)
      //non giusta --> rimuovo belief found_bin + riattivo plan "RICICLA"

+!recycle: hand_garbage(Garbage) <-
   .print("Ho in mano la spazzatura ", Garbage).
   //azion cerca bidone

+!recycle: found_garbage(Garbage) & arrived_to(Garbage) <-
   .print("Sono arrivato alla spazzatura ", Garbage, " ora la controllo.").
   //Controllo tipologia
      //giusta --> controllo se è libera
         //libera --> la occupo(metodo artefatto garbage) + Azione pickup
         //non libera --> unfocus sull'artefatto spazzatura rimuovo belief found_garbage + riattivo plan "RICICLA"
      //non giusta --> unfocus + rimuovo belief found_garbage + riattivo plan "RICICLA"
   
+!recycle: found_garbage(Garbage) <-
   .print("Ho visto della spazzatura: ", Garbage);
   goTo(Garbage).
   
       
-!recycle <-
   !logMessage("Sono libero... cerco della spazzatura");
   searchGarbage. //azione per cercare spazzatura
   


// inclusione dell'asl che contenente belief e plan di base per synapsis. è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsisJaCaMo/synapsis_base_agent.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
