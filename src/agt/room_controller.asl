// Agent robert in project practica1

/* Initial beliefs and rules -> information about the environment,
 other agents, itself application */
//temperature(aula1_4, 20).
//preference(24).

/* Initial goals -> the agents objectives*/

!start.

/*plans*/

+!startVoting(Options, Timeout) <- 
    ?censo(Censo);
   open(Options, Censo, Timeout);
   .print("---Inicio de votacion ---").

censo(C) :- .all_names(A) & .my_name(Rm) & .delete(Rm, A, C).



+!voting(Options, Timeout) <- 
    ConvId = 1;
    !open_voting(ConvId, Options, Timeout);
    .wait(Timeout);
    .print("Votacion terminada").
   // !close_voting(ConvId, Result);
    // !report_result(Result);
    // ?preference(P);
    // !temperature(P).

+!open_voting(ConvId, Options, Timeout) <-
    .broadcast(tell, open_voting(ConvId, Options, Timeout)).

+!close_voting(ConvId, Result) <-
    ?winner(ConvId, Result);
    .print("Votacion cerrada.").

winner(Id, T) :-
    .findall(t(C, V), vote(Id, V) & .count(vote(Id, V)[source(_)],C)LV) 
    & .print("Votes: " , LV) & .max(LV, t(_, T)).
    
    // c tiene el num de votos y v el valor de la temperatura
    // se cuenta con id todos los votos vengan de quien vengan
    //t(1,25) -> una persona ha votado 25

+vote(ConvId, Ballot)[source(Agent)] <- 
    .print(Agent, "Ha votado: ", Ballot). // no aparece

+temperature(T) : preference(P) & math.abs(T-P) > 2
    <- startCooling;
       .print("Temperature is: ", T).
+temperature(T) : preference(T) <- stopAirConditioner.
    
// tiene que mostrar los votos de todos 
/* Plans -> specifies how goals can be achieved by actions*/

+!start : true
    <- .print("hello world.");
       .date(Y,M,D); .time(H,Min,Sec,MilSec); // get current date & time
       +started(Y,M,D,H,Min,Sec);
       ?preference(P);
       .print("La preferencia es: ", P).
       // add a new belief

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }

