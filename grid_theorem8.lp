

% Find Grid Size (Theorem 8)

numregion(N) :- N=#count{K:region(K)}.

existanyrelation(K,L) :- relation(K,L,J).
existanyrelation(K,L) :- disjrelation(K,L,M,J).
existanyrelation(K,L) :- defaultrelation(K,L,J).
existanyrelation(K,L) :- disjdefaultrelation(K,L,I,J).

reference(L) :- existanyrelation(K,L).
target(K) :- existanyrelation(K,L).


% Find maximal partitions according to Theorem 8
% using disjoint set

pointer(K,K) :- region(K).
pointer(K,I) :- existanyrelation(K,L), pointer(L,I).
pointer(L,I) :- existanyrelation(K,L), pointer(K,I).
belong(K,I) :- I=#min{P,K: pointer(K,P)}, region(K).
partition(I) :- belong(K,I).

partition_hsize(I,M) :- M=#sum{P,K,I: slotx(K,P), belong(K,I)}, partition(I).
partition_vsize(I,N) :- N=#sum{P,K,I: sloty(K,P), belong(K,I)}, partition(I).


% The grid size the maximum one among subpartitions

hsize(M) :- M=#max{P,I: partition_hsize(I,P)}.
vsize(N) :- N=#max{P,I: partition_vsize(I,P)}.



% Basic CDC Constraints: Find required number of cells for every region

bottomrel(K,L) :- relation(K,L,sw).
bottomrel(K,L) :- relation(K,L,s).
bottomrel(K,L) :- relation(K,L,se).
vmidrel(K,L) :- relation(K,L,w).
vmidrel(K,L) :- relation(K,L,o).
vmidrel(K,L) :- relation(K,L,e).
toprel(K,L) :- relation(K,L,nw).
toprel(K,L) :- relation(K,L,n).
toprel(K,L) :- relation(K,L,ne).

leftrel(K,L) :- relation(K,L,sw).
leftrel(K,L) :- relation(K,L,w).
leftrel(K,L) :- relation(K,L,nw).
hmidrel(K,L) :- relation(K,L,s).
hmidrel(K,L) :- relation(K,L,o).
hmidrel(K,L) :- relation(K,L,n).
rightrel(K,L) :- relation(K,L,se).
rightrel(K,L) :- relation(K,L,e).
rightrel(K,L) :- relation(K,L,ne).


bottomcell(K) :- bottomrel(K,_).
topcell(K) :- toprel(K,_).

leftcell(K) :- leftrel(K,_).
rightcell(K) :- rightrel(K,_).



slotx(K,2) :- rightrel(K,L), leftrel(K,L).

hrightandmid(K,L) :- rightrel(K,L), hmidrel(K,L).
hleftandmid(L,K) :- leftrel(L,K), hmidrel(L,K).
slotx(K,2) :- hrightandmid(K,L), hleftandmid(L,K).

slotx(K,0) :- not leftcell(K), not rightcell(K), not reference(K), region(K).

slotx(K,1) :- not slotx(K,0), not slotx(K,2), region(K).


sloty(K,2) :- toprel(K,L), bottomrel(K,L).
vtopandmid(K,L) :- toprel(K,L), vmidrel(K,L).
vbottomandmid(L,K) :- bottomrel(L,K), vmidrel(L,K).
sloty(K,2) :- vtopandmid(K,L), vbottomandmid(L,K).

sloty(K,0) :- not topcell(K), not bottomcell(K), not reference(K), region(K).

sloty(K,1) :- not sloty(K,0), not sloty(K,2), region(K).


existslotx(K) :- slotx(K,P).
slotx(K,0) :- not existslotx(K), region(K).
existsloty(K) :- sloty(K,P).
sloty(K,0) :- not existsloty(K), region(K).




% Disjunctive nCDC Constraints

bottomrelx(K,L,M) :- disjrelation(K,L,M,sw).
bottomrelx(K,L,M) :- disjrelation(K,L,M,s).
bottomrelx(K,L,M) :- disjrelation(K,L,M,se).
vmidrelx(K,L,M) :- disjrelation(K,L,M,w).
vmidrelx(K,L,M) :- disjrelation(K,L,M,o).
vmidrelx(K,L,M) :- disjrelation(K,L,M,e).
toprelx(K,L,M) :- disjrelation(K,L,M,nw).
toprelx(K,L,M) :- disjrelation(K,L,M,n).
toprelx(K,L,M) :- disjrelation(K,L,M,ne).

leftrelx(K,L,M) :- disjrelation(K,L,M,sw).
leftrelx(K,L,M) :- disjrelation(K,L,M,w).
leftrelx(K,L,M) :- disjrelation(K,L,M,nw).
hmidrelx(K,L,M) :- disjrelation(K,L,M,s).
hmidrelx(K,L,M) :- disjrelation(K,L,M,o).
hmidrelx(K,L,M) :- disjrelation(K,L,M,n).
rightrelx(K,L,M) :- disjrelation(K,L,M,se).
rightrelx(K,L,M) :- disjrelation(K,L,M,e).
rightrelx(K,L,M) :- disjrelation(K,L,M,ne).


