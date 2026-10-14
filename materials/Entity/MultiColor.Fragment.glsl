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
* - SOURCE_INPUT_TYPE0__CONSTANT
* - SOURCE_INPUT_TYPE0__SAMPLED
*
* SourceInputType1:
* - SOURCE_INPUT_TYPE1__CONSTANT
* - SOURCE_INPUT_TYPE1__SAMPLED
* - SOURCE_INPUT_TYPE1__SHARED0
*
* SourceInputType2:
* - SOURCE_INPUT_TYPE2__CONSTANT
* - SOURCE_INPUT_TYPE2__SAMPLED
* - SOURCE_INPUT_TYPE2__SHARED0
* - SOURCE_INPUT_TYPE2__SHARED1
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

precision mediump float;
precision highp int;
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture2;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
uniform highp sampler2D s_MatTexture2;
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
uniform highp vec4 MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
uniform highp sampler2D s_MatTexture0;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture2;
#endif
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
uniform highp vec4 MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
#ifdef SOURCE_INPUT_TYPE2__CONSTANT
uniform highp vec4 MatColor2;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
uniform highp sampler2D s_MatTexture2;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_fog;
in highp vec4 v_light;
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED) || defined(SOURCE_INPUT_TYPE2__SAMPLED)
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_7b0f8 = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_c9f9f = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_7b0f8 = texture(s_MatTexture2, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec4 var_8a0e3 = MatColor0;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_66c60 = MatColor1;
    highp vec3 var_112af = mix(MatColor0.xyz, MatColor1.xyz, vec3(var_66c60.w));
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || !defined(SOURCE_INPUT_TYPE1__SAMPLED))
    highp vec4 var_c9f9f = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_16e1a = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_005a0 = texture(s_MatTexture0, v_texcoord0);
    highp vec4 var_c9f9f = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_7b0f8 = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_c9f9f = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_8ed44 = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_7b0f8 = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_8a0e3 = var_005a0;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_8a0e3 = var_16e1a;
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || !defined(SOURCE_INPUT_TYPE1__SAMPLED))
    highp vec4 var_8a0e3 = var_c9f9f;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_e52c2 = var_c9f9f;
    highp vec3 var_112af = mix(MatColor0.xyz, var_c9f9f.xyz, vec3(var_e52c2.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_433c2 = MatColor0;
    highp vec3 var_112af = mix(MatColor0.xyz, MatColor0.xyz, vec3(var_433c2.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_5225c = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && !defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec3 var_112af = mix(var_c9f9f.xyz, MatColor1.xyz, vec3(var_5225c.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec3 var_112af = mix(var_005a0.xyz, MatColor1.xyz, vec3(var_5225c.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_1e153 = var_c9f9f;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_486f1 = var_8ed44;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_ae961 = var_c9f9f;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec3 var_112af = mix(var_16e1a.xyz, var_c9f9f.xyz, vec3(var_1e153.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec3 var_112af = mix(var_c9f9f.xyz, var_8ed44.xyz, vec3(var_486f1.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec3 var_112af = mix(var_c9f9f.xyz, var_c9f9f.xyz, vec3(var_ae961.w));
#endif
    var_8a0e3.x = var_112af.x;
    var_8a0e3.y = var_112af.y;
    var_8a0e3.z = var_112af.z;
    highp vec4 var_d657c = var_8a0e3;
#ifdef SOURCE_INPUT_TYPE2__CONSTANT
    highp vec4 var_b4704 = MatColor2;
    highp vec3 var_40e30 = mix(var_8a0e3.xyz, MatColor2.xyz, vec3(var_b4704.w));
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) && (defined(SOURCE_INPUT_TYPE0__CONSTANT) || !defined(SOURCE_INPUT_TYPE1__CONSTANT))
    highp vec4 var_27a85 = var_7b0f8;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0) && !defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_9ac94 = var_c9f9f;
#endif
// Approximation, matches 22 cases out of 24
#if defined(SOURCE_INPUT_TYPE2__SHARED1) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED)) && (defined(SOURCE_INPUT_TYPE1__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SHARED0))
    highp vec4 var_823d4 = var_c9f9f;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0) && !defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec3 var_40e30 = mix(var_8a0e3.xyz, var_c9f9f.xyz, vec3(var_9ac94.w));
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) && (defined(SOURCE_INPUT_TYPE0__CONSTANT) || !defined(SOURCE_INPUT_TYPE1__CONSTANT))
    highp vec3 var_40e30 = mix(var_8a0e3.xyz, var_7b0f8.xyz, vec3(var_27a85.w));
#endif
// Approximation, matches 22 cases out of 24
#if defined(SOURCE_INPUT_TYPE2__SHARED1) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED)) && (defined(SOURCE_INPUT_TYPE1__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SHARED0))
    highp vec3 var_40e30 = mix(var_8a0e3.xyz, var_c9f9f.xyz, vec3(var_823d4.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_3c489 = MatColor0;
    highp vec3 var_40e30 = mix(var_8a0e3.xyz, MatColor0.xyz, vec3(var_3c489.w));
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_e3c51 = MatColor1;
    highp vec3 var_40e30 = mix(var_8a0e3.xyz, MatColor1.xyz, vec3(var_e3c51.w));
#endif
    var_d657c.x = var_40e30.x;
    var_d657c.y = var_40e30.y;
    var_d657c.z = var_40e30.z;
    highp vec4 var_a42ab = var_d657c;
    highp vec4 var_54e30 = OverlayColor;
    highp vec3 var_e73b6 = mix(var_d657c.xyz, OverlayColor.xyz, vec3(var_54e30.w));
    var_a42ab.x = var_e73b6.x;
    var_a42ab.y = var_e73b6.y;
    var_a42ab.z = var_e73b6.z;
    highp vec4 var_5be75 = var_a42ab;
    highp vec3 var_279b1 = var_a42ab.xyz * v_light.xyz;
    var_5be75.x = var_279b1.x;
    var_5be75.y = var_279b1.y;
    var_5be75.z = var_279b1.z;
    highp vec4 var_72c1b = var_5be75;
    highp vec3 var_c6e56 = mix(var_5be75.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_c6e56.x;
    var_72c1b.y = var_c6e56.y;
    var_72c1b.z = var_c6e56.z;
    bgfx_FragData0 = var_72c1b;
}
