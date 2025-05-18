#include "kernel/types.h"
#include "user/user.h"

#define MAX_PROC 64

int
main()
{
  struct proc_info ptable[MAX_PROC];

  if(getptable(MAX_PROC, (struct proc_info*) ptable)) {
    printf("PID\tPPID\tSTATE\tNAME\t\tSIZE\n");
    for(int i = 0; i < MAX_PROC; i++) {
      if(ptable[i].pid != 0) {
        printf("%d\t%d\t%d\t%s\t\t%lu\n",
          ptable[i].pid,
          ptable[i].ppid,
          ptable[i].state,
          ptable[i].name,
          ptable[i].sz);
      }
    }
  }

  else
  {
    printf("getptable system call failed.\n");
  }

  exit(0);
}
