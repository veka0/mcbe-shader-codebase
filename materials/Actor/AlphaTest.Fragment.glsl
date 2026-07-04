#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
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
* - uniform vec4 MaterialID;
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
layout(location = 0) out highp vec4 bgfx_FragColor;
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
    highp vec4 var_c81f0 = var_d9ac1;
#endif
#if defined(EMISSIVE__EMISSIVE) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_d9ac1 = mix(var_174cf, MatColor * var_a25d1, vec4(float((((var_f3ddc.x + var_f3ddc.y) + var_f3ddc.z) * (1.0 - var_f3ddc.w)) > 0.0)));
    highp vec4 var_c81f0 = var_d9ac1;
#endif
#if defined(MASKED_MULTITEXTURE__OFF) && !defined(EMISSIVE__EMISSIVE)
    highp vec4 var_c81f0 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#if defined(MASKED_MULTITEXTURE__ON) && !defined(EMISSIVE__EMISSIVE)
    highp vec4 var_c81f0 = mix(var_174cf, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_f3ddc.x + var_f3ddc.y) + var_f3ddc.z) * (1.0 - var_f3ddc.w)) > 0.0)));
#endif
#ifdef EMISSIVE__EMISSIVE_ONLY
    highp float var_a8620 = mix(var_c81f0.w, var_c81f0.w * OverlayColor.w, TintedAlphaTestEnabled.x);
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
        highp vec4 var_d36cf = v_clipPosition;
        highp vec2 var_886c2 = floor(((((v_clipPosition.xyz / vec3(var_d36cf.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_886c2 * 0.25);
        highp vec2 var_85686 = floor(var_886c2 * 0.5);
        highp vec2 var_09c49 = floor(var_886c2);
        var_e194d = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_e194d = false;
    }
#ifdef EMISSIVE__EMISSIVE
    if (var_e194d || (dot(vec4(var_d9ac1.xyz, mix(var_c81f0.w, var_c81f0.w * OverlayColor.w, TintedAlphaTestEnabled.x)), vec4(1.0)) < ActorFPEpsilon.x))
#endif
#ifdef EMISSIVE__EMISSIVE_ONLY
    if (var_e194d || var_bd07c)
#endif
#if defined(EMISSIVE__OFF) && !defined(CHANGE_COLOR__OFF)
    if (var_e194d || (mix(var_c81f0.w, var_c81f0.w * OverlayColor.w, TintedAlphaTestEnabled.x) < ActorFPEpsilon.x))
#endif
#if defined(CHANGE_COLOR__OFF) && defined(EMISSIVE__OFF)
    if (var_e194d || (mix(var_c81f0.w, var_c81f0.w * OverlayColor.w, TintedAlphaTestEnabled.x) < 0.5))
#endif
    {
        discard;
    }
#ifdef CHANGE_COLOR__MULTI
    highp vec2 var_459de = var_c81f0.xy;
    highp vec3 var_1099e = mix((var_c81f0.xxx * ChangeColor.xyz).xyz, var_c81f0.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_459de.y)));
    highp vec4 var_776bd = vec4(var_1099e.x, var_1099e.y, var_1099e.z, var_c81f0.w);
#endif
#ifndef CHANGE_COLOR__MULTI
    highp vec4 var_776bd = var_c81f0;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp vec3 var_fba6e = mix(var_c81f0.xyz, var_c81f0.xyz * ChangeColor.xyz, vec3(var_776bd.w));
    var_776bd = vec4(var_fba6e.x, var_fba6e.y, var_fba6e.z, var_c81f0.w);
    var_776bd.w *= var_8a135.w;
#endif
    var_776bd.w = max(UseAlphaRewrite.x, var_776bd.w);
    var_c81f0 = var_776bd;
#ifndef EMISSIVE__OFF
    highp vec3 var_f5435 = mix((var_776bd.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
#endif
#ifdef EMISSIVE__OFF
    highp vec3 var_f5435 = mix((var_776bd.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
#endif
    highp vec4 var_2673a = vec4(var_f5435.x, var_f5435.y, var_f5435.z, var_776bd.w);
#ifndef EMISSIVE__OFF
    highp float var_4c6fb = var_2673a.w;
    highp vec3 var_4a75a = var_f5435.xyz * mix(vec4(1.0), v_light, vec4(var_4c6fb)).xyz;
    highp vec4 var_b626b = vec4(var_4a75a.x, var_4a75a.y, var_4a75a.z, var_776bd.w);
    var_2673a = var_b626b;
    highp vec4 var_b86af = var_b626b;
#endif
    highp vec4 var_f5291 = v_fog;
#ifndef EMISSIVE__OFF
    bgfx_FragColor = vec4(mix(vec4(var_4a75a, var_b86af.w).xyz, v_fog.xyz, vec3(var_f5291.w)), var_b86af.w);
#endif
#ifdef EMISSIVE__OFF
    bgfx_FragColor = vec4(mix(vec4(var_f5435, var_2673a.w).xyz, v_fog.xyz, vec3(var_f5291.w)), var_2673a.w);
#endif
}
