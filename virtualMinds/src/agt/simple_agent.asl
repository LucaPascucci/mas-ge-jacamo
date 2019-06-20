/* Initial beliefs and rules */

synapsis_url("ws://localhost:9000/").
reconnection_attempts(5).
synapsis_body_class("artifacts.SimpleAgentBody").

/* Initial goals */


!createSynapsisBody.
!myMockEntity.

/* Plans */

//INIZIO ---- BELIEF DINAMICI
+synapsis_counterpart_status(C) <-
   if (C == true){
      !logMessage("Controparte collegata");
      !!personalSend;
   } else {
      !logMessage("Controparte non collegata");
   }.
   
+risposta_automatica(X,Y,Z) <-
   if (Y == false){
      .print("Arrivata la risposta automatica -> valori: ",X, " - ", Y ," - ", Z );
   }.
   
+here(X,Y,Z) <-
   .print("Il mio corpo si trova qui: ", X, ", ", Y, ", ", Z).
 
//FINE ---- BELIEF DINAMICI

+!myMockEntity <-
   .my_name(Me);
   !createMockEntity("TestMock",Me).

+!personalSend <-
   azionePersonalizzata;
   .wait(3000);
   !!personalSend.
   
// inclusione dell'asl che contenente belief e plan di base per synapsis
// è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsisJaCaMo/synapsis_base_agent.asl") } 