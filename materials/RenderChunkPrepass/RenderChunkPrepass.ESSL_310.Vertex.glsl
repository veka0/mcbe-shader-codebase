#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_OPAQUE_PASS
* - GEOMETRY_PREPASS_PASS
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS
* - OPAQUE_PASS
* - TRANSPARENT_PASS
* - TRANSPARENT_PBR_PASS
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF (not used)
* - RENDER_AS_BILLBOARDS__ON
*
* Seasons:
* - SEASONS__OFF (not used)
* - SEASONS__ON (not used)
*/

#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec4 a_normal;
attribute vec3 a_position;
attribute vec4 a_tangent;
attribute vec2 a_texcoord0;
attribute vec2 a_texcoord1;
#if defined(INSTANCING__ON)&&(defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS))
attribute float a_texcoord4;
#endif
#ifdef INSTANCING__ON
attribute vec4 i_data1;
attribute vec4 i_data2;
attribute vec4 i_data3;
#endif
#if defined(INSTANCING__OFF)&&(defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS))
attribute float a_texcoord4;
#endif
varying vec3 v_bitangent;
varying vec4 v_color0;
varying vec4 v_fog;
varying vec2 v_lightmapUV;
varying vec3 v_normal;
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
flat varying int v_pbrTextureId;
#endif
varying vec3 v_tangent;
centroid varying vec2 v_texcoord0;
varying vec3 v_worldPos;
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
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 GlobalRoughness;
uniform vec4 FogAndDistanceControl;
uniform vec4 SubPixelOffset;
uniform vec4 ViewPositionAndTime;
uniform vec4 FogColor;
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
struct PBRTextureData {
    float colourToMaterialUvScale0;
    float colourToMaterialUvScale1;
    float colourToMaterialUvBias0;
    float colourToMaterialUvBias1;
    float colourToNormalUvScale0;
    float colourToNormalUvScale1;
    float colourToNormalUvBias0;
    float colourToNormalUvBias1;
    int flags;
    float uniformRoughness;
    float uniformEmissive;
    float uniformMetalness;
    float maxMipColour;
    float maxMipMer;
    float maxMipNormal;
    float pad;
};

struct VertexInput {
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(TRANSPARENT_PASS)
    vec4 normal;
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(OPAQUE_PASS)|| defined(TRANSPARENT_PBR_PASS)
    vec4 tangent;
    #endif
    vec3 position;
    vec2 texcoord0;
    #ifndef DEPTH_ONLY_PASS
    vec2 lightmapUV;
    #endif
    vec4 color0;
    #ifdef DEPTH_ONLY_PASS
    vec2 lightmapUV;
    #endif
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)|| defined(TRANSPARENT_PASS)
    vec4 tangent;
    #endif
    // Approximation, matches 42 cases out of 48
    #if ! defined(ALPHA_TEST_PASS)&& ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(TRANSPARENT_PASS)
    vec4 normal;
    #endif
    #if defined(INSTANCING__ON)&&(defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS))
    int pbrTextureId;
    #endif
    #ifdef INSTANCING__ON
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
    #if defined(DEPTH_ONLY_PASS)&& defined(INSTANCING__OFF)
    vec4 normal;
    #endif
    #if defined(INSTANCING__OFF)&&(defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS))
    int pbrTextureId;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec2 texcoord0;
    #if ! defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& ! defined(GEOMETRY_PREPASS_PASS)&& ! defined(OPAQUE_PASS)
    vec4 color0;
    #endif
    vec2 lightmapUV;
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)|| defined(TRANSPARENT_PASS)
    vec4 fog;
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(OPAQUE_PASS)
    vec4 color0;
    #endif
    #ifdef OPAQUE_PASS
    vec4 fog;
    #endif
    #ifndef TRANSPARENT_PBR_PASS
    vec3 normal;
    #endif
    vec3 tangent;
    #ifdef TRANSPARENT_PBR_PASS
    vec3 normal;
    #endif
    vec3 bitangent;
    vec3 worldPos;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int pbrTextureId;
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(TRANSPARENT_PBR_PASS)
    vec4 fog;
    #endif
};

struct FragmentInput {
    vec2 texcoord0;
    #if ! defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& ! defined(GEOMETRY_PREPASS_PASS)&& ! defined(OPAQUE_PASS)
    vec4 color0;
    #endif
    vec2 lightmapUV;
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)|| defined(TRANSPARENT_PASS)
    vec4 fog;
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(OPAQUE_PASS)
    vec4 color0;
    #endif
    #ifdef OPAQUE_PASS
    vec4 fog;
    #endif
    #ifndef TRANSPARENT_PBR_PASS
    vec3 normal;
    #endif
    vec3 tangent;
    #ifdef TRANSPARENT_PBR_PASS
    vec3 normal;
    #endif
    vec3 bitangent;
    vec3 worldPos;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int pbrTextureId;
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(TRANSPARENT_PBR_PASS)
    vec4 fog;
    #endif
};

