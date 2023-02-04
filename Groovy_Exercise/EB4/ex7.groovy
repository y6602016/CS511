import java.util.concurrent.Semaphore
Semaphore okToA = new Semaphore(1);
Semaphore okToB = new Semaphore(1); // 7-1
// Semaphore okToB = new Semaphore(0); // 7-2

Thread.start{ //P
  while(true) {
    okToA.acquire();
    print("A");
    okToB.release();
  }
}

Thread.start{ //Q
  while(true) {
    okToB.acquire();
    print("B");
    okToA.release();
  }
}

