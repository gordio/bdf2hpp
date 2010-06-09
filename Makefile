.PHONY: all
all: dump_bdf mplus2hpp

mplus2hpp: scan_bdf.c parse_bdf.c bdf.c mplus2hpp.c
	gcc -o $@ $^

dump_bdf: scan_bdf.c parse_bdf.c bdf.c dump_bdf.c
	gcc -o $@ $^

%.c: %.l
	flex -o$@ $? 

%.c: %.y
	bison -o $@ -d $?

scan_bdf.c: scan_bdf.l
parse_bdf.c: parse_bdf.y

.PHONY: clean
clean:
	$(RM) scan_bdf.c parse_bdf.c *.exe
