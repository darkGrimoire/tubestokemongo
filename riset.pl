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
