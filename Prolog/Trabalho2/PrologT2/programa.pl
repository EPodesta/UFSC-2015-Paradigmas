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


% Inicializa o programa chamando o predicado new0.
:- initialization(new0).

% Coloca tartaruga no centro da tela (de 1000x1000) [criar uma nova tartaruga].
% É verificado se existe um xylast, caso exista é adicionado um novo ponto onde estava o xylast.
% É utilizado o próprio "uselapis" para isso, pois nele já temos a inserção de um ponto de acordo com
% o xylast e o IdAtual do programa.
% Caso contrário, criamos um novo ponto na posição 500, 500, note que agora é utilizado o uselapis junto
% com a inserção de um ponto com "new(Id, 500, 500)", isso deve-se ao fato que quando o "uselapis" for chamado
% como é a primeira execução, pois não existe um xylast, ele não adicionará um novo ponto como mencionado 
% anteriormente. Logo, quando for a primeira execução é adicionado um ponto no 500, 500 e criado um Id do "zero".
% Caso seja uma execução nova do programa, é utilizado o Id mais atual, de outra execução, e o ponto onde a tartaruga
% parou. Com cada execução, o Id será modificado.
% É importante salientar que a tartaruga começa, na perspectiva do usuário, em 90 graus para baixo.

new0 :-
    consult('gramatica.pl'),
    load,
    (existeXyLast -> xylast(X, Y),
    idlast(Nid),
    nb_setval(nID, Nid),
    uselapis;
    newAng(90),
    nb_setval(nID, -1),
    uselapis,
    nb_getval(atualId, Id),
    new(Id, 500, 500),
    asserta(xylast(500, 500)),   
    true).

existeXyLast :- xylast(_,_), !.

% É criado um novo ângulo no banco de dados. Não faz sentido repetir este comando, pois ele será usado
% indiretamente pelo giraesquerda e giradireita.
newAng(A) :- 
    retractall(ang(_)),
    asserta(ang(A)).

% Limpa os desenhos e reinicia no centro da tela (de 1000x1000)
% É dado um "reset" no desenho, limpamos todo o banco de dados de "xy", é resetado o IdAtual. Após isso,
% é contruido um novo ponto, no centro da tela, e adiconado um novo xylast para referenciar o centro da
% tela. Isto é, neste predicado é feito um "reset", como se fosse a primeira execução do programa.
tartaruga :-
    retractall(lastCmd(_,_)),
    asserta(lastCmd(tartaruga, 0)),
    retractall(xy(_,_,_)),
    nb_setval(nID, -1),
    uselapis,
    nb_getval(atualId, Id),
    new(Id, 500, 500),
    retractall(xylast(_,_)),
    asserta(xylast(500, 500)).

% Para frente N passos
% Neste predicado é feita uma série de operações matemáticas para calcular o quanto a tartaruga andará de acordo com o seu ângulo.
% Após estas operações, é verificado se a variável global "lapis" está em 1("setada"), caso esteja criamos um novo ponto xy no banco de dados para ser feito o desenho.
% Caso contrário, não adicionamos um novo ponto, pois o lápis não está no "papel", com isso a tartaruga andará sem marcar.
parafrente(N) :-
    retractall(lastCmd(_,_)),
    asserta(lastCmd(parafrente, N)),
    ang(G),

    XargP is (G*pi)/180,
    Xarg is cos(XargP)*N,
    Xnovo is Xarg,

    YargP is (G*pi)/180,
    Yarg is sin(YargP)*N,
    Ynovo is Yarg,


    nb_getval(lapis, L),
    nb_getval(atualId, Id),
    xylast(X, Y),
    (L =:= 1 -> new(Id, Xnovo, Ynovo), retractall(xylast(_, _)),
    Xn is X + Xnovo,
    Yn is Y + Ynovo,
    asserta(xylast(Xn, Yn));
    retractall(xylast(_, _)),
    Xn is X + Xnovo,
    Yn is Y + Ynovo,
    asserta(xylast(Xn, Yn))).

