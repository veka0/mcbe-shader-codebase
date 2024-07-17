#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLEAR0_PASS (not used)
* - CLEAR1_PASS (not used)
* - CLEAR2_PASS (not used)
* - CLEAR3_PASS (not used)
* - CLEAR4_PASS (not used)
* - CLEAR5_PASS (not used)
* - CLEAR6_PASS (not used)
* - CLEAR7_PASS (not used)
* - DEBUGFONT_PASS
*/

#define attribute in
#define varying out
#ifdef DEBUGFONT_PASS
attribute vec4 a_color0;
attribute vec4 a_color1;
#endif
attribute vec3 a_position;
#ifdef DEBUGFONT_PASS
attribute vec2 a_texcoord0;
varying vec4 v_color0;
varying vec4 v_color1;
varying vec2 v_texcoord0;
#endif
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
uniform vec4 bgfx_clear_color[8];
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
    #ifdef DEBUGFONT_PASS
    vec4 color0;
    vec4 color1;
    #endif
    vec3 position;
    #ifdef DEBUGFONT_PASS
    vec2 texcoord0;
    #endif
};

struct VertexOutput {
    vec4 position;
    #ifdef DEBUGFONT_PASS
    vec4 color0;
    vec4 color1;
    vec2 texcoord0;
    #endif
};

struct FragmentInput {
    #ifndef DEBUGFONT_PASS
    float dummy;
    #endif
    #ifdef DEBUGFONT_PASS
    vec4 color0;
    vec4 color1;
    vec2 texcoord0;
    #endif
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_texColor;
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    #ifndef DEBUGFONT_PASS
    vertOutput.position = vec4(vertInput.position.xyz, 1.0);
    #endif
    #ifdef DEBUGFONT_PASS
    vertOutput.position = ((WorldViewProj) * (vec4(vertInput.position.xyz, 1.0)));
    vertOutput.texcoord0 = vertInput.texcoord0;
    vertOutput.color0 = vertInput.color0;
    vertOutput.color1 = vertInput.color1;
    #endif
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    #ifdef DEBUGFONT_PASS
    vertexInput.color0 = (a_color0);
    vertexInput.color1 = (a_color1);
    #endif
    vertexInput.position = (a_position);
    #ifdef DEBUGFONT_PASS
    vertexInput.texcoord0 = (a_texcoord0);
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    vertexOutput.color1 = vec4(0, 0, 0, 0);
    vertexOutput.texcoord0 = vec2(0, 0);
    #endif
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
    #ifdef DEBUGFONT_PASS
    v_color0 = vertexOutput.color0;
    v_color1 = vertexOutput.color1;
    v_texcoord0 = vertexOutput.texcoord0;
    #endif
    gl_Position = vertexOutput.position;
}

