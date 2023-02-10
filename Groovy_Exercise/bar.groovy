Semaphore ticket = new Semaphore(0) // binary Semaphore
Semaphore mutex = new Semaphore(1)
Boolean itGotLate = false

100.times {
  Thread.start { // Patriot
    ticket.release()
  }
}

100.times {
  Thread.start {// Jets
    mutex.acquire()
    if (!itGotLate) {
      // mutex.acquire()
      ticket.acquire()
      ticket.acquire()
      // mutex.release()
    }
    mutex.release()
  }
}

Thread.start { //Crontab
  sleep(1000)
  itGotLate = true
  ticket.release()
  ticket.release()
}