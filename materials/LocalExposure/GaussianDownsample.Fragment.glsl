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
uniform highp sampler2D s_SceneColor;
uniform highp vec4 GaussianBlurParams;
uniform highp vec4 LuminanceRangeParams;
uniform highp vec4 RecipSceneResolution;
uniform highp vec4 ViewportScale;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    int var_4eb5d = int(GaussianBlurParams.x);
    int var_bf101 = int(GaussianBlurParams.y);
    int var_f75fa = var_4eb5d / var_bf101;
    highp float var_12786 = 0.5 * float(var_4eb5d * var_4eb5d);
    int var_ede4a = -var_f75fa;
    highp float var_1c31c;
    highp float var_92006;
    var_92006 = 0.0;
    var_1c31c = 0.0;
    highp float var_e1fa9;
    highp float var_75a6e;
    for (int var_4101a = var_ede4a; var_4101a <= var_f75fa; var_92006 = var_75a6e, var_1c31c = var_e1fa9, var_4101a++)
    {
        int var_129b1 = -var_f75fa;
        var_75a6e = var_92006;
        var_e1fa9 = var_1c31c;
        highp float var_4529f;
        highp float var_718be;
        for (int var_502e7 = var_129b1; var_502e7 <= var_f75fa; var_75a6e = var_718be, var_e1fa9 = var_4529f, var_502e7++)
        {
            highp vec2 var_e2264 = vec2(float(var_4101a), float(var_502e7)) * float(var_bf101);
            highp vec2 var_2c069 = var_e2264;
            highp float var_796da = exp((-((var_2c069.x * var_2c069.x) + (var_2c069.y * var_2c069.y))) / var_12786);
            var_4529f = var_e1fa9 + (var_796da * log2(clamp(dot(texture(s_SceneColor, min(v_texcoord0 + (var_e2264 * RecipSceneResolution.xy), ViewportScale.zw)).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), LuminanceRangeParams.z, LuminanceRangeParams.w)));
            var_718be = var_75a6e + var_796da;
        }
    }
    bgfx_FragColor = vec4(var_1c31c / var_92006, 0.0, 0.0, 0.0);
}
