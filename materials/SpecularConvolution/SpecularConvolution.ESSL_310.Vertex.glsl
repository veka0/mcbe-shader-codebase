#version 310 es

/*
* Available Macros:
*
* Passes:
* - CONVOLVE_PASS
* - GENERATE_BRDF_PASS
*/

#ifdef CONVOLVE_PASS
#extension GL_EXT_shader_texture_lod : enable
#define texture2DLod textureLod
#define texture2DGrad textureGrad
#define texture2DProjLod textureProjLod
#define texture2DProjGrad textureProjGrad
#define textureCubeLod textureLod
#define textureCubeGrad textureGrad
#endif
#define attribute in
#define varying out
attribute vec4 a_position;
#ifdef CONVOLVE_PASS
varying vec3 v_viewVec;
#endif
#ifdef GENERATE_BRDF_PASS
varying vec2 v_texCoord;
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
uniform vec4 ConvolutionParameters;
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
};

struct VertexOutput {
    vec4 position;
    #ifdef CONVOLVE_PASS
    vec3 viewVec;
    #endif
    #ifdef GENERATE_BRDF_PASS
    vec2 texCoord;
    #endif
};

struct FragmentInput {
    #ifdef CONVOLVE_PASS
    vec3 viewVec;
    #endif
    #ifdef GENERATE_BRDF_PASS
    vec2 texCoord;
    #endif
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp samplerCube s_CubeMap;
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    #ifdef CONVOLVE_PASS
    vertOutput.position = ((ViewProj) * (vec4(vertInput.position.xyz, 1.0)));
    vertOutput.viewVec = vertInput.position.xyz;
    #endif
    #ifdef GENERATE_BRDF_PASS
    vertOutput.position = vec4(vertInput.position.xy * 2.0 - 1.0, 0.0, 1.0);
    vertOutput.texCoord = vertInput.position.xy;
    #endif
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.position = (a_position);
    #ifdef CONVOLVE_PASS
    vertexOutput.viewVec = vec3(0, 0, 0);
    #endif
    #ifdef GENERATE_BRDF_PASS
    vertexOutput.texCoord = vec2(0, 0);
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
    #ifdef CONVOLVE_PASS
    v_viewVec = vertexOutput.viewVec;
    #endif
    #ifdef GENERATE_BRDF_PASS
    v_texCoord = vertexOutput.texCoord;
    #endif
    gl_Position = vertexOutput.position;
}

