int : n ;
array[1..n] of var 0..3 : x ;
constraint x[1] = 0 ;
constraint x[n] = 3 ;
constraint forall(i,j in 1..n where i+1=j)(x[i]+x[j]<=3) ;
constraint forall(i in 1..n where i mod 3 = 0)(x[i]>=2) ;
solve maximize sum(x) ;
output ["\(sum(x)) = "++show(x)] ;