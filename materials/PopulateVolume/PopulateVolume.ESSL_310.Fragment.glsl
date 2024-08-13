#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - POPULATE_PASS (not used)
*/

#extension GL_EXT_texture_cube_map_array : enable
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
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
uniform vec4 ManhattanDistAttenuationEnabled;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 JitterOffset;
uniform vec4 CascadeShadowResolutions;
uniform vec4 u_alphaRef4;
uniform vec4 HeightFogScaleBias;
uniform vec4 AirAlbedoExtinction;
uniform vec4 SkyZenithColor;
uniform vec4 IBLSkyFadeParameters;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 AmbientContribution;
uniform vec4 LastSpecularIBLIdx;
uniform vec4 FogAndDistanceControl;
uniform vec4 DeferredWaterAndDirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex;
uniform vec4 AtmosphericScattering;
uniform vec4 ClusterSize;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraLightIntensity;
uniform vec4 CameraUnderwaterAndWaterSurfaceBiasAndFalloff;
uniform vec4 CausticsParameters;
uniform vec4 CausticsTextureParameters;
uniform vec4 WorldOrigin;
uniform mat4 CloudShadowProj;
uniform vec4 ClusterDimensions;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform mat4 DirectionalLightSourceCausticsViewProj[2];
uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform vec4 DirectionalLightSourceIsSun[2];
uniform vec4 MoonDir;
uniform vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform vec4 DirectionalLightSourceShadowDirection[2];
uniform mat4 DirectionalLightSourceShadowInvProj0[2];
uniform mat4 DirectionalLightSourceShadowInvProj1[2];
uniform mat4 DirectionalLightSourceShadowInvProj2[2];
uniform mat4 DirectionalLightSourceShadowProj0[2];
uniform mat4 DirectionalLightSourceShadowProj1[2];
uniform mat4 DirectionalLightSourceShadowProj2[2];
uniform mat4 DirectionalLightSourceShadowProj3[2];
uniform mat4 DirectionalLightSourceWaterSurfaceViewProj[2];
uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 FogColor;
uniform vec4 FogSkyBlend;
uniform vec4 IBLParameters;
uniform vec4 HenyeyGreensteinG;
uniform vec4 MoonColor;
uniform mat4 PlayerShadowProj;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform mat4 PointLightProj;
uniform vec4 SunDir;
uniform vec4 PointLightShadowParams1;
uniform vec4 PointLightSpecularFadeOutParameters;
uniform vec4 PreExposureEnabled;
uniform mat4 PrevInvProj;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
uniform vec4 ShadowPCFWidth;
uniform vec4 ShadowSlopeBias;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SkyHorizonColor;
uniform vec4 SubsurfaceScatteringContributionAndFalloffScale;
uniform vec4 SunColor;
uniform vec4 TemporalSettings;
uniform vec4 Time;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform vec4 VolumeShadowSettings;
uniform vec4 WaterAlbedoExtinction;
uniform vec4 WaterExtinctionCoefficients;
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
    float dummy;
};

struct VertexOutput {
    vec4 position;
};

struct FragmentInput {
    float dummy;
};

struct FragmentOutput {
    vec4 Color0;
};

layout(rgba16f, binding = 0)writeonly uniform highp image2DArray s_CurrentLightingBuffer;
uniform highp sampler2DArray s_PreviousLightingBuffer;
uniform lowp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
uniform lowp sampler2D s_ScreenSpaceWaterBackFaceDepthAndNormal;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp sampler2DArray s_PointLightShadowTextureArray;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform lowp sampler2D s_PreviousFrameAverageLuminance;
uniform lowp sampler2D s_CausticsTexture;
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform lowp sampler2D s_BrdfLUT;
layout(std430, binding = 5)buffer s_LightLookupArray { LightData LightLookupArray[]; };
layout(std430, binding = 6)buffer s_Lights { Light Lights[]; };
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    fragOutput.Color0 = vec4(0.0, 0.0, 0.0, 0.0);
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentOutput.Color0 = vec4(0, 0, 0, 0);
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
    Frag(fragmentInput, fragmentOutput);
    bgfx_FragColor = fragmentOutput.Color0;
}

