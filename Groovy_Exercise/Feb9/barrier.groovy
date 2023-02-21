import java.util.concurrent.Semaphore
// one-time use (non-cyclic) barrier

final int N = 5
Semaphore barrier = new Semaphore(0)
Semaphore mutex = new Semaphore(1)
int c = 0

// solution 1
N.times {
  int id = it
  Thread.start {
    while (true) {
      mutex.acquire()
      if (c < N){
        c++
        if(c == N) { // only the thread reaching to c == N can pass the barrier
          N.times{
            barrier.release()
        }
      }
      }
      else{
        barrier.release() // solution 1
      }
      mutex.release()
      barrier.acquire()
    }
  }
}


// solution 2: cascaded signalling
N.times {
  int id = it
  Thread.start {
    while (true) {
      mutex.acquire()
      c++
      if(c == N) { // only the thread reaching to c == N can pass the barrier
        barrier.release() // another solution: cascaded signalling
        println(id)
      }
      mutex.release()
      barrier.acquire()
      barrier.release() // this release will be like a chained-release to wake up all blocked one by one
    }
  }
}