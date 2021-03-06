/*
   Image processing package in Prolog (a initial tentative)
     Prof. A. G. Silva - UFSC
     Initial version: June 2015
     Last update: November 2015
       - 'image.pl', 'extra.pl' and 'pgm.pl' in the same file
       - The maximum value is now determined in 'writePGM' (12nov2015, 10h)
       - More efficient implementation of: (15nov2015, 21h)
           - 'coord' (without 'append')
           - 'coord2matrix' (without 'findall')
           - 'maximum_matrix' (using 'maximum')
*/

:- use_module(library(pio)).



% EXAMPLE OF ARRAY
% -------------------------

matrix([[4,0,0,0,0,0,0,0,0,0],
        [1,1,0,0,1,9,0,0,0,0],
        [0,1,0,0,1,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0],
        [0,0,3,0,0,0,1,0,0,0],
        [0,7,1,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,5,1,0],
        [0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0]]).


% ARRAY TO LIST OF COORDINATES
% -------------------------
% Example: 
%    ?- coord([[50, 10, 30], [10, 20, 40]], C).
%    C = [(0,0,50),(0,1,10),(0,2,30),(1,0,10),(1,1,20),(1,2,40)].

coordLine([], _, _, []).

coordLine([H|T], Lin, Col, [(Lin,Col,H)|Tm]) :-
    Col1 is Col + 1,
    coordLine(T, Lin, Col1, Tm).

coordAux([], _, _, []) :- !.

coordAux([H|T], Lin, Col, [Hm|Tm]) :-
    Lin1 is Lin + 1,
    coordLine(H, Lin1, Col, Hm),
    coordAux(T, Lin1, Col, Tm).


coord2coord([], C, C).
/*
coord2coord([H|T], C, Coord) :-
    append(C,H,Cx),
    coord2coord(T, Cx, Coord).
*/
coord2coord([H|T], C, Coord) :-
    coord2coord_aux(H, C, D),
    coord2coord(T, D, Coord).

coord2coord_aux([], C, C).
coord2coord_aux([A|B], C, D) :-
    coord2coord_aux(B, [A|C], D).

coord(Mat, Coord) :-
    coordAux(Mat, -1, 0, CoordMat),
    coord2coord(CoordMat, [], CoordRev),
    reverse(CoordRev, Coord).


% LIST OF COORDINATES TO ARRAY
% -------------------------
% Example: 
%    ?- coord2matrix([(0,0,50),(0,1,10),(0,2,30),(1,0,10),(1,1,20),(1,2,40)], M).
%    M = [[50, 10, 30], [10, 20, 40]].

/*
coord2matrix(S, M) :-
    height(S, H),
    matrixconstruct(S, H, -1, [], M),
    !.

matrixconstruct(_, H, H, [_|Mt], M) :-
    reverse(Mt, M).
matrixconstruct(S, H, L, Macc, M) :-
    L1 is L + 1,
    findall( V, value(S,(L1,_,V)), Line ),
    matrixconstruct(S, H, L1, [Line|Macc], M).
*/

coord2matrix(S, M) :-
    shape(S, H, W),
    matrixconstruct(S, H, W, -1, [], M),
    !.

matrixconstruct(_, H, _, H, [_|Mt], M) :-
    reverse(Mt, M).
matrixconstruct(S, H, W, L, Macc, M) :-
    L1 is L + 1,
    lineconstruct(S, W, Line, Rest),
    matrixconstruct(Rest, H, W, L1, [Line|Macc], M).

lineconstruct([], _, [], []).
lineconstruct(Rest, 0, [], Rest).
lineconstruct([(_,_,V)|Ta], N, [V|Tb], Rest) :-
    N1 is N - 1,
    lineconstruct(Ta, N1, Tb, Rest).


% DIMENSIONS, VALUE, AND MAXIMUM
% -------------------------
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

maximum(S, M) :-  %maximum for list of coordinates
    findall( V, value(S,(_,_,V)), Lv ),
    max_list(Lv, M).


