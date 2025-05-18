#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"


#define BUF_SIZE 10
#define MAX_PROCS 20

struct perf {
  uint64 ctime;
  uint64 completetime;
  uint64 rtime;
  uint64 turnaround_time;
  uint64 waiting_time;
};

int main() {
  int pid, i;
  int n = 5;
  char buf[BUF_SIZE];
  int mode = 1;  // Default to FCFS


  printf("Select scheduler mode:\n");
  printf("0 - Round Robin\n");
  printf("1 - FCFS (First Come First Serve)\n");
  printf("2 - Priority-based\n");

  if (read(0, buf, BUF_SIZE) > 0) {
    mode = buf[0] - '0';
    if (mode >= 0 && mode <= 2) {
      schedstats(mode);
    } else {
      printf("Invalid scheduler mode selected. Using default FCFS.\n");
      schedstats(mode);  // mode already = 1
    }
  }

  for (i = 0; i < n; i++) {
    pid = fork();
    if (pid == 0) {
      if (mode == 2) { // Only for Priority scheduling
        int prio = 20 - i;
        setpriority(getpid(), prio);
        printf("Child %d started with priority %d\n", getpid(), prio);
      } else {
        printf("Child %d started\n", getpid());
      }

      if (i == 0)
        for (volatile int j = 0; j < 800000000; j++);
      else
        for (volatile int j = 0; j < 200000000; j++);

      printf("Child %d done\n", getpid());
      exit(0);
    }
  }
  

  //struct perf p;
  //uint64 total_turnaround = 0;
  //int status;

  //for (i = 0; i < n; i++) {
   // wait_stat(&status, &p);
   // total_turnaround += p.turnaround_time;
 // }

//  printf("Average turnaround time: %lu ticks\n", total_turnaround / n);

  exit(0);
}
