:- dynamic(tinggipeta/1).
:- dynamic (lebarpeta/1).
:- dynamic(isGym/2).
%:- dynamic(random/3).

init_map :-
    random(10,20,X),
    random(10,20,Y),
    asserta(lebarpeta(X)),asserta(tinggipeta(Y)),!,
    TMax is Y+1,
    LMax is X+1,
    random(1,TMax,A),
    random(1,LMax,B),
    asserta(isGym(A,B)).
 
/*
 isBorderAtas(_,Y):-
 	Y =:= 0,
 	!.
 isBorderBawah(X,_):-
 	X =:= 0,
 	!.
 isBorderKanan(X,_):-
 	tinggipeta(T),
 	Xmax is T+1,
 	X =:= Xmax,

 	!.
 isBorderKiri(_,Y):-
 	lebarpeta(T),
 	Ymax is T+1,
 	Y =:= Ymax.
*/

 isBorderAtas(X,_):-
    tinggipeta(T),
    Xmax is T+1,
    X =:= Xmax,
    !.
 isBorderBawah(X,_):-
    X =:= 0,
    !.

 isBorderKanan(_,Y):-
    lebarpeta(T),
    Ymax is T+1,
    Y =:= Ymax,
    !.

 isBorderKiri(_,Y):-
    Y =:= 0,
    !.


 printMap(X,Y):-
 	isBorderKiri(X,Y),!, write('X').
 printMap(X,Y):-
 	isBorderKanan(X,Y),!,write('X').
 printMap(X,Y):-
 	isBorderBawah(X,Y),!,write('X').
 printMap(X,Y):-
 	isBorderAtas(X,Y),!, write('X').
 printMap(X,Y):-
    pos(X,Y),!, write('P').
 printMap(X,Y):-
    isGym(X,Y),!, write('G').
 printMap(_,_):-
    write('-').
 printprio(X,Y):-
    isBorderKanan(X,Y),!, write('X').
 printprio(X,Y):-
    isBorderKiri(X,Y),!, write('X').
 printprio(X,Y):-
    isBorderAtas(X,Y),!, write('X').
 printprio(X,Y):-
    isBorderBawah(X,Y),!, write('X').
 printprio(X,Y):-
    isGym(X,Y),!, write('G').
   
 
    
