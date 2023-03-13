import java.util.concurrent.Semaphore

final int N = 5
int[] buffer = new int[N]
int start = 0, end = 0
Semaphore producer = new Semaphore(N)
Semaphore consumer = new Semaphore(0)
mutex = [new Semaphore(1), new Semaphore(1)]

10.times{
  int id = it
  Thread.start{
    Random r = new Random()
    2.times{
      int item = r.nextInt(1000)
      producer.acquire()
      mutex[0].acquire()
      buffer[start] = item
      println(id + " added product " + buffer[start] + " at " + start);
      start = (start + 1) % N
      mutex[0].release()
      consumer.release()
    }
  }
}

10.times{
  int id = it
  Thread.start{
    2.times{
      consumer.acquire()
      mutex[1].acquire()
      println(id + " consumed product " + buffer[end] + " at " + end);
      end = (end + 1) % N
      mutex[1].release()
      producer.release()
    }
  }
}

