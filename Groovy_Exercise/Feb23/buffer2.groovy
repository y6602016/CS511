import java.util.concurrent.locks.*

class Buffer{
  private Integer[] data
  private int begin = 0
  private int end = 0
  private final int N
  final Lock lock = new ReentrantLock()
  final Condition notEmpty = lock.newCondition()
  final Condition notFull = lock.newCondition()

  public Buffer(int size){
    this.N = size
    data = new Integer[N]
  }

  private boolean isFull(){
    return ((begin + 1) % N) ==  end
  }

  private boolean isEmpty(){
    return begin == end
  }

  void produce(Integer o){
    lock.lock()
    try{
      while (isFull()){
        notFull.await() // waiting for being not full then can produce one
      }
      data[begin] = o
      begin = (begin + 1) % N
      notEmpty.signal() // notifying it's not empty
    }finally{
      lock.unlock()
    }
  }

  Integer consume(){
    lock.lock()
    try{
      while (isEmpty()){
        notEmpty.await() // waiting for being not empty then can consume one
      }
      Integer temp = data[end]
      end = (end + 1) % N
      notFull.signal() // notifying it's empty
      return temp
    }finally{
      lock.unlock()
    }
  }
}



Buffer b = new Buffer(5)

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