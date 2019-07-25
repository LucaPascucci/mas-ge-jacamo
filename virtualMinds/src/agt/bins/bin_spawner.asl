/* Initial beliefs and rules */

synapsis_url("ws://localhost:9000/").
//synapsis_mind_base_name("plastic_bin").
synapsis_mind_class("bins.BinMind").
reconnection_attempts(5).

/* Initial goals */

// !spawnSynapsisArtifact(1,["plastic"]).

/* Plans */

// inclusione dell'asl che contenente belief e plan di base per synapsis. è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsis/spawner_synapsis_artifacts.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
