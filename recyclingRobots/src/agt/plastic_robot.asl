// Agent plastic_robot in project recyclingRobots

/* Initial beliefs and rules */
synapsis_url("ws://localhost:9000/").
synapsis_endpoint_path("service/").
reconnection_attempts(5).
synapsis_body_class("recyclingRobots.PlasticRobotBody").

/* Initial goals */

!createSynapsisBody.

/* Plans */

//INIZIO ---- BELIEF DINAMICI
+garbage(G) <- //trovata spazzatura
   .print("Ho visto della spazzatura").
   //controllare se è occupata
   //andare dalla spazzatura
   
+synapsis_body_status(C): C = true <-
  !!work.
   
//FINE ---- BELIEF DINAMICI

+!work : true <-
   .print("Inizio a lavorare");
   !!recycle.
 
+!recycle : hand(G) <-
   .print("Ho in mano la spazzatura ", G).
   //controllare tipologia spazzatura
   
-!recycle <-
   .print("Ho le mani libere... cerco della spazzatura");
   searchGarbage.
   //cercare spazzatura

// inclusione dell'asl che contenente belief e plan di base per synapsis
// è possibile collegare anche un file asl all'interno di un JAR
{ include("jar:file:/Users/luca/mas-ge-jacamo/recyclingRobots/lib/synapsis-mind.jar!/agt/synapsis.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
