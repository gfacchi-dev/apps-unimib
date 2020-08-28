is_regexp(epsilon).
is_regexp([R1 | R2]) :-
    is_regexp(R1),
    is_regexp(R2).
is_regexp(RE) :-
    atomic(RE).
is_regexp(RE) :-
    RE =.. [seq | R1],
    is_regexp(R1).
is_regexp(RE) :-
    RE =.. [or | R1],
    is_regexp(R1).
is_regexp(star(R1)) :-
    is_regexp(R1).
is_regexp(plus(R1)) :-
    is_regexp(R1).

not_regexp(_).
not_regexp(RE) :- 
    is_regexp(RE),
    !,
    fail.

not_exists_nfa(_).
not_exists_nfa(Id) :-
    exists_nfa(Id),
    !,
    fail.

exists_nfa(Id) :-
    gensym(t, Teststate),
    assert(initial(Teststate, Teststate)),
    initial(Id, _),
    retract(initial(Teststate, Teststate)).

nfa_regexp_comp(Id, RE) :-
    atomic(Id),
    is_regexp(RE),
    not_exists_nfa(Id),
    gensym(q, Initial),
    gensym(f, Final),
    assert(initial(Id, Initial)),
    assert(final(Id, Final)),
    nfa_regexp_comp(Id, Initial, RE, Final).
nfa_regexp_comp(Id, Initial, or(RE1, RE2), Final) :-
    gensym(q, Init1),
    gensym(q, Init2),
    assert(delta(Id, Initial, epsilon, Init1)),
    assert(delta(Id, Initial, epsilon, Init2)),
    gensym(q, Final1),
    gensym(q, Final2),
    assert(delta(Id, Final1, epsilon, Final)),
    assert(delta(Id, Final2, epsilon, Final)),
    nfa_regexp_comp(Id, Init1, RE1, Final1),
    nfa_regexp_comp(Id, Init2, RE2, Final2).
nfa_regexp_comp(Id, Initial, or([RE]), Final) :-
    gensym(q, Initial1),
    gensym(q, Final1),
    assert(delta(Id, Initial, epsilon, Initial1)),
    assert(delta(Id, Final1, epsilon, Final)),
    nfa_regexp_comp(Id, Initial1, RE, Final1).
nfa_regexp_comp(Id, Initial, or([X | Xs]), Final) :-
    nfa_regexp_comp(Id, Initial, or([X]), Final),
    nfa_regexp_comp(Id, Initial, or(Xs), Final).
nfa_regexp_comp(Id, Initial, or(RE), Final) :-
    gensym(q, Initial1),
    gensym(q, Final1),
    assert(delta(Id, Initial, epsilon, Initial1)),
    assert(delta(Id, Final1, epsilon, Final)),
    nfa_regexp_comp(Id, Initial1, RE, Final1).
nfa_regexp_comp(Id, Initial, RE, Final) :-
    RE =.. [or, R1, R2 | R3],
    gensym(q, Init1),
    gensym(q, Init2),
    assert(delta(Id, Initial, epsilon, Init1)),
    assert(delta(Id, Initial, epsilon, Init2)),
    gensym(q, Final1),
    gensym(q, Final2),
    assert(delta(Id, Final1, epsilon, Final)),
    assert(delta(Id, Final2, epsilon, Final)),
    nfa_regexp_comp(Id, Init1, R1, Final1),
    nfa_regexp_comp(Id, Init2, R2, Final2),
    X =.. [or, R3],
    nfa_regexp_comp(Id, Initial, X, Final).
nfa_regexp_comp(Id, Initial, RE, Final) :-
    RE =.. [seq, RE1, RE2],
    gensym(q, Final1),
    gensym(q, Initial2),
    nfa_regexp_comp(Id, Initial, RE1, Final1),
    assert(delta(Id, Final1, epsilon, Initial2)),
    nfa_regexp_comp(Id, Initial2, RE2, Final).
