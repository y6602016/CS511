Integer static N = 5
Integer[] buffer = new Integer[N];
int start, end;
Semaphore produce = new Semaphore(N)
Semaphore consume = new Semaphore(0)
Semaphore mutexP = new Semaphore(1)
Semaphore mutexC = new Semaphore(1)


Thread.start {
  while(true) {
    produce.acquire()
    // producer
    mutexP.acquire()
    buffer[end] = (new Random()).nextInt(100)
    end = (end + 1) % N
    mutexP.release()
    consume.release()
  }
}

Thread.start {
  Integer item;
  while (true) {
    // consumer
    consume.acquire()
    mutexC.acquire()
    item = buffer[start]
    start = (start + 1) % N
    mutexC.release()
    produce.release()
  }
}