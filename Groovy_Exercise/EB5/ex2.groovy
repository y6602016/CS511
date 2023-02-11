import java.util.concurrent.Semaphore

// similar to the second solution of Reader/Writer, queue is not allowed for this problem!

// the feeding area can be used by either cats or dogs, but not both at the same time
// if it's used by a dog, then more dogs can enter if the total num of dogs <= N
// but it's not allowed for any cat entering; the same policy applies on the case for cats
// Therefore, we should count the number of dog and cats:
// if dogs(cats) = 1 when accessing a lot, it's the first dog(cat), limiting cats(dogs) from entering. 
// if dogs(cats) = 0 when exiting the lot, it's the last dog(cat), either dog or cat can enter 
final int N = 5
Semaphore lots = new Semaphore(N)
Semaphore countCats = new Semaphore(1)
Semaphore countDogs = new Semaphore(1)
Semaphore area = new Semaphore(1)
Semaphore entryqueue = new Semaphore(1, true)
int cats = 0
dogs = 0

10.times { //Cat
  int id = it
  Thread.start {
    countCats.acquire()
    cats++
    if (cats == 1){
      area.acquire()
    }
    countCats.release()

    // access feeding lot
    lots.acquire()
    // eat
    println("The " + id + "th cat is eating")
    // exit feeding lot
    lots.release()

    countCats.acquire()
    cats--
    if (cats == 0) {
      area.release()
    }
    countCats.release()
  }
}

10.times { //Dog
  int id = it
  Thread.start {
    countDogs.acquire()
    dogs++
    if (dogs == 1) {
      area.acquire()
    }
    countDogs.release()

    // access feeding lot
    lots.acquire()
    // eat
    println("The " + id + "th dog is eating")
    // exit feeding lot
    lots.release()

    countDogs.acquire()
    dogs--
    if (dogs == 0) {
      area.release()
    }
    countDogs.release()
  }
}