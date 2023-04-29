byte c = 0;

proctype P() {
  c++
}

init{
  atomic{
    run P();
    run P();
  }
  if
  ::_nr_pr == 1 -> printf("c = %d\n", c)
  fi
  // _nr_pr == 1;
  printf("c = %d\n", c)
}