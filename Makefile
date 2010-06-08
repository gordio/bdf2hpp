.PHONY: all
all: parse_bdf

parse_bdf: scan_bdf.c parse_bdf.c
	gcc -o $@ $^

%.c: %.l
	flex -o$@ $? 

%.c: %.y
	bison -o $@ -d $?

scan_bdf.c: scan_bdf.l
parse_bdf.c: parse_bdf.y


.PHONY: clean
clean:
	$(RM) *.c *.h *.exe
