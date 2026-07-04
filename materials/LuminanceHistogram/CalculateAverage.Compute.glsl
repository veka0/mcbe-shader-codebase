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

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
struct Histogram {
    uint count;
};

layout(binding = 1, std430) buffer s_CurFrameLuminanceHistogram { Histogram CurFrameLuminanceHistogram[]; } var_071df;
layout(location = 0, binding = 2, r32f) uniform writeonly highp image2D s_AdaptedFrameAverageLuminance;
uniform highp sampler2D s_CustomWeight;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform vec4 Adaptation;
uniform vec4 AdaptiveParameters;
uniform vec4 EnableCustomWeight;
uniform vec4 LogLuminanceRange;
uniform vec4 MinLogLuminance;
void main() {
    vec4 var_32d99 = textureLod(s_PreviousFrameAverageLuminance, vec2(0.5), 0.0);
    float var_d38b8 = var_32d99.x;
    float var_cbb07;
    float var_cfa77;
    var_cfa77 = 0.0;
    var_cbb07 = 0.0;
    float var_4944f;
    float var_dad21;
    for (uint var_84265 = 1u; var_84265 < 256u; var_cfa77 = var_dad21, var_cbb07 = var_4944f, var_84265++)
    {
        float var_a5d06 = float(var_071df.CurFrameLuminanceHistogram[var_84265].count) * 0.00390625;
        float var_385ec;
        if (EnableCustomWeight.x != 0.0)
        {
            var_385ec = var_a5d06 * textureLod(s_CustomWeight, vec2((float(var_84265) + 0.5) * 0.00390625, 0.5), 0.0).x;
        }
        else
        {
            var_385ec = var_a5d06;
        }
        var_4944f = var_cbb07 + (var_385ec * float(var_84265));
        var_dad21 = var_cfa77 + var_385ec;
    }
    float var_edc68 = exp2(((((var_cbb07 / max(var_cfa77, 1.0)) - 1.0) * LogLuminanceRange.x) * 0.00393700785934925079345703125) + MinLogLuminance.x);
    float var_25b57;
    if (Adaptation.x > 0.5)
    {
        float var_d944e;
        if (var_edc68 > var_d38b8)
        {
            var_d944e = AdaptiveParameters.y;
        }
        else
        {
            var_d944e = AdaptiveParameters.z;
        }
        var_25b57 = var_d38b8 + ((var_edc68 - var_d38b8) * (1.0 - exp(((-Adaptation.y) * AdaptiveParameters.x) * var_d944e)));
    }
    else
    {
        var_25b57 = var_edc68;
    }
    imageStore(s_AdaptedFrameAverageLuminance, ivec2(0), vec4(var_25b57));
}
