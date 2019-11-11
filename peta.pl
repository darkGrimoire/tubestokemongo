:- dynamic(tinggipeta/1).
:- dynamic (lebarpeta/1).
:- dynamic(isGym/1).

init_map :-
    random(10,20,X),
    random(10,20,Y),
    asserta(lebarpeta(X)),asserta(tinggieta(Y)),!.
    random(10,20,X),
    random(10,20,Y),
    asserta(isGym(X,Y)).
 

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
 	Ymax is T +1,
 	Y =:= Ymax.


 printMap(X,Y):-
 	isBorderKiri(X,Y),!, write('X').
 printMap(X,Y):-
 	isBorderKanan(X,Y),!,write('X').
 printMap(X,Y):-
 	isBorderBawah(X,Y),!,write('X').
 printMap(X,Y):-
 	isBorderAtas(X,Y),!, write('X').
 printMap(X,Y):-
    isGym(X,Y),!, write('G').
 printprio(X,Y):-
    isBorderKanan(X,Y),!, wirte('X').
 printprio(X,Y):-
    isBorderKiri(X,Y),!, write('X').
 printprio(X,Y):-
    isBorderAtas(X,Y),!, write('X').
 printprio(X,Y):-
    isBorderBawah(X,Y),!, write('X').
 printprio(X,Y):-
    isGym(X,Y),!, write('G').
   
 
    
