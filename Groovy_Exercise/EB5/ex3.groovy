import java.util.concurrent.Semaphore

final int N = 5
onboard = [new Semaphore(0), new Semaphore(0)]
offboard = [new Semaphore(0), new Semaphore(0)]
mutexOnboard = [new Semaphore(1), new Semaphore(1)]
mutexOffboard = [new Semaphore(1), new Semaphore(1)]
Semaphore move = new Semaphore(0)

p = 0

Thread.start { // ferry
  int coast = 0
  while (true) {
    // allow passengers on
    onboard[coast].release() //open the door for the passengers

    move.acquire() // stop and wait 

    // move to opposite coast
    coast = 1 - coast;

    offboard[coast].release() //open the door for the passengers

    move.acquire()// stop and wait 
  }
}

100.times {
  Thread.start { // Passenger on East coast
    // get on
    mutexOnboard[0].acquire()
    onboard[0].acquire() 
    p++ 
    println("East side passenger is onboarding")
    onboard[0].release() // pass the key to the next passenger
    if (p == N) { 
      onboard[0].acquire() // full, close the door
      move.release()
    }
    mutexOnboard[0].release()

    // get off at opposite coast
    mutexOffboard[1].acquire()
    offboard[1].acquire() 
    p-- 
    println("East side passenger is offboarding")
    offboard[1].release() // pass the key to the next passenger
    if (p == 0) { // empty, close the door
      offboard[1].acquire() // close the door 
      move.release()
    }
    mutexOffboard[1].release()
  }
}

100.times {
  Thread.start { // Passenger on West coast
    // get on
    mutexOnboard[1].acquire()
    onboard[1].acquire() 
    p++ 
    println("West side passenger is onboarding")
    onboard[1].release() // pass the key to the next passenger
    if (p == N) { // full, close the door
      onboard[1].acquire() // close the door 
      move.release()
    }
    mutexOnboard[1].release()

    // get off at opposite coast
    mutexOffboard[0].acquire()
    offboard[0].acquire() 
    p-- 
    println("West side passenger is offboarding")
    offboard[0].release() // pass the key to the next passenger
    if (p == 0) { // empty, close the door
      offboard[0].acquire() // close the door 
      move.release()
    }
    mutexOffboard[0].release()
  }
}