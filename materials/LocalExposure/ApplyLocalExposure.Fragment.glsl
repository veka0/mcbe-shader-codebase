#version 310 es

/*
* Available Macros:
*
* Passes:
* - APPLY_LOCAL_EXPOSURE_PASS (not used)
* - GAUSSIAN_DOWNSAMPLE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AverageLuminance;
* - uniform lowp sampler2D s_DownsampledLuminance;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SceneColor;
*
* Uniforms:
* - uniform vec4 GaussianBlurParams;
* - uniform vec4 LocalExposureParams;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 RecipSceneResolution;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_AverageLuminance;
uniform highp sampler2D s_DownsampledLuminance;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneColor;
uniform highp vec4 LocalExposureParams;
uniform highp vec4 PreExposureEnabled;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp float var_8863b;
    if (PreExposureEnabled.x > 0.0)
    {
        var_8863b = log2((vec3(1.0) * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05)).x);
    }
    else
    {
        var_8863b = 0.0;
    }
    highp vec3 var_7a786 = texture(s_SceneColor, v_texcoord0).xyz;
    highp float var_72837 = log2(dot(var_7a786, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))) - var_8863b;
    highp float var_1c43f = log2(texture(s_DownsampledLuminance, v_texcoord0).x) - var_8863b;
    highp float var_7dffa = log2(texture(s_AverageLuminance, vec2(0.5)).x);
    bgfx_FragColor = vec4(var_7a786 * exp2(((var_7dffa + (LocalExposureParams.x * (var_1c43f - var_7dffa))) + (LocalExposureParams.y * (var_72837 - var_1c43f))) - var_72837), 1.0);
}
