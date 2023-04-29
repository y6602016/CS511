byte ticket = 0;
byte mutex = 1;
byte J = 0;
byte P = 0;

inline acquire(s) {
  skip;
end1:
  atomic{
    s > 0 -> s--;
  }
}

inline release(s){
  s++;
}

active [6] proctype Jets() {
  acquire(mutex);
  acquire(ticket);
  acquire(ticket);
  J++;
  assert(J * 2 <= P);
  release(mutex);
}

active [6] proctype Patriots() {
  P++;
  assert(J * 2 <= P);
  release(ticket);
}