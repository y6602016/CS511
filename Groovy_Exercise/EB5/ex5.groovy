import java.util.concurrent.Semaphore

// station.acquire(): claim a lease at the station, if it's executed, it means the car moves in successfully
// station.release(): give the lease to the next car
// The cars must release the current lease after they successfully moves into the next station
// permToProcess[0].release(): Notifying the machine "I'm ready", waking up the blocked machine
// doneProcessing[0].acquire(): Waiting for the machine done, if it's executed, it means the car can leave
// and can claim the lease of the next station

Semaphore station0 = new Semaphore(1, true)
Semaphore station1 = new Semaphore(1, true) 
Semaphore station2 = new Semaphore(1, true)
permToProcess = [new Semaphore(0), new Semaphore(0), new Semaphore(0)] // list of semaphores for machines
doneProcessing = [new Semaphore(0), new Semaphore(0), new Semaphore(0)] // list of semaphores for machines


5.times {
  int id = it
  Thread.start { // Car
    // Go to station 0
    station0.acquire()
    println("Car " + id + " is already in the station 0")
    permToProcess[0].release()
    doneProcessing[0].acquire()

    // Move on to station 1
    station1.acquire()
    println("Car " + id + " is already in the station 1")
    station0.release()
    permToProcess[1].release()
    doneProcessing[1].acquire()


    // Move on to station 2
    station2.acquire()
    println("Car " + id + " is already in the station 2")
    station1.release()
    permToProcess[2].release()
    doneProcessing[2].acquire()
    station2.release()
  }
}

3.times {
  int id = it; // iteration variable
  Thread.start { // Machine at station id
    while (true) {
    // Wait for car to arrive
    permToProcess[id].acquire()
    println("Station " + id + " is working")
    // Process car when it has arrived
    doneProcessing[id].release()
    }
  }
}