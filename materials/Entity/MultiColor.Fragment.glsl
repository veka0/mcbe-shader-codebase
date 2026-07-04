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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_c9577 = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_5fabd = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && !defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_c8f8f = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__CONSTANT) || defined(SOURCE_INPUT_TYPE1__SHARED0)) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec4 var_5fabd = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && (defined(SOURCE_INPUT_TYPE2__CONSTANT) || defined(SOURCE_INPUT_TYPE2__SAMPLED))
    highp vec4 var_24017 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_22616 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_52150 = texture(s_MatTexture0, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && !defined(SOURCE_INPUT_TYPE2__SHARED1) && (defined(SOURCE_INPUT_TYPE0__CONSTANT) || !defined(SOURCE_INPUT_TYPE2__SAMPLED))
    highp vec4 var_3b1a3 = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_daca7 = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    highp vec4 var_f4b5e = MatColor2;
#endif
#ifdef SOURCE_INPUT_TYPE1__SAMPLED
    highp vec4 var_c9577 = texture(s_MatTexture1, v_texcoord0);
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_5fabd = texture(s_MatTexture2, v_texcoord0);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_69996 = texture(s_MatTexture2, v_texcoord0);
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_a554e = var_c9577;
#endif
#if defined(SOURCE_INPUT_TYPE1__SAMPLED) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || !defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_b32df = var_c9577;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && (defined(SOURCE_INPUT_TYPE1__CONSTANT) || defined(SOURCE_INPUT_TYPE1__SHARED0)) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec4 var_14565 = var_5fabd;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && (defined(SOURCE_INPUT_TYPE1__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED0))
    highp vec4 var_33496 = MatColor0;
#endif
#if defined(SOURCE_INPUT_TYPE1__CONSTANT) && (defined(SOURCE_INPUT_TYPE0__SAMPLED) || defined(SOURCE_INPUT_TYPE2__SHARED1)) && (defined(SOURCE_INPUT_TYPE2__SAMPLED) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_c15cc = MatColor1;
#endif
#if defined(SOURCE_INPUT_TYPE2__CONSTANT) && !defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_d91f8 = MatColor2;
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_21705 = var_5fabd;
#endif
#if defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    highp vec4 var_19088 = var_c9577;
#endif
// Approximation, matches 23 cases out of 24
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    highp vec4 var_232a2 = var_5fabd;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED) && !defined(SOURCE_INPUT_TYPE1__CONSTANT)
    highp vec4 var_59913 = var_69996;
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    highp vec4 var_29c9d = var_22616;
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    highp vec4 var_f75d0 = MatColor0;
#endif
    highp vec4 var_621ea = OverlayColor;
    highp vec4 var_3a2c6 = v_fog;
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_3b1a3.w)).xyz, MatColor2.xyz, vec3(var_f4b5e.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_3b1a3.w)).xyz, var_c9577.xyz, vec3(var_a554e.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_3b1a3.w)).xyz, MatColor0.xyz, vec3(var_33496.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor1.xyz, vec3(var_daca7.w)).xyz, MatColor1.xyz, vec3(var_c15cc.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, var_c9577.xyz, vec3(var_b32df.w)).xyz, MatColor2.xyz, vec3(var_d91f8.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, var_c9577.xyz, vec3(var_b32df.w)).xyz, var_5fabd.xyz, vec3(var_21705.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, var_c9577.xyz, vec3(var_a554e.w)).xyz, var_c9577.xyz, vec3(var_19088.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, var_c9577.xyz, vec3(var_b32df.w)).xyz, MatColor0.xyz, vec3(var_33496.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor0.xyz, vec3(var_33496.w)).xyz, MatColor2.xyz, vec3(var_d91f8.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor0.xyz, vec3(var_33496.w)).xyz, var_5fabd.xyz, vec3(var_232a2.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__CONSTANT) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    bgfx_FragColor = vec4(mix((mix(mix(mix(MatColor0.xyz, MatColor0.xyz, vec3(var_33496.w)).xyz, MatColor0.xyz, vec3(var_f75d0.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), MatColor0.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_c8f8f.xyz, MatColor1.xyz, vec3(var_3b1a3.w)).xyz, MatColor2.xyz, vec3(var_f4b5e.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_c8f8f.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_c8f8f.xyz, MatColor1.xyz, vec3(var_c15cc.w)).xyz, var_5fabd.xyz, vec3(var_232a2.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_c8f8f.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_5fabd.xyz, MatColor1.xyz, vec3(var_3b1a3.w)).xyz, var_5fabd.xyz, vec3(var_14565.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_5fabd.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__CONSTANT) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_c8f8f.xyz, MatColor1.xyz, vec3(var_daca7.w)).xyz, MatColor1.xyz, vec3(var_c15cc.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_c8f8f.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_24017.xyz, var_c9577.xyz, vec3(var_b32df.w)).xyz, MatColor2.xyz, vec3(var_d91f8.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_24017.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__CONSTANT)
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_5fabd.xyz, var_5fabd.xyz, vec3(var_14565.w)).xyz, MatColor2.xyz, vec3(var_d91f8.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_5fabd.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_24017.xyz, var_c9577.xyz, vec3(var_b32df.w)).xyz, var_69996.xyz, vec3(var_59913.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_24017.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED0)
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_22616.xyz, var_c9577.xyz, vec3(var_b32df.w)).xyz, var_22616.xyz, vec3(var_29c9d.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_22616.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SAMPLED) && defined(SOURCE_INPUT_TYPE2__SHARED1)
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_52150.xyz, var_c9577.xyz, vec3(var_b32df.w)).xyz, var_c9577.xyz, vec3(var_19088.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_52150.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && defined(SOURCE_INPUT_TYPE2__SAMPLED)
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_5fabd.xyz, var_5fabd.xyz, vec3(var_14565.w)).xyz, var_69996.xyz, vec3(var_59913.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_5fabd.w);
#endif
#if defined(SOURCE_INPUT_TYPE0__SAMPLED) && defined(SOURCE_INPUT_TYPE1__SHARED0) && (defined(SOURCE_INPUT_TYPE2__SHARED0) || defined(SOURCE_INPUT_TYPE2__SHARED1))
    bgfx_FragColor = vec4(mix((mix(mix(mix(var_5fabd.xyz, var_5fabd.xyz, vec3(var_14565.w)).xyz, var_5fabd.xyz, vec3(var_21705.w)).xyz, OverlayColor.xyz, vec3(var_621ea.w)).xyz * v_light.xyz).xyz, v_fog.xyz, vec3(var_3a2c6.w)), var_5fabd.w);
#endif
}
