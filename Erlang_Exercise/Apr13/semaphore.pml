byte p = 0

inline acquire(p) {
  atomic{
    p > 0 -> p--
  }
}

inline release(p) {
  p++
}

proctype P() {
  acquire(p);
  printf("A");
  printf("B");
}

proctype Q() {
  printf("C");
  printf("D");
  release(p);
}

init{
  atomic{
    run P();
    run Q();
  }
}