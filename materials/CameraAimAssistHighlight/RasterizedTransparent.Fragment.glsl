#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS (not used)
* - RASTERIZED_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 TextureOpacity;
* - uniform vec4 TintColor;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 TextureOpacity;
uniform highp vec4 TintColor;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_d657b = texture(s_MatTexture, v_texcoord0);
    var_d657b.w *= TextureOpacity.x;
    highp vec4 var_6a5ab = var_d657b;
    highp vec4 var_1019f = var_6a5ab * TintColor;
    var_d657b = var_1019f;
    bgfx_FragData0 = var_1019f;
}
