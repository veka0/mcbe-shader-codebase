#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
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
float var_238cd;
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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_d358e = vec4(0.0);
#ifdef USE_TEXTURES__OFF
    highp vec4 var_c2e9e = vec4(1.0);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_c2e9e = texture(s_MatTexture, v_texCoords);
#endif
#ifndef ALPHA_TEST__OFF
    if (!(AlphaMaskedTint.x != 0.0))
    {
        highp vec2 var_3adfc = DitherParams2[1].xy;
        bool var_1d432;
        if (DitheringEnabledToggle.x != 0.0)
        {
            highp mat4 var_24edd = u_view;
            highp vec2 var_048e4 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[1].z)) * DitherParams2[1].z;
            highp vec2 var_c55b8 = floor(var_048e4 * 0.25);
            highp vec2 var_63b62 = floor(var_048e4 * 0.5);
            highp vec2 var_5fe78 = floor(var_048e4);
            var_1d432 = smoothstep(var_3adfc.x, var_3adfc.y, dot(-normalize(vec4(var_24edd[0].z, var_24edd[1].z, var_24edd[2].z, var_238cd).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_c55b8.x * 0.5) + ((var_c55b8.y * var_c55b8.y) * 0.75)) * 0.25) + fract((var_63b62.x * 0.5) + ((var_63b62.y * var_63b62.y) * 0.75))) * 0.25) + fract((var_5fe78.x * 0.5) + ((var_5fe78.y * var_5fe78.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
        }
        else
        {
            var_1d432 = false;
        }
#endif
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
        if ((var_c2e9e.w < DiscardValue.x) || var_1d432)
#endif
#ifdef ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
        if ((var_c2e9e.w <= 0.0) || var_1d432)
#endif
#ifndef ALPHA_TEST__OFF
        {
            discard;
        }
    }
#endif
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_43907 = var_c2e9e;
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_fbfc0 = var_c2e9e;
    highp vec2 var_5bae6 = var_fbfc0.xy;
    highp vec3 var_0cc48 = var_fbfc0.xxx * v_color.xyz;
    var_c2e9e.x = var_0cc48.x;
    var_c2e9e.y = var_0cc48.y;
    var_c2e9e.z = var_0cc48.z;
    highp vec4 var_c3ac5 = var_c2e9e;
    highp vec3 var_c928b = mix(var_c3ac5.xyz, var_fbfc0.yyy * ChangeColor.xyz, vec3(ceil(var_5bae6.y)));
    var_c2e9e.x = var_c928b.x;
    var_c2e9e.y = var_c928b.y;
    var_c2e9e.z = var_c928b.z;
    highp vec4 var_43907 = var_c2e9e;
#endif
    highp vec3 var_2a9cf = mix(var_43907.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_c2e9e.x = var_2a9cf.x;
    var_c2e9e.y = var_2a9cf.y;
    var_c2e9e.z = var_2a9cf.z;
#ifdef LIT__ON
    var_c2e9e *= v_light;
#endif
    if (AlphaMaskedTint.x != 0.0)
    {
        highp vec4 var_27464 = var_c2e9e;
        highp float var_49bb2 = var_c2e9e.w;
        highp vec3 var_905e7 = CurrentColor.xyz * mix(var_27464.xyz, var_27464.xyz * v_color.xyz, vec3(var_49bb2));
        var_c2e9e.x = var_905e7.x;
        var_c2e9e.y = var_905e7.y;
        var_c2e9e.z = var_905e7.z;
        highp vec4 var_e9c42 = var_c2e9e;
        highp vec3 var_b0b3b = var_e9c42.xyz * v_color.w;
        var_c2e9e.x = var_b0b3b.x;
        var_c2e9e.y = var_b0b3b.y;
        var_c2e9e.z = var_b0b3b.z;
        var_c2e9e.w = 1.0;
    }
#ifdef MULTI_COLOR_TINT__OFF
    else
    {
        var_c2e9e = (CurrentColor * v_color) * var_c2e9e;
    }
#endif
    var_c2e9e.w *= HudOpacity.x;
    var_d358e = var_c2e9e;
    highp vec3 var_c6e56 = mix(var_c2e9e.xyz, v_fog.xyz, vec3(v_fog.w));
    var_d358e.x = var_c6e56.x;
    var_d358e.y = var_c6e56.y;
    var_d358e.z = var_c6e56.z;
    bgfx_FragData0 = var_d358e;
}
