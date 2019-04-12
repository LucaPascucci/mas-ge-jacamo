/* Initial beliefs */

plays(initiator,client). // "Toy" scenario: let's assume to know who the client is 

/* Plans library */

+plays(initiator,In) // Let's introduce myself
	: .my_name(Me)
	<- .send(In,tell,introduction(participant,Me)).

/* Handle CFP request */
+cfp(CNPId,_Service)[source(A)]
	: plays(initiator,A) // be sure the client is really the client
	<- .send(A,tell,refuse(CNPId)). // refuse CFP
