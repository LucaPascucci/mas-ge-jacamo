/* Initial beliefs and rules */

synapsis_url("ws://localhost:9000/").
synapsis_endpoint_path("service/").
reconnection_attempts(5).
synapsis_body_class("artifacts.SimpleAgentBody").


/* Initial goals */


!createSynapsisBody.
!personalSend.

/* Plans */

//+focused(W,A,ArtId) <-
  // .print("Focused --> Workspace: ", W, " - Artifact: ", A ," - ArtifactId: ", ArtID).
   //!createBody.

//INIZIO ---- BELIEF DINAMICI
+here(X,Y,Z) <-
   .print("Il mio corpo si trova qui: ", X, ", ", Y, ", ", Z).

+onMouseExit(P,L) : .list(L) <-
   .print("Il mouse è uscito ", P);
   .length(L,X);
   .print("Lughezza della lista: ", X).
 
+onMouseExit(P,L) <-
   .print(L).
//FINE ---- BELIEF DINAMICI

+!createBody:
   synapsis_url(U) & 
   synapsis_endpoint_path(P) & 
   synapsis_body_class(C) & 
   synapsis_body_base_name(N) & 
   reconnection_attempts(V) <-
   .my_name(Me);
   createSynapsisBody(Me,U,E,V,C,Id);
   focus(Id).
   
+!personalSend: synapsis_body_status(C1) & C1 = true <-
   azionePersonalizzata;
   .wait(3000);
   !!personalSend.

-!personalSend <-
   .wait(3000);
   !!personalSend.

// inclusione dell'asl che contenente belief e plan di base per synapsis
// è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsis.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }