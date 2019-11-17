:- dynamic(pos/2).
:- dynamic(maxTokemon/1).
:- dynamic(musuh/13).
:- dynamic(inventory/12).
:- dynamic(gameStarted/1).
:- dynamic(alreadyHeal/1).



%inisialisasi fakta player, masukin ke init_player

init_player :-
	random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA),
    asserta(inventory(catamon,normal,water,HP,5000,cakar_aja,A,cakar_banget,SA,1,0,1000)),
	asserta(maxTokemon(6)),
    tinggipeta(Height), lebarpeta(Width),
    H is Height+1, W is Width+1,
    random(1,H,Y),
    random(1,W,X),
    asserta(pos(X,Y)).


%cari banyak tokemon yang lagi dipunya

cekBanyakTokemon(Banyak) :-
	findall(B, inventory(B,_,_,_,_,_,_,_,_,_,_,_), ListTokemon),
	length(ListTokemon, Banyak), !.

cekBanyakLegendaryTokemon(Banyak) :-
	findall(_, inventory(_, legendary, _, _, _, _,_,_,_,_,_,_), ListTokemon),
	length(ListTokemon, Banyak), !.

%Nambahin tokemon, cek dulu banyak tokemon di database

addTokemon(_,_,_,_,_,_,_,_,_,_,_,_) :-
	cekBanyakTokemon(Banyak),
	maxTokemon(Maks),
	(Banyak+1) > Maks , !, fail.

addTokemon(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp) :-
	asserta(inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp)).

%kalau mau drop pokemon

drop(X) :-
	\+winbattleFlag(_),
	\+inventory(X,_,_,_,_,_,_,_,_,_,_,_),
	write('You do not have tokemon '), write(X), nl,
	write('Mari kita cari Tokemon tersebut dan lawan  tokemon - tokemon lain!!'), nl.

drop(X) :-
	\+winbattleFlag(_),
	retract(inventory(X,_,_,_,_,_,_,_,_,_,_,_)),
	write('You have dropped tokemon '), write(X), nl.

drop(X) :-
	winbattleFlag(_),
	retract(inventory(X,_,_,_,_,_,_,_,_,_,_,_)),
	write('You have dropped tokemon '), write(X), nl,
	capture,!.

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
	forall(inventory(Tokemon, Type, Elemental, _, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp), (

		retract(inventory(Tokemon, _, _, _, _, _,_,_,_,_,_,_)),
		asserta(inventory(Tokemon, Type, Elemental, MaxHP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp))

		)),

	write('Semua tokemon sudah di-heal!!! yey :D '), nl,
	write('Sekarang Tokemon Anda, dalam kondisi terbaik dan siap untuk memburu Tokemon Legendary'), nl,
	asserta(alreadyHeal(sudah)), !.


%jalan
s:-
	pos(X,Y),
	YNew is Y+1,
	isObstacle(X,YNew),map,
	write('Perjalan Anda terhalang oleh tembok besar!'),nl,
	write('Anda harus putar balik dan cari jalan yang lebih aman!'),nl,!.
s :-
	pos(_,Y),
	tinggipeta(Z),
	Y =:= Z, map,
	write('Wahhh Anda sudah berkeliling sampai ke penjuru selatan dunia!!'), nl,
	write('Anda perlu berbalik dan mencari Tokemon di penjuru dunia lain!!'),!.
s :-
	retract(pos(X,Y)),
	tinggipeta(Z),
	Y < Z,
	YNew is Y+1,
	asserta(pos(X,YNew)),map,
	ceks,!.

ceks:-
	pos(X,Y),
	isGym(X,Y),
	write('Wah Anda telah sampai di Gym'),nl,
	write('Bugarkan kembali para Tokemon Anda, dengan command: heal. '),!.
w:-
	pos(X,Y),
	YNew is Y - 1,
	isObstacle(X,YNew),map,
	write('Perjalan Anda terhalang oleh tembok besar!'),nl,
	write('Anda harus putar balik dan cari jalan yang lebih aman!'),nl,!.

w :-
	pos(_,Y),
	Y =:= 1,map, 
	write('Wahhh Anda sudah berkeliling sampai ke penjuru utara dunia!!'), nl,
	write('Anda perlu berbalik dan mencari Tokemon di penjuru dunia lain!!'),!.

