byte N = 3;
byte C = 5;
byte a = 0;
byte b = 0;
byte c = 0;

byte permToProcess[N];
byte doneProcessing[N];
byte station0 = 1;
byte station1 = 1;
byte station2 = 1;


inline acquire(s){
  skip;
end1:
  atomic{
    s > 0 -> s--;
  }
}

inline release(s){
  s++;
}

proctype Car(){
  acquire(station0);
  a++;
  printf("a: %d, %d at 0\n", a, _pid);
  release(permToProcess[0]);
  acquire(doneProcessing[0]);
  assert(a == 1);
  a--;

  acquire(station1);
  b++;
  printf("b: %d, %d at 1\n", b, _pid);
  release(station0);
  release(permToProcess[1]);
  acquire(doneProcessing[1]);
  assert(b == 1);
  b--;

  acquire(station2);
  c++;
  printf("c: %d, %d at 2\n", c, _pid);
  release(station1);
  release(permToProcess[2]);
  acquire(doneProcessing[2]);
  assert(c == 1);
  c--;
  release(station2);
}

proctype Machine(int i){
  do
    ::acquire(permToProcess[i]);
    release(doneProcessing[i]);
  od
}

init {
  byte i;
  for(i:0..(N - 1)){
    permToProcess[i] = 0;
    doneProcessing[i] = 0;
  }

  atomic{
    for(i:1..(C)){
      run Car();
    }
    for(i:0..(N-1)){
      run Machine(i);
    }
  }
}