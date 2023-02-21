import java.util.concurrent.Semaphore;


final int N = 8
Semaphore barrier = new Semaphore(0)
Semaphore barrier2 = new Semaphore(0)
Semaphore mutex = new Semaphore(1, true)
r = 0


N.times {
  Thread.start { // 
    while(true) {
      mutex.acquire()
      r++
      if (r == N){
        N.times{
          barrier.release()
        }
      }
      mutex.release()
      barrier.acquire()

      mutex.acquire()
      r--
      if (r == 0){
        N.times{
          barrier2.release()
        }
      }
      mutex.release()
      barrier2.acquire()
    }
  }
}

