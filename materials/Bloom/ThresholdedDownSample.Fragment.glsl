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
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_3c433 = v_texcoord0;
    highp float var_15af8 = BloomParams.y * texture(s_AverageLuminance, vec2(0.5)).x;
    highp vec2 var_5b0ca = vec2(1.5 * abs(dFdx(var_3c433.x)), 1.5 * abs(dFdy(var_3c433.y)));
    highp vec4 var_30918 = texture(s_BlurPyramidTexture, v_texcoord0.xy);
    highp vec4 var_225c1 = texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(var_5b0ca.x, var_5b0ca.y));
    highp vec4 var_a7770 = texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(-var_5b0ca.x, var_5b0ca.y));
    highp vec4 var_51a02 = texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(var_5b0ca.x, -var_5b0ca.y));
    highp vec4 var_ff72f = texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(-var_5b0ca.x, -var_5b0ca.y));
    bgfx_FragColor = (((((var_30918 * step(var_15af8, dot(var_30918.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.5) + ((var_225c1 * step(var_15af8, dot(var_225c1.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125)) + ((var_a7770 * step(var_15af8, dot(var_a7770.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125)) + ((var_51a02 * step(var_15af8, dot(var_51a02.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125)) + ((var_ff72f * step(var_15af8, dot(var_ff72f.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125);
}
