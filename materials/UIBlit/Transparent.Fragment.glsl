#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Grayscale:
* - GRAYSCALE__OFF
* - GRAYSCALE__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 HudOpacity;
* - uniform vec4 TintColor;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 HudOpacity;
uniform highp vec4 TintColor;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_e9acc = texture(s_MatTexture, v_texcoord0) * TintColor;
    var_e9acc.w *= HudOpacity.x;
#ifdef GRAYSCALE__ON
    highp float var_63f8c = var_e9acc.x;
    highp float var_4ea36 = var_e9acc.y;
    highp float var_06696 = var_e9acc.z;
    highp float var_bec54 = ((var_63f8c * 0.300000011920928955078125) + (var_4ea36 * 0.589999973773956298828125)) + (var_06696 * 0.10999999940395355224609375);
    highp float var_765a5 = var_e9acc.w;
    highp vec4 var_c034b = vec4(var_bec54, var_bec54, var_bec54, var_765a5);
    var_e9acc = var_c034b;
    bgfx_FragData0 = var_c034b;
#endif
#ifdef GRAYSCALE__OFF
    bgfx_FragData0 = var_e9acc;
#endif
}
