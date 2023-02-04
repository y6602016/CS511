import java.util.concurrent.Semaphore
Semaphore okToAS = new Semaphore(0);
Semaphore okToER = new Semaphore(0);

Thread.start { // P
    okToAS.acquire();
    print("A");
    print("S");
    okToER.release();
}

Thread.start { // Q
    print("L");
    okToAS.release();
    okToER.acquire();
    print("E");
    print("R";
}