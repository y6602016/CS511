bool wantP = false;
bool wantQ = false;
byte critical = 0;

active proctype P() {
  do 
    :: wantP = true;
    wantQ == false;
    wantP = false;
  od
}

active proctype Q() {
  do 
    :: wantQ = true;
    wantP == false;
    wantQ = false;
  od
}