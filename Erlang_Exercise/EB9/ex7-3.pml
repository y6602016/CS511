byte np = 0;
byte nq = 0;
byte c = 0;

// error due to the byte size reached by unbounded ticket
active proctype P() {
  do
    :: np = 1;
      np = nq + 1;
      do
        :: (nq == 0 || np <= nq) -> break;
        :: else
      od
      c++;
      assert(c == 1);
      c--;
      np = 0;
  od
}

active proctype Q() {
  do
    :: nq = 1; 
      nq = np + 1;
      do
        :: (np == 0 || nq < np) -> break;
        :: else
      od
      c++;
      assert(c == 1);
      c--;
      nq = 0;
  od
}