// Agent web_socket_user in project helloworld_tutorial

/* Initial beliefs and rules */

/* Initial goals */

!setup.
//!check_messages.

/* Plans */

+joined(W,_) : true <-
	.print("Entrato nel workspace ",W).

+focused(W,A,ArtId): true <-
	.print("Workspace:", W, " - Artifact:", A ," - ArifactId:", ArtID).

+message_sent : true <- 
	.print("messaggio inviato con successo").

+!setup : true <-
	!setup_workspace.
	//!setup_artifact.
	
+!setup_workspace : true <-
	.my_name(Me);
	.concat("wp_",Me,W) 
	createWorkspace(W);
	joinWorkspace(W,Id);
	!setup_artifact.

//Crea l'artefatto websocket nel workspace main (sarebbe il default workspace del MAS)
+!setup_artifact : true <- 
	makeArtifact("websocket","web.WebSocketBuffer",[],Id);
	focus(Id);
	.my_name(Me);
	sendMessageToMiddleware(Me)[artifact_id(Id)].

-!setup_artifact : true <-
	.print("Piano setup_artifact fallito").

+!check_messages : online(C) & C=true & n_messages(N) & N > 0 <-
	get(Message);
	.print(Message).
	//!!check_messages.

+n_messages(N) : N > 0 <-
	!check_messages.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
