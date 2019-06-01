/* Initial beliefs and rules */

synapsis_url("ws://localhost:9000/").
reconnection_attempts(5).
synapsis_body_class("artifacts.SimpleAgentBody").

/* Initial goals */

!createSynapsisBody.

/* Plans */

//INIZIO ---- BELIEF DINAMICI
+here(X,Y,Z) <-
   .print("Il mio corpo si trova qui: ", X, ", ", Y, ", ", Z).

+onMouseExit(P,L) : .list(L) <-
   .print("Il mouse è uscito ", P);
   .length(L,X);
   .print("Lughezza della lista: ", X).
 
//FINE ---- BELIEF DINAMICI

+!startMind <-
   .my_name(Me);
   .print(Me," Avviato");
   !!personalSend.

+!personalSend <-
   azionePersonalizzata;
   .wait(3000);
   !!personalSend.
   
// inclusione dell'asl che contenente belief e plan di base per synapsis
// è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsisJaCaMo/synapsis_base_agent.asl") } 