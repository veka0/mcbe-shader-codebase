#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLOOM_BLEND_PASS (not used)
* - DF_DOWN_SAMPLE_PASS (not used)
* - DF_UP_SAMPLE_PASS (not used)
* - THRESHOLDED_DOWN_SAMPLE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AverageLuminance;
* - uniform lowp sampler2D s_BlurPyramidTexture;
* - uniform lowp sampler2D s_HDRi;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 BloomParams;
* - uniform vec4 ScreenSize;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_BlurPyramidTexture;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_3c433 = v_texcoord0;
    highp vec2 var_dc432 = vec2(1.5 * abs(dFdx(var_3c433.x)), 1.5 * abs(dFdy(var_3c433.y)));
    bgfx_FragColor = ((((texture(s_BlurPyramidTexture, v_texcoord0.xy) * 0.5) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(var_dc432.x, var_dc432.y)) * 0.125)) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(-var_dc432.x, var_dc432.y)) * 0.125)) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(var_dc432.x, -var_dc432.y)) * 0.125)) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(-var_dc432.x, -var_dc432.y)) * 0.125);
}
