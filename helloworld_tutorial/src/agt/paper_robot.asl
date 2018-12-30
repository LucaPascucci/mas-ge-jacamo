// Agent plastic_robot in project helloworld_tutorial

/* Initial beliefs and rules */

type("paper").

/* Initial goals */

!setupWebSocketArtifact.

/* Plans */


+focused(W,A,ArtId): true <-
	.print("Workspace:", W, " - Artifact:", A ," - ArtifactId:", ArtID).

+linked_to_body(C) : true <-
	if (C = true){
		.print("Collegato al CORPO")
	} else {
		.print("Non collegato al CORPO")
	};
	!!work.

+!work : true <- !!recycle.

+!recycle : not hand(_) <-
	.print("Cerca spazzatura"); //chiedere a controparte unity quale sia la spazzatura più vicina
	?searchGarbage("garbage",ID); //il nome verrà passato dal corpo (unity)
	focus(ID);
	?busy(false); //Controllare che l'artefatto spazzatura non sia occupato
	setGarbageBusy(true); //Impostare l'artefatto spazzatura come occupato
	.print("Vai alla spazzatura trovata");
	.print("Prendi la spazzatura");
	+hand(ID); //aggiunge ai belief dell'agente che ha la spazzatura in mano
	.print("controllare se il tipo della spazzatura è lo stesso del robot");
	!!recycle(paper). 
	
+!recycle(paper) : hand(_) <- 
	.print("Cerca bidone della spazzatura");
	.print("vai al bidone");
	.print("ricicla spazzatura");
	-hand(_).
	//!!work.

-!recycle : not hand(_) <-
	.print("Fallito piano recycle : not hand(_)").

+?searchGarbage(Name,GarbageID): true <- 
	lookupArtifact(Name,GarbageID).
  
-?searchGarbage(Name,GarbageID): true <- 
	.wait(10);
    ?searchGarbage(Name,GarbageID).

+!setupWebSocketArtifact : true <- 
	.my_name(Me)
	.concat("websocket_",Me,ArtifactName);
	makeArtifact(ArtifactName,"web.WebSocketArt",[Me],Id);
	focus(Id).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
