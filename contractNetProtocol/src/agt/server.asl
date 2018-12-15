/* Initial beliefs AND RULES */

price(_Service,X) :- .random(R) & X = (10*R)+100. // pick a random price for the service

plays(initiator,client). // "Toy" scenario: let's assume to know who the client is

/* Plans library */

+plays(initiator,In) // Let's introduce myself
	: .my_name(Me)
	<- .send(In,tell,introduction(participant,Me)).

/* Handle CFP request */
+cfp(CNPId,Task)[source(A)]
	// be sure the client is really the client, we can do Task (why?) and retrieve my offer
	: plays(initiator,A) & price(Task,Offer)
	<- +proposal(CNPId,Task,Offer); // remember my proposal
		.send(A,tell,propose(CNPId,Offer)). // propose my offer

/* Handle proposal accept */
+accept_proposal(CNPId)
	: proposal(CNPId,Task,Offer) // be sure I am the winner
	<- .print("My proposal '",Offer,"' won CNP ",CNPId,
				" for ",Task,"!"). // do Task...

/* Handle proposal reject */
+reject_proposal(CNPId)
	<- .print("I lost CNP ",CNPId, ".");
		-proposal(CNPId,_,_). // forget loser proposal
