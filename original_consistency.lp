
% The original ASP program for checking consistency of basic CDC networks

xcoord(0..M-1) :- hsize(M).
ycoord(0..N-1) :- vsize(N).


% This program works for both complete and incomplete networks
% Below we find, directional relation is specified for which pair of regions

existrelation(K,L) :- relation(K,L,J).

reference(L) :- existrelation(K,L).
target(K) :- existrelation(K,L).



% Find bounds of regions in x and y dimensions (Minimum Bounding Rectangle)

infx(K,M) :- M=#min{X,Y: occupy(K,X,Y)}, region(K).
supx(K,M) :- M=#max{X,Y: occupy(K,X,Y)}, region(K).
infy(K,M) :- M=#min{Y,X: occupy(K,X,Y)}, region(K).
supy(K,M) :- M=#max{Y,X: occupy(K,X,Y)}, region(K).



% Generate cells for all regions

1{occupy(K,X,Y): xcoord(X), ycoord(Y)} :- region(K).



% Identify 9 tiles of an object

hbox(K,X1..X2) :- infx(K,X1), supx(K,X2).
right(K,X2+1..M-1) :- supx(K,X2), hsize(M).
left(K,0..X1-1) :- infx(K,X1).

vbox(K,Y1..Y2) :- infy(K,Y1), supy(K,Y2).
top(K,Y2+1..N-1) :- supy(K,Y2), vsize(N).
bottom(K,0..Y1-1) :- infy(K,Y1).



%  Check condition (C1) for generated regions

:- relation(K,L,n), {occupy(K,X,Y): hbox(L,X), top(L,Y)}0.

:- relation(K,L,s), {occupy(K,X,Y): hbox(L,X), bottom(L,Y)}0.

:- relation(K,L,e), {occupy(K,X,Y): right(L,X), vbox(L,Y)}0.

:- relation(K,L,w), {occupy(K,X,Y): left(L,X), vbox(L,Y)}0.

:- relation(K,L,nw), {occupy(K,X,Y): left(L,X), top(L,Y)}0.

:- relation(K,L,sw), {occupy(K,X,Y): left(L,X), bottom(L,Y)}0.

:- relation(K,L,ne), {occupy(K,X,Y): right(L,X), top(L,Y)}0.

:- relation(K,L,se), {occupy(K,X,Y): right(L,X), bottom(L,Y)}0.

:- relation(K,L,o), {occupy(K,X,Y): hbox(L,X), vbox(L,Y)}0.



%  Check condition (C2)

:- not relation(K,L,n), existrelation(K,L), 1{occupy(K,X,Y): hbox(L,X), top(L,Y)}.

:- not relation(K,L,s), existrelation(K,L), 1{occupy(K,X,Y): hbox(L,X), bottom(L,Y)}.

:- not relation(K,L,e), existrelation(K,L), 1{occupy(K,X,Y): right(L,X), vbox(L,Y)}.

:- not relation(K,L,w), existrelation(K,L), 1{occupy(K,X,Y): left(L,X), vbox(L,Y)}.

:- not relation(K,L,nw), existrelation(K,L), 1{occupy(K,X,Y): left(L,X), top(L,Y)}.

:- not relation(K,L,sw), existrelation(K,L), 1{occupy(K,X,Y): left(L,X), bottom(L,Y)}.

:- not relation(K,L,ne), existrelation(K,L), 1{occupy(K,X,Y): right(L,X), top(L,Y)}.

:- not relation(K,L,se), existrelation(K,L), 1{occupy(K,X,Y): right(L,X), bottom(L,Y)}.

:- not relation(K,L,o), existrelation(K,L), 1{occupy(K,X,Y): hbox(L,X), vbox(L,Y)}.




#show occupy/3.

