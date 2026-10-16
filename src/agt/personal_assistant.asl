// Agent robert in project practica1

/* Initial beliefs and rules -> information about the environment,
 other agents, itself application */
//temperature(aula1_4, 20).
//preference(24).

/* Initial goals -> the agents objectives*/

!start.

/* Plans -> specifies how goals can be achieved by actions*/
+open_voating(ConvId, Options, timeout) <-
    ?preference(P);
    ?my_vote(Options, P, V);
    .send(rc, tell, vote(ConvId, P)).

my_vote([H |_], P, H) :- P >= H.
my_vote([H|T], P, V) :- my_vote(T, P, V).
my_vote([H], P, H).


+!start : true
    <- .print("hello world.");
       .date(Y,M,D); .time(H,Min,Sec,MilSec); // get current date & time
       +started(Y,M,D,H,Min,Sec);
       ?preference(P);
       .print("Mi preferencia es: ", P).
       // add a new belief

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
