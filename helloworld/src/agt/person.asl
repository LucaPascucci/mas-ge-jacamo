// Agent person in project helloworld

/* Initial beliefs and rules */


/* Initial goals */

!start.

/* Plans */

+!start : true <- 
	clock.now(H);
	+time_to_leave(H);
	.print("hello world. ", H);
	.broadcast(tell,hello);
	!g1.
	
+hello[source(WHO)] <- 
	-hello;
	.print("I receive an 'hello' from ",WHO);
	.send(WHO,tell,hello).

+rain : true <- 
	.print("aggiunto belief rain");
	!checkrain.

+!checkrain : rain & time_to_leave(T) & clock.now(H) & H >= T <-
	//!g1;			// new sub-goal
	//!!g2;			// new goal
	//?b(X);		// new test goal
	+b1(T-H);		// add mental note
	-b1(T-H);		// remove mental note
	-+b3(T-H);		// update mental note
	jia.get(X);		// internal action
	X > 10;			// controllo per proseguire il piano
	.print("check rain completato"). 
	//close(door).	// external action

-!checkrain : true <- 
	.print("check rain fallito");
	!checkrain.

//esempio di richiesta plan ad altri agenti
-!g1 [error(no_relevant)] : teacher(T) <- 
	.send(T, askHow, { +!g1 }, Plans);
	.add_plan(Plans);
	!g1.

-!g1 [error(no_relevant)] : not teacher(T) <- 
	!g1.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
