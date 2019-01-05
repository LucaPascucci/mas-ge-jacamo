/* Initial beliefs and rules */

/* Initial goals */

!setupWebSocketArtifact.

/* Plans */

+focused(W,A,ArtId): true <-
	.print("Workspace:", W, " - Artifact:", A ," - ArtifactId:", ArtID).
	
-focused(W,A,ArtId): true <-
	.print("Rimosso FOCUS -> Workspace:", W, " - Artifact:", A ," - ArtifactId:", ArtID).

+linked_to_body(C) : true <-
	if (C = true){
		.print("Collegato al CORPO")
	} else {
		.print("Non collegato al CORPO")
	};
	.wait(5000);
	!!work.

+!work : true <- !!recycle.

+!recycle : not hand(_) <-
	.print("Cerca spazzatura"); //chiedere a controparte unity quale sia la spazzatura più vicina
	?searchGarbage("garbage1",ID); //il nome verrà passato dal corpo (unity)
	focus(ID);
	?busy(C); //Controllare che l'artefatto spazzatura non sia occupato
	C = false;
	setGarbageBusy(true); //Impostare l'artefatto spazzatura come occupato
	.print("Vai alla spazzatura trovata"); //Movimento Body Lato unity
	.print("Prendi la spazzatura"); //Azione Unity
	+hand(ID); //Aggiunge ai belief dell'agente che ha la spazzatura in manos
	?robot_type(RT) //controllare se il tipo della spazzatura è dello stesso tipo del robot
	getGarbageType(T)
	RT = T;
	!!recycle(T). 
	
+!recycle(T) : hand(_) & robot_type(T) <- 
	.print("Cerca bidone della spazzatura"); //chiedere a controparte unity il bidone specificando PLASTICA
	?searchBin("paper_bin",ID);
	focus(ID);
	.print("vai al bidone");
	.print("ricicla spazzatura");
	-hand(_).
	//!!work.

-!recycle : hand(ID) <- 
	.print("Rilasciare spazzatura");
	setGarbageBusy(false);
	stopFocus(ID); //non ferma il focus dell'agente sull'artefatto
	.print("Togliere focus sull'artefatto spazzatura");
	-hand(ID). //Rimuovo bel
	//!!work.

-!recycle : not hand(_) <-
	.print("Fallito piano recycle : not hand(_)");
	!!work.

+?searchGarbage(Name,GarbageID): true <- 
	lookupArtifact(Name,GarbageID).
  
-?searchGarbage(Name,GarbageID): true <- 
	.wait(10);
    ?searchGarbage(Name,GarbageID).
    
+?searchBin(Name,BinID): true <- 
	lookupArtifact(Name,BinID).
  
-?searchBin(Name,BinID): true <- 
	.wait(10);
    ?searchBin(Name,BinID).

+!setupWebSocketArtifact : true <- 
	.my_name(Me);
	.concat("websocket_",Me,ArtifactName);
	makeArtifact(ArtifactName,"web.WebSocket",[Me],Id);
	focus(Id).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
