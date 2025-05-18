#include "kernel/types.h"
#include "kernel/datetime.h"
#include "user/user.h"

int main() {
  struct rtcdate r;

  // Directly pass the address of the rtcdate struct to the datetime syscall
  if (datetime(&r) == 0)
  {
    printf("Current date and time: %d-%d-%d %d:%d:%d\n",  r.year, r.month, r.day, r.hour, r.minute, r.second);
  }
  else
  {
    printf("datetime syscall failed\n");
  }

  exit(0);
}
