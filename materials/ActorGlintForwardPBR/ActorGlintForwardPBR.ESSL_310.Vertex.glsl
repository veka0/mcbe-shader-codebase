#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_OPAQUE_PASS
* - FORWARD_PBR_ALPHA_TEST_PASS (not used)
* - FORWARD_PBR_OPAQUE_PASS
* - FORWARD_PBR_TRANSPARENT_PASS
*
* Change_Color:
* - CHANGE_COLOR__MULTI (not used)
* - CHANGE_COLOR__OFF (not used)
* - CHANGE_COLOR__ON (not used)
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON (not used)
*/

#extension GL_EXT_texture_cube_map_array : enable
#define attribute in
#define varying out
attribute vec4 a_color0;
attribute float a_indices;
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
varying vec4 v_layerUv;
varying vec3 v_normal;
varying vec3 v_prevWorldPos;
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
uniform vec4 FogControl;
uniform vec4 ChangeColor;
uniform vec4 ShadowBias;
uniform vec4 u_viewTexel;
uniform mat4 DirectionalLightSourceShadowInvProj3[2];
uniform mat4 u_invView;
uniform mat4 u_viewProj;
uniform mat4 u_invProj;
uniform mat4 u_invViewProj;
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform mat4 DirectionalLightSourceInvWaterSurfaceViewProj[2];
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 CascadeShadowResolutions;
uniform vec4 u_alphaRef4;
uniform vec4 FogColor;
uniform vec4 VolumeDimensions;
uniform vec4 ActorFPEpsilon;
uniform vec4 LastSpecularIBLIdx;
uniform vec4 FogAndDistanceControl;
uniform vec4 AtmosphericScattering;
uniform vec4 ClusterSize;
uniform vec4 SkyZenithColor;
uniform vec4 IBLSkyFadeParameters;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform mat4 Bones[8];
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 WaterSurfaceParameters;
uniform vec4 CameraLightIntensity;
uniform vec4 TileLightIntensity;
uniform vec4 CausticsParameters;
uniform vec4 CausticsTextureParameters;
uniform vec4 WorldOrigin;
uniform mat4 CloudShadowProj;
uniform vec4 ClusterDimensions;
uniform mat4 DirectionalLightSourceShadowProj2[2];
uniform vec4 ColorBased;
uniform mat4 DirectionalLightSourceCausticsViewProj[2];
uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform vec4 DirectionalLightSourceIsSun[2];
uniform vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform vec4 DirectionalLightSourceShadowDirection[2];
uniform vec4 WaterSurfaceEnabled;
uniform mat4 DirectionalLightSourceShadowInvProj0[2];
uniform mat4 DirectionalLightSourceShadowInvProj1[2];
uniform mat4 DirectionalLightSourceShadowInvProj2[2];
uniform mat4 DirectionalLightSourceShadowProj0[2];
uniform mat4 DirectionalLightSourceShadowProj1[2];
uniform vec4 LightDiffuseColorAndIlluminance;
uniform mat4 DirectionalLightSourceShadowProj3[2];
uniform mat4 DirectionalLightSourceWaterSurfaceViewProj[2];
uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform vec4 DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex;
uniform vec4 FogSkyBlend;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 HudOpacity;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 IBLParameters;
uniform vec4 EmissiveUniform;
uniform vec4 GlintColor;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 ManhattanDistAttenuationEnabled;
uniform vec4 MatColor;
uniform vec4 MaterialID;
uniform vec4 MetalnessUniform;
uniform vec4 MoonColor;
uniform vec4 MoonDir;
uniform vec4 MultiplicativeTintColor;
uniform vec4 OverlayColor;
uniform vec4 ShadowSlopeBias;
uniform vec4 PBRTextureFlags;
uniform mat4 PlayerShadowProj;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 UseAlphaRewrite;
uniform mat4 PointLightProj;
uniform vec4 SunDir;
uniform vec4 PointLightShadowParams1;
uniform vec4 PointLightSpecularFadeOutParameters;
uniform vec4 PreExposureEnabled;
uniform mat4 PrevBones[8];
uniform mat4 PrevWorld;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 RoughnessUniform;
uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
uniform vec4 ShadowPCFWidth;
uniform vec4 ShadowQuantizationParameters;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SkyHorizonColor;
uniform vec4 SubPixelOffset;
uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform vec4 SubsurfaceUniform;
uniform vec4 SunColor;
uniform vec4 TileLightColor;
uniform vec4 Time;
uniform vec4 TintedAlphaTestEnabled;
uniform vec4 UVAnimation;
uniform vec4 UVScale;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform vec4 WaterExtinctionCoefficients;
uniform vec4 WaterSurfaceOctaveParameters;
uniform vec4 WaterSurfaceWaveParameters;
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

