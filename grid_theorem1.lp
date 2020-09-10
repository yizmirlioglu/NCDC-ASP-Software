

% Find Grid Size (Theorem 1)

numregion(N) :- N=#count{K:region(K)}.

hsize(2*N-1) :- numregion(N).
vsize(2*N-1) :- numregion(N).



#show hsize/1.
#show vsize/1.

