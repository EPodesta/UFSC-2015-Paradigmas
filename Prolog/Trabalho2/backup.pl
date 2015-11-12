/* Emmanuel Podestá Junior, Fernando Paladini, Lucas Ribeiro Neis.

   Programacao Logica - Prof. Alexandre G. Silva - 30set2015
   
   RECOMENDACOES:
   
   - O nome deste arquivo deve ser 'programa.pl'
   
   - O nome do banco de dados deve ser 'desenhos.pl'
   
   - Dicas de uso podem ser obtidas na execucação: 
     ?- menu.
     
   - Exemplo de uso:
     ?- load.
     ?- searchAll(id1).
     
   - [Done] change. Done and ready for test.
      * [Done] returning "false", I think it should return "true" instead (more friendly)
      * [Done] When we got two or more identifiers (id40, id50 and so on), this method changes
        the correct point, but "deletes" all points from different identifiers.

        How to reproduce:
          xy(id40, 0, 250).
          xy(id40, 10, 10).
          xy(id50, 30, 30).
          xy(id50, 0, -2).
          xy(id50, 40, 78).
          xy(id60, 10000, 10000).

        Then change some identifier calling change(id50, 0, -2, 10000, 10000).

   - [Not a problem] changeFirst. Done and ready for test.
      * Not changing only the first when points with same value appears:
            xy(id40, 0, 250).
            xy(id40, 0, 250).

        This will change both values. Actually don't know if it is a real problem.
        Anyway, can be easily solved just picking up the first point and ignoring others.

   - [Done] changeLast. Done and ready for test.
      * [Done] Couldn't test because the following error:
          ?- changeLast(id50, 200, 20004).
          ERROR: lUltimo/2: Undefined procedure: l/2
          Exception: (9) l([[id50, 0, -200]], _G566) ? 

   - searchFirst. Done and ready for test.
      * Okay.

   - searchLast. Done and ready for test.
      * Okay.

   - undo.

   - remove. Done and ready for test.
      * Okay.

   - quadrado. Done and ready for test.
      * Okay.

   - figura. Done and ready for test.
      * Okay.
      
   - replica.
   - Colocar o nome e matricula de cada integrante do grupo
     nestes comentarios iniciais do programa. Done.


     Parte 2:

     RECOMENDACOES:
   
   - O nome deste arquivo deve ser 'programa.pl'
   - O nome do banco de dados deve ser 'desenhos.pl'
   - O nome do arquivo de gramatica deve ser 'gramatica.pl'
   
   - Dicas de uso podem ser obtidas na execucação: 
     ?- menu.
     
   - Exemplo de uso:
     ?- load.
     ?- searchAll(id1).

   - Exemplo de uso da gramatica:
     ?- comando([repita, '8', '[', pf, '50', gd, '45', ']'], []).
     Ou simplesmente:
     ?- cmd("repita 8[pf 50 gd 45]").
     
   - Colocar o nome e matricula de cada integrante do grupo
     nestes comentarios iniciais do programa
*/



%:- initialization(new0(Id)).

% Coloca tartaruga no centro da tela (de 1000x1000) [criar uma nova tartaruga].
% Implementacao incompleta:
%   - Considera apenas id1 e efetua new sem verificar sua existencia
%   - Supoe que ha o xylast em 'desenhos.pl'

new0(Id) :-
    consult('gramatica.pl'),
    load,
    uselapis,
    ( existXylast(Id) -> xylast(Id, X, Y),     
    newAng(Id, 90),
    new(Id, X, Y),
    retractall(xylast(Id,_,_)),
    asserta(xylast(Id, X, Y));
    newAng(Id, 90),
    new(Id, 500, 500),
    asserta(xylast(Id, 500, 500)),
    true).


existXylast(Id) :-
    xylast(Id,_,_), !.


newAng(Id, A) :- 
    retractall(ang(Id,_)),
    asserta(ang(Id, A)).

% Limpa os desenhos e reinicia no centro da tela (de 1000x1000)
% Implementacao incompleta:
%   - Considera apenas id1
tartaruga(Id) :-
    retractall(xy(Id,_,_)),
    new(Id, 500, 500),
    retractall(xylast(Id,_,_)),
    asserta(xylast(Id, 500, 500)).