struct PBRFragmentInfo {
    vec2 lightClusterUV;
    vec3 worldPosition;
    vec3 viewPosition;
    vec3 ndcPosition;
    vec3 worldNormal;
    vec3 viewNormal;
    vec3 rf0;
    vec3 albedo;
    float metalness;
    float roughness;
    float emissive;
    float subsurface;
    float blockAmbientContribution;
    float skyAmbientContribution;
    vec2 causticsMultiplier;
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
    float uniformSubsurface;
    float maxMipColour;
    float maxMipMer;
    float maxMipNormal;
};

struct VertexInput {
    int boneId;
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
    vec4 layerUv;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec3 bitangent;
    vec4 color0;
    vec4 layerUv;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_BrdfLUT;
uniform lowp sampler2D s_CausticsTexture;
uniform lowp sampler2D s_MERSTexture;
uniform lowp sampler2D s_MatTexture;
uniform lowp sampler2D s_MatTexture1;
uniform lowp sampler2D s_NormalTexture;
uniform highp sampler2DArray s_PointLightShadowTextureArray;
uniform lowp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_SpecularIBLRecords;
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec3 bitangent;
    vec4 layerUv;
    vec3 normal;
    vec3 prevWorldPos;
    vec3 tangent;
    vec2 texcoord0;
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

vec4 jitterVertexPosition(vec3 worldPosition) {
    mat4 offsetProj = Proj;
    offsetProj[2][0] += SubPixelOffset.x;
    offsetProj[2][1] -= SubPixelOffset.y;
    return ((offsetProj) * (((View) * (vec4(worldPosition, 1.0f)))));
}
vec2 applyUvAnimation(vec2 uv, const vec4 uvAnimation) {
    uv = uvAnimation.xy + (uv * uvAnimation.zw);
    return uv;
}
void ActorVertPreprocessBase(inout VertexInput vertInput, inout VertexOutput vertOutput) {
    World = ((World) * (Bones[vertInput.boneId]));
    WorldView = ((View) * (World));
    WorldViewProj = ((Proj) * (WorldView));
    vec2 texcoord = vertInput.texcoord0;
    texcoord = applyUvAnimation(texcoord, UVAnimation);
    vertInput.texcoord0 = texcoord;
}
void ActorVertOverrideBase(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.position = jitterVertexPosition(vertInput.worldPos);
}
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
void packPBRVertOutput(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    mat4 prevWorldBones = ((PrevWorld) * (PrevBones[stdInput.vertInput.boneId]));
    vertOutput.prevWorldPos = ((prevWorldBones) * (vec4(stdInput.vertInput.position, 1.0))).xyz;
    vec3 n = stdInput.vertInput.normal.xyz;
    vec3 t = stdInput.vertInput.tangent.xyz;
    vec3 b = cross(n, t) * stdInput.vertInput.tangent.w;
    vertOutput.normal = ((World) * (vec4(n, 0.0))).xyz;
    vertOutput.tangent = ((World) * (vec4(t, 0.0))).xyz;
    vertOutput.bitangent = ((World) * (vec4(b, 0.0))).xyz;
}
void ActorVertPBR(StandardVertexInput stdInput, inout VertexOutput vertOutput) {
    ActorVertOverrideBase(stdInput, vertOutput);
    packPBRVertOutput(stdInput, vertOutput);
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
void StandardTemplate_LightingVertexFunctionIdentity(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
}

void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput);
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition);
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
struct ShadowParameters {
    vec4 cascadeShadowResolutions;
    vec4 shadowBias;
    vec4 shadowSlopeBias;
    vec4 shadowPCFWidth;
    int cloudshadowsEnabled;
    float cloudshadowContribution;
    float cloudshadowPCFWidth;
    vec4 shadowParams;
    mat4 cloudShadowProj;
};

struct DirectionalLightParams {
    mat4 shadowProj[4];
    int cascadeCount;
    int isSun;
    int index;
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

const int kInvalidPBRTextureHandle = 0xffff;
const int kPBRTextureDataFlagHasMaterialTexture = (1 << 0);
const int kPBRTextureDataFlagHasSubsurfaceChannel = (1 << 1);
const int kPBRTextureDataFlagHasNormalTexture = (1 << 2);
const int kPBRTextureDataFlagHasHeightMapTexture = (1 << 3);
#endif
#if defined(FORWARD_PBR_OPAQUE_PASS)|| defined(FORWARD_PBR_TRANSPARENT_PASS)
vec2 calculateLayerUV(const vec2 origUV, const float offset, const float rotation, const vec2 scale) {
    vec2 uv = origUV;
    uv -= 0.5;
    float rsin = sin(rotation);
    float rcos = cos(rotation);
    uv = ((uv) * (mat2(rcos, - rsin, rsin, rcos)));
    uv.x += offset;
    uv += 0.5;
    return uv * scale;
}
void ActorVertGlintPBR(VertexInput vertInput, inout VertexOutput vertOutput) {
    vertOutput.layerUv.xy = calculateLayerUV(vertInput.texcoord0, UVAnimation.x, UVAnimation.z, UVScale.xy);
    vertOutput.layerUv.zw = calculateLayerUV(vertInput.texcoord0, UVAnimation.y, UVAnimation.w, UVScale.xy);
    ActorVertPreprocessBase(vertInput, vertOutput);
}
#endif
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
void StandardTemplate_InvokeVertexPreprocessFunction(inout VertexInput vertInput, inout VertexOutput vertOutput) {
    #if ! defined(FORWARD_PBR_OPAQUE_PASS)&& ! defined(FORWARD_PBR_TRANSPARENT_PASS)
    ActorVertPreprocessBase(vertInput, vertOutput);
    #endif
    #if defined(FORWARD_PBR_OPAQUE_PASS)|| defined(FORWARD_PBR_TRANSPARENT_PASS)
    ActorVertGlintPBR(vertInput, vertOutput);
    #endif
}
void StandardTemplate_InvokeVertexOverrideFunction(StandardVertexInput vertInput, inout VertexOutput vertOutput) {
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    ActorVertOverrideBase(vertInput, vertOutput);
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    ActorVertPBR(vertInput, vertOutput);
    #endif
}
void StandardTemplate_InvokeLightingVertexFunction(VertexInput vertInput, inout VertexOutput vertOutput, vec3 worldPosition) {
    StandardTemplate_LightingVertexFunctionIdentity(vertInput, vertOutput, worldPosition);
}
void StandardTemplate_Opaque_Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
    StandardTemplate_VertShared(vertInput, vertOutput);
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexInput.boneId = int(a_indices);
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
    vertexOutput.layerUv = vec4(0, 0, 0, 0);
    vertexOutput.normal = vec3(0, 0, 0);
    vertexOutput.prevWorldPos = vec3(0, 0, 0);
    vertexOutput.tangent = vec3(0, 0, 0);
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
    StandardTemplate_Opaque_Vert(vertexInput, vertexOutput);
    v_bitangent = vertexOutput.bitangent;
    v_color0 = vertexOutput.color0;
    v_layerUv = vertexOutput.layerUv;
    v_normal = vertexOutput.normal;
    v_prevWorldPos = vertexOutput.prevWorldPos;
    v_tangent = vertexOutput.tangent;
    v_texcoord0 = vertexOutput.texcoord0;
    v_worldPos = vertexOutput.worldPos;
    gl_Position = vertexOutput.position;
}

