/* Initial beliefs and rules */

synapsis_url("ws://localhost:9000/").
synapsis_endpoint_path("service/").
reconnection_attempts(5).
synapsis_body_class("artifacts.PaperRobotBody").

/* Initial goals */

!createSynapsisBody.

/* Plans */

// inclusione dell'asl che contenente belief e plan di base per synapsis. è possibile collegare anche un file asl all'interno di un JAR
{ include("jar:file:/Users/luca/mas-ge-jacamo/recyclingRobots/lib/SynapsisJaCaMo.jar!/agt/synapsisJaCaMo/synapsis_base_agent.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
