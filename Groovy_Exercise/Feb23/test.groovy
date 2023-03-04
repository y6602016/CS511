import java.util.concurrent.locks.*

class TrainStation {
  Lock lock = new ReentrantLock()
  Condition okN = lock.newCondition()
  Condition okS = lock.newCondition()
  Condition okF = lock.newCondition()
  boolean n = flase, s = false

  void acquireNorthTrackP() {
    lock.lock()
    try{
      while(n){
        okN.await()
      }
      n = true
    }finally{
      lock.unlock()
    }
  }

  void releaseNorthTrackP() {
    lock.lock()
    try{
      n = false
      okN.signal()
      if(!south){
        okF.signal()
      }
    }finally{
      lock.unlock()
    }
  }

  void acquireSouthTrackP() {
    lock.lock()
    try{
      while(s){
        okS.await()
      }
      s = true
    }finally{
      lock.unlock()
    }
  }

  void releaseSouthTrackP() {
    lock.lock()
    try{
      s = false
      okS.signal()
      if(!north){
        okF.signal()
      }
    }finally{
      lock.unlock()
    }
  }

  void acquireTracksF() {
    lock.lock()
    try{ 
      while(s || n){
        okF.await()
      }
      s = true
      n = true
    }finally{
      lock.unlock()
    }
  }

  void releaseTracksF() {
    lock.lock()
    try{
      n = false
      s = false
      okN.signal()
      okS.signal()
      okF.signal()
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