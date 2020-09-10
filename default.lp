

% Default nCDC Constraints

existdefrel(K,L) :- defaultrelation(K,L,J).

reference(L) :- defaultrelation(K,L,J).
target(K) :- defaultrelation(K,L,J).


% Default constraint applies if there is no evidence against it

drelation(K,L,J) :- not -drelation(K,L), defaultrelation(K,L,J).

-drelation(K,L) :- defaultrelation(K,L,J), not inferrel(K,L,J), existinferrel(K,L).
-drelation(K,L) :- not defaultrelation(K,L,J), inferrel(K,L,J), existdefrel(K,L).
-drelation(K,L) :- defaultrelation(K,L,J), not relation(K,L,J), existrelation(K,L).
-drelation(K,L) :- not defaultrelation(K,L,J), relation(K,L,J), existdefrel(K,L).

existdrelation(K,L) :- drelation(K,L,J).


% Minimize evidence against default

:~ -drelation(K,L), existdefrel(K,L), region(K), region(L). [1@1,K,L]


%  DISJUNCTIVE DEFAULT nCDC CONSTRAINTS

disjdefaultind(K,L,I) :- disjdefaultrelation(K,L,I,J).
existdisjdefrel(K,L) :- disjdefaultrelation(K,L,I,J).


% Choose one basic relation from every disjunctive default constraint
1{defchosen(K,L,I): disjdefaultind(K,L,I)}1 :- existdisjdefrel(K,L).

defaultrelation(K,L,J) :- disjdefaultrelation(K,L,I,J), defchosen(K,L,I).




#show drelation/3.
#show -drelation/2.
#show defchosen/3.

