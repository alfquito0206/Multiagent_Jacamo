// Agent bob in project practica1

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true
    <- .print("hello world.");
       .date(Y,M,D); .time(H,Min,Sec,MilSec); // get current date & time
       +started(Y,M,D,H,Min,Sec);             // add a new belief
       .my_name(N);
       .send(robert, tell, happy(bob));
       .send(robert, untell, happy(bob));
       .send(robert, achieve, printHolaMundo(N));
       .send(robert, unachieve, printHolaMundo(N)).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
