import java.util.concurrent.Semaphore
Semaphore okToF = new Semaphore(0);
Semaphore okToC = new Semaphore(0);
Semaphore okToH = new Semaphore(0);


Thread.start { // P
  while(true) {
    print("A");
    okToF.release();
    print("B");
    okToC.acquire();
    print("C");
    print("D");
  }
}

Thread.start { // Q
  while(true) {
    print("E");
    okToH.releare();
    okToF.acquire();
    print("F");
    print("G");
    okToC.release();
  }
}

Thread.start { // R
  while(true) {
    okToH.acquire();
    print("H");
    print("I");
  }
}