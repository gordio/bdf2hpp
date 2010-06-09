#include <stdio.h>
#include <stdlib.h>
#include "bdf.h"


int main(int argc, char* argv[]) {
    const int begin = 0x20;
    const int end = 0x7f;
    int i, j;

    BDFFont font;
    BDFFont_ctor(&font);
    if(BDFFont_parse(&font) == 0) {
        printf("const int font_width = %d;\n", font.bbx[0]);
        printf("const int font_height = %d;\n", font.bbx[1]);
        printf("const unsigned char font_bitmap[][%d] = {\n", font.bbx[1]);
        for(i = 0; i < font.number_of_glyphs; ++i) {
            BDFGlyph* glyph = font.glyphs + i;
            if(glyph->encoding >= begin && glyph->encoding < end) {
                printf("{ ");
                for(j = glyph->bbx[1] - 1; j >= 0; --j) {
                    printf("0x%02X, ", *(glyph->bitmap + j));
                }
                printf("},\n");
            }
        }
        printf("};\n");
    }
    BDFFont_dtor(&font);

    return EXIT_SUCCESS;
}
