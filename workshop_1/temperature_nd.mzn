array[int] of int : readings;
int : start;
int : n_hours = length(readings);
array[0..n_hours] of var int : inside_temps;
constraint inside_temps[0]=start;
constraint forall(i in 1..n_hours)
            (inside_temps[i]=(inside_temps[i-1] + readings[i]) div 2);
solve satisfy;