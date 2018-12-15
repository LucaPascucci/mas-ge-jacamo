// Agent fanboy in project helloworld

// Agent fanboy in project sa1415_agentSpeakL

/* Initial beliefs */

likes("Radiohead").
phone("Glasgow Arena","05112345").
concert("Radiohead", "22/12/2014", "Glasgow Arena"). // still triggers belief addition event
concert("Metallica", "23/12/2014", "Glasgow Arena").

/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	.my_name(Me);
	.print("Hello world! from ", Me).

+concert(Artist, Date, Place) 				// triggering event (belief addition)
	: likes(Artist)							// condition
	<- !book_tickets(Artist, Date, Place). // plan body

+!book_tickets(A, D, P) : not busy(phone) <- 
	?phone(P, N); 						// test goal (to retrieve a belief)
	.send(mum,tell,busy(phone));
	.print("Telefono preso!! Ora provo a comprarmi i biglietti!!")
	!call(N);
	!choose_seats(A, D, P);
	!done.

-!book_tickets(A, D, P) : true <- 
	.print("busy phone! I'll wait...'");
	!wait_randomly;
	!book_tickets(A, D, P).

+!call(N) : true <- 
	.print("calling ", N, "...");
	!wait_randomly.

+!choose_seats(A, D, P) : true <- .print("choosing seats for ", A, " at ", P, "...").

+!done : true <- 
	.print("done!");
	.send(mum,untell,busy(phone)).
	
+!wait_randomly <-
	.random(R);
	.wait(R * 10000).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
