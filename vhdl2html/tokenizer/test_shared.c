#include "libvhdltok.h"

int main(int argc, char **argv) {
  /*Vhdltok_Init_Static();*/
  Vhdltok_Init();
  Vhdltok_Scan();
  return 0;
}