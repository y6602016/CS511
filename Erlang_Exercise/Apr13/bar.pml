byte ticket = 0;
byte mutex = 1;
byte j = 0;
byte p = 0;

inline acquire(s){
  skip;
end1:
  atomic{
    s > 0 -> s--;
  }
}

inline release(s) {
  s++;
}

active [5] proctype Jets() {
  acquire(mutex);
  acquire(ticket);
  acquire(ticket);
  release(mutex);
  j++;
  assert(j * 2 <= p);
}

active [5] proctype Patriots() {
  // //solution 1
  // p++;
  // release(ticket);

  // solution 2
  atomic{
    release(ticket);
    p++;
  }
  assert(j * 2 <= p);
}