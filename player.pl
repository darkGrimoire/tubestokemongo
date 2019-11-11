
:- include('peta.pl').

%contoh data

%--------------------------------------------------------------------------
%------------------- player.pl STARTS HERE --------------------------------
%--------------------------------------------------------------------------

%inisialisasi fakta player, masukin ke init_player

init_player :-
    asserta(tokemon(catamon,normal,water,1000,15,45)),
    asserta(pos(5,6)),
	maxTokemon(6).


%cari banyak tokemon yang lagi dipunya

cekBanyakTokemon(banyak) :-
	findall(B, tokemon(B,_,_,_,_,_), ListTokemon),
	length(ListTokemon, banyak).


%Nambahin tokemon, cek dulu banyak tokemon di database

addTokemon(_,_,_,_,_,_) :-
	cekBanyakTokemon(banyak),
	maxTokemon(Maks),
	(banyak+1) > Maks , !, fail.

addTokemon(Tokemon, Type, Elemental, HP, Atk, SpAtk) :-
	asserta(tokemon(Tokemon, Type, Elemental, HP, Atk, SpAtk)).


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



%status





