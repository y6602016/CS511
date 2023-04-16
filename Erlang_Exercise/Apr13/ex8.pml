byte s = 1;
byte c = 0;


inline acquire(s){
  // not atomic would cause problem
  s > 0 -> s--
}

inline release(s){
  s++
}

proctype P(){
  acquire(s);
  c++;
}

proctype Q(){
  acquire(s);
  c++;
}

init{
  atomic{
    run P();
    run Q();
  }
  _nr_pr == 1;
  printf("C is %d", c);
}