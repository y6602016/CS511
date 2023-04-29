byte s = 1;
active proctype A() {
  atomic{
    s == 1 -> s++;
  }
}

active proctype B() {
  atomic{
    s == 1 -> s--;
  }
}