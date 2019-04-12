// Agent mum in project helloworld

/* Initial beliefs and rules */

/* Initial goals */

!start_calling.

/* Plans */

+!start_calling : not busy(phone) <- 
	.send(fanboy2,tell,busy(phone));
	.print("Telefono preso!! Ora chiamo le amiche!!")
	.wait(10000);
	.print("Che bella chiaccherata");
	.send(fanboy2,untell,busy(phone)).

-!start_calling : true <-
	.print("Telefono occupato!! Speriamo si liberi presto!!").

-busy(phone) : true <- !start_calling.

+!wait_randomly <-
	.random(R);
	.wait(R * 5000).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
