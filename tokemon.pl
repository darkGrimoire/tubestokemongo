:-dynamic(tokemon/8).  /*tokemon(nama)*/

/*isTokemon(nama,jenis,tipe,hp,nama_attack,damage_attack,nama_sp_attack,damage_sp_attack) */
isTokemon(catamon,normal,water,HP,cakar_aja,A,cakar_banget,SA) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).
    
isTokemon(defrog,normal,water,HP,kwok,A,frogyou,SA) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).

isTokemon(anjingmon,normal,fire,HP,gukguk,A,anjingsia,SA) :-
    random(450,480,HP),
    random(55,65,A),
    random(70,80,SA).
    
isTokemon(nagamon,normal,fire,HP,sembursaja,A,duarr,SA) :-
    random(450,480,HP),
    random(55,65,A),
    random(70,80,SA).

isTokemon(birdmon,normal,leaves,HP,cuitcuit,A,ciutciut,SA) :-
    random(400,420,HP),
    random(65,75,A),
    random(85,95,SA).
    
isTokemon(tikusmon,normal,leaves,HP,puptikus,A,gigit_nih,SA) :-
    random(400,420,HP),
    random(65,75,A),
    random(85,95,SA).

isTokemon(kodingmon,normal,hmif,HP,sublime,A,vscode,SA) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).
    
isTokemon(nyetrumon,normal,hme,HP,kapasitor,A,induktor,SA) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).
    
isTokemon(radarmon,normal,signum,HP,laprak,A,radiasi,SA) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).
 
isTokemon(garamon,legendary,water,2102,salt,120,saltbae,200).
isTokemon(daemon,legendary,hmif,1011,konsekuensi,200,pencoretan,400). 
isTokemon(kumon,legendary,fire,1234,english,123,math,456).
isTokemon(doraemon,legendary,leaves,950,baling_bambu,300,time_machine,500).
  
  
generatePeluangMusuh :- 
    random(1,10,X),
    X mod 3 is 0 ->
    (
        ambilMusuhLegendary,
    );(
        ambilMusuhNormal
    ).
  
  
ambilMusuhLegendary :-
    findAll(X, (musuh(X,Tipe,_,_,_,_,_,_), Tipe == legendary), ListMusuhLegendary),
    length(ListMusuh, Panjang),
    random(0,Panjang,HasilRandom),
    ambil(ListMusuhLegendary,HasilRandom,Tokemon),
    musuh(_,Nama,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp),
    asserta(curMusuh(Nama,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp)),
    battleStart,!.
  
  
ambilMusuhNormal :-
    findAll(X, (musuh(X,Tipe,_,_,_,_,_,_), Tipe == normal), ListMusuhNormal),
    length(ListMusuh, Panjang),
    random(0,Panjang,HasilRandom),
    ambil(ListMusuhNormal,HasilRandom,Tokemon),
    musuh(_,Nama,Jenis,Tipe,_,Nama_attack,_,Nama_sp,_),
    asserta(curMusuh(Nama,Jenis,Tipe,_,Nama_attack,_,Nama_sp,_)),
    battleStart,!.


generatePeluangRun :- 
    random (1,10,X),
    X mod 2 is 0 ->
    (
        run,
    );(
        battleStart,!.
    ).
    
init_musuh(0) :- !.
init_musuh(Banyak) :-
    findall(X,isTokemon(X,_,_,_,_,_,_,_),ListMusuh),
    ambil(ListMusuh,Banyak,TokemonMusuh),
    isTokemon(TokemonMusuh,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp),
    asserta(musuh(Banyak,Nama,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp)),
    BanyakBaru is Banyak-1,
    initMusuh(BanyakBaru),!.
    
ambil([],0,'') :- !.
ambil([X|_],0,X) :- !.
ambil([_|Tail],N,X) :- N1 is N-1, ambil(Tail, N1, X), !.

/*ketemu musuh, runnya berhasil apa engga, ketika ketemu musuhnya apa*/
