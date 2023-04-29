byte turn;
bool flags[3];

proctype P(){
  byte myId = _pid - 1;
  byte left = (myId + 2) % 3;
  byte right = (myId + 1) % 3;
  flags[myId] = true;
  do
    ::(flags[left] || flags[right]) ->
      if  
        ::(turn == left) ->
          flags[myId] = false;
          turn == myId -> break;
          flags[myId] = true;
        :: else -> skip;
      fi
    :: else -> break;
  od
  // CS
  turn = right;
  flags[myId] = false;
}

init{
  turn = 0;
  byte i;

  for(i:0..2){
    flags[i] = false;
  }

  atomic{
    for(i:0..2){
      run P();
    }
  }
}