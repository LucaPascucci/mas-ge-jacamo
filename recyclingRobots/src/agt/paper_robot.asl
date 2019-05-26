// Agent paper_robot in project recyclingRobots

/* Initial beliefs and rules */
synapsis_url("ws://localhost:9000/").
synapsis_endpoint_path("service/").
reconnection_attempts(5).
synapsis_body_class("recyclingRobots.PaperRobotBody").

/* Initial goals */

/* Plans */


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
