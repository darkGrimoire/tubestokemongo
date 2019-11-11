% Tokemon Database
% tokemon(nama_pokemon,tipe,elemental,hp, atk, sp_atk, )
isTokemon(catamon,normal,water,1000,15,45).
isTokemon(dogmon,normal,fire,2500,80,350).
isTokemon(garamon,legendary,fire,7500,250,800).
isTokemon(daemon,legendary,fire,9999,500,2500).

% init player:l
init_player :-
    asserta(tokemon(catamon,normal,water,1000,15,45)),
    asserta(pos(5,6)).

init_musuh :-
    findall(T,isTokemon(T,_,_,_,_,_), ListTokemon),
    length(ListTokemon,PanjangList),
    random(0,PanjangList, NoTokemon),
    ambil(ListTokemon, NoTokemon, Tokemon),
    isTokemon(Tokemon, Type, Elemental, HP, Atk, SpAtk),
    generatePeluang(Type, Peluang),
    asserta(musuh(0,Tokemon, Type, Elemental, HP, Atk, SpAtk, Peluang)).



generatePeluang(X,P) :-
    X == normal,
    random(60,80,P).
generatePeluang(X,P) :-
    X == legendary,
    random(10,40,P).


% Utils
ambil([],0,'') :- !.
ambil([X|_],0,X) :- !.
ambil([_|Tail],N,X) :- N1 is N-1, ambil(Tail, N1, X), !.