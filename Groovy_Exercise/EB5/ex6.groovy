import java.util.concurrent.Semaphore;


// Declare semaphores here
noOfCarsCrossing = [0,0]; // list of ints
r = new Random ();


100.times {
  int myEndpoint = r.nextInt (2); // pick a random direction
  Thread.start { // Car
    // entry protocol
    // cross crossing
    // exit protocol
  }
}