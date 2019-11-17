/* LIST UTILS */

/* Checks */
isEmpty([]).
% length(List, ListLength)

/* Index Manipulation */
% searchX(List, X, IndexResult)
searchX([],_,-1) :- !.
searchX([X|_],X,0) :- !.
searchX([_|Tail],X,IndexBaru) :- 
	searchX(Tail,X,Index),
	Index \= -1,
	IndexBaru is Index+1,
	!.
searchX(_,_,-1) :- !.

% searchIdx(List, Index, X)
searchIdx([],0,'') :- !.
searchIdx([C|_],0,C) :- !.
searchIdx([_|LTail],Pos,C) :- 
	PosBaru is (Pos-1),
	searchIdx(LTail,PosBaru,C),
	!.

/* List Manipulation */
% appendList(e, List, ListResult)
appendList(X,L,[X|L]).

%assert facts from a list
assertaList([]) :- !.

assertaList([X|L]) :-
	asserta(X),
	assertaList(L), !.