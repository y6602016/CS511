import java.util.concurrent.locks.*

class WashCar{
  boolean[] state = [false, false, false]
  boolean[] load = [false, false, false]
  Lock lock = new ReentrantLock()
  Condition[] station = [lock.newCondition(),lock.newCondition(),lock.newCondition()]
  Condition[] pre = [lock.newCondition(),lock.newCondition(),lock.newCondition()]
  Condition[] activate = [lock.newCondition(),lock.newCondition(),lock.newCondition()]
  Condition[] done = [lock.newCondition(),lock.newCondition(),lock.newCondition()]

  public void one(int id){
    lock.lock()
    try{
      while(state[0]){
        station[0].await()
      }
      println(id + " arrive 0")
      state[0] = true
      while(!load[0]){
        activate[0].await() // await here to avoid missed pre[0].signal() 
      }
      pre[0].signal()
      done[0].await()
      println(id + " leave 0")
    }finally{
      lock.unlock()
    }
  }
  public void two(int id){
    lock.lock()
    try{
      while(state[1]){
        station[1].await()
      }
      println(id + " arrive 1")
      state[1] = true
      state[0] = false
      station[0].signal()
      while(!load[1]){
        activate[1].await()
      }
      pre[1].signal()
      done[1].await()
      println(id + " leave 1")
    }finally{
      lock.unlock()
    }
  }
  public void three(int id){
    lock.lock()
    try{
      while(state[2]){
        station[2].await()
      }
      println(id + " arrive 2")
      state[2] = true
      state[1] = false
      station[1].signal()
      while(!load[2]){
        activate[2].await()
      }
      pre[2].signal()
      done[2].await()
      println(id + " leave 2")
      state[2] = false
      station[2].signal()
    }finally{
      lock.unlock()
    }
  }
  public void process(int id){
    lock.lock()
    try{
      load[id] = true
      activate[id].signal()
      pre[id].await()
      println(id + " Process")
      done[id].signal()
    }finally{
      lock.unlock()
    }
  }
}

WashCar t = new WashCar()
5.times{
  int id = it
  Thread.start{
    t.one(id)
    t.two(id)
    t.three(id)
  }
}

3.times{
  int id = it
  Thread.start{
    while(true){
      t.process(id)
    }
}
}
