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
	{
		printf("size: %d %d %d\n", $2, $3, $4);
	}
	;

font_bbx
	: FONT_BBX INTEGER INTEGER INTEGER INTEGER
	{
		printf("font bbx: %d %d %d %d\n", $2, $3, $4, $5);
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
		printf("chars: %d\n", $2);
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
		printf("--- start char %s ---\n", $2);
	}
	;

encoding
	: ENCODING INTEGER
	{
		printf("encoding: %d\n", $2);
	}
	;

swidth
	: SWIDTH INTEGER INTEGER
	{
		printf("swidth: %d %d\n", $2, $3);
	}
	;

dwidth
	: DWIDTH INTEGER INTEGER
	{
		printf("dwidth: %d %d\n", $2, $3);
	}
	;

bbx
	: BBX INTEGER INTEGER INTEGER INTEGER
	{
		printf("bbx: %d %d %d %d\n", $2, $3, $4, $5);
	}
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
