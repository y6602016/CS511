// Qi-Rui Hong - 10475677

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.concurrent.CountDownLatch;

public class Customer implements Runnable {
    private Bakery bakery;
    private Random rnd;
    private List<BreadType> shoppingCart;
    private int shopTime;
    private int checkoutTime;
    private CountDownLatch doneSignal;
    private static int[] breads = new int[3];

    /**
     * Initialize a customer object and randomize its shopping cart
     */
    public Customer(Bakery bakery, CountDownLatch l) {
        // TODO
        // call fillShoppingCart() to randomize the cart with the desired breads
        this.bakery = bakery;
        this.doneSignal = l;
        this.rnd = new Random();
        this.shoppingCart = new ArrayList<BreadType>();
        this.shopTime = 1 + rnd.nextInt(1000);
        this.checkoutTime = 1 + rnd.nextInt(1000);
        this.fillShoppingCart();
        System.out.println("Number of breads [RYE, SOURDOUGH, WONDER]:" + Arrays.toString(this.breads));
        System.out.printf("Expected sales: %.2f\n",
                (this.breads[0] * 3.99 + this.breads[1] * 4.99 + this.breads[2] * 5.99));
    }

    /**
     * Run tasks for the customer
     */
    public void run() {
        // TODO
        // Based on the bread type to use the corresponding Semaphores to take the
        // bread by calling takeBread()
        for (BreadType breadType : shoppingCart) {
            switch (breadType) {
                case RYE:
                    try {
                        this.bakery.breadRYEShelves.acquire();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    break;
                case SOURDOUGH:
                    try {
                        this.bakery.breadSOURDOUGHShelves.acquire();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    break;
                case WONDER:
                    try {
                        this.bakery.breadWONDERShelves.acquire();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    break;
            }

            // shoptime
            try {
                Thread.sleep(shopTime);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            this.bakery.takeBread(breadType);

            switch (breadType) {
                case RYE:
                    this.bakery.breadRYEShelves.release();
                    break;
                case SOURDOUGH:
                    this.bakery.breadSOURDOUGHShelves.release();
                    break;
                case WONDER:
                    this.bakery.breadWONDERShelves.release();
                    break;
            }
        }

        // Using the Cashier Semaphore
        try {
            this.bakery.cashiers.acquire();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // Calling getItemsValue() to get total cost
        float total = getItemsValue();

        // Using the addSales Semaphore
        try {
            this.bakery.addToSales.acquire();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // add sales
        this.bakery.addSales(total);

        // checkout time
        try {
            Thread.sleep(checkoutTime);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        this.bakery.addToSales.release();
        this.bakery.cashiers.release();

        // Sending signal to doneSignal.countDown() to end the task
        try {
            this.doneSignal.countDown();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Return a string representation of the customer
     */
    public String toString() {
        return "Customer " + hashCode() + ": shoppingCart=" + Arrays.toString(shoppingCart.toArray()) + ", shopTime="
                + shopTime + ", checkoutTime=" + checkoutTime;
    }

    /**
     * Add a bread item to the customer's shopping cart
     */
    private boolean addItem(BreadType bread) {
        // do not allow more than 3 items, chooseItems() does not call more than 3 times
        if (shoppingCart.size() >= 3) {
            return false;
        }
        shoppingCart.add(bread);
        this.breads[BreadType.valueOf(bread.toString()).ordinal()]++;
        return true;
    }

    /**
     * Fill the customer's shopping cart with 1 to 3 random breads
     */
    private void fillShoppingCart() {
        int itemCnt = 1 + rnd.nextInt(3);
        while (itemCnt > 0) {
            addItem(BreadType.values()[rnd.nextInt(BreadType.values().length)]);
            itemCnt--;
        }
    }

    /**
     * Calculate the total value of the items in the customer's shopping cart
     */
    private float getItemsValue() {
        float value = 0;
        for (BreadType bread : shoppingCart) {
            value += bread.getPrice();
        }
        return value;
    }
}
