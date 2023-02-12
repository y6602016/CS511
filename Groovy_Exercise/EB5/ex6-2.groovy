import java.util.concurrent.Semaphore;

// 2. It's not fair since the condition to switch the right to use the road is that the number of
// the car of the current direction reduces to 0, if there are cars with the current direction
// coming in, the opposite direction needs to wait for the all cars finishing.

noOfCarsCrossing = [0,0]; // list of ints
r = new Random ();
// leave and arrive use different Semaphore to control the number of cars
endpointLeaveMutex = [new Semaphore(1, true), new Semaphore(1, true)]
endpointArriveMutex = [new Semaphore(1, true), new Semaphore(1, true)]
Semaphore road = new Semaphore(1)
countMutex = [new Semaphore(1), new Semaphore(1)] // seperate countMutex to avoid block unrelated cards

200.times {
  int id = it
  int myEndpoint = r.nextInt (2); // pick a random direction
  Thread.start { // Car
    // entry protocol
    endpointLeaveMutex[myEndpoint].acquire()
    while (noOfCarsCrossing[myEndpoint] >= 3){}
    countMutex[myEndpoint].acquire()
    if (noOfCarsCrossing[myEndpoint] == 0){
      road.acquire()
    }
    noOfCarsCrossing[myEndpoint]++
    countMutex[myEndpoint].release()
    endpointLeaveMutex[myEndpoint].release()
    
    // cross crossing
    println("Car " + id + " is leaving from " + myEndpoint + " /Enpoint:[" + noOfCarsCrossing[0] + ","+ noOfCarsCrossing[1] + "]")
    // println("Enpoint 0: " + noOfCarsCrossing[0] + ", Enpoint 1: "+ noOfCarsCrossing[1])

    // exit protocol
    endpointArriveMutex[myEndpoint].acquire()
    countMutex[myEndpoint].acquire()
    noOfCarsCrossing[myEndpoint]--
    println("Car " + id + " is arrive at " + (1 - myEndpoint) + " /Enpoint:[" + noOfCarsCrossing[0] + ","+ noOfCarsCrossing[1] + "]")
    if (noOfCarsCrossing[myEndpoint] == 0){
      road.release()
    }
    countMutex[myEndpoint].release()
    endpointArriveMutex[myEndpoint].release()
  }
}