#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORWARD_PBR_TRANSPARENT_PASS
* - FORWARD_PBR_TRANSPARENT_SKY_PROBE_PASS
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
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
varying vec4 v_color0;
varying vec3 v_ndcPosition;
varying vec2 v_texcoord0;
varying vec3 v_worldPos;
struct NoopSampler {
    int noop;
};

vec4 textureSample(mediump sampler2D _sampler, vec2 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump samplerCube _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2D _sampler, vec2 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump samplerCubeArray _sampler, vec4 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump samplerCubeArray _sampler, vec4 _coord, int _lod) {
    return textureLod(_sampler, _coord, float(_lod));
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec4 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec4 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
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
uniform mat4 PointLightProj;
uniform mat4 u_view;
uniform vec4 u_viewTexel;
uniform vec4 ShadowBias;
uniform vec4 PointLightShadowParams1;
uniform vec4 ShadowSlopeBias;
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
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 ManhattanDistAttenuationEnabled;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 CascadeShadowResolutions;
uniform vec4 u_alphaRef4;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraLightIntensity;
uniform vec4 CausticsParameters;
uniform vec4 CausticsTextureParameters;
uniform vec4 WorldOrigin;
uniform mat4 CloudShadowProj;
uniform vec4 ClusterDimensions;
uniform vec4 ShadowQuantizationParameters;
uniform vec4 ClusterSize;
uniform vec4 PreExposureEnabled;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform mat4 DirectionalLightSourceCausticsViewProj[2];
uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform vec4 DirectionalLightSourceIsSun[2];
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform vec4 DirectionalLightSourceShadowDirection[2];
uniform mat4 DirectionalLightSourceShadowInvProj0[2];
uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
uniform mat4 DirectionalLightSourceShadowInvProj1[2];
uniform mat4 DirectionalLightSourceShadowInvProj2[2];
uniform mat4 DirectionalLightSourceShadowProj0[2];
uniform mat4 DirectionalLightSourceShadowProj1[2];
uniform mat4 DirectionalLightSourceShadowProj2[2];
uniform vec4 LightDiffuseColorAndIlluminance;
uniform mat4 DirectionalLightSourceShadowProj3[2];
uniform mat4 DirectionalLightSourceWaterSurfaceViewProj[2];
uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform vec4 DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MaterialID;
uniform mat4 PlayerShadowProj;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 PointLightSpecularFadeOutParameters;
uniform vec4 ShadowPCFWidth;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SkyProbeUVFadeParameters;
uniform vec4 StarsColor;
uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform vec4 Time;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
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

uniform lowp sampler2D s_CausticsTexture;
uniform highp sampler2DArray s_PointLightShadowTextureArray;
uniform lowp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
layout(std430, binding = 1)buffer s_LightLookupArray { LightData LightLookupArray[]; };
layout(std430, binding = 2)buffer s_Lights { Light Lights[]; };
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec4 color0;
    vec3 ndcPosition;
};

struct StandardVertexInput {
    VertexInput vertInput;
    vec3 worldPos;
};

StandardSurfaceInput StandardTemplate_DefaultInput(FragmentInput fragInput) {
    StandardSurfaceInput result;
    result.UV = vec2(0, 0);
    result.Color = vec3(1, 1, 1);
    result.Alpha = 1.0;
    result.color0 = fragInput.color0;
    result.ndcPosition = fragInput.ndcPosition;
    return result;
}
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

StandardSurfaceOutput StandardTemplate_DefaultOutput() {
    StandardSurfaceOutput result;
    result.Albedo = vec3(1, 1, 1);
    result.Alpha = 1.0;
    result.Metallic = 0.0;
    result.Roughness = 1.0;
    result.Occlusion = 0.0;
    result.Emissive = 0.0;
    result.Subsurface = 0.0;
    result.AmbientLight = vec3(0.0, 0.0, 0.0);
    result.ViewSpaceNormal = vec3(0, 1, 0);
    return result;
}
float linearToLogDepth(float linearDepth) {
    return log((exp(4.0) - 1.0) * linearDepth + 1.0) / 4.0;
}
vec3 ndcToVolume(vec3 ndc, mat4 inverseProj, vec2 nearFar) {
    vec2 uv = 0.5 * (ndc.xy + vec2(1.0, 1.0));
    vec4 view = ((inverseProj) * (vec4(ndc, 1.0)));
    float viewDepth = -view.z / view.w;
    float wLinear = (viewDepth - nearFar.x) / (nearFar.y - nearFar.x);
    return vec3(uv, linearToLogDepth(wLinear));
}
vec4 sampleVolume(highp sampler2DArray volume, ivec3 dimensions, vec3 uvw) {
    float depth = uvw.z * float(dimensions.z) - 0.5;
    int index = clamp(int(depth), 0, dimensions.z - 2);
    float offset = clamp(depth - float(index), 0.0, 1.0);
    vec4 a = textureSample(volume, vec3(uvw.xy, index), 0.0).rgba;
    vec4 b = textureSample(volume, vec3(uvw.xy, index + 1), 0.0).rgba;
    return mix(a, b, offset);
}
struct TemporalAccumulationParameters {
    ivec3 dimensions;
    vec3 previousUvw;
    vec4 currentValue;
    float historyWeight;
    float frustumBoundaryFalloff;
};

