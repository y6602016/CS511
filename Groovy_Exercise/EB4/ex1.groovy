import java.util.concurrent.Semaphore
Semaphore okToC = new Semaphore(0);
Semaphore okToF = new Semaphore(0);

Thread.start { // P
    print("A");
    okToF.release();
    print("B");
    okToC.acquire();
    print("C");
}

Thread.start { // Q
    print("E");
    okToF.acquire();
    print("F");
    okToC.release();
    print("G");
}