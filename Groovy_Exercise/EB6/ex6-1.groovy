import java.util.concurrent.locks.*

class Pizza {
  // Variables declared here
  int l = 0
  int s = 0
  Lock lock = new ReentrantLock()
  Condition okLarge = lock.newCondition()
  Condition okSmall = lock.newCondition()

  void purchaseSmallPizza() {
    lock.lock()
    try{
      while(s < 1){
        println("Waiting for a small pizza, l:" + l + ", s:" + s)
        okSmall.await()
      }
      s--
      println("Take a small pizza, l:" + l + ", s:" + s)
    }finally{
      lock.unlock()
    }
  }

  void purchaseLargePizza() {
    lock.lock()
    try{
      while(l < 1 && s < 2){
        println("Waiting for a large pizza, l:" + l + ", s:" + s)
        okLarge.await()
      }
      if(l >= 1){
        l--
        println("Take a large pizza, l:" + l + ", s:" + s)
      }
      else if(s >= 2){
        s = s - 2
        println("Take large pizza(two small), l:" + l + ", s:" + s)
      }
    }finally{
      lock.unlock()
    }
  }

  void bakeSmallPizza() {
    lock.lock()
    try{
      s++
      println("Bake a small pizza, l:" + l + ", s:" + s)
      okSmall.signal()
      okLarge.signal()
    }finally{
      lock.unlock()
    }
  }

  void bakeLargePizza() {
    lock.lock()
    try{
      l++
      println("Bake a large pizza, l:" + l + ", s:" + s)
      okLarge.signal()
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