% IMAGE OF ZEROS
% -------------------------
% zerosAuxLine((3,4),[],Sb).

zerosAuxLine((X,_), S, S) :-
    X < 0,
    !.
zerosAuxLine((_,X), S, S) :-
    X =< 0,
    !.
zerosAuxLine((H,W), Sa, S) :-
    Wa is W - 1,
    zerosAuxLine((H,Wa), [(H,Wa,0)|Sa], S).

zerosAuxSet((X,_), S, S) :-
    X < 0,
    !.
zerosAuxSet((_,X), S, S) :-
    X < 0,
    !.
zerosAuxSet((H,W), Sa, S) :-
    Ha is H - 1,
    zerosAuxLine((Ha,W), [], Sb),
    append(Sb, Sa, Sc),
    zerosAuxSet((Ha,W), Sc, S).

zeros((H,W), S) :-
    zerosAuxSet((H,W), [], S).


% GET|PUT PIXEL
% -------------------------

getPixel([(A,B,V)|_], (X,Y,V)) :-
    A == X,
    B == Y,
    !.
getPixel([_|St], (X,Y,Z)) :-
    getPixel(St, (X,Y,Z)).

putPixel(_, [], []) :- 
    !.
putPixel((A,B,V), [(A,B,_)|T1], [(A,B,V)|T2]) :-
    putPixel((A,B,V), T1, T2),
    !.
putPixel((A,B,V), [(Ax,Bx,Vx)|T1], [(Ax,Bx,Vx)|T2]) :-
    Ax \= A,
    putPixel((A,B,V), T1, T2).
putPixel((A,B,V), [(Ax,Bx,Vx)|T1], [(Ax,Bx,Vx)|T2]) :-
    Bx \= B,
    putPixel((A,B,V), T1, T2).


% NEIGHBORHOOD
% -------------------------

above(S, (X,Y,_), (Xa,Y,V)) :-
    X > 0,
    Xa is X - 1,
    getPixel(S, (Xa,Y,V)).

below(S, (X,Y,_), (Xa,Y,V)) :-
    Xa is X + 1,
    getPixel(S, (Xa,Y,V)).

left(S, (X,Y,_), (X,Ya,V)) :-
    Y > 0,
    Ya is Y - 1,
    getPixel(S, (X,Ya,V)).

right(S, (X,Y,_), (X,Ya,V)) :-
    Ya is Y + 1,
    getPixel(S, (X,Ya,V)).

neighbor(S, (X,Y,V), E) :-
    above(S, (X,Y,V), E).
neighbor(S, (X,Y,V), E) :-
    below(S, (X,Y,V), E).
neighbor(S, (X,Y,V), E) :-
    left(S, (X,Y,V), E).
neighbor(S, (X,Y,V), E) :-
    right(S, (X,Y,V), E).

n4(S, (X,Y,V), N) :-
    findall(E, neighbor(S, (X,Y,V), E), N).


% WRITE PGM
% -------------------------
% Write a PGM (text mode by line) image file format
% Example: 
%    ?- readPGM('ufsc.pgm', M), writePGM('ufsc_out.pgm', M).

writePGM(FileName, I) :-
    open(FileName, write, File),
    dimensions(I, H, W),
    write(File, 'P2\n'),
    write(File, '# Image Processing in Prolog - UFSC 2015\n'),
    write(File, W), write(File, ' '), write(File, H), write(File, '\n'),
    %%% write(File, '255\n'),  %removed in 12nov2015, 10h
    maximum_matrix(I, Max), write(File, Max), write(File, '\n'),  %inserted in 12nov2015, 10h
    write_elements(File, I),
    close(File).

write_elements(_, []) :-
    !.
write_elements(File, [H|T]) :-
    write_line(File, H),
    write(File, '\n'),
    write_elements(File, T).

write_line(_, []) :-
    !.
write_line(File, [H|T]) :-
    write(File, H), write(File, ' '),
    write_line(File, T).

