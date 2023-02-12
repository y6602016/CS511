import java.util.concurrent.Semaphore;


// Declare semaphores here
noOfCarsCrossing = [0,0]; // list of ints
r = new Random ();
endpointMutex = [new Semaphore(1, true), new Semaphore(1, true)]
Semaphore count = new Semaphore(1)
Semaphore road = new Semaphore(1)

100.times {
  int id = it
  int myEndpoint = r.nextInt (2); // pick a random direction
  Thread.start { // Car
    // entry protocol
    endpointMutex[myEndpoint].acquire()
    if (noOfCarsCrossing[myEndpoint] == 0) {
      road.acquire()
    }
    noOfCarsCrossing[myEndpoint]++
    endpointMutex[myEndpoint].release()

    // cross crossing
    println("Car " + id + " is leaving from " + myEndpoint)
    println("Enpoint 0: " + noOfCarsCrossing[0] + ", Enpoint 1: "+ noOfCarsCrossing[1])

    // exit protocol
    endpointMutex[myEndpoint].acquire()
    noOfCarsCrossing[myEndpoint]--
    if (noOfCarsCrossing[myEndpoint] == 0){
      road.release()
    }
    endpointMutex[myEndpoint].release()
  }
}