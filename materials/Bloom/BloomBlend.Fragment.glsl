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
uniform highp sampler2D s_HDRi;
uniform highp vec4 BloomParams;
uniform highp vec4 ViewportScale;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_07931 = (floor(ViewportScale.zw * ViewportScale.xy) - vec2(0.5)) / ViewportScale.zw;
    highp vec2 var_60318 = (ViewportScale.xy * 4.0) * (vec2(0.5) / ViewportScale.zw);
    highp vec4 var_cc6cb = ((((((texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(0.5 * var_60318.x, 0.5 * var_60318.y), var_07931)) * 0.16599999368190765380859375) + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2((-0.5) * var_60318.x, 0.5 * var_60318.y), var_07931)) * 0.16599999368190765380859375)) + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(0.5 * var_60318.x, (-0.5) * var_60318.y), var_07931)) * 0.16599999368190765380859375)) + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2((-0.5) * var_60318.x, (-0.5) * var_60318.y), var_07931)) * 0.16599999368190765380859375)) + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(var_60318.x, var_60318.y), var_07931)) * 0.082999996840953826904296875)) + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(-var_60318.x, var_60318.y), var_07931)) * 0.082999996840953826904296875)) + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(var_60318.x, -var_60318.y), var_07931)) * 0.082999996840953826904296875);
    bgfx_FragColor = vec4(texture(s_HDRi, v_texcoord0.xy).xyz + ((var_cc6cb + (texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(-var_60318.x, -var_60318.y), var_07931)) * 0.082999996840953826904296875)).xyz * BloomParams.x), 1.0);
}
