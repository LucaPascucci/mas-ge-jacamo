/* Initial beliefs and rules */

/* Initial goals */

!start2.

/* Plans */

+!start : message(X) <- 
	?focused(france, gui, ArtId); //controlla la belief base
	printMsg(X)[artifact_id(ArtId)]. //Utilizza il printMsg dell'artefatto specificato in parentesi


+!start : true <- .print("hello world.").

+!start2 : message(X)
   <- for ( focused(_,gui,ArtId) ) { //per ogni artefatto osservato dall'agente
          printMsg(X)[artifact_id(ArtId)] //Utilizza il printMsg dell'artefatto specificato in parentesi
      }.

//belief che viene aggiunto in automatico dalla configurazione del MAS
+focused(W,A,ArtId): true <-
	.print("Workspace:", W, " - Artifact:", A ," - ArifactId:", ArtID).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
