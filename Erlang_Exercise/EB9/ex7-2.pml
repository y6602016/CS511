byte np = 0;
byte nq = 0;
byte c = 0;
active proctype P() {
  byte temp = 0;
  do
    :: temp = nq + 1;
      np = temp;
      do
        :: (nq == 0 || np <= nq) -> break;
        :: else
      od
      c++;
      assert(c == 1);
      c--
      np = 0;
  od
}

active proctype Q() {
  byte temp = 0;
  do
    :: temp = np + 1;
      nq = temp;
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