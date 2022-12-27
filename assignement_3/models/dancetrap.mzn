% Beauty Trap
% Perform the most seductive dance

enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

int: maxlen;
set of int: STEP = 1..maxlen;
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;
constraint assert(maxlegs[stand] >= maxlen, "maxlegs[stand] smaller than maxlen");
constraint assert(maxarms[neutral] >= maxlen, "maxarms[neutral] smaller than maxlen");
constraint assert(maxface[blank] >= maxlen, "maxface[blank] smaller than maxlen");

array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;
constraint assert(dance_value[stand,neutral] = 0, "incorrect dance_value array");
constraint assert(entice_value[neutral,blank] = 0, "incorrect entice_value array");
int: boredom; % how bored each step make the viewer

var STEP: len;

constraint len<=sum(m in LEGS diff {stand})(maxlegs[m]);
constraint len<=sum(m in ARMS diff {neutral})(maxarms[m]);
constraint len<=sum(m in FACE diff {blank})(maxface[m]);

array[STEP] of var LEGS: legs;
array[STEP] of var ARMS: arms;
array[STEP] of var FACE: face;

constraint length(legs)=maxlen;
constraint length(arms)=maxlen;
constraint length(face)=maxlen;

include "global_cardinality_low_up.mzn";
constraint global_cardinality_low_up(legs, LEGS, [0|i in LEGS], maxlegs);
constraint global_cardinality_low_up(arms, ARMS, [0|i in ARMS], maxarms);
constraint global_cardinality_low_up(face, FACE, [0|i in FACE], maxface);

include "regular.mzn";
array[1..9, LEGS] of 0..9 : legs_automaton =
    [| 0,0,0,4,5,6
     | 1,0,3,0,0,6
     | 1,0,7,4,5,6
     | 1,0,3,4,0,6
     | 1,2,3,4,5,6
     | 1,0,3,4,5,6

     | 1,0,8,4,5,6 % second waltz in a row
     | 1,0,0,4,5,6 % third waltz in a row

     | 1,0,3,4,5,6 |]; % start state
constraint regular(legs, 9, 6, legs_automaton, 9, {6});

constraint forall(l1 in 1..len-1 where legs[l1]=waltz)
                (forall(l2 in l1+1..len where legs[l2]=curtsey)(exists(l3 in l1+1..l2-1)(legs[l3]=stand)));


array[1..6, ARMS] of 0..6 : arms_automaton =
    [| 0,2,3,4,5
     | 1,0,3,0,5
     | 1,2,0,0,5
     | 0,2,3,0,5
     | 0,2,3,4,5

     | 0,2,3,4,5 |];
constraint regular(arms, 6, 5, arms_automaton, 6, {neutral});


array[1..12, FACE] of 0..12 : face_automaton =
    [| 6,2,3,0,5,11
     | 1,7,3,4,5,11
     | 1,2,8,0,5,11
     | 1,2,3,9,5,11
     | 1,2,3,4,10,11

     | 0,2,3,0,5,11  % second time a gesture is made in a row
     | 1,0,3,4,5,11
     | 1,2,0,0,5,11
     | 1,2,3,0,5,11
     | 1,2,3,4,0,11
     
     | 1,2,3,4,5,11 % neutral

     | 1,2,3,4,5,11 |]; % starting state
constraint regular(face, 12, 6, face_automaton, 12, {11});


constraint forall(s in STEP where s>len)(legs[s]=stand /\ arms[s]=neutral /\ face[s]=blank);
constraint forall(s in STEP)(dance_value[legs[s], arms[s]] >=0 /\ entice_value[arms[s], face[s]]>=0);

var int : objective;
constraint objective = sum(s in STEP)(dance_value[legs[s], arms[s]] + entice_value[arms[s], face[s]])
                        - boredom * len ;
solve maximize objective;