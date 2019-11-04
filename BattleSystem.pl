
:- dynamic(musuh/5).
:- dynamic(inventory/2).
/* Pre-Battle */
pickTokemon() %cek inventory

/* In-Battle */
dispStatus()
com() %choose command
atkCalc()
specAtkCalc()
ElmtCalc()

/* Post-Battle */
endBattle()
loseBattle()
winBattle()
% update