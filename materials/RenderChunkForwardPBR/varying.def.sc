vec4 a_color0    : COLOR0;
#if !defined(DEPTH_ONLY_ALPHA_TEST_PASS) && !defined(DEPTH_ONLY_OPAQUE_PASS)
vec2 a_texcoord1 : TEXCOORD1;
vec4 a_normal    : NORMAL;
int  a_texcoord4 : TEXCOORD4;
#endif
vec3 a_position  : POSITION;
#if !defined(DEPTH_ONLY_ALPHA_TEST_PASS) && !defined(DEPTH_ONLY_OPAQUE_PASS)
vec4 a_tangent   : TANGENT;
#endif
vec2 a_texcoord0 : TEXCOORD0;

vec4 i_data1 : TEXCOORD7;
vec4 i_data2 : TEXCOORD6;
vec4 i_data3 : TEXCOORD5;

vec3          v_bitangent               : BITANGENT;
vec4          v_clipPosition            : COLOR1;
vec4          v_color0                  : COLOR0;
#if !defined(DEPTH_ONLY_ALPHA_TEST_PASS) && !defined(DEPTH_ONLY_OPAQUE_PASS)
vec2          v_ditheringAndMaskTinting : TEXCOORD2;
#endif
flat int      v_frontFacing             : FRONTFACING;
#if !defined(DEPTH_ONLY_ALPHA_TEST_PASS) && !defined(DEPTH_ONLY_OPAQUE_PASS)
vec3          v_lightColor              : TEXCOORD5;
vec2          v_lightmapUV              : TEXCOORD1;
#endif
vec3          v_normal                  : NORMAL;
flat int      v_pbrTextureId            : TEXCOORD4;
vec3          v_tangent                 : TANGENT;
centroid vec2 v_texcoord0               : TEXCOORD0;
vec3          v_worldPos                : TEXCOORD3;