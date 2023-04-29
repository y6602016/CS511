byte turn = 1;

active proctype P() {
  do
    ::do
      :: turn == 1 -> break;
      :: else
      od
      turn = 2;
  od;
}

active proctype Q() {
  do
    ::do
      :: turn == 2 -> break;
      :: else
      od
      turn = 1;
  od;
}