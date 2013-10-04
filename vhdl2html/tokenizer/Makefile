all:

lib-static:
	-rm *.o lib
	mkdir -p lib
	gnatmake -Plibvhdltok.gpr -v

test-static: lib-static
	gcc -g test.c -o lib/test.exe lib/libvhdltok.a /opt/gcc-4.7.2-ghdl/lib/gcc/x86_64-apple-darwin11.4.2/4.7.2/adalib/libgnat.a 

run-static:
	lib/test.exe

lib-shared:
	-rm *.o lib
	mkdir -p lib
	gnatmake -Plibvhdltok_shared.gpr -v

test-shared: lib-shared
	gcc -g test_shared.c -o lib/test.exe -Llib -lvhdltok 
#-lgnat

#	gnatmake -c libvhdltok.adb
#	gcc -shared -o libvhdltok.so *.o

run-shared:
	DYLD_LIBRARY_PATH=$(CURDIR)/lib:/opt/gcc-4.7.2-ghdl/lib/gcc/x86_64-apple-darwin11.4.2/4.7.2/adalib lib/test.exe

.PHONY: lib test




gdb:
	DYLD_LIBRARY_PATH=$(CURDIR)/lib:/opt/gcc-4.7.2-ghdl/lib/gcc/x86_64-apple-darwin11.4.2/4.7.2/adalib gdb --args lib/test.exe


info:
	gnatls -v
	otool -L lib/test.exe

clean:
	-rm -rf *.ali *.o lib
