vec4 a_color0    : COLOR0;
vec3 a_position  : POSITION;
vec2 a_texcoord0 : TEXCOORD0;

vec4 i_data1 : TEXCOORD7;
vec4 i_data2 : TEXCOORD6;
vec4 i_data3 : TEXCOORD5;

vec4  v_color0          : COLOR0;
vec4  v_fog             : COLOR1;
#ifdef FORWARD_PBR_TRANSPARENT_PASS
vec3  v_ndcPosition     : COLOR2;
#endif
float v_occlusionHeight : TEXCOORD2;
vec2  v_occlusionUV     : TEXCOORD1;
vec2  v_texcoord0       : TEXCOORD0;
#ifdef FORWARD_PBR_TRANSPARENT_PASS
vec3  v_worldPos        : TEXCOORD3;
#endif
