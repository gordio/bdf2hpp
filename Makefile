scan_bdf: scan_bdf.c
	gcc -o $@ $? -lfl

%.c: %.l
	flex -o$@ $? 
