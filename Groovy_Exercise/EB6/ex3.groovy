class Barrier{
  private static int size
  private arrival
  Barrier(int s){
    size = s
  }

  public synchronized void waitAtBarrier(){
    // if not everyone reach, wait; if all reach, go
    arrival++
    while (arrival < size){
      wait()
    }
    notifyAll() // if using notify, it's cascading signaling
  }
}

Barrier b = new Barrier(3)

Thread.start{
  print("a")
  b.waitAtBarrier()
  print("1")
}

Thread.start{
  print("b")
  b.waitAtBarrier()
  print("2")
}

Thread.start{
  print("c")
  b.waitAtBarrier()
  print("3")
}