% Para tras N passos
% Este predicado opera da mesma forma que o anterior, contudo multiplicamos o resultado da equação por -1
% fazendo com que ele ande para tras no desenho.
paratras(N) :- 
    retractall(lastCmd(_,_)),
    asserta(lastCmd(paratras, N)),
    ang(G),

    XargP is (G*pi)/180,
    Xarg is cos(XargP)*N,
    Xnovo is Xarg*(-1),

    YargP is (G*pi)/180,
    Yarg is sin(YargP)*N,
    Ynovo is Yarg*(-1),


    nb_getval(lapis, L),
    nb_getval(atualId, Id),
    xylast(X, Y),
    (L =:= 1 -> new(Id, Xnovo, Ynovo), retractall(xylast(_, _)),
    Xn is X + Xnovo,
    Yn is Y + Ynovo,
    asserta(xylast(Xn, Yn));
    retractall(xylast(_, _)),
    Xn is X + Xnovo,
    Yn is Y + Ynovo,
    asserta(xylast(Xn, Yn))).


% Gira a direita G graus.
% É somado o valor G ao valor do ângulo já existente.
% É considerado a direta da tartaruga.
giradireita(G) :- 
    retractall(lastCmd(_,_)),
    asserta(lastCmd(giradireita, G)),
    ang(H),
    NewG is H + G,
    newAng(NewG).

% Gira a esquerda G graus.
% É subtraido o valor do G ao valor do ângulo já existente.
% É considerado a esquerda da tartaruga.
giraesquerda(G) :- 
    retractall(lastCmd(_,_)),
    asserta(lastCmd(giraesquerda, G)),
    ang(H),
    NewG is H - G,
    newAng(NewG).


% Use nada (levanta lapis)
usenada :- 
    retractall(lastCmd(_,_)),
    asserta(lastCmd(usenada, 0)),
    nb_setval(lapis, 0).

% Use lapis.
% Esse predicado será responsável por colocar a variável global "lapis" em 1, para mostrar que o lápis está no papel.
% Ele será responsável, também, por modificar o Id atual toda vez que ele for chamado, fazendo com que os desenhos sejam
% independentes, para isso é atribuido a um elemento do banco de dados o valor do idAtual. Caso o uselapis estaja sendo 
% executado pela primeira vez(a chamada veio do "new0"), ele apenas retornará "true", pois o "new0" será responsável por adicionar
% o ponto na primeira execução. Nas próximas execuções do "uselapis", ele que adicionará o novo ponto, esse ponto será o 
% xylast.
uselapis :- 
    retractall(lastCmd(_,_)),
    asserta(lastCmd(uselapis, 0)),
    nb_setval(lapis, 1),
    nb_getval(nID, Ul),
    U is Ul + 1,
    nb_setval(nID, U),
    retractall(idlast(_)),
    asserta(idlast(U)),
    atom_concat(id, U, NewId),
    nb_setval(atualId, NewId),
    (U >= 1 ->
    xylast(X, Y),
    new(NewId, X, Y); true).

% Nova Funcionalidade: Esse predicado será responsável por repetir N vezes o último comando dado ao programa.
repitaUltimoComando(N) :-
    lastCmd(Num, Valor),
    between(1, N, K),
    (Num = parafrente -> parafrente(Valor);
        (Num = paratras -> paratras(Valor);
            (Num = giradireita-> giradireita(Valor);
                (Num = giraesquerda -> giraesquerda(Valor);
                    (Num = newAng -> newAng(Valor);
                        (Num = usenada -> usenada;
                            (Num = uselapis -> uselapis
                            )
                        )
                    )
                )
            )
        )
    ),
    false; true.


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
    retractall(xylast(_,_)),
    retractall(ang(_)),
    retractall(idlast(_)),
    retractall(lastCmd(_,_)),
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
    listing(idlast),
    listing(lastCmd),
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