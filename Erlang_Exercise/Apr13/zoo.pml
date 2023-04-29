byte mice = 0;
byte felines = 0;
byte mutexMice = 1;
byte mutexFelines = 1;
byte mutex = 1;
byte feedinglot = 2;
byte c = 0;
byte area = 1;

inline acquire(s) {
  atomic{
    s > 0 -> s--;
  }
}

inline release(s) {
  s++;
}

active [5] proctype Mouse(){
  acquire(mutex);
  acquire(mutexMice);
  mice++;
  if
    :: mice == 1 -> acquire(mutexFelines);
    :: else -> skip;
  fi
  release(mutexMice);
  release(mutex);

  acquire(feedinglot);
  c++;
  assert(c < 3);
  c--;
  release(feedinglot);

  acquire(mutexMice);
  mice--;
  if 
    ::mice == 0 -> release(mutexFelines);
    ::else -> skip
  fi
  release(mutexMice)
}

active [5] proctype Feline(){
  acquire(mutex);
  acquire(mutexFelines);
  felines++;
  if
    :: felines == 1 -> acquire(mutexMice);
    :: else -> skip;
  fi
  release(mutexFelines);
  release(mutex);

  acquire(feedinglot);
  c++;
  assert(c < 3);
  c--;
  release(feedinglot);

  acquire(mutexFelines);
  felines--;
  if 
    ::felines == 0 -> release(mutexMice);
    ::else -> skip
  fi
  release(mutexFelines)
}