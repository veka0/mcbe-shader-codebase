/*
* Available Macros:
*
* Passes:
* - HIGHLIGHT_PASS (not used)
* - HIGHLIGHT_TEXTURE_EDGE_PASS (not used)
*/

$input a_position, a_texcoord0
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

uniform vec4 HighlightColor;
uniform vec4 HighlightAlpha;
uniform vec4 HiddenBlocksAlpha;
uniform vec4 CameraPosition;
uniform vec4 BlockEdgeColor;
uniform vec4 BlockEdgeThickness;
uniform mat4 InverseProjView;
uniform vec4 OutlineColor;
uniform vec4 OutlineWidth;
uniform vec4 OverlayTextureStretch;
uniform vec4 ScreenSize;
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
    vec3 position;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
};

struct FragmentInput {
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_HighlightTextureColor);
SAMPLER2D_AUTOREG(s_HighlightTextureDepth);
SAMPLER2D_AUTOREG(s_SceneTextureColor);
SAMPLER2D_AUTOREG(s_SceneTextureDepth);
SAMPLER2D_AUTOREG(s_SelectedBlocksOverlayTexture);
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
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
    Vert(vertexInput, vertexOutput);
    v_texcoord0 = vertexOutput.texcoord0;
    gl_Position = vertexOutput.position;
}

