import java.util.concurrent.Semaphore
Semaphore okToG = new Semaphore(2);
Semaphore okToC = new Semaphore(0);


Thread.start { // P
  while(true) {
    okToC.acquire();
    okToC.acquire();
    print("A");
    print("B");
    print("C");
    print("D");
    okToG.release();
    okToG.release();
  }
}

Thread.start { // Q
  while(true) {
    okToG.acquire();
    print("E");
    print("F");
    print("G");
    okToC.release();
  }
}

Thread.start { // R
  while(true) {
    print("H");
    print("I");
  }
}