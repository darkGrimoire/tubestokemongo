:- include('utils.pl').
:- dynamic(maxInventory/1).
:- dynamic(equTokemon/6).
:- dynamic(inventory/6).
:- dynamic(curMusuh/6).

:- dynamic(pbattleFlag/1).
:- dynamic(inbattleFlag/1).

/* For debugging purpose */
:- write('a wild hewwo appears!'),nl,asserta(pbattleFlag(1)), asserta(inventory(fawwis, legendary, fire, 5000, 1250, 3000)), asserta(curMusuh(hewwo, legendary, leaves, 8000, 800, 2500)).

/* Additional functions */
/* utils->printList(List). */
printList([]) :- !.
printList([H|Tail]) :-
	write(H), printList(Tail),!.

/* Pre-Battle */
% Display Tokemons
dispTokemon :-
    findall(X, inventory(X,_,_,_,_,_), yourTokemons),
    write('Your Tokemons are: ['),
    printList(yourTokemons),
    write(']'),nl,
    write('choose your Tokemons! ( pick(tokemon_name). or stat(tokemon_name) )'),nl,!.

% Cek inventory, udah pasti di inventory ada tokemons minimal 1
pick(Tokemon) :-
    \+pbattleFlag(_),!.

pick(Tokemon) :-
    \+inventory(Tokemon,_,_,_,_,_),
    write('You don\'t have '), write(Tokemon), write('!'),nl,
    dispTokemon,!.

pick(Tokemon) :-
    inventory(Tokemon,Type,Elmt,HP,Attack,Sp_attack),
    asserta(equTokemon(Tokemon,Type,Elmt,HP,Attack,Sp_attack)),
    write('You: "I choose '), write(Tokemon), write('!"'),nl,nl,
    asserta(spAvailable(1)), retract(pbattleFlag(_)), asserta(inbattleFlag(1)),
    battleStat,!.

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
    write('Special Attack: '), write(Sp_attack),nl,nl,!.

/* In-Battle */
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
    inbattleFlag(_), spAvailable(_),
    write('Special Attack available!'),nl,
    write('attack or specialAttack?'),nl,!.

attack :-
    inbattleFlag(_),
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    equTokemon(_,_,Elmt,HP,Attack,_),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier > 1 ->
    (
        write('The enemy is weak from your element!'),
        Damage is Attack*ElmtModifier,
        write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
        Damage < EnemyHP ->
        (
            NewEnemyHP is EnemyHP-Damage,
            retract(curMusuh(Enemy,_,_,_,_,_)),
            asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyAttack,EnemySpAttack)),
            battleStat,!
        );(
            retract(curMusuh(Enemy,_,_,_,_,_)),
            write('The enemy has fallen! Do you want to capture it?')
        )
    );(
        ElmtModifier == 1 ->
        (
            write('Your strike hits the enemy!'),
                Damage is Attack*ElmtModifier,
            write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
            Damage < EnemyHP ->
            (
                NewEnemyHP is EnemyHP-Damage,
                retract(curMusuh(Enemy,_,_,_,_,_)),
                asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyAttack,EnemySpAttack)),
                battleStat,!
            );(
                retract(curMusuh(Enemy,_,_,_,_,_)),
                write('The enemy has fallen! Do you want to capture it?')
            )
        );(
            write('Your attack is not very effective...'),
            Damage is Attack*ElmtModifier,
            write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
            Damage < EnemyHP ->
            (
                NewEnemyHP is EnemyHP-Damage,
                retract(curMusuh(Enemy,_,_,_,_,_)),
                asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyAttack,EnemySpAttack)),
                battleStat,!
            );(
                retract(curMusuh(Enemy,_,_,_,_,_)),
                write('The enemy has fallen! Do you want to capture it?')
            )
        )
    ),
    !.

specialAttack :-
    inbattleFlag(_), spAvailable(_),
    retract(spAvailable(_)),
    curMusuh(Enemy,Type,EnemyElmt,EnemyHP,EnemyAttack,EnemySpAttack),
    equTokemon(_,_,Elmt,HP,_,SpAttack),
    elmtCalc(Elmt, EnemyElmt, ElmtModifier),
    ElmtModifier > 1 ->
    (
        write('The enemy is weak from your element!'),
        Damage is SpAttack*ElmtModifier,
        write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
        Damage < EnemyHP ->
        (
            NewEnemyHP is EnemyHP-Damage,
            retract(curMusuh(Enemy,_,_,_,_,_)),
            asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyAttack,EnemySpAttack)),
            battleStat,!
        );(
            retract(curMusuh(Enemy,_,_,_,_,_)),
            write('The enemy has fallen! Do you want to capture it?')
        )
    );(
        ElmtModifier == 1 ->
        (
            write('Your strike hits the enemy!'),
            Damage is SpAttack*ElmtModifier,
            write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
            Damage < EnemyHP ->
            (
                NewEnemyHP is EnemyHP-Damage,
                retract(curMusuh(Enemy,_,_,_,_,_)),
                asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyAttack,EnemySpAttack)),
                battleStat,!
            );(
                retract(curMusuh(Enemy,_,_,_,_,_)),
                write('The enemy has fallen! Do you want to capture it?')
            )
        );(
            write('Your attack is not very effective...'),
            Damage is SpAttack*ElmtModifier,
            write('You dealt '), write(Damage), write(' to '), write(Enemy), write('!'),nl,
            Damage < EnemyHP ->
            (
                NewEnemyHP is EnemyHP-Damage,
                retract(curMusuh(Enemy,_,_,_,_,_)),
                asserta(curMusuh(Enemy,Type,EnemyElmt,NewEnemyHP,EnemyAttack,EnemySpAttack)),
                battleStat,!
            );(
                retract(curMusuh(Enemy,_,_,_,_,_)),
                write('The enemy has fallen! Do you want to capture it?')
            )
        )
    ),
    !.


elmtCalc(fire, leaves, 1.5).
elmtCalc(fire, water, 0.5).
elmtCalc(fire, fire, 1).
elmtCalc(leaves, leaves, 1).
elmtCalc(leaves, water, 1.5).
elmtCalc(leaves, fire, 0.5).
elmtCalc(water, leaves, 0.5).
elmtCalc(water, water, 1).
elmtCalc(water, fire, 1.5).

/* Post-Battle */
endBattle()
loseBattle()
winBattle()
% update