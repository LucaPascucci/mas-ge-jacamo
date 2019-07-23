// Agent synapsis_base_agent_future in project virtualMinds

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true <- .print("hello world.").

/*   
+!createMockEntity(ClassName, EntityName): focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <- 
   .concat("Inviata richiesta di creazione entità mock: ", EntityName, " -> classe: ", ClassName, Message);
   !logMessage(Message);
   .term2string(EntityName,EntityNameString);
   createMockEntity(ClassName, EntityNameString).
   
-!createMockEntity(ClassName, EntityName) <-
   !!createMockEntity(ClassName, EntityName).
*/

/* 
+!createMockEntities(ClassName, EntityName, NumberOfEntities): focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <- 
   .concat("Inviata richiesta di creazione di ", NumberOfEntities , " entità mock: ", EntityName, " -> classe: ", ClassName, Message);
   !logMessage(Message);
   .term2string(EntityName,EntityNameString);
   createMockEntities(ClassName, EntityNameString, NumberOfEntities).

-!createMockEntities(ClassName, EntityName, NumberOfEntities) <-
   !!createMockEntities(ClassName, EntityName, NumberOfEntities).
*/
   
/* 
+!deleteMockEntity(EntityName): focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <- 
   .concat("Inviata richiesta di eliminazione entità mock: ", EntityName, Message);
   !logMessage(Message);
   .term2string(EntityName,EntityNameString);
   deleteMockEntity(EntityNameString).
   
-!deleteMockEntity(EntityName) <-
   !!deleteMockEntity(EntityName).
*/

/* 
+!deleteMockEntities(EntityName, NumberOfEntities): focused(_,N,_) & synapsis_base_name(BaseName) & .substring(BaseName,N) <- 
   .concat("Inviata richiesta di creazione di ", NumberOfEntities , " entità mock: ", EntityName, Message);
   !logMessage(Message);
   .term2string(EntityName,EntityNameString);
   deleteMockEntities(EntityNameString).
   
-!deleteMockEntities(EntityName,NumberOfEntities) <-
   !!deleteMockEntity(EntityName,NumberOfEntities).   
*/

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
