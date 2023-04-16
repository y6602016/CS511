bool wantP = false;
bool wantQ = false;

active proctype P(){
  do
    :: wantP = true;
    do
      :: wantQ -> 
        wantP = false;
        wantP = true;
      :: else -> break
    od;
progress1:
    wantP = false;
  od;
}

active proctype Q(){
  do
    :: wantQ = true;
    do
      :: wantP -> 
        wantQ = false;
        wantQ = true;
      :: else -> break
    od;
progress2:
    wantQ = false;
  od;
}