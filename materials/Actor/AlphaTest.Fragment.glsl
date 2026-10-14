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
* - EMISSIVE__EMISSIVE
* - EMISSIVE__EMISSIVE_ONLY
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
float var_33fae;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
#ifdef MASKED_MULTITEXTURE__ON
uniform highp sampler2D s_MatTexture1;
#endif
uniform highp sampler2D s_MatTexture;
#if !defined(CHANGE_COLOR__OFF) || !defined(EMISSIVE__OFF)
uniform highp vec4 ActorFPEpsilon;
#endif
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 MatColor;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TintedAlphaTestEnabled;
uniform highp vec4 UseAlphaRewrite;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_light;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef EMISSIVE__EMISSIVE
    highp vec4 var_a25d1 = texture(s_MatTexture, v_texcoord0);
#endif
#if defined(EMISSIVE__EMISSIVE) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_d9ac1 = MatColor * var_a25d1;
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_174cf = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_f3ddc = var_174cf;
#endif
#if defined(EMISSIVE__EMISSIVE) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_4f88d = var_d9ac1;
#endif
#if defined(EMISSIVE__EMISSIVE) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_d9ac1 = mix(var_174cf, MatColor * var_a25d1, vec4(float((((var_f3ddc.x + var_f3ddc.y) + var_f3ddc.z) * (1.0 - var_f3ddc.w)) > 0.0)));
    highp vec4 var_4f88d = var_d9ac1;
#endif
#if defined(MASKED_MULTITEXTURE__OFF) && !defined(EMISSIVE__EMISSIVE)
    highp vec4 var_4f88d = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#if defined(MASKED_MULTITEXTURE__ON) && !defined(EMISSIVE__EMISSIVE)
    highp vec4 var_4f88d = mix(var_174cf, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_f3ddc.x + var_f3ddc.y) + var_f3ddc.z) * (1.0 - var_f3ddc.w)) > 0.0)));
#endif
#ifdef EMISSIVE__EMISSIVE_ONLY
    highp float var_a8620 = mix(var_4f88d.w, var_4f88d.w * OverlayColor.w, TintedAlphaTestEnabled.x);
    bool var_e7bf9 = var_a8620 < ActorFPEpsilon.x;
    bool var_bd07c;
    if (!var_e7bf9)
    {
        var_bd07c = var_a8620 > (1.0 - ActorFPEpsilon.x);
    }
    else
    {
        var_bd07c = var_e7bf9;
    }
#endif
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_e194d;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec2 var_2c6b3 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_2c6b3 * 0.25);
        highp vec2 var_85686 = floor(var_2c6b3 * 0.5);
        highp vec2 var_09c49 = floor(var_2c6b3);
        var_e194d = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_e194d = false;
    }
#ifdef EMISSIVE__EMISSIVE
    if (var_e194d || (dot(vec4(var_d9ac1.xyz, mix(var_4f88d.w, var_4f88d.w * OverlayColor.w, TintedAlphaTestEnabled.x)), vec4(1.0)) < ActorFPEpsilon.x))
#endif
#ifdef EMISSIVE__EMISSIVE_ONLY
    if (var_e194d || var_bd07c)
#endif
#if defined(EMISSIVE__OFF) && !defined(CHANGE_COLOR__OFF)
    if (var_e194d || (mix(var_4f88d.w, var_4f88d.w * OverlayColor.w, TintedAlphaTestEnabled.x) < ActorFPEpsilon.x))
#endif
#if defined(CHANGE_COLOR__OFF) && defined(EMISSIVE__OFF)
    if (var_e194d || (mix(var_4f88d.w, var_4f88d.w * OverlayColor.w, TintedAlphaTestEnabled.x) < 0.5))
#endif
    {
        discard;
    }
#ifndef CHANGE_COLOR__MULTI
    highp vec4 var_c65ea = var_4f88d;
#endif
#ifdef CHANGE_COLOR__MULTI
    highp vec4 var_a6909 = var_4f88d;
    highp vec2 var_e1236 = var_4f88d.xy;
    highp vec3 var_728f2 = var_4f88d.xxx * ChangeColor.xyz;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp float var_e3254 = var_c65ea.w;
    highp vec3 var_618b0 = mix(var_4f88d.xyz, var_4f88d.xyz * ChangeColor.xyz, vec3(var_e3254));
#endif
#ifdef CHANGE_COLOR__MULTI
    var_a6909.x = var_728f2.x;
#endif
#ifdef CHANGE_COLOR__ON
    var_c65ea.x = var_618b0.x;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_a6909.y = var_728f2.y;
#endif
#ifdef CHANGE_COLOR__ON
    var_c65ea.y = var_618b0.y;
    var_c65ea.z = var_618b0.z;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_a6909.z = var_728f2.z;
    highp vec4 var_60355 = var_a6909;
    highp vec3 var_ef570 = mix(var_60355.xyz, var_4f88d.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_e1236.y)));
    var_a6909.x = var_ef570.x;
    var_a6909.y = var_ef570.y;
    var_a6909.z = var_ef570.z;
    highp vec4 var_c65ea = var_a6909;
#endif
#ifdef CHANGE_COLOR__ON
    var_c65ea.w *= var_8a135.w;
#endif
    var_c65ea.w = max(UseAlphaRewrite.x, var_c65ea.w);
    var_4f88d = var_c65ea;
    highp vec4 var_f4172 = var_c65ea;
    highp vec3 var_6f9dd = var_c65ea.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
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
    highp vec4 var_72c1b = var_4b012;
    highp vec3 var_c6e56 = mix(var_4b012.xyz, v_fog.xyz, vec3(v_fog.w));
    var_72c1b.x = var_c6e56.x;
    var_72c1b.y = var_c6e56.y;
    var_72c1b.z = var_c6e56.z;
    bgfx_FragData0 = var_72c1b;
}
