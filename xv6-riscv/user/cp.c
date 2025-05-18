#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

char buf[512];

int main(int argc, char *argv[]) {
  int src, dst, n;

  if (argc != 3) {
    fprintf(2, "Usage: cp <source> <destination>\n");
    exit(1);
  }

  src = open(argv[1], O_RDONLY);
  if (src < 0) {
    fprintf(2, "cp: cannot open %s\n", argv[1]);
    exit(1);
  }

  dst = open(argv[2], O_CREATE | O_WRONLY);
  if (dst < 0) {
    fprintf(2, "cp: cannot create %s\n", argv[2]);
    close(src);
    exit(1);
  }

  while ((n = read(src, buf, sizeof(buf))) > 0) {
    if (write(dst, buf, n) != n) {
      fprintf(2, "cp: write error\n");
      close(src);
      close(dst);
      exit(1);
    }
  }

  close(src);
  close(dst);
  exit(0);
}
