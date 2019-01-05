// Agent spawner_agent in project helloworld_tutorial

/* Initial beliefs and rules */

/* Initial goals */

!agentsnumber(10).
/* Plans */

+!agentsnumber(N) : N > 0 <-
	.print("crea agente ", N);
	.concat("alone",N,W);
	.create_agent(W,"/src/agt/alone_agent.asl");
	!agentsnumber(N-1).

-!agentsnumber(N) : true <-
	.print("conclusa creazione agenti").

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
