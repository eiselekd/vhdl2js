# requires patched ghdl with --xml command, subdirectory vhdl2xml
GHDL-XML ?= ghdl 

SRC = \
	e1.vhd 	\
	top.vhd

all:

# requires patched ghdl with --xml command, subdirectory vhdl2xml
xml: compile
	$(GHDL-XML) --xml --workdir=gnu/work --work=work e1.vhd   > e1.vhd.xml
	$(GHDL-XML) --xml --workdir=gnu/work --work=work top.vhd  > top.vhd.xml

js: xml
	perl ../xml2js/hdl2js.pl e1.vhd.xml -o e1.vhd.js   
	perl ../xml2js/hdl2js.pl top.vhd.xml -o top.vhd.js 
	# try to beautify
	-js-beautify e1.vhd.js  > e1.vhd.b.js
	-js-beautify top.vhd.js > top.vhd.b.js

html: js
	perl ../vhdl2html/hdl2html.pl --ast=e1.vhd.b.js  -o e1.vhd.html  e1.vhd
	perl ../vhdl2html/hdl2html.pl --ast=top.vhd.b.js -o top.vhd.html top.vhd

compile:
	mkdir -p gnu/work
	$(GHDL-XML) -a --workdir=gnu/work --work=work e1.vhd
	$(GHDL-XML) -a --workdir=gnu/work --work=work top.vhd

clean:
	rm -rf gnu
