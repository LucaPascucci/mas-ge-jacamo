// Agent user_bounded in project helloworld

/* Initial beliefs and rules */

/* Initial goals */

!use.

/* Plans */
+!use : true <-
	incBounded;
	for (.range(I,1,10)){
		incBounded;
	}.

-!use : true <-
	.print("plan 'use' fallito").
	
-!use [error_msg(Msg),incBounded_failed("max_value_reached",Value)] <- .print(Msg);
     .print("last value is ",Value).
     
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
