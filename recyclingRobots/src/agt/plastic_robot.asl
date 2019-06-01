/* Beliefs per synapsis */
synapsis_url("ws://localhost:9000/").
reconnection_attempts(5).
synapsis_body_class("artifacts.PlasticRobotBody").

/* Goal iniziale per synapsis */
!createSynapsisBody.

/* Plans */

//FOCUS SU ARTEFATTO GARBAGE
   //1)avviare plan recycle

+hand_garbage(Name) <-
   //Attivo plan
   !!recycle. 

//INIZIO ---- BELIEF DINAMICI
+found_garbage(Name) <- //trovata spazzatura --> Name (gameobject)
   .print("Devo fare focus sull'artefatto").
   //focus sull'artefatto 

+found_bin(Name) <-
   !!recycle.
   
+arrived_to(Name) <-
   !!recycle.

//FINE ---- BELIEF DINAMICI

/* Plan per synapsis */
+!startMind : true <-
   .print("Inizio a lavorare");
   !!recycle.
   
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
   .print("Sono arrivato alla spazzatura ", Garbage, " ora la prendo.").
   //Azione pickup
   
+!recycle: found_garbage(Name) <-
   .print("Ho visto della spazzatura: ", Name);
   .print("Controllo spazzatura trovata").
   //Controllo tipologia
      //giusta --> controllo se è libera
         //libera --> la occupo(metodo artefatto garbage) + Azione goto
         //non libera --> unfocus sull'artefatto spazzatura rimuovo belief found_garbage + riattivo plan "RICICLA"
      //non giusta --> unfocus + rimuovo belief found_garbage + riattivo plan "RICICLA"
       
-!recycle <-
   .print("Sono libero... cerco della spazzatura");
   searchGarbage. //azione per cercare spazzatura

       

// inclusione dell'asl che contenente belief e plan di base per synapsis. è possibile collegare anche un file asl all'interno di un JAR
{ include("jar:file:/Users/luca/mas-ge-jacamo/recyclingRobots/lib/SynapsisJaCaMo.jar!/agt/synapsisJaCaMo/synapsis_base_agent.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
