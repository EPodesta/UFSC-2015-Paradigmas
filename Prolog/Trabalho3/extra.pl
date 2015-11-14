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
