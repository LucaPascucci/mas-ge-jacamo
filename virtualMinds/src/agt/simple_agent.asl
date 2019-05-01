/* Initial beliefs and rules */

/* Initial goals */

!setupWebSocketArtifact.
!sendAction.

/* Plans */

+joined(W,_) : true <-
	.print("Entrato nel workspace ",W).

+focused(W,A,ArtId): true <-
	.print("Workspace: ", W, " - Artifact: ", A ," - ArtifactId: ", ArtID).
					
+incoming_messages_number(N) : N > 0 <-
	.print("messaggi in coda : ",N);
	!!get_message. 				//GIUSTO CREARE UN NUOVO GOAL?

+online_status(C) <-
	if (C = true){
		.print("WEBSOCKET COLLEGATA")
	} else {
		.print("WEBSOCKET NON COLLEGATA")
	}.
	
+linked_to_body_status(C) : true <-
	if (C = true){
		.print("CORPO COLLEGATO");
	} else {
		.print("CORPO NON COLLEGATO")
	}.

+!setupWebSocketArtifact : true <- 
	.my_name(Me)
	.concat("websocket_",Me,ArtifactName);
	makeArtifact(ArtifactName,"artifacts.SimpleAgentArtifact",[Me],Id);
	focus(Id).
	
+!sendAction: online_status(C1) & C1 = true & linked_to_body_status(C2) & C2 = true <-
   azionePersonalizzata;
   .wait(3000);
   !!sendAction. //CREA UN NUOVO GOAL

-!sendAction <-
   .wait(3000);
   !!sendAction. //CREA UN NUOVO GOAL?

+!get_message <-
	getPerception(Message);
	cartago.invoke_obj(Message,getContent,Res);
	.print(Res);
	cartago.invoke_obj(Message,getParameters,Array);
	cartago.array_to_list(Array,Res2);
	.print(Res2).

-!get_message: true <-
	.print("Piano get_message fallito").
	
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
