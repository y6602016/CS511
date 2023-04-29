byte mice = 0;
byte felines = 0;
byte mutexMice = 1;
byte mutexFelines = 1;
byte mutex = 1;
byte lots = 2;
byte animalInLots = 0;

inline acquire(s) {
  atomic{
    s > 0 -> s--;
  }
}

inline release(s) {
  s++;
}

active [3] proctype Mouse() {
  acquire(mutex);
  acquire(mutexMice);
  mice++;
  if 
    :: mice == 1 -> acquire(mutexFelines);
    :: else -> skip
  fi
  release(mutexMice);
  release(mutex);

  // CS
  acquire(lots);
  animalInLots++;
  assert(animalInLots < 3)
  animalInLots--;
  release(lots);

  acquire(mutexMice);
  mice--;
  if 
    :: mice == 0 -> release(mutexFelines);
    :: else -> skip
  fi
  release(mutexMice);
}

active [3] proctype Feline() {
  acquire(mutex);
  acquire(mutexFelines);
  felines++;
  if 
    :: felines == 1 -> acquire(mutexMice);
    :: else -> skip
  fi
  release(mutexFelines);
  release(mutex);

  // CS
  acquire(lots);
  animalInLots++;
  assert(animalInLots < 3)
  animalInLots--;
  release(lots);


  acquire(mutexFelines);
  felines--;
  if 
    :: felines == 0 -> release(mutexMice);
    :: else -> skip
  fi
  release(mutexFelines);
}