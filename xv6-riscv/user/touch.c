#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main(int argc, char *argv[]) {
  if(argc != 2) {
    printf("Usage: touch <filename>\n");
    exit(1);
  }

  // Check if the file already exists
  int fd = open(argv[1], O_RDONLY);
  if(fd >= 0) {
    // File exists, raise error
    printf("Error: file '%s' already exists\n", argv[1]);
    close(fd);
    exit(1);
  }

  // File does not exist, create it
  fd = open(argv[1], O_CREATE | O_WRONLY);
  if(fd < 0) {
    // Error in creating the file
    printf("Error: could not create file '%s'\n", argv[1]);
    exit(1);
  }

  // Successfully created an empty file, close it
  close(fd);
  exit(0);
}
