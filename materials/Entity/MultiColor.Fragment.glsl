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
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_e4b7c = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_8f244 = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && !defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_3cba3 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__CONSTANT) || defined(SOURCE_INPUT_TYPE1__SHARED0)) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec4 var_8f244 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && (defined(SOURCE_INPUT_TYPE2__CONSTANT) || defined(SOURCE_INPUT_TYPE2__SAMPLED))
    highp vec4 var_84035 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_c9d31 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_897d7 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && !defined(SOURCE_INPUT_TYPE2__SHARED1) && (defined(SOURCE_INPUT_TYPE0__CONSTANT) || !defined(SOURCE_INPUT_TYPE2__SAMPLED))
    highp vec4 var_7dd2f = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_477c1 = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    highp vec4 var_cc82d = MatColor2;
#endif
#ifdef SOURCE_INPUT_TYPE1__SAMPLED
    highp vec4 var_e4b7c = texture(s_MatTexture1, v_texcoord0);
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_8f244 = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_ea61a = texture(s_MatTexture2, v_texcoord0);
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_e6d48 = var_e4b7c;
#endif
#if defined(SOURCE_INPUT_TYPE1__SAMPLED) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || !defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_4d5f6 = var_e4b7c;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__CONSTANT) || defined(SOURCE_INPUT_TYPE1__SHARED0)) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec4 var_0561c = var_8f244;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec4 var_80322 = MatColor0;
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE2__SHARED1)) && (defined(SOURCE_INPUT_TYPE2__SAMPLED) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_5783a = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE2__CONSTANT) && !defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_f33ad = MatColor2;
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_36f6f = var_8f244;
#endif
#if defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_7c126 = var_e4b7c;
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_0e8db = var_8f244;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_52884 = var_ea61a;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_69b0e = var_c9d31;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_ff82e = MatColor0;
#endif
    highp vec4 var_d504b = OverlayColor;
    highp vec4 var_d4c6f = v_fog;
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_7dd2f.w)).xyz, MatColor2.xyz, vec3(var_cc82d.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_7dd2f.w)).xyz, var_e4b7c.xyz, vec3(var_e6d48.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_7dd2f.w)).xyz, MatColor0.xyz, vec3(var_80322.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_477c1.w)).xyz, MatColor1.xyz, vec3(var_5783a.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, var_e4b7c.xyz, vec3(var_4d5f6.w)).xyz, MatColor2.xyz, vec3(var_f33ad.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, var_e4b7c.xyz, vec3(var_4d5f6.w)).xyz, var_8f244.xyz, vec3(var_36f6f.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, var_e4b7c.xyz, vec3(var_e6d48.w)).xyz, var_e4b7c.xyz, vec3(var_7c126.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, var_e4b7c.xyz, vec3(var_4d5f6.w)).xyz, MatColor0.xyz, vec3(var_80322.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor0.xyz, vec3(var_80322.w)).xyz, MatColor2.xyz, vec3(var_f33ad.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor0.xyz, vec3(var_80322.w)).xyz, var_8f244.xyz, vec3(var_0e8db.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    bgfx_FragData0 = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor0.xyz, vec3(var_80322.w)).xyz, MatColor0.xyz, vec3(var_ff82e.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_3cba3.xyz, MatColor1.xyz, vec3(var_7dd2f.w)).xyz, MatColor2.xyz, vec3(var_cc82d.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_3cba3.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_3cba3.xyz, MatColor1.xyz, vec3(var_5783a.w)).xyz, var_8f244.xyz, vec3(var_0e8db.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_3cba3.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_8f244.xyz, MatColor1.xyz, vec3(var_7dd2f.w)).xyz, var_8f244.xyz, vec3(var_0561c.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_8f244.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_3cba3.xyz, MatColor1.xyz, vec3(var_477c1.w)).xyz, MatColor1.xyz, vec3(var_5783a.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_3cba3.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_84035.xyz, var_e4b7c.xyz, vec3(var_4d5f6.w)).xyz, MatColor2.xyz, vec3(var_f33ad.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_84035.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_8f244.xyz, var_8f244.xyz, vec3(var_0561c.w)).xyz, MatColor2.xyz, vec3(var_f33ad.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_8f244.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_84035.xyz, var_e4b7c.xyz, vec3(var_4d5f6.w)).xyz, var_ea61a.xyz, vec3(var_52884.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_84035.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_c9d31.xyz, var_e4b7c.xyz, vec3(var_4d5f6.w)).xyz, var_c9d31.xyz, vec3(var_69b0e.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_c9d31.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_897d7.xyz, var_e4b7c.xyz, vec3(var_4d5f6.w)).xyz, var_e4b7c.xyz, vec3(var_7c126.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_897d7.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_8f244.xyz, var_8f244.xyz, vec3(var_0561c.w)).xyz, var_ea61a.xyz, vec3(var_52884.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_8f244.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    bgfx_FragData0 = vec4(mix((mix(mix(mix(var_8f244.xyz, var_8f244.xyz, vec3(var_0561c.w)).xyz, var_8f244.xyz, vec3(var_36f6f.w)).xyz, OverlayColor.xyz, vec3(var_d504b.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_d4c6f.w)), var_8f244.w);
#endif
}
