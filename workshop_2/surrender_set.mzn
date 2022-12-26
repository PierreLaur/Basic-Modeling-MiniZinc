% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

var set of NEGOTIATOR : party ;

var int : obj ;
constraint obj = min(i in party)(honor[i]);

var int : strength = sum(i,j in party where i<j)(joint[i,j]);
constraint strength >= m;

constraint card(party) >= l;
constraint card(party) <= u;

constraint forall(i in party)(i!=dummy);

solve maximize obj;
output ["party : \(party) \n"++
        "obj : \(obj) \n" ++
        "strength : \(strength)"];