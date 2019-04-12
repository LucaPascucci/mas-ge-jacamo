// Agent math_agent in project helloworld

/* Initial beliefs and rules */
fib(0, 1).
fib(1, 1).

/* Initial goals */

//!compute_fibonacci_until(0, 100).
!print_stuff(0,100).

/* Plans */

+!start_fibonacci(N,M) [source(Who)] : true <-
	.print("Start fibonacci received form ", Who)
	!compute_fibonacci_until(N, M).

+!compute_fibonacci_until(N,M) : N = M <- 
	!compute_fibonacci(N);
	.print("Done").

+!compute_fibonacci_until(N,M) : N < M <- 
	!compute_fibonacci(N);
	!compute_fibonacci_until(N+1,M).
	
+!compute_fibonacci(N) : true <-
	?fib(N,Y); //cerca nella belief base (BB) se esiste il fib(N) Y è il valore di fibonacci
	.wait(100);
	.print("fib(", N,") = ", Y).

/*
 * piano per i numeri di fibonacci da calcolare
 * per fib(2,Y) utilizza i belief -> fib(1,1) e fib(0,1) aggiungendo alla belief base (BB) il belief fib(2,2)
 */
+?fib(X,Y) : fib(X - 1, Y1) & fib(X - 2, Y2) & Y = Y1 + Y2 <-
	+fib(X,Y). //aggiunge il belief fib(X,Y) alla belief base (BB) dell'agente
	
	
+!print_stuff(N,M) <-
	.print("stuff");
	.wait(100);
	if (N < M) {
		!print_stuff(N+1,M);
	}.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
