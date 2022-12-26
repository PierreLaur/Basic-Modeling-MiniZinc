% assignment 2
% select a set of raiding warrior
enum WARRIOR;
WARRIOR: dummy;
enum CLAN; % the clan they belong too

int: l; % minimum raid party size
int: u; % maximum raid party size
int: m; % limit of hatreds

array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

array[CLAN,CLAN] of 0..1: hates;

array[1..u] of var WARRIOR: s;

set of WARRIOR: raid ::output_only = { fix(s[i]) | i in 1..u where fix(s[i])!=dummy};
var int : obj ;

constraint forall(i in 1..u-1)
                    (s[i]>=s[i+1] + (s[i]!=dummy));

constraint sum([w!=dummy | w in s]) <= u;
constraint sum([w!=dummy | w in s]) >= l;

constraint sum(i,j in 1..u where i<j)(hates[clan[s[i]],clan[s[j]]]) <= m;
constraint obj = sum(w in s)(strength[w]);

solve maximize obj ;