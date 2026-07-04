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
#if defined(ALPHA_TEST__OFF) && defined(USE_TEXTURES__OFF)
    highp vec4 var_e651c = CurrentColor * v_color;
#endif
#if defined(ALPHA_TEST__OFF) && defined(USE_TEXTURES__ON)
    highp vec4 var_e651c = (CurrentColor * v_color) * texture(s_MatTexture, v_texCoords);
#endif
#if defined(USE_TEXTURES__OFF) && !defined(ALPHA_TEST__OFF)
    highp vec4 var_e651c = vec4(1.0);
#endif
#if defined(USE_TEXTURES__ON) && !defined(ALPHA_TEST__OFF)
    highp vec4 var_e651c = texture(s_MatTexture, v_texCoords);
#endif
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
    if (var_e651c.w < DiscardValue.x)
#endif
#ifdef ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
    if (var_e651c.w <= 0.0)
#endif
#ifndef ALPHA_TEST__OFF
    {
        discard;
    }
    var_e651c = (CurrentColor * v_color) * var_e651c;
#endif
    var_e651c.w *= HudOpacity.x;
    bgfx_FragColor = var_e651c;
}
