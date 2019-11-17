:- dynamic(pos/2).
:- dynamic(maxTokemon/1).
:- dynamic(tokemon/6).
:- dynamic(inventory/6).
:- dynamic(gameStarted/1).
:- dynamic(alreadyHeal/1).

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
	findall(B, inventory(B,_,_,_,_,_), ListTokemon),
	length(ListTokemon, Banyak), !.

cekBanyakLegendaryTokemon(Banyak) :-
	findall(_, inventory(_, legendary, _, _, _, _), ListTokemon),
	length(ListTokemon, Banyak), !.

%Nambahin tokemon, cek dulu banyak tokemon di database

addTokemon(_,_,_,_,_,_) :-
	cekBanyakTokemon(Banyak),
	maxTokemon(Maks),
	(Banyak+1) > Maks , !, fail.

addTokemon(Tokemon, Type, Elemental, HP, Atk, SpAtk) :-
	asserta(inventory(Tokemon, Type, Elemental, HP, Atk, SpAtk)).

%kalau mau drop pokemon

drop(X) :-
	\+inventory(X,_,_,_,_,_),
	write('You do not have tokemon '), write(X), nl,
	write('Mari kita cari Tokemon tersebut dan lawan  tokemon - tokemon lain!!'), nl.

drop(X) :-
	retract(inventory(X,_,_,_,_,_)),
	write('You have dropped tokemon '), write(X), nl.


%kalau mau heal tokemon

heal :-
	pos(X,_), isGym(A,_), X \== A,
	write('You are not in the gym, Butuh beberapa langkah lagi untuk menuju gym'), nl,
	write('Pergi ke gym, kasih suntikan energy untuk tokemon - tokemonmu'),nl,!.

heal :-
	pos(_,Y), isGym(_,B), Y \== B,
	write('You are not in the gym, Butuh beberapa langkah lagi untuk menuju gym'), nl,
	write('Pergi ke gym, kasih suntikan energy untuk tokemon - tokemonmu'),nl,!.

heal :-
	pos(X,Y), isGym(A,B), X =:= A, Y =:= B, alreadyHeal(_),
	write('You already heal the tokemons, cannot do it again :('), nl,!.


heal :-
	pos(X,Y), isGym(A,B), X =:= A, Y =:= B, \+alreadyHeal(_),
	forall(inventory(Tokemon, Type, Elemental, _, Atk, SpAtk), (

		isTokemon(Tokemon, _, _, MaxHP, _, _),
		retract(inventory(Tokemon, _, _, _, _, _)),
		asserta(inventory(Tokemon, Type, Elemental, MaxHP, Atk, SpAtk))

		)),

	write('Semua tokemon sudah di-heal!!! yey :D '), nl,
	write('Sekarang Tokemon Anda, dalam kondisi terbaik dan siap untuk memburu Tokemon Legendary'), nl, !.
	asserta(alreadyHeal(sudah)), !.


%jalan

%gabisa jalan ke atas
s :-
	pos(_,Y),
	tinggipeta(Z),
	Y =:= Z, 
	write('Wahhh Anda sudah berkeliling sampai ke penjuru selatan dunia!!'), nl,
	write('Anda perlu berbalik dan mencari Tokemon di penjuru dunia lain!!'),!.

%bisa jalan ke atas
s:-
	pos(X,Y),
	isObstacle(A,B),
	Y =:= B,
	X =:= A,
	write('Perjalan Anda terhalang oleh tembok besar!'),nl,
	write('Anda harus putar balik dan cari jalan yang lebih aman!'),nl,!.
s :-
	retract(pos(X,Y)),
	tinggipeta(Z),
	Y < Z,
	YNew is Y+1,
	asserta(pos(X,YNew)),!.

w :-
	pos(_,Y),
	Y =:= 1, 
	write('Wahhh Anda sudah berkeliling sampai ke penjuru utara dunia!!'), nl,
	write('Anda perlu berbalik dan mencari Tokemon di penjuru dunia lain!!'),!.

w :-
	retract(pos(X,Y)),
	Y > 1,
	YNew is Y-1,
	asserta(pos(X,YNew)),!.
w:-
	pos(X,Y),
	isObstacle(A,B),
	Y =:= B,
	X =:= A,
	write('Perjalan Anda terhalang oleh tembok besar!'),nl,
	write('Anda harus putar balik dan cari jalan yang lebih aman!'),nl,!.
a :-
	pos(X,_),
	X =:= 1, 
	write('Wahhh Anda sudah berkeliling sampai ke ujung barat dunia!!'), nl,
	write('Anda perlu berbalik dan mencari Tokemon di penjuru dunia lain!!'),!.

a :-
	retract(pos(X,Y)),
	X > 1,
	XNew is X-1,
	asserta(pos(XNew,Y)),!.
a:-
	pos(X,Y),
	isObstacle(A,B),
	Y =:= B,
	X =:= A,
	write('Perjalan Anda terhalang oleh tembok besar!'),nl,
	write('Anda harus putar balik dan cari jalan yang lebih aman!'),nl,!.

d :-
	pos(X,_),
	lebarpeta(Z),
	X =:= Z, 	
	write('Wahhh Anda sudah berkeliling sampai ke ujung timur dunia!!'), nl,
	write('Anda perlu berbalik dan mencari Tokemon di penjuru dunia lain!!'),!.
d :-
	retract(pos(X,Y)),
	lebarpeta(Z),
	X < Z,
	XNew is X+1,
	asserta(pos(XNew,Y)),!.
d:-
	pos(X,Y),
	isObstacle(A,B),
	Y =:= B,
	X =:= A,
	write('Perjalan Anda terhalang oleh tembok besar!'),nl,
	write('Anda harus putar balik dan cari jalan yang lebih aman!'),nl,!.



%cek status

status :-
	\+gameStarted(_),
	write('You cannot do this, start the game first!!'), nl, !.

status :-
	pos(X,Y),
	write('You are currently in coordinate '), write(X), write(','), write(Y), nl,

	cekBanyakTokemon(Banyak),
	write('You have acquired '), write(Banyak), write(' tokemons!!'), nl, N is 1,
	forall(inventory(Tokemon, Type, Elemental, HP, Atk, SpAtk), (

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