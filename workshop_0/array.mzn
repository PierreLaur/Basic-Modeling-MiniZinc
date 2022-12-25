int : n ;
set of int : ZEROTONINE = 0..9 ;
set of int : N_RANGE = 1..n ;
array[N_RANGE] of var ZEROTONINE : x ;
constraint sum(x)=product(x) ;
constraint forall(i,j in N_RANGE where i<j)(x[i]<=x[j]);
solve satisfy;
output [show(x[i]) | i in N_RANGE];