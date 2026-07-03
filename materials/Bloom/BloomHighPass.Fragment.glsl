#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLOOM_BLEND_PASS (not used)
* - BLOOM_HIGH_PASS (not used)
* - DF_DOWN_SAMPLE_PASS (not used)
* - DF_DOWN_SAMPLE_WITH_DEPTH_EROSION_PASS (not used)
* - DF_UP_SAMPLE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BlurPyramidTexture;
* - uniform lowp sampler2D s_DepthTexture;
* - uniform lowp sampler2D s_HDRi;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 BloomParams1;
* - uniform vec4 BloomParams2;
* - uniform vec4 RenderMode;
* - uniform vec4 ScreenSize;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_DepthTexture;
uniform highp sampler2D s_HDRi;
uniform highp vec4 BloomParams1;
uniform highp vec4 BloomParams2;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_a00a8 = v_texcoord0;
    highp vec2 var_d98cf = vec2(1.5 * abs(dFdx(var_a00a8.x)), 1.5 * abs(dFdy(var_a00a8.y)));
    highp vec4 var_3f885 = texture(s_HDRi, v_texcoord0);
    highp vec4 var_64950 = texture(s_HDRi, v_texcoord0 + vec2(var_d98cf.x, var_d98cf.y));
    highp vec4 var_05513 = texture(s_HDRi, v_texcoord0 + vec2(-var_d98cf.x, var_d98cf.y));
    highp vec4 var_962ce = texture(s_HDRi, v_texcoord0 + vec2(var_d98cf.x, -var_d98cf.y));
    highp vec4 var_7ef15 = texture(s_HDRi, v_texcoord0 + vec2(-var_d98cf.x, -var_d98cf.y));
    highp vec4 var_71aaa = ((((vec4(var_3f885.xyz, dot(var_3f885.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))) * 0.5) + (vec4(var_64950.xyz, dot(var_64950.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))) * 0.125)) + (vec4(var_05513.xyz, dot(var_05513.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))) * 0.125)) + (vec4(var_962ce.xyz, dot(var_962ce.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))) * 0.125)) + (vec4(var_7ef15.xyz, dot(var_7ef15.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))) * 0.125);
    highp vec4 var_0f678;
    if (BloomParams2.z != 0.0)
    {
        var_0f678 = var_71aaa * pow(clamp(((texture(s_DepthTexture, v_texcoord0).x * BloomParams2.y) - BloomParams2.x) / (BloomParams2.y - BloomParams2.x), BloomParams1.z, 1.0), BloomParams1.y);
    }
    else
    {
        var_0f678 = var_71aaa;
    }
    bgfx_FragColor = var_0f678;
}
