%{
#include <stdio.h>
%}
%x bitmap
%%
STARTFONT			{ printf("start_font"); }
FONT				{ printf("font"); }
SIZE				{ printf("font_size"); }
FONTBOUNDINGBOX			{ printf("font_boundingbox"); }
STARTPROPERTIES			{ printf("start_properties"); }
ENDPROPERTIES			{ printf("end_properties"); }
CHARS				{ printf("char_num"); }
STARTCHAR			{ printf("start_char"); }
ENCODING			{ printf("encoding"); }
SWIDTH				{ printf("swidth"); }
DWIDTH				{ printf("dwidth"); }
BBX				{ printf("bbx"); }
BITMAP				{ printf("bitmap"); BEGIN(bitmap); }
<bitmap>{
[0-9a-fA-F]{2}			{ printf("hex"); }
ENDCHAR				{ printf("end_char"); BEGIN(INITIAL); }
}
ENDFONT				{ printf("end_font"); }
[0-9]+\.[0-9]+			{ printf("version"); }
-?[0-9]+			{ printf("integer"); }
\"[^\"]*\"			{ printf("escaped_text"); }
[^ \t\r\n-]*(-[^ \t\r\n-]*){14}	{ printf("xlfd"); }
[^ \t\r\n]+			{ printf("text"); }
COMMENT[^\r\n]*[\r\n]+
%%
