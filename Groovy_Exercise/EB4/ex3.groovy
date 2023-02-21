import java.util.concurrent.Semaphore
Semaphore okToI = new Semaphore(0);
Semaphore okToO = new Semaphore(0);
Semaphore okToOK = new Semaphore(0);

Thread.start { // P
    print(" R ");
    okToI.release();
    okToOK.acquire();
    print(" OK ");
}

Thread.start { // Q
    okToI.acquire();
    print(" I ");
    okToO.release();
    okToOK.acquire();
    print(" OK ");
}

Thread.start { // R
    okToO.acquire();
    print(" O ");
    okToOK.release();
    okToOK.release();
    print(" OK ");
}