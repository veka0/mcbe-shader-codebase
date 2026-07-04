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
* - uniform lowp sampler2D s_DownsampledLogLuminance;
* - uniform lowp sampler3D s_FilteredBilateralGrid;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SceneColor;
*
* Uniforms:
* - uniform vec4 BilateralGridParams;
* - uniform vec4 GaussianBlurParams;
* - uniform vec4 LocalExposureParams;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 RecipSceneResolution;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_AverageLuminance;
uniform highp sampler2D s_DownsampledLogLuminance;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneColor;
uniform highp sampler3D s_FilteredBilateralGrid;
uniform highp vec4 BilateralGridParams;
uniform highp vec4 LocalExposureParams;
uniform highp vec4 PreExposureEnabled;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp float var_8887a;
    if (PreExposureEnabled.x > 0.0)
    {
        var_8887a = log2((vec3(1.0) * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05)).x);
    }
    else
    {
        var_8887a = 0.0;
    }
    highp vec4 var_66629 = texture(s_SceneColor, v_texcoord0);
    highp vec3 var_11748 = var_66629.xyz;
    highp float var_570a3 = log2(dot(var_11748, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))) - var_8887a;
    highp vec4 var_6e2c7 = texture(s_DownsampledLogLuminance, v_texcoord0);
    highp float var_088ee = var_6e2c7.x - var_8887a;
    highp vec2 var_9f63d = texture(s_FilteredBilateralGrid, vec3(v_texcoord0, (var_570a3 - BilateralGridParams.x) / (BilateralGridParams.y - BilateralGridParams.x))).xy;
    highp float var_c534f;
    if (var_9f63d.x < 0.001000000047497451305389404296875)
    {
        var_c534f = var_088ee;
    }
    else
    {
        var_c534f = mix(BilateralGridParams.x + ((var_9f63d.y / var_9f63d.x) * (BilateralGridParams.y - BilateralGridParams.x)), var_088ee, LocalExposureParams.z);
    }
    highp float var_7dffa = log2(texture(s_AverageLuminance, vec2(0.5)).x);
    bgfx_FragColor = vec4(var_11748 * exp2(((var_7dffa + (LocalExposureParams.x * (var_c534f - var_7dffa))) + (LocalExposureParams.y * (var_570a3 - var_c534f))) - var_570a3), 1.0);
}
