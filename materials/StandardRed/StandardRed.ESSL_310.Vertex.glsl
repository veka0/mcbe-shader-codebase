#version 310 es

/*
* Available Macros:
*
* Passes:
* - CUSTOM_PASS_BASED_ON_OPAQUE_PASS
* - DEPTH_ONLY_PASS
* - OPAQUE_PASS
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*/

#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec4 a_normal;
attribute vec3 a_position;
attribute vec2 a_texcoord0;
#ifdef INSTANCING__ON
attribute vec4 i_data1;
attribute vec4 i_data2;
attribute vec4 i_data3;
#endif
varying vec4 v_color0;
varying vec2 v_texcoord0;
varying vec3 v_viewSpaceNormal;
#ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
varying vec4 v_viewSpacePosition;
varying vec4 v_worldSpacePosition;
#endif
struct NoopSampler {
    int noop;
};

#ifdef INSTANCING__ON
vec3 instMul(vec3 _vec, mat3 _mtx) {
    return ((_vec) * (_mtx));
}
vec3 instMul(mat3 _mtx, vec3 _vec) {
    return ((_mtx) * (_vec));
}
vec4 instMul(vec4 _vec, mat4 _mtx) {
    return ((_vec) * (_mtx));
}
vec4 instMul(mat4 _mtx, vec4 _vec) {
    return ((_mtx) * (_vec));
}
#endif
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
uniform vec4 Ambient;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 LightAmbientColorAndIntensity;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 ShadowFilterSize;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 ShadowTexel;
uniform mat4 ShadowTransform;
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
    vec4 color0;
    vec4 normal;
    vec3 position;
    vec2 texcoord0;
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec4 color0;
    vec2 texcoord0;
    vec3 viewSpaceNormal;
    #ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    vec4 viewSpacePosition;
    vec4 worldSpacePosition;
    #endif
};

struct FragmentInput {
    vec4 color0;
    vec2 texcoord0;
    vec3 viewSpaceNormal;
    #ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    vec4 viewSpacePosition;
    vec4 worldSpacePosition;
    #endif
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_MatTexture;
uniform lowp sampler2D s_ShadowTexture;
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec3 viewSpaceNormal;
    #ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    vec4 viewSpacePosition;
    vec4 worldSpacePosition;
    #endif
};

struct StandardVertexInput {
    VertexInput vertInput;
    vec3 worldPos;
};

struct StandardSurfaceOutput {
    vec3 Albedo;
    float Alpha;
    float Metallic;
    float Roughness;
    float Occlusion;
    float Emissive;
    vec3 AmbientLight;
    vec3 ViewSpaceNormal;
};

struct CompositingOutput {
    vec3 mLitColor;
};

void StandardTemplate_VertSharedTransform(VertexInput vertInput, inout VertexOutput vertOutput, out vec3 worldPosition) {
    #ifdef INSTANCING__OFF
    vec3 wpos = ((World) * (vec4(vertInput.position, 1.0))).xyz;
    #endif
    #ifdef INSTANCING__ON
    mat4 model;
    model[0] = vec4(vertInput.instanceData0.x, vertInput.instanceData1.x, vertInput.instanceData2.x, 0);
    model[1] = vec4(vertInput.instanceData0.y, vertInput.instanceData1.y, vertInput.instanceData2.y, 0);
    model[2] = vec4(vertInput.instanceData0.z, vertInput.instanceData1.z, vertInput.instanceData2.z, 0);
    model[3] = vec4(vertInput.instanceData0.w, vertInput.instanceData1.w, vertInput.instanceData2.w, 1);
    vec3 wpos = instMul(model, vec4(vertInput.position, 1.0)).xyz;
    #endif
    vertOutput.position = ((ViewProj) * (vec4(wpos, 1.0)));
    worldPosition = wpos;
}
void StandardTemplate_VertexPreprocessIdentity(VertexInput vertInput, inout VertexOutput vertOutput) {
}
void StandardTemplate_VertexOverrideIdentity(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
}

void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput);
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition);
#endif
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

