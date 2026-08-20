vec4 a_color0    : COLOR0;
#ifndef DEPTH_ONLY_ALPHA_TEST_PASS
vec2 a_texcoord1 : TEXCOORD1;
vec4 a_normal    : NORMAL;
int  a_texcoord4 : TEXCOORD4;
#endif
vec3 a_position  : POSITION;
#ifndef DEPTH_ONLY_ALPHA_TEST_PASS
vec4 a_tangent   : TANGENT;
#endif
vec2 a_texcoord0 : TEXCOORD0;
vec2 a_texcoord2 : TEXCOORD2;

vec4 i_data1 : TEXCOORD7;
vec4 i_data2 : TEXCOORD6;
vec4 i_data3 : TEXCOORD5;

vec3      v_bitangent               : BITANGENT;
#ifdef GEOMETRY_PREPASS_ALPHA_TEST_PASS
vec4      v_clipPosition            : COLOR1;
#endif
vec4      v_color0                  : COLOR0;
#ifndef DEPTH_ONLY_ALPHA_TEST_PASS
vec2      v_ditheringAndMaskTinting : TEXCOORD2;
flat int  v_frontFacing             : FRONTFACING;
vec3      v_lightColor              : TEXCOORD5;
vec2      v_lightmapUV              : TEXCOORD1;
#endif
vec3      v_normal                  : NORMAL;
#ifndef DEPTH_ONLY_ALPHA_TEST_PASS
flat int  v_pbrTextureId            : TEXCOORD4;
#endif
vec3      v_tangent                 : TANGENT;
vec2      v_texcoord0               : TEXCOORD0;
flat vec2 v_textureShift            : TEXCOORD6;
vec3      v_worldPos                : TEXCOORD3;