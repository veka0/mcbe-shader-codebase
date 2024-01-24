vec4 a_color0    : COLOR0;
vec4 a_normal    : NORMAL;
vec3 a_position  : POSITION;
vec2 a_texcoord0 : TEXCOORD0;

vec4 i_data1 : TEXCOORD7;
vec4 i_data2 : TEXCOORD6;
vec4 i_data3 : TEXCOORD5;

vec4 v_color0            : COLOR0;
vec2 v_texcoord0         : TEXCOORD0;
vec3 v_viewSpaceNormal   : NORMAL;
#ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
vec4 v_viewSpacePosition : COLOR1;
#endif
vec3 v_worldPos          : TEXCOORD3;