% Para frente N passos
% Implementacao incompleta:
%   - Considera apenas id1
%   - Somando apenas em X, ou seja, nao considera a inclinacao da tartaruga
parafrente(N, Id) :-
    write('Revisar: pf '), writeln(N),
    xylast(Id, X, Y),
    ang(Id, G), write(G), nl,

    XargP is (G*pi)/180, write(XargP), nl,
    Xarg is cos(XargP)*N, write(Xarg), nl,
    Xnovo is Xarg, write(Xnovo), nl,

    YargP is (G*pi)/180, write(YargP), nl,
    Yarg is sin(YargP)*N, write(Yarg), nl,
    Ynovo is Yarg, write(Ynovo),

  %  (mod(G,360) =:= )



    nb_getval(lapis, L),
    (L =:= 1 -> new(Id, Xnovo, Ynovo), retractall(xylast(Id,_, _)),
    asserta(xylast(Id, Xnovo, Ynovo));
    retractall(xylast(Id,_, _)),
    asserta(xylast(Id, Xnovo, Ynovo))).

% Para tras N passos
paratras(N, Id) :- 
    write('Implementar: pt '), writeln(N),
    xylast(Id, X, Y),
    ang(Id, G), write(G), nl,

    XargP is (G*pi)/180, write(XargP), nl,
    Xarg is cos(XargP)*N, write(Xarg), nl,
    Xnovo is Xarg*(-1), write(Xnovo),

    YargP is (G*pi)/180, write(YargP), nl,
    Yarg is sin(YargP)*N, write(Yarg), nl,
    Ynovo is Yarg*(-1), write(Ynovo),

    nb_getval(lapis, L),
    (L =:= 1 -> new(Id, Xnovo, Ynovo), retractall(xylast(Id,_, _)),
    asserta(xylast(Id, Xnovo, Ynovo));
    retractall(xylast(Id,_, _)),
    asserta(xylast(Id, Xnovo, Ynovo))).

% Gira a direita G graus
giradireita(Id, G) :- 

    write('Implementar: ge '), writeln(G),
    ang(Id, H),
    NewG is H + G,
    newAng(Id, NewG).

% Gira a esquerda G graus
giraesquerda(Id, G) :- 

    write('Implementar: gd '), writeln(G),
    ang(Id, H), write(H),
    NewG is H - G,
    newAng(Id, NewG).


% Use nada (levanta lapis)
usenada :- 
    write('Implementar: un '),
    nb_setval(lapis, 0).

% Use lapis
uselapis :- 
    write('Implementar: ul '),
    nb_setval(lapis, 1).



% undo :- 
%     copy('desenhos.pl','backup.pl') :- 
%     open('desenhos.pl',read,Stream1),
%     open('backup.pl',write,Stream2),
%     copy_stream_data('desenhos.pl','backup.pl'),
%     close(File1),
%     close(File2).

undo:-
  list(A, B, C),
  retract(list(A,B,C)),
  retract(xy(A,B,C)), !.

remove(Id, X, Y) :-
    retract(xy(Id, X, Y)),
    retract(list(Id, X, Y)).

% Apaga os predicados 'xy' da memoria e carrega os desenhos a partir de um arquivo de banco de dados
load :-
    retractall(xy(_,_,_)),
    retractall(list(_,_,_)),
    retractall(xylast(_,_,_)),
    retractall(ang(_,_)),
    open('desenhos.pl', read, Stream),
    repeat,
        read(Stream, Data),
        (Data == end_of_file -> true ; assert(Data), fail),
        !,
        close(Stream).

% Ponto de deslocamento, se <Id> existente
new(Id,X,Y) :-
    xy(Id,_,_),
    assertz(xy(Id,X,Y)),
    asserta(list(Id,X,Y)),
    !.

% Ponto inicial, caso contrario
new(Id,X,Y) :-
    asserta(xy(Id,X,Y)),
    asserta(list(Id,X,Y)),
    !.

quadrado(Id, X, Y, Lado) :-
    new(Id, X, Y),
    new(Id, Lado, 0),
    nb_setval(lado, Lado),
    nb_getval(lado, New),
    Neg is New * -1,
    new(Id, 0, Lado),
    new(Id, Neg, 0).

replicaSub(Id, N, Dx, Dy) :-
    findall(Ponto, (xy(Id,X,Y), append([Id], [X], L1), append(L1, [Y], Ponto) ), All), length(All, T),
    between(0, T, K),
    nth0(K, All, V),
    nth0(0, V, Ident),
    nth0(1, V, Ex),
    nth0(2, V, Uai),
    atom_concat(Ident, N, NewIdent),
    NewEx is Ex+(Dx*N),
    NewUai is Uai+(Dy*N),
    ((K =:= 0) -> new(NewIdent, NewEx, NewUai) ; new(NewIdent, Ex, Uai)),
    false.

replica(Id,N,Dx,Dy) :-
    between(1, N, M),
    replicaSub(Id, M, Dx, Dy),
    false.

