// Agent bob in project practica1

/* Initial beliefs and rules -> information about the environment, other agents, itself application
siguiente sesion se trabajara con beliefs */
temperature(20).
temperature(aula1_4, 20).

/* Initial goals -> the agents objectives*/
!temperature(20).
!happy(bob).

!start.

/* Plans -> specifies how goals can be achieved by actions*/

+!temperature(20) <- .print("Temperature is 20.");
+!happy(bob) <- .print("Bob is happy.");
    <- kiss(bob).


+!start : true
    <- .print("hello world.");
       .date(Y,M,D); .time(H,Min,Sec,MilSec); // get current date & time
       +started(Y,M,D,H,Min,Sec).             // add a new belief

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
