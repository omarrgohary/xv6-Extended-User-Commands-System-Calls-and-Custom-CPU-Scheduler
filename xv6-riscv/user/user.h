
#define SCHED_ROUND_ROBIN  0
#define SCHED_FCFS         1
#define SCHED_PRIORITY     2
typedef unsigned int   uint;
typedef unsigned long  uint64;

struct stat;

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int setpriority(int pid, int priority);
int close(int);
int kill(int);
int exec(const char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int kbdint(void);
int countsyscall(void);
int getppid(void);
int sysrand(void);
int schedstats(int mode);  // replaces set_sched_mode
int wait_stat();


struct rtcdate;
int datetime(struct rtcdate *);

struct proc_info {
  int pid;
  int ppid;
  int state;
  char name[16];
  uint64 sz;
};

int getptable(int, struct proc_info*);

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...) __attribute__ ((format (printf, 2, 3)));
void printf(const char*, ...) __attribute__ ((format (printf, 1, 2)));
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
int atoi(const char*);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);

// umalloc.c
void* malloc(uint);
void free(void*);