dimensions([Ih|It], H, W) :-
    length(Ih, W),
    length(It, H1),
    H is H1 + 1.

/*
maximum_matrix([], 0). %maximum for matrix
maximum_matrix([Ih|It], M) :-
    max_list(Ih, M1),
    maximum_matrix(It, M2),
    M1 >= M2,
    M is M1.
maximum_matrix([Ih|It], M) :-
    max_list(Ih, M1),
    maximum_matrix(It, M2),
    M2 > M1,
    M is M2.
*/

maximum_matrix(M, Maximum) :-
    coord(M, S),
    maximum(S, Maximum).


% READ PGM
% -------------------------
% Example: 
%    ?- readPGM('ufsc.pgm', M), writePGM('ufsc_out.pgm', M).

readPGM(FileName, I) :-
    phrase_from_file(lines(Ls), FileName),
    line_parser(Ls, [], L),
    K is 4,
    remove_elements(L, K, I).  %remove os K primeiros elementos (linhas)

remove_elements(L, 0, L) :-
    !.
remove_elements([_|T], K, I) :-
    K1 is K - 1,
    remove_elements(T, K1, I).

line_parser([], L, Ls) :-
    reverse(L, Ls).
line_parser([H|T], Z, L) :-
    substitute("   ", " ", H, B1),
    substitute("  ", " ", B1, B),
    atom_codes(C, B),
    atomic_list_concat(D, ' ', C),
    atomic_list_number(D, [], E),
    line_parser(T, [E|Z], L),
    !.

atomic_list_number([], L, Ls) :-
    reverse(L, Ls).
atomic_list_number([A|Ar], Br, L) :-
    atomic_list_number_aux(A, B),
    B =\= -1,  %inserted in 12nov2015, 17h
    atomic_list_number(Ar, [B|Br], L).
atomic_list_number([A|Ar], Br, L) :-  %inserted in 12nov2015, 17h
    atomic_list_number_aux(A, B),
    B == -1,
    atomic_list_number(Ar, Br, L).

atomic_list_number_aux(A, B) :-
    catch(atom_number(A, B), _, fail).
atomic_list_number_aux(_, -1).  %update in 12nov2015, 17h


% AUXILIARY FUNCTIONS
% -------------------------

eos([], []).

replace(_, _) --> call(eos), !.
replace(Find, Replace), Replace -->
        Find,
        !,
        replace(Find, Replace).
replace(Find, Replace), [C] -->
        [C],
        replace(Find, Replace).

substitute(Find, Replace, Request, Result):-
        phrase(replace(Find, Replace), Request, Result).    

remove([],_,[]) :- !. 
remove([X|T],X,L1) :- !, remove(T,X,L1).         
remove([H|T],X,[H|L1]) :- remove(T,X,L1).

lines([])           --> call(eos), !.
lines([Line|Lines]) --> line(Line), lines(Lines).

line([])     --> ( "\n" ; call(eos) ), !.
line([L|Ls]) --> [L], line(Ls).



%---------------------T3A--------------------------


%-----------------Negativo----------------
negativo(FileName) :-
    readPGM(FileName, Org),
    coord(Org, S),
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
    readPGM(FileName, M),
    coord(M, S),
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
    (seeNeighboorhood(L, I) ->
        nb_getval(final, W),
        insert_at((X, Y, I), W, 1, L1),
        nb_setval(final, L1),
        lonely(T_input);
        lonely(T_input)
    ).

seeNeighboorhood([], _) :-
    !.

seeNeighboorhood([(X, Y, I)|T], V) :-
    I < V,
    seeNeighboorhood(T,V).


%--------CAMINHO---------------
path(FileName, (X1, Y1, I1),(X2,Y2,I2),Path) :-
    readPGM(FileName, S),
    coord(S, SS),
    travel(SS, (X1,Y1,I1),(X2,Y2,I2),[(X1,Y1,I1)],Q),
    reverse(Q,Path).


travel(S, (X1,Y1,I1),(X2,Y2,I2),P,[B|P]) :-
    n4(S, (X1,Y1,I1),W),
    runN4(W, (X2,Y2,I2)).

