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
* ThreadLimit:
* - THREAD_LIMIT__LIMITED_AT128 (not used)
* - THREAD_LIMIT__NATIVE (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AdaptedFrameAverageLuminance;
* - layout(binding = 1, std430) buffer s_CurFrameLuminanceHistogramBuffer { Histogram s_CurFrameLuminanceHistogram[]; };
* - uniform lowp sampler2D s_GameColor;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
*
* Uniforms:
* - uniform vec4 Adaptation;
* - uniform vec4 AdaptiveParameters;
* - uniform vec4 CenterWeight;
* - uniform vec4 LogLuminanceRange;
* - uniform vec4 MinLogLuminance;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantileBounds;
* - uniform vec4 ScreenSize;
*/

precision mediump float;
precision highp int;
struct Histogram {
    uint count;
};

layout(binding = 1, std430) buffer s_CurFrameLuminanceHistogram { Histogram CurFrameLuminanceHistogram[]; } var_39887;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp vec4 Adaptation;
uniform highp vec4 AdaptiveParameters;
uniform highp vec4 LogLuminanceRange;
uniform highp vec4 MinLogLuminance;
uniform highp vec4 QuantileBounds;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp float var_f0692;
    var_f0692 = 0.0;
    highp float var_c0db6;
    for (uint var_f44ea = 1u; var_f44ea < 256u; var_f0692 = var_c0db6, var_f44ea++)
    {
        var_c0db6 = var_f0692 + (float(var_39887.CurFrameLuminanceHistogram[var_f44ea].count) * 0.00390625);
    }
    highp float var_f6a30 = var_f0692 * QuantileBounds.x;
    highp float var_eb933 = var_f0692 * QuantileBounds.y;
    highp float var_54186;
    highp float var_fd30c;
    var_fd30c = 0.0;
    var_54186 = 0.0;
    highp float var_ac7e9;
    highp float var_70cee;
    highp float var_335c2;
    uint var_b3b25 = 1u;
    highp float var_f9f72 = 0.0;
    for (; var_b3b25 < 256u; var_f9f72 = var_335c2, var_fd30c = var_70cee, var_54186 = var_ac7e9, var_b3b25++)
    {
        highp float var_a0cf6 = float(var_39887.CurFrameLuminanceHistogram[var_b3b25].count) * 0.00390625;
        highp float var_23720 = max(var_f9f72, var_f6a30);
        highp float var_c37ba = max(min(var_f9f72 + var_a0cf6, var_eb933), var_23720) - var_23720;
        var_ac7e9 = var_54186 + (var_c37ba * float(var_b3b25));
        var_70cee = var_fd30c + var_c37ba;
        var_335c2 = var_f9f72 + var_a0cf6;
    }
    highp float var_d6eff = (((var_54186 / max(var_fd30c, 1.0)) - 1.0) * (LogLuminanceRange.x * 0.00393700785934925079345703125)) + MinLogLuminance.x;
    highp float var_a7e97;
    if (Adaptation.x > 0.5)
    {
        highp float var_37379 = clamp(log2(max(textureLod(s_PreviousFrameAverageLuminance, vec2(0.5), 0.0).x, 0.00095000001601874828338623046875)), MinLogLuminance.x, MinLogLuminance.x + LogLuminanceRange.x);
        highp float var_b0364;
        if (var_d6eff > var_37379)
        {
            var_b0364 = AdaptiveParameters.y;
        }
        else
        {
            var_b0364 = AdaptiveParameters.z;
        }
        var_a7e97 = var_37379 + ((var_d6eff - var_37379) * (1.0 - exp(((-Adaptation.y) * AdaptiveParameters.x) * var_b0364)));
    }
    else
    {
        var_a7e97 = var_d6eff;
    }
    bgfx_FragColor = vec4(exp2(var_a7e97));
}
