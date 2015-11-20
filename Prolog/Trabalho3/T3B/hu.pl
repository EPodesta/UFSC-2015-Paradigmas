/*
   Hus Invariant Moments in Prolog
     Prof. A. G. Silva - UFSC - November 2015
     Based on https://github.com/shackenberg/Image-Moments-in-Python/blob/master/moments.py
*/

:- consult('img.pl').

mean_x(S, MeanX) :-
    x_times_image(S, L),
    sum(L, N1),
    sum(S, N2),
    MeanX is N1 / N2.

mean_y(S, MeanY) :-
    y_times_image(S, L),
    sum(L, N1),
    sum(S, N2),
    MeanY is N1 / N2.


% raw or spatial moments
m(S, M00, M01, M10, M02, M20, M12, M21, M03, M30) :-
    sum(S, M00),
    x_times_image(S, L1),
    sum(L1, M01),
    y_times_image(S, L2),
    sum(L2, M10),
    xn_times_image(S, 2, L3),
    sum(L3, M02),
    yn_times_image(S, 2, L4),
    sum(L4, M20),
    y2x_times_image(S, L5),
    sum(L5, M12),
    x2y_times_image(S, L6),
    sum(L6, M21),
    xn_times_image(S, 3, L7),
    sum(L7, M03),
    yn_times_image(S, 3, L8),
    sum(L8, M30).


sum([], 0).
sum([(_,_,V)|T], N) :-
    sum(T, N1),
    N is N1 + V.

x_times_image([], []).
x_times_image([(X,Y,V)|T], L) :-
    x_times_image(T, L1),
    V1 is X*V,
    append([(X,Y,V1)], L1, L).

y_times_image([], []).
y_times_image([(X,Y,V)|T], L) :-
    y_times_image(T, L1),
    V1 is Y*V,
    append([(X,Y,V1)], L1, L).

xn_times_image([], _, []).
xn_times_image([(X,Y,V)|T], N, L) :-
    xn_times_image(T, N, L1),
    V1 is X^N*V,
    append([(X,Y,V1)], L1, L).

yn_times_image([], _, []).
yn_times_image([(X,Y,V)|T], N, L) :-
    yn_times_image(T, N, L1),
    V1 is Y^N*V,
    append([(X,Y,V1)], L1, L).

x2y_times_image([], []).
x2y_times_image([(X,Y,V)|T], L) :-
    x2y_times_image(T, L1),
    V1 is X*X*Y*V,
    append([(X,Y,V1)], L1, L).

y2x_times_image([], []).
y2x_times_image([(X,Y,V)|T], L) :-
    y2x_times_image(T, L1),
    V1 is Y*Y*X*V,
    append([(X,Y,V1)], L1, L).

% central moments
mu(S, MU11, MU02, MU20, MU12, MU21, MU03, MU30) :-
    mean_x(S, MeanX),
    mean_y(S, MeanY),
    x_minus_constant(S, MeanX, L1), y_minus_constant(S, MeanY, L2), multiply(L1, L2, L3), multiply(L3, S, L4), sum(L4, MU11),
    multiply(L2, L2, L5), multiply(L5, S, L6), sum(L6, MU02),
    multiply(L1, L1, L7), multiply(L7, S, L8), sum(L8, MU20),
    multiply(L1, L5, L9), multiply(L9, S, L10), sum(L10, MU12),
    multiply(L7, L2, L11), multiply(L11, S, L12), sum(L12, MU21),
    multiply(L2, L5, L13), multiply(L13, S, L14), sum(L14, MU03),
    multiply(L1, L7, L15), multiply(L15, S, L16), sum(L16, MU30).
    

x_minus_constant([], _, []).
x_minus_constant([(X,Y,_)|T], C, L) :-
    x_minus_constant(T, C, L1),
    V1 is X - C,
    append([(X,Y,V1)], L1, L).

y_minus_constant([], _, []).
y_minus_constant([(X,Y,_)|T], C, L) :-
    y_minus_constant(T, C, L1),
    V1 is Y - C,
    append([(X,Y,V1)], L1, L).

% nao e usado sum_constant
sum_constant([], _, []).
sum_constant([(X,Y,V)|T], C, L) :-
    sum_constant(T, C, L1),
    V1 is V + C,
    append([(X,Y,V1)], L1, L).

multiply([], [], []).
multiply([(X,Y,V1)|T1], [(X,Y,V2)|T2], L) :-
    multiply(T1, T2, L1),
    V3 is V1 * V2,
    append([(X,Y,V3)], L1, L).


nu(S, NU11, NU12, NU21, NU02, NU20, NU03, NU30) :-
    sum(S, SUM),
    mu(S, MU11, MU02, MU20, MU12, MU21, MU03, MU30),
    NU11 is MU11 / SUM^(2/2+1),
    NU12 is MU12 / SUM^(3/2+1),
    NU21 is MU21 / SUM^(3/2+1),
    NU02 is MU02 / SUM^(2/2+1),
    NU20 is MU20 / SUM^(2/2+1),
    NU03 is MU03 / SUM^(3/2+1),
    NU30 is MU30 / SUM^(3/2+1).


