%{
#include <stdio.h>

void yyerror(const char* str) {
	printf("error: %s\n", str);
}

int yywrap() {
	return 1;
}

int main() {
	yyparse();
	return 0;
}
%}
%token START_FONT FONT SIZE FONT_BBX START_PROPERTIES END_PROPERTIES
%token CHARS START_CHAR ENCODING SWIDTH DWIDTH BBX BITMAP END_CHAR END_FONT
%token HEX VERSION INTEGER ESCAPED_TEXT XLFD TEXT
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
		printf("start char is found.\n");
	}
	;

encoding
	: ENCODING INTEGER
	;

swidth
	: SWIDTH INTEGER INTEGER
	;

dwidth
	: DWIDTH INTEGER INTEGER
	;

bbx
	: BBX INTEGER INTEGER INTEGER INTEGER
	;

bitmap
	: BITMAP bitmap_data
	;

bitmap_data
	: 
	| bitmap_data HEX
	;

end_char
	: END_CHAR
	;

end_font
	: END_FONT
	;
%%
