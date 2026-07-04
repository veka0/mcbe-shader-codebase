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
#ifdef USE_TEXTURES__ON
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
uniform highp vec4 HudOpacity;
uniform highp vec4 OverlayColor;
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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#if defined(ALPHA_TEST__OFF) && defined(MULTI_COLOR_TINT__OFF) && defined(USE_TEXTURES__OFF)
    highp vec3 var_698d4 = mix(vec3(1.0), OverlayColor.xyz, vec3(OverlayColor.w));
#endif
#if defined(ALPHA_TEST__OFF) && defined(LIT__OFF) && defined(MULTI_COLOR_TINT__OFF) && defined(USE_TEXTURES__OFF)
    highp vec4 var_5aff5 = (CurrentColor * v_color) * vec4(var_698d4.x, var_698d4.y, var_698d4.z, vec4(1.0).w);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_5aff5 = texture(s_MatTexture, v_texCoords);
#endif
#if defined(USE_TEXTURES__OFF) && !defined(ALPHA_TEST__OFF)
    highp vec4 var_5aff5 = vec4(1.0);
#endif
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
    if (var_5aff5.w < DiscardValue.x)
#endif
#ifdef ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
    if (var_5aff5.w <= 0.0)
#endif
#ifndef ALPHA_TEST__OFF
    {
        discard;
    }
#endif
#if defined(MULTI_COLOR_TINT__OFF) && (defined(USE_TEXTURES__ON) || !defined(ALPHA_TEST__OFF))
    highp vec3 var_b8e0a = mix(var_5aff5.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
#endif
#if defined(ALPHA_TEST__OFF) && defined(LIT__OFF) && defined(MULTI_COLOR_TINT__OFF) && defined(USE_TEXTURES__ON)
    highp vec4 var_86d2a = (CurrentColor * v_color) * vec4(var_b8e0a.x, var_b8e0a.y, var_b8e0a.z, var_5aff5.w);
#endif
#if defined(ALPHA_TEST__OFF) && defined(MULTI_COLOR_TINT__ON) && defined(USE_TEXTURES__OFF)
    highp vec2 var_f4024 = vec2(1.0);
    highp vec3 var_94055 = mix(mix(v_color.xyz, ChangeColor.xyz, vec3(ceil(var_f4024.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
#endif
#if defined(ALPHA_TEST__OFF) && defined(LIT__OFF) && defined(MULTI_COLOR_TINT__ON) && defined(USE_TEXTURES__OFF)
    highp vec4 var_5aff5 = vec4(var_94055.x, var_94055.y, var_94055.z, vec4(1.0).w);
#endif
#if defined(MULTI_COLOR_TINT__ON) && (defined(USE_TEXTURES__ON) || !defined(ALPHA_TEST__OFF))
    highp vec2 var_6841b = var_5aff5.xy;
    highp vec3 var_03b9e = mix(mix((var_5aff5.xxx * v_color.xyz).xyz, var_5aff5.yyy * ChangeColor.xyz, vec3(ceil(var_6841b.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
#endif
#if defined(ALPHA_TEST__OFF) && defined(LIT__OFF) && defined(MULTI_COLOR_TINT__ON) && defined(USE_TEXTURES__ON)
    highp vec4 var_86d2a = vec4(var_03b9e.x, var_03b9e.y, var_03b9e.z, var_5aff5.w);
#endif
#if defined(ALPHA_TEST__OFF) && defined(LIT__ON) && defined(MULTI_COLOR_TINT__OFF) && defined(USE_TEXTURES__OFF)
    highp vec4 var_5aff5 = (CurrentColor * v_color) * (vec4(var_698d4.x, var_698d4.y, var_698d4.z, vec4(1.0).w) * v_light);
#endif
#if defined(ALPHA_TEST__OFF) && defined(LIT__ON) && defined(MULTI_COLOR_TINT__OFF) && defined(USE_TEXTURES__ON)
    highp vec4 var_86d2a = (CurrentColor * v_color) * (vec4(var_b8e0a.x, var_b8e0a.y, var_b8e0a.z, var_5aff5.w) * v_light);
#endif
#if defined(ALPHA_TEST__OFF) && defined(LIT__ON) && defined(MULTI_COLOR_TINT__ON) && defined(USE_TEXTURES__OFF)
    highp vec4 var_5aff5 = vec4(var_94055.x, var_94055.y, var_94055.z, vec4(1.0).w) * v_light;
#endif
#if defined(ALPHA_TEST__OFF) && defined(LIT__ON) && defined(MULTI_COLOR_TINT__ON) && defined(USE_TEXTURES__ON)
    highp vec4 var_86d2a = vec4(var_03b9e.x, var_03b9e.y, var_03b9e.z, var_5aff5.w) * v_light;
#endif
#if defined(LIT__OFF) && defined(MULTI_COLOR_TINT__OFF) && !defined(ALPHA_TEST__OFF)
    var_5aff5 = (CurrentColor * v_color) * vec4(var_b8e0a.x, var_b8e0a.y, var_b8e0a.z, var_5aff5.w);
#endif
#if defined(LIT__OFF) && defined(MULTI_COLOR_TINT__ON) && !defined(ALPHA_TEST__OFF)
    var_5aff5 = vec4(var_03b9e.x, var_03b9e.y, var_03b9e.z, var_5aff5.w);
#endif
#if defined(LIT__ON) && defined(MULTI_COLOR_TINT__OFF) && !defined(ALPHA_TEST__OFF)
    var_5aff5 = (CurrentColor * v_color) * (vec4(var_b8e0a.x, var_b8e0a.y, var_b8e0a.z, var_5aff5.w) * v_light);
#endif
#if defined(LIT__ON) && defined(MULTI_COLOR_TINT__ON) && !defined(ALPHA_TEST__OFF)
    var_5aff5 = vec4(var_03b9e.x, var_03b9e.y, var_03b9e.z, var_5aff5.w) * v_light;
#endif
#if defined(USE_TEXTURES__OFF) || !defined(ALPHA_TEST__OFF)
    var_5aff5.w *= HudOpacity.x;
#endif
#if defined(ALPHA_TEST__OFF) && defined(USE_TEXTURES__ON)
    var_86d2a.w *= HudOpacity.x;
#endif
    highp vec4 var_95f69 = v_fog;
#if defined(USE_TEXTURES__OFF) || !defined(ALPHA_TEST__OFF)
    highp vec3 var_14685 = mix(var_5aff5.xyz, v_fog.xyz, vec3(var_95f69.w));
#endif
#if defined(ALPHA_TEST__OFF) && defined(USE_TEXTURES__ON)
    highp vec3 var_f6bbd = mix(var_86d2a.xyz, v_fog.xyz, vec3(var_95f69.w));
#endif
#if defined(USE_TEXTURES__OFF) || !defined(ALPHA_TEST__OFF)
    bgfx_FragColor = vec4(var_14685.x, var_14685.y, var_14685.z, var_5aff5.w);
#endif
#if defined(ALPHA_TEST__OFF) && defined(USE_TEXTURES__ON)
    bgfx_FragColor = vec4(var_f6bbd.x, var_f6bbd.y, var_f6bbd.z, var_86d2a.w);
#endif
}
