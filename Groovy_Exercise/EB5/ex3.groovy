import java.util.concurrent.Semaphore

final int N = 10
Semaphore eastOnboard = new Semaphore(0)
Semaphore eastOffboard = new Semaphore(0)
Semaphore mutexEastOnboard = new Semaphore(1)
Semaphore mutexEastOffboard = new Semaphore(1)
Semaphore westOnboard = new Semaphore(0)
Semaphore westOffboard = new Semaphore(0)
Semaphore mutexWestOnboard = new Semaphore(1)
Semaphore mutexWestOffboard = new Semaphore(1)
Semaphore move = new Semaphore(0)

p = 0

Thread.start { // ferry
  int coast = 0
  while (true) {
    // allow passengers on
    if (coast == 0) {
      eastOnboard.release() //open the door for the passengers at the east side
    }
    else if (coast == 1){
      westOnboard.release()
    }

    move.acquire() // stop and wait 

    // move to opposite coast
    coast = 1 - coast;

    // wait for all passengers to get off
    if (coast == 1) {
      eastOffboard.release() //open the door for the passengers at the east side to exit
    }
    else if (coast == 0){
      westOffboard.release()
    }

    move.acquire()// stop and wait 
  }
}

100.times {
  Thread.start { // Passenger on East coast
    // get on
    mutexEastOnboard.acquire()
    eastOnboard.acquire() 
    p++ 
    println("East side passenger is onboarding")
    eastOnboard.release() // pass the key to the next passenger
    if (p == N) { // full, close the door
      eastOnboard.acquire() // close the door 
      move.release()
    }
    mutexEastOnboard.release()

    // get off at opposite coast
    mutexEastOffboard.acquire()
    eastOffboard.acquire() 
    p-- 
    println("East side passenger is offboarding")
    eastOffboard.release() // pass the key to the next passenger
    if (p == 0) { // empty, close the door
      eastOffboard.acquire() // close the door 
      move.release()
    }
    mutexEastOffboard.release()
  }
}

100.times {
  Thread.start { // Passenger on West coast
    // get on
    mutexWestOnboard.acquire()
    westOnboard.acquire() 
    p++ 
    println("West side passenger is onboarding")
    westOnboard.release() // pass the key to the next passenger
    if (p == N) { // full, close the door
      westOnboard.acquire() // close the door 
      move.release()
    }
    mutexWestOnboard.release()

    // get off at opposite coast
    mutexWestOffboard.acquire()
    westOffboard.acquire() 
    p-- 
    println("West side passenger is offboarding")
    westOffboard.release() // pass the key to the next passenger
    if (p == 0) { // empty, close the door
      westOffboard.acquire() // close the door 
      move.release()
    }
    mutexWestOffboard.release()
  }
}