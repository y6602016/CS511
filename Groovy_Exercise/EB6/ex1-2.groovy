class Bar {
  // your code here
  int p 
  boolean late 

  Bar(){
    p = 0
    late = false
  }

  public synchronized jets(){
    while (!late && p < 2){
      wait()
    }
    if (!late){
      p -= 2
    }
    println("Jets")
  } 

  public synchronized patriots(){
    p++
    if (p > 0 && p % 2 == 0 && !late){
      notify()
    }
    println("Patriots")
  }

  public synchronized itGoLate(){
    late = true
    notifyAll()
  }
}

Bar b = new Bar();

20.times {
  Thread.start {// jets
    b.jets();
  }
}

5.times {
  Thread.start {// patriots
    b.patriots();
  }
}

Thread.start{
  sleep(3000)
  b.itGoLate()
}