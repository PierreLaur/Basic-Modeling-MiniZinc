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
array[1..card(LEGS)+3, LEGS] of 0..card(LEGS)+3 : legs_automaton =
    [| 0,0,0,4,5,6
     | 1,0,3,0,0,6
     | 1,0,7,4,5,6
     | 1,0,3,4,0,6
     | 1,2,3,4,5,6
     | 1,0,3,4,5,6

     | 1,0,8,4,5,6 % second waltz in a row
     | 1,0,0,4,5,6 % third waltz in a row

     | 1,0,3,4,5,6 |]; % start state
constraint regular(legs, card(LEGS)+3, card(LEGS), legs_automaton, card(LEGS)+3, {6});

constraint forall(l1 in 1..len-1 where legs[l1]=waltz)
                (forall(l2 in l1+1..len where legs[l2]=curtsey)(exists(l3 in l1+1..l2-1)(legs[l3]=stand)));


array[1..card(ARMS)+1, ARMS] of 0..card(ARMS)+1 : arms_automaton =
    [| 0,2,3,4,5
     | 1,0,3,0,5
     | 1,2,0,0,5
     | 0,2,3,0,5
     | 0,2,3,4,5

     | 0,2,3,4,5 |];
constraint regular(arms, card(ARMS)+1, card(ARMS), arms_automaton, card(ARMS), {neutral});


array[1..2*card(FACE)+1, FACE] of 0..2*card(FACE)+1 : face_automaton =
    [| 7,2,3,0,5,6
     | 1,8,3,4,5,6
     | 1,2,9,0,5,6
     | 1,2,3,10,5,6
     | 1,2,3,4,11,6
     | 1,2,3,4,5,12

     | 0,2,3,0,5,6  % second time a gesture is made in a row
     | 1,0,3,4,5,6
     | 1,2,0,0,5,6
     | 1,2,3,0,5,6
     | 1,2,3,4,0,6
     | 1,2,3,4,5,6

     | 1,2,3,4,5,6 |];
constraint regular(face, 2*card(FACE)+1, card(FACE), face_automaton, 2*card(FACE)+1, {6, 12});

constraint forall(s in STEP where s>len)(legs[s]=stand /\ arms[s]=neutral /\ face[s]=blank);

constraint forall(s in STEP)(dance_value[legs[s], arms[s]] >=0 /\ entice_value[arms[s], face[s]]>=0);

var int : objective;
constraint objective = sum(s in STEP)(dance_value[legs[s], arms[s]] + entice_value[arms[s], face[s]])
                        - boredom * len ;
solve maximize objective;