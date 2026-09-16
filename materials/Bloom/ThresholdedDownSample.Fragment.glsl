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
uniform highp sampler2D s_AverageLuminance;
uniform highp sampler2D s_BlurPyramidTexture;
uniform highp vec4 BloomParams;
uniform highp vec4 ViewportScale;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec2 var_a42d5 = (floor(ViewportScale.zw * ViewportScale.xy) - vec2(0.5)) / ViewportScale.zw;
    highp float var_adcf6 = BloomParams.y * texture(s_AverageLuminance, vec2(0.5)).x;
    highp vec2 var_dcf2e = (ViewportScale.xy * 1.5) * (vec2(2.0) / ViewportScale.zw);
    highp vec4 var_178a0 = texture(s_BlurPyramidTexture, min(v_texcoord0.xy, var_a42d5));
    highp vec4 var_c8f38 = texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(var_dcf2e.x, var_dcf2e.y), var_a42d5));
    highp vec4 var_73c84 = texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(-var_dcf2e.x, var_dcf2e.y), var_a42d5));
    highp vec4 var_639dc = texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(var_dcf2e.x, -var_dcf2e.y), var_a42d5));
    highp vec4 var_100eb = texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(-var_dcf2e.x, -var_dcf2e.y), var_a42d5));
    bgfx_FragData0 = (((((var_178a0 * step(var_adcf6, dot(var_178a0.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.5) + ((var_c8f38 * step(var_adcf6, dot(var_c8f38.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125)) + ((var_73c84 * step(var_adcf6, dot(var_73c84.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125)) + ((var_639dc * step(var_adcf6, dot(var_639dc.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125)) + ((var_100eb * step(var_adcf6, dot(var_100eb.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125);
}
