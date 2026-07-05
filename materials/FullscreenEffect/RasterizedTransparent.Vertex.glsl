#version 310 es

/*
* Available Macros:
*
* Passes:
* - RASTERIZED_TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED (not used)
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED (not used)
*
* Lit:
* - LIT__OFF (not used)
* - LIT__ON (not used)
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
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 CurrentColor;
* - uniform vec4 DiscardValue;
* - uniform vec4 HudOpacity;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 UVAnimation;
* - uniform vec4 ZShiftValue;
*/

uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
uniform vec4 UVAnimation;
uniform vec4 ZShiftValue;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color;
out vec4 v_fog;
out vec4 v_light;
centroid out vec2 v_texCoords;
void main() {
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_4d7fb = u_proj;
    var_4d7fb[2] = var_67767;
    vec4 var_137b0 = var_4d7fb * (u_view * vec4((u_model[0] * vec4(a_position, 1.0)).xyz, 1.0));
    var_137b0.z += ZShiftValue.x;
    v_color = a_color0;
    v_fog = vec4(0.0);
    v_light = vec4(0.0);
    v_texCoords = UVAnimation.xy + (a_texcoord0 * UVAnimation.zw);
    gl_Position = var_137b0;
}
