% Beauty Trap
% Create the most magnificient feast 
enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};

%int: ndish;
%set of int: DISH = 1..ndish;
%set of int: TASTE = 1..6;
%int: 2 = 1; int: 3 = 2; int: 4 = 3; int: 5 = 4; int: 6 = 5; int: 7 = 6;
%set of int: TEMP = 1..3;
%int: hot = 1; int: cold = 2; int: warm = 3;

array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;

array[COURSE] of var DISH: dish;

include "alldifferent.mzn";
constraint alldifferent(dish);

include "regular.mzn";

array[1..card(TASTE)+1,TASTE] of 0..7 : dishes_transitions = 
        [|0, 0, 4, 0, 0, 0
          |0, 0, 0, 5, 0, 7
          |0, 0, 0, 0, 6, 7
          |2, 3, 0, 5, 6, 7
          |0, 3, 4, 0, 0, 7
          |2, 3, 4, 5, 0, 7
          |2, 3, 4, 5, 6, 0|];

constraint regular([taste[d] | d in dish], card(TASTE)+1, card(TASTE), dishes_transitions, 1, {5});

array[1..card(TEMP)+1, TEMP] of 0..card(TEMP)+1 : temp_transitions =
        [| 2,3,4
         | 2,0,4
         | 2,3,4
         | 2,3,4 |];

constraint regular([temp[d] | d in dish], card(TEMP)+1, card(TEMP), temp_transitions, 1, {2,3,4});

constraint forall(i in 1..len-2)
            (heavy[dish[i]] /\ heavy[dish[i+1]] -> not heavy[dish[i+2]]);

var int : magnificience ;
constraint magnificience = sum(d in dish)(value[d])
                            + len - 1
                            + sum(i in 1..len-1)(temp[dish[i]]!=temp[dish[i+1]])
                            + sum(i in 1..len-1)(heavy[dish[i]]!=heavy[dish[i+1]]);

solve maximize magnificience;

