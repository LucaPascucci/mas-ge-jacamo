// Agent fanboy in project helloworld

// Agent fanboy in project sa1415_agentSpeakL

/* Initial beliefs */

likes("Radiohead").
phone("Glasgow Arena","05112345").
concert("Radiohead", "22/12/2014", "Glasgow Arena"). // still triggers belief addition event
concert("Metallica", "23/12/2014", "Glasgow Arena").
busy(phone).
//~busy(phone). //NEGAZIONE DEL BELIEF (cioè non sono in grado di sapere se il telefono è occupato)

/* Initial goals */

!start.

/* Plans */

+hello[source(WHO)]
  <- .print("I receive an 'hello' from ",WHO);
     .send(WHO,tell,hello).

+!start : true <- 
	.my_name(Me);
	.print("Hello world! from ", Me).

+concert(Artist, Date, Place) 				// triggering event (belief addition)
	: likes(Artist)							// condition
	<- !book_tickets(Artist, Date, Place). // plan body

+!book_tickets(A, D, P) 					// triggering event (achievement goal addition)
	: not busy(phone) & not ~busy(phone) 	// lack of knowledge
	<- ?phone(P, N); 						// test goal (to retrieve a belief)
       !call(N);
       !choose_seats(A, D, P);
       !done.

-!book_tickets(A, D, P) : true <- 
	.print("busy phone! I'll wait...'");
	.wait(5000); //millisecondi
	-busy(phone);
	!book_tickets(A, D, P).

+!call(N) : true <- .print("calling ", N, "...").

+!choose_seats(A, D, P) : true <- .print("choosing seats for ", A, " at ", P, "...").

+!done : true <- .print("done!").

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
