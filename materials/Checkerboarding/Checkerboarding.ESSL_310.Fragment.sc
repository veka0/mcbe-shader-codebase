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
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    fragOutput.Color0 = vec4(0.0, 0.0, 0.0, 0.0);
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentOutput.Color0 = vec4(0, 0, 0, 0);
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
    Frag(fragmentInput, fragmentOutput);
    gl_FragColor = fragmentOutput.Color0;
}

