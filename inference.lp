

% Infer missing CDC relations
% This program checks consistency of the nCDC network and infers all missing CDC relations
% based on improved ASP formulation of basic CDC networks

1{inferrel(K,L,J): alltiles(J)} :- not existrelation(K,L), region(K), region(L).

existinferrel(K,L) :- inferrel(K,L,J).


% Form the grid

xcoord(0..M-1) :- hsize(M).
ycoord(0..N-1) :- vsize(N).


% Below we find, directional relation is specified for which pair of regions

existrelation(K,L) :- relation(K,L,J).

reference(L) :- existrelation(_,L).
target(K) :- existrelation(K,_).


% Bounds of regions in x and y dimensions (to find MBR)

1{infx(K,X): xcoord(X)}1 :- region(K).
1{supx(K,X): xcoord(X)}1 :- region(K).
1{infy(K,Y): ycoord(Y)}1 :- region(K).
1{supy(K,Y): ycoord(Y)}1 :- region(K).


% Constraints on inf and sup

:- X2<X1, infx(K,X1), supx(K,X2), region(K).
:- Y2<Y1, infy(K,Y1), supy(K,Y2), region(K).


% Generate cells for all regions

1{occupy(K,X,Y): xcoord(X), ycoord(Y)} :- region(K).

xoccupy(K,X) :- occupy(K,X,_).
yoccupy(K,Y) :- occupy(K,_,Y).


% Ensure that every object has a cell at its borders so that infx,infy,supx,supy holds 

:- not xoccupy(K,X1), infx(K,X1).
:- not xoccupy(K,X2), supx(K,X2).
:- not yoccupy(K,Y1), infy(K,Y1).
:- not yoccupy(K,Y2), supy(K,Y2).


% Test  bounds of objects

:- xoccupy(K,X), X<X1, infx(K,X1).
:- xoccupy(K,X), X>X2, supx(K,X2).
:- yoccupy(K,Y), Y<Y1, infy(K,Y1).
:- yoccupy(K,Y), Y>Y2, supy(K,Y2).



% Identify 9 tiles of an object

hbox(K,X1..X2) :- infx(K,X1), supx(K,X2).
right(K,X2+1..M-1) :- supx(K,X2), hsize(M).
left(K,0..X1-1) :- infx(K,X1).

vbox(K,Y1..Y2) :- infy(K,Y1), supy(K,Y2).
top(K,Y2+1..N-1) :- supy(K,Y2), vsize(N).
bottom(K,0..Y1-1) :- infy(K,Y1).



%  Check condition (C1) for basic CDC constraints

:- relation(K,L,n), {occupy(K,X,Y): hbox(L,X), top(L,Y)}0.

:- relation(K,L,s), {occupy(K,X,Y): hbox(L,X), bottom(L,Y)}0.

:- relation(K,L,e), {occupy(K,X,Y): right(L,X), vbox(L,Y)}0.

:- relation(K,L,w), {occupy(K,X,Y): left(L,X), vbox(L,Y)}0.

:- relation(K,L,nw), {occupy(K,X,Y): left(L,X), top(L,Y)}0.

:- relation(K,L,sw), {occupy(K,X,Y): left(L,X), bottom(L,Y)}0.

:- relation(K,L,ne), {occupy(K,X,Y): right(L,X), top(L,Y)}0.

:- relation(K,L,se), {occupy(K,X,Y): right(L,X), bottom(L,Y)}0.

:- relation(K,L,o), {occupy(K,X,Y): hbox(L,X), vbox(L,Y)}0.



%  Check condition (C1) for inferred CDC constraints

:- inferrel(K,L,n), {occupy(K,X,Y): hbox(L,X), top(L,Y)}0.

:- inferrel(K,L,s), {occupy(K,X,Y): hbox(L,X), bottom(L,Y)}0.

:- inferrel(K,L,e), {occupy(K,X,Y): right(L,X), vbox(L,Y)}0.

:- inferrel(K,L,w), {occupy(K,X,Y): left(L,X), vbox(L,Y)}0.

:- inferrel(K,L,nw), {occupy(K,X,Y): left(L,X), top(L,Y)}0.

:- inferrel(K,L,sw), {occupy(K,X,Y): left(L,X), bottom(L,Y)}0.

:- inferrel(K,L,ne), {occupy(K,X,Y): right(L,X), top(L,Y)}0.

:- inferrel(K,L,se), {occupy(K,X,Y): right(L,X), bottom(L,Y)}0.

:- inferrel(K,L,o), {occupy(K,X,Y): hbox(L,X), vbox(L,Y)}0.




%  Check condition (C2) for basic and inferred CDC constraints

:- not inferrel(K,L,n), not relation(K,L,n), 1{occupy(K,X,Y): hbox(L,X), top(L,Y)}, region(K), region(L).

:- not inferrel(K,L,s), not relation(K,L,s), 1{occupy(K,X,Y): hbox(L,X), bottom(L,Y)}, region(K), region(L).

:- not inferrel(K,L,e), not relation(K,L,e), 1{occupy(K,X,Y): right(L,X), vbox(L,Y)}, region(K), region(L).

:- not inferrel(K,L,w), not relation(K,L,w), 1{occupy(K,X,Y): left(L,X), vbox(L,Y)}, region(K), region(L).

:- not inferrel(K,L,nw), not relation(K,L,nw), 1{occupy(K,X,Y): left(L,X), top(L,Y)}, region(K), region(L).

:- not inferrel(K,L,sw), not relation(K,L,sw), 1{occupy(K,X,Y): left(L,X), bottom(L,Y)}, region(K), region(L).

:- not inferrel(K,L,ne), not relation(K,L,ne), 1{occupy(K,X,Y): right(L,X), top(L,Y)}, region(K), region(L).

:- not inferrel(K,L,se), not relation(K,L,se), 1{occupy(K,X,Y): right(L,X), bottom(L,Y)}, region(K), region(L).

:- not inferrel(K,L,o), not relation(K,L,o), 1{occupy(K,X,Y): hbox(L,X), vbox(L,Y)}, region(K), region(L).




#show inferrel/3.
#show occupy/3.

