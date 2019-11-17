:- include('utils.pl').
:- include('player.pl').
:- dynamic(maxInventory/1).
:- dynamic(equTokemon/6).
:- dynamic(inventory/6).
:- dynamic(curMusuh/6).

% FLAGS
:- dynamic(pbattleFlag/1).
:- dynamic(inbattleFlag/1).

/* For debugging purpose */
:- write('a wild hewwo appears!'),nl,
    asserta(inventory(fawwis, legendary, signum, 5000, 1250, 3000)),
    asserta(curMusuh(hewwo, legendary, fire, 8000, 800, 2500)).

/* Additional functions */


/* Pre-Battle */
init_battle :-
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    asserta(pbattleFlag(1)), asserta(spEnemyAvailable(1)),
    write('a wild '), write(Enemy), write(' appears!'),nl,
    dispTokemon,!.

% Display Tokemons
dispTokemon :-
    setof(X, X^inventory(X,_,_,_,_,_), YourTokemons),
    write('Your Tokemons are: ['),
    printList(YourTokemons),
    write(']'),nl,
    write('choose your Tokemons! ( pick(tokemon_name). or stat(tokemon_name) )'),nl,!.

% Cek inventory, udah pasti di inventory ada tokemons minimal 1
pick(Tokemon) :-
    \+pbattleFlag(_),!.

pick(Tokemon) :-
    pbattleFlag(_),
    \+inventory(Tokemon,_,_,_,_,_),
    write('You don\'t have '), write(Tokemon), write('!'),nl,
    dispTokemon,!.

pick(Tokemon) :-
    pbattleFlag(_),
    inventory(Tokemon,Type,Elmt,HP,Attack,Sp_attack),
    asserta(equTokemon(Tokemon,Type,Elmt,HP,Attack,Sp_attack)),
    write('You: "I choose '), write(Tokemon), write('!"'),nl,nl,
    asserta(spAvailable(1)), retract(pbattleFlag(_)), asserta(inbattleFlag(1)),
    battleStat,!.

stat(Tokemon) :-
    \+pbattleFlag(_),!.

stat(Tokemon):-
    pbattleFlag(_),
    \+inventory(Tokemon,_,_,_,_,_),
    write('You don\'t have '), write(Tokemon), write('!'),nl,
    dispTokemon,!.

stat(Tokemon) :-
    pbattleFlag(_),
    inventory(Tokemon,Type,Elmt,HP,Attack,Sp_attack),
    write('Name: '), write(Tokemon),nl,
    write('Type: '), write(Type),nl,
    write('Elemental: '), write(Elmt),nl,
    write('HP: '), write(HP),nl,
    write('Attack: '), write(Attack),nl,
    write('Special Attack: '), write(Sp_attack),nl,nl,
    dispTokemon,!.

/* In-Battle */
battleStat :-
    \+inbattleFlag(_),!.

