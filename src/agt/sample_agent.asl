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
       .send(rc, tell, happy(bob));
       .send(rc, untell, happy(bob));
       .send(rc, achieve, printHolaMundo(N));
       .send(rc, unachieve, printHolaMundo(N));
       .send(rc, askOne, preference(P));
       .send(rc, askOne, temperature(X), T);
       .send(rc, askOne, happy(X), A);
       // .wait (1000);
       .print(A).

+preference(P)[source(A)]
    <- .print("Me ha llegado la preferencia: ", P).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
