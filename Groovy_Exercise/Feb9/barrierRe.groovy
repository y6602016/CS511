import java.util.concurrent.Semaphore
// Reuse (cyclic) barrier

final int N = 5
Semaphore barrier = new Semaphore(0)
Semaphore barrier2 = new Semaphore(0)
Semaphore mutex = new Semaphore(1)
int c = 0
int[] f = new int[N]

N.times {
  int id = it
  Thread.start {
    while (true) {
      mutex.acquire()
      c++
      f[id]++;
      if(c == N) { // only the thread reaching to c == N can pass the barrier
        N.times{
          barrier.release()
        }
        // c = 0 // Wrong! attempt to reset the counter makes the barrier reusable -> infinite
      }
      mutex.release()

      // barrier
      println(id + " reached barrier, c=" + f[id])
      barrier.acquire()
      println(id + " passed barrier, c=" + f[id])

      // use a second barrier here to stop threads entering the next circle until all finish
      // if a thread takes all permits, it will be blocked here so that everyone can have permit
      mutex.acquire() 
      c-- 
      if(c == 0){ // reaching here means everyone gets permit and left from the first barrier
        N.times{
          barrier2.release()
        }
      }
      mutex.release()
      barrier2.acquire()
    }
  }
}