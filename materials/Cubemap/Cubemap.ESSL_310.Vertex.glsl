#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
*/

#define attribute in
#define varying out
attribute vec3 a_position;
varying vec3 v_texcoord0;
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
uniform mat4 CubemapRotation;
uniform vec4 SubPixelOffset;
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
};

struct VertexOutput {
    vec4 position;
    vec3 texcoord0;
};

struct FragmentInput {
    vec3 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp samplerCube s_MatTexture;
vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x;
    offsetProj[2][1] -= SubPixelOffset.y;
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f)))));
}
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vec3 worldPosition = ((World) * (vec4(vertInput.position, 1.0))).xyz;
    vertOutput.position = jitterVertexPosition(worldPosition);
    vertOutput.texcoord0 = ((CubemapRotation) * (vec4(worldPosition, 0.0))).xyz;
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.position = (a_position);
    vertexOutput.texcoord0 = vec3(0, 0, 0);
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