runN4([], (_,_,_)) :- false.

runN4([(X,Y,I)|Rabo], (R,C,I)) :-
    (X,Y,I) = (R,C,I),
    runN4(Rabo, (R,C,I)).


travel(S, (X1,Y1,I1),(X2,Y2,I2),Visited,Path) :-
    n4(S, (X1,Y1,I1), W),
    calcPath(W, (X1,Y1,I1), (X2,Y2,I2), Visited, Path).


calcPath([(X,Y,I)|Rabo], (X1,Y1,I1),(X2,Y2,I2),Visited,Path) :-
    write('U'),
    (X,Y,I) \== (X2,Y2,I2),
    \+member((X,Y,I),Visited),
    calcPath(Rabo, (X,Y,I),(X2,Y2,I2),[(X,Y,I)|Visited],Path).


%-------MEDIA----------
average(FileName1, FileName2) :-
    readPGM(FileName1, M1),
    coord(M1, S),
    readPGM(FileName2, M2),
    coord(M2, J),
    average(S, J, W),
    coord2matrix(W, L),
    atom_concat('Media', '_out.pgm', NewM),
    writePGM(NewM, L).

average([], [], []) :-
    !.
average([(X, Y, I)|T_input], [(_, _, K)|L_input] ,[H_output|T_output]) :-
    New_intensity is (I + K)/2,
    copy_term((X, Y, New_intensity), H_output),
    average(T_input, L_input, T_output).

%-------------New func-------------
remove_at(X,[X|Xs],1,Xs).
remove_at(X,[Y|Xs],K,[Y|Ys]) :-
    K > 1, 
    K1 is K - 1,
    remove_at(X,Xs,K1,Ys).
insert_at(X,L,K,R) :- remove_at(X,R,K,L).


%--------- New function / Color Checker ----------
% This function checks whether the image have more 
% black or white pixels in its constituion.
%
% Examples:
%
%   ?- checkColor('tests/test_black.pgm')
%   The given picture is more black than white.
%   true.
%   
%   ?- checkColor('tests/test_white.pgm')
%   The given picture is whiter than black.
%   true.
%
%   ?- checkColor('tests/test_grey.pgm')
%   Wow, the given picture is black and white in the same proportion.
%   true.
%
colorChecker([]) :-
    !.

colorChecker([(X, Y, V)|T_input]) :-
    nb_getval(intensity, Intensity),
    (V >= 128 -> NewValue is Intensity + 1 ; NewValue is Intensity - 1),
    nb_setval(intensity, NewValue),
    colorChecker(T_input).

checkColor(Filename) :-
    readPGM(Filename, Load),
    coord(Load, S),
    nb_setval(intensity, 0),
    colorChecker(S),
    nb_getval(intensity, Intensity),
    (Intensity == 0 -> 
        write('Wow, the given picture is black and white in the same proportion.') ;
        (Intensity > 0 -> write('The given picture is more black than white.') ; write('The given picture is whiter than black.')) ).