hu(S, I1, I2, I3, I4, I5, I6, I7) :-
    nu(S, NU11, NU12, NU21, NU02, NU20, NU03, NU30),
    I1 is NU20 + NU02,
    I2 is (NU20 - NU02)^2 + 4*NU11^2,
    I3 is (NU30 - 3*NU12)^2 + (3*NU21 - NU03)^2,
    I4 is (NU30 + NU12)^2 + (NU21 + NU03)^2,
    I5 is (NU30 - 3*NU12) * (NU30 + NU12) * ( (NU30 + NU12)^2 - 3*(NU21 + NU03)^2 ) + (3*NU21 - NU03) * (NU21 + NU03) * ( 3*(NU30 + NU12)^2 - (NU21 + NU03)^2 ),
    I6 is (NU20 - NU02) * ( (NU30 + NU12)^2 - (NU21 + NU03)^2 ) + 4 * NU11 * (NU30 + NU12) * (NU21 + NU03),
    I7 is (3*NU21 - NU03) * (NU30 + NU12) * ( (NU30 + NU12)^2 - 3*(NU21 + NU03)^2 ) - (NU30 - 3*NU12) * (NU21 + NU03) * ( 3*(NU30 + NU12)^2 - (NU21 + NU03)^2 ).


% T3B
% -------------------------

addImages :-
    load,
    retractall(image(_,_,_,_,_,_,_,_)),
    new('pgm/apple-1.pgm', apple-1),
    new('pgm/bat-5.pgm', bat-5),
    commit.


load :-
    retractall(image(_,_,_,_,_,_,_,_)),
    open('huImg.pl', read, Stream),
    repeat,
        read(Stream, Data),
        (Data == end_of_file -> true ; assert(Data), fail),
        !,
        close(Stream).

commit :-
    open('huImg.pl', write, Stream),
    telling(Screen),
    tell(Stream),
    listing(image),
    tell(Screen),
    close(Stream).


new(Filename, Id) :-
    readPGM(Filename, S),
    coord(S, SS),
    hu(SS, I1,I2,I3,I4,I5,I6,I7),
    assertz(image(Id,I1,I2,I3,I4,I5,I6,I7)),
    !.

new(Id, I1,I2,I3,I4,I5,I6,I7) :-
    assertz(image(Id, I1,I2,I3,I4,I5,I6,I7)),
    !.

discoverImage(FileName) :-
    readPGM(FileName, S),
    coord(S, SS),
    hu(SS, I1,I2,I3,I4,I5,I6,I7),
    findall(E, image(E,_,_,_,_,_,_,_), All),
    compare(All, I1,I2,I3,I4,I5,I6,I7, W),
    min_list(W, Min),
    nb_setval(posicao, -1),
    min_pos(W, Min, Pos),
    nth0(Pos, All, Image),
    write(All),
    write(W),
    write(Pos),
    write(Image), nl,
    write('Is this your image?'), nl,
    read(X),
    (   
        (X = 'n'; X = 'no') ->
            write('Type the Id of the Image:'), nl,
            read(Y),
                new(Y, I1,I2,I3,I4,I5,I6,I7),
                write('Image Added.'), nl,
                commit, halt;
                ((X = 'y'; X = 'yes') ->
                    (Min =:= 0 -> write('Not adding, it\'s the same image.'), nl, halt; 
                        new(Image, I1,I2,I3,I4,I5,I6,I7),
                        write('Image Added.'), nl,
                        commit, halt
                    )
                )
    ).

min_pos([L|Ls], Min, Pos) :-
    (L =:= Min ->
        nb_getval(posicao, P),
        Pos is P + 1;
        nb_getval(posicao, P),
        NewP is P + 1,
        nb_setval(posicao, NewP),
        min_pos(Ls, Min, Pos)
    ).

list_min([], Min, Min).
list_min([L|Ls], Min0, Min) :-
    Min1 is min(L, Min0),
    nb_getval(posicao, Pos),
    NewPos is Pos + 1,
    nb_setval(posicao, NewPos),
    list_min(Ls, Min1, Min).

compare([],_,_,_,_,_,_,_,[]) :-
    !.

compare([Head|Tail], I1,I2,I3,I4,I5,I6,I7, [H_output|T_output]) :-
    image(Head,X1,X2,X3,X4,X5,X6,X7),
    distEuclidian([I1,I2,I3,I4,I5,I6,I7],[X1,X2,X3,X4,X5,X6,X7], List),
    sum_list(List, Sum),
    copy_term(Sum, H_output),
    compare(Tail,I1,I2,I3,I4,I5,I6,I7, T_output).


distEuclidian([],[],[]) :- !.

distEuclidian([I_input|I_output], [X_input|X_output], [Input|Output]) :-
    NewI is I_input,
    NewX is X_input,
    H is NewI - NewX,
    PowH is H^2,
    SqrtH is sqrt(PowH),
    copy_term(SqrtH, Input),
    distEuclidian(I_output, X_output, Output).


test :-
    coord([[20,5,1],[4,10,50],[4,2,5]], S),
    writeln(S),
    hu(S, I1, I2, I3, I4, I5, I6, I7),
    writeln(I1),
    writeln(I2),
    writeln(I3),
    writeln(I4),
    writeln(I5),
    writeln(I6),
    writeln(I7).
