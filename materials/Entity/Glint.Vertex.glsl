#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - ALPHA_TEST_COLOR_MASK_PASS (not used)
* - ALPHA_TEST_COLOR_MASK_GLINT_PASS (not used)
* - ALPHA_TEST_COLOR_MASK_MULTIPLICATIVE_TINT_PASS (not used)
* - ALPHA_TEST_EMISSIVE_PASS (not used)
* - ALPHA_TEST_EMISSIVE_ONLY_PASS (not used)
* - ALPHA_TEST_GLINT_PASS (not used)
* - ALPHA_TEST_MASKED_OVERWRITE_PASS (not used)
* - ALPHA_TEST_MULTI_COLOR_PASS (not used)
* - BASE_COLOR_PASS (not used)
* - COLOR_MASK_PASS (not used)
* - EMISSIVE_PASS (not used)
* - GLINT_PASS (not used)
* - MULTI_COLOR_PASS (not used)
*
* SourceInputType0:
* - SOURCE_INPUT_TYPE0__CONSTANT (not used)
* - SOURCE_INPUT_TYPE0__SAMPLED (not used)
*
* SourceInputType1:
* - SOURCE_INPUT_TYPE1__CONSTANT (not used)
* - SOURCE_INPUT_TYPE1__SAMPLED (not used)
* - SOURCE_INPUT_TYPE1__SHARED0 (not used)
*
* SourceInputType2:
* - SOURCE_INPUT_TYPE2__CONSTANT (not used)
* - SOURCE_INPUT_TYPE2__SAMPLED (not used)
* - SOURCE_INPUT_TYPE2__SHARED0 (not used)
* - SOURCE_INPUT_TYPE2__SHARED1 (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture0;
* - uniform lowp sampler2D s_MatTexture1;
* - uniform lowp sampler2D s_MatTexture2;
*
* Uniforms:
* - uniform mat4 Bones[8];
* - uniform vec4 DiscardValue;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 GlintColor;
* - uniform vec4 MatColor0;
* - uniform vec4 MatColor1;
* - uniform vec4 MatColor2;
* - uniform vec4 OverlayColor;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
*/

uniform mat4 Bones[8];
uniform mat4 u_modelViewProj;
uniform mat4 u_model[4];
uniform vec4 FogColor;
uniform vec4 FogControl;
uniform vec4 OverlayColor;
uniform vec4 TileLightColor;
uniform vec4 UVAnimation;
uniform vec4 UVScale;
in float a_indices;
in vec4 a_normal;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_fog;
out vec4 v_layerUv;
out vec4 v_light;
out vec2 v_texcoord0;
void main() {
    int var_e3d27 = int(a_indices);
    vec4 var_1785d = u_modelViewProj * (Bones[var_e3d27] * vec4(a_position, 1.0));
    vec4 var_00926 = var_1785d;
    vec3 var_54c8b = normalize(u_model[0] * (Bones[var_e3d27] * a_normal)).xyz;
    var_54c8b.y *= TileLightColor.w;
    vec4 var_edf44 = vec4(FogColor.x, FogColor.y, FogColor.z, vec4(0.0).w);
    var_edf44.w = clamp(((var_00926.z / FogControl.z) - FogControl.x) / (FogControl.y - FogControl.x), 0.0, 1.0);
    float var_97211 = sin(UVAnimation.z);
    float var_ce25b = cos(UVAnimation.z);
    vec2 var_98b8b = (a_texcoord0 - vec2(0.5)) * mat2(vec2(var_ce25b, -var_97211), vec2(var_97211, var_ce25b));
    var_98b8b.x += UVAnimation.x;
    vec2 var_eb807 = var_98b8b;
    vec2 var_e0bbc = var_eb807 + vec2(0.5);
    var_98b8b = var_e0bbc;
    vec2 var_1a9e2 = var_e0bbc * UVScale.xy;
    float var_89ba8 = sin(UVAnimation.w);
    float var_104e7 = cos(UVAnimation.w);
    vec2 var_65238 = (a_texcoord0 - vec2(0.5)) * mat2(vec2(var_104e7, -var_89ba8), vec2(var_89ba8, var_104e7));
    var_65238.x += UVAnimation.y;
    vec2 var_0ef75 = var_65238;
    vec2 var_a930f = var_0ef75 + vec2(0.5);
    var_65238 = var_a930f;
    vec2 var_fa5b0 = var_a930f * UVScale.xy;
    v_fog = var_edf44;
    v_layerUv = vec4(var_1a9e2.x, var_1a9e2.y, var_fa5b0.x, var_fa5b0.y);
    v_light = vec4(TileLightColor.xyz * ((((((1.0 + var_54c8b.y) * 0.2750000059604644775390625) + ((var_54c8b.x * var_54c8b.x) * (-0.100000001490116119384765625))) + ((var_54c8b.z * var_54c8b.z) * 0.100000001490116119384765625)) + 0.449999988079071044921875) + (OverlayColor.w * 0.3499999940395355224609375)), 1.0);
    v_texcoord0 = a_texcoord0;
    gl_Position = var_1785d;
}
