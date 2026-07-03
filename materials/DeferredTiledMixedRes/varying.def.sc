vec3 a_position  : POSITION;
vec2 a_texcoord0 : TEXCOORD0;
// Approximation, matches 15 cases out of 16
#if (BGFX_SHADER_LANGUAGE_GLSL == 310) && (defined(DIRECTIONAL_LIGHTING_PASS) || defined(DIRECTIONAL_LIGHTING_PASS0_PASS) || defined(DIRECTIONAL_LIGHTING_PASS1_PASS))
vec4 a_texcoord1 : TEXCOORD1;
#endif

vec3 v_projPosition : COLOR1;
vec4 v_texcoord0    : TEXCOORD0;
// Approximation, matches 15 cases out of 16
#if (BGFX_SHADER_LANGUAGE_GLSL == 310) && (defined(DIRECTIONAL_LIGHTING_PASS) || defined(DIRECTIONAL_LIGHTING_PASS0_PASS) || defined(DIRECTIONAL_LIGHTING_PASS1_PASS))
vec4 v_tileCoords   : TEXCOORD1;
#endif