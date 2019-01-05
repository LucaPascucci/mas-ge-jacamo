// Agent web_socket_user in project helloworld_tutorial

/* Initial beliefs and rules */
message("messaggio").
message_number(0). 

/* Initial goals */

!setupWebSocketArtifact.

/* Plans */

+joined(W,_) : true <-
	.print("Entrato nel workspace ",W).

+focused(W,A,ArtId): true <-
	.print("Workspace:", W, " - Artifact:", A ," - ArtifactId:", ArtID).

//+message_sent : true <- 
	//.print("messaggio inviato con successo").
	
+n_messages(N) : N > 0 <-
	//.print("messaggi in coda : ",N);
	!!get_messages. 					//GIUSTO CREARE UN NUOVO GOAL?
	
+online(C) : true <-
	if (C = true){
		.print("WEBSOCKET COLLEGATA")
	} else {
		.print("WEBSOCKET NON COLLEGATA")
	}.
	
+linked_to_body(C) : true <-
	if (C = true){
		.print("CORPO COLLEGATO");
		!!sendDelayedMessage;
	} else {
		.print("CORPO NON COLLEGATO")
	}.

+!setupWebSocketArtifact : true <- 
	.my_name(Me)
	.concat("websocket",Me,ArtifactName);
	makeArtifact(ArtifactName,"web.WebSocket",[Me],Id);
	focus(Id).
	
+!sendDelayedMessage : online(C1) & C2 = true & linked_to_body(C2) & C2 = true & message_number(N) & N > 1 <-
	//.wait(100);
	?message(M);
	-+message_number(N-1);
	sendMessageToBody(M);
	!!sendDelayedMessage.
	
-!sendDelayedMessage : message_number(N) & N = 1 <-
	sendMessageToBody("lastmessage");
	.print("completato invio messaggi").
	
-!sendDelayedMessage : true <-
	.wait(100);
	!!sendDelayedMessage.

+!get_messages : online(C) & C=true <-
	get(Message);
	.print(Message).

-!get_messages: true <-
	?online(C);
	.print("Piano get_messages fallito -> WebSocket online: ", C).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
