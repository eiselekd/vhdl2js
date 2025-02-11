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


#################################################################
# gcc-6 doesnt work with 4.7 ada. Therefore run inside container:
# lxc-create -t download -n compile1 -- -d ubuntu -r precise -a amd64
#  - apt-get install git subversion wget libgmp-dev libmpfr-dev libmpc-dev gcc-multilib
#  - apt-get build-dep gcc
#################################################################

prep: gmp mpfr mpc

gmp:
	apt-get source libgmp-dev;
	cd gmp-5.0.2+dfsg/; ./configure --disable-shared --enable-static --prefix=$(HOME)/bin; make; make install

mpfr:
	apt-get source libmpfr-dev;
	cd mpfr4-3.1.0/; ./configure --disable-shared  --enable-static --with-gmp=$(HOME)/bin --prefix=$(HOME)/bin; make; make install

mpc:
	apt-get source libmpc-dev;
	cd mpclib-0.9/; ./configure --disable-shared  --enable-static --with-gmp=$(HOME)/bin --prefix=$(HOME)/bin --with-mpfr=$(HOME)/bin; make; make install

libiconv:
	wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.11.tar.gz
	tar xvf libiconv-1.11.tar.gz;
	cd libiconv-1.11; ./configure --prefix=/usr; make ; make install

conf:
	mkdir -p gcc-4.7.2-build;
	rm -rf /opt/gcc-4.7.2-ghdl
	rm -rf $(CURDIR)/sysroot/usr; mkdir -p $(CURDIR)/sysroot/usr 
	ln -sf /usr/lib/x86_64-linux-gnu $(CURDIR)/sysroot/usr/lib
	cp -r /usr/include $(CURDIR)/sysroot/usr/include
	export PATH=$(HOME)/bin-texinfo:/opt/gcc-4.7.2/bin:$$PATH; \
        cd gcc-4.7.2-build; ../gcc-4.7.2/configure \
           --prefix=/opt/gcc-4.7.2-ghdl \
           --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu \
           --disable-nls --enable-languages=c,ada,vhdl \
           --with-gmp=$(HOME)/bin  \
           --with-mpfr=$(HOME)/bin  \
           --enable-static \
           --disable-shared \
           --disable-bootstrap \
           --disable-multilib \
	   --with-sysroot=$(CURDIR)/sysroot

#--enable-multiarch


build:
	export PATH=$(HOME)/bin-texinfo:/opt/gcc-4.7.2-ghdl/bin:$$PATH; \
        cd gcc-4.7.2-build; \
	make; make install

dist:
	mkdir -p $(HOME)/dist
	cd $(HOME)/dist; ln -sf $(CURDIR)/gcc-4.7.2-build gcc-4.7.2-objs 
	cd $(HOME)/dist; ln -sf $(CURDIR)/gcc-4.7.2 gcc-4.7.2 


.PHONY: ghdl

ghdl:
	cd ghdl/translate; make BE=gcc
	cd ghdl/translate/ghdldrv; make ghdl_gcc; ln -sf ghdl_gcc ghdl; make install.all
	ghdl/translate/ghdldrv/ghdl_gcc --xml -fexplicit --ieee=synopsys   -o $(HOME)/src/ghdl-out $(HOME)/src/ghdl-var.vhd

ghdl-r:
	cd ghdl/translate; make BE=gcc
	cd ghdl/translate/ghdldrv; make ghdl_gcc; ln -sf ghdl_gcc ghdl; make install.all
	cd ghdl/translate/grt; make
	cd ghdl/translate/lib; \
	ln -sf ../grt/grt.lst . ; ln -sf ../grt/libgrt.a .;

ghdl-p:
	cd ghdl/translate; make BE=gcc
	cd ghdl/translate/ghdldrv; make ghdl_gcc;
