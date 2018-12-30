// Agent web_socket_user in project helloworld_tutorial

/* Initial beliefs and rules */

/* Initial goals */

!setupWebSocketArtifact.
!sendDelayedMessage.

/* Plans */

+joined(W,_) : true <-
	.print("Entrato nel workspace ",W).

+focused(W,A,ArtId): true <-
	.print("Workspace:", W, " - Artifact:", A ," - ArtifactId:", ArtID).

+message_sent : true <- 
	.print("messaggio inviato con successo").
	
+n_messages(N) : N > 0 <-
	//.print("messaggi in coda : ",N);
	!!get_messages. //GIUSTO CREARE UN NUOVO GOAL?
	
+online(C) : true <-
	if (C = true){
		.print("WebSocket collegata")
	} else {
		.print("WebSocket non collegata")
	}.
	
+linked_to_body(C) : true <-
	if (C = true){
		.print("Collegato al CORPO")
	} else {
		.print("Non collegato al CORPO")
	}.

+!setupWebSocketArtifact : true <- 
	.my_name(Me);
	.concat("websocket_",Me,ArtifactName);
	makeArtifact(ArtifactName,"web.WebSocketArt",[Me],Id);
	focus(Id).
	
+!sendDelayedMessage : online(C1) & C2 = true & linked_to_body(C2) & C2 = true <-
	.wait(5000);
	-message(M);
	sendMessageToBody(M);
	!!sendStop.
	
-!sendDelayedMessage : true <-
	.wait(2000);
	!sendDelayedMessage.

+!get_messages : online(C) & C=true <-
	get(Message);
	.print(Message).

-!get_messages: true <-
	?online(C);
	.print("Piano check messages fallito -> WebSocket online: ", C).

+!sendStop : true <-
	.wait(3000);
	sendMessageToBody("stop");
	!!sendResume.
	
+!sendResume : true <-
	.wait(5000);
	sendMessageToBody("resume").

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
