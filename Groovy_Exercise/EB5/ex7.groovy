import java.util.concurrent.Semaphore;

// not fair?

Semaphore permToLoad = new Semaphore(0)
Semaphore doneLoading = new Semaphore(0)
Semaphore mutex = new Semaphore(1)
stationMutex = [new Semaphore(1, true), new Semaphore(1, true)]
trains = [0, 0]

200.times {
  int id = it
  int dir = (new Random()).nextInt(2);
  Thread.start { // Freight Train travelling in direction dir
    mutex.acquire()
    stationMutex[dir].acquire()
    stationMutex[1 - dir].acquire()
    trains[dir]++
    println("dir:" + dir + " Freight Train " + id +  " is staying at the station")
    println(trains)
    permToLoad.release();
    doneLoading.acquire();
    trains[dir]--
    stationMutex[1 - dir].release()
    stationMutex[dir].release()
    mutex.release()
  }
}

Thread.start { // Loading Machine
  while (true) {
    permToLoad.acquire();
    // load freight train
    doneLoading.release();
  }
}

200.times {
  int id = it
  int dir = (new Random()).nextInt(2);
  Thread.start { // PassengerTrain travelling in direction dir
    stationMutex[dir].acquire()
    trains[dir]++
    // stay at the station
    println("dir:" + dir + " Passenger Train " + id +  " is staying at the station")
    println(trains)
    trains[dir]--
    stationMutex[dir].release()
  }
}