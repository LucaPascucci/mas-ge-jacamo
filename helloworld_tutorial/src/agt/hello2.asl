/* Initial beliefs and rules */

message(fr,"Bonjour").
message(br,"Bom dia").
message(it,"Buon giorno").
message(us,"Good morning").

/* Initial goals */

!start2.

/* Plans */

+!start : country(Country) & message(Country,Text) <- 
	for (focused(_,_,ArtId)){
		printMsg(Text) [artifact_id(ArtId)];
	}.
	
+!start2 : message(Text) <-
	for (numMsg(N)[artifact_name(_,Name)] & focused(_,Name[artifact_type("display.GUIConsole")],ArtId)){
		printMsg(Text)[artifact_id(ArtId)]
	}.
	
//belief che viene aggiunto in automatico dalla configurazione del MAS
+focused(W,A,ArtId): true <-
	.print("Workspace:", W, " - Artifact:", A ," - ArifactId:", ArtID).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
