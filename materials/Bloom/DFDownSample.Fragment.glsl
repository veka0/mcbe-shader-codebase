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
uniform highp vec4 ViewportScale;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_0492c = (floor(ViewportScale.zw * ViewportScale.xy) - vec2(0.5)) / ViewportScale.zw;
    highp vec2 var_6b7f4 = (ViewportScale.xy * 1.5) * (vec2(2.0) / ViewportScale.zw);
    bgfx_FragColor = ((((texture(s_BlurPyramidTexture, min(v_texcoord0.xy, var_0492c)) * 0.5) + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(var_6b7f4.x, var_6b7f4.y), var_0492c)) * 0.125)) + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(-var_6b7f4.x, var_6b7f4.y), var_0492c)) * 0.125)) + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(var_6b7f4.x, -var_6b7f4.y), var_0492c)) * 0.125)) + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(-var_6b7f4.x, -var_6b7f4.y), var_0492c)) * 0.125);
}
