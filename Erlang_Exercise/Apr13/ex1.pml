active proctype P() {
  byte n = 10;
  byte sum = 0;
  byte i = 1;
  do
    :: i > n -> break
    :: else  -> 
      sum = sum + i;
      i++
  od;
  printf("The sum of the first %d numbers = %d\n",  n, sum);
}

