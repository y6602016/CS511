class Semaphore {
  int permits
  Semaphore(int init) {
    permits = init
  }

  public synchronized void acquire() {
    while (permits == 0){
      wait()
    }
    permits--
  }

  public synchronized void release(){
    permits++
    notify() // use notify is better here, it wakes only one, which is acquire. 
    // But it's not fair, since the new permit may be stolen by an outside incoming thread
  }
}


Semaphore mutex = new Semaphore(1)

int c = 0
P = Thread.start{
  10.times{
    mutex.acquire()
    c++
    mutex.release()
  }
}

Q = Thread.start{
  10.times{
    mutex.acquire()
    c++
    mutex.release()
  }
}

P.join()
Q.join()
println(c)