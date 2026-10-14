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

precision mediump float;
precision highp int;
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
uniform highp vec4 MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
uniform highp sampler2D s_MatTexture0;
#endif
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
uniform highp vec4 MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_fog;
in highp vec4 v_light;
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED)
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_a9d82 = texture(s_MatTexture1, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec4 var_0f388 = MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_32465 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_a9d82 = texture(s_MatTexture1, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_0f388 = var_32465;
#endif
    highp float var_238ec = var_0f388.w;
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec3 var_d993a = mix(MatColor0.xyz, MatColor0.xyz * MatColor1.xyz, vec3(var_238ec));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec3 var_d993a = mix(MatColor0.xyz, MatColor0.xyz * var_a9d82.xyz, vec3(var_238ec));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec3 var_d993a = mix(MatColor0.xyz, MatColor0.xyz * MatColor0.xyz, vec3(var_238ec));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec3 var_d993a = mix(var_32465.xyz, var_32465.xyz * MatColor1.xyz, vec3(var_238ec));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec3 var_d993a = mix(var_32465.xyz, var_32465.xyz * var_a9d82.xyz, vec3(var_238ec));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec3 var_d993a = mix(var_32465.xyz, var_32465.xyz * var_32465.xyz, vec3(var_238ec));
#endif
    var_0f388.x = var_d993a.x;
    var_0f388.y = var_d993a.y;
    var_0f388.z = var_d993a.z;
    highp vec4 var_aa4ef = var_0f388;
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
    highp vec4 var_7046f = MatColor1;
#endif
#ifdef SOURCE_INPUT_TYPE1__SAMPLED
    highp vec4 var_7046f = var_a9d82;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_7046f = var_32465;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_7046f = MatColor0;
#endif
    var_aa4ef.w *= var_7046f.w;
    highp vec4 var_a42ab = var_aa4ef;
    highp vec4 var_54e30 = OverlayColor;
    highp vec3 var_e73b6 = mix(var_aa4ef.xyz, OverlayColor.xyz, vec3(var_54e30.w));
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
