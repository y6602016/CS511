import java.util.concurrent.Semaphore

final int N = 5;
int[] buffer = new int[N];
start = 0;
end = 0;
Semaphore produce = new Semaphore(N)
Semaphore consume = new Semaphore(0)
Semaphore mutexP = new Semaphore(1)
Semaphore mutexC = new Semaphore(1)

5.times {
  int id = it;
  Thread.start {
    Random r = new Random();
    while(true) {
      int item = r.nextInt(10000);
      produce.acquire(); // avoid consumer consumes more
      mutexP.acquire(); // avoid mutiple producers over-write
      buffer[start] = item;
      println(id + " added product " + buffer[start] + " at " + start);
      start = (start + 1) % N;
      mutexP.release(); // avoid mutiple producers over-write
      consume.release(); // avoid consumer consumes more
    }
  }
}


5.times {
  int id = it;
  Thread.start {
    while(true) {
      consume.acquire(); // avoid consumer consumes more
      mutexC.acquire(); // avoid mutiple consumers over-consume
      int item = buffer[end]
      println(id + " consumed product " + item + " at " + end);
      end = (end + 1) % N;
      mutexC.release(); // avoid mutiple consumers over-consume
      produce.release(); // avoid consumer consumes more
    }
  }
}