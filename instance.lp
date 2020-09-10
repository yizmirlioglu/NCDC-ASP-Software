 
alltiles(sw).  alltiles(s).  alltiles(se).  alltiles(w).  alltiles(o).  alltiles(e).  alltiles(nw).  alltiles(n).  alltiles(ne). 
  
region(1..8). 
 
relation(1,2,w).  relation(1,2,nw).  relation(1,2,n).  relation(1,2,ne).  
relation(2,1,s).  relation(2,1,o).  
relation(2,3,sw).  relation(2,3,w).  
relation(2,4,n).  
relation(3,2,e).  relation(3,2,ne).  
relation(3,5,w).  relation(3,5,nw).  
relation(4,6,se).  
disjrelation(5,3,1,se).  disjrelation(5,3,1,e).  
disjrelation(5,3,2,sw).  disjrelation(5,3,2,se).  
disjrelation(5,3,3,n).  
disjrelation(5,3,4,w).  disjrelation(5,3,4,nw).  
relation(5,6,se).  
relation(6,4,nw).  
disjrelation(7,1,1,n).  disjrelation(7,1,1,ne).  
disjrelation(7,1,2,n).  
relation(7,3,nw).  relation(7,3,ne).  
relation(8,7,se).  relation(8,7,n).  relation(8,7,ne).  
