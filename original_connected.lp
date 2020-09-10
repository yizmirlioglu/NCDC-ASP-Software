
% The original ASP subprogram for checking connectedness


% Recursively define transitive closure of connectedness

connected(K,X,Y,X,Y) :- occupy(K,X,Y).

connected(K,X,Y,X,Y+1) :- occupy(K,X,Y), occupy(K,X,Y+1).
connected(K,X,Y,X,Y-1) :- occupy(K,X,Y), occupy(K,X,Y-1).
connected(K,X,Y,X+1,Y) :- occupy(K,X,Y), occupy(K,X+1,Y).
connected(K,X,Y,X-1,Y) :- occupy(K,X,Y), occupy(K,X-1,Y).


% Transitive closure

connected(K,X1,Y1,X3,Y3) :- connected(K,X1,Y1,X2,Y2), connected(K,X2,Y2,X3,Y3). 


% Any two cells of a region must be connected to each other

:- not connected(K,X1,Y1,X2,Y2), occupy(K,X1,Y1), occupy(K,X2,Y2), region(K).

