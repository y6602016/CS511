bool wantP = false;
bool wantQ = false;
byte turn = 1;

active proctype P() {
  do
    ::wantP = true;
      do
        :: wantQ ->
          if 
            ::turn == 2 ->
              wantP = false;
              do
                :: turn == 1 -> break
                :: else
              od
              wantP = true;
            ::else -> skip
          fi
        :: else -> break
      od
      turn = 2;
      wantP = false;
  od
}