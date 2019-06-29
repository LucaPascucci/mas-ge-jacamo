// Agent spawn_test in project virtualMinds

/* Initial beliefs and rules */

synapsis_agent_base_name("test").
synapsis_agent_path("src/agt/simple_agent.asl").

/* Initial goals */

!spawnSynapsisAgent(1).

{ include("synapsisJaCaMo/spawner_synapsis_agents.asl") } 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
