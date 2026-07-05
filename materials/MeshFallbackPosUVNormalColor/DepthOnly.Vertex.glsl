#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS (not used)
* - RASTERIZED_OPAQUE_PASS (not used)
* - RASTERIZED_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED (not used)
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED (not used)
*
* Lit:
* - LIT__OFF
* - LIT__ON
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF (not used)
* - MULTI_COLOR_TINT__ON (not used)
*
* UseTextures:
* - USE_TEXTURES__OFF (not used)
* - USE_TEXTURES__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 AlphaMaskedTint;
* - uniform vec4 ChangeColor;
* - uniform vec4 CurrentColor;
* - uniform vec4 DiscardValue;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 HudOpacity;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 UVAnimation;
* - uniform vec4 ZShiftValue;
*/

uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 FogColor;
uniform vec4 FogControl;
#ifdef LIT__ON
uniform vec4 OverlayColor;
#endif
uniform vec4 SubPixelOffset;
#ifdef LIT__ON
uniform vec4 TileLightColor;
#endif
uniform vec4 UVAnimation;
uniform vec4 ZShiftValue;
in vec4 a_color0;
#ifdef LIT__ON
in vec4 a_normal;
#endif
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_clipPosition;
out vec4 v_color;
out vec4 v_fog;
out vec4 v_light;
centroid out vec2 v_texCoords;
out vec3 v_worldPos;
void main() {
    vec4 var_8815e = u_model[0] * vec4(a_position, 1.0);
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_cbf5d = u_proj;
    var_cbf5d[2] = var_67767;
    vec4 var_79258 = var_cbf5d * (u_view * vec4(var_8815e.xyz, 1.0));
    vec4 var_5b30b = var_79258;
    var_5b30b.z += ZShiftValue.x;
#ifdef LIT__ON
    vec3 var_54aa7 = normalize((u_model[0] * a_normal).xyz);
    var_54aa7.y *= TileLightColor.w;
#endif
    vec4 var_20599 = var_5b30b;
    vec4 var_27f6b = var_20599;
    var_5b30b = var_20599;
    v_clipPosition = var_79258;
    v_color = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_27f6b.z / FogControl.z) - FogControl.x) / (FogControl.y - FogControl.x), 0.0, 1.0));
#ifdef LIT__OFF
    v_light = vec4(0.0);
#endif
#ifdef LIT__ON
    v_light = vec4(vec3(((((1.0 + var_54aa7.y) * 0.2750000059604644775390625) + ((var_54aa7.x * var_54aa7.x) * (-0.100000001490116119384765625))) + ((var_54aa7.z * var_54aa7.z) * 0.100000001490116119384765625)) + 0.449999988079071044921875) * TileLightColor.xyz, 1.0) + vec4(OverlayColor.w * 0.3499999940395355224609375);
#endif
    v_texCoords = UVAnimation.xy + (a_texcoord0 * UVAnimation.zw);
    v_worldPos = var_8815e.xyz;
    gl_Position = var_20599;
}
