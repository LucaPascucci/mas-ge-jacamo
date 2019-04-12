// Agent sample_agent in project helloworld

/* Initial beliefs and rules */

red(box1) [source(percept)]. // creato automaticamente durante la fase di percezione
friend(mark,alice) [source(mark)].
lier(alice) [source(self), source(mark)].
~lier(mark)[source(self)].
numerodispari.
numerodispari(31).

/* Initial goals */

!start.	//achievement goal
!print_fact(5).

/* Plans */

+red(X) : true <- 
	jia.get(Y);		// internal action
	Y > 10;			// controllo per proseguire il piano
	.print("OK"). 	//STANDARD internal action

//Internal actions and backtracking	
+numerodispari : math.odd(X) & X > 10 <- .print("numero dispari > 10: ", X).
+numerodispari(X) : math.odd(X) <- .print(X, " è un numero dispari").

+hello[source(WHO)] <- 
	.print("I received a 'hello' from ", WHO);
	.send(WHO,tell,hello).

+!start : true <-
	.my_name(Me); 
	.print("hello world from ", Me);
	.send(bob,tell,rain); //crea un belief su bob
	.send(bob,tell,teacher(Me)).
	
+!print_fact(N) : true <- 
	!fact(N,F);
	.print("Il fattoriale di ", N, " è ", F).

+!fact(N,1) : N == 0. //caso base

+!fact(N,F) : N > 0 <- 	//caso con N > 0
	!fact(N-1,F1);		//prima calcolo il fattoriale del numero precedente (fino ad arrivare al caso base) e poi moltiplico quel valore per il fattoriale di N
	F = F1 * N.

+!g1 : true <- 
	.my_name(Me);
	.print("Piano g1 di simple_agent eseguito da ", Me).
	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
