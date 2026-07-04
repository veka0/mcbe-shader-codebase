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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_4b905 = texture(s_MatTexture1, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_4b905 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_990c0 = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_61dc8 = texture(s_MatTexture1, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE2__SAMPLED
    highp vec4 var_61dc8 = texture(s_MatTexture2, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
    highp vec4 var_516d0 = MatColor1;
    highp vec4 var_0c70a = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec3 var_74f50 = mix(MatColor0.xyz, MatColor1.xyz, vec3(var_0c70a.w));
#endif
// Approximation, matches 15 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_516d0 = var_4b905;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_516d0 = var_990c0;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_516d0 = var_61dc8;
#endif
// Approximation, matches 15 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_ca8f0 = var_4b905;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_1e153 = var_990c0;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_486f1 = var_61dc8;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec3 var_74f50 = mix(MatColor0.xyz, var_4b905.xyz, vec3(var_ca8f0.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_516d0 = MatColor0;
    highp vec4 var_433c2 = MatColor0;
    highp vec3 var_74f50 = mix(MatColor0.xyz, MatColor0.xyz, vec3(var_433c2.w));
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec4 var_8b54d = vec4(var_74f50.x, var_74f50.y, var_74f50.z, MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec3 var_74f50 = mix(var_4b905.xyz, MatColor1.xyz, vec3(var_0c70a.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec3 var_74f50 = mix(var_4b905.xyz, var_990c0.xyz, vec3(var_1e153.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec3 var_74f50 = mix(var_4b905.xyz, var_61dc8.xyz, vec3(var_486f1.w));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec3 var_74f50 = mix(var_4b905.xyz, var_4b905.xyz, vec3(var_ca8f0.w));
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_8b54d = vec4(var_74f50.x, var_74f50.y, var_74f50.z, var_4b905.w);
#endif
    if ((var_8b54d.w <= DiscardValue.x) && (var_516d0.w <= 0.0))
    {
        discard;
    }
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec3 var_77bee = var_61dc8.xyz * MatColor2.xyz;
#endif
// Approximation, matches 17 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec3 var_0b5f1 = var_4b905.xyz * MatColor2.xyz;
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_efb6b = vec4(var_77bee.x, var_77bee.y, var_77bee.z, var_61dc8.w);
#endif
// Approximation, matches 17 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_91a2a = vec4(var_0b5f1.x, var_0b5f1.y, var_0b5f1.z, var_4b905.w);
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec3 var_c0d0a = mix(var_61dc8.xyz, var_77bee.xyz, vec3(var_efb6b.w));
#endif
// Approximation, matches 17 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec3 var_c0d0a = mix(var_4b905.xyz, var_0b5f1.xyz, vec3(var_91a2a.w));
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_e7b4c = vec4(var_c0d0a.x, var_c0d0a.y, var_c0d0a.z, var_61dc8.w);
#endif
// Approximation, matches 17 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_e7b4c = vec4(var_c0d0a.x, var_c0d0a.y, var_c0d0a.z, var_4b905.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec3 var_98bca = MatColor0.xyz * MatColor2.xyz;
    highp vec4 var_9a4b8 = vec4(var_98bca.x, var_98bca.y, var_98bca.z, MatColor0.w);
    highp vec3 var_c0d0a = mix(MatColor0.xyz, var_98bca.xyz, vec3(var_9a4b8.w));
    highp vec4 var_e7b4c = vec4(var_c0d0a.x, var_c0d0a.y, var_c0d0a.z, MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec3 var_2d157 = MatColor1.xyz * MatColor2.xyz;
    highp vec4 var_bd3a3 = vec4(var_2d157.x, var_2d157.y, var_2d157.z, MatColor1.w);
    highp vec3 var_c0d0a = mix(MatColor1.xyz, var_2d157.xyz, vec3(var_bd3a3.w));
    highp vec4 var_e7b4c = vec4(var_c0d0a.x, var_c0d0a.y, var_c0d0a.z, MatColor1.w);
#endif
    highp vec4 var_7d55a = OverlayColor;
    highp vec4 var_b651a = v_fog;
    highp vec3 var_b2454 = mix((mix(mix(var_74f50.xyz, var_c0d0a.xyz, vec3(ceil(var_e7b4c.w))).xyz, OverlayColor.xyz, vec3(var_7d55a.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_b651a.w));
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    bgfx_FragColor = vec4(var_b2454.x, var_b2454.y, var_b2454.z, MatColor0.w);
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    bgfx_FragColor = vec4(var_b2454.x, var_b2454.y, var_b2454.z, var_4b905.w);
#endif
}