#ifdef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
void computeLighting_NdotL_Vertex(VertexInput vInput, inout VertexOutput vOutput, vec3 worldPosition) {
    vec3 objectNormal = vInput.normal.xyz;
    vec3 viewSpaceNormal = ((WorldView) * (vec4(objectNormal.xyz, 0.0))).xyz;
    vOutput.viewSpaceNormal = viewSpaceNormal;
}
#endif
#ifdef OPAQUE_PASS
void computeLighting_BlinnPhong_Vertex(VertexInput vInput, inout VertexOutput vOutput, vec3 worldPosition) {
    vec3 objectNormal = vInput.normal.xyz;
    vec3 viewSpaceNormal = ((WorldView) * (vec4(objectNormal.xyz, 0.0))).xyz;
    vOutput.viewSpaceNormal = viewSpaceNormal;
    vOutput.viewSpacePosition = ((View) * (vec4(worldPosition.x, worldPosition.y, worldPosition.z, 1.0)));
    vOutput.worldSpacePosition = vec4(worldPosition.x, worldPosition.y, worldPosition.z, 1.0);
}
#endif
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_VertShared(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_InvokeVertexPreprocessFunction(vertInput, vertOutput);
    StandardVertexInput stdInput;
    stdInput.vertInput = vertInput;
    StandardTemplate_VertSharedTransform(vertInput, vertOutput, stdInput.worldPos);
    vertOutput.texcoord0 = vertInput.texcoord0;
    vertOutput.color0 = vertInput.color0;
    StandardTemplate_InvokeVertexOverrideFunction(stdInput, vertOutput);
    StandardTemplate_InvokeLightingVertexFunction(vertInput, vertOutput, stdInput.worldPos);
}
#endif
void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertexPreprocessIdentity(vertInput, vertOutput);
}
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertexOverrideIdentity(vertInput, vertOutput);
}
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
    #ifdef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    computeLighting_NdotL_Vertex(vertInput, vertOutput, worldPosition);
    #endif
    #ifdef OPAQUE_PASS
    computeLighting_BlinnPhong_Vertex(vertInput, vertOutput, worldPosition);
    #endif
}
void StandardTemplate_Opaque_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertShared(vertInput, vertOutput);
}
#endif
#ifdef DEPTH_ONLY_PASS
void StandardTemplate_DepthOnly_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_InvokeVertexPreprocessFunction(vertInput, vertOutput);
    StandardVertexInput stdInput;
    stdInput.vertInput = vertInput;
    StandardTemplate_VertSharedTransform(vertInput, vertOutput, stdInput.worldPos);
    StandardTemplate_InvokeVertexOverrideFunction(stdInput, vertOutput);
}
#endif
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color0 = (a_color0);
    vertexInput.normal = (a_normal);
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
    #ifdef INSTANCING__ON
    vertexInput.instanceData0 = i_data1;
    vertexInput.instanceData1 = i_data2;
    vertexInput.instanceData2 = i_data3;
    #endif
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    vertexOutput.texcoord0 = vec2(0, 0);
    vertexOutput.viewSpaceNormal = vec3(0, 0, 0);
    #ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    vertexOutput.viewSpacePosition = vec4(0, 0, 0, 0);
    vertexOutput.worldSpacePosition = vec4(0, 0, 0, 0);
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
    #ifndef DEPTH_ONLY_PASS
    StandardTemplate_Opaque_Vert(vertexInput, vertexOutput);
    #endif
    #ifdef DEPTH_ONLY_PASS
    StandardTemplate_DepthOnly_Vert(vertexInput, vertexOutput);
    #endif
    v_color0 = vertexOutput.color0;
    v_texcoord0 = vertexOutput.texcoord0;
    v_viewSpaceNormal = vertexOutput.viewSpaceNormal;
    #ifndef CUSTOM_PASS_BASED_ON_OPAQUE_PASS
    v_viewSpacePosition = vertexOutput.viewSpacePosition;
    v_worldSpacePosition = vertexOutput.worldSpacePosition;
    #endif
    gl_Position = vertexOutput.position;
}

