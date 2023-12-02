vec4 a_color0    : COLOR0;
vec3 a_position  : POSITION;
#if defined(GEOMETRY_PREPASS_PASS) && (BGFX_SHADER_LANGUAGE_GLSL == 310)
vec2 a_texcoord0 : TEXCOORD0;
#endif

#if defined(GEOMETRY_PREPASS_PASS) && (BGFX_SHADER_LANGUAGE_GLSL == 310)
vec4 i_data1 : TEXCOORD7;
vec4 i_data2 : TEXCOORD6;
vec4 i_data3 : TEXCOORD5;

#endif
vec4 v_color0       : COLOR0;
#if defined(GEOMETRY_PREPASS_PASS) && (BGFX_SHADER_LANGUAGE_GLSL == 310)
vec3 v_normal       : NORMAL;
vec3 v_prevWorldPos : TEXCOORD4;
vec2 v_texcoord0    : TEXCOORD0;
vec3 v_worldPos     : TEXCOORD3;
#endif