% TESTS
% -------------------------
/*
   Examples:

      ?- matrix(M), coord(M,S), getPixel(S,(0,0,V)).
      M = [[4, 0, 0, 0, 0, 0, 0, 0|...], [1, 1, 0, 0, 1, 9, 0|...], [0, 1, 0, 0, 1, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 3, 0|...], [0, 7, 1|...], [0, 0|...], [0|...], [...|...]|...],
      S = [ (0, 0, 4), (0, 1, 0), (0, 2, 0), (0, 3, 0), (0, 4, 0), (0, 5, 0), (0, 6, 0), (0, ..., ...), (..., ...)|...],
      V = 4.

      ?- matrix(M), coord(M,S), above(S,(1,0,V),X).
      M = [[4, 0, 0, 0, 0, 0, 0, 0|...], [1, 1, 0, 0, 1, 9, 0|...], [0, 1, 0, 0, 1, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 3, 0|...], [0, 7, 1|...], [0, 0|...], [0|...], [...|...]|...],
      S = [ (0, 0, 4), (0, 1, 0), (0, 2, 0), (0, 3, 0), (0, 4, 0), (0, 5, 0), (0, 6, 0), (0, ..., ...), (..., ...)|...],
      X = (0, 0, 4).

      ?- matrix(M), coord(M,S), n4(S,(1,4,V),X).
      M = [[4, 0, 0, 0, 0, 0, 0, 0|...], [1, 1, 0, 0, 1, 9, 0|...], [0, 1, 0, 0, 1, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 3, 0|...], [0, 7, 1|...], [0, 0|...], [0|...], [...|...]|...],
      S = [ (0, 0, 4), (0, 1, 0), (0, 2, 0), (0, 3, 0), (0, 4, 0), (0, 5, 0), (0, 6, 0), (0, ..., ...), (..., ...)|...],
      X = [ (0, 4, 0), (2, 4, 1), (1, 3, 0), (1, 5, 9)].

      ?- matrix(M), coord(M,S), getPixel(S,(5,1,V)), putPixel((5,1,777),S,S1), getPixel(S1,(5,1,V1)).
      M = [[4, 0, 0, 0, 0, 0, 0, 0|...], [1, 1, 0, 0, 1, 9, 0|...], [0, 1, 0, 0, 1, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 3, 0|...], [0, 7, 1|...], [0, 0|...], [0|...], [...|...]|...],
      S = [ (0, 0, 4), (0, 1, 0), (0, 2, 0), (0, 3, 0), (0, 4, 0), (0, 5, 0), (0, 6, 0), (0, ..., ...), (..., ...)|...],
      V = 7,
      S1 = [ (0, 0, 4), (0, 1, 0), (0, 2, 0), (0, 3, 0), (0, 4, 0), (0, 5, 0), (0, 6, 0), (0, ..., ...), (..., ...)|...],
      V1 = 777

      verifyFinalCoord((R1,C1,I1),(R2,C2,I2)) :-
    R1 = R2,
    C1 = C2,
    !.

verifyLoop([], _) :-
    false.
verifyLoop([(X, Y, _)|T], (R, C, I)) :-
    (X = Xs, Y = Ys ->  true; check_loop(T, (R, C, I))).

checkNeighboorhood([], (R1,C1,I1), (R2,C2,I2), (X, Y, I)) :-
    X is R1,
    Y is C1,
    I is I1.

checkNeighboorhood([(X, Y, I)|Tail], (R1,C1,I1), (R2,C2,I2), Higher) :-
    (verifyFinalCoord((R1,C1,I1),(R2,C2,I2)) -> 
        checkNeighboorhood([], (R1,C1,I1),(R2,C2,I2), Higher);
        (I >= I1 ->
            checkNeighboorhood(Tail, (X,Y,I), (R2,C2,I2), Higher);
            checkNeighboorhood(Tail, (R1,C1,I1), (R2,C2,I2), Higher)
        )
    ).

existPath([], _, _,Comp , Output) :-
    reverse(Comp, Output).

existPath(FileName, (R1, C1, _), (R2, C2, _), Comp, Output) :-
    readPGM(FileName, M),
    coord(M, S),
    getPixel(S, (R1,C1,I1)),
    getPixel(S, (R2,C2,I2)),
    (R1 = R2, C1 = C2 -> 
        write('Path has been found:'), nl,
        reverse([(R1, C1, I1)|Comp], Output),
        true;
        n4(S, (R1,C1,I1), List),
        intersection(List, Comp, Intersection),
        subtract(List, Intersection, Nlist),
        checkNeighboorhood(Nlist, (R1,C1,I1),(R2, C2, I2), Higher),
        (verifyLoop(Comp, Higher) ->
            write('None path has been found'), nl,
            reverse([(R1,C1,I1)|Comp], Output);
            existPath(FileName, Higher, (R2, C2, I2), [(R1,C1,I1)|Comp], Output)
        )
    ).

*/