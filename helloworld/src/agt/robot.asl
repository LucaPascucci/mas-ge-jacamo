// Agent robot in project helloworld

/* Initial beliefs and rules */

/* Initial goals */

/* Plans */

+see(gold) <- !goto(gold).

+!goto(gold) :see(gold) <- // long term goal 
	!select direction(A);
	go(A);
	!goto(gold).
	
+battery(low) <- // reactivity
	!charge.

// goal meta-events
^!charge[state(started)] <- .suspend(goto(gold)).

^!charge[state(finished)] <- .resume(goto(gold)).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
