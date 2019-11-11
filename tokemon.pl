:-dynamic(tokemon/6).  /*tokemon(nama)*/

/*isTokemon(nama,jenis,tipe,hp,attack,sp_attack) */
isTokemon(catamon,normal,water,500,50,70).
isTokemon(anjingmon,normal,fire,450,60,80).
isTokemon(birdmon,normal,leaves,400,70,90).
isTokemon(tikusmon,normal,leaves,400,70,90).
isTokemon(dragonmon,normal,fire,500,60,80).
isTokemon(geanymon,normal,water,470,60,80).
isTokemon(logkomon,normal,hmif,510,50,80).
isTokemon(remon,normal,hme,790,60,90).
isTokemon(radarmon,normal,signum,800,40,60).

isTokemon(garamon,legendary,water,2102,120,200).
isTokemon(daemon,legendary,fire,1011,200,400).
isTokemon(kumon,legendary,fire,1234,123,456).
isTokemon(doraemon,legendary,leaves,950,300,500).
/*
generatePeluang(X,P) :-
    X == normal,
    random(60,80,P).
generatePeluang(X,P) :-
    X == legendary,
    random(10,40,P).  
peluangEncounter(P) :- 
    random(
*/
musuhnyaApa :- 
    random(0,PanjangList,X),
    ambil(ListMusuh,X,Tokemon),
    isTokemon(Tokemon,Jenis,Tipe,HP,Attack,Sp_attack),
    asserta(musuh(0,Tokemon,Jenis,Tipe,HP,Attack,Sp_attack))
/*
peluangRun(P) :- 
*/
ambil([],0,'') :- !.
ambil([X|_],0,X) :- !.
ambil([_|Tail],N,X) :- N1 is N-1, ambil(Tail, N1, X), !.

/*ketemu musuh, runnya berhasil apa engga, ketika ketemu musuhnya apa*/
