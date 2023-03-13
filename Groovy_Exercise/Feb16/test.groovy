class Barrier{
  int size
  int arrival
  Barrier(int s){
    size = s
  }
  public synchronized void reached(){
    arrival++
    while(arrival < size){
      wait()
    }
    notifyAll()
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