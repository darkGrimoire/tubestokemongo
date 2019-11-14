:- include('peta.pl').
:- dynamic(pos/2).
:- dynamic(maxTokemon/1).
:- dynamic(tokemon/6).
:- dynamic(inventory/6).
:- dynamic(gameStarted/1).

%contoh data

%--------------------------------------------------------------------------
%------------------- player.pl STARTS HERE --------------------------------
%--------------------------------------------------------------------------

%inisialisasi fakta player, masukin ke init_player

init_player :-
    asserta(inventory(catamon,normal,water,1000,15,45)),
    asserta(pos(5,6)), %bisa dirandom juga mungkin ini posisi awalnya (?)
	asserta(maxTokemon(6)).


%cari banyak tokemon yang lagi dipunya

cekBanyakTokemon(Banyak) :-
	findall(B, tokemon(B,_,_,_,_,_), ListTokemon),
	length(ListTokemon, Banyak).


%Nambahin tokemon, cek dulu banyak tokemon di database

addTokemon(_,_,_,_,_,_) :-
	cekBanyakTokemon(Banyak),
	maxTokemon(Maks),
	(Banyak+1) > Maks , !, fail.

addTokemon(Tokemon, Type, Elemental, HP, Atk, SpAtk) :-
	asserta(inventory(Tokemon, Type, Elemental, HP, Atk, SpAtk)).


%jalan

%gabisa jalan ke atas
w :-
	pos(_,Y),
	tinggipeta(Z),
	Y =:= Z, 
	write('Jalan anda menuju utara terhalang tembok besar!!'), nl, !.

%bisa jalan ke atas
w :-
	retract(pos(X,Y)),
	tinggipeta(Z),
	Y < Z,
	YNew is Y+1,
	asserta(pos(X,YNew)),!.

s :-
	pos(_,Y),
	Y =:= 1, 
	write('Jalan anda menuju selatan terhalang tembok besar!!'), nl, !.

s :-
	retract(pos(X,Y)),
	Y > 1,
	YNew is Y-1,
	asserta(pos(X,YNew)),!.

a :-
	pos(X,_),
	X =:= 1, 
	write('Jalan anda menuju barat terhalang tembok besar!!'), nl, !.

a :-
	retract(pos(X,Y)),
	X > 1,
	XNew is X-1,
	asserta(pos(XNew,Y)),!.

d :-
	pos(X,_),
	lebarpeta(Z),
	X =:= Z, 
	write('Jalan anda menuju timur terhalang tembok besar!!'), nl, !.

d :-
	retract(pos(X,Y)),
	lebarpeta(Z),
	X < Z,
	XNew is X+1,
	asserta(pos(XNew,Y)),!.



%cek status

status :-
	\+gameStarted(_),
	write('You cannot do this, start the game first!!'), nl, !.

status :-
	pos(X,Y),
	write('You are currently in coordinate '), write(X), write(','), write(Y), nl,

	cekBanyakTokemon(Banyak),
	write('You have acquired '), write(Banyak), write(' tokemons!!'), nl, N is 1,
	forall(tokemon(Tokemon, Type, Elemental, HP, Atk, SpAtk), (

		write(N), write(' --> '), write('Name: '), write(Tokemon), nl,
		write('      Type: '), write(Type), nl,
		write('      Elemental: '), write(Elemental), nl,
		write('      Current HP: '), write(HP), nl,
		write('      Attack: '), write(Atk), nl,
		write('      Special Attack: '), write(SpAtk), nl

		)),
	write('Here are the legendary tokemons you still have to seek...'), nl, N is 1,
	forall(tokemon(Tokemon, legendary, Elemental, HP, Atk, SpAtk), (

		write(N), write(' --> '), write('Name: '), write(Tokemon), nl,
		% write('      Type: '), write(Type), nl,
		write('      Elemental: '), write(Elemental), nl,
		write('      Current HP: '), write(HP), nl,
		write('      Attack: '), write(Atk), nl,
		write('      Special Attack: '), write(SpAtk), nl


		)).