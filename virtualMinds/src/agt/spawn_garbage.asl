// Agent spanw_garbage in project virtualMinds

/* Initial beliefs and rules */

synapsis_artifact_base_name("garbage").
synapsis_url("ws://localhost:9000/").
synapsis_body_class("artifacts.GarbageBody").
reconnection_attempts(5).

/* Initial goals */

//!spawnSynapsisBody(10).

{ include("synapsisJaCaMo/spawner_synapsis_artifacts.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }