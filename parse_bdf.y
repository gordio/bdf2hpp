%{
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "bdf.h"

BDFFont* font_ptr = NULL;
BDFGlyph* glyph_ptr = NULL;
int glyph_count = 0;
int bitmap_count = 0;

void yyerror(const char* str) {
	printf("error: %s\n", str);
}

int yywrap() {
	return 1;
}

int BDFFont_parse(BDFFont* font) {
    int result;
    font_ptr = font;
    result = yyparse();
    font_ptr = NULL;
    return result;
}
%}
%union {
	int integer;
	unsigned char byte;
	char* text;
}
%token START_FONT FONT SIZE FONT_BBX START_PROPERTIES END_PROPERTIES
%token CHARS START_CHAR ENCODING SWIDTH DWIDTH BBX BITMAP END_CHAR END_FONT
%token VERSION ESCAPED_TEXT XLFD
%token <integer> INTEGER
%token <byte> HEX
%token <text> TEXT
%%
bdf
	: start_font
	  font
	  size
	  font_bbx
	  start_properties
	  properties
	  end_properties
	  chars
	  characters
	  end_font
	;

start_font
	: START_FONT VERSION
	;

font
	: FONT XLFD
	;

size
	: SIZE INTEGER INTEGER INTEGER
	;

font_bbx
	: FONT_BBX INTEGER INTEGER INTEGER INTEGER
	{
		assert(font_ptr);
		font_ptr->bbx[0] = $2;
		font_ptr->bbx[1] = $3;
		font_ptr->bbx[2] = $4;
		font_ptr->bbx[3] = $5;
	}
	;

start_properties
	: START_PROPERTIES INTEGER
	;

properties
	: property
	| properties property
	;

property
	: TEXT property_value
	;

property_value
	: ESCAPED_TEXT
	| INTEGER
	;

end_properties
	: END_PROPERTIES
	;

chars
	: CHARS INTEGER
	{
		int malloc_size;
		assert(font_ptr);
		font_ptr->number_of_glyphs = $2;
		malloc_size = sizeof(BDFGlyph) * font_ptr->number_of_glyphs;
		font_ptr->glyphs = malloc(malloc_size);
		memset(font_ptr->glyphs, 0, malloc_size);
		glyph_count = 0;
	}
	;

characters
	: character
	| characters character
	;

character
	: start_char
	  encoding
	  swidth
	  dwidth
	  bbx
	  bitmap
	  end_char
	;

start_char
	: START_CHAR TEXT
	{
		assert(font_ptr);
		glyph_ptr = font_ptr->glyphs + glyph_count++;
	}
	;

encoding
	: ENCODING INTEGER
	{
		assert(glyph_ptr);
		glyph_ptr->encoding = $2;
	}
	;

swidth
	: SWIDTH INTEGER INTEGER
	;

dwidth
	: DWIDTH INTEGER INTEGER
	{
		assert(glyph_ptr);
		glyph_ptr->dwidth[0] = $2;
		glyph_ptr->dwidth[1] = $3;
	}
	;

bbx
	: BBX INTEGER INTEGER INTEGER INTEGER
	{
		int byte_size;
		assert(glyph_ptr);
		glyph_ptr->bbx[0] = $2;
		glyph_ptr->bbx[1] = $3;
		glyph_ptr->bbx[2] = $4;
		glyph_ptr->bbx[3] = $5;
		glyph_ptr->pitch = ($2 + 7) / 8;
		byte_size = glyph_ptr->pitch * $3;
		glyph_ptr->bitmap = malloc(sizeof(unsigned char) * byte_size);
		bitmap_count = 0;
	}
	;

bitmap
	: BITMAP bitmap_data
	;

bitmap_data
	: 
	| bitmap_data HEX
	{
		assert(glyph_ptr);
		*(glyph_ptr->bitmap + bitmap_count++) = $2;
	}
	;

end_char
	: END_CHAR
	;

end_font
	: END_FONT
	;
%%
