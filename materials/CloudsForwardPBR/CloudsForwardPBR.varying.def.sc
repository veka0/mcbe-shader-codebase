vec4 a_color0   : COLOR0;
vec3 a_position : POSITION;

vec4 i_data1 : TEXCOORD8;
vec4 i_data2 : TEXCOORD7;
vec4 i_data3 : TEXCOORD6;
vec4 i_data4 : TEXCOORD5;
#if !defined(DEPTH_ONLY_FALLBACK_PASS) && !defined(DEPTH_ONLY_PASS)

vec4 v_color0        : COLOR0;
vec3 v_ndcPosition   : COLOR1;
vec3 v_worldPosition : TEXCOORD3;
#endif
