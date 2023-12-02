#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_FALLBACK_PASS (not used)
* - FALLBACK_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_PASS
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
#ifdef INSTANCING__ON
attribute vec4 i_data0;
attribute vec4 i_data1;
attribute vec4 i_data2;
attribute vec4 i_data3;
#endif
varying vec4 v_color0;
varying vec3 v_ndcPosition;
varying vec3 v_worldPosition;
struct NoopSampler {
    int noop;
};

#if defined(INSTANCING__ON)&&(defined(DEPTH_ONLY_PASS)|| defined(FORWARD_PBR_TRANSPARENT_PASS))
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
uniform vec4 ShadowBias;
uniform vec4 SunDir;
uniform vec4 u_viewTexel;
uniform vec4 ShadowSlopeBias;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform vec4 PrepassUVOffset;
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 CascadeShadowResolutions;
uniform vec4 u_alphaRef4;
uniform vec4 AtmosphericScatteringEnabled;
uniform vec4 VolumeScatteringEnabled;
uniform vec4 FogSkyBlend;
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 MoonDir;
uniform vec4 MoonColor;
uniform vec4 ShadowParams;
uniform vec4 DistanceControl;
uniform vec4 ClusterSize;
uniform vec4 FogAndDistanceControl;
uniform vec4 AtmosphericScattering;
uniform vec4 SubPixelOffset;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 DirectionalLightToggleAndCountAndMaxDistance;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 FogColor;
uniform vec4 VolumeDimensions;
uniform vec4 ShadowPCFWidth;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraLightIntensity;
uniform vec4 ClusterDimensions;
uniform vec4 SunColor;
uniform vec4 PointLightSpecularFadeOutParameters;
uniform vec4 VolumeNearFar;
uniform vec4 IBLParameters;
uniform vec4 CloudColor;
uniform vec4 SkyZenithColor;
uniform vec4 SkyHorizonColor;
uniform mat4 CloudShadowProj;
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

struct Light {
    vec4 position;
    vec4 color;
    int shadowProbeIndex;
    float gridLevelRadius;
    float higherGridLevelRadius;
    float lowerGridLevelRadius;
};

struct LightData {
    float lookup;
};

struct VertexInput {
    vec3 position;
    vec4 color0;
    #ifdef INSTANCING__ON
    vec4 instanceData2;
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData3;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec4 color0;
    vec3 worldPosition;
    vec3 ndcPosition;
};

struct FragmentInput {
    vec4 color0;
    vec3 worldPosition;
    vec3 ndcPosition;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp samplerCube s_SpecularIBL;
uniform highp sampler2DArrayShadow s_ShadowCascades0;
uniform highp sampler2DShadow s_CloudShadow;
uniform lowp sampler2D s_BrdfLUT;
uniform highp sampler2DArrayShadow s_ShadowCascades1;
uniform highp sampler2DArrayShadow s_PointLightShadowTextureArray;
uniform highp sampler2DArray s_ScatteringBuffer;
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

#ifdef FORWARD_PBR_TRANSPARENT_PASS
vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x;
    offsetProj[2][1] -= SubPixelOffset.y;
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f)))));
}
void VertForwardPBRTransparent(VertexInput vertInput, inout VertexOutput vertOutput) {
    #ifdef INSTANCING__OFF
    vec3 worldPosition = ((World) * (vec4(vertInput.position, 1.0))).xyz;
    #endif
    #ifdef INSTANCING__ON
    mat4 model;
    model[0] = vertInput.instanceData0;
    model[1] = vertInput.instanceData1;
    model[2] = vertInput.instanceData2;
    model[3] = vertInput.instanceData3;
    vec3 worldPosition = instMul(model, vec4(vertInput.position, 1.0)).xyz;
    #endif
    vec4 clipPosition = ((ViewProj) * (vec4(worldPosition, 1.0)));
    vec3 ndcPosition = clipPosition.xyz / clipPosition.w;
    vertOutput.position = jitterVertexPosition(worldPosition);
    vertOutput.worldPosition = worldPosition;
    vertOutput.ndcPosition = ndcPosition;
    vec3 cloudColor = clamp(CloudColor.rgb * vertInput.color0.rgb, 0.0, 1.0);
    vertOutput.color0 = vec4(cloudColor.r, cloudColor.g, cloudColor.b, CloudColor.a);
}
#endif
void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    #if defined(DEPTH_ONLY_PASS)&& defined(INSTANCING__OFF)
    vec3 worldPosition = ((World) * (vec4(vertInput.position, 1.0))).xyz;
    #endif
    #if defined(DEPTH_ONLY_PASS)&& defined(INSTANCING__ON)
    mat4 model;
    model[0] = vertInput.instanceData0;
    model[1] = vertInput.instanceData1;
    model[2] = vertInput.instanceData2;
    model[3] = vertInput.instanceData3;
    vec3 worldPosition = instMul(model, vec4(vertInput.position, 1.0)).xyz;
    #endif
    #ifdef DEPTH_ONLY_PASS
    vertOutput.position = ((ViewProj) * (vec4(worldPosition, 1.0)));
    vertOutput.position.z = clamp(vertOutput.position.z, 0.0, 1.0);
    #endif
    #ifdef FORWARD_PBR_TRANSPARENT_PASS
    VertForwardPBRTransparent(vertInput, vertOutput);
    #endif
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.position = (a_position);
    vertexInput.color0 = (a_color0);
    #ifdef INSTANCING__ON
    vertexInput.instanceData2 = i_data2;
    vertexInput.instanceData0 = i_data0;
    vertexInput.instanceData1 = i_data1;
    vertexInput.instanceData3 = i_data3;
    #endif
    vertexOutput.color0 = vec4(0, 0, 0, 0);
    vertexOutput.worldPosition = vec3(0, 0, 0);
    vertexOutput.ndcPosition = vec3(0, 0, 0);
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
    v_color0 = vertexOutput.color0;
    v_worldPosition = vertexOutput.worldPosition;
    v_ndcPosition = vertexOutput.ndcPosition;
    gl_Position = vertexOutput.position;
}