vec3 PreExposeLighting(vec3 color, float averageLuminance) {
    return color * (0.18f / averageLuminance + 1e - 4);
}
void FragForwardPBRTransparent(StandardSurfaceInput fragInput, inout vec4 outColor) {
    vec3 starColor = fragInput.color0.rgb;
    starColor.rgb *= StarsColor.rgb * fragInput.color0.a;
    vec3 fogAppliedColor;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0) {
        vec3 uvw = ndcToVolume(fragInput.ndcPosition, InvProj, VolumeNearFar.xy);
        vec4 sourceExtinction = sampleVolume(s_ScatteringBuffer, ivec3(VolumeDimensions.xyz), uvw);
        fogAppliedColor = sourceExtinction.a * starColor.rgb;
    }
    else {
        fogAppliedColor = starColor.rgb;
    }
    outColor = vec4(fogAppliedColor, fragInput.color0.a);
}
struct CompositingOutput {
    vec3 mLitColor;
};

vec4 standardComposite(StandardSurfaceOutput stdOutput, CompositingOutput compositingOutput) {
    return vec4(compositingOutput.mLitColor, stdOutput.Alpha);
}
void StandardTemplate_FinalColorOverrideIdentity(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
}
void StandardTemplate_CustomSurfaceShaderEntryIdentity(vec2 uv, vec3 worldPosition, inout StandardSurfaceOutput surfaceOutput) {
}
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

vec3 computeLighting_Unlit(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return stdOutput.Albedo;
}
#ifdef FORWARD_PBR_TRANSPARENT_PASS
void StarsSurfaceFunction(StandardSurfaceInput fragInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 fogAppliedColor;
    FragForwardPBRTransparent(fragInput, fogAppliedColor);
    if (PreExposureEnabled.x > 0.0) {
        float exposure = textureSample(s_PreviousFrameAverageLuminance, vec2(0.5, 0.5)).r;
        fogAppliedColor.rgb = PreExposeLighting(fogAppliedColor.rgb, exposure);
    }
    surfaceOutput.Albedo = fogAppliedColor.rgb;
    surfaceOutput.Alpha = fogAppliedColor.a;
}
#endif
#ifdef FORWARD_PBR_TRANSPARENT_SKY_PROBE_PASS
void StarsSkyProbeSurfaceFunction(StandardSurfaceInput fragInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 fogAppliedColor;
    FragForwardPBRTransparent(fragInput, fogAppliedColor);
    vec2 uv = (fragInput.ndcPosition.xy + vec2(1.0, 1.0)) / 2.0;
    float fadeStart = SkyProbeUVFadeParameters.x;
    float fadeEnd = SkyProbeUVFadeParameters.y;
    float fadeRange = fadeStart - fadeEnd + 1e - 5;
    float fade = (clamp(uv.y, fadeEnd, fadeStart) - fadeEnd) / fadeRange;
    fogAppliedColor *= fade;
    if (PreExposureEnabled.x > 0.0) {
        fogAppliedColor.rgb = PreExposeLighting(fogAppliedColor.rgb, 1.0);
    }
    surfaceOutput.Albedo = fogAppliedColor.rgb;
    surfaceOutput.Alpha = max(fogAppliedColor.a, SkyProbeUVFadeParameters.z);
}
#endif
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #ifdef FORWARD_PBR_TRANSPARENT_PASS
    StarsSurfaceFunction(surfaceInput, surfaceOutput);
    #endif
    #ifdef FORWARD_PBR_TRANSPARENT_SKY_PROBE_PASS
    StarsSkyProbeSurfaceFunction(surfaceInput, surfaceOutput);
    #endif
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    StandardTemplate_FinalColorOverrideIdentity(fragInput, surfaceInput, surfaceOutput, fragOutput);
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.color0 = v_color0;
    fragmentInput.ndcPosition = v_ndcPosition;
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.worldPos = v_worldPos;
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
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    bgfx_FragColor = fragmentOutput.Color0;
}

