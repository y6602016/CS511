import java.util.concurrent.locks.*

class Pizza {
  // Variables declared here
  int l = 0
  int s = 0
  int N
  Lock lock = new ReentrantLock()
  Condition okLarge = lock.newCondition()
  Condition okSmall = lock.newCondition()
  Condition okBake = lock.newCondition()

  Pizza(int size){
    N = size
  }

  void purchaseSmallPizza() {
    lock.lock()
    try{
      while(s < 1){
        println("Waiting for a small pizza, l:" + l + ", s:" + s)
        okSmall.await()
      }
      s--
      println("Take a small pizza, l:" + l + ", s:" + s)
      okBake.signal()
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
        okBake.signal()
      }
      else if(s >= 2){
        s = s - 2
        println("Take large pizza(two small), l:" + l + ", s:" + s)
        okBake.signal()
        okBake.signal()
      }
    }finally{
      lock.unlock()
    }
  }

  void bakeSmallPizza() {
    lock.lock()
    try{
      while(l + s >= N){
        println("Waiting for baking, l:" + l + ", s:" + s)
        okBake.await()
      }
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
      while(l + s >= N){
        println("Waiting for baking, l:" + l + ", s:" + s)
        okBake.await()
      }
      l++
      println("Bake a large pizza, l:" + l + ", s:" + s)
      okLarge.signal()
    }finally{
      lock.unlock()
    }
  }
}

Pizza p = new Pizza(6)



4.times{
  Thread.start{
    p.purchaseSmallPizza()
  }
}

22.times{
  Thread.start{
    p.bakeSmallPizza()
  }
}

4.times{
  Thread.start{
    p.purchaseLargePizza()
  }
}

2.times{
  Thread.start{
    p.bakeLargePizza()
  }
}