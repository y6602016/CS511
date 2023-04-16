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
Semaphore mutex = new Semaphore(1)
Semaphore mutexCats = new Semaphore(1)
Semaphore mutexDogs = new Semaphore(1)
Semaphore area = new Semaphore(1)
animals = [0, 0] // [cat, dog]

20.times { //Cat
  int id = it
  Thread.start {
    mutex.acquire()
    mutexCats.acquire()
    if (animals[0] == 0){ // who comes first, who acquires
      area.acquire()
    }
    animals[0]++
    mutexCats.release()
    mutex.release()

    // access feeding lot
    lots.acquire()
    // eat
    println("The " + id + "th cat is eating")
    println("cats: " + animals[0] + ", dogs: " + animals[1])
    // exit feeding lot
    lots.release()

    mutexCats.acquire()
    animals[0]--
    if (animals[0] == 0) {
      area.release()
    }
    mutexCats.release()
  }
}

15.times { //Dog
  int id = it
  Thread.start {
    mutex.acquire()
    mutexDogs.acquire()
    if (animals[1] == 0) {
      area.acquire()
    }
    animals[1]++
    mutexDogs.release()
    mutex.release()

    // access feeding lot
    lots.acquire()
    // eat
    println("The " + id + "th dog is eating")
    println("cats: " + animals[0] + ", dogs: " + animals[1])
    // exit feeding lot
    lots.release()

    mutexDogs.acquire()
    animals[1]--
    if (animals[1] == 0) {
      area.release()
    }
    mutexDogs.release()
  }
}