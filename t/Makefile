GHDL ?= ghdl 

SRC = 		\
	e1.vhd 	\
	top.vhd

all:

compile:
	mkdir -p gnu/work
	$(GHDL) -a --workdir=gnu/work --work=work e1.vhd
	$(GHDL) -a --workdir=gnu/work --work=work top.vhd

clean:
	rm -rf gnu
