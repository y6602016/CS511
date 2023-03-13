import java.util.concurrent.locks.*

class Pizza {
  // Variables declared here
  int s = 0, l = 0
  final int N = 5
  Lock lock = new ReentrantLock()
  Condition okL = lock.newCondition()
  Condition okS = lock.newCondition()
  Condition okB = lock.newCondition()

  void purchaseSmallPizza() {
    lock.lock()
    try{
      while(s < 1){
        okS.await()
      }
      s--
      okB.signal()
    }finally{
      lock.unlock()
    }
  }

  void purchaseLargePizza() {
    lock.lock()
    try{
      while(l < 1 && s < 2){
        okL.await()
      }
      if(l >= 1){
        l--
        okB.signal()
      }
      else{
        s -= 2
        okB.signal()
        okB.signal()
      }
    }finally{
      lock.unlock()
    }
  }

  void bakeSmallPizza() {
    lock.lock()
    try{
      while(l + s >= N){
        okB.await()
      }
      s++
      okS.signal()
      okL.signal()
    }finally{
      lock.unlock()
    }
  }

  void bakeLargePizza() {
    lock.lock()
    try{
      while(l + s >= N){
        okB.await()
      }
      l++
      okL.signal()
    }finally{
      lock.unlock()
    }
  }
}

Pizza p = new Pizza()



5.times{
  Thread.start{
    p.purchaseSmallPizza()
  }
}

100.times{
  Thread.start{
    p.bakeSmallPizza()
  }
}

10.times{
  Thread.start{
    p.purchaseLargePizza()
  }
}

5.times{
  Thread.start{
    p.bakeLargePizza()
  }
}