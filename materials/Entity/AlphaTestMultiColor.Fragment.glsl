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
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
uniform highp sampler2D s_MatTexture0;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
#ifdef SOURCE_INPUT_TYPE2__SAMPLED
uniform highp sampler2D s_MatTexture2;
#endif
uniform highp vec4 DiscardValue;
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
uniform highp vec4 MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
uniform highp vec4 MatColor1;
#endif
uniform highp vec4 MatColor2;
uniform highp vec4 OverlayColor;
in highp vec4 v_fog;
in highp vec4 v_light;
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED) || defined(SOURCE_INPUT_TYPE2__SAMPLED)
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_ac960 = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_ac960 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_16e1a = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_d2b11 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_ac960 = texture(s_MatTexture1, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE2__SAMPLED
    highp vec4 var_d2b11 = texture(s_MatTexture2, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
    highp vec4 var_82be0 = MatColor1;
#endif
#if !defined(SOURCE_INPUT_TYPE1__CONSTANT) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED))
    highp vec4 var_82be0 = var_ac960;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_98893 = var_ac960;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && !defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_98893 = MatColor0;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_82be0 = MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
    highp vec4 var_0c70a = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec3 var_554eb = mix(MatColor0.xyz, MatColor1.xyz, vec3(var_0c70a.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_98893 = var_16e1a;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_98893 = var_d2b11;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_98893 = var_ac960;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_e52c2 = var_ac960;
    highp vec3 var_554eb = mix(MatColor0.xyz, var_ac960.xyz, vec3(var_e52c2.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_98893 = MatColor0;
    highp vec4 var_433c2 = MatColor0;
    highp vec3 var_554eb = mix(MatColor0.xyz, MatColor0.xyz, vec3(var_433c2.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec3 var_554eb = mix(var_ac960.xyz, MatColor1.xyz, vec3(var_0c70a.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_aa51b = var_ac960;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec3 var_554eb = mix(var_16e1a.xyz, var_ac960.xyz, vec3(var_aa51b.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec3 var_554eb = mix(var_d2b11.xyz, var_ac960.xyz, vec3(var_aa51b.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec3 var_554eb = mix(var_ac960.xyz, var_ac960.xyz, vec3(var_aa51b.w));
#endif
    var_98893.x = var_554eb.x;
    var_98893.y = var_554eb.y;
    var_98893.z = var_554eb.z;
    highp vec4 var_d5886 = var_98893;
    if ((var_d5886.w <= DiscardValue.x) && (var_82be0.w <= 0.0))
    {
        discard;
    }
// Approximation, matches 16 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || !defined(SOURCE_INPUT_TYPE1__CONSTANT))
    highp vec4 var_43b0c = var_ac960;
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec4 var_43b0c = var_d2b11;
#endif
// Approximation, matches 16 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || !defined(SOURCE_INPUT_TYPE1__CONSTANT))
    highp vec3 var_eb2c6 = var_ac960.xyz * MatColor2.xyz;
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec3 var_eb2c6 = var_d2b11.xyz * MatColor2.xyz;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_43b0c = MatColor0;
    highp vec3 var_eb2c6 = MatColor0.xyz * MatColor2.xyz;
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_43b0c = MatColor1;
    highp vec3 var_eb2c6 = MatColor1.xyz * MatColor2.xyz;
#endif
    var_43b0c.x = var_eb2c6.x;
    var_43b0c.y = var_eb2c6.y;
    var_43b0c.z = var_eb2c6.z;
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_0c346 = MatColor0;
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_0c346 = MatColor1;
#endif
// Approximation, matches 17 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || !defined(SOURCE_INPUT_TYPE1__SAMPLED))
    highp vec4 var_bfb91 = var_43b0c;
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec4 var_0c346 = var_d2b11;
#endif
// Approximation, matches 16 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || !defined(SOURCE_INPUT_TYPE1__CONSTANT))
    highp vec4 var_0c346 = var_ac960;
#endif
// Approximation, matches 17 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_6ee6f = var_43b0c;
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec3 var_30772 = mix(var_d2b11.xyz, var_43b0c.xyz, vec3(var_6ee6f.w));
#endif
// Approximation, matches 16 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || !defined(SOURCE_INPUT_TYPE1__CONSTANT))
    highp vec3 var_30772 = mix(var_ac960.xyz, var_43b0c.xyz, vec3(var_6ee6f.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec3 var_30772 = mix(MatColor0.xyz, var_43b0c.xyz, vec3(var_bfb91.w));
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec3 var_30772 = mix(MatColor1.xyz, var_43b0c.xyz, vec3(var_bfb91.w));
#endif
    var_0c346.x = var_30772.x;
    var_0c346.y = var_30772.y;
    var_0c346.z = var_30772.z;
    highp vec4 var_d657c = var_98893;
    highp vec4 var_0486c = var_0c346;
    highp vec3 var_8c797 = mix(var_98893.xyz, var_0c346.xyz, vec3(ceil(var_0486c.w)));
    var_d657c.x = var_8c797.x;
    var_d657c.y = var_8c797.y;
    var_d657c.z = var_8c797.z;
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
