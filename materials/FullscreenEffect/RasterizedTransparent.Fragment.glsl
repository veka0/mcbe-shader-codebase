#version 310 es

/*
* Available Macros:
*
* Passes:
* - RASTERIZED_TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
*
* Lit:
* - LIT__OFF (not used)
* - LIT__ON (not used)
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
* - uniform vec4 CurrentColor;
* - uniform vec4 DiscardValue;
* - uniform vec4 HudOpacity;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 UVAnimation;
* - uniform vec4 ZShiftValue;
*/

precision mediump float;
precision highp int;
#ifdef USE_TEXTURES__ON
uniform highp sampler2D s_MatTexture;
#endif
uniform highp vec4 CurrentColor;
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
uniform highp vec4 DiscardValue;
#endif
uniform highp vec4 HudOpacity;
in highp vec4 v_color;
#ifdef USE_TEXTURES__ON
centroid in highp vec2 v_texCoords;
#endif
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifdef USE_TEXTURES__OFF
    highp vec4 var_ee258 = vec4(1.0);
#endif
#if defined(ALPHA_TEST__OFF) && defined(USE_TEXTURES__OFF)
    highp vec4 var_095aa = (CurrentColor * v_color) * vec4(1.0, 1.0, 1.0, var_ee258.w);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_5c592 = texture(s_MatTexture, v_texCoords);
    highp vec4 var_ae96f = var_5c592;
#endif
#if defined(ALPHA_TEST__OFF) && defined(USE_TEXTURES__ON)
    highp vec4 var_095aa = (CurrentColor * v_color) * vec4(pow(max(var_5c592.xyz, vec3(0.0)), vec3(2.2000000476837158203125)), var_ae96f.w);
#endif
#if defined(USE_TEXTURES__OFF) && !defined(ALPHA_TEST__OFF)
    highp vec4 var_095aa = vec4(1.0, 1.0, 1.0, var_ee258.w);
#endif
#if defined(USE_TEXTURES__ON) && !defined(ALPHA_TEST__OFF)
    highp vec4 var_095aa = vec4(pow(max(var_5c592.xyz, vec3(0.0)), vec3(2.2000000476837158203125)), var_ae96f.w);
#endif
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
    if (var_095aa.w < DiscardValue.x)
#endif
#ifdef ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
    if (var_095aa.w <= 0.0)
#endif
#ifndef ALPHA_TEST__OFF
    {
        discard;
    }
    var_095aa = (CurrentColor * v_color) * var_095aa;
#endif
    var_095aa.w *= HudOpacity.x;
    bgfx_FragColor = var_095aa;
}
