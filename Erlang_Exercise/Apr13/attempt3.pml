bool wantP = false;
bool wantQ = false;
byte critical = 0;

active proctype P() {
  do 
    :: wantP = true;
    do
      :: wantQ == false -> break
      :: else
    od;
    // critical ++;
    // assert(critical == 1);
    // critical --;
progress1:
    wantP = false;
  od
}

active proctype Q() {
  do 
    :: wantQ = true;
    do
      :: wantP == false -> break
      :: else
    od;
    // critical ++;
    // assert(critical == 1);
    // critical --;
progress2:
    wantQ = false;
  od
}