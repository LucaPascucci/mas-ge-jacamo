// Agent plastic_bin_spawner in project virtualMinds

/* Initial beliefs and rules */
synapsis_url("ws://localhost:9000/").
synapsis_body_base_name("plastic_bin").
synapsis_body_class("bins.BinBody").
reconnection_attempts(5).

/* Initial goals */

!spawnSynapsisArtifact(1,["plastic"]).

/* Plans */

// inclusione dell'asl che contenente belief e plan di base per synapsis. è possibile collegare anche un file asl all'interno di un JAR
{ include("synapsisJaCaMo/spawner_synapsis_artifacts.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
