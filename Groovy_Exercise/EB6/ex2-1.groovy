class TWS{
  int state = 0
  
  public synchronized void one(){
    while (state != 0){
      wait()
    }
    println(state)
    state++
    notifyAll()
  }

  public synchronized void two(){
    while (state != 1){
      wait()
    }
    println(state)
    state++
    notifyAll()
  }

  public synchronized void three(){
    while (state != 2){
      wait()
    }
    println(state)
    state = 0
    notifyAll()
  }
}

TWS t = new TWS()
10.times{
  Thread.start{
    switch((new Random()).nextInt(3)){
      case 0: t.one(); break
      case 1: t.two(); break
      default: t.three(); break
    }
  }
}