#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS
* - TAAU_PASS
*/

#ifdef TAAU_PASS
#extension GL_EXT_texture_cube_map_array : enable
#endif
#define attribute in
#define varying out
attribute vec3 a_position;
attribute vec2 a_texcoord0;
varying vec2 v_texcoord0;
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
uniform vec4 TAAUpscalingParameters;
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
uniform vec4 ResolutionRatiosAndFPEpsilon;
uniform vec4 SubPixelJitter;
uniform mat4 CurrentViewProjectionMatrixUniform;
uniform vec4 CurrentWorldOrigin;
uniform vec4 DisplayResolution;
uniform mat4 PreviousViewProjectionMatrixUniform;
uniform vec4 PreviousWorldOrigin;
uniform vec4 RecipDisplayResolution;
uniform vec4 RenderResolution;
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

uniform lowp sampler2D s_InputFinalColor;
uniform lowp sampler2D s_InputTAAHistory;
uniform lowp sampler2D s_InputBufferMotionVectors;
#ifdef FALLBACK_PASS
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
}
#endif
#ifdef TAAU_PASS
void UpscalingVert(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = vec4(vertInput.position, 1.0);
    vertOutput.position.xy = vertOutput.position.xy * 2.0 - 1.0;
    vertOutput.texcoord0 = vertInput.texcoord0;
}
#endif
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
    #ifdef FALLBACK_PASS
    Vert(vertexInput, vertexOutput);
    #endif
    #ifdef TAAU_PASS
    UpscalingVert(vertexInput, vertexOutput);
    #endif
    v_texcoord0 = vertexOutput.texcoord0;
    gl_Position = vertexOutput.position;
}

