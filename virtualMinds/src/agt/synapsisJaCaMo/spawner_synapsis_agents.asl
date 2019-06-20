// Synapsis mind spawner --> Agente permette la creazione di agenti

/* Belief di esempio
 * 
 * synapsis_agent_base_name("simple_agent").
 * synapsis_agent_path("src/agt/simple_agent.asl").
 * obbligatorio che il file asl da creare includa synapsis_base_agent.asl ed avere i beliefs e goal iniziale richiesti da quest'ultimo
 * 
 */

/* Goal di esempio per avviare la creazione di agenti
 * 
 * !spawnSynapsisAgent(3). --> crea 3 agenti (con i relativi synapsis body)
 * 
 */
 
/* Plans */

+!spawnSynapsisAgent(N): N > 0  <-
   !!createSynapsisAgent(N);
	!spawnSynapsisAgent(N-1).

+!spawnSynapsisAgent(N): N = 0 <-
	!logMessage("Conclusa creazione synapsis agents").

-!spawnSynapsisAgent <-
   !logMessage("Errore durante la creazione di agenti").
   
+!createSynapsisAgent(N): synapsis_agent_base_name(BaseName) & synapsis_agent_path(Path) <-
   .concat(BaseName,N,AgentName);
   .create_agent(AgentName,Path);
   .concat("Creato ", AgentName, Message);
   !logMessage(Message).

-!createSynapsisAgent <-
   !logMessage("Errore durante la creazione di un agenti").
   
+!logMessage(Message) <- 
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: ", Message).
   
-!logMessage <-
   .time(H,M,S);
   .my_name(Me);
   .print("[Synapsis - ", Me, " - ", H, ":", M, ":", S, "]: Errore durante il log").