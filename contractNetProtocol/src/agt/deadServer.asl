/* Initial beliefs */

plays(initiator,client). // "Toy" scenario: let's assume to know who the client is

/* Plans library */

+plays(initiator,In) // Let's introduce myself, but forget about CNP
	: .my_name(Me)
	<- .send(In,tell,introduction(participant,Me)).
