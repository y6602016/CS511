// Qi-Rui Hong - 10475677

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Semaphore;
import java.util.concurrent.CountDownLatch;

public class Bakery implements Runnable {
    private static final int TOTAL_CUSTOMERS = 20; // 200
    private static final int CAPACITY = 50;// 50
    private static final int FULL_BREAD = 20;// 20
    private Map<BreadType, Integer> availableBread;
    private ExecutorService executor;
    private float sales = 0;
    private CountDownLatch doneSignal = new CountDownLatch(TOTAL_CUSTOMERS);
    // TODO
    // 1. create 3 strong Semaphores for 3 types bread shelves
    public static Semaphore breadRYEShelves = new Semaphore(1, true);
    public static Semaphore breadSOURDOUGHShelves = new Semaphore(1, true);
    public static Semaphore breadWONDERShelves = new Semaphore(1, true);
    // 2. create a strong Semaphore with 4 initial permits for cashiers
    public static Semaphore cashiers = new Semaphore(4, true);
    // 3. create a strong Semaphore for one cashier to add sales
    public static Semaphore addToSales = new Semaphore(1, true);

    /**
     * Remove a loaf from the available breads and restock if necessary
     */
    public void takeBread(BreadType bread) {
        int breadLeft = availableBread.get(bread);
        if (breadLeft > 0) {
            availableBread.put(bread, breadLeft - 1);
        } else {
            System.out.println("No " + bread.toString() + " bread left! Restocking...");
            // restock by preventing access to the bread stand for some time
            try {
                Thread.sleep(1000);
            } catch (InterruptedException ie) {
                ie.printStackTrace();
            }
            availableBread.put(bread, FULL_BREAD - 1);
        }
    }

    /**
     * Add to the total sales
     */
    public void addSales(float value) {
        sales += value;
    }

    /**
     * Run all customers in a fixed thread pool
     */
    public void run() {
        availableBread = new ConcurrentHashMap<BreadType, Integer>();
        availableBread.put(BreadType.RYE, FULL_BREAD);
        availableBread.put(BreadType.SOURDOUGH, FULL_BREAD);
        availableBread.put(BreadType.WONDER, FULL_BREAD);

        // TODO
        executor = Executors.newFixedThreadPool(CAPACITY);

        for (int i = 0; i < TOTAL_CUSTOMERS; i++) {
            executor.execute(new Customer(this, doneSignal));
        }

        try {
            doneSignal.await();
            System.out.printf("Total sales = %.2f\n", sales);
            executor.shutdown();
        } catch (InterruptedException ie) {
            ie.printStackTrace();
        }
    }
}
