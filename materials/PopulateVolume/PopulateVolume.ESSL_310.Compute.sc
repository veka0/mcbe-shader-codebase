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
vec4 textureSample(mediump samplerCubeArray _sampler, vec4 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
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
vec3 vec3_splat(float _x) {
    return vec3(_x, _x, _x);
}
vec4 vec4_splat(float _x) {
    return vec4(_x, _x, _x, _x);
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

uniform vec4 ShadowBias;
uniform mat4 DirectionalLightSourceShadowInvProj3[2];
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform mat4 DirectionalLightSourceInvWaterSurfaceViewProj[2];
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform vec4 JitterOffset;
uniform vec4 CascadeShadowResolutions;
uniform mat4 DirectionalLightSourceShadowInvProj1[2];
uniform vec4 FogColor;
uniform vec4 VolumeDimensions;
uniform vec4 HeightFogScaleBias;
uniform vec4 AirAlbedoExtinction;
uniform vec4 SkyZenithColor;
uniform vec4 IBLSkyFadeParameters;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 AmbientContribution;
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
uniform vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform vec4 DirectionalLightSourceShadowDirection[2];
uniform mat4 DirectionalLightSourceShadowInvProj0[2];
uniform mat4 DirectionalLightSourceShadowInvProj2[2];
uniform mat4 DirectionalLightSourceShadowProj0[2];
uniform mat4 DirectionalLightSourceShadowProj1[2];
uniform mat4 DirectionalLightSourceShadowProj2[2];
uniform mat4 DirectionalLightSourceShadowProj3[2];
uniform mat4 DirectionalLightSourceWaterSurfaceViewProj[2];
uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 FogSkyBlend;
uniform vec4 IBLParameters;
uniform vec4 HenyeyGreensteinG;
uniform vec4 LastSpecularIBLIdx;
uniform vec4 ManhattanDistAttenuationEnabled;
uniform vec4 MoonColor;
uniform vec4 MoonDir;
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
uniform vec4 SubsurfaceScatteringContribution;
uniform vec4 SunColor;
uniform vec4 TemporalSettings;
uniform vec4 Time;
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
SAMPLER2D_AUTOREG(s_CausticsTexture);
IMAGE2D_ARRAY_WR_AUTOREG(s_CurrentLightingBuffer, rgba16f);
SAMPLER2DARRAY_AUTOREG(s_PointLightShadowTextureArray);
SAMPLER2D_AUTOREG(s_PreviousFrameAverageLuminance);
SAMPLER2DARRAY_AUTOREG(s_PreviousLightingBuffer);
SAMPLER2DARRAY_AUTOREG(s_ScatteringBuffer);
SAMPLER2D_AUTOREG(s_ScreenSpaceWaterDepthAndNormal);
SAMPLER2DARRAY_AUTOREG(s_ShadowCascades);
SAMPLERCUBEARRAY_AUTOREG(s_SpecularIBLRecords);
BUFFER_RW_AUTOREG(s_LightLookupArray, LightData);
BUFFER_RW_AUTOREG(s_Lights, Light);
float D_GGX_TrowbridgeReitz(vec3 N, vec3 H, float a) {
    float a2 = a * a;
    float nDotH = max(dot(N, H), 0.0);
    float f = max((a2 - 1.0) * nDotH * nDotH + 1.0, 1e - 4);
    return a2 / (f * f * 3.1415926535897932384626433832795);
}
float G_Smith(float nDotL, float nDotV, float a) {
    float k = a / 2.0;
    float viewTerm = nDotV / (nDotV * (1.0 - k) + k + 1e - 4);
    float lightTerm = nDotL / (nDotL * (1.0 - k) + k + 1e - 4);
    return viewTerm * lightTerm;
}
vec3 F_Schlick(vec3 V, vec3 H, vec3 R0) {
    float vDotH = max(dot(V, H), 0.0);
    return R0 + (1.0 - R0) * pow(clamp(1.0 - vDotH, 0.0, 1.0), 5.0);
}
vec3 BRDF_Spec_CookTorrance(float nDotL, float nDotV, float D, float G, vec3 F) {
    return (F * D * G) / (4.0 * nDotL * nDotV + 1e - 4);
}
vec3 BRDF_Diff_Lambertian(vec3 albedo) {
    return albedo / 3.1415926535897932384626433832795;
}
float getClusterDepthIndex(float viewSpaceDepth, float maxSlices, vec2 clusterNearFar) {
    float zNear = clusterNearFar.x;
    float zFar = clusterNearFar.y;
    if (viewSpaceDepth < zNear) {
        return - 1.0f;
    }
    if (viewSpaceDepth >= zNear && viewSpaceDepth <= 1.0f) {
        return 0.0f;
    }
    if (viewSpaceDepth > 1.0f && viewSpaceDepth <= 1.5f) {
        return 1.0f;
    }
    float nearFarLog = log2(zFar / 1.5f);
    return floor(log2(viewSpaceDepth / 1.5f) * ((maxSlices - 2.0f) / nearFarLog) + 2.0f); // Attention!
}
vec3 getClusterIndex(vec2 uv, float viewSpaceDepth, vec3 clusterDimensions, vec2 clusterNearFar, vec2 screenSize, vec2 clusterSize) {
    float viewportX = uv.x * screenSize.x;
    float viewportY = uv.y * screenSize.y;
    float clusterIdxX = floor(viewportX / clusterSize.x);
    float clusterIdxY = floor(viewportY / clusterSize.y);
    float clusterIdxZ = getClusterDepthIndex(viewSpaceDepth, clusterDimensions.z, clusterNearFar);
    return vec3(clusterIdxX, clusterIdxY, clusterIdxZ);
}
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
vec2 bilinearWeights(float textureDimensions, vec2 uv) {
    vec2 pixel = (uv * textureDimensions) + vec2(0.5, 0.5);
    return fract(pixel);
}
float bilinearFilter(vec4 samples, vec2 weights) {
    return mix(mix(samples.w, samples.z, weights.x), mix(samples.x, samples.y, weights.x), weights.y);
}
float bilinearPCF(vec4 samples, vec2 weights, float comparisonValue) {
    vec4 comparisonTests = step(comparisonValue, samples);
    return bilinearFilter(comparisonTests, weights);
}
bool pointInFrustum(vec4 projPos) {
    return projPos.x >= -1.0 && projPos.x <= 1.0 &&
    projPos.y >= -1.0 && projPos.y <= 1.0 &&
    projPos.z >= -1.0 && projPos.z <= 1.0;
}
int GetShadowCascade(int lightIndex, vec3 worldPos, out vec4 projPos, out mat4 invProj) {
    projPos = ((DirectionalLightSourceShadowProj0[lightIndex]) * (vec4(worldPos, 1.0))); // Attention!
    if (pointInFrustum(projPos)) {
        invProj = DirectionalLightSourceShadowInvProj0[lightIndex];
        return 0;
    }
    projPos = ((DirectionalLightSourceShadowProj1[lightIndex]) * (vec4(worldPos, 1.0))); // Attention!
    if (pointInFrustum(projPos)) {
        invProj = DirectionalLightSourceShadowInvProj1[lightIndex];
        return 1;
    }
    projPos = ((DirectionalLightSourceShadowProj2[lightIndex]) * (vec4(worldPos, 1.0))); // Attention!
    if (pointInFrustum(projPos)) {
        invProj = DirectionalLightSourceShadowInvProj2[lightIndex];
        return 2;
    }
    projPos = ((DirectionalLightSourceShadowProj3[lightIndex]) * (vec4(worldPos, 1.0))); // Attention!
    if (pointInFrustum(projPos)) {
        invProj = DirectionalLightSourceShadowInvProj3[lightIndex];
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
            vec3 uvw = vec3(cloudUv + (offset * CascadeShadowResolutions[cloudCascade]), (DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * float(2)));
            vec4 shadowSamples = textureGather(s_ShadowCascades, uvw, 0);
            vec2 weights = bilinearWeights(ShadowFilterOffsetAndRangeFarAndMapSize.z, uvw.xy);
            amt += bilinearPCF(shadowSamples, weights, cloudProjPos.z);
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
    bool inPlayerTextureBounds = playerUv.x >= 0.0 && playerUv.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y && playerUv.y >= (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y)&& playerUv.y < 1.0;
    if (!inPlayerTextureBounds) {
        return 1.0;
    }
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z;
            vec2 newUv = playerUv + (offset * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            vec3 uvw = vec3(newUv.x, newUv.y, ((DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * float(2)) + 1.0));
            vec4 shadowSamples = textureGather(s_ShadowCascades, uvw, 0);
            vec2 weights = bilinearWeights(ShadowFilterOffsetAndRangeFarAndMapSize.z, uvw.xy);
            amt += bilinearPCF(shadowSamples, weights, playerProjPos.z);
        }
    }
    return amt / float(filterWidth * filterWidth);
}
float GetFilteredShadow(int cascadeIndex, float projZ, int cascade, vec2 uv, out float shadowDepth) {
    if (cascadeIndex < 0) {
        shadowDepth = 0.0;
        return 1.0;
    }
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(ShadowPCFWidth[cascade] * VolumeShadowSettings.x + 0.5), 1, MaxFilterWidth);
    int filterOffset = filterWidth / 2;
    float amt = 0.f;
    vec2 baseUv = uv * CascadeShadowResolutions[cascade];
    projZ = projZ * 0.5 + 0.5;
    baseUv.y += 1.0 - CascadeShadowResolutions[cascade];
    float depthSamples = 0.0;
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * ShadowFilterOffsetAndRangeFarAndMapSize.x;
            vec3 uvw = vec3(baseUv + (offset * CascadeShadowResolutions[cascade]), (float(cascadeIndex) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(cascade));
            vec4 shadowSamples = textureGather(s_ShadowCascades, uvw, 0);
            vec2 weights = bilinearWeights(ShadowFilterOffsetAndRangeFarAndMapSize.z, uvw.xy);
            amt += bilinearPCF(shadowSamples, weights, projZ);
            depthSamples += bilinearFilter(shadowSamples, weights);
        }
    }
    shadowDepth = depthSamples / float(filterWidth * filterWidth);
    return amt / float(filterWidth * filterWidth);
}
float GetShadowAmount(int lightIndex, vec3 worldPos, float NdL, float viewDepth, out float depth) {
    float amt = 1.0;
    float cloudAmt = 1.0;
    float playerAmt = 1.0;
    vec4 projPos;
    mat4 invProj;
    int cascade = GetShadowCascade(lightIndex, worldPos, projPos, invProj);
    if (cascade != -1) {
        float bias = ShadowBias[cascade] + ShadowSlopeBias[cascade] * clamp(tan(acos(NdL)), 0.0, 1.0);
        vec2 uv = vec2(projPos.x, projPos.y) * 0.5f + 0.5f;
        float shadowDepth;
        float biasedDepth = projPos.z - bias / projPos.w;
        amt = GetFilteredShadow(int(DirectionalLightSourceShadowCascadeNumber[lightIndex].x), biasedDepth, cascade, uv, shadowDepth);
        float shadowMapDepthRange = length(((invProj) * (vec4(0.0, 0.0, 1.0, 0.0)))); // Attention!
        depth = (projPos.z - shadowDepth) * shadowMapDepthRange;
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

vec3 findLinePlaneIntersectionForCubemap(vec3 normal, vec3 lineDirection) {
    return lineDirection * (1.f / dot(lineDirection, normal));
}
vec3 getSampleCoordinateForAdjacentFace(vec3 inCoordinate) {
    vec3 outCoordinate = inCoordinate;
    if (inCoordinate.y > 1.0f) {
        switch(int(inCoordinate.z)) {
            case 0 :
            outCoordinate.z = float(3);
            outCoordinate.x = 2.0f - inCoordinate.y;
            outCoordinate.y = inCoordinate.x;
            break;
            case 1 :
            outCoordinate.z = float(3);
            outCoordinate.x = inCoordinate.y - 1.0f;
            outCoordinate.y = 1.0f - inCoordinate.x;
            break;
            case 2 :
            outCoordinate.z = float(4);
            outCoordinate.x = inCoordinate.x;
            outCoordinate.y = inCoordinate.y - 1.0f;
            break;
            case 3 :
            outCoordinate.z = float(5);
            outCoordinate.x = 1.0f - inCoordinate.x;
            outCoordinate.y = 2.0f - inCoordinate.y;
            break;
            case 4 :
            outCoordinate.z = float(3);
            outCoordinate.x = inCoordinate.x;
            outCoordinate.y = inCoordinate.y - 1.0f;
            break;
            case 5 :
            outCoordinate.z = float(3);
            outCoordinate.x = 1.0f - inCoordinate.x;
            outCoordinate.y = 2.0f - inCoordinate.y;
            break;
            default :
            break;
        }
    } else if (inCoordinate.y < 0.0f) {
        switch(int(inCoordinate.z)) {
            case 0 :
            outCoordinate.z = float(2);
            outCoordinate.x = 1.0f + inCoordinate.y;
            outCoordinate.y = 1.0f - inCoordinate.x;
            break;
            case 1 :
            outCoordinate.z = float(2);
            outCoordinate.x = -inCoordinate.y;
            outCoordinate.y = inCoordinate.x;
            break;
            case 2 :
            outCoordinate.z = float(5);
            outCoordinate.x = 1.0f - inCoordinate.x;
            outCoordinate.y = -inCoordinate.y;
            break;
            case 3 :
            outCoordinate.z = float(4);
            outCoordinate.x = inCoordinate.x;
            outCoordinate.y = 1.0f + inCoordinate.y;
            break;
            case 4 :
            outCoordinate.z = float(2);
            outCoordinate.x = inCoordinate.x;
            outCoordinate.y = 1.0f + inCoordinate.y;
            break;
            case 5 :
            outCoordinate.z = float(2);
            outCoordinate.x = 1.0f - inCoordinate.x;
            outCoordinate.y = -inCoordinate.y;
            break;
            default :
            break;
        }
    }
    vec2 uvCache = outCoordinate.xy;
    if (uvCache.x > 1.0) {
        switch(int(outCoordinate.z)) {
            case 0 :
            outCoordinate.z = float(5);
            outCoordinate.x = uvCache.x - 1.0f;
            outCoordinate.y = uvCache.y;
            break;
            case 1 :
            outCoordinate.z = float(4);
            outCoordinate.x = uvCache.x - 1.0f;
            outCoordinate.y = uvCache.y;
            break;
            case 2 :
            outCoordinate.z = float(0);
            outCoordinate.x = 1.0f - uvCache.y;
            outCoordinate.y = uvCache.x - 1.0f;
            break;
            case 3 :
            outCoordinate.z = float(0);
            outCoordinate.x = uvCache.y;
            outCoordinate.y = 2.0f - uvCache.x;
            break;
            case 4 :
            outCoordinate.z = float(0);
            outCoordinate.x = uvCache.x - 1.0f;
            outCoordinate.y = uvCache.y;
            break;
            case 5 :
            outCoordinate.z = float(1);
            outCoordinate.x = uvCache.x - 1.0f;
            outCoordinate.y = uvCache.y;
            break;
            default :
            break;
        }
    } else if (uvCache.x < 0.0) {
        switch(int(outCoordinate.z)) {
            case 0 :
            outCoordinate.z = float(4);
            outCoordinate.x = 1.0f + uvCache.x;
            outCoordinate.y = uvCache.y;
            break;
            case 1 :
            outCoordinate.z = float(5);
            outCoordinate.x = 1.0f + uvCache.x;
            outCoordinate.y = uvCache.y;
            break;
            case 2 :
            outCoordinate.z = float(1);
            outCoordinate.x = uvCache.y;
            outCoordinate.y = -uvCache.x;
            break;
            case 3 :
            outCoordinate.z = float(1);
            outCoordinate.x = 1.0f - uvCache.y;
            outCoordinate.y = 1.0f + uvCache.x;
            break;
            case 4 :
            outCoordinate.z = float(1);
            outCoordinate.x = 1.0f + uvCache.x;
            outCoordinate.y = uvCache.y;
            break;
            case 5 :
            outCoordinate.z = float(0);
            outCoordinate.x = 1.0f + uvCache.x;
            outCoordinate.y = uvCache.y;
            break;
            default :
            break;
        }
    }
    return outCoordinate;
}
float wrappedDiffuse(vec3 n, vec3 l, float w) {
    return max((dot(n, l) + w) / ((1.0 + w) * (1.0 + w)), 0.0); // Attention!
}
void BSDF_VanillaMinecraft(vec3 n, vec3 l, vec3 v, vec3 color, float metalness, float linearRoughness, float subsurface, vec3 rf0, float diffuseEnabled, float specularEnabled, inout vec3 diffuse, inout vec3 specular) {
    float nDotL = max(dot(n, l), 0.0);
    float nDotV = max(dot(n, v), 0.0);
    float nDotLSubsurf = mix(nDotL, wrappedDiffuse(n, l, 0.25) + wrappedDiffuse(-n, l, 0.25), subsurface);
    vec3 h = normalize(l + v);
    float roughness = linearRoughness * linearRoughness;
    float d = D_GGX_TrowbridgeReitz(n, h, roughness);
    float g = G_Smith(nDotL, nDotV, roughness);
    vec3 f = F_Schlick(v, h, rf0);
    vec3 albedo = (1.0 - f) * (1.0 - metalness) * color; // Attention!
    diffuse = nDotLSubsurf * BRDF_Diff_Lambertian(albedo) * diffuseEnabled;
    specular = nDotL * BRDF_Spec_CookTorrance(nDotL, nDotV, d, g, f) * specularEnabled;
}
void BSDF_VanillaMinecraft_DiffuseOnly(vec3 n, vec3 l, vec3 color, float metalness, float subsurface, float diffuseEnabled, inout vec3 diffuse) {
    float nDotL = max(dot(n, l), 0.0);
    float nDotLSubsurf = mix(nDotL, wrappedDiffuse(n, l, 0.25) + wrappedDiffuse(-n, l, 0.25), subsurface);
    vec3 albedo = (1.0 - metalness) * color;
    diffuse = nDotLSubsurf * BRDF_Diff_Lambertian(albedo) * diffuseEnabled;
}
void BSDF_VanillaMinecraft_SpecularOnly(vec3 n, vec3 l, vec3 v, float metalness, float linearRoughness, vec3 rf0, float specularEnabled, inout vec3 specular) {
    float nDotL = max(dot(n, l), 0.0);
    float nDotV = max(dot(n, v), 0.0);
    vec3 h = normalize(l + v);
    float roughness = linearRoughness * linearRoughness;
    float d = D_GGX_TrowbridgeReitz(n, h, roughness);
    float g = G_Smith(nDotL, nDotV, roughness);
    vec3 f = F_Schlick(v, h, rf0);
    specular = nDotL * BRDF_Spec_CookTorrance(nDotL, nDotV, d, g, f) * specularEnabled;
}
float smoothWindowAttenuation(float sqrDistance, float sqrRadius, float t) {
    return clamp(smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, t) * PointLightAttenuationWindow.z + PointLightAttenuationWindow.w, 0.0, 1.0);
}
float smoothDistanceAttenuation(float sqrDistance, float sqrRadius) {
    float ratio = sqrDistance / sqrRadius;
    float smoothFactor = clamp(1.0f - ratio * ratio, 0.0, 1.0);
    return smoothFactor * smoothFactor;
}
float getDistanceAttenuation(float sqrDistance, float radius) {
    float attenuation = 1.0f / max(sqrDistance, 0.01f * 0.01f);
    attenuation *= smoothDistanceAttenuation(sqrDistance, radius * radius);
    if (PointLightAttenuationWindowEnabled.x > 0.0f) {
        attenuation *= smoothWindowAttenuation(sqrDistance, radius * radius, 1.0f - attenuation);
    }
    return attenuation;
}
float calculateDirectOcclusionForDiscreteLight(int lightIndex, vec3 surfaceWorldPos, vec3 surfaceWorldNormal, bool useShadowBias) {
    Light lightInfo = Lights[lightIndex];
    if (lightInfo.shadowProbeIndex < 0) {
        return 1.f;
    }
    vec3 lightToPoint = surfaceWorldPos - lightInfo.position.xyz;
    vec3 surfaceViewPosition = abs(lightToPoint);
    vec3 sampleCoordinates = vec3_splat(0.f);
    if (surfaceViewPosition.x >= surfaceViewPosition.y && surfaceViewPosition.x >= surfaceViewPosition.z) {
        surfaceViewPosition = vec3(surfaceViewPosition.y, surfaceViewPosition.z, surfaceViewPosition.x);
        if (lightToPoint.x > 0.f) {
            vec3 intersection = findLinePlaneIntersectionForCubemap(vec3(1.f, 0.f, 0.f), lightToPoint);
            intersection = intersection * 0.5f + 0.5f;
            sampleCoordinates = vec3(1.f - intersection.z, intersection.y, float(0));
        } else {
            vec3 intersection = findLinePlaneIntersectionForCubemap(vec3(-1.f, 0.f, 0.f), lightToPoint);
            intersection = intersection * 0.5f + 0.5f;
            sampleCoordinates = vec3(intersection.z, intersection.y, float(1));
        }
    } else if (surfaceViewPosition.y >= surfaceViewPosition.z) {
        surfaceViewPosition = vec3(surfaceViewPosition.x, surfaceViewPosition.z, surfaceViewPosition.y);
        if (lightToPoint.y > 0.f) {
            vec3 intersection = findLinePlaneIntersectionForCubemap(vec3(0.f, 1.f, 0.f), lightToPoint);
            intersection = intersection * 0.5f + 0.5f;
            sampleCoordinates = vec3(intersection.x, 1.f - intersection.z, float(2));
        } else {
            vec3 intersection = findLinePlaneIntersectionForCubemap(vec3(0.f, - 1.f, 0.f), lightToPoint);
            intersection = intersection * 0.5f + 0.5f;
            sampleCoordinates = vec3(intersection.x, intersection.z, float(3));
        }
    } else {
        if (lightToPoint.z > 0.f) {
            vec3 intersection = findLinePlaneIntersectionForCubemap(vec3(0.f, 0.f, 1.f), lightToPoint);
            intersection = intersection * 0.5f + 0.5f;
            sampleCoordinates = vec3(intersection.x, intersection.y, float(4));
        } else {
            vec3 intersection = findLinePlaneIntersectionForCubemap(vec3(0.f, 0.f, - 1.f), lightToPoint);
            intersection = intersection * 0.5f + 0.5f;
            sampleCoordinates = vec3(1.f - intersection.x, intersection.y, float(5));
        }
    }
    surfaceViewPosition.z *= -1.f;
    vec4 surfaceProjPos = ((PointLightProj) * (vec4(surfaceViewPosition, 1.0))); // Attention!
    if (useShadowBias) {
        float NdL = dot(-normalize(lightToPoint), surfaceWorldNormal);
        float bias = PointLightShadowParams1.x + PointLightShadowParams1.y * clamp(tan(acos(NdL)), 0.0, 1.0);
        surfaceProjPos.z += bias;
    }
    surfaceProjPos /= surfaceProjPos.w;
    int filterWidth = 4;
    int filterOffset = filterWidth / 2;
    float directOcclusion = 0.f;
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * PointLightShadowParams1.w;
            vec3 offsetSampleCoordinates = getSampleCoordinateForAdjacentFace(vec3(sampleCoordinates.x + offset.x, 1.0f - sampleCoordinates.y + offset.y, sampleCoordinates.z));
            offsetSampleCoordinates.z = float(lightInfo.shadowProbeIndex * 6) + offsetSampleCoordinates.z;
            vec4 shadowSamples = textureGather(s_PointLightShadowTextureArray, offsetSampleCoordinates, 0);
            vec2 weights = bilinearWeights(1.0 / PointLightShadowParams1.w, offsetSampleCoordinates.xy);
            directOcclusion += bilinearPCF(shadowSamples, weights, surfaceProjPos.z);
        }
    }
    return directOcclusion / float(filterWidth * filterWidth);
}
bool getLightClusterRangeIfValid(vec2 lightClusterUV, float surfaceViewPosZ, out highp int rangeStart, out highp int rangeEnd) {
    vec3 clusterId = getClusterIndex(lightClusterUV, - surfaceViewPosZ, ClusterDimensions.xyz, ClusterNearFarWidthHeight.xy, ClusterNearFarWidthHeight.zw, ClusterSize.xy);
    if (clusterId.x < 0.0 || clusterId.y < 0.0 || clusterId.z < 0.0 || clusterId.x >= ClusterDimensions.x || clusterId.y >= ClusterDimensions.y || clusterId.z >= ClusterDimensions.z) {
        return false;
    }
    highp int clusterIdx = int(clusterId.x + clusterId.y * ClusterDimensions.x + clusterId.z * ClusterDimensions.x * ClusterDimensions.y);
    rangeStart = clusterIdx * int(ClusterDimensions.w);
    rangeEnd = rangeStart + int(ClusterDimensions.w);
    return true;
}
float getSquaredDistanceToLight(vec3 lightWorldDir) {
    float squaredDistanceToLight = 0.0f;
    if (ManhattanDistAttenuationEnabled.x > 0.0f) {
        squaredDistanceToLight = abs(lightWorldDir.x) + abs(lightWorldDir.y) + abs(lightWorldDir.z);
        squaredDistanceToLight = dot(squaredDistanceToLight, squaredDistanceToLight);
    }
    else {
        squaredDistanceToLight = dot(lightWorldDir, lightWorldDir);
    }
    return squaredDistanceToLight;
}
vec3 calculatePointLightIlluminance(int lightIndex, vec3 surfaceWorldPos, vec3 surfaceWorldNormal, bool useShadowBias, out vec4 ambientTint) {
    ambientTint = vec4_splat(0.0);
    if (lightIndex < 0) {
        return vec3_splat(0.0);
    }
    vec3 lightWorldDir = Lights[lightIndex].position.xyz - surfaceWorldPos.xyz;
    float squaredDistanceToLight = getSquaredDistanceToLight(lightWorldDir);
    float r = Lights[lightIndex].position.w;
    if (squaredDistanceToLight >= r * r) {
        return vec3_splat(0.0);
    }
    float directOcclusion = 1.0f;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0) {
        directOcclusion = calculateDirectOcclusionForDiscreteLight(lightIndex, surfaceWorldPos, surfaceWorldNormal, useShadowBias);
    }
    if (directOcclusion <= 0.0) {
        return vec3_splat(0.0);
    }
    float lightIntensity = Lights[lightIndex].color.a;
    float attenuation = getDistanceAttenuation(squaredDistanceToLight, r);
    vec3 lightColor = Lights[lightIndex].color.rgb;
    vec3 illuminance = lightColor * lightIntensity * attenuation;
    ambientTint.rgb = lightColor * attenuation;
    ambientTint.a = 1.0f - squaredDistanceToLight / (r * r);
    return directOcclusion * illuminance * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
