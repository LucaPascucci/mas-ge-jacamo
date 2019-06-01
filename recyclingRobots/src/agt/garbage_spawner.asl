// Agent garbage_spawner in project recyclingRobots

/* Initial beliefs and rules */

synapsis_artifact_base_name("garbage").
synapsis_url("ws://localhost:9000/").
synapsis_body_class("artifacts.GarbageBody").
reconnection_attempts(5).

/* Initial goals */

!spawnSynapsisBody(20).

// inclusione dell'asl che contenente belief e plan di base per synapsis. è possibile collegare anche un file asl all'interno di un JAR
{ include("jar:file:/Users/luca/mas-ge-jacamo/recyclingRobots/lib/SynapsisJaCaMo.jar!/agt/synapsisJaCaMo/spawner_synapsis_bodies.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

