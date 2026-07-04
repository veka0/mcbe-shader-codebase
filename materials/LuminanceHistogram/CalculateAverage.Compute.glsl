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

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
struct Histogram {
    uint count;
};

layout(binding = 1, std430) buffer s_CurFrameLuminanceHistogram { Histogram CurFrameLuminanceHistogram[]; } var_d3341;
layout(location = 0, binding = 2, r32f) uniform writeonly highp image2D s_AdaptedFrameAverageLuminance;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform vec4 Adaptation;
uniform vec4 AdaptiveParameters;
uniform vec4 LogLuminanceRange;
uniform vec4 MinLogLuminance;
uniform vec4 QuantileBounds;
void main() {
    float var_df095;
    var_df095 = 0.0;
    float var_f1fcc;
    for (uint var_f44ea = 1u; var_f44ea < 256u; var_df095 = var_f1fcc, var_f44ea++)
    {
        var_f1fcc = var_df095 + (float(var_d3341.CurFrameLuminanceHistogram[var_f44ea].count) * 0.00390625);
    }
    float var_ff753 = var_df095 * QuantileBounds.x;
    float var_07558 = var_df095 * QuantileBounds.y;
    float var_da4f3;
    float var_fded9;
    var_fded9 = 0.0;
    var_da4f3 = 0.0;
    float var_8242f;
    float var_75fd1;
    float var_78bcc;
    uint var_78056 = 1u;
    float var_d0fba = 0.0;
    for (; var_78056 < 256u; var_d0fba = var_78bcc, var_fded9 = var_75fd1, var_da4f3 = var_8242f, var_78056++)
    {
        float var_0faa1 = float(var_d3341.CurFrameLuminanceHistogram[var_78056].count) * 0.00390625;
        float var_e821e = max(var_d0fba, var_ff753);
        float var_05327 = max(min(var_d0fba + var_0faa1, var_07558), var_e821e) - var_e821e;
        var_8242f = var_da4f3 + (var_05327 * float(var_78056));
        var_75fd1 = var_fded9 + var_05327;
        var_78bcc = var_d0fba + var_0faa1;
    }
    float var_6c37d = (((var_da4f3 / max(var_fded9, 1.0)) - 1.0) * (LogLuminanceRange.x * 0.00393700785934925079345703125)) + MinLogLuminance.x;
    float var_d8db1;
    if (Adaptation.x > 0.5)
    {
        float var_5a1e8 = clamp(log2(max(textureLod(s_PreviousFrameAverageLuminance, vec2(0.5), 0.0).x, 0.00095000001601874828338623046875)), MinLogLuminance.x, MinLogLuminance.x + LogLuminanceRange.x);
        float var_d944e;
        if (var_6c37d > var_5a1e8)
        {
            var_d944e = AdaptiveParameters.y;
        }
        else
        {
            var_d944e = AdaptiveParameters.z;
        }
        var_d8db1 = var_5a1e8 + ((var_6c37d - var_5a1e8) * (1.0 - exp(((-Adaptation.y) * AdaptiveParameters.x) * var_d944e)));
    }
    else
    {
        var_d8db1 = var_6c37d;
    }
    imageStore(s_AdaptedFrameAverageLuminance, ivec2(0), vec4(exp2(var_d8db1)));
}
