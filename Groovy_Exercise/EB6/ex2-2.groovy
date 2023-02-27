import java.util.concurrent.locks.*

class TWS{
  private int state = 1
  Lock lock = new ReentrantLock()
  Condition okOne = lock.newCondition()
  Condition okTwo = lock.newCondition()
  Condition okThree = lock.newCondition()

  public void one(){
    lock.lock()
    try{
      while (state != 1){
        okOne.await()
      }
      println(state)
      state = 2
      okTwo.signal()
    }finally{
      lock.unlock()
    }
  }

  public void two(){
    lock.lock()
    try{
      while (state != 2){
        okTwo.await()
      }
      println(state)
      state = 3
      okThree.signal()
    }finally{
      lock.unlock()
    }
  }

  public void three(){
    lock.lock()
    try{
      while (state != 3){
        okThree.await()
      }
      println(state)
      state = 1
      okOne.signal()
    }finally{
      lock.unlock()
    }
  }
}

TWS t = new TWS()
100.times{
  Thread.start{
    switch(1 + (new Random()).nextInt(3)){
      case 1: t.one(); break
      case 2: t.two(); break
      default: t.three(); break
    }
  }
}