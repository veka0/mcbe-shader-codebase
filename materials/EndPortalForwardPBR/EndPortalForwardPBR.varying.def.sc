vec4 a_color0    : COLOR0;
vec3 a_position  : POSITION;
vec2 a_texcoord0 : TEXCOORD0;

vec4 i_data1 : TEXCOORD7;
vec4 i_data2 : TEXCOORD6;
vec4 i_data3 : TEXCOORD5;

centroid vec2 v_colorUV      : TEXCOORD0;
float         v_encodedPlane : TEXCOORD2;
vec4          v_fog          : COLOR0;
centroid vec2 v_parallaxUV   : TEXCOORD1;