struct FragmentOutput {
    vec4 Color0; vec4 Color1; vec4 Color2;
};

uniform lowp sampler2D s_MatTexture;
uniform lowp sampler2D s_SeasonsTexture;
uniform lowp sampler2D s_LightMapTexture;
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec2 lightmapUV;
    #if ! defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& ! defined(GEOMETRY_PREPASS_PASS)&& ! defined(TRANSPARENT_PBR_PASS)
    vec2 texcoord0;
    vec4 fog;
    #endif
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)|| defined(TRANSPARENT_PASS)
    vec3 normal;
    #endif
    vec3 tangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(OPAQUE_PASS)|| defined(TRANSPARENT_PBR_PASS)
    vec3 normal;
    #endif
    vec3 bitangent;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    int pbrTextureId;
    #endif
    vec3 worldPos;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(TRANSPARENT_PBR_PASS)
    vec2 texcoord0;
    vec4 fog;
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

vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x;
    offsetProj[2][1] -= SubPixelOffset.y;
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f)))));
}
float calculateFogIntensityFadedVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd, float fogAlpha) {
    float distance = cameraDepth / maxDistance;
    distance += fogAlpha;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
#ifdef RENDER_AS_BILLBOARDS__ON
void transformAsBillboardVertex(inout StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    stdInput.worldPos += vec3(0.5, 0.5, 0.5);
    vec3 forward = normalize(stdInput.worldPos - ViewPositionAndTime.xyz);
    vec3 right = normalize(cross(vec3(0.0, 1.0, 0.0), forward));
    vec3 up = cross(forward, right);
    vec3 offsets = stdInput.vertInput.color0.xyz;
    stdInput.worldPos -= up * (offsets.z - 0.5) + right * (offsets.x - 0.5);
    vertOutput.position = ((ViewProj) * (vec4(stdInput.worldPos, 1.0)));
}
#endif
#if ! defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& ! defined(GEOMETRY_PREPASS_PASS)
float RenderChunkVert(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    #ifdef RENDER_AS_BILLBOARDS__ON
    vertOutput.color0 = vec4(1.0, 1.0, 1.0, 1.0);
    transformAsBillboardVertex(stdInput, vertOutput);
    #endif
    float cameraDepth = length(ViewPositionAndTime.xyz - stdInput.worldPos);
    float fogIntensity = calculateFogIntensityFadedVanilla(cameraDepth, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y, RenderChunkFogAlpha.x);
    vertOutput.fog = vec4(FogColor.rgb, fogIntensity);
    vertOutput.position = jitterVertexPosition(stdInput.worldPos);
    return cameraDepth;
}
#endif
#if defined(TRANSPARENT_PASS)|| defined(TRANSPARENT_PBR_PASS)
void RenderChunkVertTransparent(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    float cameraDepth = RenderChunkVert(stdInput, vertOutput);
    bool shouldBecomeOpaqueInTheDistance = stdInput.vertInput.color0.a < 0.95;
    if (shouldBecomeOpaqueInTheDistance) {
        float cameraDistance = cameraDepth / FogAndDistanceControl.w;
        float alphaFadeOut = clamp(cameraDistance, 0.0, 1.0);
        vertOutput.color0.a = mix(stdInput.vertInput.color0.a, 1.0, alphaFadeOut);
    }
}
#endif
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
void calculateVertexPosition(inout StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    #ifdef RENDER_AS_BILLBOARDS__ON
    vertOutput.color0 = vec4(1.0, 1.0, 1.0, 1.0);
    transformAsBillboardVertex(stdInput, vertOutput);
    #endif
    vertOutput.position = jitterVertexPosition(stdInput.worldPos);
}
#endif
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

void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition);
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

