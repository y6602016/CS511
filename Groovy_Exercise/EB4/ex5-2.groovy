import java.util.concurrent.Semaphore
Semaphore okToE = new Semaphore(2);
Semaphore okToH = new Semaphore(0);


Thread.start { // P
  while(true) {
    print("A");
    print("B");
    print("C");
    print("D");
  }
}

Thread.start { // Q
  while(true) {
    okToE.acquire();
    print("E");
    print("F");
    print("G");
    okToH.release();
  }
}

Thread.start { // R
  while(true) {
    okToH.acquire();
    okToH.acquire();
    print("H");
    print("I");
    okToE.release();
    okToE.release();
  }
}