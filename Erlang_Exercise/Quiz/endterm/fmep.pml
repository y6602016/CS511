// Qi-Rui Hong
// I pledge my honor that I have abided bu the Steven Honor
byte turn = 0;
bool flag[2];

proctype P(byte me){
  do
    ::flag[me] = true;
      do
        ::turn == me -> break;
        :: else -> 
          do
            :: flag[1 - me] == false -> break;
            :: else
          od
          turn = me;
      od
      printf("%d went in\n", me);
      // CS
      flag[me] = false;
      printf("%d went out\n", me);
  od
}

proctype Q(byte me){
  do
    ::flag[me] = true;
      do
        ::turn == me -> break;
        :: else -> 
          do
            :: flag[1 - me] == false -> break;
            :: else
          od
          turn = me;
      od
      printf("%d went in\n", me);
      // CS
      flag[me] = false;
      printf("%d went out\n", me);
  od
}

init{
  byte i = 0;
  for(i:0..1){
    flag[i] = false;
  }

  atomic{
    run P(0);
    run Q(1);
  }
}
