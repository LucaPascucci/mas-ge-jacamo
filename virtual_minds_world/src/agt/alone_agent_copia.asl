// Agent web_socket_user in project helloworld_tutorial

/* Initial beliefs and rules */
message("messaggio").
message_number(5). 

/* Initial goals */

!setupWebSocketArtifact.

/* Plans */

//+joined(W,_) : true <-
	//.print("Entrato nel workspace ",W).

 +focused(W,A,ArtId): true <-
	.print("Workspace: ", W, " - Artifact: ", A ," - ArtifactId: ", ArtID).
					
+incoming_messages(N) : N > 0 <-
	//.print("messaggi in coda : ",N);
	!!get_messages. 				//GIUSTO CREARE UN NUOVO GOAL?

+online(C) : true <-
	if (C = true){
		.print("WEBSOCKET COLLEGATA")
	} else {
		.print("WEBSOCKET NON COLLEGATA")
	}.
	
+link_to_body(C) : true <-
	if (C = true){
		.print("CORPO COLLEGATO");
		!!sendDelayedMessage;
		//!!waitMessage;
	} else {
		.print("CORPO NON COLLEGATO")
	}.

+!setupWebSocketArtifact : true <- 
	.my_name(Me)
	.concat("websocket_",Me,ArtifactName);
	makeArtifact(ArtifactName,"web.WebSocketAloneAgent",[Me],Id);
	focus(Id).
	
+!sendDelayedMessage : online(C1) & C1 = true & linked_to_body(C2) & C2 = true & message_number(N) & N > 1 <-
	.print("sendDelayedMessage");
	.wait(100);
	?message(C);
	-+message_number(N-1);
	azionePersonalizzata.
	//!waitMessage;
	//!!sendDelayedMessage.
	
-!sendDelayedMessage : message_number(N) & N = 1 <-
	action("lastmessage",N);
	.print("completato invio messaggi").
	
-!sendDelayedMessage : true <-
	.wait(100);
	!!sendDelayedMessage.

+!get_messages : online(C) & C=true <-
	getAnswer(Message);
	cartago.invoke_obj(Message,getContent,Res);
	.print(Res);
	cartago.invoke_obj(Message,getParameters,Array);
	cartago.array_to_list(Array,Res2);
	.print(Res2).
	// .print(Message).

-!get_messages: true <-
	?online(C);
	.print("Piano get_messages fallito -> WebSocket online: ", C).

+!waitMessage <-
	.print("In attesa di un messaggio");
	getStringResponse(Message);
	
	.print(Message);
	!!waitMessage.
	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
