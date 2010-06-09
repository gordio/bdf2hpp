#include <string.h>
#include "bdf.h"


void BDFFont_ctor(BDFFont* font) {
    memset(font, 0, sizeof(BDFFont));
}


void BDFFont_dtor(BDFFont* font) {
    int i;
    for(i = 0; i < font->number_of_glyphs; ++i) {
        BDFGlyph* glyph = font->glyphs + i;
        free(glyph->bitmap);
    } 
    free(font->glyphs);
    font->glyphs = NULL;
}
