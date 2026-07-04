int  a_texcoord4 : TEXCOORD4;
vec4 a_color0    : COLOR0;
vec4 a_normal    : NORMAL;
vec3 a_position  : POSITION;
vec2 a_texcoord0 : TEXCOORD0;

vec4 i_data1 : TEXCOORD7;
vec4 i_data2 : TEXCOORD6;
vec4 i_data3 : TEXCOORD5;

flat int    v_adjacentClouds : TEXCOORD4;
vec4        v_color0         : COLOR0;
vec3        v_ndcPosition    : COLOR1;
vec3        v_normal         : NORMAL;
vec2        v_texcoord0      : TEXCOORD0;
smooth vec2 v_tilePosition   : TEXCOORD5;
vec3        v_worldPos       : TEXCOORD3;