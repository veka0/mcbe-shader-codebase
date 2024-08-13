/*
* Available Macros:
*
* Passes:
* - DO_CHECKERBOARDING_PASS (not used)
* - ESSL_100_PASS (not used)
* - FALLBACK_PASS (not used)
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

uniform vec4 OtherSideOffset;
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

IMAGE2D_RO_AUTOREG(s_ColorMetalnessInput, rgba8);
SAMPLER2D_AUTOREG(s_NormalInput);
IMAGE2D_RO_AUTOREG(s_EmissiveLinearRoughnessInput, rgba16f);
UIMAGE2D_RO_AUTOREG(s_PlaneIDInput, r32ui);
IMAGE2D_RO_AUTOREG(s_WorldPositionInput, rgba32f);
IMAGE2D_RO_AUTOREG(s_LowPrecisionWorldPositionInput, rgba16f);
IMAGE2D_RO_AUTOREG(s_ViewDirectionAndSplitMaskInput, rgba16f);
IMAGE2D_WR_AUTOREG(s_ColorMetalnessOutput, rgba8);
SAMPLER2D_AUTOREG(s_NormalOutput);
IMAGE2D_WR_AUTOREG(s_EmissiveLinearRoughnessOutput, rgba16f);
UIMAGE2D_WR_AUTOREG(s_PlaneIDOutput, r32ui);
IMAGE2D_WR_AUTOREG(s_WorldPositionOutput, rgba32f);
IMAGE2D_WR_AUTOREG(s_LowPrecisionWorldPositionOutput, rgba16f);
IMAGE2D_WR_AUTOREG(s_ViewDirectionAndSplitMaskOutput, rgba16f);
void Checkerboarding() {
}

NUM_THREADS(8, 8, 1)
void main() {
    LocalInvocationID = gl_LocalInvocationID;
    LocalInvocationIndex = gl_LocalInvocationIndex;
    GlobalInvocationID = gl_GlobalInvocationID;
    WorkGroupID = gl_WorkGroupID;
    Checkerboarding();
}

