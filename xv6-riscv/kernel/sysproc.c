#include "types.h"
#include "syscall.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

extern uint64 global_turnaround_time;
extern uint64 global_waiting_time;
extern int total_benchmark_processes;
extern int completed_benchmark_processes;




// At the top of sysproc.c, add this declaration:
//int wait_stat(int *status, struct perf *pstats) {
  //return wait_stat_internal(status, pstats);  // Call the internal helper
//}


extern struct proc proc[NPROC];

// Required if not already declared
extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

struct perf {
  uint64 ctime;
  uint64 completetime;
  uint64 rtime;
  uint64 turnaround_time;
  uint64 waiting_time;
};


uint64
sys_schedstats(void) {
  int mode;
  if (argint(0, &mode) < 0)
      return -1;
  if (mode < 0 || mode > 2)
      return -1;

  sched_mode = mode; 

global_turnaround_time = 0;
global_waiting_time = 0;
total_benchmark_processes = 0;
completed_benchmark_processes = 0;


  

  if (sched_mode == SCHED_ROUND_ROBIN)
  {
    printf("Scheduler mode set to: Round Robin\n");
  }

  else if (sched_mode == SCHED_FCFS)
  {
    printf("Scheduler mode set to: FCFS\n");
  }
  else if (sched_mode == SCHED_PRIORITY)
  {
    printf("Scheduler mode set to: Priority\n");
  }
  else
  {
    printf("Unknown scheduler mode!\n");
  }
  return 0;
}


uint64
sys_wait_stat(void)
{
  uint64 status_addr, perf_addr;
  struct perf p;

  if (argaddr(0, &status_addr) < 0 || argaddr(1, &perf_addr) < 0)
    return -1;

  int status;
  int ret = wait_stat_internal(&status, &p);  // helper below
  if (ret < 0)
    return -1;

  // Copy status and perf to user space
  if (copyout(myproc()->pagetable, status_addr, (char*)&status, sizeof(status)) < 0)
    return -1;
  if (copyout(myproc()->pagetable, perf_addr, (char*)&p, sizeof(p)) < 0)
    return -1;

  return ret;
}


extern int getptable(int n, uint64 addr);

uint64
sys_getptable(void)
{
  int n;
  uint64 addr;

  if(argint(0, &n) < 0 || argaddr(1, &addr) < 0)
    return 0;

  return getptable(n, addr);
}

uint64
sys_getppid(void)
{
  return myproc()->parent->pid;
}

uint64
sys_setpriority(void)
{
  int pid, priority;
  if (argint(0, &pid) < 0 || argint(1, &priority) < 0)
    return -1;

  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->pid == pid) {
      p->priority = priority;
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1; // PID not found
}


uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
