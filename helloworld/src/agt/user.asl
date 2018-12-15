// Agent user in project helloworld

/* Initial beliefs and rules */

/* Initial goals */

//!create_and_use.
!use.

/* Plans */
+!use: true <-
	.print("utilizzo l'operazione inc() messa a disposizione dall'artefatto Counter"); 
	inc.

//NON UTILIZZATI
+!create_and_use : true <- 
	!setupArtifact(Id);
	// use
	inc;
	// second use specifying the Id
	inc [artifact_id(Id)].

//NON UTILIZZATO (perché è sufficiente creare l'artefatto nelle impostazioni del MAS)
+!setupArtifact(C): true <- 
	// internal action
	makeArtifact("c0","Counter",C).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
