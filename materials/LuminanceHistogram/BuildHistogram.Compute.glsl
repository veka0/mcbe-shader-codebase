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
* - THREAD_LIMIT__LIMITED_AT128
* - THREAD_LIMIT__NATIVE
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AdaptedFrameAverageLuminance;
* - layout(binding = 3, std430) buffer s_CurFrameLuminanceHistogramBuffer { Histogram s_CurFrameLuminanceHistogram[]; };
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

#ifdef THREAD_LIMIT__LIMITED_AT128
layout(local_size_x = 16, local_size_y = 8, local_size_z = 1) in;
#endif
#ifdef THREAD_LIMIT__NATIVE
layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;
#endif
struct Histogram {
    uint count;
};

layout(binding = 3, std430) buffer s_CurFrameLuminanceHistogram { Histogram CurFrameLuminanceHistogram[]; } var_b7280;
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
    uint var_1a89b = GlobalInvocationID.x;
    uint var_e5a21 = GlobalInvocationID.y;
#ifdef THREAD_LIMIT__LIMITED_AT128
    for (uint var_a845f = 0u; var_a845f < 2u; var_a845f++)
#endif
#ifdef THREAD_LIMIT__NATIVE
    for (uint var_5c629 = 0u; var_5c629 < 1u; var_5c629++)
#endif
    {
#ifdef THREAD_LIMIT__LIMITED_AT128
        curFrameLuminanceHistogramShared[(var_a845f * 128u) + gl_LocalInvocationIndex] = 0u;
#endif
#ifdef THREAD_LIMIT__NATIVE
        curFrameLuminanceHistogramShared[(var_5c629 * 256u) + gl_LocalInvocationIndex] = 0u;
#endif
    }
    barrier();
    bool var_65e9e = var_1a89b < uint(ScreenSize.x);
    bool var_4a46b;
    if (var_65e9e)
    {
        var_4a46b = var_e5a21 < uint(ScreenSize.y);
    }
    else
    {
        var_4a46b = var_65e9e;
    }
    if (var_4a46b)
    {
        vec2 var_2a716 = (vec2(ivec2(int(var_1a89b), int(var_e5a21))) + vec2(0.5)) / ScreenSize.zw;
        vec3 var_43b49 = textureLod(s_GameColor, var_2a716, 0.0).xyz;
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
        vec2 var_529a3 = var_2a716 - vec2(0.5);
        uint var_be8be = atomicAdd(curFrameLuminanceHistogramShared[var_9eefc], uint(exp((-CenterWeight.x) * dot(var_529a3, var_529a3)) * 256.0));
    }
    barrier();
#ifdef THREAD_LIMIT__LIMITED_AT128
    for (uint var_3f941 = 0u; var_3f941 < 2u; var_3f941++)
#endif
#ifdef THREAD_LIMIT__NATIVE
    for (uint var_2edda = 0u; var_2edda < 1u; var_2edda++)
#endif
    {
#ifdef THREAD_LIMIT__LIMITED_AT128
        uint var_c8bf6 = (var_3f941 * 128u) + gl_LocalInvocationIndex;
#endif
#ifdef THREAD_LIMIT__NATIVE
        uint var_c8bf6 = (var_2edda * 256u) + gl_LocalInvocationIndex;
#endif
        uint var_1dd77 = atomicAdd(var_b7280.CurFrameLuminanceHistogram[var_c8bf6].count, curFrameLuminanceHistogramShared[var_c8bf6]);
    }
}
