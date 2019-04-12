// Agent counterobserver in project helloworld

/* Initial beliefs and rules */

/* Initial goals */

!observe.

/* Plans */

//NON UTILIZZATO (perché è sufficiente impostare il focus nelle impostazioni del MAS)
+!observe : true <- 
	?myArtifact(C,"c0"); // discover the tool
	focus(C);
	?myArtifact(C1,"c1");
	focus(C1).

+count(V) <- 
	.print("observed new value: ",V).
	
+tick [artifact_name(Id,"c0")] <- 
	.print("perceived a tick").

//NON UTILIZZATO (vedi plan +!observe)
+?myArtifact(CounterId,ID): true <- 
	.print("Cerco l'artefatto: ", CounterId);
	lookupArtifact(Id,CounterId).

//NON UTILIZZATO (vedi plan +!observe)
-?myArtifact(CounterId,ID): true <- 
	.print("Artefatto non trovato");
	.wait(10);

//NON UTILIZZATO (vedi plan +!observe)
?myArtifact(CounterId,ID).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
