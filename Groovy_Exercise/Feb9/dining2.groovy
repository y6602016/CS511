import java.util.concurrent.Semaphore

final int N = 5
List<Semaphore> forks = []
N.times{
  forks.add(new Semaphore(1))
}
Semaphore chairs = new Semaphore(N - 1) // one person doesn't eat first

N.times{
  int id = it
  Thread.start{
    int left = id, right = (id + 1) % N

    println(id + " srarted " + left + ", " + right)
    while (true){
      chairs.acquire()
      println(id + " eating")
      forks[left].acquire()
      forks[right].acquire()

      forks[left].release()
      forks[right].release()
      println(id + " done")
      chairs.release()
    }
  }
}