byte s = 1;
active proctype A() {
  s == 1 -> s++;
}

active proctype B() {
  s == 1 -> s--;
}