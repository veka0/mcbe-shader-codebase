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
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
uniform highp sampler2D s_MatTexture0;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
uniform highp sampler2D s_MatTexture1;
#endif
uniform highp sampler2D s_MatTexture2;
uniform highp vec4 GlintColor;
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
uniform highp vec4 MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
uniform highp vec4 MatColor1;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightColor;
in highp vec4 v_fog;
in highp vec4 v_layerUv;
in highp vec4 v_light;
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED)
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef SOURCE_INPUT_TYPE1__SAMPLED
    highp vec4 var_943c3 = texture(s_MatTexture1, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec4 var_6d22a = MatColor0;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_6d22a = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_943c3 = texture(s_MatTexture0, v_texcoord0);
    highp vec4 var_6d22a = var_943c3;
#endif
    if (var_6d22a.w <= 0.0)
    {
        discard;
    }
    highp vec4 var_60af6 = var_6d22a;
    highp float var_0a4b5 = var_60af6.w;
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
    highp vec3 var_d9378 = mix(var_6d22a.xyz, var_6d22a.xyz * MatColor1.xyz, vec3(var_0a4b5));
#endif
#if !defined(SOURCE_INPUT_TYPE1__CONSTANT) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED))
    highp vec3 var_d9378 = mix(var_6d22a.xyz, var_6d22a.xyz * var_943c3.xyz, vec3(var_0a4b5));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec3 var_d9378 = mix(var_6d22a.xyz, var_6d22a.xyz * MatColor0.xyz, vec3(var_0a4b5));
#endif
    var_60af6.x = var_d9378.x;
    var_60af6.y = var_d9378.y;
    var_60af6.z = var_d9378.z;
    highp vec4 var_aa4ef = var_60af6;
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
    highp vec4 var_a42dd = MatColor1;
#endif
#if !defined(SOURCE_INPUT_TYPE1__CONSTANT) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE1__SAMPLED))
    highp vec4 var_a42dd = var_943c3;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_a42dd = MatColor0;
#endif
    var_aa4ef.w *= var_a42dd.w;
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
    highp vec4 var_88ff7 = var_5be75;
    highp vec3 var_c6e56 = mix(var_5be75.xyz, v_fog.xyz, vec3(v_fog.w));
    var_88ff7.x = var_c6e56.x;
    var_88ff7.y = var_c6e56.y;
    var_88ff7.z = var_c6e56.z;
    highp vec4 var_c28da = ((texture(s_MatTexture2, fract(v_layerUv.xy)).xyzx * GlintColor) + (texture(s_MatTexture2, fract(v_layerUv.zw)).xyzx * GlintColor)) * TileLightColor;
    highp vec4 var_d18cf = var_c28da;
    highp vec4 var_42c1d = vec4(var_c28da.xyz * var_c28da.xyz, abs(var_d18cf.w)) + vec4(var_88ff7.xyz, 0.0);
    var_6d22a = var_42c1d;
    bgfx_FragData0 = var_42c1d;
}
