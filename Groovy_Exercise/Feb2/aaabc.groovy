import java.util.concurrent.Semaphore
Semaphore okA = new Semaphore(3);
Semaphore okBorC = new Semaphore(0);
Semaphore mutex = new Semaphore(0);

// output aaa(b+c)aaa(b+c)aaa

Thread.start { // P
    while (true) {
      okA.acquire()
      print("a")
      okBorC.release()
    }
}

Thread.start { // Q
    while (true) {
      okBorC.acquire()
      okBorC.acquire()
      okBorC.acquire()
      print("b")
      mutex.release()
    }
}

// output aaa(b+c)aaa(b+c)aaa
Thread.start{ //R
  while (true) {
      mutex.acquire()
      print("c")
      okA.release()
      okA.release()
      okA.release()
  }
}