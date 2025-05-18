#include "kernel/types.h"
#include "user/user.h"

int main() {
  for (int i = 0; i < 1; i++) {
    printf("Random number %d: %d\n", i + 1, sysrand());
  }

  exit(0);
}
