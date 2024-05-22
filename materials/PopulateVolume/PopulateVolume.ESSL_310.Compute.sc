/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - POPULATE_PASS (not used)
*/

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
vec4 textureSample(NoopSampler noopsampler, vec2 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec3 vec3_splat(float _x) {
    return vec3(_x, _x, _x);
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

uniform mat4 PointLightProj;
uniform vec4 ShadowBias;
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform mat4 DirectionalLightSourceInvWaterSurfaceViewProj[2];
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 ManhattanDistAttenuationEnabled;
uniform vec4 JitterOffset;
uniform vec4 CascadeShadowResolutions;
uniform vec4 FogColor;
uniform vec4 VolumeDimensions;
uniform vec4 AirAlbedoExtinction;
uniform vec4 SkyZenithColor;
uniform vec4 IBLSkyFadeParameters;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 AmbientContribution;
uniform vec4 FogAndDistanceControl;
uniform vec4 AtmosphericScattering;
uniform vec4 ClusterSize;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraLightIntensity;
uniform vec4 CausticsParameters;
uniform vec4 WorldOrigin;
uniform mat4 CloudShadowProj;
uniform vec4 ClusterDimensions;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform vec4 DirectionalLightSourceIsSun[2];
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 MoonDir;
uniform vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform vec4 DirectionalLightSourceShadowDirection[2];
uniform mat4 DirectionalLightSourceShadowProj0[2];
uniform mat4 DirectionalLightSourceShadowProj1[2];
uniform mat4 DirectionalLightSourceShadowProj2[2];
uniform mat4 DirectionalLightSourceShadowProj3[2];
uniform mat4 DirectionalLightSourceWaterSurfaceViewProj[2];
uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 FogSkyBlend;
uniform vec4 HeightFogScaleBiasAndCameraUnderwaterAndWaterDepthBias;
uniform vec4 IBLParameters;
uniform vec4 HenyeyGreensteinG;
uniform vec4 MoonColor;
uniform mat4 PlayerShadowProj;
uniform vec4 PointLightAttenuationWindow;
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
uniform vec4 SubsurfaceScatteringContribution;
uniform vec4 SunColor;
uniform vec4 TemporalSettings;
uniform vec4 Time;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeScatteringEnabled;
uniform vec4 VolumeShadowSettings;
uniform vec4 WaterAlbedoExtinction;
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
uvec3 LocalInvocationID;
uint LocalInvocationIndex;
uvec3 GlobalInvocationID;
uvec3 WorkGroupID;
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

SAMPLER2D_AUTOREG(s_BrdfLUT);
IMAGE2D_ARRAY_WR_AUTOREG(s_CurrentLightingBuffer, rgba16f);
SAMPLER2D_HIGHP_AUTOREG(s_PlayerShadowMap);
SAMPLER2DARRAY_AUTOREG(s_PointLightShadowTextureArray);
SAMPLER2D_AUTOREG(s_PreviousFrameAverageLuminance);
SAMPLER2DARRAY_AUTOREG(s_PreviousLightingBuffer);
SAMPLER2DARRAY_AUTOREG(s_ScatteringBuffer);
SAMPLER2D_AUTOREG(s_ScreenSpaceWaterDepth);
SAMPLER2DARRAY_AUTOREG(s_ShadowCascades);
SAMPLERCUBE_AUTOREG(s_SpecularIBLCurrent);
SAMPLERCUBE_AUTOREG(s_SpecularIBLPrevious);
BUFFER_RW_AUTOREG(s_LightLookupArray, LightData);
BUFFER_RW_AUTOREG(s_Lights, Light);
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

bool areCascadedShadowsEnabled(float mode) {
    return int(mode) == 1;
}
float shadowSampleAndCompare(highp sampler2D shadowMap, float textureDimensions, vec2 uv, float comparisonValue, out float shadowDepth) {
    vec2 pixel = (uv * textureDimensions) + vec2(0.5, 0.5);
    vec2 weight = fract(pixel);
    vec4 samples = textureGather(shadowMap, uv, 0);
    shadowDepth = mix(mix(samples.w, samples.z, weight.x), mix(samples.x, samples.y, weight.x), weight.y);
    vec4 comparisonTests = vec4(step(comparisonValue, samples.x), step(comparisonValue, samples.y), step(comparisonValue, samples.z), step(comparisonValue, samples.w));
    return mix(mix(comparisonTests.w, comparisonTests.z, weight.x), mix(comparisonTests.x, comparisonTests.y, weight.x), weight.y);
}
float shadowSampleAndCompare(highp sampler2DArray shadowMap, float textureDimensions, vec3 uvw, float comparisonValue, out float shadowDepth) {
    vec2 pixel = (uvw.xy * textureDimensions) + vec2(0.5, 0.5);
    vec2 weight = fract(pixel);
    vec4 samples = textureGather(shadowMap, uvw, 0);
    shadowDepth = mix(mix(samples.w, samples.z, weight.x), mix(samples.x, samples.y, weight.x), weight.y);
    vec4 comparisonTests = vec4(step(comparisonValue, samples.x), step(comparisonValue, samples.y), step(comparisonValue, samples.z), step(comparisonValue, samples.w));
    return mix(mix(comparisonTests.w, comparisonTests.z, weight.x), mix(comparisonTests.x, comparisonTests.y, weight.x), weight.y);
}
bool pointInFrustum(vec4 projPos) {
    return projPos.x >= -1.0 && projPos.x <= 1.0 &&
    projPos.y >= -1.0 && projPos.y <= 1.0 &&
    projPos.z >= -1.0 && projPos.z <= 1.0;
}
int GetShadowCascade(int lightIndex, vec3 worldPos, out vec4 projPos) {
    projPos = ((DirectionalLightSourceShadowProj0[lightIndex]) * (vec4(worldPos, 1.0))); // Attention!
    if (pointInFrustum(projPos)) {
        return 0;
    }
    projPos = ((DirectionalLightSourceShadowProj1[lightIndex]) * (vec4(worldPos, 1.0))); // Attention!
    if (pointInFrustum(projPos)) {
        return 1;
    }
    projPos = ((DirectionalLightSourceShadowProj2[lightIndex]) * (vec4(worldPos, 1.0))); // Attention!
    if (pointInFrustum(projPos)) {
        return 2;
    }
    projPos = ((DirectionalLightSourceShadowProj3[lightIndex]) * (vec4(worldPos, 1.0))); // Attention!
    if (pointInFrustum(projPos)) {
        return 3;
    }
    return - 1;
}
float GetFilteredCloudShadow(vec3 worldPos, float NdL) {
    const int cloudCascade = 0;
    vec4 cloudProjPos = ((CloudShadowProj) * (vec4(worldPos, 1.0))); // Attention!
    cloudProjPos /= cloudProjPos.w;
    float bias = ShadowBias[cloudCascade] + ShadowSlopeBias[cloudCascade] * clamp(tan(acos(NdL)), 0.0, 1.0);
    cloudProjPos.z -= bias / cloudProjPos.w;
    vec2 cloudUv = (vec2(cloudProjPos.x, cloudProjPos.y) * 0.5f + 0.5f) * CascadeShadowResolutions[cloudCascade];
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * VolumeShadowSettings.x + 0.5f), 1, MaxFilterWidth);
    int filterOffset = filterWidth / 2;
    float amt = 0.f;
    cloudProjPos.z = cloudProjPos.z * 0.5 + 0.5;
    cloudUv.y += 1.0 - CascadeShadowResolutions[cloudCascade];
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * ShadowFilterOffsetAndRangeFarAndMapSize.x;
            vec3 uvw = vec3(cloudUv + (offset * CascadeShadowResolutions[cloudCascade]), DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * float(2));
            float shadowDepth = 0.0;
            amt += shadowSampleAndCompare(s_ShadowCascades, ShadowFilterOffsetAndRangeFarAndMapSize.z, uvw, cloudProjPos.z, shadowDepth);
        }
    }
    return amt / float(filterWidth * filterWidth);
}
float GetPlayerShadow(vec3 worldPos, float NdL) {
    const int playerCascade = 0;
    vec4 playerProjPos = ((PlayerShadowProj) * (vec4(worldPos, 1.0))); // Attention!
    float bias = ShadowBias[playerCascade] + ShadowSlopeBias[playerCascade] * clamp(tan(acos(NdL)), 0.0, 1.0);
    playerProjPos.z -= bias;
    playerProjPos.z = min(playerProjPos.z, 1.0);
    vec2 playerUv = (vec2(playerProjPos.x, playerProjPos.y) * 0.5f + 0.5f) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(2.0 * VolumeShadowSettings.x + 0.5f), 1, MaxFilterWidth);
    int filterOffset = filterWidth / 2;
    float amt = 0.f;
    playerProjPos.z = playerProjPos.z * 0.5 + 0.5;
    playerUv.y += 1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z;
            vec2 newUv = playerUv + (offset * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            if (newUv.x >= 0.0 && newUv.x < 1.0 && newUv.y >= 0.0 && newUv.y < 1.0) {
                float shadowDepth = 0.0;
                amt += shadowSampleAndCompare(s_PlayerShadowMap, FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.w, newUv, playerProjPos.z, shadowDepth);
            }
            else {
                amt += 1.0f;
            }
        }
    }
    return amt / float(filterWidth * filterWidth);
}
float GetFilteredShadow(int cascadeIndex, float projZ, int cascade, vec2 uv) {
    if (cascadeIndex < 0) {
        return 1.0;
    }
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(ShadowPCFWidth[cascade] * VolumeShadowSettings.x + 0.5), 1, MaxFilterWidth);
    int filterOffset = filterWidth / 2;
    float amt = 0.f;
    vec2 baseUv = uv * CascadeShadowResolutions[cascade];
    projZ = projZ * 0.5 + 0.5;
    baseUv.y += 1.0 - CascadeShadowResolutions[cascade];
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * ShadowFilterOffsetAndRangeFarAndMapSize.x;
            float shadowDepth = 0.0;
            amt += shadowSampleAndCompare(s_ShadowCascades, ShadowFilterOffsetAndRangeFarAndMapSize.z, vec3(baseUv + (offset * CascadeShadowResolutions[cascade]), (float(cascadeIndex) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(cascade)), projZ, shadowDepth);
        }
    }
    return amt / float(filterWidth * filterWidth);
}
float GetShadowAmount(int lightIndex, vec3 worldPos, float NdL, float viewDepth) {
    float amt = 1.0;
    float cloudAmt = 1.0;
    float playerAmt = 1.0;
    vec4 projPos;
    int cascade = GetShadowCascade(lightIndex, worldPos, projPos);
    if (cascade != -1) {
        float bias = ShadowBias[cascade] + ShadowSlopeBias[cascade] * clamp(tan(acos(NdL)), 0.0, 1.0);
        projPos.z -= bias / projPos.w;
        vec2 uv = vec2(projPos.x, projPos.y) * 0.5f + 0.5f;
        amt = GetFilteredShadow(int(DirectionalLightSourceShadowCascadeNumber[lightIndex].x), projPos.z, cascade, uv);
        if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0) {
            playerAmt = GetPlayerShadow(worldPos, NdL);
            amt = min(amt, playerAmt);
        }
        if (int(DirectionalLightSourceIsSun[lightIndex].x) > 0 && int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0) {
            cloudAmt = GetFilteredCloudShadow(worldPos, NdL);
            if (cloudAmt < 1.0) {
                cloudAmt = max(cloudAmt, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w);
                amt = min(amt, cloudAmt);
            }
        }
        float shadowFade = smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSize.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSize.y, - viewDepth);
        amt = mix(amt, 1.0, shadowFade);
    }
    return amt;
}
float linearToLogDepth(float linearDepth) {
    return log((exp(4.0) - 1.0) * linearDepth + 1.0) / 4.0;
}
float logToLinearDepth(float logDepth) {
    return (exp(4.0 * logDepth) - 1.0) / (exp(4.0) - 1.0);
}
vec3 ndcToVolume(vec3 ndc, mat4 inverseProj, vec2 nearFar) {
    vec2 uv = 0.5 * (ndc.xy + vec2(1.0, 1.0));
    vec4 view = ((inverseProj) * (vec4(ndc, 1.0))); // Attention!
    float viewDepth = -view.z / view.w;
    float wLinear = (viewDepth - nearFar.x) / (nearFar.y - nearFar.x);
    return vec3(uv, linearToLogDepth(wLinear));
}
vec3 volumeToNdc(vec3 uvw, mat4 proj, vec2 nearFar) {
    vec2 xy = 2.0 * uvw.xy - vec2(1.0, 1.0);
    float wLinear = logToLinearDepth(uvw.z);
    float viewDepth = -((1.0 - wLinear) * nearFar.x + wLinear * nearFar.y);
    vec4 ndcDepth = ((proj) * (vec4(0.0, 0.0, viewDepth, 1.0))); // Attention!
    float z = ndcDepth.z / ndcDepth.w;
    return vec3(xy, z);
}
vec3 worldToVolume(vec3 world, mat4 viewProj, mat4 invProj, vec2 nearFar) {
    vec4 proj = ((viewProj) * (vec4(world, 1.0))); // Attention!
    vec3 ndc = proj.xyz / proj.w;
    return ndcToVolume(ndc, invProj, nearFar);
}
vec3 volumeToWorld(vec3 uvw, mat4 invViewProj, mat4 proj, vec2 nearFar) {
    vec3 ndc = volumeToNdc(uvw, proj, nearFar);
    vec4 world = ((invViewProj) * (vec4(ndc, 1.0))); // Attention!
    return world.xyz / world.w;
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

TemporalAccumulationParameters createTemporalAccumulationParameters(ivec3 dimensions, vec3 previousUvw, vec4 currentValue, float historyWeight, float frustumBoundaryFalloff) {
    TemporalAccumulationParameters params;
    params.dimensions = dimensions;
    params.previousUvw = previousUvw;
    params.currentValue = currentValue;
    params.historyWeight = historyWeight;
    params.frustumBoundaryFalloff = frustumBoundaryFalloff;
    return params;
}
vec4 blendHistory(TemporalAccumulationParameters params, highp sampler2DArray previousVolume) {
    vec4 previousValue = sampleVolume(previousVolume, params.dimensions, params.previousUvw);
    vec3 previousTexelCoord = VolumeDimensions.xyz * params.previousUvw;
    vec3 previousTexelCoordClamped = clamp(previousTexelCoord, vec3(0.0, 0.0, 0.0), vec3(params.dimensions));
    float distanceFromBoundary = length(previousTexelCoordClamped - previousTexelCoord);
    float rejectHistory = clamp(distanceFromBoundary * params.frustumBoundaryFalloff, 0.0, 1.0);
    float blendWeight = mix(params.historyWeight, 0.0, rejectHistory);
    return mix(params.currentValue, previousValue, blendWeight);
}
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

float calculateFogIntensityFaded(float cameraDepth, float maxDistance, float fogStart, float fogEndMinusStartReciprocal, float fogAlpha) {
    float distance = cameraDepth / maxDistance;
    distance += fogAlpha;
    return clamp((distance - fogStart) * fogEndMinusStartReciprocal, 0.0, 1.0);
}
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

const float kInv4Pi = 1.0f / (4.0f * 3.1415926535897932384626433832795);
float henyeyGreenstein(float cosTheta, float g) {
    float denom = (1.0 + g * g + 2.0 * g * cosTheta);
    return kInv4Pi * (1.0 - g * g) / (denom * sqrt(denom));
}
void Populate() {
    int volumeWidth = int(VolumeDimensions.x);
    int volumeHeight = int(VolumeDimensions.y);
    int volumeDepth = int(VolumeDimensions.z);
    int x = int(GlobalInvocationID.x);
    int y = int(GlobalInvocationID.y);
    int z = int(GlobalInvocationID.z);
    if (x >= volumeWidth || y >= volumeHeight || z >= volumeDepth) {
        return;
    }
    vec3 uvw = (vec3(x, y, z) + vec3(0.5, 0.5, 0.5) + JitterOffset.xyz) / VolumeDimensions.xyz;
    vec3 worldPosition = volumeToWorld(uvw, InvViewProj, Proj, VolumeNearFar.xy);
    vec3 viewPosition = ((View) * (vec4(worldPosition, 1.0))).xyz; // Attention!
    vec3 worldAbsolute = worldPosition - WorldOrigin.xyz;
    float waterDepthSampleW = max(uvw.z - HeightFogScaleBiasAndCameraUnderwaterAndWaterDepthBias.w / VolumeDimensions.z, 0.0f);
    vec3 waterDepthSampleNdc = volumeToNdc(vec3(uvw.xy, waterDepthSampleW), Proj, VolumeNearFar.xy);
    float waterDepth = texelFetch(s_ScreenSpaceWaterDepth, ivec2(x, volumeHeight - 1 - y), 0).r;
    bool underwater = HeightFogScaleBiasAndCameraUnderwaterAndWaterDepthBias.z != 0.0f;
    if (waterDepthSampleNdc.z > waterDepth) {
        underwater = !underwater;
    }
    float density = underwater ? 1.0 : clamp(HeightFogScaleBiasAndCameraUnderwaterAndWaterDepthBias.x * worldPosition.y + HeightFogScaleBiasAndCameraUnderwaterAndWaterDepthBias.y, 0.0, 1.0);
    float viewDistance = length(viewPosition);
    float fogIntensity = calculateFogIntensityFaded(viewDistance, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y, RenderChunkFogAlpha.x);
    density = mix(density, 0.0, fogIntensity);
    vec4 albedoExtinction = underwater ? WaterAlbedoExtinction : AirAlbedoExtinction;
    float henyeyGreensteinG = underwater ? HenyeyGreensteinG.y : HenyeyGreensteinG.x;
    vec3 scattering = density * albedoExtinction.rgb * albedoExtinction.a;
    float extinction = density * albedoExtinction.a;
    vec3 source = vec3(0.0, 0.0, 0.0);
    vec3 blockAmbient = AmbientContribution.x * BlockBaseAmbientLightColorIntensity.rgb * BlockBaseAmbientLightColorIntensity.a;
    vec3 skyAmbient = AmbientContribution.y * SkyAmbientLightColorIntensity.rgb * SkyAmbientLightColorIntensity.a;
    vec3 ambient = blockAmbient + skyAmbient;
    ambient = max(ambient, vec3_splat(AmbientContribution.z));
    source += kInv4Pi * scattering * ambient * DiffuseSpecularEmissiveAmbientTermToggles.w;
    if (abs(AmbientContribution.y) > 0.0001) {
        int lightCount = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
        for(int i = 0; i < lightCount; i ++ ) {
            float directOcclusion = 1.0;
            if (areCascadedShadowsEnabled(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x)) {
                directOcclusion = GetShadowAmount(
                    i,
                    worldPosition,
                    1.0,
                0.0);
            }
            vec3 v = -(viewPosition / viewDistance);
            vec3 l = normalize(((View) * (DirectionalLightSourceWorldSpaceDirection[i])).xyz); // Attention!
            float phase = henyeyGreenstein(dot(v, l), henyeyGreensteinG);
            vec4 colorAndIlluminance = DirectionalLightSourceDiffuseColorAndIlluminance[i];
            vec3 illuminance = colorAndIlluminance.rgb * colorAndIlluminance.a;
            source += scattering * directOcclusion * phase * illuminance;
        }
    }
    if (TemporalSettings.x > 0.0) {
        vec3 uvwUnjittered = (vec3(x, y, z) + vec3(0.5, 0.5, 0.5)) / VolumeDimensions.xyz;
        vec3 worldPositionUnjittered = volumeToWorld(uvwUnjittered, InvViewProj, Proj, VolumeNearFar.xy);
        vec3 viewPositionUnjittered = ((View) * (vec4(worldPositionUnjittered, 1.0))).xyz; // Attention!
        vec3 previousWorldPosition = worldPositionUnjittered - PrevWorldPosOffset.xyz;
        vec3 previousUvw = worldToVolume(previousWorldPosition, PrevViewProj, PrevInvProj, VolumeNearFar.xy);
        vec4 currentValue = vec4(source, extinction);
        TemporalAccumulationParameters params = createTemporalAccumulationParameters(
            ivec3(VolumeDimensions.xyz),
            previousUvw,
            currentValue,
            TemporalSettings.z,
        TemporalSettings.y);
        vec4 result = blendHistory(params, s_PreviousLightingBuffer);
        imageStore(s_CurrentLightingBuffer, ivec3(x, y, z), result);
    }
    else {
        imageStore(s_CurrentLightingBuffer, ivec3(x, y, z), vec4(source, extinction));
    }
}

NUM_THREADS(8, 8, 8)
void main() {
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
    LocalInvocationID = gl_LocalInvocationID;
    LocalInvocationIndex = gl_LocalInvocationIndex;
    GlobalInvocationID = gl_GlobalInvocationID;
    WorkGroupID = gl_WorkGroupID;
    Populate();
}

