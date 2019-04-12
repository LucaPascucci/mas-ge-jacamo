/* Initial beliefs AND RULES */

//BELIEF PROLOG-LIKE RULE
all_proposals_received(CNPId)
	:- .count(introduction(participant,_),NP) & // NP = number of participants
		.count(propose(CNPId,_), NO) & // NO = number of proposals received
		.count(refuse(CNPId), NR) & // NR = number of refusals received
		NP = NO + NR. // condition to proceed in the protocol

/* Initial goals */

!startCNP(1,fix(computer)). // Start the call for proposals

/* Plans library */

/* CFP phase */
+!startCNP(Id,Task) // Start the CFP
	<- .print("Waiting for participants..."); .wait(2000); // wait for participants to introduce themselves
		+cnp_state(Id,propose); // remember the state of the CNP
		.findall(Name,introduction(participant,Name),LP); // retrieve all participants (put each Name in list LP)
		.print("Sending CFP to ",LP); .send(LP,tell,cfp(Id,Task)); // send them the CFP (notice MULTICAST)
		.at("now +4 seconds", { +!contract(Id) }). // deadline for accepting CFP proposals (then proceed to next CFP state)

/* Handle CFP replies */
+propose(CNPId,_Offer) // Handle proposal replies
	: cnp_state(CNPId,propose) & all_proposals_received(CNPId)
	<- !contract(CNPId).

+refuse(CNPId) // Handle refusal replies 
   :  cnp_state(CNPId,propose) & all_proposals_received(CNPId)
   <- !contract(CNPId).

/* Contracting phase */
@contracting[atomic]
+!contract(CNPId) // NOTICE "atomic" annotation to avoid other plans be intended while this executes
	: cnp_state(CNPId,propose)
	<- -+cnp_state(CNPId,contract); // update state of the CNP
		.findall(offer(O,A),propose(CNPId,O)[source(A)],L); // retrieve all proposals (put each O -- offer -- and A -- agent -- in L)
		.print("Offers are ",L);
		L \== []; // if no offers, continuing contracting is meaningless
		.min(L,offer(WOf,WAg)); // sort offers, first is the best
		.print("Winner is ",WAg," with ",WOf);
		!announce_result(CNPId,L,WAg); // "broadcast" winner
		-+cnp_state(CNPId,finished). // end state of the CNP

// Why this? Can you see where does this come from?
+!contract(_). 

/* End phase */
+!announce_result(_,[],_). // no more participants to contact

+!announce_result(CNPId,[offer(_,WAg)|T],WAg) // if winner agent... 
   <- .send(WAg,tell,accept_proposal(CNPId)); // ...accept proposal...
      !announce_result(CNPId,T,WAg). // ...then continue

+!announce_result(CNPId,[offer(_,LAg)|T],WAg) // if loser agent... 
   <- .send(LAg,tell,reject_proposal(CNPId)); // ...reject proposal...
      !announce_result(CNPId,T,WAg). // ...then continue

/* Plans failure handling*/

-!contract(CNPId)
	<- .print("CNP ",CNPId," has failed!").
