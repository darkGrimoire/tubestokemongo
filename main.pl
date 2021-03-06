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
    init_musuh(17),
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
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    apakahBisaLevelUp(Bisa1), isReadytoEvolve(Bisa2).
    

help :-
    menu,
    write('[DAFTAR COMMAND]'),nl,
    write('start.   : memulai permainan'),nl,
    write('map.     : memperlihatkan peta'),nl,
    write('status.  : memperlihatkan inventorymu dan objectivesmu'),nl,
    write('help.    : nampilin ini ehe]'),nl,
    write('loadd(F).: memuat permainan dari file bernama F'),nl,
    write('save(F). : menyimpan permainan ke file bernama F'),nl,
    write('quit     : keluar permainan'),nl,
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
    apakahBisaLevelUp(Bisa1), isReadytoEvolve(Bisa2),
    !.


quit :-
    %retract(gameStarted(_)),
    write('Dadah.'), nl,
    halt.


gameOver :-
write('     ______                        ____                 '),nl,
write('    / ____/___ _____ ___  ___     / __ \\_   _____  _____'),nl,
write('   / / __/ __ `/ __ `__ \\/ _ \\   / / / / | / / _ \\/ ___/'),nl,
write('  / /_/ / /_/ / / / / / /  __/  / /_/ /| |/ /  __/ /    '),nl,
write('  \\____/\\__,_/_/ /_/ /_/\\___/   \\____/ |___/\\___/_/     '),nl,nl,

write('      ___              __         __                       __________  ____  ____________  '),nl,
write('     /   |  ____  ____/ /___ _   / /_____  ____  ____ _   / ____/ __ \\/ __ \\/ ____/_  __/  '),nl,
write('    / /| | / __ \\/ __  / __ `/  / //_/ _ \\/ __ \\/ __ `/  / /   / / / / /_/ / __/   / /     '),nl,
write('   / ___ |/ / / / /_/ / /_/ /  / ,< /  __/ / / / /_/ /  / /___/ /_/ / _, _/ /___  / /      '),nl,
write('  /_/  |_/_/ /_/\\__,_/\\__,_/  /_/|_|\\___/_/ /_/\\__,_/   \\____/\\____/_/ |_/_____/ /_/       '),nl,nl,
                                                                                        

write('           __     __       ____  ___    ________  _______  _   __      __  '),nl,
write('    ____  / /__  / /_     / __ \\/   |  / ____/  |/  / __ \\/ | / /  _ _/_/  '),nl,
write('   / __ \\/ / _ \\/ __ \\   / / / / /| | / __/ / /|_/ / / / /  |/ /  (_) /    '),nl,
write('  / /_/ / /  __/ / / /  / /_/ / ___ |/ /___/ /  / / /_/ / /|  /  _ / /     '),nl,
write('  \\____/_/\\___/_/ /_/  /_____/_/  |_/_____/_/  /_/\\____/_/ |_/  (_) /      '),nl,
write('                                                                  |_|      '),nl,nl,

write('Coba lagi ya tahun depan huehue.... :( '), nl.


youWin :-
write('  __  __               _       ___       ____   __        _____         '),nl,
write('  \\ \\/ /___  __  __   | |     / (_)___  / / /  / /_  ___ |__  /_  __    '),nl,
write('   \\  / __ \\/ / / /   | | /| / / / __ \\/ / /  / __ \\/ _ \\ /_ <| |/_/    '),nl,
write('   / / /_/ / /_/ /    | |/ |/ / / / / /_/_/  / / / /  __/__/ />  <_ _ _ '),nl,
write('  /_/\\____/\\__,_/     |__/|__/_/_/ /_(_|_)  /_/ /_/\\___/____/_/|_(_| | )'),nl,
write('                                                          |/|/          '),nl,nl,

write('Malam bersama DAEMON itu terasa sangat penjang dan menegangkan. Berbagai macam rintangan dan halangan'), nl,
write('kamu lalui bersama para tokemon kebanggaanmu. Kamu berhasil menyelesaikan permasalahan angkatan para '), nl,
write('tokemon-tokemonmu. Kamu juga berhasil membuktikan komitmenmu melalui pertandingan melawan DAEMON.... '), nl,nl,

write('Maka dari itu, bersenanglah...,'), nl,
write('berbahagialah...,  '), nl,
write('hiruplah udara pagi yang segar nan tidak kelihatan ini... '), nl,
write('jangan lupa bersyukur..., jangan lupa sholat..., karena kamu...'), nl,nl,

write('      __    ___    _   ________________  __  ________   ______     ____  '), nl,
write('     / /   /   |  / | / /_  __/  _/ __ \\/ / / / ____/  / / / /  _ / __ \\ '), nl,
write('    / /   / /| | /  |/ / / /  / // / / / / / / __/    / / / /  (_) / / / '), nl,
write('   / /___/ ___ |/ /|  / / / _/ // /_/ / /_/ / /___   /_/_/_/  _ / /_/ /  '), nl,
write('  /_____/_/  |_/_/ |_/ /_/ /___/\\___\\_\\____/_____/  (_|_|_)  (_)_____/   '), nl, hehe,nl.

