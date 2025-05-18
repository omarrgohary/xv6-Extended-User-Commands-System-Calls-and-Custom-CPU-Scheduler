#include "kernel/types.h"
#include "user/user.h"

int main() {
  int ppid = getppid();
  int pid = getpid();
  printf("My PID: %d, My PPID: %d\n", pid, ppid);
  exit(0);
}
