import java.util.concurrent.Semaphore

Semaphore ticket = new Semaphore(0) // binary Semaphore
Semaphore mutex = new Semaphore(1) // mutex for multiple jets fans to avoid that two fans each
// get the first ticket, such that both are stuck at the second ticket. Only one jets fan can collect
// ticket at a time

30.times {
  int id = it
  Thread.start { // Patriots
    ticket.release()
    println("The " +  id + " Patriots fan enters.")
  }
}

20.times {
  int id = it
  Thread.start {// Jets
    mutex.acquire()
    ticket.acquire()
    ticket.acquire()
    println("The " +  id + " Jets fan enters.")
    mutex.release()
  }
}