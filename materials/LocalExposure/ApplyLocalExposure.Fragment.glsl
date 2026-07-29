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
* - uniform vec4 GaussianBlurParams;
* - uniform vec4 LocalExposureParams;
* - uniform vec4 LuminanceRangeParams;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 RecipSceneResolution;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_AverageLuminance;
uniform highp sampler2D s_DownsampledLogLuminance;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneColor;
uniform highp sampler3D s_FilteredBilateralGrid;
uniform highp vec4 LocalExposureParams;
uniform highp vec4 LuminanceRangeParams;
uniform highp vec4 PreExposureEnabled;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp float var_39afe;
    if (PreExposureEnabled.x > 0.0)
    {
        var_39afe = log2(clamp((vec3(1.0) * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05)).x, LuminanceRangeParams.z, LuminanceRangeParams.w));
    }
    else
    {
        var_39afe = 0.0;
    }
    highp vec4 var_66629 = texture(s_SceneColor, v_texcoord0);
    highp vec3 var_c221d = var_66629.xyz;
    highp float var_7e3ef = log2(clamp(dot(var_c221d, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), LuminanceRangeParams.z, LuminanceRangeParams.w)) - var_39afe;
    highp vec4 var_6e2c7 = texture(s_DownsampledLogLuminance, v_texcoord0);
    highp float var_abf2c = var_6e2c7.x - var_39afe;
    highp vec2 var_0d22a = texture(s_FilteredBilateralGrid, vec3(v_texcoord0, (var_7e3ef - LuminanceRangeParams.x) / (LuminanceRangeParams.y - LuminanceRangeParams.x))).xy;
    highp float var_3401f;
    if (var_0d22a.x < 0.001000000047497451305389404296875)
    {
        var_3401f = var_abf2c;
    }
    else
    {
        var_3401f = mix(LuminanceRangeParams.x + ((var_0d22a.y / var_0d22a.x) * (LuminanceRangeParams.y - LuminanceRangeParams.x)), var_abf2c, LocalExposureParams.z);
    }
    highp float var_62854 = log2(clamp(texture(s_AverageLuminance, vec2(0.5)).x, LuminanceRangeParams.z, LuminanceRangeParams.w));
    bgfx_FragData0 = vec4(var_c221d * exp2(((var_62854 + (LocalExposureParams.x * (var_3401f - var_62854))) + (LocalExposureParams.y * (var_7e3ef - var_3401f))) - var_7e3ef), 1.0);
}
