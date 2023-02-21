import java.util.concurrent.Semaphore

// 2. The solution is free from starvation, because we use a stromg Semaphore getDiscQueue to queue the clients.
// After the client get the permit, if the current MAX_WEIGHTS is not enough for the client, the client would stay 
// in the while loop until others return weights and there are enough weights for him. 
// Therefore, every client eventually get the desired amount of weights and never starves.
// Also, we use strong semaphores for the apparatus to avoid starvation.


MAX_WEIGHTS = 10;
GYM_CAP = 20;
// Declare semaphores here
Semaphore enterGym = new Semaphore(GYM_CAP)
Semaphore getDiscQueue = new Semaphore(1, true)
Semaphore returnDiscQueue = new Semaphore(1, true)
Semaphore getDisc = new Semaphore(MAX_WEIGHTS)
mutexApp = [new Semaphore(1, true), new Semaphore(1, true), new Semaphore(1, true), new Semaphore(1, true)]

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
    println("$id is entering");

    routine.size().times{
      // complete exercise on machine
      println("$id needs: " + routine[it][1] + " weights");
      getDiscQueue.acquire()
      routine[it][1].times{
        getDisc.acquire()
        println("$id takes one weight");
      }
      getDiscQueue.release()

      mutexApp[routine[it][0]].acquire()
      println("$id is performing:"+routine[it][0] + "--"+ routine[it][1]);
      mutexApp[routine[it][0]].release()

      returnDiscQueue.acquire()
      routine[it][1].times{
        getDisc.release()
        println("$id returns one weight");
      }
      returnDiscQueue.release()
    }

    // leave gym
    println("$id is leaving");
    enterGym.release()
  }
}