import java.util.concurrent.Semaphore

Semaphore ticket = new Semaphore(0) // binary Semaphore
Semaphore mutex = new Semaphore(1)
itGotLate = false

8.times {
  int id = it
  Thread.start { // Patriot
    ticket.release()
    println("The " +  id + " Patriots fan enters.")
  }
}

20.times {
  int id = it
  Thread.start {// Jets
    mutex.acquire()
    if (!itGotLate) {
      // mutex.acquire() // mutex CANN'T be here! If multiple fans are stuck here(not happy hour yet)
      // and then happy hour is on, the first fan can get in because happy hour only releases two tickets
      // but the rest fans still can't go in since no more tickets
      ticket.acquire() // #someone may stay at here for tickets and then happy hour is on
      ticket.acquire()
      // mutex.release()
    }
    println("The " +  id + " Jets fan enters.")
    mutex.release()
  }
}

Thread.start { //Crontab, aka.happy hour
  sleep(3000)
  itGotLate = true
  // #once happy hour is on, releasing tickets in case anyone is asked to wait from not happy hour yet
  ticket.release()
  ticket.release()
}