import java.util.concurrent.Semaphore

final int N = 5
List<Semaphore> forks = []
N.times{
  forks.add(new Semaphore(1))
}

N.times{
  int id = it
  Thread.start{
    int left, right
    if (id == 0){ // breaking the symmetry
      left = 1
      right = 0
    }
    else{
      left = id
      right = (id + 1) % N
    }

    println(id + " srarted " + left + ", " + right)
    while (true){
      forks[left].acquire()
      forks[right].acquire()
      println(id + " eating")
      println(id + " done")
      forks[left].release()
      forks[right].release()
    }
  }
}