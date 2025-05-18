#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main(int argc, char *argv[]) {
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  int found = 0;  // Flag to stop searching once the file is found

  if (argc != 3) {
    exit(1);  // Exit if incorrect number of arguments
  }

  fd = open(argv[1], 0);
  if(fd < 0){
    exit(0);  // Exit if failed to open directory
  }

  fstat(fd, &st);

  if(st.type == T_FILE){
    if(strcmp(argv[1], argv[2]) == 0){
      printf("%s\n", argv[1]);  // Print the file path if file is found
      found = 1;  // Set the flag when file is found
    }
  }

  if(st.type == T_DIR && !found) {  // Only search directories if file is not found
    strcpy(buf, argv[1]);
    p = buf + strlen(buf);
    *p++ = '/';

    while(read(fd, &de, sizeof(de)) == sizeof(de)) {
      if(de.inum == 0)
        continue;
      if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;

      int fd2 = open(buf, 0);
      if(fd2 < 0) {
        continue;
      }

      fstat(fd2, &st);
      close(fd2);

      if (st.type == T_FILE && strcmp(de.name, argv[2]) == 0) {
        printf("%s\n", buf);  // Print file path once found
        found = 1;
        break;  // Exit loop as the file is found
      }

      char *argv_new[] = { argv[0], buf, argv[2] };
      if(fork() == 0){
        exec(argv[0], argv_new);
      } else {
        wait(0);
      }
    }
  }

  close(fd);
  if (!found) {
    exit(0);  // Exit if file is not found
  }

  exit(0);
}
