// similar to ex7-2, ABABAB..
import java.util.concurrent.Semaphore

Semaphore okToMinusN = new Semaphore(0);
Semaphore okToCalculate = new Semaphore(1);

int n2 = 0;
int n = 50;

P = Thread.start {
  while (n > 0) {
    okToMinusN.acquire();
    n = n - 1;
    okToCalculate.release();
  }
}

Thread.start {
  while (true) {
    okToCalculate.acquire();
    n2 = n2 + 2 * n + 1;
    okToMinusN.release();
  }
}

P.join()
// if your code prints 2600 you might need an extra line of code here ...
if (n2 == 2600) {okToCalculate.release();}
print(n2)