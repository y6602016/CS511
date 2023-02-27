import java.lang.System

class Semaphore {
  int permits
  long startWaitingTime = 0
  static final long startTime = System.currentTimeMillis()
  int waiting

  Semaphore(int init) {
    permits = init
  }

  synchronized protected static final long age(){
    return System.currentTimeMillis() - startTime
  }

  public synchronized void acquire() {
    if (waiting > 0 || permits == 0){
      long arrivalTime = age()
      while (arrivalTime > startWaitingTime || permits == 0){
        waiting++
        wait()
        waiting--
      }
    }
    permits--
  }

  public synchronized void release(){
    permits++
    startWaitingTime =  age() // update startWaitingTime
    notify() // use notify is better here, it wakes only one, which is acquire. 
    // But it's not fair, since the new permit may be stolen by an outside incoming thread
  }
}


Semaphore mutex = new Semaphore(1)

int c = 0
P = Thread.start{
  30.times{
    mutex.acquire()
    c++
    mutex.release()
  }
}

Q = Thread.start{
  30.times{
    mutex.acquire()
    c++
    mutex.release()
  }
}

P.join()
Q.join()
println(c)