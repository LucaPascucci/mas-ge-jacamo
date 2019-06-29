/* Initial beliefs and rules */

synapsis_url("ws://localhost:9000/").
reconnection_attempts(5).
synapsis_body_class("artifacts.SimpleAgentBody").

/* Initial goals */

!createSynapsisBody(["prova",1,false]).
!createMySynapsisMockEntity("TestMock").

//INIZIO -> BELIEF DINAMICI
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
 
//FINE -> BELIEF DINAMICI

/* Plans */

+!personalSend <-
   azionePersonalizzata;
   .wait(3000);
   !!personalSend.


// inclusione dell'asl che contenente belief e plan di base per synapsis è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsisJaCaMo/synapsis_base_agent.asl") } 