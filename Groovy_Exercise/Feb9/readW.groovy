import java.util.concurrent.Semaphore

Semaphore resource = new Semaphore(1)
int r = 0
Semaphore readerMutex = new Semaphore(1) // for counting the num of readers
Semaphore entryqueue = new Semaphore(1, true)

10.times{
  int id = it
  Thread.start { //Writer
    entryqueue.acquire()
    // ===
    resource.acquire() // !!be careful to be locked in the queue!!!
    // ===
    entryqueue.release()
    // write to the shared resource
    println("Writer " + id + " is writing..")
    resource.release()
  }
}

20.times{
  int id = it
  Thread.start { // Reader
    entryqueue.acquire()
    // ===
    readerMutex.acquire()
    r++
    if (r == 1) {
      resource.acquire()
    }
    readerMutex.release()
    // ===
    entryqueue.release()
    // reads from the shared resource
    println("Reader " + id + " is reading..")
    readerMutex.acquire()
    r--
    if (r == 0){
      resource.release()
    }
    readerMutex.release()
  }
}

