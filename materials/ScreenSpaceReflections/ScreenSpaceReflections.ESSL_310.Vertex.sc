/*
* Available Macros:
*
* Passes:
* - SSR_FILL_GAPS_PASS (not used)
* - SSR_GET_REFLECTED_COLOR_PASS (not used)
* - SSR_RAY_MARCH_PASS
*
* ExtendedGapFill:
* - EXTENDED_GAP_FILL__OFF (not used)
* - EXTENDED_GAP_FILL__ON (not used)
*/

$input a_position, a_texcoord0
#ifdef SSR_RAY_MARCH_PASS
$output v_projPosition
#endif
$output v_texcoord0
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

uniform vec4 SSRRoughnessCutoffParams;
uniform vec4 CameraData;
uniform vec4 RenderMode;
uniform vec4 SSRFadingParams;
uniform vec4 SSRRayMarchingParams;
uniform vec4 ScreenSize;
uniform vec4 UnitPlaneExtents;
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
    vec4 position;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    #ifdef SSR_RAY_MARCH_PASS
    vec4 projPosition;
    #endif
    vec2 texcoord0;
};

struct FragmentInput {
    #ifdef SSR_RAY_MARCH_PASS
    vec4 projPosition;
    #endif
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_GbufferDepth);
SAMPLER2D_AUTOREG(s_GbufferNormal);
SAMPLER2D_AUTOREG(s_GbufferRoughness);
SAMPLER2D_AUTOREG(s_InputTexture);
SAMPLER2D_AUTOREG(s_RasterColor);
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = vec4(vertInput.position.xy * 2.0 - 1.0, 0.0, 1.0);
    vertOutput.texcoord0 = vec2(vertInput.texcoord0.x, vertInput.texcoord0.y);
}
#ifdef SSR_RAY_MARCH_PASS
void RayMarchVert(VertexInput vertInput, inout VertexOutput vertOutput) {
    Vert(vertInput, vertOutput);
    vertOutput.projPosition = vec4(vertOutput.position);
}
#endif
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
    #ifdef SSR_RAY_MARCH_PASS
    vertexOutput.projPosition = vec4(0, 0, 0, 0);
    #endif
    vertexOutput.texcoord0 = vec2(0, 0);
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
    #ifndef SSR_RAY_MARCH_PASS
    Vert(vertexInput, vertexOutput);
    #endif
    #ifdef SSR_RAY_MARCH_PASS
    RayMarchVert(vertexInput, vertexOutput);
    v_projPosition = vertexOutput.projPosition;
    #endif
    v_texcoord0 = vertexOutput.texcoord0;
    gl_Position = vertexOutput.position;
}

