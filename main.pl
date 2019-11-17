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
%:- include('tokemon.pl').
/*-----------------------------------------*/

start :-
    gameStarted(_),
    write('The game has started'),nl,!.

start :-


    write('    _____                                   _     _                             '),nl,   
    write('   (____  | Found Your Daemon!!            | |   | |            _               '),nl,  
    write('    _   | | ____  ____ ____   ___  ____    | |__ | |_   _ ____ | |_  ____  ____ '),nl,
    write('   | |   | / _  |/ _  )    | / _ ||  _ |   |  __)| | | | |  _ ||  _)/ _  )/ ___)'),nl,
    write('   | |__/ ( ( | ( (/ /| | | | |_| | | | |  | |   | | |_| | | | | |_( (/ /| |    '),nl,
    write('   |_____/ |_||_||____)_|_|_||___/|_| |_|  |_|   |_||____|_| |_||___)____)_|    '),nl,
    write(''),nl,
    write('Pengalaman seru Anda akan segera dimulai!!'),nl,
    write(''),nl,
    write('Berikut spek yang Anda perlukan dalam melakukan perjalanan ini'),nl, 
    write(''),nl,menu,

    
                                                                                                                  
    
    init_map,
    init_player,
    % init_musuh,
    asserta(gameStarted(1)),
    !.
menu:-
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,     
    write('%                              ~Daemon Hunter ~                                %'),nl,
    write('% 1. start  : untuk memulai petulanganmu                                       %'),nl,
    write('% 2. map    : menampilkan peta                                                 %'),nl,
    write('% 3. status : menampilkan kondisimu terkini                                    %'),nl,
    write('% 4. w      : gerak ke utara 1 langkah                                         %'),nl,
    write('% 5. s      : gerak ke selatan 1 langkah                                       %'),nl,
    write('% 6. d      : gerak ke ke timur 1 langkah                                      %'),nl,
    write('% 7. a      : gerak ke barat 1 langkah                                         %'),nl,
    write('% 8. help   : menampilkan segala bantuan                                       %'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl.

help :-
    menu,
    write('[DAFTAR COMMAND]'),nl,
    write('start.   : memulai permainan'),nl,
    write('map.     : memperlihatkan peta'),nl,
    write('status.  : memperlihatkan inventorymu dan objectivesmu'),nl,
    write('help.    : nampilin ini ehe]'),nl,
    write('w.       : gerak 1 petak ke utara'),nl,
    write('s.       : gerak 1 petak ke selatan'),nl,
    write('d.       : gerak 1 petak ke timur'),nl,
    write('a.       : gerak 1 petak ke barat'),nl,
    write('Keterangan Simbol :'), nl,
    write('P    :    Player'), nl,
    write('G    :    Gym'), nl,!.

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
!.


quit :-
    retract(gameStarted(_)),
    write('Dadah.'), nl,
    halt.