hehe:-
    write('    NhyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyhM'),nl,
    write('    N/-----------oyyyyyyyyyyyyyyyyyyyyyyyyys++++oyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyys-:M'),nl,
    write('    N/:+os+:-----dMMMMMMMMMMMMMMMMMMMMMMMMMd----/MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm-:M'),nl,
    write('    N/:+os+:-----shhhhhhhhhhhhhhhhhhhhhhhhhs----/hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhy-:M'),nl,
    write('    N/:++++:-----ydddddddddddddddddddddddddh++++odddddddddddddddddddddddddddddddddddddddddddddddddddh-:M'),nl,
    write('    N/:++ss:-----dMMMMMMMMMMMMMMMMMMMMMMMMMd----/MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMm-:M'),nl,
    write('    N/:oo/:------+ssssssssssssssssssssssssso::::/ssssssssssssssssssssssssssssssssssssssssssssssssssso-:M'),nl,
    write('    N/:+++s:-----/++++++MMMMMMMMMMMMMo+++++++++++++++++dMMMMMMMMMMMMh++++++++++++++++++++sMMMMMMMMMMm-:M'),nl,
    write('    N/:+y+s/-----------:MMMMMMMMMMMMM/-----------------hMMMMMMMMMMMMy---------------------hMMMMMMMMMm-:M'),nl,
    write('    N/--/+o:-----/++++++sssssssssssss++++++++++++++++++ossssssssssssoooooooooooo+++++++++++ooooooooo+-:M'),nl,
    write('    N//o+++:-----------:MMMMMMMMMMMMM/-----------------hMMMMMMMMMMMMMMMMMMMMMMMMN-:+++o+::+o/://+:+/--:M'),nl,
    write('    N//o+++:-----------:mmmmmmmmmmmmm/-----------------ymmmmmmmmmmmmmmmmmmmmmmmmd-/o//+s+o/s+oo//+o/--:M'),nl,
    write('    N/:++os:-----/++++++yyyyyyyyyyyyy++++++++++++++++++syyyyyyyyyyyyyyyyyyyyyyyyy++s+o+y/o/s/oo+++ys+-:M'),nl,
    write('    N/:sso/:-----------:MMMMMMMMMMMMM/-----------------hMMMMMMMMMMMMMMMMMMMMMMMMN-:o+:-+:+/-+/o:-:+s:-:M'),nl,
    write('    N/:oo/::-----------:yyyyyyyyyyyyy:-----------------oyyyyyyyyyyyyyyyyyyyyyyyyy--:+///o+:-/o+os/+:--:M'),nl,
    write('    N/-:yos:-----/++++++mmmmmmmmmmmmmo+++++++++++++++++hmmmmmmmmmmmmh++++++++++++++s:-:-//s-soyo:-/s+-:M'),nl,
    write('    N//s+++:-----------:MMMMMMMMMMMMM/-----------------hMMMMMMMMMMMMy-------------+::/s+::s+oss+o--+--:M'),nl,
    write('    N/-:++/:-----::::::/sssssssssssss/:::::::::::::::::+ssssssssssss+:::::::::::::o:oy/o+s+/::o+o+oo:-:M'),nl,
    write('    N/:s+++:-----dMMMMMMMMMMMMMMMMMMMMMMMMMm////oMMMMMMMMMMMMMMMMMMMMMMMMMMMMh////+ooss+++/++//o+++s/-:M'),nl,
    write('    N/-----------dMMMMMMMMMMMMMMMMMMMMMMMMMd----/MMMMMMMMMMMMMMMMMMMMMMMMMMMMy---:+--/://++s++/:----o-:M'),nl,
    write('    N/-----------+oooooooooooooooooooooooooo+++++ooooooooooooooooooooooooooooo++++s+//:::ooooo::://+o-:M'),nl,
    write('    N/-----------dMMMMMMMMMMMMMMMMMMMMMMMMMd----/MMMMMMMMMMMMMMMMMMMMMMMMMMMMy----/+///////////////o:-:M'),nl,
    write('    N/------/+---ymmmmmmmmmmmmmmmmmmmmmmmmmy----/mmmmmmmmmmmmmmmmmmmmmmmmmmmms-----:///////////////:--:M'),nl,
    write('    N/----+os/:/-/++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/-:M'),nl,
    write('    N/----:o+oso++::----------------------------------------------------------------------------------:M'),nl,
    write('    N/------/o+os/s+:o::s/-o++/+/o++/o-+o-o-o+-----------:ooo:o:s++:o++o:s/++oo-/s-/s:/oo/+:o:+/-oo---:M'),nl,
    write('    N/----------o:o:+s-y+y:++++o/++++/oooo/oos+----------/ss:oy:y//:s--s:h+y/s++os:y+y:++-o/yoo:+soo--:M'),nl,
    write('    N/--------------/::/-:+/++//:/++/-+:-+:+--+----------://:-o:+---/++/:+-:+/:+://:-//:/-/:+-:++--+:-:M'),nl,
    write('    N/------------------------------------------------------------------------------------------------:M'),nl,
    write('    N/-h+d/y:hs+/yy/h/sy/y:+s/ys/-:oh+syo/y+s/oh:y/yos+y:-:yos+oooo/y--ysy+-sh:/d/y-d+y/y:+osh:y/y+o:-:M'),nl,
    write('    N/-d+ssd:ssh-so-d-+y-yoso-s+---:h-syo/yoy+s+yh/y+y+h++/h+sososm/y--ysys+yoh/ysm-d+y+y+sos+yh+yod+-:M'),nl,
    write('    N/-:::-:-:::-::-:-::--::--::---::-::::::-:::::-:::-:::::::--:::::--:::-::-:::-:-:::--::-::::-:::--:M'),nl,
    write('    NysssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssM'),nl.

                                                          
