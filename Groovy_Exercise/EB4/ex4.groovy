import java.util.concurrent.Semaphore
Semaphore mutex = new Semaphore(0);
Semaphore canPrint = new Semaphore(0);

int y = 0, z = 0;

// possible value set = {1, 3}
Thread.start { // P
    int x;
    mutex.acquire(); // excluding the value 0
    x = y + z;
    print(x);
}

Thread.start { // Q
    y = 1;
    mutex.release();
    z = 2;
}


// possible value set = {0, 1}
Thread.start { // P
    int x;
    x = y + z;
    mutex.release();
    print(x);
}

Thread.start { // Q
    y = 1;
    mutex.acquire(); // excluding the value 3
    z = 2;
}
