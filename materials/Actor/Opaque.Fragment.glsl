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
* - EMISSIVE__EMISSIVE (not used)
* - EMISSIVE__EMISSIVE_ONLY (not used)
* - EMISSIVE__OFF
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
* - uniform vec4 UseAlphaRewrite;
*/

precision mediump float;
precision highp int;
#ifdef MASKED_MULTITEXTURE__ON
uniform highp sampler2D s_MatTexture1;
#endif
uniform highp sampler2D s_MatTexture;
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 MatColor;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_color0;
in highp vec4 v_fog;
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
#endif
#ifdef CHANGE_COLOR__MULTI
    var_3096f.x = var_728f2.x;
#endif
#ifdef CHANGE_COLOR__ON
    var_65640.x = var_618b0.x;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_3096f.y = var_728f2.y;
#endif
#ifdef CHANGE_COLOR__ON
    var_65640.y = var_618b0.y;
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
    highp vec4 var_f4172 = var_65640;
    highp vec3 var_6f9dd = var_65640.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    var_f4172.x = var_6f9dd.x;
    var_f4172.y = var_6f9dd.y;
    var_f4172.z = var_6f9dd.z;
    highp vec4 var_f8661 = var_f4172;
    highp vec3 var_2a9cf = mix(var_f4172.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_f8661.x = var_2a9cf.x;
    var_f8661.y = var_2a9cf.y;
    var_f8661.z = var_2a9cf.z;
#ifdef EMISSIVE__OFF
    highp vec4 var_f1c11 = var_f8661;
#endif
#ifndef EMISSIVE__OFF
    highp vec4 var_ec73b = var_f8661;
    highp vec4 var_f1c11 = var_f8661;
    highp vec3 var_d2dfa = var_f8661.xyz * mix(vec4(1.0), v_light, vec4(var_ec73b.w)).xyz;
#endif
#ifdef EMISSIVE__OFF
    highp vec3 var_d2dfa = var_f8661.xyz * v_light.xyz;
#endif
    var_f1c11.x = var_d2dfa.x;
    var_f1c11.y = var_d2dfa.y;
    var_f1c11.z = var_d2dfa.z;
#ifdef EMISSIVE__OFF
    var_f4172 = var_f1c11;
#endif
#ifndef EMISSIVE__OFF
    var_ec73b = var_f1c11;
    var_f4172 = var_f1c11;
#endif
    highp vec4 var_1d587 = var_f1c11;
    highp vec4 var_4b012 = vec4(var_f1c11.xyz, var_1d587.w);
    highp vec4 var_65069 = var_4b012;
    highp vec3 var_c6e56 = mix(var_4b012.xyz, v_fog.xyz, vec3(v_fog.w));
    var_65069.x = var_c6e56.x;
    var_65069.y = var_c6e56.y;
    var_65069.z = var_c6e56.z;
    var_65069.w = 1.0;
    bgfx_FragData0 = var_65069;
}
