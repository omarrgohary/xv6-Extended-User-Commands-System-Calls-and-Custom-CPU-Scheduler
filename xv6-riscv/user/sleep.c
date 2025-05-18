#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main(int argc, char* argv[])
{
  int n1 = atoi(argv[1]);
  sleep(n1);
  exit(0);

}
