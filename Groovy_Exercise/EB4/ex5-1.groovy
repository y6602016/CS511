import java.util.concurrent.Semaphore
Semaphore okToA = new Semaphore(2);
Semaphore okToE = new Semaphore(0);


Thread.start { // P
  while(true) {
    okToA.acquire();
    print("A");
    print("B");
    print("C");
    print("D");
    okToE.release();
  }
}

Thread.start { // Q
  while(true) {
    okToE.acquire();
    okToE.acquire();
    print("E");
    print("F");
    print("G");
    okToA.release();
    okToA.release();
  }
}

Thread.start { // R
  while(true) {
    print("H");
    print("I");
  }
}