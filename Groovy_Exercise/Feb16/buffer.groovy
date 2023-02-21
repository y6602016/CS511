class PC{
  Integer buffer 

  PC(){
    buffer = null
  }

  public synchronized void produce(Integer o){
    while (buffer != null){ // buffer may change after being waked up, so using "while" instad of "if"
    // so that we can evaluate condition again to ensure everything works correct
      wait()
    } 
    buffer = o // no racde condition for the buffer
    notifyAll() // use notifyAll -> no deadlock! use notify -> deadlock
  }

  public synchronized Integer consume(){
    while (buffer == null){
      wait()
    }
    Integer temp = buffer
    buffer = null
    notifyAll() // may wake up someone who we don't want to wake up, ex: another consumer, aka, permission leaking
    return temp
  }
}

PC b = new PC()

10.times{
  int id = it
  Thread.start{// producers
    Integer i = (new Random()).nextInt(100)
    b.produce(i)
    println(id + " produced " + i)
  }
}

10.times{
  int id = it
  Thread.start{// consumers
    println(id + " consumes " + b.consume())
  }
}