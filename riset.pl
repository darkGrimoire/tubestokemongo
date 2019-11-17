
/*
:- dynamic(test/3).
:- asserta(test(1000,2,500)),
    test(NeededExp, Level, HP),
    NewLevel is Level+1,
    NewNeededExp is NeededExp+((NewLevel)*1000),
    LowBound is 0.1*HP,
    HighBound is 0.3*HP,
    random(LowBound, HighBound, NewHP),
    NewHP2 is floor(NewHP+HP),
    retract(test(_,_,_)),
    asserta(test(NewNeededExp,NewLevel,NewHP2)).
*/

%test :- retractall(inventory), retractall(isGym), retractall(pos).

%inventory(catamon,normal,water,4800,5000,cakar_aja,500,cakar_banget,750,1,0,1000).
%inventory(garamon,legendary,water,21020,salt,1200,saltbae,2000,1,0,10000).

%pos(1,2).

%isGym(1,2).

try :- N is 1,
	write(N),
	N1 is N+1,
	write(N1),
	N is N1+1,
	write(N).
