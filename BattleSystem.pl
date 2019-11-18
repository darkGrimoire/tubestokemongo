% :- include('utils.pl').
% :- include('player.pl').
:- dynamic(maxInventory/1).
:- dynamic(equTokemon/12).
:- dynamic(inventory/12).
:- dynamic(curMusuh/12).
:- dynamic(musuh/13).

% FLAGS
:- dynamic(spAvailable/1).
:- dynamic(spEnemyAvailable/1).
:- dynamic(daemonFlag/1).
:- dynamic(selaluBenarAvailable/1).
:- dynamic(selaluBenarCD/1).
:- dynamic(doubleAttack/1).
:- dynamic(defendFlag/1).
:- dynamic(pbattleFlag/1).
:- dynamic(inbattleFlag/1).
:- dynamic(winbattleFlag/1).
:- dynamic(losebattleFlag/1).
:- dynamic(gameoverFlag/1).
:- dynamic(wingameFlag/1).

/* For debugging purpose */
debugEvolve :-
    asserta(inventory(radarmon, normal, signum, 50000, 50000, laprak, 2500, radiasi, 8000,3,5500,5000)).

debugBiasa :- write('a wild hewwo appears!'),nl,
    asserta(inventory(radarmon, normal, signum, 50000, 50000, laprak, 2500, radiasi, 8000,3,10000,10000)),
    asserta(curMusuh(garamon,legendary,water,21020,21020,salt,1200,saltbae,2000,1,0,10000)),!.

debugDaemon :-
    asserta(inventory(radarmon, normal, signum, 50000, 50000, laprak, 2500, radiasi, 8000,3,10000,10000)),
    asserta(inventory(doraemon,legendary,leaves,9500,9500,baling_bambu,3000,time_machine,5000,1,0,10000)),
    asserta(inventory(kumon,legendary,fire,12345,12345,english,1234,math,2345,1,0,10000)),
    asserta(daemonFlag(1)),
    asserta(curMusuh(daemon, legendary, hmif, 135182, 135182, konsekuensi, 2000, pencoretan, 4000, 1, 1000, 1000)),!.

/* Additional functions */
% curMusuh(daemon, legendary, hmif, 135182, 135182, konsekuensi, 2000, pencoretan, 4000, 1, 1000, 1000)).
% template: curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
% template: equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
% ,_
/* Pre-Battle */
init_battle :-
    \+daemonFlag(_),
    curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_),
    retract(probbattleFlag(_)), asserta(pbattleFlag(1)), asserta(spEnemyAvailable(1)),
    write('a wild '), write(Enemy), write(' appears!'),nl,
    dispTokemon,!.

init_battle :-
    daemonFlag(_),
    curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_),
    random(2000,8000,PowerUp),
    retract(probbattleFlag(_)), asserta(pbattleFlag(1)), asserta(selaluBenarAvailable(PowerUp)),
    write('The Daemon appears menacingly in front of you...'),nl,
    dispTokemon,!.

% Display Tokemons
dispTokemon :-
    findall(X, inventory(X,_,_,_,_,_,_,_,_,_,_,_), YourTokemons),
    write('Your Tokemons are: ['),
    printList(YourTokemons),
    write(']'),nl,
    write('choose your Tokemons! ( pick(tokemon_name). or stat(tokemon_name) )'),nl,!.

% Cek inventory, udah pasti di inventory ada tokemons minimal 1
pick(Tokemon) :-
    \+pbattleFlag(_),!.

pick(Tokemon) :-
    pbattleFlag(_),
    \+inventory(Tokemon,_,_,_,_,_,_,_,_,_,_,_),
    write('You don\'t have '), write(Tokemon), write('!'),nl,
    dispTokemon,!.

