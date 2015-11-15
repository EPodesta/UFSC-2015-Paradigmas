% Image processing package in Prolog (a initial tentative)
% Prof. A. G. Silva - UFSC - October 2015
%
% Extra functions, especially the transformation of coordinates list for matrix notation
% Example: 
%    ?- coord2matrix([(0,0,50),(0,1,10),(0,2,30),(1,0,10),(1,1,20),(1,2,40)], M).
%    M = [[50, 10, 30], [10, 20, 40]].

:- consult('imagem.pl').
:- consult('pgm.pl').

coord2matrix(S, M) :-
    height(S, H),
    matrixconstruct(S, H, -1, [], M),
    !.

test :-
    load('ufsc.pgm', S),
    coord2matrix(S, M),
    writePGM('ufsc_out.pgm', M),
    !.

load(FileName, S) :-
    readPGM(FileName, M),
    coord(M, S).

matrixconstruct(_, H, H, [Mh|Mt], M) :-
    reverse(Mt, M).
matrixconstruct(S, H, L, Macc, M) :-
    L1 is L + 1,
    findall( V, value(S,(L1,_,V)), Line ),
    matrixconstruct(S, H, L1, [Line|Macc], M).

shape(S, H, W) :-
    height(S, H), width(S, W).

height(S, H) :-
    findall( L, value(S,(L,0,_)), Ll ),
    max_list(Ll, H1),
    H is H1 + 1.

width(S, W) :-
    findall( C, value(S,(0,C,_)), Lc ),
    max_list(Lc, W1),
    W is W1 + 1.

value([(X,Y,V)|_], (X,Y,V)).
value([_|St], (X,Y,Z)) :-
    value(St, (X,Y,Z)).  

%-----------------Negativo----------------
negativo(FileName) :-
    load(FileName, S),
    sub_neg(S, SS),
    coord2matrix(SS, M),
    atom_codes(X, FileName),
    atomic_list_concat(Y, '.', X),
    nth0(0, Y, Li),
    atom_concat(Li, '_out.pgm', NewFileName),
    writePGM(NewFileName, M).

sub_neg([], []) :-
    !.
sub_neg([(X, Y, I)|T_input], [H_output|T_output]) :-
    New_intensity is 255 - I,
    copy_term((X, Y, New_intensity), H_output),
    sub_neg(T_input, T_output).

%------------------Pixel isolado---------------
isolatedPixel(FileName) :-
    load(FileName, S),
    nb_setval(coords, S),
    nb_setval(final, []),
    lonely(S), !,
    nb_getval(final, V),
    write(V).

lonely([]) :-
    !.

lonely([(X, Y, I)|T_input]) :-
    nb_getval(coords, S),
    n4(S,(X, Y, I), L),
    seeNeighboorhood(L, I),
    nb_getval(final, W),
    insert_at((X, Y, I), W, 1, L1),
    nb_setval(final, L1),
    lonely(T_input).

lonely([(X, Y, I)|T_input]) :-
    lonely(T_input).

seeNeighboorhood([], _) :-
    !.

seeNeighboorhood([(X, Y, I)|T], V) :-
    I < V,
    seeNeighboorhood(T,V).


%--------CAMINHO---------------
existPath(FileName, R1, C1, R2, C2) :-
    load(FileName, S),
    nb_setval(coords, S),
    nb_setval(final, []),
    getPixel(S, (R1,C1,V)),
    getPixel(S, (R2, C2, I)),
    sub_neg1(R1, C1, V, R2, C2), !,
    nb_getval(final, V),
    write(V).

sub_neg1(R1, C1, V, R2, C2) :-
    nb_getval(coords, S),
    n4(S,(R1, C1, V), L),
    nb_setval(xis, R1),
    nb_setval(ipslon, C1),
    %write(L),
    seeNeighboorhoodPath(L, V, R2, C2),
    R1 =:= R2,
    C1 =:= C2,
    write('Existe').


seeNeighboorhoodPath([], _) :-
    !.

seeNeighboorhoodPath([(X, Y, I)|T], V, R2, C2) :-
    write('O'),
    nb_getval(xis, Xant),
    nb_getval(ipslon, Yant),
    (X \= Xant;
    Y \= Yant ->
    I >= V,
    sub_neg1(X, Y, I, R2, C2),
    seeNeighboorhoodPath(T,V, R2, C2, I)).

seeNeighboorhoodPath([(X, Y, I)|T], V, R2, C2) :-
    write('H'),
    seeNeighboorhoodPath(T, V, R2, C2).


%-------MEDIA----------
avaregeImages(M1, M2) :-
    load(M1, S),
    load(M2, J),
    avarege(S, J, W),
    coord2matrix(W, L),
    atom_concat('New', '_out.pgm', NewM),
    writePGM(NewM, L).

avarege([], [], []) :-
    !.
avarege([(X, Y, I)|T_input], [(_, _, K)|L_input] ,[H_output|T_output]) :-
    New_intensity is (I + K)/2,
    copy_term((X, Y, New_intensity), H_output),
    avarege(T_input, L_input, T_output).

%-------------New func-------------
remove_at(X,[X|Xs],1,Xs).
remove_at(X,[Y|Xs],K,[Y|Ys]) :-
    K > 1, 
    K1 is K - 1,
    remove_at(X,Xs,K1,Ys).
insert_at(X,L,K,R) :- remove_at(X,R,K,L).

add(X, L, [X|L]).
add_list([], L, L).
add_list([H|T], L, L1) :- add(H, L2, L1), add_list(T, L, L2).

lUltimo([X], X).
lUltimo([H|T], L) :- lUltimo(T, L).