DiscreteLightingContributions evaluateDiscreteLightsDirectContribution(vec2 lightClusterUV, vec3 surfacePos, vec3 n, vec3 v, vec3 color, float metalness, float linearRoughness, float subsurface, vec3 rf0, vec3 surfaceWorldPos, vec3 surfaceWorldNormal, bool calculateDiffuse, bool calculateSpecular, out bool noDiscreteLight) {
    DiscreteLightingContributions lightContrib;
    lightContrib.diffuse = vec3_splat(0.0);
    lightContrib.specular = vec3_splat(0.0);
    lightContrib.ambientTint = vec4(0.0, 0.0, 0.0, 0.0);
    if (!(calculateSpecular || calculateDiffuse))
    {
        return lightContrib;
    }
    highp int rangeStart = 0;
    highp int rangeEnd = 0;
    if (!getLightClusterRangeIfValid(lightClusterUV, surfacePos.z, rangeStart, rangeEnd)) {
        return lightContrib;
    }
    int usedLightCount = 0;
    for(highp int i = rangeStart; i < rangeEnd; ++ i) {
        int lightIndex = int(LightLookupArray[i].lookup);
        if (lightIndex < 0) {
            break;
        }
        vec3 lightPos = ((View) * (vec4(Lights[lightIndex].position.xyz, 1.0))).xyz; // Attention!
        vec3 lightDir = lightPos - surfacePos;
        vec3 l = normalize(lightDir);
        vec3 diffuse = vec3_splat(0.0);
        vec3 specular = vec3_splat(0.0);
        if (calculateDiffuse) {
            if (calculateSpecular) {
                BSDF_VanillaMinecraft(n, l, v, color, metalness, linearRoughness, subsurface, rf0, DiffuseSpecularEmissiveAmbientTermToggles.x, DiffuseSpecularEmissiveAmbientTermToggles.y, diffuse, specular);
            }
            else {
                BSDF_VanillaMinecraft_DiffuseOnly(n, l, color, metalness, subsurface, DiffuseSpecularEmissiveAmbientTermToggles.x, diffuse);
            }
        }
        else {
            if (calculateSpecular) {
                BSDF_VanillaMinecraft_SpecularOnly(n, l, v, metalness, linearRoughness, rf0, DiffuseSpecularEmissiveAmbientTermToggles.y, specular);
            }
        }
        usedLightCount ++ ;
        vec4 ambientTint = vec4_splat(0.0);
        bool useShadowBias = true;
        vec3 pointLightContribution = calculatePointLightIlluminance(lightIndex, surfaceWorldPos, surfaceWorldNormal, useShadowBias, ambientTint);
        lightContrib.ambientTint += ambientTint;
        lightContrib.diffuse += diffuse * pointLightContribution;
        lightContrib.specular += specular * pointLightContribution;
    }
    if (usedLightCount > 0) {
        lightContrib.ambientTint.rgb = lightContrib.ambientTint.rgb / float(usedLightCount);
        lightContrib.ambientTint.a = lightContrib.ambientTint.a / float(usedLightCount);
        noDiscreteLight = false;
    }
    return lightContrib;
}
bool isCloseEnoughToSeePointLightTerm(float dist, float distFadeBegin, float distFadeEnd, out float percentOfFade) {
    bool enablePointLightFade = distFadeBegin > 0.0f;
    percentOfFade = 0.0f;
    if (enablePointLightFade) {
        percentOfFade = smoothstep(distFadeBegin, distFadeEnd, dist);
    }
    bool isCloseEnough = (!enablePointLightFade)||(enablePointLightFade && dist < distFadeEnd);
    return isCloseEnough;
}
bool isCloseEnoughToSeePointLightDiffuse(float dist, out float percentOfDiffuseFade) {
    float distPointLightDiffuseFadeOut_Begin = PointLightDiffuseFadeOutParameters.x;
    float distPointLightDiffuseFadeOut_End = PointLightDiffuseFadeOutParameters.y;
    return isCloseEnoughToSeePointLightTerm(dist, distPointLightDiffuseFadeOut_Begin, distPointLightDiffuseFadeOut_End, percentOfDiffuseFade);
}
float getPointLightViewDistance(vec3 viewPosition) {
    float dist = 0.0;
    if (ManhattanDistAttenuationEnabled.x > 0.0f) {
        dist = abs(viewPosition.x) + abs(viewPosition.y) + abs(viewPosition.z);
    } else {
        dist = length(viewPosition);
    }
    return dist;
}

