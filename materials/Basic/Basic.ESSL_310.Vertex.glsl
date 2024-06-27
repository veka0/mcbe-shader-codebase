#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* SampleMatTexture:
* - SAMPLE_MAT_TEXTURE__OFF (not used)
* - SAMPLE_MAT_TEXTURE__ON (not used)
*
* TransformUV0:
* - TRANSFORM_UV0__OFF (not used)
* - TRANSFORM_UV0__ON
*/

#extension GL_EXT_texture_cube_map_array : enable
#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec4 a_normal;
attribute vec3 a_position;
attribute vec4 a_tangent;
attribute vec2 a_texcoord0;
#ifdef INSTANCING__ON
attribute vec4 i_data1;
attribute vec4 i_data2;
attribute vec4 i_data3;
#endif
varying vec3 v_bitangent;
varying vec4 v_color0;
varying vec3 v_normal;
varying vec3 v_tangent;
varying vec2 v_texcoord0;
varying vec3 v_viewDir;
varying vec3 v_wpos;
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
mat4 mtxFromRows(vec4 _0, vec4 _1, vec4 _2, vec4 _3) {
    return transpose(mat4(_0, _1, _2, _3));
}
mat3 mtxFromRows(vec3 _0, vec3 _1, vec3 _2) {
    return transpose(mat3(_0, _1, _2));
}
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
uniform vec4 LightDirectionAndIntensity;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 MatColor;
uniform mat4 UV0Transform;
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
    vec4 tangent;
    vec2 texcoord0;
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec3 bitangent;
    vec4 color0;
    vec3 normal;
    vec3 tangent;
    vec2 texcoord0;
    vec3 viewDir;
    vec3 wpos;
};

struct FragmentInput {
    vec3 bitangent;
    vec4 color0;
    vec3 normal;
    vec3 tangent;
    vec2 texcoord0;
    vec3 viewDir;
    vec3 wpos;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_MatTexture;
void VertShared(VertexInput vertInput, inout VertexOutput vertOutput) {
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
    vec3 normal = vertInput.normal.xyz;
    vec3 wnormal = ((World) * (vec4(normal.xyz, 0.0))).xyz;
    vec3 tangent = vertInput.tangent.xyz;
    vec3 wtangent = ((World) * (vec4(tangent.xyz, 0.0))).xyz;
    vec3 viewNormal = normalize(((View) * (vec4(wnormal, 0.0))).xyz);
    vec3 viewTangent = normalize(((View) * (vec4(wtangent, 0.0))).xyz);
    vec3 viewBitangent = cross(viewNormal, viewTangent);
    mat3 tbn = mtxFromRows(viewTangent, viewBitangent, viewNormal);
    vertOutput.wpos = wpos.xyz;
    vec3 view = ((View) * (vec4(wpos, 0.0))).xyz;
    vertOutput.viewDir = ((view) * (tbn));
    vertOutput.normal = viewNormal;
    vertOutput.tangent = viewTangent;
    vertOutput.bitangent = viewBitangent;
    vertOutput.texcoord0 = vertInput.texcoord0;
    #ifdef TRANSFORM_UV0__ON
    vertOutput.texcoord0 = ((UV0Transform) * (vec4(vertOutput.texcoord0, 0, 1))).xy;
    #endif
    vertOutput.color0 = vertInput.color0;
}
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    VertShared(vertInput, vertOutput);
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color0 = (a_color0);
    vertexInput.normal = (a_normal);
    vertexInput.position = (a_position);
    vertexInput.tangent = (a_tangent);
    vertexInput.texcoord0 = (a_texcoord0);
    #ifdef INSTANCING__ON
    vertexInput.instanceData0 = i_data1;
    vertexInput.instanceData1 = i_data2;
    vertexInput.instanceData2 = i_data3;
    #endif
    vertexOutput.bitangent = vec3(0, 0, 0);
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    vertexOutput.normal = vec3(0, 0, 0);
    vertexOutput.tangent = vec3(0, 0, 0);
    vertexOutput.texcoord0 = vec2(0, 0);
    vertexOutput.viewDir = vec3(0, 0, 0);
    vertexOutput.wpos = vec3(0, 0, 0);
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
    v_bitangent = vertexOutput.bitangent;
    v_color0 = vertexOutput.color0;
    v_normal = vertexOutput.normal;
    v_tangent = vertexOutput.tangent;
    v_texcoord0 = vertexOutput.texcoord0;
    v_viewDir = vertexOutput.viewDir;
    v_wpos = vertexOutput.wpos;
    gl_Position = vertexOutput.position;
}

