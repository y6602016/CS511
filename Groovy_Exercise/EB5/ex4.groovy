import java.util.concurrent.Semaphore

// 2. The solution is free from starvation, because we use a stromg Semaphore getDiscQueue to queue the clients.
// After the client get the permit, if the current MAX_WEIGHTS is not enough for the client, the client would stay 
// in the while loop until others return weights and there are enough weights for him. 
// Therefore, every client eventually get the desired amount of weights and never starves.


MAX_WEIGHTS = 10;
GYM_CAP = 50;
// Declare semaphores here
Semaphore enterGym = new Semaphore(GYM_CAP)
Semaphore getDiscQueue = new Semaphore(1, true)
// Semaphore returnDiscQueue = new Semaphore(1, true)
Semaphore weightMutex = new Semaphore(1) // getting and returning share the same variable, it needs to be atomic
Semaphore app0 = new Semaphore(1, true)
Semaphore app1 = new Semaphore(1, true)
Semaphore app2 = new Semaphore(1, true)
Semaphore app3 = new Semaphore(1, true)

def make_routine(int no_exercises) { // returns a random routine
  Random rand = new Random();
  int size = rand.nextInt(no_exercises);
  def routine = [];
  size.times {
    routine.add(new Tuple(rand.nextInt(4),rand.nextInt(MAX_WEIGHTS)));
  }
  return routine;
}

100.times {
  int id = it;
  Thread.start { // Client
    def routine = make_routine(20); // random routine of 20 exercises
    // enter gym
    enterGym.acquire()

    routine.size().times{
      // complete exercise on machine

      getDiscQueue.acquire()
      while (MAX_WEIGHTS < routine[it][1]){}
      weightMutex.acquire()
      println("MAX_WEIGHTS: " + MAX_WEIGHTS)
      MAX_WEIGHTS -= routine[it][1]
      println("$id is taking "+routine[it][1] + " weights");
      println("MAX_WEIGHTS: " + MAX_WEIGHTS)
      weightMutex.release()
      getDiscQueue.release()

      switch(routine[it][0]){
        case 0:
          app0.acquire()
          break
        case 1:
          app1.acquire()
          break
        case 2:
          app2.acquire()
          break
        case 3:
          app3.acquire()
          break
      }
      println("$id is performing:"+routine[it][0] + "--"+ routine[it][1]);
      switch(routine[it][0]){
        case 0:
          app0.release()
          break
        case 1:
          app1.release()
          break
        case 2:
          app2.release()
          break
        case 3:
          app3.release()
          break
      }

      // returnDiscQueue.acquire()
      weightMutex.acquire()
      MAX_WEIGHTS += routine[it][1]
      println("$id is returning "+routine[it][1] + " weights")
      println("MAX_WEIGHTS: " + MAX_WEIGHTS)
      weightMutex.release()
      // returnDiscQueue.release()
    }

    // leave gym
    enterGym.release()
  }
}