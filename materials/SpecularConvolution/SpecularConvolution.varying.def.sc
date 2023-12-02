vec4 a_position : POSITION;

#ifdef CONVOLVE_PASS
vec3 v_viewVec  : TEXCOORD0;
#endif
#ifdef GENERATE_BRDF_PASS
vec2 v_texCoord : TEXCOORD0;
#endif
