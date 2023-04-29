byte N = 3;
byte C = 7;
byte a = 0;
byte b = 0;
byte c = 0;

byte permToProcess[N];
byte doneProcessing[N];
byte station0 = 1;
byte station1 = 1;
byte station2 = 1;

inline acquire(s) {
  atomic{
    s > 0 -> s--;
  }
}

inline release(s) {
  s++;
}

proctype Car() {
  acquire(station0);
  release(permToProcess[0])
  acquire(doneProcessing[0])

  acquire(station1);
  release(station0);
  release(permToProcess[1])
  acquire(doneProcessing[1])

  acquire(station2);
  release(station1);
  release(permToProcess[2])
  acquire(doneProcessing[2])
  release(station2);
}

proctype Machine(int i){
  do::
  acquire(permToProcess[i])
  release(doneProcessing[i])
  od
}