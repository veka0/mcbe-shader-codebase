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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_a42d5 = (floor(ViewportScale.zw * ViewportScale.xy) - vec2(0.5)) / ViewportScale.zw;
    highp float var_15af8 = BloomParams.y * texture(s_AverageLuminance, vec2(0.5)).x;
    highp vec2 var_dcf2e = (ViewportScale.xy * 1.5) * (vec2(2.0) / ViewportScale.zw);
    highp vec4 var_a7f0c = texture(s_BlurPyramidTexture, min(v_texcoord0.xy, var_a42d5));
    highp vec4 var_7dbdc = texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(var_dcf2e.x, var_dcf2e.y), var_a42d5));
    highp vec4 var_7588b = texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(-var_dcf2e.x, var_dcf2e.y), var_a42d5));
    highp vec4 var_b315c = texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(var_dcf2e.x, -var_dcf2e.y), var_a42d5));
    highp vec4 var_d4f6d = texture(s_BlurPyramidTexture, min(v_texcoord0.xy + vec2(-var_dcf2e.x, -var_dcf2e.y), var_a42d5));
    bgfx_FragColor = (((((var_a7f0c * step(var_15af8, dot(var_a7f0c.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.5) + ((var_7dbdc * step(var_15af8, dot(var_7dbdc.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125)) + ((var_7588b * step(var_15af8, dot(var_7588b.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125)) + ((var_b315c * step(var_15af8, dot(var_b315c.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125)) + ((var_d4f6d * step(var_15af8, dot(var_d4f6d.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))) * 0.125);
}
