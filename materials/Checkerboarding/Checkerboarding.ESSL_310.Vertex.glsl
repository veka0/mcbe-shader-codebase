#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_CHECKERBOARDING_PASS (not used)
* - FALLBACK_PASS (not used)
*/

#define attribute in
#define varying out
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

uniform vec4 u_viewRect;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 u_viewTexel;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 OtherSideOffset;
vec4 ViewRect;
mat4 Proj;
mat4 View;
vec4 ViewTexel;
mat4 InvView;
mat4 InvProj;
mat4 ViewProj;
mat4 InvViewProj;
mat4 PrevViewProj;
mat4 WorldArray[4];
mat4 World;
mat4 WorldView;
mat4 WorldViewProj;
vec4 PrevWorldPosOffset;
vec4 AlphaRef4;
float AlphaRef;
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
uniform lowp sampler2D s_NormalInput;
layout(rgba16f, binding = 2)readonly uniform highp image2D s_EmissiveLinearRoughnessInput;
layout(r32ui, binding = 3)readonly uniform highp uimage2D s_PlaneIDInput;
layout(rgba32f, binding = 4)readonly uniform highp image2D s_WorldPositionInput;
layout(rgba16f, binding = 5)readonly uniform highp image2D s_LowPrecisionWorldPositionInput;
layout(rgba16f, binding = 6)readonly uniform highp image2D s_ViewDirectionAndSplitMaskInput;
layout(rgba8, binding = 7)writeonly uniform highp image2D s_ColorMetalnessOutput;
uniform lowp sampler2D s_NormalOutput;
layout(rgba16f, binding = 9)writeonly uniform highp image2D s_EmissiveLinearRoughnessOutput;
layout(r32ui, binding = 10)writeonly uniform highp uimage2D s_PlaneIDOutput;
layout(rgba32f, binding = 11)writeonly uniform highp image2D s_WorldPositionOutput;
layout(rgba16f, binding = 12)writeonly uniform highp image2D s_LowPrecisionWorldPositionOutput;
layout(rgba16f, binding = 13)writeonly uniform highp image2D s_ViewDirectionAndSplitMaskOutput;
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexOutput.position = vec4(0, 0, 0, 0);
    ViewRect = u_viewRect;
    Proj = u_proj;
    View = u_view;
    ViewTexel = u_viewTexel;
    InvView = u_invView;
    InvProj = u_invProj;
    ViewProj = u_viewProj;
    InvViewProj = u_invViewProj;
    PrevViewProj = u_prevViewProj;
    {
        WorldArray[0] = u_model[0];
        WorldArray[1] = u_model[1];
        WorldArray[2] = u_model[2];
        WorldArray[3] = u_model[3];
    }
    World = u_model[0];
    WorldView = u_modelView;
    WorldViewProj = u_modelViewProj;
    PrevWorldPosOffset = u_prevWorldPosOffset;
    AlphaRef4 = u_alphaRef4;
    AlphaRef = u_alphaRef4.x;
    Vert(vertexInput, vertexOutput);
    gl_Position = vertexOutput.position;
}

