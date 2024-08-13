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
attribute vec4 a_position;
attribute vec4 a_texcoord3;
varying vec4 v_additional;
varying vec4 v_color;
varying vec3 v_screenPosition;
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
uniform vec4 PrimProps0;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 ShaderType;
uniform vec4 PrimProps1;
uniform vec4 u_alphaRef4;
uniform vec4 TextureSize1;
uniform mat4 Transform;
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
    vec4 additional;
    vec4 color;
    vec4 position;
};

struct VertexOutput {
    vec4 position;
    vec4 additional;
    vec4 color;
    vec3 screenPosition;
};

struct FragmentInput {
    vec4 additional;
    vec4 color;
    vec3 screenPosition;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_Texture0;
uniform lowp sampler2D s_Texture1;
uniform lowp sampler2D s_Texture2;
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = ((vertInput.position) * (Transform));
    vertOutput.screenPosition = vertInput.position.xyz;
    float w = vertOutput.position.w;
    vertOutput.position.x = vertOutput.position.x * 2.0 - w;
    vertOutput.position.y = (w - vertOutput.position.y) * 2.0 - w;
    vertOutput.color = vertInput.color;
    vertOutput.additional = vertInput.additional;
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.additional = (a_texcoord3);
    vertexInput.color = (a_color0);
    vertexInput.position = (a_position);
    vertexOutput.additional = vec4(0, 0, 0, 0);
    vertexOutput.color = vec4(0, 0, 0, 0);
    vertexOutput.screenPosition = vec3(0, 0, 0);
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
    v_additional = vertexOutput.additional;
    v_color = vertexOutput.color;
    v_screenPosition = vertexOutput.screenPosition;
    gl_Position = vertexOutput.position;
}

