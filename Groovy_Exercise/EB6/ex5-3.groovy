class Grid {
  final int N
  int p = 0
  int c = 0
  int waitExitP = 0

  Grid(int size){
    N = size
  }

  synchronized void startConsuming() {
    while(c + 1 > p || waitExitP > 0){ // stopProducing has the priority
      wait()
    }
    c++
    println("consuming, p:" + p + " c:" + c)
  }
  synchronized void stopConsuming() {
    c--
    notifyAll()
    println("stop consuming, p:" + p + " c:" + c)
  }
  synchronized void startProducing() {
    while (p >= N){
      wait()
    }
    p++
    notifyAll()
    println("producing, p:" + p + " c:" + c)
  }
  synchronized void stopProducing() {
    while(p - 1 < c){
      println("wait stop producing")
      waitExitP++
      wait()
      waitExitP--
    }
    p--
    notifyAll()
    println("stop producing, p:" + p + " c:" + c)
  } 
}

Grid g = new Grid(3)

10.times{
  int id = it
  Thread.start{
    g.startConsuming()
    sleep(2)
    g.stopConsuming()
    g.startProducing()
    sleep(1)
    g.stopProducing()
  }
}

10.times{
  int id = it
  Thread.start{
    g.startProducing()
    sleep(2)
    g.stopProducing()
    g.startConsuming()
    sleep(2)
    g.stopConsuming()
  }
}