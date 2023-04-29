byte turn = 1;

active proctype P(){
  do
    ::do
      ::turn == 1 -> break;
      :: else
      od;
process1:
    turn = 2;
  od;
}

active proctype Q(){
  do
    ::do
      ::turn == 2 -> break;
      :: else
      od;
    turn = 1;

    // an inifnite loop at noncritical section, P process suffers starvation
    do 
      :: else
    od;
  od;
}