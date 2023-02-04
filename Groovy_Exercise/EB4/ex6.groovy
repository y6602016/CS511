import java.util.concurrent.Semaphore
Semaphore okToC = new Semaphore(0);

Thread.start{ //A
  print("A"); //opA
  okToC.release();
}

Thread.start{ //B
  print("B"); //opB
  okToC.release();
}

Thread.start{ //C
  okToC.acquire();
  okToC.acquire();
  print("C"); //opC
}