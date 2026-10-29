// Agent bob in project smartroom

/* Initial beliefs and rules */

/* Initial goals */

!start.


/* Plans */

// -------------------Con VotingMachine------------------
// open([21,25,30], [mario, luigi, bowser], 4000)

+!startVoting(Options, Timeout) <-
    ?censo(Censo);
    open(Options, Censo, Timeout);
    .print("-----------Inicia la votación-----------").

/*censo(C) :- .all_names(A) & .my_name(rm) & .delete(rm, A, C).
    — La línea daba error por un typo: 'rm' en vez de 'rc'
    — Además, C se usaba tanto para recibir all_names como para el resultado de borrar
      en A (sin valor). */
censo(C) :- .all_names(A) & .my_name(rc) & .delete(rc, A, C). // Quiero borrar rc de todos los agentes (A) y guardar el resultado de la resta en C

+vm::result(R) <-   // namespace con "::" (con ":" se interpretaba como contexto del plan)
    .print("El resultado de la votacion ha sido: ", R);
    -+preference(R);
    !regular(R).

// Decide si enfriar, calentar o nada según la temperatura actual del HVAC
+!regular(P) : temperature(T) & T > P <- startCooling.
+!regular(P) : temperature(T) & T < P <- startHeating.
+!regular(P) <- .print("Ya estamos a ", P, " grados").

// Para cuando llega (o se pasa) de la temperatura objetivo
+temperature(T) : preference(P) & state("cooling") & T <= P <-
    stopAirConditioner;
    .print("Temperatura objetivo alcanzada: ", T).
+temperature(T) : preference(P) & state("heating") & T >= P <-
    stopAirConditioner;
    .print("Temperatura objetivo alcanzada: ", T).
+temperature(T) <-
    .print("Ahora la temperatura es: ", T).


+!voting(Options, Timeout) <-
    ConvId = 1;
    !open_voting(ConvId, Options, Timeout);
    .wait(Timeout);
    !close_voting(ConvId, Result).
    
    //!close_voting(ConvId, Result);
    //!report_result(Result);
    //?preference(P);
    //!temperature(P).

+!open_voting(ConvId, Options, Timeout) <-
    // Aquí no quiero un .send(), sino un broadcast a todos los votantes.
    // tell responde a una creencia
    // achieve responde a un objetivo
    .broadcast(tell, open_voting(ConvId, Options, Timeout)).

+!close_voting(ConvId, Result) <-
    ?winner(ConvId, Result);
    .print("Votación terminada. Candidato ganador: ", Result).

winner(ConvId, T) :- 
    .findall(t(C, V), vote(Id, V) & .count(vote(Id, V)[source(_)], C), LV)
    & .print("Votes: ", LV) & .max(LV, t(_, T)).
    // c tiene el num de votos y v el valor de la temperatura
    // se cuenta con id todos los votos vengan de quien vengan
    //t(1,25) -> una persona ha votado 25

+tick <-
    ?co::count(C);
    .print("El contador ahora vale: ", C).

    +contador_actualizado(C) : C>6 <-
        .print("El contador se ha actualizado a", C).

+vote(ConvId, Ballot)[source(Agent)] <-
    .print(Agent, " ha votado: ", Ballot).

+!start : true
    <- .print("hello world.");
       .date(Y,M,D); .time(H,Min,Sec,MilSec); // get current date & time
       +started(Y,M,D,H,Min,Sec). 
       co :: inc.
       co::inc_get(3, C);
       +contador_actualizado(C).        // add a new belief
       // +temperature(25).                      // add a new belief

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