w :-
	retract(pos(X,Y)),
	Y > 1,
	YNew is Y-1,
	asserta(pos(X,YNew)),map,
	cekw,!.
cekw:-
	pos(X,Y),
	isGym(X,Y),
	write('Wah Anda telah sampai di Gym'),nl,
	write('Bugarkan kembali para Tokemon Anda, dengan command: heal. '),!.
a:-
	pos(X,Y),
	XNew is X-1,
	isObstacle(XNew,Y),map,
	write('Perjalan Anda terhalang oleh tembok besar!'),nl,
	write('Anda harus putar balik dan cari jalan yang lebih aman!'),nl,!.
a :-
	pos(X,_),
	X =:= 1,map, 
	write('Wahhh Anda sudah berkeliling sampai ke ujung barat dunia!!'), nl,
	write('Anda perlu berbalik dan mencari Tokemon di penjuru dunia lain!!'),!.

a :-
	retract(pos(X,Y)),
	X > 1,
	XNew is X-1,
	asserta(pos(XNew,Y)),map,ceka,!.
ceka:-
	pos(X,Y),
	isGym(X,Y),
	write('Wah Anda telah sampai di Gym'),nl,
	write('Bugarkan kembali para Tokemon Anda, dengan command: heal. '),!.

d:-
	pos(X,Y),
	XNew is X+1,
	isObstacle(XNew,Y),map,
	write('Perjalan Anda terhalang oleh tembok besar!'),nl,
	write('Anda harus putar balik dan cari jalan yang lebih aman!'),nl,!.

d :-
	pos(X,_),
	lebarpeta(Z),
	X =:= Z,map, 	
	write('Wahhh Anda sudah berkeliling sampai ke ujung timur dunia!!'), nl,
	write('Anda perlu berbalik dan mencari Tokemon di penjuru dunia lain!!'),!.
d :-
	retract(pos(X,Y)),
	lebarpeta(Z),
	X < Z,
	XNew is X+1,
	asserta(pos(XNew,Y)),map,cekd,!.
cekd:-
	pos(X,Y),
	isGym(X,Y),
	write('Wah Anda telah sampai di Gym'),nl,
	write('Bugarkan kembali para Tokemon Anda, dengan command: heal. '),!.



%cek status

status :-
	\+gameStarted(_),
	write('You cannot do this, start the game first!!'), nl, !.

status :-
	pos(X,Y),
	write('You are currently in coordinate '), write(X), write(','), write(Y), nl,

	cekBanyakTokemon(Banyak), cekBanyakLegendaryTokemon(BanyakLegendary)
	write('You have acquired '), write(Banyak), write(' tokemons!!'), nl, N is 1,
	write('...dengan '), write(BanyakLegendary), write(' di antaranya adalah legendary! WOW!'),
	forall(inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp), (

		write('  --> '), write('Name: '), write(Tokemon), nl,
		write('      Type: '), write(Type), nl,
		write('      Elemental: '), write(Elemental), nl,
		write('      Health: '), write(HP), nl,
		write('      Nama Skill Attack: '), write(NamaAtk), nl,
		write('      Attack: '), write(Atk), nl,
		write('      Nama Skill Special Attack: '), write(NamaSpAtk), nl,
		write('      Special Attack: '), write(SpAtk), nl,
		write('      Level Tokemon: '), write(Level), nl,
		write('      Current XP: '), write(CurExp), nl,
		write('      XP yang dibutuhkan buat naik level: ', write(NeededExp)), nl

		)),

	write('Here are the legendary tokemons you still have to seek...'), nl,
	forall(isTokemon(Tokemon, legendary, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp), (

		write('  --> '), write('Name: '), write(Tokemon), nl,
		write('      Elemental: '), write(Elemental), nl,
		write('      Health: '), write(HP), nl,
		write('      Nama Skill Attack: '), write(NamaAtk), nl,
		write('      Attack: '), write(Atk), nl,
		write('      Nama Skill Special Attack: '), write(NamaSpAtk), nl,
		write('      Special Attack: '), write(SpAtk), nl,
		write('      Level Tokemon: '), write(Level), nl,
		write('      Current XP: '), write(CurExp), nl,
		write('      XP yang dibutuhkan buat naik level: ', write(NeededExp)), nl

		)).