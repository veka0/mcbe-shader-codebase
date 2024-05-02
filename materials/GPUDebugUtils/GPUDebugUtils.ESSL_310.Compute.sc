/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - GPU_VALIDATION_PASS
* - TDR_PASS
*/

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

BUFFER_RW_AUTOREG(s_FakeRWBufferBuffer, int);
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

NUM_THREADS(256, 1, 1)
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