bottomcell(K) :- bottomrelx(K,L,M).
topcell(K) :- toprelx(K,L,M).
leftcell(K) :- leftrelx(K,L,M).
rightcell(K) :- rightrelx(K,L,M).


slotx(K,2) :- rightrelx(K,L,M), leftrelx(K,L,M).
sloty(K,2) :- toprelx(K,L,M), bottomrelx(K,L,M).

hrightandmid(K,L) :- rightrelx(K,L,M), hmidrelx(K,L,M).
hleftandmid(L,K) :- leftrelx(L,K,M), hmidrelx(L,K,M).

vtopandmid(K,L) :- toprelx(K,L,M), vmidrelx(K,L,M).
vbottomandmid(L,K) :- bottomrelx(L,K,M), vmidrelx(L,K,M).




% Default nCDC Constraints

dbottomrel(K,L) :- defaultrelation(K,L,sw).
dbottomrel(K,L) :- defaultrelation(K,L,s).
dbottomrel(K,L) :- defaultrelation(K,L,se).
dvmidrel(K,L) :- defaultrelation(K,L,w).
dvmidrel(K,L) :- defaultrelation(K,L,o).
dvmidrel(K,L) :- defaultrelation(K,L,e).
dtoprel(K,L) :- defaultrelation(K,L,nw).
dtoprel(K,L) :- defaultrelation(K,L,n).
dtoprel(K,L) :- defaultrelation(K,L,ne).

dleftrel(K,L) :- defaultrelation(K,L,sw).
dleftrel(K,L) :- defaultrelation(K,L,w).
dleftrel(K,L) :- defaultrelation(K,L,nw).
dhmidrel(K,L) :- defaultrelation(K,L,s).
dhmidrel(K,L) :- defaultrelation(K,L,o).
dhmidrel(K,L) :- defaultrelation(K,L,n).
drightrel(K,L) :- defaultrelation(K,L,se).
drightrel(K,L) :- defaultrelation(K,L,e).
drightrel(K,L) :- defaultrelation(K,L,ne).


bottomcell(K) :- dbottomrel(K,L).
topcell(K) :- dtoprel(K,L).
leftcell(K) :- dleftrel(K,L).
rightcell(K) :- drightrel(K,L).


slotx(K,2) :- drightrel(K,L), dleftrel(K,L).
sloty(K,2) :- dtoprel(K,L), dbottomrel(K,L).

hrightandmid(K,L) :- drightrel(K,L), dhmidrel(K,L).
hleftandmid(L,K) :- dleftrel(L,K), dhmidrel(L,K).

vtopandmid(K,L) :- dtoprel(K,L), dvmidrel(K,L).
vbottomandmid(L,K) :- dbottomrel(L,K), dvmidrel(L,K).





% Disjunctive Default nCDC Constraints

dbottomrelx(K,L,M) :- disjdefaultrelation(K,L,M,sw).
dbottomrelx(K,L,M) :- disjdefaultrelation(K,L,M,s).
dbottomrelx(K,L,M) :- disjdefaultrelation(K,L,M,se).
dvmidrelx(K,L,M) :- disjdefaultrelation(K,L,M,w).
dvmidrelx(K,L,M) :- disjdefaultrelation(K,L,M,o).
dvmidrelx(K,L,M) :- disjdefaultrelation(K,L,M,e).
dtoprelx(K,L,M) :- disjdefaultrelation(K,L,M,nw).
dtoprelx(K,L,M) :- disjdefaultrelation(K,L,M,n).
dtoprelx(K,L,M) :- disjdefaultrelation(K,L,M,ne).

dleftrelx(K,L,M) :- disjdefaultrelation(K,L,M,sw).
dleftrelx(K,L,M) :- disjdefaultrelation(K,L,M,w).
dleftrelx(K,L,M) :- disjdefaultrelation(K,L,M,nw).
dhmidrelx(K,L,M) :- disjdefaultrelation(K,L,M,s).
dhmidrelx(K,L,M) :- disjdefaultrelation(K,L,M,o).
dhmidrelx(K,L,M) :- disjdefaultrelation(K,L,M,n).
drightrelx(K,L,M) :- disjdefaultrelation(K,L,M,se).
drightrelx(K,L,M) :- disjdefaultrelation(K,L,M,e).
drightrelx(K,L,M) :- disjdefaultrelation(K,L,M,ne).

bottomcell(K) :- dbottomrelx(K,L,M).
topcell(K) :- dtoprelx(K,L,M).
leftcell(K) :- dleftrelx(K,L,M).
rightcell(K) :- drightrelx(K,L,M).

slotx(K,2) :- drightrelx(K,L,M), dleftrelx(K,L,M).
sloty(K,2) :- dtoprelx(K,L,M), dbottomrelx(K,L,M).

hrightandmid(K,L) :- drightrelx(K,L,M), dhmidrelx(K,L,M).
hleftandmid(L,K) :- dleftrelx(L,K,M), dhmidrelx(L,K,M).

vtopandmid(K,L) :- dtoprelx(K,L,M), dvmidrelx(K,L,M).
vbottomandmid(L,K) :- dbottomrelx(L,K,M), dvmidrelx(L,K,M).





#show hsize/1.
#show vsize/1.
#show partition/1.
#show belong/2.

