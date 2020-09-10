

% Improved ASP subprogram for checking connectedness
% Check connectedness  by connected closure  (recursively)


% Find the left-bottom cell of each target region

leftborder(K,Y) :- occupy(K,X1,Y), infx(K,X1), target(K).

leftbottom(K,Y1) :- leftborder(K,Y1), infy(K,Y1), target(K).

notleftbottom(K,Y1) :- not leftborder(K,Y1), infy(K,Y1), target(K).

leftbottom(K,Y+1) :- leftborder(K,Y+1), notleftbottom(K,Y), target(K).

notleftbottom(K,Y+1) :- Y<Y1, not leftborder(K,Y+1), notleftbottom(K,Y), supy(K,Y1), target(K).

stem(K,X1,Y1) :- leftbottom(K,Y1), infx(K,X1).



% Designate the stem cell for each target region and add neighbor cells to its connected closure

reachable(K,X,Y) :- stem(K,X,Y).
reachable(K,X-1,Y) :- reachable(K,X,Y), occupy(K,X-1,Y).
reachable(K,X+1,Y) :- reachable(K,X,Y), occupy(K,X+1,Y).
reachable(K,X,Y-1) :- reachable(K,X,Y), occupy(K,X,Y-1).
reachable(K,X,Y+1) :- reachable(K,X,Y), occupy(K,X,Y+1).



% if there is a cell which is not in connected closure of that region, then it is disconnected

:- occupy(K,X,Y), not reachable(K,X,Y), target(K).



