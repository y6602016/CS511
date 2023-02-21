

200.times{
  int count = 0
  P = Thread.start{
    10.times{
      int temp = count + 1
      count = temp
    }
  }
  Q = Thread.start{
    10.times{
      int temp = count + 1
      count = temp
    }
  }

  P.join()
  Q.join()
  println(count)
}