import java.util.concurrent.locks.*

class TrainStation {
  Lock lock = new ReentrantLock()
  boolean north = false
  boolean south = false
  Condition okNorth = lock.newCondition()
  Condition okSouth = lock.newCondition()
  Condition okF = lock.newCondition()

  void acquireNorthTrackP() {
    lock.lock()
    try{
      while (north){
        okNorth.await()
      }
      north = true
    }finally{
      lock.unlock()
    }
  }

  void releaseNorthTrackP() {
    lock.lock()
    try{
      north = false
      okNorth.signal()
      if (!south){ // if south is empty, freight can acquire
        okF.signal()
      }
    }finally{
      lock.unlock()
    }
  }

  void acquireSouthTrackP() {
    lock.lock()
    try{
      while (south){
        okSouth.await()
      }
      south = true
    }finally{
      lock.unlock()
    }
  }

  void releaseSouthTrackP() {
    lock.lock()
    try{
      south = false
      okSouth.signal()
      if (!north){ // if north is empty, freight can acquire
        okF.signal()
      }
    }finally{
      lock.unlock()
    }
  }

  void acquireTracksF() {
    lock.lock()
    try{
      while (north || south){ // either one of directions is not empty, wait
        okF.await()
      }
      north = true
      south = true
    }finally{
      lock.unlock()
    }
  }

  void releaseTracksF() {
    lock.lock()
    try{
      north = false
      south = false
      okNorth.signal()
      okSouth.signal()
      okF.signal() // not only signal north and south, also signal next freight
    }finally{
      lock.unlock()
    }
  } 
}

TrainStation s = new TrainStation();

200.times{
  Thread.start { // Passenger Train going North 
    s.acquireNorthTrackP();
    println "NPT" + Thread.currentThread().getId(); 
    s.releaseNorthTrackP();
  } 
}

200.times{
  Thread.start { // Passenger Train going South 
    s.acquireSouthTrackP();
    println "SPT"+ Thread.currentThread().getId(); 
    s.releaseSouthTrackP()
  } 
}


200.times {
  Thread.start { // Freight Train 
    s.acquireTracksF();
    println "FT "+ Thread.currentThread().getId(); 
    s.releaseTracksF();
  }
}