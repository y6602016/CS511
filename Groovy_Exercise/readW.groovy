

Semaphore resource = new Semaphore(1)
int r = 0
Semaphore mutex = new Semaphore(1)
Semaphore entryqueue = new Semaphore(1, true)

10.times{
  Thread.start { //Writer
  entryqueue.acquire()
  // ===
  resource.acquire() // !!be careful to be locked in the queue!!!
  // ===
  entryqueue.release()
  // write to the shared resource
  resource.release()
}
}

20.times{
  Thread.start { // Reader
  entryqueue.acquire()
  // ===
  mutex.acquire()
  r++
  if (r == 1) {
    resource.acquire()
  }
  mutex.release()
  // ===
  entryqueue.release()
  // reads from the shared resource
  mutex.acquire()
  r--
  if (r == 0){
    resource.release()
  }
  mutex.release()
}
}
