byte x = 0;

active proctype P(){
  do
    ::if
      :: x < 200 -> x++;
      :: else -> skip
      fi
  atomic{
    assert(0 <= x);
    assert(x <= 200);
  }
  od;
}

active proctype Q(){
  do
    ::if
      :: x > 0 -> // 1. when x == 200, enter the statement
        x--; // 4. x -= 1  ----> x = 0 - 1 = -1
      :: else -> skip
      fi
  atomic{
    assert(0 <= x);
    assert(x <= 200);
  }
  od;
}

active proctype R(){
  do
    ::if
      :: x == 200 -> // 2. when x == 200, enter the statement
        x = 0; // 3. x = 0
      :: else -> skip
      fi
  atomic{
    assert(0 <= x);
    assert(x <= 200);
  }
  od;
}