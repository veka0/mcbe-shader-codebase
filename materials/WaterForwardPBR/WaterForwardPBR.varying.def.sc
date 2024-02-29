vec4 a_color0    : COLOR0;
vec2 a_texcoord1 : TEXCOORD1;
vec4 a_normal    : NORMAL;
#ifdef DO_WATER_SHADING_PASS
int  a_texcoord4 : TEXCOORD4;
#endif
vec3 a_position  : POSITION;
vec4 a_tangent   : TANGENT;
vec2 a_texcoord0 : TEXCOORD0;

vec4 i_data1 : TEXCOORD7;
vec4 i_data2 : TEXCOORD6;
vec4 i_data3 : TEXCOORD5;

vec3          v_bitangent    : BITANGENT;
vec4          v_color0       : COLOR0;
#ifdef DO_WATER_SHADING_PASS
flat int      v_frontFacing  : FRONTFACING;
#endif
vec2          v_lightmapUV   : TEXCOORD1;
vec3          v_normal       : NORMAL;
#ifdef DO_WATER_SHADING_PASS
flat int      v_pbrTextureId : TEXCOORD4;
#endif
vec3          v_tangent      : TANGENT;
centroid vec2 v_texcoord0    : TEXCOORD0;
vec3          v_worldPos     : TEXCOORD3;
