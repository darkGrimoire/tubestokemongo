:-include('utils.pl').
:-include('BattleSystem.pl').

:-dynamic(inventory/12).  /*tokemon(nama)*/
:-dynamic(musuh/13).

/*isTokemon(Nama,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp) */
/*inisialisasi semua tokemon*/
isTokemon(catamon,normal,water,HP,HP,cakarsaja,A,cakarbanget,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(defrog,normal,water,HP,HP,kwok,A,frogyou,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(anjingmon,normal,fire,HP,HP,gukguk,A,anjingsia,SA,1,0,1000) :-
    random(4500,4800,HP),
    random(550,650,A),
    random(700,800,SA).
isTokemon(nagamon,normal,fire,HP,HP,sembursaja,A,duarr,SA,1,0,1000) :-
    random(4500,4800,HP),
    random(550,650,A),
    random(700,800,SA).
isTokemon(birdmon,normal,leaves,HP,HP,cuitcuit,A,ciutciut,SA,1,0,1000) :-
    random(4000,4200,HP),
    random(650,750,A),
    random(850,950,SA).
isTokemon(tikusmon,normal,leaves,HP,HP,puptikus,A,gigit_nih,SA,1,0,1000) :-
    random(4000,4200,HP),
    random(650,750,A),
    random(850,950,SA).
isTokemon(kodingmon,normal,hmif,HP,HP,sublime,A,vscode,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(nyetrumon,normal,hme,HP,HP,kapasitor,A,induktor,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(radarmon,normal,signum,HP,HP,laprak,A,radiasi,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(garamon,legendary,water,21020,21020,salt,1200,saltbae,2000,1,0,10000).
isTokemon(kumon,legendary,fire,12345,12345,english,1234,math,2345,1,0,10000).
isTokemon(doraemon,legendary,leaves,9500,9500,baling_bambu,3000,time_machine,5000,1,0,10000).

/*inisialisasi tokemon legend terkuat*/
isTokemon(daemon,superlegendary,hmif,135182,135182,konsekuensi,2000,pencoretan,4000,1,0,10000). 

/*inisialisasi bentuk evolving dari semua tokemon*/
isEvolve(singamon,normal,water,HP,HP,cakarsaja,A,cakarbangetbanget,SA,0,-1,0) :-
    random(47000,50000,HP),
    random(5000,6000,A),
    random(7000,8000,SA).
isEvolve(dedefrog,normal,water,HP,HP,kwok,A,froggingsheet,SA,0,-1,0) :-
    random(47000,50000,HP),
    random(5000,6000,A),
    random(7000,8000,SA).
isEvolve(anjijingmon,normal,fire,HP,HP,gukguk,A,anjingsiamaneh,SA,0,-1,0) :-
    random(45000,48000,HP),
    random(5500,6500,A),
    random(7000,8000,SA).
isEvolve(nagagamon,normal,fire,HP,HP,sembursaja,A,duarR,SA,0,-1,0) :-
    random(45000,48000,HP),
    random(5500,6500,A),
    random(7000,8000,SA).
isEvolve(bibirdmon,normal,leaves,HP,HP,cuitcuit,A,ciutciuttt,SA,0,-1,0) :-
    random(40000,42000,HP),
    random(6500,7500,A),
    random(8500,9500,SA).
isEvolve(tikukusmon,normal,leaves,HP,HP,puptikus,A,gigitnih,SA,0,-1,0) :-
    random(40000,42000,HP),
    random(6500,7500,A),
    random(8500,9500,SA).
isEvolve(kodidingmon,normal,hmif,HP,HP,sublime,A,vscode,SA,0,-1,0) :-
    random(47000,50000,HP),
    random(5000,6000,A),
    random(7000,8000,SA).
isEvolve(nyetrurumon,normal,hme,HP,HP,kapasitor,A,induktor,SA,0,-1,0) :-
    random(47000,50000,HP),
    random(5000,6000,A),
    random(7000,8000,SA).
isEvolve(radarawrmon,normal,signum,HP,HP,laprak,A,radiasi,SA,0,-1,0) :-
    random(47000,50000,HP),
    random(5000,6000,A),
    random(7000,8000,SA).
isEvolve(gararamon,legendary,water,210200,210200,salt,1200,saltbae,2000,0,-1,0). 
isEvolve(kukumon,legendary,fire,123456,123456,english,1234,math,2345,0,-1,0).
isEvolve(doraraemon,legendary,leaves,95000,95000,baling_bambu,3000,time_machine,5000,0,-1,0).

/*fungsi2 lain*/
apakahBisaLevelUp(Bisa) :-
    findall(X, (inventory(X,_,_,_,_,_,_,_,_,Level,CurrExp,NeededExp), Level<3, CurrExp>=NeededExp), ListNonMaxLevel),
    length(ListNonMaxLevel,Panjang),
    Panjang \== 0 ->
    (
        Bisa = yes,!
    );(
        Bisa = no,!
    ),!.
    
isReadytoEvolve(X) :- 
    findall(X, (inventory(X,_,_,_,_,_,_,_,_,Level,CurrExp,NeededExp), Level==3, CurrExp>=NeededExp), ListEvolve),
    length(ListEvolve,Panjang),
    Panjang \== 0 ->
    (
        X = ready,!
    );(
        X = no,!
    ),!.

evolve(Tokemon) :-
    inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp),
    NewMaxHP is floor(MaxHP+(MaxHP*(1.9))),
    NewHP is floor(HP+(HP*1.9)),
    NewDamageAtk is floor(DamageAtk+(DamageAtk*(1.5))),
    NewDamageSp is floor(DamageSp+(DamageAtk*(1.5))),
    retract(inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp)),
    isEvolve(A,Jenis,Tipe,B,C,NamaAtk,D,E,F,G,H,I),
    asserta(inventory(A,Jenis,Tipe,B,C,NamaAtk,D,E,F,G,H,I)),!.
    
    
levelUp(Tokemon) :-
    inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp),
    NewLevel is Level+1,
    NewNeededExp is NeededExp+(NeededExp*1.2),
    BatasBawah is 0.1*MaxHP,
    BatasAtas is 0.3*MaxHP,
    random(BatasBawah, BatasAtas, PlusHP),
    NewMaxHP is floor(MaxHP+PlusHP),
    NewHP is floor(HP+(PlusHP*0.8)),
    NewDamageAtk is (DamageAtk+(0.1*PlusHP)),
    NewDamageSp is (DamageSp+(0.1*PlusHP)),
    retract(inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp)),
    asserta(inventory(Tokemon,Jenis,Tipe,NewHP,NewMaxHP,NamaAtk,NewDamageAtk,NamaSp,NewDamageSp,NewLevel,CurrExp,NewNeededExp)),
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
    findall(X, (musuh(_,X,Tipe,_,_,_,_,_,_,_,_,_,_), Tipe == legendary), ListMusuhLegendary),
    length(ListMusuhLegendary, Panjang),
    random(0,Panjang,HasilRandom),
    searchIdx(ListMusuhLegendary,HasilRandom,Tokemon),
    isTokemon(Tokemon,Jenis,Tipe,HP,MaxHP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    % musuh(_,Tokemon,Jenis,Tipe,HP,MaxHP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    asserta(curMusuh(Tokemon,Jenis,Tipe,HP,MaxHP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    retract(musuh(_,Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
    init_battle,!.
  
  
ambilMusuhNormal :-
    findall(X, (musuh(_,X,Tipe,_,_,_,_,_,_,_,_,_,_), Tipe == normal), ListMusuhNormal),
    length(ListMusuhNormal, Panjang),
    random(0,Panjang,HasilRandom),
    searchIdx(ListMusuhNormal,HasilRandom,Tokemon),
    isTokemon(Tokemon,Jenis,Tipe,HP,MaxHP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    % musuh(Idx,Tokemon,Jenis,Tipe,HP,MaxHP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    asserta(curMusuh(Tokemon,Jenis,Tipe,HP,MaxHP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    retract(musuh(_,Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
    init_battle,!.


generatePeluangRun(X) :- 
    random(1,10,Num),
    Num mod 4 =:= 0 ->
    (
        X = berhasil,!
    );(
        X = gagal,!
    ),!.
    
init_musuh(0) :- !.
init_musuh(Banyak) :-
    findall(X,(isTokemon(X,Jenis,_,_,_,_,_,_,_,_,_,_), Jenis\==superlegendary), ListMusuh),
    searchIdx(ListMusuh,Banyak,TokemonMusuh),
    isTokemon(TokemonMusuh,Jenis,Tipe,HP,MaxHP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
    asserta(musuh(Banyak,TokemonMusuh,Jenis,Tipe,HP,MaxHP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
    BanyakBaru is Banyak-1,
    init_musuh(BanyakBaru),!.
    
