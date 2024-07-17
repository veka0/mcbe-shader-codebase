#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec2 a_position;
attribute vec2 a_texcoord0;
varying vec4 v_color;
varying vec2 v_uv;
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
uniform mat4 ImGuiProj;
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
    vec4 color;
    vec2 position;
    vec2 uv;
};

struct VertexOutput {
    vec4 position;
    vec4 color;
    vec2 uv;
};

struct FragmentInput {
    vec4 color;
    vec2 uv;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_MatTexture;
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = ((ImGuiProj) * (vec4(vertInput.position, 0.0, 1.0)));
    vertOutput.color = vertInput.color;
    vertOutput.uv = vec2(vertInput.uv.x, vertInput.uv.y);
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color = (a_color0);
    vertexInput.position = (a_position);
    vertexInput.uv = (a_texcoord0);
    vertexOutput.color = vec4(0, 0, 0, 0);
    vertexOutput.uv = vec2(0, 0);
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
    v_color = vertexOutput.color;
    v_uv = vertexOutput.uv;
    gl_Position = vertexOutput.position;
}

