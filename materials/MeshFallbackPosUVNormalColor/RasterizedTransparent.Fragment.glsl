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
* - uniform vec4 AlphaMaskedTint;
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
uniform highp vec4 AlphaMaskedTint;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 CurrentColor;
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
    highp vec4 var_4e612 = v_color;
#ifdef USE_TEXTURES__OFF
    highp vec4 var_13425 = vec4(1.0);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_13425 = texture(s_MatTexture, v_texCoords);
#endif
#ifndef ALPHA_TEST__OFF
    highp vec2 var_ded9f = DitherParams2[1].xy;
    bool var_54432;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp vec4 var_75953 = v_clipPosition;
        highp vec2 var_376f6 = floor(((((v_clipPosition.xyz / vec3(var_75953.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[1].z)) * DitherParams2[1].z;
        highp vec2 var_c27b1 = floor(var_376f6 * 0.25);
        highp vec2 var_a5f3b = floor(var_376f6 * 0.5);
        highp vec2 var_ccfe4 = floor(var_376f6);
        var_54432 = smoothstep(var_ded9f.x, var_ded9f.y, dot(-normalize(vec3(View[0].z, View[1].z, View[2].z)), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_c27b1.x * 0.5) + ((var_c27b1.y * var_c27b1.y) * 0.75)) * 0.25) + fract((var_a5f3b.x * 0.5) + ((var_a5f3b.y * var_a5f3b.y) * 0.75))) * 0.25) + fract((var_ccfe4.x * 0.5) + ((var_ccfe4.y * var_ccfe4.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_54432 = false;
    }
    if (!(AlphaMaskedTint.x != 0.0))
    {
#endif
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
        if ((var_13425.w < DiscardValue.x) || var_54432)
#endif
#ifdef ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
        if ((var_13425.w <= 0.0) || var_54432)
#endif
#ifndef ALPHA_TEST__OFF
        {
            discard;
        }
    }
#endif
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_e0f55 = mix(var_13425.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_6841b = var_13425.xy;
    highp vec3 var_e0f55 = mix(mix((var_13425.xxx * v_color.xyz).xyz, var_13425.yyy * ChangeColor.xyz, vec3(ceil(var_6841b.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
#endif
#ifdef LIT__OFF
    var_13425 = vec4(var_e0f55.x, var_e0f55.y, var_e0f55.z, var_13425.w);
#endif
#ifdef LIT__ON
    var_13425 = vec4(var_e0f55.x, var_e0f55.y, var_e0f55.z, var_13425.w) * v_light;
#endif
    if (AlphaMaskedTint.x != 0.0)
    {
        highp vec3 var_a1ec2 = (CurrentColor.xyz * mix(var_13425.xyz, var_13425.xyz * v_color.xyz, vec3(var_13425.w))).xyz * var_4e612.w;
        var_13425 = vec4(var_a1ec2.x, var_a1ec2.y, var_a1ec2.z, var_13425.w);
        var_13425.w = 1.0;
    }
#ifdef MULTI_COLOR_TINT__OFF
    else
    {
        var_13425 = (CurrentColor * v_color) * var_13425;
    }
#endif
    var_13425.w *= HudOpacity.x;
    highp vec4 var_6ca24 = v_fog;
    highp vec3 var_14685 = mix(var_13425.xyz, v_fog.xyz, vec3(var_6ca24.w));
    bgfx_FragColor = vec4(var_14685.x, var_14685.y, var_14685.z, var_13425.w);
}
