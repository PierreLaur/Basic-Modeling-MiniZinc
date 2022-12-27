include "inverse.mzn";
int : n;

% in what place in the sequence do I put each note ?
% to what note do I assign each place in the sequence ?
set of int : SEQUENCE = 1..n ;
set of int : NOTES = 1..n ;

array[NOTES] of var SEQUENCE : order ;
array[SEQUENCE] of var NOTES : note ;
constraint inverse(order, note);
constraint abs(order[1] - order[n]) = 1 ;


array[1..n-1] of var 1..n-1 : differences = [abs(note[i]-note[i+1])| i in 1..n-1];
array[1..n-1] of var 1..n-1 : dposn ;
constraint inverse(dposn, differences);
constraint dposn[n-1] = min(order[1], order[n]);

constraint note[1] < note[n]; % breaking symmetry

solve satisfy;

output [show(note) ++ "\n  " ++ show(differences)];