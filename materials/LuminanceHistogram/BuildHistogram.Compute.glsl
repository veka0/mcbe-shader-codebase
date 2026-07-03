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

layout(binding = 1, std430) buffer s_CurFrameLuminanceHistogram { Histogram CurFrameLuminanceHistogram[]; } var_f0b4b;
uniform highp sampler2D s_GameColor;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform vec4 CenterWeight;
uniform vec4 LogLuminanceRange;
uniform vec4 MinLogLuminance;
uniform vec4 PreExposureEnabled;
uniform vec4 ScreenSize;
shared uint curFrameLuminanceHistogramShared[256];
void func_caa06(inout float arg_30116, inout uint arg_1cbae) {
    if (arg_30116 < 0.00095000001601874828338623046875)
    {
        arg_1cbae = 0u;
        return;
    }
    arg_1cbae = uint((clamp((log2(arg_30116) - MinLogLuminance.x) / LogLuminanceRange.x, 0.0, 1.0) * 254.0) + 1.0);
}
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    uint var_58b5b = GlobalInvocationID.x;
    uint var_9f84d = GlobalInvocationID.y;
    curFrameLuminanceHistogramShared[gl_LocalInvocationIndex] = 0u;
    barrier();
    bool var_65e9e = var_58b5b < uint(ScreenSize.x);
    bool var_4a46b;
    if (var_65e9e)
    {
        var_4a46b = var_9f84d < uint(ScreenSize.y);
    }
    else
    {
        var_4a46b = var_65e9e;
    }
    if (var_4a46b)
    {
        vec2 var_0d03f = vec2(ivec2(int(var_58b5b), int(var_9f84d))) / ScreenSize.xy;
        vec3 var_43b49 = textureLod(s_GameColor, var_0d03f, 0.0).xyz;
        vec3 var_8a584;
        if (PreExposureEnabled.x > 0.0)
        {
            var_8a584 = var_43b49 / vec3((0.180000007152557373046875 / textureLod(s_PreviousFrameAverageLuminance, vec2(0.5), 0.0).x) + 9.9999997473787516355514526367188e-05);
        }
        else
        {
            var_8a584 = var_43b49;
        }
        float var_378d8 = dot(var_8a584, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        uint var_9eefc;
        func_caa06(var_378d8, var_9eefc);
        vec2 var_529a3 = var_0d03f - vec2(0.5);
        uint var_be8be = atomicAdd(curFrameLuminanceHistogramShared[var_9eefc], uint(exp((-CenterWeight.x) * dot(var_529a3, var_529a3)) * 256.0));
    }
    barrier();
    uint var_56ca1 = atomicAdd(var_f0b4b.CurFrameLuminanceHistogram[gl_LocalInvocationIndex].count, curFrameLuminanceHistogramShared[gl_LocalInvocationIndex]);
}