figura(Id, X, Y, Lado) :-
    nb_setval(lado, Lado),
    nb_getval(lado, New),
    Neg is New * -1,
    NegU is Neg / sqrt(2),
    LadoU is New / sqrt(2),
    new(Id, X, Y),
    new(Id, LadoU, NegU),
    new(Id, Lado, 0),
    new(Id, LadoU, LadoU),
    new(Id, 0, Lado),
    new(Id, NegU, LadoU),
    new(Id, Neg, 0),
    new(Id, NegU, NegU).

% Exibe opcoes de busca
search :-
    write('searchAll(Id).     -> Ponto inicial e todos os deslocamentos de <Id>'), nl,
    write('searchFirst(Id,N). -> Ponto inicial e os <N-1> primeiros deslocamentos de <Id>'), nl,
    write('searchLast(Id,N).  -> Lista os <N> ultimos deslocamentos de <Id>').

searchAll(Id) :-
    listing(xy(Id,_,_)).

searchFirst(Id, N) :-
    findall(Ponto, (xy(Id,X,Y), append([Id], [X], L1), append(L1, [Y], Ponto) ), All),
    nth0(0, All, M),
    write(M), nl,
    NewN is N - 1,
    (NewN >= 1 -> between(1, NewN, X),
    nth0(X, All, K),
    write(K), nl; false),
    false.

searchLast(Id, N) :-
    findall(Ponto, (xy(Id,X,Y), append([Id], [X], L1), append(L1, [Y], Ponto) ), All), length(All, Tam),
    Itera is Tam - N,
    between(Itera, Tam, X),
    nth0(X, All, K),
    write(K),
    false.

% Exibe opcoes de alteracao
change :-
    write('change(Id,X,Y,Xnew,Ynew).  -> Altera o ponto inicial de <Id>'), nl,
    write('changeFirst(Id,Xnew,Ynew). -> Altera o ponto inicial de <Id>'), nl,
    write('changeLast(Id,Xnew,Ynew).  -> Altera o deslocamento final de <Id>').

change(Id, X, Y, Xnew, Ynew) :-
    (findall(Ponto, (xy(Z,U,W), append([Z], [U], L1), append(L1, [W], Ponto) ), All), length(All, T),
    retractall(xy(_,_,_)),
    retractall(list(_,_,_)),
    between(0, T, K),
    nth0(K, All, V),
    nth0(0, V, Ident),
    nth0(1, V, Ex),
    nth0(2, V, Uai),
    ( Ident = Id, Ex = X, Uai = Y -> new(Ident, Xnew, Ynew);
    new(Ident, Ex, Uai)), false);
    true.

changeFirst(Id, Xnew, Ynew) :-
    remove(Id, _, _), !,
    asserta(xy(Id, Xnew, Ynew)),
    assertz(list(Id, Xnew, Ynew)).

changeLast(Id, Xnew, Ynew) :-
      findall(Ponto, (xy(Id,X,Y), append([Id], [X], L1), append(L1, [Y], Ponto) ), All), length(All, T),
      lUltimo(All, L),
      write(L),
      nth0(0, L, Ident),
      write(Ident),
      nth0(1, L, Ex),
      nth0(2, L, Uai),
      remove(Ident,Ex, Uai),
      assertz(xy(Id, Xnew, Ynew)),
      asserta(list(Id, Xnew, Ynew)), !.

% ler o ultimo, 
lUltimo([X], X).
lUltimo([H|T], L) :- lUltimo(T, L).
%ler todos
lAll([X], X, K).
lAll([H|T], L, K) :- lAll(T, L, K), H = K.
% Grava os desenhos da memoria em arquivo
commit :-
    open('desenhos.pl', write, Stream),
    telling(Screen),
    tell(Stream),
    listing(xy),
    listing(list),
    listing(xylast),
    listing(ang),
    tell(Screen),
    close(Stream).

% Exibe menu principal
menu :-
    write('load.        -> Carrega todos os desenhos do banco de dados para a memoria'), nl,
    write('new(Id,X,Y). -> Insere um deslocamento no desenho com identificador <Id>'), nl,
    write('                (se primeira insercao, trata-se de um ponto inicial)'), nl,
    write('search.      -> Consulta pontos dos desenhos'), nl,
    write('change.      -> Modifica um deslocamento existente do desenho'), nl,
    write('remove.      -> Remove um determinado deslocamento existente do desenho'), nl,
    write('undo.        -> Remove o deslocamento inserido mais recentemente'), nl,
    write('commit.      -> Grava alteracoes de todos dos desenhos no banco de dados').