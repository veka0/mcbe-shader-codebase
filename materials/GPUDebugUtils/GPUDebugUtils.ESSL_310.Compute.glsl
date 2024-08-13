#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - GPU_VALIDATION_PASS
* - TDR_PASS
*/

#extension GL_EXT_texture_cube_map_array : enable
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

layout(std430, binding = 0)buffer s_FakeRWBufferBuffer { int s_FakeRWBuffer[]; };
#ifdef GPU_VALIDATION_PASS
void InitiateGpuValidaitonError() {
    s_FakeRWBuffer[GlobalInvocationID.x] = 0;
}
#endif
#ifdef TDR_PASS
void InitiateTDR() {
    while(s_FakeRWBuffer[GlobalInvocationID.x] == 0) {
        s_FakeRWBuffer[GlobalInvocationID.x] = 0;
    }
}
#endif

layout(local_size_x = 256, local_size_y = 1, local_size_z = 1)in;
void main() {
    LocalInvocationID = gl_LocalInvocationID;
    LocalInvocationIndex = gl_LocalInvocationIndex;
    GlobalInvocationID = gl_GlobalInvocationID;
    WorkGroupID = gl_WorkGroupID;
    #ifdef GPU_VALIDATION_PASS
    InitiateGpuValidaitonError();
    #endif
    #ifdef TDR_PASS
    InitiateTDR();
    #endif
}

