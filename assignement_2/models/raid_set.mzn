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

var set of WARRIOR : raid ;
var int : obj ;

constraint forall(w in raid)(w!=dummy);

constraint card(raid)<=u;
constraint card(raid)>=l;
constraint sum(w1,w2 in raid where w1<w2)(hates[clan[w1],clan[w2]]) <= m;
constraint obj = sum(w in raid)(strength[w]);

solve maximize obj ;