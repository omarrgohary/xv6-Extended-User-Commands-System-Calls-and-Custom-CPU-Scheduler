#include "kernel/types.h"
#include "user/user.h"

// Simple string-to-integer validation
int is_positive_number(char *s) {
  for (int i = 0; s[i] != 0; i++) {
    if (s[i] < '0' || s[i] > '9')
      return 0;
  }
  return 1;
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(2, "Usage: fact <non-negative integer>\n");
    exit(1);
  }

  if (!is_positive_number(argv[1])) {
    fprintf(2, "fact: please enter a non-negative integer\n");
    exit(1);
  }

  int n = atoi(argv[1]);
  int result = 1;
  for (int i = 2; i <= n; i++) {
    result *= i;
  }

  printf("Factorial of %d is %d\n", n, result);
  exit(0);
}
