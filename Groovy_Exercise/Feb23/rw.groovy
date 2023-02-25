import java.util.concurrent.locks.*
// priority for readers, unfair for writers
class RW{
  int readers = 0;
  int writers = 0
  final Lock lock = new ReentrantLock()
  final Condition okToRead = lock.newCondition()
  final Condition okToWrite = lock.newCondition()

  public void startRead(){
    lock.lock()
    try{
      while (writers > 0){
        okToRead.await()
      }
      readers = readers + 1
    }finally{
      lock.unlock()
    }
  }

  public void endRead(){
    lock.lock()
    try{
      readers = readers - 1
      if (readers == 0){
        okToWrite.signal()
      }
    }finally{
      lock.unlock()
    }
  }

  public void startWrite(){
    lock.lock()
    try{
      while (writers != 0 || readers != 0){
        okToWrite.await()
      }
      writers = writers + 1
    }finally{
      lock.unlock()
    }
  }

  public void endWrite(){
    lock.lock()
    try{
      writers = writers - 1
      okToRead.signalAll()
      okToWrite.signal()
    }finally{
      lock.unlock()
    }
  }
}

RW r = new RW()


100.times{
  int id = it
  Thread.start{
    r.startWrite()
    println(id + " starts writing")
    println(id + " ends writing")
    r.endWrite()
  }
}

100.times{
  int id = it
  Thread.start{
    r.startRead()
    println(id + " starts reading")
    println(id + " ends reading")
    r.endRead()
  }
}