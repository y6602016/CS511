class Bar {
  // your code here
  int p = 0

  public synchronized jets(){
    while (p < 2){
      wait()
    }
    p -= 2
    println("Jets")
  } 

  public synchronized patriots(){
    p++
    if (p % 2 == 0){
      notify()
    }
    println("Patriots")
  }
}

Bar b = new Bar();

20.times {
  Thread.start {// jets
    b.jets();
  }
}
10.times {
  Thread.start {// patriots
    b.patriots();
  }
}