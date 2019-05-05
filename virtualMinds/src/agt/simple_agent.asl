/* Initial beliefs and rules */

nervousware_url("ws://localhost:8025/middleware").
endpoint_path("/service").

/* Initial goals */

!setupWebSocketArtifact.
!sendAction.

/* Plans */

+joined(W,_) : true <-
	.print("Entrato nel workspace ",W).

+focused(W,A,ArtId): true <-
	.print("Workspace: ", W, " - Artifact: ", A ," - ArtifactId: ", ArtID).

+online_status(C) <-
	if (C = true){
		.print("WEBSOCKET COLLEGATA")
	} else {
		.print("WEBSOCKET NON COLLEGATA")
	}.
	
+linked_to_body_status(C) <-
	if (C = true){
		.print("CORPO COLLEGATO");
	} else {
		.print("CORPO NON COLLEGATO")
	}.
	
+new_message(S,R,C,P) <- 
   .print("NUOVO MESSAGGIO --> Sender: ", S, " - Receiver: ", R, " - Content:", C, " - Parametri:", P).

+!setupWebSocketArtifact : nervousware_url(U) & endpoint_path(P) <- 
	.my_name(Me)
	.concat("websocket_",Me,ArtifactName);
	makeArtifact(ArtifactName,"artifacts.SimpleAgentArtifact",[Me,U,P],Id);
	focus(Id).
	
+!sendAction: online_status(C1) & C1 = true & linked_to_body_status(C2) & C2 = true <-
   azionePersonalizzata;
   .wait(3000);
   !!sendAction.

-!sendAction <-
   .wait(3000);
   !!sendAction.

	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
