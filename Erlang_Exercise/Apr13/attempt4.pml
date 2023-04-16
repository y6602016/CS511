bool wantP = false;
bool wantQ = false;
byte critical = 0;

active proctype P() {
  do 
    :: wantP = true;
    do
      :: wantQ -> wantP = false; wantP = true;
      :: else -> break
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
      :: wantP -> wantQ = false; wantQ = true;
      :: else -> break
    od;
    // critical ++;
    // assert(critical == 1);
    // critical --;
progress2:
    wantQ = false;
  od
}