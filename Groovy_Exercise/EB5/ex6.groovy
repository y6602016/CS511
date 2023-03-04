import java.util.concurrent.Semaphore;

// 2. No. It's not fair since one side might starve and never enter the road
// ex: q1 = [a, b], q2 = [c, d], and q1 acquires the road
// and then "e" arrives at q1, "e" runs before "c" and "d" in q2.
// q2 only can run whenever q1 becomes empty -> q2 starves

// 2. Yes, by using strong semaphores?

// Declare semaphores here
noOfCarsCrossing = [0,0]; // must use seperate count! when one direction is going, the other one needs to be blocked at count = 0
r = new Random ();
endpointMutex = [new Semaphore(1, true), new Semaphore(1, true)]
Semaphore road = new Semaphore(1)

// ex6-2 
enterMutex = [new Semaphore(3, true), new Semaphore(3, true)]

300.times {
  int id = it
  int myEndpoint = r.nextInt (2); // pick a random direction
  Thread.start { // Car
    // entry protocol
    enterMutex[myEndpoint].acquire() // ex6-2

    endpointMutex[myEndpoint].acquire()
    if (noOfCarsCrossing[myEndpoint] == 0) {
      road.acquire()
    }
    noOfCarsCrossing[myEndpoint]++
    endpointMutex[myEndpoint].release()

    // cross crossing
    // println("Car " + id + " is leaving from " + myEndpoint)
    println ("car $id crossing in direction "+myEndpoint + " current totals "+noOfCarsCrossing);

    // exit protocol
    endpointMutex[myEndpoint].acquire()
    noOfCarsCrossing[myEndpoint]--
    if (noOfCarsCrossing[myEndpoint] == 0){
      road.release()
    }
    endpointMutex[myEndpoint].release()

    enterMutex[myEndpoint].release() // ex6-2
  }
}