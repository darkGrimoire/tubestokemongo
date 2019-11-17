:- include('utils.pl').
:- include('player.pl').
:- dynamic(maxInventory/1).
:- dynamic(equTokemon/12).
:- dynamic(inventory/12).
:- dynamic(curMusuh/12).
:- dynamic(musuh/13).

% FLAGS
:- dynamic(spAvailable/1).
:- dynamic(spEnemyAvailable/1).
:- dynamic(pbattleFlag/1).
:- dynamic(inbattleFlag/1).
:- dynamic(winbattleFlag/1).
:- dynamic(losebattleFlag/1).
:- dynamic(gameoverFlag/1).

/* For debugging purpose */
debug_battle :- write('a wild hewwo appears!'),nl,
    asserta(inventory(radarmon, normal, signum, 50000, 50000, laprak, 2500, radiasi, 8000,3,10000,10000)),
    asserta(curMusuh(daemon, legendary, hmif, 135182, 135182, konsekuensi, 2000, pencoretan, 4000, 1, 1000, 1000)).

/* Additional functions */
% curMusuh(daemon, legendary, hmif, 135182, 135182, konsekuensi, 2000, pencoretan, 4000, 1, 1000, 1000)).
% template: curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
% template: equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
% ,_
/* Pre-Battle */
init_battle :-
    curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_),
    asserta(pbattleFlag(1)), asserta(spEnemyAvailable(1)),
    write('a wild '), write(Enemy), write(' appears!'),nl,
    dispTokemon,!.

% Display Tokemons
dispTokemon :-
    setof(X, inventory(X,_,_,_,_,_,_,_,_,_,_,_), YourTokemons),
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
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    inbattleFlag(_),
    curMusuh(EnemyTokemon,_,EnemyElmt,EnemyHP,EnemyMaxHP,_,_,_,_,_,_,_),
    write('%                    Enemy                        %'),nl,
    write('%    '),write(EnemyTokemon),write('               %'),nl,
    write('%    Health:     '), write(EnemyHP), write(' / '), write(EnemyMaxHP)write('          %'),nl,
    write('%    Elemental:  '), write(EnemyElmt),write('               %'),nl,
    write('%                    Tokemon                      %'),nl,
    equTokemon(Tokemon,_,Elmt,HP,MaxHP,_,_,_,_,_,_,_),
    write('%                ')write(Tokemon),write('                    %'),nl,
    write('%    Health: '), write(HP), write('/'), write(MaxHP),write('             %'),nl,
    write('%    Elemental: '), write(Elmt),write('                   %')nl,nl,
    battleChoice,!.

battleChoice :-
    \+inbattleFlag(_),!.

battleChoice :-
    inbattleFlag(_), spAvailable(_),
    write('Special Attack available!'),nl,
    write('attack or specialAttack?'),nl,!.

battleChoice :-
    inbattleFlag(_), \+spAvailable(_),
    write('attack?'),nl,!.

battleChoice :-
    \+inbattleFlag(_),!.

/* ATTACKS */

attack :-
    \+inbattleFlag(_),!.

attack :-
    inbattleFlag(_),
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,NameAttack,_,_,_,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier > 1,
        write('You use '), write(NameAttack),write('!'),nl,
        write('The enemy is weak from your element!'),nl,
        attackCalc(ElmtModifier),!.

attack :-
    inbattleFlag(_),
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,NameAttack,_,_,_,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier =:= 1,
        write('You use '), write(NameAttack),write('!'),nl,
        write('Your strike hits the enemy!'),nl,
        attackCalc(ElmtModifier),!.

attack :-
    inbattleFlag(_),
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,NameAttack,_,_,_,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier < 1,
        write('You use '), write(NameAttack),write('!'),nl,
        write('Your attack is not very effective...'),nl,
        attackCalc(ElmtModifier),!.

attackCalc(ElmtModifier) :-
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
    equTokemon(_,_,_,_,_,_,Attack,_,_,_,_,_),
    Damage is Attack*ElmtModifier,
    write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
    Damage < EnemyHP ->
    (
        NewEnemyHP is EnemyHP-Damage,
        retract(curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP)),
        enemyAttack,!
    );(
        retract(inbattleFlag(_)), asserta(winbattleFlag(1)),
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
    equTokemon(_,_,Elmt,_,_,_,NameSpAttack,_,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier > 1,
        write('You use '), write(NameSpAttack),write('!'),nl,
        write('The enemy is weak from your element!'),nl,
        specialAttackCalc(ElmtModifier),!.

specialAttackUtil :-
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,NameSpAttack,_,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier =:= 1,
        write('You use '), write(NameSpAttack),write('!'),nl,
        write('Your strike hits the enemy!'),nl,
        specialAttackCalc(ElmtModifier),!.

specialAttackUtil :-
    curMusuh(_,_,EnemyElmt,_,_,_,_,_,_,_,_,_),
    equTokemon(_,_,Elmt,_,_,_,NameSpAttack,_,_,_,_,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier < 1,
        write('You use '), write(NameSpAttack),write('!'),nl,
        write('Your attack is not very effective...'),nl,
        specialAttackCalc(ElmtModifier),!.

specialAttackCalc(ElmtModifier) :-
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
    equTokemon(_,_,_,_,_,_,_,_,SpAttack,_,_,_),
    Damage is SpAttack*ElmtModifier,
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
        write('The enemy has fallen! [capture] or [no]?'),nl,!
    ),!.

enemyAttack :-
    spEnemyAvailable(_),
    curMusuh(_,_,_,EnemyHP,EnemyMaxHP,_,_,_,_,_,_,_),
    EnemyHP =< EnemyMaxHP*0.25,
        enemySpecialAttack,
        retract(spEnemyAvailable(_)),
        battleStat,!.

enemyAttack :-
    \+spEnemyAvailable(_),
        enemyNormalAttack,
        battleStat,!.

enemyAttack :-
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
        enemyNormalAttack,
        battleStat,!
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
    curMusuh(Enemy,_,_,_,_,_,EnemyAttack,_,_,_,_,_),
    equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is EnemyAttack*ElmtModifier,
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(Tokemon,_,_,_,_,_,_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP)),
        !
    );(
        retract(equTokemon(Tokemon,_,_,_,_,_)),
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
    curMusuh(Enemy,_,_,_,_,_,_,_,EnemySpAttack,_,_,_),
    equTokemon(Tokemon,Type,Elmt,HP,MaxHP,NameAttack,Attack,NameSpAttack,SpAttack,Level,CurEXP,NeededEXP),
    Damage is EnemySpAttack*ElmtModifier,
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

/* Post-Battle */

dispInventory :-
    setof(X, inventory(X,_,_,_,_,_,_,_,_,_,_,_), YourTokemons),
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
    addTokemon(Enemy,Type,EnemyElmt,EnemyHP,EnemyMaxHP,EnemyNameAttack,EnemyAttack,EnemyNameSpAttack,EnemySpAttack,EnemyLevel,EnemyCurEXP,EnemyNeededEXP),
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
    retract(curMusuh(Enemy,_,_,_,_,_,_,_,_,_,_,_)),
    retract(winbattleFlag(_)),
    cekLegendaryObj,
    !.

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
    !.