nfa_regexp_comp(Id, Initial, RE, Final) :-
    RE =.. [seq, R1, R2 | R3],
    gensym(q, Final1),
    gensym(q, Initial2),
    gensym(q, Final2),
    gensym(q, Initial3),
    nfa_regexp_comp(Id, Initial, R1, Final1),
    assert(delta(Id, Final1, epsilon, Initial2)),
    nfa_regexp_comp(Id, Initial2, R2, Final2),
    assert(delta(Id, Final2, epsilon, Initial3)),
    nfa_regexp_comp(Id, Initial3, R3, Final).
nfa_regexp_comp(Id, Initial, RE, Final) :-
    RE =.. [seq, RE1],
    nfa_regexp_comp(Id, Initial, RE1, Final).
nfa_regexp_comp(Id, Initial, [RE], Final) :-
    nfa_regexp_comp(Id, Initial, RE, Final).
nfa_regexp_comp(Id, Initial, [RE1 | RE2], Final) :-
    gensym(q, Final1),
    gensym(q, Initial2),
    nfa_regexp_comp(Id, Initial, RE1, Final1),
    assert(delta(Id, Final1, epsilon, Initial2)),
    nfa_regexp_comp(Id, Initial2, RE2, Final).
nfa_regexp_comp(Id, Initial, star(RE), Final) :-
    gensym(q, Initial1),
    gensym(q, Final1),
    assert(delta(Id, Initial, epsilon, Initial1)),
    assert(delta(Id, Final1, epsilon, Final)),
    assert(delta(Id, Final1, epsilon, Initial1)),
    assert(delta(Id, Initial, epsilon, Final)),
    nfa_regexp_comp(Id, Initial1, RE, Final1).
nfa_regexp_comp(Id, Initial, plus(RE), Final) :-
    nfa_regexp_comp(Id, Initial, seq(RE, star(RE)), Final).
nfa_regexp_comp(Id, Initial, RE, Final) :-
    atomic(RE),
    assert(delta(Id, Initial, RE, Final)).
nfa_regexp_comp(Id, Initial, RE, Final) :-
    not_regexp(RE),
    assert(delta(Id, Initial, RE, Final)).
nfa_regexp_comp(Id, Initial, RE, Final) :-
    compound_name_arguments(RE, _, []),
    assert(delta(Id, Initial, RE, Final)).

nfa_test(Id, []) :-
    atomic(Id),
    initial(Id, Q),
    nfa_test(Id, [], Q).
nfa_test(Id, []) :-
    atomic(Id),
    initial(Id, Q),
    delta(Id, Q, X, Qnext),
    X = epsilon,
    nfa_test(Id, [], Qnext).
nfa_test(Id, RE) :-
    atomic(Id),
    initial(Id, Q),
    nfa_test(Id, RE, Q).
nfa_test(Id, [X | Xs]) :-
    atomic(Id),
    initial(Id, Q),
    nfa_test(Id, [X |Xs], Q).
nfa_test(Id, [X | Xs], Q) :-
    delta(Id, Q, X, Qnext),
    nfa_test(Id, Xs, Qnext).
nfa_test(Id, [X | Xs], Q) :-
    delta(Id, Q, T, Qnext),
    T = epsilon,
    nfa_test(Id, [X | Xs], Qnext).
nfa_test(Id, [], Q) :-
    final(Id, Q).
nfa_test(Id, [], Q) :-
    delta(Id, Q, epsilon, Qnext),
    nfa_test(Id, [], Qnext).

nfa_list(Id) :-
    atomic(Id),
    listing(initial(Id, _)),
    listing(delta(Id, _, _, _)),
    listing(final(Id, _)).
nfa_list() :-
    listing(initial(_, _)),
    listing(delta(_, _, _, _)),
    listing(final(_, _)).

nfa_clear(Id) :-
    atomic(Id),
    retractall(delta(Id, _, _, _)),
    retractall(initial(Id, _)),
    retractall(final(Id, _)).
nfa_clear() :-
    nfa_clear(_).

:- dynamic initial/2.
:- dynamic final/2.
:- dynamic delta/4.
