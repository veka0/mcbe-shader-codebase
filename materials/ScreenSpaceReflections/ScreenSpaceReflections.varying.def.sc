vec4 a_position  : POSITION;
vec2 a_texcoord0 : TEXCOORD0;

#ifdef SSR_RAY_MARCH_PASS
vec4 v_projPosition : TEXCOORD1;
#endif
vec2 v_texcoord0    : TEXCOORD0;
