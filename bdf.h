#ifndef BDF_H
#define BDF_H


typedef struct BDFGlyph_ {
    int encoding;
    int dwidth[2];
    int bbx[4];
    int pitch;
    unsigned char* bitmap;
} BDFGlyph;


typedef struct BDFFont_ {
    int bbx[4];
    int number_of_glyphs;
    BDFGlyph* glyphs;
} BDFFont;


void BDFFont_ctor(BDFFont* font);
void BDFFont_dtor(BDFFont* font);
int BDFFont_parse(BDFFont* font);


#endif
