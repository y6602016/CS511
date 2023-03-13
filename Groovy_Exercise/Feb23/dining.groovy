import java.util.concurrent.locks.*

class ForkMonitor{
  final int N
  List<Integer> forks = []
  final Lock lock = new ReentrantLock()
  final List<Condition> okEat = []

  public ForkMonitor(int size){
    N = size
    N.times{
      forks.add(2)
    }
    N.times{
      okEat.add(lock.newCondition())
    }
  }

  private void updateForkCount(int i, int delta){
    lock.lock()
    try{
      forks[(i + 1) % N] = forks[(i + 1) % N] + delta
      if (i - 1 >= 0){
        forks[i - 1] = forks[i - 1] + delta
      }else{ // i = 0
        forks[N - 1] = forks[N - 1] + delta
      }
    }finally{
      lock.unlock()
    }
  }

  public void takeForks(int i){
    lock.lock()
    try{
      while (forks[i] != 2){ // if forks[i] != 2, it means neighbors are using your fork, so wait
        okEat[i].acwait()
      }
      updateForkCount(i, -1)
    }finally{
      lock.unlock()
    }
  }

  public void releaseForks(int i){
    lock.lock()
    try{
      updateForkCount(i, 1)
      if (forks[(i + 1) % N] == 2){
        okEat[(i + 1) % N].signal()
      }
      if(i > 0){
        if(forks[(i - 1) % N] == 2){
          okEat[(i - 1) % N].signal()
        }
      }else{
        if(forks[N - 1] == 2){
          okEat[N - 1].signal()
        }
      }
    }finally{
      lock.unlock()
    }
  }
}

ForkMonitor f = new ForkMonitor(5)
5.times{
  int id = it
  Thread.start{
    while (true){
      f.takeForks(id)
      println(id + " grabs forks")
      println(id + " releases forks")
      f.releaseForks(id)
    }
  }
}