class Grid {
  int p = 0
  int c = 0

  synchronized void startConsuming() {
    while(c + 1 > p){ // if c + 1 <= p, ok
      wait()
    }
    c++
    println("consuming, p:" + p + " c:" + c)
  }

  synchronized void stopConsuming() {
    c--
    notifyAll() // c-, startConsuming and stopProducing race
    println("stop consuming, p:" + p + " c:" + c)
  }

  synchronized void startProducing() {
    p++
    notifyAll() // p+, startConsuming and stopProducing race
    println("producing, p:" + p + " c:" + c)
  }

  synchronized void stopProducing() {
    while(p - 1 < c){ // if p - 1 >= c, ok
      wait()
    }
    p--
    println("stop producing, p:" + p + " c:" + c)
  } 
}

Grid g = new Grid()

5.times{
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

5.times{
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