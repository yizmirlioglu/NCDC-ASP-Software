

% Subprogram for Disjunctive nCDC Constraints


disjind(K,L,I) :- disjrelation(K,L,I,J).
existdisj(K,L) :- disjrelation(K,L,I,J).

% Choose one basic relation from every disjunctive relation

1{chosen(K,L,I): disjind(K,L,I)}1 :- existdisj(K,L).

relation(K,L,J) :- disjrelation(K,L,I,J), chosen(K,L,I).


existrelation(K,L) :- disjrelation(K,L,I,J).

reference(L) :- disjrelation(K,L,I,J).
target(K) :- disjrelation(K,L,I,J).




#show chosen/3.



