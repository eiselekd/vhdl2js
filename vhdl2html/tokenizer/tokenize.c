#include "libvhdltok.h"

int main(int argc, char **argv) {
  Vhdltok_Init_Static();
  Vhdltok_Init();
  if (argc == 2) {
    Vhdltok_Scan("./", argv[1]);
  }
  return 0;
}
