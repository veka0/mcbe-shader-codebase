#version 310 es

/*
* Available Macros:
*
* Passes:
* - BUILD_HISTOGRAM_PASS
* - CALCULATE_AVERAGE_PASS
* - CLEAN_UP_PASS
* - FALLBACK_PASS (not used)
*/

#define shadow2D(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DArray(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DProj(_sampler, _coord)textureProj(_sampler, _coord)
struct NoopSampler {
    int noop;
};

#ifndef CLEAN_UP_PASS
vec4 textureSample(mediump sampler2D _sampler, vec2 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump samplerCube _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2D _sampler, vec2 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
#endif
struct NoopImage2D {
    int noop;
};

struct NoopImage3D {
    int noop;
};

struct rayQueryKHR {
    int noop;
};

struct accelerationStructureKHR {
    int noop;
};

uniform vec4 MinLogLuminance;
uniform vec4 AdaptiveParameters;
uniform vec4 LogLuminanceRange;
uniform vec4 ScreenSize;
uniform vec4 DeltaTime;
uniform vec4 EnableCustomWeight;
uvec3 LocalInvocationID;
uint LocalInvocationIndex;
uvec3 GlobalInvocationID;
uvec3 WorkGroupID;
struct Histogram {
    uint count;
};

struct VertexInput {
    float dummy;
};

struct VertexOutput {
    vec4 position;
};

struct FragmentInput {
    float dummy;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_GameColor;
uniform lowp sampler2D s_CustomWeight;
layout(r32f, binding = 2)uniform highp image2D s_AdaptedFrameAverageLuminance;
layout(r32f, binding = 3)uniform highp image2D s_MaxFrameLuminance;
layout(std430, binding = 1)buffer s_CurFrameLuminanceHistogram { Histogram CurFrameLuminanceHistogram[]; };
#ifdef BUILD_HISTOGRAM_PASS
shared uint curFrameLuminanceHistogramShared[256];
uint luminanceToHistogramBin(float luminance) {
    if (luminance < 0.00095f) {
        return 0u;
    }
    float logLuminance = clamp((log2(luminance) - MinLogLuminance.x) * 1.0f / LogLuminanceRange.x, 0.0f, 1.0f);
    return uint(logLuminance * 254.0 + 1.0);
}
void Build() {
    uint x = GlobalInvocationID.x;
    uint y = GlobalInvocationID.y;
    curFrameLuminanceHistogramShared[LocalInvocationIndex] = 0u;
    barrier();
    if (x < uint(ScreenSize.x)&& y < uint(ScreenSize.y)) {
        ivec2 pixel = ivec2(x, y);
        vec2 uv = vec2(pixel) / ScreenSize.xy;
        vec3 color = textureSample(s_GameColor, uv, 0.0f).rgb;
        float luminance = dot(color.rgb, vec3(0.2126f, 0.7152f, 0.0722f));
        uint index = luminanceToHistogramBin(luminance);
        atomicAdd(curFrameLuminanceHistogramShared[index], 1u);
    }
    barrier();
    atomicAdd(CurFrameLuminanceHistogram[LocalInvocationIndex].count, curFrameLuminanceHistogramShared[LocalInvocationIndex]);
}
#endif
#ifdef CALCULATE_AVERAGE_PASS
shared float curFrameLuminanceHistogramShared[256];
void Average() {
    uint histogramCount = CurFrameLuminanceHistogram[LocalInvocationIndex].count;
    if (EnableCustomWeight.x != 0.0) {
        vec2 uv = vec2((float(LocalInvocationIndex) + 0.5f) / float(256), 0.5f);
        curFrameLuminanceHistogramShared[LocalInvocationIndex] = float(histogramCount) * textureSample(s_CustomWeight, uv, 0.0f).r;
    }
    else {
        curFrameLuminanceHistogramShared[LocalInvocationIndex] = float(histogramCount) * float(LocalInvocationIndex);
    }
    barrier();
    for(uint cutoff = uint(256 >> 1); cutoff > 0u; ) {
        if (uint(LocalInvocationIndex) < cutoff) {
            curFrameLuminanceHistogramShared[LocalInvocationIndex] = curFrameLuminanceHistogramShared[LocalInvocationIndex] + curFrameLuminanceHistogramShared[LocalInvocationIndex + cutoff];
        }
        barrier();
        cutoff = (cutoff >> 1u);
    }
    if (LocalInvocationIndex == 0u) {
        float weightedLogAverage = (curFrameLuminanceHistogramShared[0] / max(ScreenSize.x * ScreenSize.y - float(histogramCount), 1.0f)) - 1.0f;
        if (weightedLogAverage < 1.f) {
            weightedLogAverage = 0.0f;
        }
        float weightedAverageLuminance = exp2(((weightedLogAverage * LogLuminanceRange.x) / 254.0f) + MinLogLuminance.x);
        float prevLuminance = imageLoad(s_AdaptedFrameAverageLuminance, ivec2(0, 0)).r;
        bool isBrighter = (prevLuminance < weightedAverageLuminance);
        float speedParam = isBrighter ? AdaptiveParameters.y : AdaptiveParameters.z;
        float adaptedLuminance = prevLuminance + (weightedAverageLuminance - prevLuminance) * (1.0f - exp(-DeltaTime.x * AdaptiveParameters.x * speedParam));
        if (isBrighter) {
            adaptedLuminance = adaptedLuminance > weightedAverageLuminance ? weightedAverageLuminance : adaptedLuminance;
        }
        else {
            adaptedLuminance = adaptedLuminance > weightedAverageLuminance ? adaptedLuminance : weightedAverageLuminance;
        }
        imageStore(s_AdaptedFrameAverageLuminance, ivec2(0, 0), vec4(adaptedLuminance, adaptedLuminance, adaptedLuminance, adaptedLuminance));
        int maxLuminanceBin = 0;
        for(int i = 256 - 1; i > 0; i -- ) {
            if (float(CurFrameLuminanceHistogram[i].count) >= AdaptiveParameters.w) {
                maxLuminanceBin = i;
                break;
            }
        }
        vec2 uv = vec2((float(maxLuminanceBin) + 0.5f) / float(256), 0.5f);
        float maxLuminance = 0.0f;
        if (EnableCustomWeight.x != 0.0) {
            maxLuminance = exp2(((textureSample(s_CustomWeight, uv, 0.0f).r - 1.0f) * LogLuminanceRange.x) / 254.0f + MinLogLuminance.x);
        }
        else {
            maxLuminance = exp2(((float(maxLuminanceBin) - 1.0f) * LogLuminanceRange.x) / 254.0f + MinLogLuminance.x);
        }
        imageStore(s_MaxFrameLuminance, ivec2(0, 0), vec4(maxLuminance, maxLuminance, maxLuminance, maxLuminance));
    }
}
#endif
#ifdef CLEAN_UP_PASS
void Clean() {
    CurFrameLuminanceHistogram[LocalInvocationIndex].count = 0u;
}
#endif

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1)in;
void main() {
    LocalInvocationID = gl_LocalInvocationID;
    LocalInvocationIndex = gl_LocalInvocationIndex;
    GlobalInvocationID = gl_GlobalInvocationID;
    WorkGroupID = gl_WorkGroupID;
    #ifdef BUILD_HISTOGRAM_PASS
    Build();
    #endif
    #ifdef CALCULATE_AVERAGE_PASS
    Average();
    #endif
    #ifdef CLEAN_UP_PASS
    Clean();
    #endif
}

