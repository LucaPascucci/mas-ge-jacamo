// Agent agent_clock in project helloworld_tutorial

/* Initial beliefs and rules */

/* Initial goals */

!test_clock.

/* Plans */


+!test_clock <- 
	makeArtifact("myClock","c4jexamples.Clock",[],Id);
	focus(Id);
	+n_ticks(0);
	start;
	.print("clock started.").
	
@plan1
+tick: n_ticks(10) <- 
	stop;
	.print("clock stopped.").
	
@plan2 [atomic]
+tick: n_ticks(N) <- 
	-+n_ticks(N+1); //Aggiornamento Belief
	.print("tick perceived!").

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