battleStat :-
    inbattleFlag(_),
    curMusuh(EnemyTokemon,_,EnemyElmt,EnemyHP,_,_),
    write(EnemyTokemon),nl,
    write('Health: '), write(EnemyHP),nl,
    write('Elemental: '), write(EnemyElmt),nl,
    equTokemon(Tokemon,_,Elmt,HP,_,_),
    write(Tokemon),nl,
    write('Health: '), write(HP),nl,
    write('Elemental: '), write(Elmt),nl,nl,
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
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    equTokemon(_,_,Elmt,HP,Attack,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier > 1,
        write('The enemy is weak from your element!'),nl,
        attackCalc(ElmtModifier),!.

attack :-
    inbattleFlag(_),
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    equTokemon(_,_,Elmt,HP,Attack,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier =:= 1,
        write('Your strike hits the enemy!'),nl,
        attackCalc(ElmtModifier),!.

attack :-
    inbattleFlag(_),
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    equTokemon(_,_,Elmt,HP,Attack,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier < 1,
        write('Your attack is not very effective...'),nl,
        attackCalc(ElmtModifier),!.

attackCalc(ElmtModifier) :-
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    equTokemon(_,_,Elmt,HP,Attack,_),
    Damage is Attack*ElmtModifier,
    write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
    Damage < EnemyHP ->
    (
        NewEnemyHP is EnemyHP-Damage,
        retract(curMusuh(Enemy,_,_,_,_,_)),
        asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyAttack,EnemySpAttack)),
        enemyAttack,!
    );(
        % retract(curMusuh(Enemy,_,_,_,_,_)),
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
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    equTokemon(_,_,Elmt,HP,_,SpAttack),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier > 1,
        write('The enemy is weak from your element!'),nl,
        specialAttackCalc(ElmtModifier),!.

specialAttackUtil :-
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    equTokemon(_,_,Elmt,HP,_,SpAttack),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier =:= 1,
        write('Your strike hits the enemy!'),nl,
        specialAttackCalc(ElmtModifier),!.

specialAttackUtil :-
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    equTokemon(_,_,Elmt,HP,_,SpAttack),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier < 1,
        write('Your attack is not very effective...'),nl,
        specialAttackCalc(ElmtModifier),!.

specialAttackCalc(ElmtModifier) :-
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    equTokemon(_,_,Elmt,HP,_,SpAttack),
    Damage is SpAttack*ElmtModifier,
    write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
    Damage < EnemyHP ->
    (
        NewEnemyHP is EnemyHP-Damage,
        retract(curMusuh(Enemy,_,_,_,_,_)),
        asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyAttack,EnemySpAttack)),
        enemyAttack,!
    );(
        % retract(curMusuh(Enemy,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(winbattleFlag(1)),
        write('The enemy has fallen! [capture] or [no]?'),nl,!
    ),!.

enemyAttack :-
    spEnemyAvailable(_),
    curMusuh(Enemy,_,_,EnemyHP,_,_),
    EnemyHP < 2000,
        enemySpecialAttack,
        retract(spEnemyAvailable(_)),
        battleStat,!.

enemyAttack :-
    \+spEnemyAvailable(_),
    curMusuh(Enemy,_,_,EnemyHP,_,_),
        enemyNormalAttack,
        battleStat,!.

enemyAttack :-
    spEnemyAvailable(_),
    write('Enemy\'s turn!'),nl,
    curMusuh(Enemy,_,_,EnemyHP,_,_),
    EnemyHP > 2000,
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
    curMusuh(Enemy,_,EnemyElmt,EnemyHP,EnemyAttack,_),
    equTokemon(Tokemon,Type,Elmt,HP,Attack,SpAttack),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier > 1,
        write(Enemy), write(' hits you hard!'),nl,
        enemyNormalAttackCalc(ElmtModifier),!.

enemyNormalAttack :-
    curMusuh(Enemy,_,EnemyElmt,EnemyHP,EnemyAttack,_),
    equTokemon(Tokemon,Type,Elmt,HP,Attack,SpAttack),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier =:= 1,
        write(Enemy), write(' hits you!'),nl,
        enemyNormalAttackCalc(ElmtModifier),!.

enemyNormalAttack :-
    curMusuh(Enemy,_,EnemyElmt,EnemyHP,EnemyAttack,_),
    equTokemon(Tokemon,Type,Elmt,HP,Attack,SpAttack),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier < 1,
        write(Enemy), write(' attack is not very effective...'),
        enemyNormalAttackCalc(ElmtModifier),!.

enemyNormalAttackCalc(ElmtModifier) :-
    curMusuh(Enemy,_,EnemyElmt,EnemyHP,EnemyAttack,_),
    equTokemon(Tokemon,Type,Elmt,HP,Attack,SpAttack),
    Damage is EnemyAttack*ElmtModifier,
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,Attack,SpAttack)),
        !
    );(
        retract(equTokemon(Tokemon,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,!
    ),!.

enemySpecialAttack :-
    curMusuh(Enemy,_,EnemyElmt,EnemyHP,_,EnemySpAttack),
    equTokemon(Tokemon,Type,Elmt,HP,Attack,SpAttack),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier > 1 ->
    (
        write(Enemy), write(' hits you hard!'),nl,
        enemySpecialAttackCalc(ElmtModifier),!
    );(
        elmtCalc(EnemyElmt, Elmt, ElmtModifier),
        curMusuh(Enemy,_,_,_,_,_),
        ElmtModifier =:= 1 ->
        (
            write(Enemy), write(' hits you!'),nl,
            enemySpecialAttackCalc(ElmtModifier),!
        );(
            curMusuh(Enemy,_,_,_,_,_),
            write(Enemy), write(' attack is not very effective...'),nl,
            enemySpecialAttackCalc(ElmtModifier),!
        ),!
    ),
    !.

enemySpecialAttack :-
    curMusuh(Enemy,_,EnemyElmt,EnemyHP,_,EnemySpAttack),
    equTokemon(Tokemon,Type,Elmt,HP,Attack,SpAttack),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier > 1,
        write(Enemy), write(' hits you hard!'),nl,
        enemySpecialAttackCalc(ElmtModifier),!.

enemySpecialAttack :-
    curMusuh(Enemy,_,EnemyElmt,EnemyHP,_,EnemySpAttack),
    equTokemon(Tokemon,Type,Elmt,HP,Attack,SpAttack),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier =:= 1,
        write(Enemy), write(' hits you!'),nl,
        enemySpecialAttackCalc(ElmtModifier),!.

enemySpecialAttack :-
    curMusuh(Enemy,_,EnemyElmt,EnemyHP,_,EnemySpAttack),
    equTokemon(Tokemon,Type,Elmt,HP,Attack,SpAttack),
    elmtCalc(EnemyElmt, Elmt, ElmtModifier),
    ElmtModifier < 1,
        write(Enemy), write(' attack is not very effective...'),
        enemySpecialAttackCalc(ElmtModifier),!.

enemySpecialAttackCalc(ElmtModifier) :-
    curMusuh(Enemy,_,EnemyElmt,EnemyHP,_,EnemySpAttack),
    equTokemon(Tokemon,Type,Elmt,HP,Attack,SpAttack),
    Damage is EnemySpAttack*ElmtModifier,
    write(Enemy), write(' dealt '), write(Damage), write(' to you!'),nl,
    Damage < HP ->
    (
        NewHP is HP-Damage,
        retract(equTokemon(_,_,_,_,_,_)),
        asserta(equTokemon(Tokemon,Type,Elmt,NewHP,Attack,SpAttack)),
        !
    );(
        retract(equTokemon(Tokemon,_,_,_,_,_)),
        retract(inbattleFlag(_)), asserta(losebattleFlag(1)),
        write('You has fallen!'),nl,!
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
    setof(X, X^inventory(X,_,_,_,_,_), YourTokemons),
    write('Your Tokemons are: ['),
    printList(YourTokemons),
    write(']'),nl,!.

capture :-
    winbattleFlag(_),
    cekBanyakTokemon(N),
    N < 6,
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    addTokemon(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    write('You captured '), write(Enemy), write('!'),nl,
    endBattle,!.

capture :-
    winbattleFlag(_),
    cekBanyakTokemon(N),
    N > 5,
    write('Your inventory is full! [drop(X)] a pokemon first!. (use [dispInventory] to see your inventory)'),nl,nl,
    dispInventory,!.

no :-
    winbattleFlag(_),
    curMusuh(Enemy,_,_,_,_,_),
    write(Enemy), write(' began running away trying to heal somewhere in the woods'),nl,
    write('What a merciful person you are!'),nl,
    endBattle,!.

endBattle :-
    retract(curMusuh(Enemy,_,_,_,_,_)),
    retract(winbattleFlag(_)),
    findall(X, musuh(_,_,_))
    status,!.


% loseBattle()
% winBattle()
% % update