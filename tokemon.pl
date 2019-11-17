:-dynamic(tokemon/11).  /*tokemon(nama)*/

/*isTokemon(nama,jenis,tipe,hp,maxhp,nama_attack,damage_attack,nama_sp_attack,damage_sp_attack,level,currExp,neededExp) */

isTokemon(catamon,normal,water,HP,5000,cakar_aja,A,cakar_banget,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
   
isTokemon(defrog,normal,water,HP,5000,kwok,A,frogyou,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
/*    ///////////////////////////////////
isTokemon(defrog,normal,water,HP,5500,kwok,A,frogyou,SA,2,100,200) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA). 
isTokemon(catamon,normal,water,HP,550,cakar_aja,A,cakar_banget,SA,2,100,200) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).
    
isTokemon(catamon,normal,water,HP,600,cakar_aja,A,cakar_banget,SA,3,200,300) :-
    random(470,500,HP),
    random(50,60,A),
    random(70,80,SA).
////////////////////////////////////      */
isTokemon(anjingmon,normal,fire,HP,6000,gukguk,A,anjingsia,SA,1,0,1000) :-
    random(4500,4800,HP),
    random(550,650,A),
    random(700,800,SA).
    
isTokemon(nagamon,normal,fire,HP,sembursaja,A,duarr,SA,1,0,1000) :-
    random(4500,4800,HP),
    random(550,650,A),
    random(700,800,SA).

isTokemon(birdmon,normal,leaves,HP,cuitcuit,A,ciutciut,SA,1,0,1000) :-
    random(4000,4200,HP),
    random(650,750,A),
    random(850,950,SA).
    
isTokemon(tikusmon,normal,leaves,HP,puptikus,A,gigit_nih,1,0,1000) :-
    random(4000,4200,HP),
    random(650,750,A),
    random(850,950,SA).

isTokemon(kodingmon,normal,hmif,HP,sublime,A,vscode,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
    
isTokemon(nyetrumon,normal,hme,HP,kapasitor,A,induktor,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
    
isTokemon(radarmon,normal,signum,HP,laprak,A,radiasi,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
 
isTokemon(garamon,legendary,water,21020,salt,1200,saltbae,2000,1,0,10000).
isTokemon(daemon,legendary,hmif,10110,konsekuensi,2000,pencoretan,4000,1,0,10000). 
isTokemon(kumon,legendary,fire,12345,english,1234,math,2345,1,0,10000).
isTokemon(doraemon,legendary,leaves,9500,baling_bambu,3000,time_machine,5000,1,0,10000).

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
    inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp),
    NewLevel is Level+1,
    NewNeededExp is NeededExp+(NeededExp*1.2),
    BatasBawah is 0.1*MaxHP,
    BatasAtas is 0.3*MaxHP,
    random(BatasBawah, BatasAtas, PlusHP),
    NewMaxHP is floor(MaxHP+PlusHP),
    NewHP is floor(HP+(PlusHP*0.75)),
    NewDamageAtk is (Damage+(0.1*PlusHP)),
    NewDamageSp is (Sp+(0.1*PlusHP)),
    retract(inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp)),
    asserta(inventory(Tokemon,Jenis,Tipe,NewHP,NewMaxHP,NamaAtk,NewDamageAtk,NamaSp,NewDamageSp,NewLevel,CurrExp,NewNededExp)),
    write('Congratzszszs!!! Your '), write(Tokemon), write(' is now on level '), write(NewLevel), write('!'), nl, !.
    
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
    searchIdx(ListMusuhLegendary,HasilRandom,Tokemon),
    isTokemon(Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    musuh(_,Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    asserta(curMusuh(Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    retract(musuh(_,Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    init_battle,!.
  
  
ambilMusuhNormal :-
    findall(X, (musuh(X,Tipe,_,_,_,_,_,_), Tipe == normal), ListMusuhNormal),
    length(ListMusuh, Panjang),
    random(0,Panjang,HasilRandom),
    searchIdx(ListMusuhNormal,HasilRandom,Tokemon),
    isTokemon(Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    musuh(_,Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    asserta(curMusuh(Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    retract(musuh(_,Tokemon,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp))
    init_battle,!.


generatePeluangRun(X) :- 
    random (1,10,X),
    X mod 4 =:= 0 ->
    (
        X = berhasil,!
    );(
        X = gagal,!
    )!.
    
init_musuh(0) :- !.
init_musuh(Banyak) :-
    findall(X,isTokemon(X,_,_,_,_,_,_,_),ListMusuh),
    searchIdx(ListMusuh,Banyak,TokemonMusuh),
    isTokemon(TokemonMusuh,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    asserta(musuh(Banyak,Nama,Jenis,Tipe,HP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    BanyakBaru is Banyak-1,
    initMusuh(BanyakBaru),!.
    

/*ketemu musuh, runnya berhasil apa engga, ketika ketemu musuhnya apa*/
