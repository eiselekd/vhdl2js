all:

lib-static:
	-rm *.o lib
	mkdir -p lib
	gnatmake -Plibvhdltok.gpr -v

LIBGNAT=$(shell gnatls -v | perl libgnat.pl)

test-static: lib-static
	gcc -g tokenize.c -o lib/tokenize.exe lib/libvhdltok.a $(LIBGNAT)/libgnat.a 

run-static:
	lib/tokenize.exe e1.vhd

lib-shared:
	-rm *.o lib
	mkdir -p lib
	gnatmake -Plibvhdltok_shared.gpr -v

test-shared: lib-shared
	gcc -g tokenize_shared.c -o lib/tokenize_shared.exe -Llib -lvhdltok $(if $(findstring Darwin,$(shell uname)),,-lgnat)
#-lgnat

#	gnatmake -c libvhdltok.adb
#	gcc -shared -o libvhdltok.so *.o

run-shared:
	DYLD_LIBRARY_PATH=$(CURDIR)/lib:/opt/gcc-4.7.2-ghdl/lib/gcc/x86_64-apple-darwin11.4.2/4.7.2/adalib lib/tokenize_shared.exe

.PHONY: lib test



gdb:
	DYLD_LIBRARY_PATH=$(CURDIR)/lib:/opt/gcc-4.7.2-ghdl/lib/gcc/x86_64-apple-darwin11.4.2/4.7.2/adalib gdb --args lib/tokenize.exe


info:
	gnatls -v
	gnatls -v | perl libgnat.pl
	otool -L lib/test.exe

clean:
	-rm -rf *.ali *.o lib
