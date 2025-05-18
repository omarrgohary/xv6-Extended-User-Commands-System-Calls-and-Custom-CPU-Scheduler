#include "types.h"
#include "riscv.h"
#include "datetime.h"
#include "proc.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"

#define MTIME_FREQ  10100000 // 10 million ticks/sec (QEMU default)
#define TIMEZONE_OFFSET 3 * 3600   // 3 hours in seconds

void convert_unix_time_to_rtcdate(uint64 unix_time, struct rtcdate *r);


extern int kbd_intr_count;
uint64
sys_kbdint(void)
{
  return kbd_intr_count;
}


extern int syscall_counter;

uint64
sys_countsyscall(void)
{
  return syscall_counter;
}

// extern uint64 BOOT_EPOCH;

uint64
sys_datetime(void)
{
  uint64 user_dst;
  struct rtcdate r;

  if (argaddr(0, &user_dst) < 0)
    return -1;

  uint64 ticks = *(volatile uint64*)CLINT_MTIME;
  uint64 seconds = ticks / MTIME_FREQ;

  // Convert seconds to UNIX time
  uint64 now = BOOT_EPOCH + seconds + TIMEZONE_OFFSET;
  convert_unix_time_to_rtcdate(now, &r);

  if (user_dst < USERBASE || user_dst >= USERTOP) {
    return -1;  // Invalid user address (outside of user space range)
  }
  // Copy to user space
  if (copyout(myproc()->pagetable, user_dst, (char*)&r, sizeof(r)) < 0)
    return -1;

  return 0;
}
void convert_unix_time_to_rtcdate(uint64 unix_time, struct rtcdate *r) {
  // Seconds in time units
  int days_in_month[] = {31,28,31,30,31,30,31,31,30,31,30,31};
  int year = 1970;
  int month, day;
  int days = unix_time / 86400;
  int secs_remaining = unix_time % 86400;

  // Calculate current year
  while (1) {
    int leap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
    int days_in_year = leap ? 366 : 365;
    if (days >= days_in_year) {
      days -= days_in_year;
      year++;
    } else {
      break;
    }
  }

  // Handle leap year for current year
  int leap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
  if (leap)
    days_in_month[1] = 29;

  // Calculate month and day
  month = 0;
  while (days >= days_in_month[month]) {
    days -= days_in_month[month];
    month++;
  }
  day = days + 1;

  // Calculate hour, minute, second
  int hour = secs_remaining / 3600;
  secs_remaining %= 3600;
  int minute = secs_remaining / 60;
  int second = secs_remaining % 60;

  // Fill struct
  r->year = year;
  r->month = month + 1; // month is 0-indexed
  r->day = day;
  r->hour = hour;
  r->minute = minute;
  r->second = second;
}


static uint seed = 1; // default seed

uint64
sys_sysrand(void)
{
  // Optional: reseed occasionally using ticks for variability
  seed = seed * 1664525 + 1013904223;
  return seed;
}
