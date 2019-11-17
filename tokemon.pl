:-dynamic(tokemon/11).  /*tokemon(nama)*/

/*isTokemon(nama,jenis,tipe,hp,nama_attack,damage_attack,nama_sp_attack,damage_sp_attack,level,currExp,neededExp) */
isTokemon(catamon,normal,water,HP,cakar_aja,A,cakar_banget,SA,1,0,100) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).
    
isTokemon(defrog,normal,water,HP,kwok,A,frogyou,SA,1,0,100) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).

isTokemon(anjingmon,normal,fire,HP,gukguk,A,anjingsia,SA,1,0,100) :-
    random(450,480,HP),
    random(55,65,A),
    random(70,80,SA).
    
isTokemon(nagamon,normal,fire,HP,sembursaja,A,duarr,SA,1,0,100) :-
    random(450,480,HP),
    random(55,65,A),
    random(70,80,SA).

isTokemon(birdmon,normal,leaves,HP,cuitcuit,A,ciutciut,SA,1,0,100) :-
    random(400,420,HP),
    random(65,75,A),
    random(85,95,SA).
    
isTokemon(tikusmon,normal,leaves,HP,puptikus,A,gigit_nih,1,0,100) :-
    random(400,420,HP),
    random(65,75,A),
    random(85,95,SA).

isTokemon(kodingmon,normal,hmif,HP,sublime,A,vscode,SA,1,0,100) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).
    
isTokemon(nyetrumon,normal,hme,HP,kapasitor,A,induktor,SA,1,0,100) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).
    
isTokemon(radarmon,normal,signum,HP,laprak,A,radiasi,SA,1,0,100) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).
 
isTokemon(garamon,legendary,water,2102,salt,120,saltbae,200,1,0,1000).
isTokemon(daemon,legendary,hmif,1011,konsekuensi,200,pencoretan,400,1,0,1000). 
isTokemon(kumon,legendary,fire,1234,english,123,math,456,1,0,1000).
isTokemon(doraemon,legendary,leaves,950,baling_bambu,300,time_machine,500,1,0,1000).

apakahBisaLevelUp(Bisa) :-
    findall(X, (inventory(X,_,_,_,_,_,_,_,Level,CurrExp,NeededExp), Level<3, CurrExp>=NeededExp), ListNonMaxLevel),
    length(ListNonMaxLevel,Panjang),
    Panjang\==0 ->
    (
        Bisa = yes,!
    );(
        Bisa = no,!
    ),!.
    
levelUp(Tokemon) :-
    retract(inventory(Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    asserta(inventory(Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack+10,Nama_sp,Damage_sp+10,CurrExp,NeededExp+1000)),
    write('Congratzszszs!!! Your '), write(Tokemon), write(' is now on level'), write(level+1), write('!'), nl, !.
    
generateEncounter(Encounter) :-
    random(1,10,X),
    X mod 2 =:= 0 ->
    (
        Encounter = ada,!
    );(
        Encounter = gaada,!
    ),!.

generateMusuh :- 
    random(1,10,X),
    X mod 3 =:= 0 ->
    (
        ambilMusuhLegendary,!
    );(
        ambilMusuhNormal,!
    ),!.
  
  
ambilMusuhLegendary :-
    findall(X, (musuh(X,Tipe,_,_,_,_,_,_), Tipe == legendary), ListMusuhLegendary),
    length(ListMusuh, Panjang),
    random(0,Panjang,HasilRandom),
    ambil(ListMusuhLegendary,HasilRandom,Tokemon),
    isTokemon(Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    musuh(_,Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    asserta(curMusuh(Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    retract(musuh(_,Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    init_battle,!.
  
  
ambilMusuhNormal :-
    findall(X, (musuh(X,Tipe,_,_,_,_,_,_), Tipe == normal), ListMusuhNormal),
    length(ListMusuh, Panjang),
    random(0,Panjang,HasilRandom),
    ambil(ListMusuhNormal,HasilRandom,Tokemon),
    isTokemon(Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    musuh(_,Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    asserta(curMusuh(Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    retract(musuh(_,Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp))
    init_battle,!.


generatePeluangRun(X) :- 
    random (1,10,X),
    X mod 4 =:= 0 ->
    (
        X = berhasil,
    );(
        X = gagal,
    )!.
    
init_musuh(0) :- !.
init_musuh(Banyak) :-
    findall(X,isTokemon(X,_,_,_,_,_,_,_),ListMusuh),
    ambil(ListMusuh,Banyak,TokemonMusuh),
    isTokemon(TokemonMusuh,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    asserta(musuh(Banyak,Nama,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    BanyakBaru is Banyak-1,
    initMusuh(BanyakBaru),!.
    
ambil([],0,'') :- !.
ambil([X|_],0,X) :- !.
ambil([_|Tail],N,X) :- N1 is N-1, ambil(Tail, N1, X), !.

/*ketemu musuh, runnya berhasil apa engga, ketika ketemu musuhnya apa*/
