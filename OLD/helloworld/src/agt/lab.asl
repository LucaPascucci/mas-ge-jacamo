// Agent lab in project helloworld

/* Initial beliefs and rules */

stop(10).
current(0).

/* Initial goals */

//!start.
//!start2(0)
!start4(0,5).
!start_fibonacci.


/* Plans */

+!start_fibonacci : true <-
	.send(lab2,achieve,start_fibonacci(0, 100)).

//print "hello world." infinitely many times
+!start : true <- 
	.print("hello world");
	!start.


//continuously print "hello world N", where N is a progressive integer starting from 0
+!start2(N) : true <-
	.print("hello world ", N);
	.wait(1000);
	!start2(N+1).


//print "hello world N" M + 1 times, where N is a progressive integer starting from 0 and M is an arbitrary positive integer
+!start3(N,M) : M > 0 <-
	.print("hello world ", N);
	.wait(1000);
	!start3(N+1,M-1).

+!start3(N,M) : M = 0 <- 
	.print("hello world ", N).
	
+!start3bis : current(N) & stop(X) & N < X <- 
	.print(N , " hello world.");
	-+current(N+1);
	.wait(1000);
	!start2bis.
	
-!start3bis : true <- .print("finish").	

//print "hello world N E" M +1 times, where N is a progressive integer starting from 0, M is an arbitrary positive integer, and E is "pari" if N is even, "dispari" otherwise
+!start4(N,M) : M > 0 <-
	!check(N);
	.wait(1000);
	!start4(N+1,M-1).
	
+!start4(N,M) : M = 0 <- 
	!check(N).

+!check(N) : N mod 2 = 0 <-
	.print("hello world ", N , " pari").
	
+!check(N) : N mod 2 = 1 <-
	.print("hello world ", N , " dispari").
	

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
