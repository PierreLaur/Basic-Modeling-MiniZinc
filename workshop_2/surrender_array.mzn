% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

array[1..u] of var NEGOTIATOR: party ;
constraint forall(i in 1..u-1)
                        (party[i] + (party[i]!=dummy) <= party[i+1]);

var int : obj ;
constraint obj = min(i in party)(honor[i]);

var int : strength = sum(i,j in party)(joint[i,j]);
constraint strength >= m;

var int : n_negotiators ;
constraint n_negotiators = sum(i in party)(i!=dummy);
constraint  n_negotiators <= m;
constraint  n_negotiators >= l;

solve maximize obj;