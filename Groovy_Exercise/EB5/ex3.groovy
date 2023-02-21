import java.util.concurrent.Semaphore

final int N = 5
onboard = [new Semaphore(0), new Semaphore(0)]
offboard = [new Semaphore(0), new Semaphore(0)]
Semaphore move = new Semaphore(0)

p = 0

Thread.start { // ferry
  int coast = 0
  while (true) {
    // allow passengers on
    N.times{
      onboard[coast].release() //open the door for the passengers
    }

    N.times{
      move.acquire() // stop and wait for N signals
    }

    // move to opposite coast
    coast = 1 - coast;

    N.times{
      offboard[coast].release() //open the door for the passengers
    }
    
    N.times{
      move.acquire() // stop and wait 
    } 
  }
}

100.times {
  Thread.start { // Passenger on East coast
    // get on
    onboard[0].acquire()
    println("East side passenger is onboarding")
    move.release() // signal: onboarded

    offboard[1].acquire() 
    println("East side passenger is offboarding")
    move.release()
  }
}

100.times {
  Thread.start { // Passenger on West coast
    // get on
    onboard[1].acquire()
    println("West side passenger is onboarding")
    move.release() // signal: onboarded

    offboard[0].acquire() 
    println("West side passenger is offboarding")
    move.release()
  }
}