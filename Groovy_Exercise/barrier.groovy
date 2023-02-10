// one-time use (non-cyclic) barrier
// car-wash
final int N = 5
Semaphore barrier = new Semaphore(0)
int c = 0

N.times {
  Thread.start {
    mutex.acquire()
    c++
    if(c == N) {
      N.times{
        barrier.release()
      }
    }
    mutex.release()

    barrier.acquire()
  }
}