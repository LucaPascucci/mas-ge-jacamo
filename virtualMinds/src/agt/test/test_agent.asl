/* Initial beliefs and rules */

synapsis_url("ws://localhost:9000/").
reconnection_attempts(5).
synapsis_mind_class("artifacts.SimpleAgentMind").

/* Initial goals */

!createSynapsisMind(["prova",1,false]).
!createMySynapsisMockEntity("TestMock").

//INIZIO -> BELIEF DINAMICI
+synapsis_counterpart_status(Name, C): .my_name(Me) & .substring(Me,Name) <-
   ?my_synapsis_mind_ID(MyArtID);
   if (C == true){
      synapsisLog("Controparte collegata")[artifact_id(MyArtID)];
   } else {
      synapsisLog("Controparte non collegata")[artifact_id(MyArtID)];
   }.

//FINE -> BELIEF DINAMICI

/* Plans */


// inclusione dell'asl che contenente belief e plan di base per synapsis è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsisJaCaMo/synapsis_base_agent.asl") } 