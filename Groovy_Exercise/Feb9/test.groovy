import java.util.concurrent.Semaphore;

Semaphore c = new Semaphore(6, true)

int t = 0
Semaphore mutex = new Semaphore(1)
Semaphore truck = new Semaphore(2, true)
int c2 = 0
int b = 0



100.times {
  int id = it
  Thread.start { 
    mutex.acquire()
    if(t == 0){
      6.times{
        c.acquire()
      }
    }
    t++
    mutex.release()
    truck.acquire()
    println("t")
    println("leave")

    truck.release()
    mutex.acquire()
    t--
    if(t == 0){
      6.times{
        c.release()
      }
    }
    mutex.release()
  }
}

100.times {
  int id = it
  Thread.start { 
    c.acquire()
    c2++
    println("C " + c2)
    c2--
    c.release()
  }
}

// 3.times{
//   int id = it
//   Thread.start { // Loading Machine
//     while (true) {
//       permToLoad[id].acquire()
//       doneLoading[id].release()
//     }
//   }
// }


