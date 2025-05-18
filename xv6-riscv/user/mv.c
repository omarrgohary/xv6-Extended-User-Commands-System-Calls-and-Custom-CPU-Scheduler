#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    if(argc != 3) {
        fprintf(2, "Usage: mv <source> <destination>\n");
        exit(1);
    }

    // Link the source file to the destination
    if(link(argv[1], argv[2]) < 0) {
        fprintf(2, "mv: failed to link %s to %s\n", argv[1], argv[2]);
        exit(1);
    }

    // Remove the original file (unlink it)
    if(unlink(argv[1]) < 0) {
        fprintf(2, "mv: failed to unlink %s\n", argv[1]);
        exit(1);
    }

    exit(0);
}