pick(Tokemon) :-
    pbattleFlag(_),
    inventory(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    retract(inventory(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
    asserta(equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
    write('You: "I choose '), write(Tokemon), write('!"'),nl,nl,
    asserta(spAvailable(1)), retract(pbattleFlag(_)), asserta(inbattleFlag(1)),
    battleStat,!.

stat(Tokemon) :-
    \+pbattleFlag(_),!.

stat(Tokemon):-
    pbattleFlag(_),
    \+inventory(Tokemon,_,_,_,_,_,_,_,_,_,_,_),
    write('You don\'t have '), write(Tokemon), write('!'),nl,
    dispTokemon,!.

stat(Tokemon) :-
    pbattleFlag(_),
    inventory(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,_,_),
    write('Name: '), write(Tokemon), write('[Lv '), write(Level), write(']'),nl,
    write('Type: '), write(Type),nl,
    write('Elemental: '), write(Elmt),nl,
    write('HP: '), write(HP), write('/'), write(MaxHP),nl,
    write('Attack: '), write(NameAttack), write(' ('),write(Attack), write(' damage)'),nl,
    write('Special Attack: '), write(NameSpAttack), write(' ('),write(SpAttack), write(' damage)'),nl,nl,
    dispTokemon,!.

/* In-Battle */
battleStat :-
    \+inbattleFlag(_),!.

battleStat :-
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    inbattleFlag(_), defendFlag(_),
    checkDefend,
    curMusuh(EnemyTokemon,_,EnemyElmt,EnemyHP,EnemyMaxHP,_,_,_,_,_,_,_),
    write('                    Enemy                        '),nl,nl,
    write('               '),write(EnemyTokemon),nl,
    write('    Health:'), write(EnemyHP), write(' / '), write(EnemyMaxHP),nl,
    write('                Elemental:  '), write(EnemyElmt),nl,nl,
    write('                    Tokemon:                     '),nl,nl,
    equTokemon(Tokemon,_,Elmt,HP,MaxHP,_,_,_,_,_,_,_),
    write('                '),write(Tokemon),nl,
    write('    Health: '), write(HP), write('/'), write(MaxHP),nl,
    write('    Elemental: '), write(Elmt),nl,nl,
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    battleChoice,!.

battleStat :-
    inbattleFlag(_), \+defendFlag(_),
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    curMusuh(EnemyTokemon,_,EnemyElmt,EnemyHP,EnemyMaxHP,_,_,_,_,_,_,_),
    write('                    Enemy                        '),nl,nl,
    write('               '),write(EnemyTokemon),nl,
    write('    Health:'), write(EnemyHP), write(' / '), write(EnemyMaxHP),nl,
    write('                Elemental:  '), write(EnemyElmt),nl,nl,
    write('                    Tokemon:                     '),nl,nl,
    equTokemon(Tokemon,_,Elmt,HP,MaxHP,_,_,_,_,_,_,_),
    write('                '),write(Tokemon),nl,
    write('    Health: '), write(HP), write('/'), write(MaxHP),nl,
    write('    Elemental: '), write(Elmt),nl,nl,
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    battleChoice,!.

checkDefend :-
    defendFlag(Elmt),
    retract(defendFlag(_)),
    retract(equTokemon(Tokemon,Type,_,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
    asserta(equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)).


battleChoice :-
    \+inbattleFlag(_),!.

battleChoice :-
    inbattleFlag(_), spAvailable(_),
    write('Special Attack available!'),nl,
    write('attack, defend, or specialAttack?'),nl,!.

battleChoice :-
    inbattleFlag(_), \+spAvailable(_),
    write('attack or defend?'),nl,!.

battleChoice :-
    \+inbattleFlag(_),!.

/* ATTACKS */

attack :-
    \+inbattleFlag(_),!.

attack :-
    inbattleFlag(_),
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,NameAttack,_,_,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier > 1,
        write('You use '), write(NameAttack),write('!'),nl,
        write('The enemy is weak from your element!'),nl,
        attackCalc(ElmtModifier),!.

attack :-
    inbattleFlag(_),
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,NameAttack,_,_,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier =:= 1,
        write('You use '), write(NameAttack),write('!'),nl,
        write('Your strike hits the enemy!'),nl,
        attackCalc(ElmtModifier),!.

attack :-
    inbattleFlag(_),
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,NameAttack,_,_,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier < 1,
        write('You use '), write(NameAttack),write('!'),nl,
        write('Your attack is not very effective...'),nl,
        attackCalc(ElmtModifier),!.

attackCalc(ElmtModifier) :-
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
    equTokemon(_,_,_,_,_,_,Attack,_,_,_,_,_),
    Damage is floor(float(Attack*ElmtModifier)),
    write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
    Damage < EnemyHP ->
    (
        NewEnemyHP is EnemyHP-Damage,
        retract(curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP)),
        enemyAttack,!
    );(
        retract(inbattleFlag(_)), asserta(winbattleFlag(1)),
        retract(equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        asserta(inventory(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        write('The enemy has fallen! [capture] or [no]?'),nl,!
    ),!.

specialAttack :-
    \+inbattleFlag(_),!.

specialAttack :-
    inbattleFlag(_), spAvailable(_),
    retract(spAvailable(_)),
    specialAttackUtil,!.

specialAttack :-
    inbattleFlag(_), \+spAvailable(_),
    write('Special Attack not available!'),nl,
    battleStat,!.

specialAttackUtil :-
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,_,NameSpAttack,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier > 1,
        write('You use '), write(NameSpAttack),write('!'),nl,
        write('The enemy is weak from your element!'),nl,
        specialAttackCalc(ElmtModifier),!.

specialAttackUtil :-
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,_,NameSpAttack,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier =:= 1,
        write('You use '), write(NameSpAttack),write('!'),nl,
        write('Your strike hits the enemy!'),nl,
        specialAttackCalc(ElmtModifier),!.

specialAttackUtil :-
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,_,NameSpAttack,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier < 1,
        write('You use '), write(NameSpAttack),write('!'),nl,
        write('Your attack is not very effective...'),nl,
        specialAttackCalc(ElmtModifier),!.

specialAttackCalc(ElmtModifier) :-
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
    equTokemon(_,_,_,_,_,_,_,_,SpAttack,_,_,_),
    Damage is floor(float(SpAttack*ElmtModifier)),
    write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
    Damage < EnemyHP ->
    (
        NewEnemyHP is EnemyHP-Damage,
        retract(curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP)),
        enemyAttack,!
    );(
        % retract(curMusuh(Enemy,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(winbattleFlag(1)),
        retract(equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        asserta(inventory(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        write('The enemy has fallen! [capture] or [no]?'),nl,!
    ),!.

defend :-
    \+inbattleFlag(_),!.

defend :-
    inbattleFlag(_),
    write('You use defend!'),nl,
    retract(equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
    asserta(equTokemon(Tokemon,Type,defend,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
    asserta(defendFlag(Elmt)),
    enemyAttack,!.


enemyAttack :-
    daemonFlag(1), selaluBenarAvailable(_),
    write('Daemon\'s turn!'),nl,
    random(1,10,PeluangAttackMusuh),
    PeluangAttackMusuh mod 4 =:= 0 ->
    (
        daemonSkill_SelaluBenar,
        retract(selaluBenarAvailable(_)),
        asserta(selaluBenarCD(3)),
        battleStat,!
    );( % PeluangAttackMusuh mod 3 is not 0
        daemonFlag(1), selaluBenarAvailable(_),
        daemonNormalAttack,
        % asserta(doubleAttack(1)),
        checkSelaluBenar,!
    ),!.

enemyAttack :-
    daemonFlag(1), \+selaluBenarAvailable(_),
    write('Daemon\'s turn!'),nl,
        daemonNormalAttack,
        checkSelaluBenar,!.

enemyAttack :-
    \+daemonFlag(_),
    spEnemyAvailable(_),
    curMusuh(_,_,_,EnemyHP,EnemyMaxHP,_,_,_,_,_,_,_),
    EnemyHP =< EnemyMaxHP*0.25,
        enemySpecialAttack,
        retract(spEnemyAvailable(_)),
        battleStat,!.

enemyAttack :-
    \+daemonFlag(_),
    \+spEnemyAvailable(_),
        enemyNormalAttack,
        battleStat,!.

enemyAttack :-
    \+daemonFlag(_),
    spEnemyAvailable(_),
    write('Enemy\'s turn!'),nl,
    curMusuh(_,_,_,EnemyHP,EnemyMaxHP,_,_,_,_,_,_,_),
    EnemyHP > EnemyMaxHP*0.25,
    random(1,10,PeluangAttackMusuh),
    PeluangAttackMusuh mod 3 =:= 0 ->
    (
        enemySpecialAttack,
        retract(spEnemyAvailable(_)),
        battleStat,!
    );( % PeluangAttackMusuh mod 3 is not 0
        \+daemonFlag(_),
        spEnemyAvailable(_),
        enemyNormalAttack,
        battleStat,!
    ),!.

daemonNormalAttack :-
    daemonFlag(1), doubleAttack(1),
    random(1,10,PeluangAttackMusuh),
    PeluangAttackMusuh mod 2 =:= 0 ->
    (
        enemySpecialAttack,
        retract(doubleAttack(_)),
        daemonNormalAttack,!
    );( % PeluangAttackMusuh mod 3 is not 0
        daemonFlag(1), doubleAttack(1),
        enemyNormalAttack,
        retract(doubleAttack(_)),
        daemonNormalAttack,!
    ),!.

daemonNormalAttack :-
    daemonFlag(1), \+doubleAttack(_),
    random(1,10,PeluangAttackMusuh),
    PeluangAttackMusuh mod 2 =:= 0 ->
    (
        enemySpecialAttack,
        battleStat,!
    );( % PeluangAttackMusuh mod 3 is not 0
        daemonFlag(1), \+doubleAttack(_),
        enemyNormalAttack,
        battleStat,!
    ),!.

checkSelaluBenar :-
    selaluBenarCD(CD),
    CD =:= 0,
    write('Daemon Skill is ready!'),nl,
    retract(selaluBenarCD(_)),
    asserta(doubleAttack(1)),
    random(2000,8000,PowerUp),
    asserta(selaluBenarAvailable(PowerUp)),!.

checkSelaluBenar :-
    selaluBenarCD(CD),
    CD > 0,
    write('Daemon Skill recharging...'),nl,
    retract(selaluBenarCD(CD)),
    NewCD is CD-1,
    asserta(selaluBenarCD(NewCD)),!.

daemonSkill_SelaluBenar :-
    selaluBenarAvailable(PowerUp),
    curMusuh(Enemy,_,_,_,_,_,_,_,EnemySpAttack,_,_,_),
    equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is floor(float(EnemySpAttack*2.5+PowerUp)),
    write('**WARNING**'),nl,
    write(Enemy),write(' use SELALU BENAR Skill!'),nl,
    write('**WARNING**'),nl,nl,
    write(Enemy), write(' hits you hard!'),nl,
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        !
    );(
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,
        loseBattle,!
    ),!.

enemyNormalAttack :-
    curMusuh(Enemy,_,EnemyElmt,_,_,EnemyNameAttack,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,_,_,_,_,_,_),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier > 1,
        write(Enemy),write(' use '), write(EnemyNameAttack),write('!'),nl,
        write(Enemy), write(' hits you hard!'),nl,
        enemyNormalAttackCalc(ElmtModifier),!.

enemyNormalAttack :-
    curMusuh(Enemy,_,EnemyElmt,_,_,EnemyNameAttack,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,_,_,_,_,_,_),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier =:= 1,
        write(Enemy),write(' use '), write(EnemyNameAttack),write('!'),nl,
        write(Enemy), write(' hits you!'),nl,
        enemyNormalAttackCalc(ElmtModifier),!.

enemyNormalAttack :-
    curMusuh(Enemy,_,EnemyElmt,_,_,EnemyNameAttack,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,_,_,_,_,_,_),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier < 1,
        write(Enemy),write(' use '), write(EnemyNameAttack),write('!'),nl,
        write(Enemy), write(' attack is not very effective...'),
        enemyNormalAttackCalc(ElmtModifier),!.

enemyNormalAttackCalc(ElmtModifier) :-
    defendFlag(_), selaluBenarAvailable(PowerUp),
    curMusuh(Enemy,EnemyType,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
    equTokemon(Tokemon,Type,defend,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is floor(float(EnemyAttack*ElmtModifier+PowerUp)),
    Damage1 is Damage*0.5,
    Damage2 is EnemyHP*0.25,
    Reflect is floor(float((Damage1+Damage2-abs(Damage1-Damage2))/2)),
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    write('But... because your defend is active you can recounter your enemy\'s attack!'),nl,
    write('You dealt '), write(Reflect), write(' to '), write(Enemy), write('!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        NewEnemyHP is EnemyHP-Reflect,
        retract(curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(curMusuh(Enemy,EnemyType,EnemyElmt,NewEnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP)),
        !
    );(
        defendFlag(_), selaluBenarAvailable(PowerUp),
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,
        loseBattle,!
    ),!.

enemyNormalAttackCalc(ElmtModifier) :-
    \+defendFlag(_), selaluBenarAvailable(PowerUp),
    curMusuh(Enemy,_,_,_,_,_,EnemyAttack,_,_,_,_,_),
    equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is floor(float(EnemyAttack*ElmtModifier+PowerUp)),
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        !
    );(
        \+defendFlag(_), selaluBenarAvailable(PowerUp),
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,
        loseBattle,!
    ),!.

enemyNormalAttackCalc(ElmtModifier) :-
    defendFlag(_), \+selaluBenarAvailable(_),
    curMusuh(Enemy,EnemyType,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
    equTokemon(Tokemon,Type,defend,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is floor(float(EnemyAttack*ElmtModifier)),
    Damage1 is Damage*0.5,
    Damage2 is EnemyHP*0.25,
    Reflect is floor(float((Damage1+Damage2-abs(Damage1-Damage2))/2)),
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    write('But... because your defend is active you can recounter your enemy\'s attack!'),nl,
    write('You dealt '), write(Reflect), write(' to '), write(Enemy), write('!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        NewEnemyHP is EnemyHP-Reflect,
        retract(curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(curMusuh(Enemy,EnemyType,EnemyElmt,NewEnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP)),
        !
    );(
        defendFlag(_), \+selaluBenarAvailable(_),
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,
        loseBattle,!
    ),!.

enemyNormalAttackCalc(ElmtModifier) :-
    \+defendFlag(_), \+selaluBenarAvailable(_),
    curMusuh(Enemy,_,_,_,_,_,EnemyAttack,_,_,_,_,_),
    equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is floor(float(EnemyAttack*ElmtModifier)),
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        !
    );(
        \+defendFlag(_), \+selaluBenarAvailable(_),
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,
        loseBattle,!
    ),!.

enemySpecialAttack :-
    curMusuh(Enemy,_,EnemyElmt,_,_,_,_,EnemyNameSpAttack,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,_,_,_,_,_,_),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier > 1,
        write(Enemy),write(' use '), write(EnemyNameSpAttack),write('!'),nl,
        write(Enemy), write(' hits you hard!'),nl,
        enemySpecialAttackCalc(ElmtModifier),!.

enemySpecialAttack :-
    curMusuh(Enemy,_,EnemyElmt,_,_,_,_,EnemyNameSpAttack,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,_,_,_,_,_,_),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier =:= 1,
        write(Enemy),write(' use '), write(EnemyNameSpAttack),write('!'),nl,
        write(Enemy), write(' hits you!'),nl,
        enemySpecialAttackCalc(ElmtModifier),!.

enemySpecialAttack :-
    curMusuh(Enemy,_,EnemyElmt,_,_,_,_,EnemyNameSpAttack,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,_,_,_,_,_,_),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier < 1,
        write(Enemy),write(' use '), write(EnemyNameSpAttack),write('!'),nl,
        write(Enemy), write(' attack is not very effective...'),nl,
        enemySpecialAttackCalc(ElmtModifier),!.

enemySpecialAttackCalc(ElmtModifier) :-
    defendFlag(_), selaluBenarAvailable(PowerUp),
    curMusuh(Enemy,EnemyType,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
    equTokemon(Tokemon,Type,defend,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is floor(float(EnemyAttack*ElmtModifier+PowerUp)),
    Damage1 is Damage*0.5,
    Damage2 is EnemyHP*0.25,
    Reflect is floor(float((Damage1+Damage2-abs(Damage1-Damage2))/2)),
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    write('But... because your defend is active you can recounter your enemy\'s attack!'),nl,
    write('You dealt '), write(Reflect), write(' to '), write(Enemy), write('!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        NewEnemyHP is EnemyHP-Reflect,
        retract(curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(curMusuh(Enemy,EnemyType,EnemyElmt,NewEnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP)),
        !
    );(
        defendFlag(_), selaluBenarAvailable(PowerUp),
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,
        loseBattle,!
    ),!.

enemySpecialAttackCalc(ElmtModifier) :-
    \+defendFlag(_), selaluBenarAvailable(PowerUp),
    curMusuh(Enemy,_,_,_,_,_,_,_,EnemySpAttack,_,_,_),
    equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is floor(float(EnemySpAttack*ElmtModifier+PowerUp)),
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        !
    );(
        \+defendFlag(_), selaluBenarAvailable(PowerUp),
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,
        loseBattle,!
    ),!.

enemySpecialAttackCalc(ElmtModifier) :-
    defendFlag(_), \+selaluBenarAvailable(_),
    curMusuh(Enemy,EnemyType,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
    equTokemon(Tokemon,Type,defend,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is floor(float(EnemyAttack*ElmtModifier)),
    Damage1 is Damage*0.5,
    Damage2 is EnemyHP*0.25,
    Reflect is floor(float((Damage1+Damage2-abs(Damage1-Damage2))/2)),
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    write('But... because your defend is active you can recounter your enemy\'s attack!'),nl,
    write('You dealt '), write(Reflect), write(' to '), write(Enemy), write('!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        NewEnemyHP is EnemyHP-Reflect,
        retract(curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(curMusuh(Enemy,EnemyType,EnemyElmt,NewEnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP)),
        !
    );(
        defendFlag(_), \+selaluBenarAvailable(_),
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,
        loseBattle,!
    ),!.

enemySpecialAttackCalc(ElmtModifier) :-
    \+defendFlag(_), \+selaluBenarAvailable(_),
    curMusuh(Enemy,_,_,_,_,_,_,_,EnemySpAttack,_,_,_),
    equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is floor(float(EnemySpAttack*ElmtModifier)),
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        !
    );(
        \+defendFlag(_), \+selaluBenarAvailable(_),
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,
        loseBattle,!
    ),!.

elmtCalc(fire, leaves, 1.5).
elmtCalc(fire, water, 0.5).
elmtCalc(fire, fire, 1).
elmtCalc(leaves, leaves, 1).
elmtCalc(leaves, water, 1.5).
elmtCalc(leaves, fire, 0.5).
elmtCalc(water, leaves, 0.5).
elmtCalc(water, water, 1).
elmtCalc(water, fire, 1.5).

elmtCalc(hmif, signum, 0.5).
elmtCalc(hmif, hmif, 1).
elmtCalc(hmif, hme, 1.5).
elmtCalc(hme, hmif, 0.5).
elmtCalc(hme, hme, 1).
elmtCalc(hme, signum, 1.5).
elmtCalc(signum, hme, 0.5).
elmtCalc(signum, signum, 1).
elmtCalc(signum, hmif, 1.5).

elmtCalc(hmif, fire, 1.5).
elmtCalc(hmif, leaves, 1.5).
elmtCalc(hmif, water, 1.5).
elmtCalc(hme, fire, 2).
elmtCalc(hme, leaves, 2).
elmtCalc(hme, water, 2).
elmtCalc(signum, water, 0.5).
elmtCalc(signum, fire, 3).
elmtCalc(signum, leaves, 1).

elmtCalc(fire, hmif, 0.5).
elmtCalc(leaves, hmif, 0.5).
elmtCalc(water, hmif, 0.5).
elmtCalc(fire, hme, 1).
elmtCalc(leaves, hme, 1).
elmtCalc(water, hme, 1).
elmtCalc(water, signum, 1).
elmtCalc(fire, signum, 1).
elmtCalc(leaves, signum, 1).

elmtCalc(hmif, defend, 0.25).
elmtCalc(hme, defend, 0.25).
elmtCalc(signum, defend, 0.25).
elmtCalc(fire, defend, 0.25).
elmtCalc(leaves, defend, 0.25).
elmtCalc(water, defend, 0.25).

/* Post-Battle */

dispInventory :-
    findall(X, inventory(X,_,_,_,_,_,_,_,_,_,_,_), YourTokemons),
    write('Your Tokemons are: ['),
    printList(YourTokemons),
    write(']'),nl,!.

capture :-
    \+winbattleFlag(_),!.

capture :-
    winbattleFlag(_),
    cekBanyakTokemon(N),
    N < 6,
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
    NewEnemyHP is floor(float(0.5*EnemyMaxHP)),
    addTokemon(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
    write('You captured '), write(Enemy), write('!'),nl,
    endBattle,!.

capture :-
    winbattleFlag(_),
    cekBanyakTokemon(N),
    N > 5,
    write('Your inventory is full! [drop(X)] a pokemon first!. (use [dispInventory] to see your inventory)'),nl,nl,
    dispInventory,!.

no :-
    \+winbattleFlag(_),!.

no :-
    winbattleFlag(_),
    curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_),
    write(Enemy), write(' began running away trying to heal somewhere in the woods'),nl,
    write('What a merciful person you are!'),nl,
    endBattle,!.

endBattle :-
    \+winbattleFlag(_),!.

endBattle :-
    winbattleFlag(_),
    shareEXP(EXP),
    write('You got '), write(EXP), write(' EXPs!'),nl,
    retract(curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_)),
    retract(winbattleFlag(_)),
    cekLegendaryObj,
    map,!.

shareEXP(Cuan) :-
    curMusuh(Enemy,Type,_,_,_,_,_,_,_,_,_,_),
    Type == legendary,
    random(1500,2000,Cuan),
    forall((inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp), Tokemon \== Enemy), (
        NewCurExp is CurExp+Cuan,
        retract(inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp)),
        asserta(inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, NewCurExp, NeededExp))
        )),!.

shareEXP(Cuan) :-
    curMusuh(Enemy,Type,_,_,_,_,_,_,_,_,_,_),
    Type == normal,
    random(500, 750, Cuan),
    forall((inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp), Tokemon \== Enemy), (
        NewCurExp is CurExp+Cuan,
        retract(inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp)),
        asserta(inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, NewCurExp, NeededExp))
        )),!.

shareEXP(Cuan) :-
    curMusuh(Enemy,Type,_,_,_,_,_,_,_,_,_,_),
    Type == superlegendary,
    Cuan is 5000,
    forall((inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp), Tokemon \== Enemy, CurExp =\= -1), (
        NewCurExp is CurExp+5000,
        retract(inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, CurExp, NeededExp)),
        asserta(inventory(Tokemon, Type, Elemental, HP, MaxHP, NamaAtk, Atk, NamaSpAtk, SpAtk, Lvl, NewCurExp, NeededExp))
        )),!.

cekLegendaryObj :-
    \+winbattleFlag(_),!.

cekLegendaryObj :-
    winbattleFlag(_),
    findall(X, (musuh(_,X,Type,_,_,_,_,_,_,_,_,_,_), Type == legendary), LegendaryList),
    length(LegendaryList, Len),
    Len > 0,
    write('Your journey doesn\'t end here, cap\'n!'),nl,
    write('There are still '), write(Len), write(' legendary tokemon(s) left.'),nl,
    write('Check your status to see their name\'s.'),nl,nl,
    !.

cekLegendaryObj :-
    winbattleFlag(_),
    findall(X, (musuh(_,X,Type,_,_,_,_,_,_,_,_,_,_), Type == legendary), LegendaryList),
    length(LegendaryList, Len),
    Len =:= 0,
    write('You have found all legendary tokemons!!'),nl,
    write('Congratulations.. work so hard forget how to vacations..'),nl,nl,
    retract(curMusuh(_,_,_,_,_,_,_,_,_,_,_,_)), retract(winbattleFlag(_)), asserta(wingameFlag(_)),
    youWin,!.


loseBattle :-
    \+losebattleFlag(_),!.

loseBattle :-
    losebattleFlag(_),
    cekBanyakTokemon(N),
    N > 0,
    write('You watch powerlessly seeing your tokemon dies in front of you...'),nl,
    write('But, you still have other tokemons! They\'re waiting for you to take revenge!'),nl,nl,
    retract(losebattleFlag(_)), asserta(pbattleFlag(_)),
    dispTokemon,!.

loseBattle :-
    losebattleFlag(_),
    cekBanyakTokemon(N),
    N =:= 0,
    write('You watch powerlessly seeing your tokemon dies in front of you...'),nl,
    write('You have no tokemon left. You lose.'),nl,nl,
    retract(curMusuh(_,_,_,_,_,_,_,_,_,_,_,_)),retract(losebattleFlag(_)), asserta(gameoverFlag(_)),
    gameOver,!.
