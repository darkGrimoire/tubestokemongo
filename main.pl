/* Nama Kelompok: 
    Anggota:
        13518017 - Farras Hibban
        13518053 - Fatkhan Masruri
        13518089 - Annisa Rahim
        13518125 - Faris Rizki Ekananda
*/

/* INCLUDES */
:- include('peta.pl').
:- include('player.pl').
:- include('utils.pl').
:- include('ExternalFile.pl').
:- include('BattleSystem.pl').
:- include('tokemon.pl').
/*-----------------------------------------*/

start :-
    gameStarted(_),
    write('The game has started'),nl,!.

start :-
    write('+------------------+'),nl,
    write('|   Insert Badass  |'),nl,
    write('|  ASCII Art Here! |'),nl,
    write('+------------------+'),nl,nl,
    write('Insert badass storyline here'),nl,
    write('and some characters here and'),nl,
    write('Yeah hahaha..'),nl,nl,
    write('Let the game BEGINS!'),nl,nl,
    init_map,
    init_player,
    % init_musuh,
    asserta(gameStarted(1)),
    !.

help :-
    write('[DAFTAR COMMAND]'),nl,
    write('start.   : memulai permainan'),nl,
    write('map.     : memperlihatkan peta'),nl,
    write('status.  : memperlihatkan inventorymu dan objectivesmu'),nl,
    write('help.    : nampilin ini ehe]'),nl,
    write('w.       : gerak 1 petak ke utara'),nl,
    write('s.       : gerak 1 petak ke selatan'),nl,
    write('d.       : gerak 1 petak ke timur'),nl,
    write('a.       : gerak 1 petak ke barat'),nl,!.

map :-
    \+gameStarted(_),
    write('Game belum mulai!'),nl,
    write('Gunakan command [start.] untuk memulai permainannya!'),nl,!.

map :-
    tinggipeta(T),
    lebarpeta(L),
    XMin is 0,
    XMax is L+1,
    YMin is 0,
    YMax is T+1,
    forall(between(YMin,YMax,J), (
        forall(between(XMin,XMax,I), (
            printMap(I,J)
        )),
        nl
    )),
    write('Keterangan Simbol :'), nl,
    write('P    :    Player'), nl,
    write('G    :    Gym'), nl,
!.


quit :-
    retract(gameStarted(_)),
    write('Dadah.'), nl,
    halt.



