#version 310 es

/*
* Available Macros:
*
* Passes:
* - BUILD_HISTOGRAM_PASS (not used)
* - CALCULATE_AVERAGE_PASS (not used)
* - CALCULATE_AVERAGE_FRAGMENT_PASS (not used)
* - CLEAN_UP_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AdaptedFrameAverageLuminance;
* - layout(binding = 1, std430) buffer s_CurFrameLuminanceHistogramBuffer { Histogram s_CurFrameLuminanceHistogram[]; };
* - uniform lowp sampler2D s_CustomWeight;
* - uniform lowp sampler2D s_GameColor;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
*
* Uniforms:
* - uniform vec4 Adaptation;
* - uniform vec4 AdaptiveParameters;
* - uniform vec4 CenterWeight;
* - uniform vec4 EnableCustomWeight;
* - uniform vec4 LogLuminanceRange;
* - uniform vec4 MinLogLuminance;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 ScreenSize;
*/

precision mediump float;
precision highp int;
struct Histogram {
    uint count;
};

layout(binding = 1, std430) buffer s_CurFrameLuminanceHistogram { Histogram CurFrameLuminanceHistogram[]; } var_369af;
uniform highp sampler2D s_CustomWeight;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp vec4 Adaptation;
uniform highp vec4 AdaptiveParameters;
uniform highp vec4 EnableCustomWeight;
uniform highp vec4 LogLuminanceRange;
uniform highp vec4 MinLogLuminance;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_21627 = textureLod(s_PreviousFrameAverageLuminance, vec2(0.5), 0.0);
    highp float var_20ae9 = var_21627.x;
    highp float var_5e68f;
    highp float var_63b76;
    var_63b76 = 0.0;
    var_5e68f = 0.0;
    highp float var_e0a5d;
    highp float var_fe3e0;
    for (uint var_85691 = 1u; var_85691 < 256u; var_63b76 = var_fe3e0, var_5e68f = var_e0a5d, var_85691++)
    {
        highp float var_9e28b = float(var_369af.CurFrameLuminanceHistogram[var_85691].count) * 0.00390625;
        highp float var_fa56b;
        if (EnableCustomWeight.x != 0.0)
        {
            var_fa56b = var_9e28b * textureLod(s_CustomWeight, vec2((float(var_85691) + 0.5) * 0.00390625, 0.5), 0.0).x;
        }
        else
        {
            var_fa56b = var_9e28b;
        }
        var_e0a5d = var_5e68f + (var_fa56b * float(var_85691));
        var_fe3e0 = var_63b76 + var_fa56b;
    }
    highp float var_a8e81 = exp2(((((var_5e68f / max(var_63b76, 1.0)) - 1.0) * LogLuminanceRange.x) * 0.00393700785934925079345703125) + MinLogLuminance.x);
    highp float var_4b85e;
    if (Adaptation.x > 0.5)
    {
        highp float var_b0364;
        if (var_a8e81 > var_20ae9)
        {
            var_b0364 = AdaptiveParameters.y;
        }
        else
        {
            var_b0364 = AdaptiveParameters.z;
        }
        var_4b85e = var_20ae9 + ((var_a8e81 - var_20ae9) * (1.0 - exp(((-Adaptation.y) * AdaptiveParameters.x) * var_b0364)));
    }
    else
    {
        var_4b85e = var_a8e81;
    }
    bgfx_FragColor = vec4(var_4b85e);
}