const float kInv4Pi = 1.0f / (4.0f * 3.1415926535897932384626433832795);
float henyeyGreenstein(float cosTheta, float g) {
    float denom = (1.0 + g * g + 2.0 * g * cosTheta);
    return kInv4Pi * (1.0 - g * g) / (denom * sqrt(denom));
}
vec3 evaluateDiscreteLightsDirectContribution(vec2 lightClusterUV, vec3 surfaceViewPos, vec3 v, vec3 surfaceWorldPos, float henyeyGreensteinG, vec3 scattering) {
    highp int rangeStart = 0;
    highp int rangeEnd = 0;
    if (!getLightClusterRangeIfValid(lightClusterUV, surfaceViewPos.z, rangeStart, rangeEnd)) {
        return vec3_splat(0.0);
    }
    vec3 source = vec3(0.0, 0.0, 0.0);
    for(highp int i = rangeStart; i < rangeEnd; ++ i) {
        int lightIndex = int(LightLookupArray[i].lookup);
        if (lightIndex < 0) {
            break;
        }
        vec4 unused = vec4_splat(0.0);
        vec3 dummySurfaceNormal = vec3(0.0, 1.0, 0.0);
        bool useShadowBias = false;
        vec3 pointLightContribution = calculatePointLightIlluminance(
            lightIndex,
            surfaceWorldPos,
            dummySurfaceNormal,
            useShadowBias,
            unused
        );
        vec3 lightPos = ((View) * (vec4(Lights[lightIndex].position.xyz, 1.0))).xyz; // Attention!
        vec3 lightDir = lightPos - surfaceViewPos;
        vec3 l = normalize(lightDir);
        float phase = henyeyGreenstein(dot(v, l), henyeyGreensteinG);
        source += scattering * phase * pointLightContribution;
    }
    return source;
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
    vec2 waterDepthAndNormal = texelFetch(s_ScreenSpaceWaterDepthAndNormal, ivec2(x, volumeHeight - 1 - y), 0).rg;
    float waterDepth = waterDepthAndNormal.x;
    float waterNormal = waterDepthAndNormal.y;
    float waterSurfaceSignedDistance = (uvw.z - waterDepth) * VolumeDimensions.z * waterNormal;
    float underwater = smoothstep(-0.5, 0.5, (waterSurfaceSignedDistance - CameraUnderwaterAndWaterSurfaceBiasAndFalloff.y) / CameraUnderwaterAndWaterSurfaceBiasAndFalloff.z);
    underwater = CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0f ? 1.0 - underwater : underwater;
    float density = clamp(HeightFogScaleBias.x * worldPosition.y + HeightFogScaleBias.y, 0.0, 1.0);
    vec3 airScattering = density * AirAlbedoExtinction.rgb * AirAlbedoExtinction.a;
    vec3 waterScattering = WaterAlbedoExtinction.rgb * WaterAlbedoExtinction.a;
    vec3 scattering = mix(airScattering, waterScattering, underwater);
    float airExtinction = density * AirAlbedoExtinction.a;
    float waterExtinction = WaterAlbedoExtinction.a;
    float extinction = mix(airExtinction, waterExtinction, underwater);
    float henyeyGreensteinG = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, underwater);
    float viewDistance = length(viewPosition);
    float fogIntensity = calculateFogIntensityFaded(viewDistance, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y, RenderChunkFogAlpha.x);
    scattering = mix(scattering, vec3_splat(0.0), fogIntensity);
    extinction = mix(extinction, 0.0, fogIntensity);
    vec3 source = vec3(0.0, 0.0, 0.0);
    vec3 blockAmbient = AmbientContribution.x * BlockBaseAmbientLightColorIntensity.rgb * BlockBaseAmbientLightColorIntensity.a;
    vec3 skyAmbient = AmbientContribution.y * SkyAmbientLightColorIntensity.rgb * SkyAmbientLightColorIntensity.a;
    vec3 ambient = blockAmbient + skyAmbient;
    ambient = max(ambient, vec3_splat(AmbientContribution.z));
    source += kInv4Pi * scattering * ambient * DiffuseSpecularEmissiveAmbientTermToggles.w;
    vec3 v = -(viewPosition / viewDistance);
    if (abs(AmbientContribution.y) > 0.0001) {
        int lightCount = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
        for(int i = 0; i < lightCount; i ++ ) {
            float directOcclusion = 1.0;
            if (areCascadedShadowsEnabled(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x)) {
                float shadowDepth;
                directOcclusion = GetShadowAmount(
                    i,
                    worldPosition,
                    1.0,
                    0.0,
                shadowDepth);
            }
            vec3 l = normalize(((View) * (DirectionalLightSourceWorldSpaceDirection[i])).xyz); // Attention!
            float phase = henyeyGreenstein(dot(v, l), henyeyGreensteinG);
            vec4 colorAndIlluminance = DirectionalLightSourceDiffuseColorAndIlluminance[i];
            vec3 illuminance = colorAndIlluminance.rgb * colorAndIlluminance.a;
            source += scattering * directOcclusion * phase * illuminance;
        }
    }
    float dist = getPointLightViewDistance(viewPosition);
    float unused = 0.0;
    bool shouldCalculatePointLights = isCloseEnoughToSeePointLightDiffuse(dist, unused);
    vec2 lightClusterUV = uvw.xy;
    if (bool(VolumeScatteringEnabledAndPointLightVolumetricsEnabled.y)&& bool(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z)&& shouldCalculatePointLights) {
        source += evaluateDiscreteLightsDirectContribution(
            lightClusterUV,
            viewPosition,
            v,
            worldPosition,
            henyeyGreensteinG,
            scattering
        );
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

