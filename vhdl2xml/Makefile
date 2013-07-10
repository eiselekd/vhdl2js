download-ghdl:
	rm -rf ghdl
	svn co -r150 svn://svn.gna.org/svn/ghdl/trunk ghdl
	cat ghdl-r150.diff | patch -p1 -d ghdl

download-gcc:
	-rm gcc-4.7.2.tar.gz
	wget ftp://ftp.gnu.org/gnu/gcc/gcc-4.7.2/gcc-4.7.2.tar.gz
	tar xvf gcc-4.7.2.tar.gz
	cat gcc-4.7.2.Darwin.diff | patch -p1 -d gcc-4.7.2

prepare-ghdl:
	-rm -rf ghdl-0.30dev
	cd ghdl/translate/gcc; ./dist.sh sources;cp ghdl-0.30dev.tar.bz2 $(CURDIR)
	tar xvf ghdl-0.30dev.tar.bz2
	-rm -rf gcc-4.7.2/gcc/vhdl
	cp -r ghdl-0.30dev/vhdl gcc-4.7.2/gcc/
