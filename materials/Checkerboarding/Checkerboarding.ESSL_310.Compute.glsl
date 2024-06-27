#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_CHECKERBOARDING_PASS (not used)
* - ESSL_100_PASS (not used)
* - FALLBACK_PASS (not used)
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

layout(rgba8, binding = 0)readonly uniform highp image2D s_ColorMetalnessInput;
layout(rgba8, binding = 7)writeonly uniform highp image2D s_ColorMetalnessOutput;
layout(rgba16f, binding = 2)readonly uniform highp image2D s_EmissiveLinearRoughnessInput;
layout(rgba16f, binding = 9)writeonly uniform highp image2D s_EmissiveLinearRoughnessOutput;
layout(rgba16f, binding = 5)readonly uniform highp image2D s_LowPrecisionWorldPositionInput;
layout(rgba16f, binding = 12)writeonly uniform highp image2D s_LowPrecisionWorldPositionOutput;
uniform lowp sampler2D s_NormalInput;
uniform lowp sampler2D s_NormalOutput;
layout(r32ui, binding = 3)readonly uniform highp uimage2D s_PlaneIDInput;
layout(r32ui, binding = 10)writeonly uniform highp uimage2D s_PlaneIDOutput;
layout(rgba16f, binding = 6)readonly uniform highp image2D s_ViewDirectionAndSplitMaskInput;
layout(rgba16f, binding = 13)writeonly uniform highp image2D s_ViewDirectionAndSplitMaskOutput;
layout(rgba32f, binding = 4)readonly uniform highp image2D s_WorldPositionInput;
layout(rgba32f, binding = 11)writeonly uniform highp image2D s_WorldPositionOutput;
void Checkerboarding() {
}

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1)in;
void main() {
    LocalInvocationID = gl_LocalInvocationID;
    LocalInvocationIndex = gl_LocalInvocationIndex;
    GlobalInvocationID = gl_GlobalInvocationID;
    WorkGroupID = gl_WorkGroupID;
    Checkerboarding();
}

