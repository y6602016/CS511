byte c = 0;

proctype P() {
  byte i;
  byte temp;
  do
    :: i > 9 -> break
    :: else -> 
      i++; 
      temp = c; 
      c = temp + 1
  od;
}

init{
  atomic{
    run P();
    run P();
  }
  // _nr_pr == 1 -> printf("c = %d\n", c)
  _nr_pr == 1;
  printf("c = %d\n", c)
  assert(c > 2)
}