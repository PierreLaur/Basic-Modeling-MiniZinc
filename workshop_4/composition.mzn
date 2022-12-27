int : n;

% in what place in the sequence do I put each note ?
% to what note do I assign each place in the sequence ?
set of int : SEQUENCE = 1..n ;
set of int : NOTES = 1..n ;

array[SEQUENCE] of var NOTES : note ;

array[1..n-1] of var int : differences = [abs(note[i]-note[i+1])| i in 1..n-1];
include "alldifferent.mzn";
constraint alldifferent(differences);
constraint alldifferent(note);

constraint note[1] < note[n]; % breaking symmetry

solve satisfy;

output [show(note) ++ "\n  " ++ show(differences)];