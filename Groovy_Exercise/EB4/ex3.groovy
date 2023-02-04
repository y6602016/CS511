import java.util.concurrent.Semaphore
Semaphore okToI = new Semaphore(0);
Semaphore okToO = new Semaphore(0);
Semaphore okToPOK = new Semaphore(0);
Semaphore okToQOK = new Semaphore(0);

Thread.start { // P
    print(" R ");
    okToI.release();
    okToPOK.acquire();
    print(" OK ");
}

Thread.start { // Q
    okToI.acquire();
    print(" I ");
    okToO.release();
    okToQOK.acquire();
    print(" OK ");
}

Thread.start { // R
    okToO.acquire();
    print(" O ");
    okToPOK.release();
    okToQOK.release();
    print(" OK ");
}