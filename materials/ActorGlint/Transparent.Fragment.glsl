#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Change_Color:
* - CHANGE_COLOR__MULTI
* - CHANGE_COLOR__OFF
* - CHANGE_COLOR__ON
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF
* - MASKED_MULTITEXTURE__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_MatTexture1;
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform vec4 BlockLightColor;
* - uniform mat4 Bones[8];
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 GlintColor;
* - uniform vec4 HudOpacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
* - uniform vec4 UseAlphaRewrite;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture1;
uniform highp sampler2D s_MatTexture;
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 GlintColor;
uniform highp vec4 HudOpacity;
uniform highp vec4 MatColor;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightColor;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_layerUv;
in highp vec4 v_light;
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#if defined(MASKED_MULTITEXTURE__OFF) && !defined(CHANGE_COLOR__OFF)
    highp vec4 var_663d1 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#if defined(CHANGE_COLOR__OFF) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_65640 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_7fef3 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_0b7d3 = var_7fef3;
#endif
#if defined(CHANGE_COLOR__MULTI) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_3096f = var_663d1;
#endif
#if defined(CHANGE_COLOR__ON) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_65640 = var_663d1;
#endif
#if defined(MASKED_MULTITEXTURE__ON) && !defined(CHANGE_COLOR__OFF)
    highp vec4 var_663d1 = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#if defined(CHANGE_COLOR__OFF) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_65640 = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#if defined(CHANGE_COLOR__MULTI) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_3096f = var_663d1;
#endif
#if defined(CHANGE_COLOR__ON) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_65640 = var_663d1;
#endif
#ifdef CHANGE_COLOR__MULTI
    highp vec2 var_e1236 = var_663d1.xy;
    highp vec3 var_728f2 = var_663d1.xxx * ChangeColor.xyz;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp float var_e3254 = var_65640.w;
    highp vec3 var_618b0 = mix(var_663d1.xyz, var_663d1.xyz * ChangeColor.xyz, vec3(var_e3254));
    var_65640.x = var_618b0.x;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_3096f.x = var_728f2.x;
#endif
#ifdef CHANGE_COLOR__ON
    var_65640.y = var_618b0.y;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_3096f.y = var_728f2.y;
#endif
#ifdef CHANGE_COLOR__ON
    var_65640.z = var_618b0.z;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_3096f.z = var_728f2.z;
    highp vec4 var_60355 = var_3096f;
    highp vec3 var_ef570 = mix(var_60355.xyz, var_663d1.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_e1236.y)));
    var_3096f.x = var_ef570.x;
    var_3096f.y = var_ef570.y;
    var_3096f.z = var_ef570.z;
    highp vec4 var_65640 = var_3096f;
#endif
#ifdef CHANGE_COLOR__ON
    var_65640.w *= var_8a135.w;
#endif
    var_65640.w = max(0.0, var_65640.w);
    highp vec4 var_bf684 = var_65640;
    highp vec3 var_6f9dd = var_65640.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    var_bf684.x = var_6f9dd.x;
    var_bf684.y = var_6f9dd.y;
    var_bf684.z = var_6f9dd.z;
    highp vec4 var_a42ab = var_bf684;
    highp vec3 var_2a9cf = mix(var_bf684.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_a42ab.x = var_2a9cf.x;
    var_a42ab.y = var_2a9cf.y;
    var_a42ab.z = var_2a9cf.z;
    highp vec4 var_60f01 = var_a42ab;
    highp vec3 var_279b1 = var_a42ab.xyz * v_light.xyz;
    var_60f01.x = var_279b1.x;
    var_60f01.y = var_279b1.y;
    var_60f01.z = var_279b1.z;
    var_bf684 = var_60f01;
    highp vec4 var_a2360 = (GlintColor * (texture(s_MatTexture1, fract(v_layerUv.xy)).xyzx + texture(s_MatTexture1, fract(v_layerUv.zw)).xyzx)) * TileLightColor;
    highp vec4 var_edd83 = vec4(var_a2360.xyz * var_a2360.xyz, abs(var_a2360.w)) + vec4(var_60f01.xyz, 0.0);
    var_edd83.w = var_60f01.w;
    highp vec4 var_f83be = var_edd83;
    highp vec4 var_94f91 = vec4(var_edd83.xyz, var_f83be.w * HudOpacity.x);
    highp vec4 var_72c1b = var_94f91;
    highp vec3 var_c6e56 = mix(var_94f91.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_c6e56.x;
    var_72c1b.y = var_c6e56.y;
    var_72c1b.z = var_c6e56.z;
    bgfx_FragData0 = var_72c1b;
}
