#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_SKY_PROBE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*/

#define shadow2D(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DArray(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DProj(_sampler, _coord)textureProj(_sampler, _coord)
#define attribute in
#define varying out
attribute vec4 a_color0;
attribute vec3 a_position;
attribute vec2 a_texcoord0;
#ifdef INSTANCING__ON
attribute vec4 i_data1;
attribute vec4 i_data2;
attribute vec4 i_data3;
#endif
varying vec4 v_color0;
varying vec3 v_ndcPosition;
varying vec2 v_texcoord0;
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
uniform mat4 PointLightProj;
uniform mat4 u_view;
uniform vec4 PointLightShadowParams1;
uniform vec4 SunDir;
uniform vec4 u_viewTexel;
uniform vec4 ShadowBias;
uniform vec4 ShadowSlopeBias;
uniform mat4 u_invView;
uniform mat4 u_viewProj;
uniform mat4 u_invProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 ManhattanDistAttenuationEnabled;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 CascadeShadowResolutions;
uniform vec4 u_alphaRef4;
uniform vec4 FogAndDistanceControl;
uniform vec4 AtmosphericScattering;
uniform vec4 ClusterSize;
uniform vec4 IBLSkyFadeParameters;
uniform vec4 SkyZenithColor;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraLightIntensity;
uniform vec4 CloudColor;
uniform vec4 WorldOrigin;
uniform mat4 CloudShadowProj;
uniform vec4 ClusterDimensions;
uniform vec4 PreExposureEnabled;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 SubsurfaceScatteringContribution;
uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 DistanceControl;
uniform vec4 ShadowParams;
uniform vec4 MoonColor;
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidth;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 ShadowPCFWidth;
uniform vec4 FogColor;
uniform vec4 FogSkyBlend;
uniform vec4 IBLParameters;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MaterialID;
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 MoonDir;
uniform mat4 PlayerShadowProj;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 SunColor;
uniform vec4 PointLightSpecularFadeOutParameters;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SkyHorizonColor;
uniform vec4 SkyProbeUVFadeParameters;
uniform vec4 SubPixelOffset;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeScatteringEnabled;
vec4 ViewRect;
mat4 Proj;
mat4 View;
vec4 ViewTexel;
mat4 InvView;
mat4 ViewProj;
mat4 InvProj;
mat4 InvViewProj;
mat4 PrevViewProj;
mat4 WorldArray[4];
mat4 World;
mat4 WorldView;
mat4 WorldViewProj;
vec4 PrevWorldPosOffset;
vec4 AlphaRef4;
float AlphaRef;
struct DiscreteLightingContributions {
    vec3 diffuse;
    vec3 specular;
    vec4 ambientTint;
};

struct LightData {
    float lookup;
};

struct Light {
    vec4 position;
    vec4 color;
    int shadowProbeIndex;
    int pad0;
    int pad1;
    int pad2;
};

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
    float uniformSubsurface;
    float maxMipColour;
    float maxMipMer;
    float maxMipNormal;
};

struct LightSourceWorldInfo {
    vec4 worldSpaceDirection;
    vec4 diffuseColorAndIlluminance;
    vec4 shadowDirection;
    mat4 shadowProj0;
    mat4 shadowProj1;
    mat4 shadowProj2;
    mat4 shadowProj3;
    int isSun;
    int shadowCascadeNumber;
    int pad0;
    int pad1;
};

struct PBRFragmentInfo {
    vec2 lightClusterUV;
    vec3 worldPosition;
    vec3 viewPosition;
    vec3 ndcPosition;
    vec3 worldNormal;
    vec3 viewNormal;
    vec3 albedo;
    float metalness;
    float roughness;
    float emissive;
    float subsurface;
    float blockAmbientContribution;
    float skyAmbientContribution;
};

struct PBRLightingContributions {
    vec3 directDiffuse;
    vec3 directSpecular;
    vec3 indirectDiffuse;
    vec3 indirectSpecular;
    vec3 emissive;
};

struct VertexInput {
    vec4 color0;
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
    vec3 ndcPosition;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec4 color0;
    vec3 ndcPosition;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_BrdfLUT;
uniform highp sampler2DShadow s_PlayerShadowMap;
uniform highp sampler2DArrayShadow s_PointLightShadowTextureArray;
uniform lowp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArrayShadow s_ShadowCascades;
uniform lowp samplerCube s_SpecularIBLCurrent;
uniform lowp samplerCube s_SpecularIBLPrevious;
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec4 color0;
    vec3 ndcPosition;
    vec3 worldPos;
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
    float Subsurface;
    vec3 AmbientLight;
    vec3 ViewSpaceNormal;
};

struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

struct AtmosphereParams {
    vec3 sunDir;
    vec3 moonDir;
    vec4 sunColor;
    vec4 moonColor;
    vec3 skyZenithColor;
    vec3 skyHorizonColor;
    vec4 fogColor;
    float horizonBlendMin;
    float horizonBlendStart;
    float mieStart;
    float horizonBlendMax;
    float rayleighStrength;
    float sunMieStrength;
    float moonMieStrength;
    float sunGlareShape;
};

struct TemporalAccumulationParameters {
    ivec3 dimensions;
    vec3 previousUvw;
    vec4 currentValue;
    float historyWeight;
    float frustumBoundaryFalloff;
};

#ifndef DEPTH_ONLY_PASS
vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x;
    offsetProj[2][1] -= SubPixelOffset.y;
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f)))));
}
void VertForwardPBRTransparent(in StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    vec4 clipPosition = vertOutput.position;
    vertOutput.position = jitterVertexPosition(stdInput.worldPos);
    vertOutput.ndcPosition = clipPosition.xyz / clipPosition.w;
    vec3 cloudColor = clamp(CloudColor.rgb * stdInput.vertInput.color0.rgb, 0.0, 1.0);
    vertOutput.color0 = vec4(cloudColor.r, cloudColor.g, cloudColor.b, CloudColor.a);
}
#endif
struct CompositingOutput {
    vec3 mLitColor;
};

void StandardTemplate_VertSharedTransform(inout StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    VertexInput vertInput = stdInput.vertInput;
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
    stdInput.worldPos = wpos;
    vertOutput.worldPos = wpos;
}
void StandardTemplate_VertexPreprocessIdentity(VertexInput vertInput, inout VertexOutput vertOutput) {
}
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_LightingVertexFunctionIdentity(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
}
#endif

void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput);
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition);
#endif
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

#ifdef DEPTH_ONLY_PASS
void DepthOnlyVertex(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position.z = clamp(vertOutput.position.z, 0.0, 1.0);
}
#endif
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_VertShared(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_InvokeVertexPreprocessFunction(vertInput, vertOutput);
    StandardVertexInput stdInput;
    stdInput.vertInput = vertInput;
    StandardTemplate_VertSharedTransform(stdInput, vertOutput);
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
    #ifdef DEPTH_ONLY_PASS
    DepthOnlyVertex(vertInput, vertOutput);
    #endif
    #ifndef DEPTH_ONLY_PASS
    VertForwardPBRTransparent(vertInput, vertOutput);
    #endif
}
#ifdef DEPTH_ONLY_PASS
void StandardTemplate_DepthOnly_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_InvokeVertexPreprocessFunction(vertInput, vertOutput);
    StandardVertexInput stdInput;
    stdInput.vertInput = vertInput;
    StandardTemplate_VertSharedTransform(stdInput, vertOutput);
    StandardTemplate_InvokeVertexOverrideFunction(stdInput, vertOutput);
}
#endif
#ifndef DEPTH_ONLY_PASS
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
    StandardTemplate_LightingVertexFunctionIdentity(vertInput, vertOutput, worldPosition);
}
void StandardTemplate_Opaque_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertShared(vertInput, vertOutput);
}
#endif
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.color0 = (a_color0);
    vertexInput.position = (a_position);
    vertexInput.texcoord0 = (a_texcoord0);
    #ifdef INSTANCING__ON
    vertexInput.instanceData0 = i_data1;
    vertexInput.instanceData1 = i_data2;
    vertexInput.instanceData2 = i_data3;
    #endif
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    vertexOutput.ndcPosition = vec3(0, 0, 0);
    vertexOutput.texcoord0 = vec2(0, 0);
    vertexOutput.worldPos = vec3(0, 0, 0);
    vertexOutput.position = vec4(0, 0, 0, 0);
    ViewRect = u_viewRect;
    Proj = u_proj;
    View = u_view;
    ViewTexel = u_viewTexel;
    InvView = u_invView;
    ViewProj = u_viewProj;
    InvProj = u_invProj;
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
    #ifdef DEPTH_ONLY_PASS
    StandardTemplate_DepthOnly_Vert(vertexInput, vertexOutput);
    #endif
    #ifndef DEPTH_ONLY_PASS
    StandardTemplate_Opaque_Vert(vertexInput, vertexOutput);
    #endif
    v_color0 = vertexOutput.color0;
    v_ndcPosition = vertexOutput.ndcPosition;
    v_texcoord0 = vertexOutput.texcoord0;
    v_worldPos = vertexOutput.worldPos;
    gl_Position = vertexOutput.position;
}

