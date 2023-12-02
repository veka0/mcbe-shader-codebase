#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - SCATTERING_PASS (not used)
*/

#define shadow2D(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DArray(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DProj(_sampler, _coord)textureProj(_sampler, _coord)
struct NoopSampler {
    int noop;
};

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

uniform vec4 VolumeNearFar;
uniform vec4 VolumeDimensions;
uvec3 LocalInvocationID;
uint LocalInvocationIndex;
uvec3 GlobalInvocationID;
uvec3 WorkGroupID;
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

layout(rgba16f, binding = 0)readonly uniform highp image2DArray s_LightingBuffer;
layout(rgba16f, binding = 1)writeonly uniform highp image2DArray s_ScatteringBuffer;
float logToLinearDepth(float logDepth) {
    return (exp(4.0 * logDepth) - 1.0) / (exp(4.0) - 1.0);
}
struct TemporalAccumulationParameters {
    ivec3 dimensions;
    vec3 previousUvw;
    vec4 currentValue;
    float historyWeight;
    float frustumBoundaryFalloff;
};

void Scattering() {
    int volumeWidth = int(VolumeDimensions.x);
    int volumeHeight = int(VolumeDimensions.y);
    int volumeDepth = int(VolumeDimensions.z);
    int x = int(GlobalInvocationID.x);
    int y = int(GlobalInvocationID.y);
    if (x >= volumeWidth || y >= volumeHeight) {
        return;
    }
    float prevW = -0.5 / VolumeDimensions.z;
    float prevWLinear = logToLinearDepth(prevW);
    float prevDepth = (1.0 - prevWLinear) * VolumeNearFar.x + prevWLinear * VolumeNearFar.y;
    vec4 accum = vec4(0.0, 0.0, 0.0, 1.0);
    for(int z = 0; z < volumeDepth; ++ z) {
        float nextW = (float(z) + 0.5) / VolumeDimensions.z;
        float nextWLinear = logToLinearDepth(nextW);
        float nextDepth = (1.0 - nextWLinear) * VolumeNearFar.x + nextWLinear * VolumeNearFar.y;
        float stepSize = nextDepth - prevDepth;
        prevDepth = nextDepth;
        vec4 sourceExtinction = imageLoad(s_LightingBuffer, ivec3(x, y, z));
        float transmittance = exp(-sourceExtinction.a * stepSize);
        float contribution = abs(sourceExtinction.a) > 1e - 6 ? ((1.0 - transmittance) / sourceExtinction.a) : stepSize;
        accum.rgb += accum.a * contribution * sourceExtinction.rgb;
        accum.a *= transmittance;
        imageStore(s_ScatteringBuffer, ivec3(x, y, z), accum);
    }
}

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1)in;
void main() {
    LocalInvocationID = gl_LocalInvocationID;
    LocalInvocationIndex = gl_LocalInvocationIndex;
    GlobalInvocationID = gl_GlobalInvocationID;
    WorkGroupID = gl_WorkGroupID;
    Scattering();
}

