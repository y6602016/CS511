byte wantP = false;
byte wantQ = false;
byte turn = 1;
byte cs = 0;

active proctype P() {
  do
    :: wantP = true;
    do
      :: !wantQ -> break;
      :: else ->
        if
          :: (turn == 2) ->
            wantP = false;
            do
            :: turn == 1 -> break
            :: else 
            od;
            wantP = true;
          :: else
        fi
    od;
    // cs++;
    // assert(cs == 1);
    // cs--;
progress1:
    turn = 2;
    wantP = false;
  od;
}

active proctype Q() {
  do
    :: wantQ = true;
    do
      :: !wantP -> break;
      :: else ->
        if
          ::(turn == 1) ->
            wantQ = false;
            do
              :: turn == 2 -> break;
              :: else
            od;
            wantQ = true;
          :: else
        fi
    od;
    // cs++;
    // assert(cs == 1);
    // cs--;
progress2:
    turn = 1;
    wantQ = false;
  od;
}