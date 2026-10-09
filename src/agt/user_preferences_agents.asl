// Agent robert in project practica1

/* Initial beliefs and rules -> information about the environment,
 other agents, itself application */
temperature(aula1_4, 20).
preference(24).
happy(calamardo).

/* Initial goals -> the agents objectives*/

!start.

/* Plans -> specifies how goals can be achieved by actions*/

// temperature(T) is perceived from the hvac artifact
+temperature(T) : preference(P) & math.abs(T-P) > 2
    <- startCooling;
       .print("Temperature is: ", T).

+temperature(T) : preference(T)
    <- stopAirConditioner;
       .print("Temperature is: ", T).

// messages sent by bob
+happy(X)[source(A)]
    <- .print(A, " dice que ", X, " es feliz").

-happy(X)[source(A)]
    <- .print("pobrecito ", X, " no es feliz").

+!printHolaMundo(N)
    <- .print("Hola mundo de parte de: ", N);
       .wait(100).

+!start : true
    <- .print("hello world.");
       .date(Y,M,D); .time(H,Min,Sec,MilSec); // get current date & time
       +started(Y,M,D,H,Min,Sec).             // add a new belief

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