void computeLighting_RenderChunk_Vertex(VertexInput vInput, inout VertexOutput vOutput, vec3 worldPosition) {
    vOutput.lightmapUV = vInput.lightmapUV;
}
#if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
float applyPBRValuesToVertexOutput(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    float cameraDepth = length(ViewPositionAndTime.xyz - stdInput.worldPos);
    float fogIntensity = calculateFogIntensityFadedVanilla(cameraDepth, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y, RenderChunkFogAlpha.x);
    vertOutput.fog = vec4(FogColor.rgb, fogIntensity);
    vertOutput.pbrTextureId = stdInput.vertInput.pbrTextureId & 0xffff;
    vec3 n = stdInput.vertInput.normal.xyz;
    vec3 t = stdInput.vertInput.tangent.xyz;
    vec3 b = cross(n, t);
    vertOutput.normal = ((World) * (vec4(n, 0.0))).xyz;
    vertOutput.tangent = ((World) * (vec4(t, 0.0))).xyz;
    vertOutput.bitangent = ((World) * (vec4(b, 0.0))).xyz;
    vertOutput.worldPos = stdInput.worldPos;
    return cameraDepth;
}
float RenderChunkPrepassVert(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    calculateVertexPosition(stdInput, vertOutput);
    return applyPBRValuesToVertexOutput(stdInput, vertOutput);
}
#endif
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
void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertexPreprocessIdentity(vertInput, vertOutput);
}
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)|| defined(OPAQUE_PASS)
    RenderChunkVert(vertInput, vertOutput);
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    RenderChunkPrepassVert(vertInput, vertOutput);
    #endif
    #if defined(TRANSPARENT_PASS)|| defined(TRANSPARENT_PBR_PASS)
    RenderChunkVertTransparent(vertInput, vertOutput);
    #endif
}
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
    computeLighting_RenderChunk_Vertex(vertInput, vertOutput, worldPosition);
}
void StandardTemplate_Opaque_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertShared(vertInput, vertOutput);
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(TRANSPARENT_PASS)
    vertexInput.normal = (a_normal);
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(OPAQUE_PASS)|| defined(TRANSPARENT_PBR_PASS)
    vertexInput.tangent = (a_tangent);
    #endif
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
    #ifndef DEPTH_ONLY_PASS
    vertexInput.lightmapUV = (a_texcoord1);
    #endif
    vertexInput.color0 = (a_color0);
    #ifdef DEPTH_ONLY_PASS
    vertexInput.lightmapUV = (a_texcoord1);
    #endif
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)|| defined(TRANSPARENT_PASS)
    vertexInput.tangent = (a_tangent);
    #endif
    // Approximation, matches 42 cases out of 48
    #if ! defined(ALPHA_TEST_PASS)&& ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(TRANSPARENT_PASS)
    vertexInput.normal = (a_normal);
    #endif
    #if defined(INSTANCING__ON)&&(defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS))
    vertexInput.pbrTextureId = int(a_texcoord4);
    #endif
    #ifdef INSTANCING__ON
    vertexInput.instanceData0 = i_data1;
    vertexInput.instanceData1 = i_data2;
    vertexInput.instanceData2 = i_data3;
    #endif
    #if defined(DEPTH_ONLY_PASS)&& defined(INSTANCING__OFF)
    vertexInput.normal = (a_normal);
    #endif
    #if defined(INSTANCING__OFF)&&(defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS))
    vertexInput.pbrTextureId = int(a_texcoord4);
    #endif
    vertexOutput.texcoord0 = vec2(0, 0);
    #if ! defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& ! defined(GEOMETRY_PREPASS_PASS)&& ! defined(OPAQUE_PASS)
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    #endif
    vertexOutput.lightmapUV = vec2(0, 0);
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)|| defined(TRANSPARENT_PASS)
    vertexOutput.fog = vec4(0, 0, 0, 0);
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(OPAQUE_PASS)
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    #endif
    #ifdef OPAQUE_PASS
    vertexOutput.fog = vec4(0, 0, 0, 0);
    #endif
    #ifndef TRANSPARENT_PBR_PASS
    vertexOutput.normal = vec3(0, 0, 0);
    #endif
    vertexOutput.tangent = vec3(0, 0, 0);
    #ifdef TRANSPARENT_PBR_PASS
    vertexOutput.normal = vec3(0, 0, 0);
    #endif
    vertexOutput.bitangent = vec3(0, 0, 0);
    vertexOutput.worldPos = vec3(0, 0, 0);
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    vertexOutput.pbrTextureId = 0;
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(TRANSPARENT_PBR_PASS)
    vertexOutput.fog = vec4(0, 0, 0, 0);
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
    StandardTemplate_Opaque_Vert(vertexInput, vertexOutput);
    v_texcoord0 = vertexOutput.texcoord0;
    #if ! defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)&& ! defined(GEOMETRY_PREPASS_PASS)&& ! defined(OPAQUE_PASS)
    v_color0 = vertexOutput.color0;
    #endif
    v_lightmapUV = vertexOutput.lightmapUV;
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)|| defined(TRANSPARENT_PASS)
    v_fog = vertexOutput.fog;
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(OPAQUE_PASS)
    v_color0 = vertexOutput.color0;
    #endif
    #ifdef OPAQUE_PASS
    v_fog = vertexOutput.fog;
    #endif
    #ifndef TRANSPARENT_PBR_PASS
    v_normal = vertexOutput.normal;
    #endif
    v_tangent = vertexOutput.tangent;
    #ifdef TRANSPARENT_PBR_PASS
    v_normal = vertexOutput.normal;
    #endif
    v_bitangent = vertexOutput.bitangent;
    v_worldPos = vertexOutput.worldPos;
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)
    v_pbrTextureId = vertexOutput.pbrTextureId;
    #endif
    #if defined(GEOMETRY_PREPASS_ALPHA_TEST_PASS)|| defined(GEOMETRY_PREPASS_PASS)|| defined(TRANSPARENT_PBR_PASS)
    v_fog = vertexOutput.fog;
    #endif
    gl_Position = vertexOutput.position;
}

