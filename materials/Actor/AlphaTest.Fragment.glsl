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
* - uniform mat4 Bones[8];
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
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
uniform highp vec4 MatColor;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TintedAlphaTestEnabled;
uniform highp vec4 UseAlphaRewrite;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_light;
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#if defined(EMISSIVE__EMISSIVE) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_e462f = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#if defined(MASKED_MULTITEXTURE__OFF) && !defined(EMISSIVE__EMISSIVE)
    highp vec4 var_288ae = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_7fef3 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_0b7d3 = var_7fef3;
#endif
#if defined(EMISSIVE__EMISSIVE) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_288ae = var_e462f;
#endif
#if defined(MASKED_MULTITEXTURE__ON) && !defined(EMISSIVE__EMISSIVE)
    highp vec4 var_288ae = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#if defined(EMISSIVE__EMISSIVE) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_e462f = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
    highp vec4 var_288ae = var_e462f;
#endif
#ifdef EMISSIVE__EMISSIVE
    if (dot(vec4(var_e462f.xyz, mix(var_288ae.w, var_288ae.w * OverlayColor.w, TintedAlphaTestEnabled.x)), vec4(1.0)) < ActorFPEpsilon.x)
#endif
#ifdef EMISSIVE__EMISSIVE_ONLY
    highp float var_a8620 = mix(var_288ae.w, var_288ae.w * OverlayColor.w, TintedAlphaTestEnabled.x);
    bool var_e7bf9 = var_a8620 < ActorFPEpsilon.x;
    bool var_330ac;
    if (!var_e7bf9)
#endif
#if defined(EMISSIVE__OFF) && !defined(CHANGE_COLOR__OFF)
    if (mix(var_288ae.w, var_288ae.w * OverlayColor.w, TintedAlphaTestEnabled.x) < ActorFPEpsilon.x)
#endif
#if defined(CHANGE_COLOR__OFF) && defined(EMISSIVE__OFF)
    if (mix(var_288ae.w, var_288ae.w * OverlayColor.w, TintedAlphaTestEnabled.x) < 0.5)
#endif
    {
#ifdef EMISSIVE__EMISSIVE_ONLY
        var_330ac = var_a8620 > (1.0 - ActorFPEpsilon.x);
    }
    else
    {
        var_330ac = var_e7bf9;
    }
    if (var_330ac)
    {
#endif
        discard;
    }
#ifdef CHANGE_COLOR__MULTI
    highp vec2 var_459de = var_288ae.xy;
    highp vec3 var_1099e = mix((var_288ae.xxx * ChangeColor.xyz).xyz, var_288ae.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_459de.y)));
    highp vec4 var_776bd = vec4(var_1099e.x, var_1099e.y, var_1099e.z, var_288ae.w);
#endif
#ifndef CHANGE_COLOR__MULTI
    highp vec4 var_776bd = var_288ae;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp vec3 var_fba6e = mix(var_288ae.xyz, var_288ae.xyz * ChangeColor.xyz, vec3(var_776bd.w));
    var_776bd = vec4(var_fba6e.x, var_fba6e.y, var_fba6e.z, var_288ae.w);
    var_776bd.w *= var_8a135.w;
#endif
    var_776bd.w = max(UseAlphaRewrite.x, var_776bd.w);
    var_288ae = var_776bd;
#ifndef EMISSIVE__OFF
    highp vec3 var_5d005 = mix((var_776bd.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
#endif
#ifdef EMISSIVE__OFF
    highp vec3 var_5d005 = mix((var_776bd.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
#endif
    highp vec4 var_b9108 = vec4(var_5d005.x, var_5d005.y, var_5d005.z, var_776bd.w);
#ifndef EMISSIVE__OFF
    highp float var_4c6fb = var_b9108.w;
    highp vec3 var_1325b = var_5d005.xyz * mix(vec4(1.0), v_light, vec4(var_4c6fb)).xyz;
    highp vec4 var_b626b = vec4(var_1325b.x, var_1325b.y, var_1325b.z, var_776bd.w);
    var_b9108 = var_b626b;
    highp vec4 var_ab9d7 = var_b626b;
    highp vec4 var_1a4b7 = vec4(var_1325b, var_ab9d7.w);
#endif
#ifdef EMISSIVE__OFF
    highp vec4 var_1a4b7 = vec4(var_5d005, var_b9108.w);
#endif
    highp vec4 var_6ca24 = v_fog;
    highp vec3 var_14685 = mix(var_1a4b7.xyz, v_fog.xyz, vec3(var_6ca24.w));
    bgfx_FragColor = vec4(var_14685.x, var_14685.y, var_14685.z, var_1a4b7.w);
}
