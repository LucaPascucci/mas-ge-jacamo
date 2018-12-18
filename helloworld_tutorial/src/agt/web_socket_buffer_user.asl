// Agent web_socket_user in project helloworld_tutorial

/* Initial beliefs and rules */

/* Initial goals */

!setup.
//!startReading.
!sendDelayedMessage.

/* Plans */

+joined(W,_) : true <-
	.print("Entrato nel workspace ",W).

+focused(W,A,ArtId): true <-
	.print("Workspace:", W, " - Artifact:", A ," - ArifactId:", ArtID).

+message_sent : true <- 
	.print("messaggio inviato con successo").
	
+n_messages(N) : N > 0 <-
	.print("messaggi in coda : ",N);
	!!get_messages.
	
+online(C) : C = true <-
	.print("WebSocket collegata").
	
+online(C) : C = false <-
	.print("WebSocket non collegata").
	
+message_recieved : true <-
	.print("messaggio ricevuto").
	
+!setup : true <-
	!setupWorkspace.
	
+!setupWorkspace : true <-
	.my_name(Me);
	.concat(Me,"_workspace",W) 
	createWorkspace(W);
	joinWorkspace(W,Id);
	!setupArtifact. //nuovo sub goal

+!setupArtifact : true <- 
	makeArtifact("websocket","web.WebSocketClientBuffer",[],Id);
	focus(Id);
	?online(C);
	C = true;
	.my_name(Me);
	registerBrain(Me)[artifact_id(Id)].

//non utilizzato
+!startReading : online(C) & C = true <-
	!consumeMessages.

//non utilizzato
+!consumeMessages: n_messages(N) & N > 0 <- 
	get(Message);	
	!consumeMessage(Message); //nuovo sub goal
	!!consumeMessages. //nuovo goal

//non utilizzato	
+!consumeMessage(Message) : true
	<- .print(Message).

//non utilizzato
-!startReading : true <-
	//.wait(2000);
	!!startReading.

//non utilizzato
-!consumeMessages: true <-
	!!consumeMessages.

+!sendDelayedMessage : online(C) & C = true <-
	.wait(5000);
	-message(M);
	sendMessageToBody(M).
	
-!sendDelayedMessage : true <-
	.wait(2000);
	!!sendDelayedMessage.

+!get_messages : online(C) & C=true <-
	get(Message);
	.print(Message).

-!get_messages: true <-
	?online(C);
	.print("Piano check messages fallito -> WebSocket online: ", C).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
