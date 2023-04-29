byte mice = 0;
byte felines = 0;
byte mutexMice = 1;
byte mutexFelines = 1;
byte mutex = 1;
byte resource = 1;

inline acquire(s) {
  atomic{
    s > 0 -> s--;
  }
}

inline release(s) {
  s++;
}

active [3] proctype Mouse() {
  acquire(mutexMice);
  if 
    :: mice == 0 -> acquire(resource);
    :: else -> skip
  fi
  mice++;
  release(mutexMice);

  // CS
  assert(felines == 0)

  acquire(mutexMice);
  mice--;
  if 
    :: mice == 0 -> release(resource);
    :: else -> skip
  fi
  release(mutexMice);
}

active [3] proctype Feline() {
  acquire(mutex);
  acquire(mutexFelines);
  if 
    :: felines == 0 -> acquire(resource);
    :: else -> skip
  fi
  felines++;
  release(mutexFelines);
  release(mutex);

  // CS
  assert(mice == 0)

  acquire(mutexFelines);
  felines--;
  if 
    :: felines == 0 -> release(resource);
    :: else -> skip
  fi
  release(mutexFelines);
}