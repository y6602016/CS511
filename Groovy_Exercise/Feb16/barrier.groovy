class Barrier{
  private static int size
  private int arrival = 0
  Barrier(int s){
    size = s
  }

  public synchronized void reached(){
    // if not everyone reach, wait; if all reach, go
    arrival++
    while (sarrival < size){
      wait()
    }
    notifyAll() // if using notify, same result?
  }
}

Barrier b = new Barrier(3)

Thread.start{
  print("a")
  b.reached()
  print("1")
}

Thread.start{
  print("b")
  b.reached()
  print("2")
}

Thread.start{
  print("c")
  b.reached()
  print("3")
}