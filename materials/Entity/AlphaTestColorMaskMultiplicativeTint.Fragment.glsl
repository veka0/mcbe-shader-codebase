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
    highp vec4 var_cd179 = texture(s_MatTexture1, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_cd179 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_6bd37 = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_17182 = texture(s_MatTexture1, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE2__SAMPLED
    highp vec4 var_17182 = texture(s_MatTexture2, v_texcoord0);
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec4 var_32f69 = MatColor0;
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_32f69 = var_cd179;
#endif
    highp float var_3e0b8 = var_32f69.w;
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec3 var_4e829 = mix(MatColor0.xyz, MatColor0.xyz * MatColor1.xyz, vec3(var_3e0b8));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec3 var_4e829 = mix(MatColor0.xyz, MatColor0.xyz * var_cd179.xyz, vec3(var_3e0b8));
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec3 var_4e829 = mix(MatColor0.xyz, MatColor0.xyz * MatColor0.xyz, vec3(var_3e0b8));
#endif
#ifdef SOURCE_INPUT_TYPE0__CONSTANT
    highp vec4 var_29045 = vec4(var_4e829.x, var_4e829.y, var_4e829.z, MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec3 var_59242 = mix(var_cd179.xyz, var_cd179.xyz * MatColor1.xyz, vec3(var_3e0b8));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec3 var_59242 = mix(var_cd179.xyz, var_cd179.xyz * var_6bd37.xyz, vec3(var_3e0b8));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec3 var_59242 = mix(var_cd179.xyz, var_cd179.xyz * var_17182.xyz, vec3(var_3e0b8));
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec3 var_59242 = mix(var_cd179.xyz, var_cd179.xyz * var_cd179.xyz, vec3(var_3e0b8));
#endif
#ifdef SOURCE_INPUT_TYPE0__SAMPLED
    highp vec4 var_29045 = vec4(var_59242.x, var_59242.y, var_59242.z, var_cd179.w);
#endif
    var_32f69 = var_29045;
    highp vec4 var_79503 = var_29045;
#ifdef SOURCE_INPUT_TYPE1__CONSTANT
    highp vec4 var_b0326 = MatColor1;
#endif
// Approximation, matches 15 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED)
    highp vec4 var_b0326 = var_cd179;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && !defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_b0326 = var_6bd37;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_b0326 = var_17182;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0)
    highp vec4 var_b0326 = MatColor0;
#endif
    var_79503.w *= var_b0326.w;
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_18a95 = var_17182;
#endif
// Approximation, matches 17 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_18a95 = var_cd179;
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec3 var_b4d6d = var_17182.xyz * MatColor2.xyz;
#endif
// Approximation, matches 17 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec3 var_b4d6d = var_cd179.xyz * MatColor2.xyz;
#endif
#if defined(SOURCE_INPUT_TYPE2__SAMPLED) || (defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_19379 = vec4(var_b4d6d.x, var_b4d6d.y, var_b4d6d.z, var_17182.w);
#endif
// Approximation, matches 17 cases out of 18
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_19379 = vec4(var_b4d6d.x, var_b4d6d.y, var_b4d6d.z, var_cd179.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0)) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_18a95 = MatColor0;
    highp vec3 var_b4d6d = MatColor0.xyz * MatColor2.xyz;
    highp vec4 var_19379 = vec4(var_b4d6d.x, var_b4d6d.y, var_b4d6d.z, MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_18a95 = MatColor1;
    highp vec3 var_b4d6d = MatColor1.xyz * MatColor2.xyz;
    highp vec4 var_19379 = vec4(var_b4d6d.x, var_b4d6d.y, var_b4d6d.z, MatColor1.w);
#endif
    highp vec3 var_83f4e = mix(var_79503.xyz, var_b4d6d.xyz, vec3(var_19379.w));
    highp vec4 var_6b2de = vec4(var_83f4e.x, var_83f4e.y, var_83f4e.z, var_79503.w);
    if ((var_6b2de.w + var_18a95.w) <= 0.0)
    {
        discard;
    }
    highp vec4 var_67e20 = OverlayColor;
    highp vec4 var_34c7a = v_fog;
    bgfx_FragData0 = vec4(mix((mix(var_83f4e.xyz, OverlayColor.xyz, vec3(var_67e20.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_34c7a.w)), var_79503.w);
}
