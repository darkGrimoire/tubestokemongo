
%predikat untuk load dan save 

loadd(_) :-
	gameStarted(_),
	write('Game sudah dimulai, silakan exit dulu kalo mau load game'), nl, !.

loadd(File) :-
	\+file_exists(File),
	write('File '), write(File), write(' tidak ditemukan...'), nl, !.

loadd(File) :-
	open(File, read, Stream),
	readFileLines(Stream, Lines),
	close(Stream),
	assertaList(Lines), !.

save(_) :-
	\+gameStarted(_),
	write('Command tidak dapat dilakukan karena game belum dimulai...'), nl, !.

save(File) :-
	tell(File),
		%perlu ditambahin apa2 aja yang harus disimpan ke file eksternal
		writeTokemon,
		writeMap,
		%writeMusuh,
		writeHeal,
		writeGame,
		maxTokemon(Max),
		write(maxTokemon(Max)), write('.'), nl,
	told, !.

writeTokemon :-
	\+inventory(_,_,_,_,_,_), !.

writeTokemon :-
	forall(inventory(Tokemon, Type, Elemental, HP, Atk, SpAtk),( 
		write(inventory(Tokemon, Type, Elemental, HP, Atk, SpAtk)),
		write('.'),nl
		)), !.

writeMap :-
	pos(X,Y),
	write(pos(X,Y)), write('.'), nl,
	lebarpeta(Width),
	write(lebarpeta(Width)), write('.'), nl,
	tinggipeta(Height),
	write(tinggipeta(Height)), write('.'), nl,
	isGym(XGym,YGym),
	write(isGym(XGym,YGym)), write('.'), nl,
	!.

writeHeal :-
	\+alreadyHeal(_), !.

writeHeal :-
	alreadyHeal(X),
	write(alreadyHeal(X)), write('.'), nl, !.

writeGame :-
	\+gameStarted(_), !.

writeGame :-
	gameStarted(X),
	write(gameStarted(X)), write('.'), nl, !.

/*
writeMusuh :-
	\+musuh(_,_,_,_,_,_,_), !.

%writeMusuh :-
	forall(musuh(Idx, Tokemon, Type, Elemental, HP, Atk, SpAtk ),(
		write(musuh(Idx, Tokemon, Type, Elemental, HP, Atk, SpAtk)),
		write('.'), nl
		)), !.
*/

%fungsi utility file eksternal

%read file eksternal

readData(S,[]) :-
	at_end_of_stream(S), !.

readData(S, [Head|Tail]) :-
	get_char(S,Head),
	readData(S, Tail).

readFile(File, Data) :-
	open(File, read, S),
	repeat,
	readData(S, Data),
	close(S), !.

readFileLines(S, []) :-
	at_end_of_stream(S).

readFileLines(S, [Head|Tail]) :-
	\+at_end_of_stream(S),
	read(S, Head),
	readFileLines(S, Tail).

%write file eksternal 

writeData(_,[]) :- !.

writeData(S, [Head|Tail]) :-
	write(S, Head),
	writeData(S, Tail).

writeList(File, List) :-
	open(File, write, S),
	repeat,
	writeData(S, List),
	close(S).
