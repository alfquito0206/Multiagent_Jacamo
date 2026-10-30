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
    .print("--- Inicio la votación ---").

/*censo(C) :- .all_names(A) & .my_name(rm) & .delete(rm, A, C).
    — La línea daba error por un typo: 'rm' en vez de 'rc'
    — Además, C se usaba tanto para recibir all_names como para el resultado de borrar
      en A (sin valor). */
censo(C) :- .all_names(A) & .my_name(rc) & .delete(rc, A, C). // Quiero borrar rc de todos los agentes (A) y guardar el resultado de la resta en C

+vm::result(R) <-   // namespace con "::" (con ":" se interpretaba como contexto del plan)
    .print("El resultado de la votación ha sido: ", R);
    -+preference(R);
    !temp(R).

// Para el aire cuando la temperatura está a 1 grado o menos del objetivo (como en la versión del profesor).
// "not state(\"idle\")" evita llamar a stop si el aire ya está parado.
+temperature(T) : preference(P) & not state("idle") & math.abs(T - P) <= 1 <-
    stopAirConditioner.


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

// Decide si enfriar, calentar o nada. T: temperatura objetivo, Actual: la que marca el HVAC.
// Solo se ejecuta una vez (cuando llega el resultado); la parada la hacen los planes +temperature.
+!temp(T) : temperature(Actual) & T < Actual <-
    startCooling;    // sin "!": es la operación del artefacto HVAC, no un subobjetivo
    .concat("[startCooling] La temperatura es: ", Actual, " objetivo: ", T, Msg);
    gui::printMsg(Msg);   // escribe en la ventana del artefacto GUIconsole
    .print("[startCooling] La temperatura es: ", Actual, " objetivo: ", T).

+!temp(T) : temperature(Actual) & T > Actual <-
    startHeating;
    .concat("[startHeating] La temperatura es: ", Actual, " objetivo: ", T, Msg);
    gui::printMsg(Msg);
    .print(Msg).
+!temp(T) : temperature(Actual) & T == Actual <-
    stopAirConditioner; 
    .print("Ya estamos a la temperatura objetivo: ", T).

+co::tick <-   // con focus co::w.c1 la señal también llega con el namespace co
    ?co::count(C);
    .print("El contador tiene: ", C).

    +contador_actualizado(C) : C>6 <-
        .print("El contador se ha actualizado: ", C).

+vote(ConvId, Ballot)[source(Agent)] <-
    .print(Agent, " ha votado: ", Ballot).

+!start : true
    <- .print("hello world.");
       .date(Y,M,D); .time(H,Min,Sec,MilSec); // get current date & time
       +started(Y,M,D,H,Min,Sec);
       co::inc;
       co::inc_get(3, C);
       +contador_actualizado(C).        // add a new belief
       // +temperature(25).                      // add a new belief

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
