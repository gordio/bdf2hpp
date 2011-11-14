#include <stdio.h>
#include <stdlib.h>
#include "bdf.h"


int main(int argc, char* argv[]) {
	int i, x, y;
	BDFFont font;
	BDFFont_ctor(&font);
	if(BDFFont_parse(&font) == 0) {

		/*printf("FONT BBX: %d %d %d %d\n",*/
				/*font.bbx[0], font.bbx[1], font.bbx[2], font.bbx[3]);*/
		/*printf("NUMBER OF GLYPHS: %d\n", font.number_of_glyphs);*/

		int bit = 0;
		unsigned char mask = 0x01;
		for(i = 0; i < font.number_of_glyphs; ++i) {
			BDFGlyph* glyph = font.glyphs + i;
			printf("\t# %i %d \"%c\"\n", i, glyph->encoding, glyph->encoding);
			/*printf("--- encoding: %d ---\n", glyph->encoding);*/
			/*printf("dwidth: %d %d\n", glyph->dwidth[0], glyph->dwidth[1]);*/
			/*printf("bbx: %d %d %d %d\n",*/
					/*glyph->bbx[0], glyph->bbx[1], glyph->bbx[2], glyph->bbx[3]);*/
			for(y = 0; y < glyph->bbx[1]; ++y) {
				for(x = 0; x < glyph->pitch; ++x) {
					int index = glyph->pitch * y + x;
					printf("\t0x%02X,", *(glyph->bitmap + index));
					printf(" /* ");
					for(bit = 7;bit >= 0;bit--) {
						if ((mask << bit) & (unsigned char)*(glyph->bitmap + index)) {
							printf("1");
						} else {
							printf("0");
						}
					}
					printf(" */ ");
					printf(" /* ");
					for(bit = 7;bit >= 0;bit--) {
						if ((mask << bit) & (unsigned char)*(glyph->bitmap + index)) {
							printf("██");
						} else {
							printf("  ");
						}
					}
					printf(" */ ");
				}
				printf("\n");
			}
			printf("\n");
		}
	}
	BDFFont_dtor(&font);

	return EXIT_SUCCESS;
}
