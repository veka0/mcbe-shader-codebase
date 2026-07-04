#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS (not used)
* - RASTERIZED_OPAQUE_PASS (not used)
* - RASTERIZED_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
*
* Lit:
* - LIT__OFF
* - LIT__ON
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF
* - MULTI_COLOR_TINT__ON
*
* UseTextures:
* - USE_TEXTURES__OFF
* - USE_TEXTURES__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 ChangeColor;
* - uniform vec4 CurrentColor;
* - uniform vec4 DiscardValue;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 HudOpacity;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 UVAnimation;
* - uniform vec4 ZShiftValue;
*/

precision mediump float;
precision highp int;
#if defined(ALPHA_TEST__OFF) && defined(USE_TEXTURES__ON)
uniform highp sampler2D s_MatTexture;
#endif
#ifndef ALPHA_TEST__OFF
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
#endif
#if defined(USE_TEXTURES__ON) && !defined(ALPHA_TEST__OFF)
uniform highp sampler2D s_MatTexture;
#endif
#ifdef MULTI_COLOR_TINT__OFF
uniform highp vec4 CurrentColor;
#endif
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 ChangeColor;
#endif
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
uniform highp vec4 DiscardValue;
#endif
#ifndef ALPHA_TEST__OFF
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
#endif
uniform highp vec4 HudOpacity;
uniform highp vec4 OverlayColor;
#ifndef ALPHA_TEST__OFF
in highp vec4 v_clipPosition;
#endif
in highp vec4 v_color;
in highp vec4 v_fog;
#if defined(LIT__OFF) && defined(USE_TEXTURES__ON)
centroid in highp vec2 v_texCoords;
#endif
#ifdef LIT__ON
in highp vec4 v_light;
#endif
#if defined(LIT__ON) && defined(USE_TEXTURES__ON)
centroid in highp vec2 v_texCoords;
#endif
#ifndef ALPHA_TEST__OFF
in highp vec3 v_worldPos;
#endif
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifndef ALPHA_TEST__OFF
    highp mat4 View = u_view;
#endif
#ifdef USE_TEXTURES__OFF
    highp vec4 var_7a57b = vec4(1.0);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_7a57b = texture(s_MatTexture, v_texCoords);
#endif
#ifndef ALPHA_TEST__OFF
    highp vec2 var_ded9f = DitherParams2[1].xy;
    bool var_f0b07;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp vec4 var_75953 = v_clipPosition;
        highp vec2 var_376f6 = floor(((((v_clipPosition.xyz / vec3(var_75953.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[1].z)) * DitherParams2[1].z;
        highp vec2 var_c27b1 = floor(var_376f6 * 0.25);
        highp vec2 var_a5f3b = floor(var_376f6 * 0.5);
        highp vec2 var_ccfe4 = floor(var_376f6);
        var_f0b07 = smoothstep(var_ded9f.x, var_ded9f.y, dot(-normalize(vec3(View[0].z, View[1].z, View[2].z)), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_c27b1.x * 0.5) + ((var_c27b1.y * var_c27b1.y) * 0.75)) * 0.25) + fract((var_a5f3b.x * 0.5) + ((var_a5f3b.y * var_a5f3b.y) * 0.75))) * 0.25) + fract((var_ccfe4.x * 0.5) + ((var_ccfe4.y * var_ccfe4.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_f0b07 = false;
    }
#endif
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
    if ((var_7a57b.w < DiscardValue.x) || var_f0b07)
#endif
#ifdef ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
    if ((var_7a57b.w <= 0.0) || var_f0b07)
#endif
#ifndef ALPHA_TEST__OFF
    {
        discard;
    }
#endif
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_87e86 = mix(var_7a57b.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
#endif
#if defined(LIT__OFF) && defined(MULTI_COLOR_TINT__OFF)
    var_7a57b = (CurrentColor * v_color) * vec4(var_87e86.x, var_87e86.y, var_87e86.z, var_7a57b.w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_6841b = var_7a57b.xy;
    highp vec3 var_470a3 = mix(mix((var_7a57b.xxx * v_color.xyz).xyz, var_7a57b.yyy * ChangeColor.xyz, vec3(ceil(var_6841b.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
#endif
#if defined(LIT__OFF) && defined(MULTI_COLOR_TINT__ON)
    var_7a57b = vec4(var_470a3.x, var_470a3.y, var_470a3.z, var_7a57b.w);
#endif
#if defined(LIT__ON) && defined(MULTI_COLOR_TINT__OFF)
    var_7a57b = (CurrentColor * v_color) * (vec4(var_87e86.x, var_87e86.y, var_87e86.z, var_7a57b.w) * v_light);
#endif
#if defined(LIT__ON) && defined(MULTI_COLOR_TINT__ON)
    var_7a57b = vec4(var_470a3.x, var_470a3.y, var_470a3.z, var_7a57b.w) * v_light;
#endif
    var_7a57b.w *= HudOpacity.x;
    highp vec4 var_6ca24 = v_fog;
    highp vec3 var_14685 = mix(var_7a57b.xyz, v_fog.xyz, vec3(var_6ca24.w));
    bgfx_FragColor = vec4(var_14685.x, var_14685.y, var_14685.z, var_7a57b.w);
}
