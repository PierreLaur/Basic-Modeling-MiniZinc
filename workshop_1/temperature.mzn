array[int] of int : readings;
int : start;
int : n_hours = length(readings);
array[0..n_hours] of var int : inside_temps;
constraint inside_temps[0]=start;

enum options = {heat, strongly_heat, cool, strongly_cool, do_nothing};
array[1..n_hours] of var options : choices;
array[options] of int : costs = [1,5,3,9,0];
array[options] of int : effects = [1,4,-2,-5,0];
constraint forall(i in 1..n_hours)
        (inside_temps[i]=(inside_temps[i-1]+readings[i]) div 2
        + effects[choices[i]]);
constraint forall(i in 1..n_hours)(25<=inside_temps[i]);
constraint forall(i in 1..n_hours)(inside_temps[i]<=30);

var int : obj = sum([costs[i] | i in choices]); 
solve minimize obj;
output[show(inside_temps)++"\n"++show(choices)++"\n"++show(obj)]