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

#extension GL_EXT_texture_cube_map_array : enable
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
vec4 textureSample(mediump samplerCubeArray _sampler, vec4 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump samplerCubeArray _sampler, vec4 _coord, int _lod) {
    return textureLod(_sampler, _coord, float(_lod));
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec4 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec4 _coord, float _lod) {
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

uniform vec4 AdaptiveParameters;
uniform vec4 EnableCustomWeight;
uniform vec4 CenterWeight;
uniform vec4 Adaptation;
uniform vec4 LogLuminanceRange;
uniform vec4 MinLogLuminance;
uniform vec4 PreExposureEnabled;
uniform vec4 ScreenSize;
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
layout(r32f, binding = 2)uniform highp image2D s_AdaptedFrameAverageLuminance;
uniform lowp sampler2D s_CustomWeight;
uniform lowp sampler2D s_PreviousFrameAverageLuminance;
layout(std430, binding = 1)buffer s_CurFrameLuminanceHistogram { Histogram CurFrameLuminanceHistogram[]; };
const float kHistogramWeightScaleFactor = float(1 << 8);
#ifdef BUILD_HISTOGRAM_PASS
vec3 UnExposeLighting(vec3 color, float averageLuminance) {
    return color / (0.18f / averageLuminance + 1e - 4);
}
#endif
#ifdef CALCULATE_AVERAGE_PASS
void Average() {
    float totalLogLuminance = 0.0;
    float totalWeight = 0.0;
    for(uint i = 1u; i < uint(256); ++ i) {
        float weight = float(CurFrameLuminanceHistogram[i].count) / kHistogramWeightScaleFactor;
        if (EnableCustomWeight.x != 0.0) {
            vec2 uv = vec2((float(i) + 0.5f) / float(256), 0.5f);
            weight *= textureSample(s_CustomWeight, uv, 0.0f).r;
        }
        totalLogLuminance += weight * float(i);
        totalWeight += weight;
    }
    float meanLogLuminance = totalLogLuminance / max(totalWeight, 1.0f) - 1.0f;
    float meanLuminance = exp2(((meanLogLuminance * LogLuminanceRange.x) / 254.0f) + MinLogLuminance.x);
    float adaptedLuminance = meanLuminance;
    if (Adaptation.x > 0.5) {
        float prevLuminance = imageLoad(s_AdaptedFrameAverageLuminance, ivec2(0, 0)).r;
        bool isBrighter = (meanLuminance > prevLuminance);
        float speedParam = isBrighter ? AdaptiveParameters.y : AdaptiveParameters.z;
        float adjustment = (meanLuminance - prevLuminance) * (1.0f - exp(-Adaptation.y * AdaptiveParameters.x * speedParam));
        adaptedLuminance = prevLuminance + adjustment;
    }
    imageStore(s_AdaptedFrameAverageLuminance, ivec2(0, 0), vec4(adaptedLuminance, adaptedLuminance, adaptedLuminance, adaptedLuminance));
}
#endif
#ifdef CLEAN_UP_PASS
void Clean() {
    CurFrameLuminanceHistogram[LocalInvocationIndex].count = 0u;
}
#endif

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
        if (PreExposureEnabled.x > 0.0) {
            float preExposure = textureSample(s_PreviousFrameAverageLuminance, vec2(0.5, 0.5), 0.0).r;
            color.rgb = UnExposeLighting(color.rgb, preExposure);
        }
        float luminance = dot(color.rgb, vec3(0.2126f, 0.7152f, 0.0722f));
        uint index = luminanceToHistogramBin(luminance);
        vec2 centerToPixel = uv - vec2(0.5, 0.5);
        float weight = exp(-CenterWeight.x * dot(centerToPixel, centerToPixel));
        uint weightFixed = uint(weight * kHistogramWeightScaleFactor);
        atomicAdd(curFrameLuminanceHistogramShared[index], weightFixed);
    }
    barrier();
    atomicAdd(CurFrameLuminanceHistogram[LocalInvocationIndex].count, curFrameLuminanceHistogramShared[LocalInvocationIndex]);
}

#endif
#ifndef CALCULATE_AVERAGE_PASS
layout(local_size_x = 16, local_size_y = 16, local_size_z = 1)in;
#endif
#ifdef CALCULATE_AVERAGE_PASS
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1)in;
#endif
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

