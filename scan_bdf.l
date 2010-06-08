%{
#include "parse_bdf.h"
%}
%x bitmap
%%
STARTFONT			{ return START_FONT; }
FONT				{ return FONT; }
SIZE				{ return SIZE; }
FONTBOUNDINGBOX			{ return FONT_BBX; }
STARTPROPERTIES			{ return START_PROPERTIES; }
ENDPROPERTIES			{ return END_PROPERTIES; }
CHARS				{ return CHARS; }
STARTCHAR			{ return START_CHAR; }
ENCODING			{ return ENCODING; }
SWIDTH				{ return SWIDTH; }
DWIDTH				{ return DWIDTH; }
BBX				{ return BBX; }
BITMAP				{ BEGIN(bitmap); return BITMAP; }
<bitmap>{
[0-9a-fA-F]{2}			{ yylval.byte = strtol(yytext, NULL, 16); return HEX; }
ENDCHAR				{ BEGIN(INITIAL); return END_CHAR; }
}
ENDFONT				{ return END_FONT; }
[0-9]+\.[0-9]+			{ return VERSION; }
-?[0-9]+			{ yylval.integer = atoi(yytext); return INTEGER; }
\"[^\"]*\"			{ return ESCAPED_TEXT; }
[^ \t\r\n-]*(-[^ \t\r\n-]*){14}	{ return XLFD; }
[^ \t\r\n]+			{ yylval.text = yytext; return TEXT; }
<*>COMMENT[^\r\n]*[\r\n]+
<*>[ \t\r\n]
%%
