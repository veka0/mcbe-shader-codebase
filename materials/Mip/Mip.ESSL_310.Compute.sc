/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - MIP_DISTANCE_PASS (not used)
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

uniform vec4 Levels;
uniform vec4 ScreenSize;
uniform mat4 SceneInverseProjection;
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

SAMPLER2D_AUTOREG(s_FramebufferDepth);
IMAGE2D_RO_AUTOREG(s_InputMip, rgba16f);
IMAGE2D_WR_AUTOREG(s_OutputMip, rgba16f);
void MipDistance() {
}

NUM_THREADS(8, 8, 1)
void main() {
    LocalInvocationID = gl_LocalInvocationID;
    LocalInvocationIndex = gl_LocalInvocationIndex;
    GlobalInvocationID = gl_GlobalInvocationID;
    WorkGroupID = gl_WorkGroupID;
    MipDistance();
}

