import java.util.concurrent.Semaphore;

// not fair?

Semaphore permToLoad = new Semaphore(0)
Semaphore doneLoading = new Semaphore(0)
Semaphore mutex = new Semaphore(1)
stationMutex = [new Semaphore(1, true), new Semaphore(1, true)]

// 200.times {
//   int id = it
//   int dir = (new Random()).nextInt(2);
//   Thread.start { // PassengerTrain travelling in direction dir
//     stationMutex[dir].acquire()
//     // stay at the station
//     println("dir:" + dir + " Passenger Train " + id +  " is staying at the station")
//     println("dir:" + dir + " Passenger Train " + id +  " has left from the station")
//     stationMutex[dir].release()
//   }
// }

200.times {
  int id = it
  int dir = (new Random()).nextInt(2);
  Thread.start { // Freight Train travelling in direction dir
    mutex.acquire()
    stationMutex[dir].acquire()
    stationMutex[1 - dir].acquire()
    println("dir:" + dir + " Freight Train " + id +  " is staying at the station")
    permToLoad.release();
    doneLoading.acquire();
    println("dir:" + dir + " Freight Train " + id +  " has left from the station")
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
    // stay at the station
    println("dir:" + dir + " Passenger Train " + id +  " is staying at the station")
    println("dir:" + dir + " Passenger Train " + id +  " has left from the station")
    stationMutex[dir].release()
  }
}