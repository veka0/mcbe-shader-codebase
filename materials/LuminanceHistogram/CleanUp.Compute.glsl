#version 310 es

/*
* Available Macros:
*
* Passes:
* - BUILD_HISTOGRAM_PASS (not used)
* - CALCULATE_AVERAGE_PASS (not used)
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

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;
struct Histogram {
    uint count;
};

layout(binding = 1, std430) buffer s_CurFrameLuminanceHistogram { Histogram CurFrameLuminanceHistogram[]; } var_bf956;
void main() {
    var_bf956.CurFrameLuminanceHistogram[gl_LocalInvocationIndex].count = 0u;
}
