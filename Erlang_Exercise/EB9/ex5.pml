// Peterson's Algo!
bool flag[2];
bool last;
byte critical = 0;

active [2] proctype user() {
  // last 一定要在flag[_pid] = true之後，如果先last卻沒表態
  // 讓另一人entern CS，這時last會是別人，但其實自己才是last那個，反而
  // 可以進去CS，此時兩人都在CS，mutex fails!
  // last = _pid;
  flag[_pid] = true;
  last = _pid;
  (flag[1 - _pid] == false || last == 1 -_pid);

  critical++;
  assert(critical == 1);
  critical--;

  flag[_pid] = false;
}