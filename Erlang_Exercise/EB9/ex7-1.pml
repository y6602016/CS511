byte np = 0;
byte nq = 0;

active proctype P() {
  do
    :: np = nq + 1;
      do
        :: (nq == 0 || np <= nq) -> break;
        :: else
      od
      np = 0;
  od
}

active proctype Q() {
  do
    :: nq = np + 1;
      do
        :: (np == 0 || nq < np) -> break;
        :: else
      od
      nq = 0;
  od
}