% :-include('utils.pl').
% :-include('BattleSystem.pl').

:-dynamic(inventory/12).  /*tokemon(nama)*/
:-dynamic(musuh/13).

/*isTokemon(Nama,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp) */
/*inisialisasi semua tokemon*/
% isTokemon(catamon,normal,water,HP,HP,cakaraja,A,cakarbanget,SA,1,0,1000) :-
%     random(4700,5000,HP),
%     random(500,600,A),
%     random(700,800,SA).
isTokemon(kudamon,normal,water,HP,HP,ikikikiki,A,tendanganmaut,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(defrog,normal,water,HP,HP,kwok,A,frogyou,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(lotusmon,normal,water,HP,HP,splash,A,tenggelam,SA,1,0,1000) :-
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
isTokemon(potatomon,normal,fire,HP,HP,potatopunch,A,boiledpotato,SA,1,0,1000) :-
    random(4500,4800,HP),
    random(550,650,A),
    random(700,800,SA).
    
isTokemon(birdmon,normal,leaves,HP,HP,cuitcuit,A,ciutciut,SA,1,0,1000) :-
    random(4000,4200,HP),
    random(650,750,A),
    random(850,950,SA).
isTokemon(tikusmon,normal,leaves,HP,HP,puptikus,A,gigitnih,SA,1,0,1000) :-
    random(4000,4200,HP),
    random(650,750,A),
    random(850,950,SA).
isTokemon(salamander,normal,leaves,HP,HP,lick,A,poison,SA,1,0,1000) :-
    random(4000,4200,HP),
    random(650,750,A),
    random(850,950,SA).
    
isTokemon(kodingmon,normal,hmif,HP,HP,sublime,A,vscode,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(alstrukdat,normal,hmif,HP,HP,praprak,A,duartubes,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(nyetrumon,normal,hme,HP,HP,kapasitor,A,induktor,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(powermon,normal,hme,HP,HP,kekuatan,A,lightning,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(radarmon,normal,signum,HP,HP,laprak,A,radiasi,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isTokemon(signalmon,normal,signum,HP,HP,nosignal,A,airplanemode,SA,1,0,1000) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
    
isTokemon(garamon,legendary,water,21020,21020,salt,1200,saltbae,2000,1,0,10000).
isTokemon(kumon,legendary,fire,12345,12345,english,1234,math,2345,1,0,10000).
isTokemon(doraemon,legendary,leaves,9500,9500,baling_bambu,3000,time_machine,5000,1,0,10000).

/*inisialisasi tokemon legend terkuat*/
isTokemon(daemon,superlegendary,hmif,135182,135182,konsekuensi,2000,pencoretan,4000,1,0,10000). 

/*inisialisasi bentuk evolving dari semua tokemon*/
isEvolve(singamon,normal,water,HP,HP,cakaraja,A,cakarbangetbanget,SA,0,-1,0) :-
    random(49000,50000,HP),
    random(5900,6000,A),
    random(7900,8000,SA).
isEvolve(dedefrog,normal,water,HP,HP,kwok,A,froggingsheet,SA,0,-1,0) :-
    random(49000,50000,HP),
    random(5900,6000,A),
    random(7900,8000,SA).
isEvolve(lotusmon,normal,water,HP,HP,splash,A,tenggelamkan,SA,0,-1,0) :-
    random(49000,50000,HP),
    random(5900,6000,A),
    random(7900,8000,SA).
isEvolve(anjinggmon,normal,fire,HP,HP,gukguk,A,anjingsiamaneh,SA,0,-1,0) :-
    random(47000,48000,HP),
    random(6400,6500,A),
    random(7900,8000,SA).
isEvolve(dragomon,normal,fire,HP,HP,sembursaja,A,duarR,SA,0,-1,0) :-
    random(47000,48000,HP),
    random(6400,6500,A),
    random(7900,8000,SA).
isEvolve(mashedpotatomon,normal,fire,HP,HP,potatopunch,A,mashedpotato,SA,0,-1,0) :-
    random(47000,48000,HP),
    random(6400,6500,A),
    random(7900,8000,SA).
isEvolve(burungmon,normal,leaves,HP,HP,cuitcuit,A,ciutciuttt,SA,0,-1,0) :-
    random(40000,42000,HP),
    random(7400,7500,A),
    random(9400,9500,SA).
isEvolve(ratatouille,normal,leaves,HP,HP,puptikus,A,firecook,SA,0,-1,0) :-
    random(40000,42000,HP),
    random(7400,7500,A),
    random(9400,9500,SA).
isEvolve(salamander,normal,leaves,HP,HP,lick,A,poison,SA,0,-1,0) :-
    random(40000,42000,HP),
    random(7400,7500,A),
    random(9400,9500,SA).
isEvolve(tubesmon,normal,hmif,HP,HP,sublime,A,vscode,SA,0,-1,0) :-
    random(47000,50000,HP),
    random(5900,6000,A),
    random(7900,8000,SA).
isEvolve(orkom,normal,hmif,HP,HP,praprak,A,ekusUpUROsHION,SA,0,-1,0) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isEvolve(lightingmon,normal,hme,HP,HP,kapasitor,A,induktor,SA,0,-1,0) :-
    random(47000,50000,HP),
    random(5900,6000,A),
    random(7900,8000,SA).
isEvolve(himapow,normal,hme,HP,HP,kekuatan,A,matilampu,SA,1,0,0) :-
    random(4700,5000,HP),
    random(500,600,A),
    random(700,800,SA).
isEvolve(radiasimon,normal,signum,HP,HP,laprak,A,radiasi,SA,0,-1,0) :-
    random(47000,50000,HP),
    random(5900,6000,A),
    random(7900,8000,SA).
isEvolve(signalmon,normal,signum,HP,HP,nosignal,A,airplanemode,SA,0,-1,0) :-
    random(47000,50000,HP),
    random(5900,6000,A),
    random(7900,8000,SA).
isEvolve(micinmon,legendary,water,210200,210200,salt,1200,saltbae,2000,0,-1,0). 
isEvolve(kukumon,legendary,fire,123456,123456,english,1234,math,2345,0,-1,0).
isEvolve(dorayaki,legendary,leaves,95000,95000,balingbambu,3000,timemachine,5000,0,-1,0).

/*fungsi2 lain*/
apakahBisaLevelUp(Bisa) :-
    findall(X, (inventory(X,_,_,_,_,_,_,_,_,Level,CurrExp,NeededExp), Level<3, CurrExp>=NeededExp), ListNonMaxLevel),
    length(ListNonMaxLevel,Panjang),
    Panjang \== 0 ->
    (
        write('Wow I think you\'re tokemon is mature enough to level up!'),nl,
        write('You can level up these tokemons: '), printList(ListNonMaxLevel),nl,
        write('use [levelUp(X)] to levelup!'),nl,
        Bisa = yes,!
    );(
        Bisa = no,!
    ),!.
    
isReadytoEvolve(X) :- 
    findall(X, (inventory(X,_,_,_,_,_,_,_,_,Level,CurrExp,NeededExp), Level==3, CurrExp>=NeededExp), ListEvolve),
    length(ListEvolve,Panjang),
    Panjang \== 0 ->
    (
        write('Your tokemon(s) is ready to evolve!'),nl,
        write('You can evolve these tokemons: '), printList(ListEvolve),nl,
        write('use [evolve(X)] to evolve!'),nl,
        X = ready,!
    );(
        X = no,!
    ),!.

evolve(Tokemon) :-
    daemonFlag(1),
    findall(X, (inventory(X,_,_,_,_,_,_,_,_,Level,CurrExp,NeededExp), Level==3, CurrExp>=NeededExp), ListEvolve),
    searchX(ListEvolve, Tokemon, Idx),
    Idx =\= -1,
    inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp),
    retract(inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp)),
    isEvolve(A,Jenis,Tipe,B,C,NamaAtk,D,E,F,G,H,I),
    write('Congratzszszs!!! Your '), write(Tokemon), write(' is now evolving into something new... '), nl,
    write(A), write(!), nl,
    asserta(inventory(A,Jenis,Tipe,B,C,NamaAtk,D,E,F,G,H,I)),!.

evolve(Tokemon) :-
    \+daemonFlag(_),
    findall(X, (inventory(X,_,_,_,_,_,_,_,_,Level,CurrExp,NeededExp), Level==3, CurrExp>=NeededExp), ListEvolve),
    searchX(ListEvolve, Tokemon, Idx),
    Idx =\= -1,
    inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp),
    retract(inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp)),
    isEvolve(A,Jenis,Tipe,B,C,NamaAtk,D,E,F,G,H,I),
    asserta(daemonFlag(1)),
    write('Congratzszszs!!! Your '), write(Tokemon), write(' is now evolving into something new... '), nl,
    write(A), write(!), nl,nl,
    write('Shortly after you evolved, the ground crumbles...'),nl,
    write('The Daemon unleashed as it smells your scent of power...'),nl,
    write('Will you be able to defeat it?'),nl,nl,
    asserta(musuh(999,daemon,superlegendary,hmif,135182,135182,konsekuensi,2000,pencoretan,4000,1,0,10000)),
    asserta(inventory(A,Jenis,Tipe,B,C,NamaAtk,D,E,F,G,H,I)),!.
    
    
levelUp(Tokemon) :-
    findall(X, (inventory(X,_,_,_,_,_,_,_,_,Level,CurrExp,NeededExp), Level<3, CurrExp>=NeededExp), ListNonMaxLevel),
    searchX(ListNonMaxLevel, Tokemon, Idx),
    Idx =\= -1,
    inventory(Tokemon,Jenis,Tipe,HP,MaxHP,NamaAtk,DamageAtk,NamaSp,DamageSp,Level,CurrExp,NeededExp),
    NewLevel is Level+1,
    NewNeededExp is NeededExp+(NeededExp*1.2),
    BatasBawah is 0.3*MaxHP,
    BatasAtas is 0.5*MaxHP,
    random(BatasBawah, BatasAtas, PlusHP),
    NewMaxHP is floor(float(MaxHP+PlusHP)),
    NewHP is floor(float(HP+(PlusHP*0.8))),
    NewDamageAtk is floor(float(DamageAtk+(0.1*PlusHP))),
    NewDamageSp is floor(float(DamageSp+(0.1*PlusHP))),
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
    daemonFlag(1),
    random(1,10,X),
    X mod 2 =:= 0 ->
    (
        musuh(_,daemon,Jenis,Tipe,HP,MaxHP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp),
        asserta(curMusuh(daemon,Jenis,Tipe,HP,MaxHP,Nama_attack,Damage_attack,Nama_sp,Damage_sp,Level,CurrExp,NeededExp)),
        retract(musuh(_,Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        init_battle,!
    );(
        daemonFlag(1),
        retract(probbattleFlag(_)),
        write('But when you check it, there is... nothing?'),nl,
        write('You hear heavy footsteps closing...'),nl,!
    ),!.

generateMusuh :-
    \+daemonFlag(_),
    random(1,10,X),
    X mod 5 =:= 0 ->
    (
        ambilMusuhLegendary,!
    );(
        \+daemonFlag(_),
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
    daemonFlag(1),
    write('You can\'t run... You can only accept your final fate.'),nl,
    X = gagal,!.

generatePeluangRun(X) :- 
    \+daemonFlag(_),
    random(1,10,Num),
    Num mod 2 =:= 0 ->
    (
        X = berhasil,!
    );(
        \+daemonFlag(_),
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
    
/*
NewMaxHP is floor(MaxHP+(MaxHP*(1.9))),
    NewHP is floor(HP+(HP*1.9)),
    NewDamageAtk is floor(DamageAtk+(DamageAtk*(1.5))),
    NewDamageSp is floor(DamageSp+(DamageAtk*(1.5))),
    */
