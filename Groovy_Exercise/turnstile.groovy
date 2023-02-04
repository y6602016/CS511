import java.util.concurrent.Semaphore

counter = 0;
mutex = new Semaphore(1);
f = new Semaphore(0);

def turnstile() {
  50.times{
    mutex.acquire();
    counter++;
    mutex.release();
  }
  f.release();
}

2.times{
  Thread.start{
    turnstile();
  }
}

f.acquire()
f.acquire()
println(counter)
