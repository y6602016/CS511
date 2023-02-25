import java.util.concurrent.locks.*

class Buffer{
  Integer buffer = null
  final Lock lock = new ReentrantLock()
  final Condition canProduce = lock.newCondition()
  final Condition canConsume = lock.newCondition()

  void produce(Integer o){
    lock.lock()
    try{
      while (buffer != null){
        canProduce.await() 
      }
      buffer = o
      canConsume.signal() 
    }finally{
      lock.unlock()
    }
  }

  Integer consume(){
    lock.lock()
    try{
      while (buffer == null){
        canConsume.await() 
      }
      Integer temp = buffer
      buffer = null
      canProduce.signal() 
      return temp
    }finally{
      lock.unlock()
    }
  }
}



Buffer b = new Buffer()

20.times{
  int id = it
  Thread.start{
    println(id + " produces")
    b.produce(id)
  }
}

20.times{
  int id = it
  Thread.start{
    println(id + " consumes " + b.consume())
  }
}