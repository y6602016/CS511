
// Quiz 4
// 23 Feb 2023
// One-time-use barrier

// Name 1: Qi-Rui Hong
// Name 2:

class Barrier {
    int size
    int arrival = 0

    Barrier(int size) {
	    this.size=size
    }

    public synchronized void reached(){
        arrival++
        while (arrival < size){
            wait()
        }
        notifyAll() // or using notify() for cascading signling
    }
    
}

Barrier b = new Barrier(3)

Thread.start {// P
    println "1"
    b.reached()
    println "a"
}

Thread.start {// Q
    println "2"
    b.reached()
    println "b"
}

Thread.start {// R
    println "3"
    b.reached()
    println "c"
}
