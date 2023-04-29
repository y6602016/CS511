byte permit = 1;
byte c = 0;

inline acquire(s){
  atomic{
    s > 0 -> s--;
  }
}

inline release(s){
  s++;
}

proctype P(){
  acquire(permit);
  c++;
  assert(c == 1);
  c--;
  release(permit);
}

init{
  atomic{
    run P();
    run P();
    run P();
    run P();
    run P();
    run P();
  }
}