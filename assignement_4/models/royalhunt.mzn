int: n; % number of court members
set of int: COURT = 1..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
array[HORSE] of int: beauty;
array[HORSE] of int: speed;

array[COURT,HORSE] of int: enjoy;


array[COURT] of var 0..m : horse;
array[HORSE] of var 0..n : court;
constraint forall(c in COURT, h in HORSE)(horse[c]=h <-> court[h]=c);

include "alldifferent_except_0.mzn";
constraint alldifferent_except_0(court);
constraint alldifferent_except_0(horse);

var int : emperor_enjoyment = enjoy[emperor, horse[emperor]]; 
constraint forall(c in COURT diff {emperor} where horse[c]>0)
        (enjoy[c,horse[c]]<emperor_enjoyment /\ enjoy[c,horse[c]]>=0); % the emperor is most entertained
constraint count(c in COURT)(horse[c]>0) = min(n,m) ;
constraint forall(c1,c2 in COURT where rank[c1]>rank[c2])
            (
                (beauty[horse[c1]]>=beauty[horse[c2]]) \/
                (horse[c2]=0)
            );

array[int] of var bool : speed_constraint_satisfied = [
    (speed[h1]<=speed[h2]) \/
    (ability[court[h1]] >= ability[court[h2]]) \/
    (court[h1]=0)
 |  h1, h2 in HORSE where h1!=h2];

var int : objective ;
constraint objective = sum(c in COURT)(if horse[c]>0 then enjoy[c,horse[c]] else 0 endif)
                    - sum(s in speed_constraint_satisfied)(not s)*100;

solve maximize objective ;