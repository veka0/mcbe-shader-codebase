#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - POPULATE_PASS (not used)
*/

#define shadow2D(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DArray(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DProj(_sampler, _coord)textureProj(_sampler, _coord)
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
uniform mat4 PrevInvProj;
uniform mat4 u_view;
uniform vec4 SunDir;
uniform vec4 PointLightShadowParams1;
uniform vec4 ShadowBias;
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
uniform vec4 JitterOffset;
uniform vec4 u_alphaRef4;
uniform vec4 FogColor;
uniform vec4 VolumeDimensions;
uniform vec4 ShadowPCFWidth;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 TemporalSettings;
uniform vec4 VolumeScatteringEnabled;
uniform mat4 CloudShadowProj;
uniform vec4 WorldOrigin;
uniform vec4 AtmosphericScatteringEnabled;
uniform vec4 AlbedoExtinction;
uniform vec4 FogSkyBlend;
uniform vec4 DensityFalloff;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 DirectionalLightToggleAndCountAndMaxDistance;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 MoonColor;
uniform vec4 ShadowParams;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraLightIntensity;
uniform vec4 ClusterDimensions;
uniform vec4 FogAndDistanceControl;
uniform vec4 AtmosphericScattering;
uniform vec4 ClusterSize;
uniform vec4 MoonDir;
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 SunColor;
uniform vec4 PointLightSpecularFadeOutParameters;
uniform vec4 VolumeNearFar;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 IBLParameters;
uniform vec4 SkyZenithColor;
uniform vec4 SkyHorizonColor;
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
uvec3 LocalInvocationID;
uint LocalInvocationIndex;
uvec3 GlobalInvocationID;
uvec3 WorkGroupID;
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

uniform highp sampler2DShadow s_CloudShadow;
uniform lowp samplerCube s_SpecularIBL;
uniform lowp sampler2D s_BrdfLUT;
uniform highp sampler2DArrayShadow s_PointLightShadowTextureArray;
uniform highp sampler2DArrayShadow s_ShadowCascades0;
layout(rgba16f, binding = 0)writeonly uniform highp image2DArray s_CurrentLightingBuffer;
uniform highp sampler2DArray s_PreviousLightingBuffer;
uniform highp sampler2DArrayShadow s_ShadowCascades1;
uniform highp sampler2DArray s_ScatteringBuffer;
layout(std430, binding = 2)buffer s_DirectionalLightSources { LightSourceWorldInfo DirectionalLightSources[]; };
layout(std430, binding = 6)buffer s_LightLookupArray { LightData LightLookupArray[]; };
layout(std430, binding = 7)buffer s_Lights { Light Lights[]; };
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

ShadowParameters createShadowParams(vec4 cascadeShadowResolutions, vec4 shadowBias, vec4 shadowSlopeBias, vec4 shadowPCFWidth, int cloudshadowsEnabled, float cloudshadowContribution, float cloudshadowPCFWidth, vec4 shadowParams, mat4 cloudShadowProj) {
    ShadowParameters params;
    params.cascadeShadowResolutions = cascadeShadowResolutions;
    params.shadowBias = shadowBias;
    params.shadowSlopeBias = shadowSlopeBias;
    params.shadowPCFWidth = shadowPCFWidth;
    params.cloudshadowsEnabled = cloudshadowsEnabled;
    params.cloudshadowContribution = cloudshadowContribution;
    params.cloudshadowPCFWidth = cloudshadowPCFWidth;
    params.shadowParams = shadowParams;
    params.cloudShadowProj = cloudShadowProj;
    return params;
}
bool areCascadedShadowsEnabled(float mode) {
    return int(mode) == 1;
}
int GetShadowCascade(DirectionalLightParams params, vec3 worldPos, out vec4 projPos) {
    for(int c = 0; c < params.cascadeCount; ++ c) {
        mat4 proj = params.shadowProj[c];
        projPos = ((proj) * (vec4(worldPos, 1.0)));
        projPos /= projPos.w;
        vec3 posDiff = clamp(projPos.xyz, vec3(-1.0, - 1.0, - 1.0), vec3(1.0, 1.0, 1.0)) - projPos.xyz;
        if (length(posDiff) == 0.0) {
            return c;
        }
    }
    return - 1;
}
float GetFilteredCloudShadow(ShadowParameters params, vec3 worldPos, float NdL) {
    int cloudCascade = 0;
    vec4 cloudProjPos = ((params.cloudShadowProj) * (vec4(worldPos, 1.0)));
    cloudProjPos /= cloudProjPos.w;
    float bias = params.shadowBias[cloudCascade] + params.shadowSlopeBias[cloudCascade] * clamp(tan(acos(NdL)), 0.0, 1.0);
    cloudProjPos.z -= bias / cloudProjPos.w;
    vec2 cloudUv = (vec2(cloudProjPos.x, cloudProjPos.y) * 0.5f + 0.5f) * params.cascadeShadowResolutions[0];
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(params.cloudshadowPCFWidth + 0.5f), 1, MaxFilterWidth);
    int filterOffset = filterWidth / 2;
    float amt = 0.f;
    cloudProjPos.z = cloudProjPos.z * 0.5 + 0.5;
    cloudUv.y += 1.0 - params.cascadeShadowResolutions[0];
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * params.shadowParams.x;
            amt += shadow2D(s_CloudShadow, vec3(cloudUv + (offset * params.cascadeShadowResolutions[0]), cloudProjPos.z));
        }
    }
    return amt / float(filterWidth * filterWidth);
}
float GetFilteredShadow(ShadowParameters params, int cascadeIndex, float projZ, int cascade, vec2 uv) {
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(params.shadowPCFWidth[cascade] + 0.5), 1, MaxFilterWidth);
    int filterOffset = filterWidth / 2;
    float amt = 0.f;
    vec2 baseUv = uv * params.cascadeShadowResolutions[cascade];
    projZ = projZ * 0.5 + 0.5;
    baseUv.y += 1.0 - params.cascadeShadowResolutions[cascade];
    for(int iy = 0; iy < filterWidth && iy < MaxFilterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth && ix < MaxFilterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * params.shadowParams.x;
            if (cascadeIndex == 0) {
                amt += shadow2DArray(s_ShadowCascades0, vec4(baseUv + (offset * params.cascadeShadowResolutions[cascade]), float(cascade), projZ));
            } else if (cascadeIndex == 1) {
                amt += shadow2DArray(s_ShadowCascades1, vec4(baseUv + (offset * params.cascadeShadowResolutions[cascade]), float(cascade), projZ));
            } else {
                amt += 1.0;
            }
        }
    }
    return amt / float(filterWidth * filterWidth);
}
float GetShadowAmount(ShadowParameters params, DirectionalLightParams light, vec3 worldPos, float NdL, float viewDepth) {
    float amt = 1.0;
    float cloudAmt = 1.0;
    vec4 projPos;
    int cascade = GetShadowCascade(light, worldPos, projPos);
    if (cascade != -1) {
        float bias = params.shadowBias[light.index] + params.shadowSlopeBias[light.index] * clamp(tan(acos(NdL)), 0.0, 1.0);
        projPos.z -= bias / projPos.w;
        vec2 uv = vec2(projPos.x, projPos.y) * 0.5f + 0.5f;
        amt = GetFilteredShadow(params, light.index, projPos.z, cascade, uv);
        if (light.isSun > 0 && params.cloudshadowsEnabled > 0) {
            cloudAmt = GetFilteredCloudShadow(params, worldPos, NdL);
            if (cloudAmt < 1.0) {
                cloudAmt = max(cloudAmt, 1.0 - params.cloudshadowContribution);
                amt = min(amt, cloudAmt);
            }
        }
        float shadowRange = params.shadowParams.y;
        float shadowFade = smoothstep(max(0.0, shadowRange - 8.0), shadowRange, - viewDepth);
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
    vec4 view = ((inverseProj) * (vec4(ndc, 1.0)));
    float viewDepth = -view.z / view.w;
    float wLinear = (viewDepth - nearFar.x) / (nearFar.y - nearFar.x);
    return vec3(uv, linearToLogDepth(wLinear));
}
vec3 volumeToNdc(vec3 uvw, mat4 proj, vec2 nearFar) {
    vec2 xy = 2.0 * uvw.xy - vec2(1.0, 1.0);
    float wLinear = logToLinearDepth(uvw.z);
    float viewDepth = -((1.0 - wLinear) * nearFar.x + wLinear * nearFar.y);
    vec4 ndcDepth = ((proj) * (vec4(0.0, 0.0, viewDepth, 1.0)));
    float z = ndcDepth.z / ndcDepth.w;
    return vec3(xy, z);
}
vec3 worldToVolume(vec3 world, mat4 viewProj, mat4 invProj, vec2 nearFar) {
    vec4 proj = ((viewProj) * (vec4(world, 1.0)));
    vec3 ndc = proj.xyz / proj.w;
    return ndcToVolume(ndc, invProj, nearFar);
}
vec3 volumeToWorld(vec3 uvw, mat4 invViewProj, mat4 proj, vec2 nearFar) {
    vec3 ndc = volumeToNdc(uvw, proj, nearFar);
    vec4 world = ((invViewProj) * (vec4(ndc, 1.0)));
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

DirectionalLightParams getDirectionalLightParams(LightSourceWorldInfo light) {
    DirectionalLightParams params;
    params.shadowProj[0] = light.shadowProj0;
    params.shadowProj[1] = light.shadowProj1;
    params.shadowProj[2] = light.shadowProj2;
    params.shadowProj[3] = light.shadowProj3;
    params.cascadeCount = 4;
    params.isSun = light.isSun;
    params.index = light.shadowCascadeNumber;
    return params;
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
    vec3 viewPosition = ((View) * (vec4(worldPosition, 1.0))).xyz;
    vec3 worldAbsolute = worldPosition - WorldOrigin.xyz;
    float density = clamp(DensityFalloff.x * exp(-worldAbsolute.y * DensityFalloff.y), 0.0, 1.0);
    float viewDistance = length(viewPosition);
    float fogIntensity = calculateFogIntensityFaded(viewDistance, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y, RenderChunkFogAlpha.x);
    density = mix(density, 0.0, fogIntensity);
    vec3 scattering = density * AlbedoExtinction.rgb * AlbedoExtinction.a;
    float extinction = density * AlbedoExtinction.a;
    vec3 source = vec3(0.0, 0.0, 0.0);
    vec3 blockAmbient = BlockBaseAmbientLightColorIntensity.rgb * BlockBaseAmbientLightColorIntensity.a;
    vec3 skyAmbient = SkyAmbientLightColorIntensity.rgb * SkyAmbientLightColorIntensity.a;
    vec3 ambient = blockAmbient + skyAmbient;
    source += scattering * ambient * DiffuseSpecularEmissiveAmbientTermToggles.w;
    int lightCount = int(DirectionalLightToggleAndCountAndMaxDistance.y);
    for(int i = 0; i < lightCount; i ++ ) {
        float directOcclusion = 1.0;
        if (areCascadedShadowsEnabled(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x)) {
            ShadowParameters params = createShadowParams(
                CascadeShadowResolutions,
                ShadowBias,
                ShadowSlopeBias,
                ShadowPCFWidth,
                int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y),
                EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w,
                EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z,
                ShadowParams,
            CloudShadowProj);
            directOcclusion = GetShadowAmount(
                params,
                getDirectionalLightParams(DirectionalLightSources[i]),
                worldPosition,
                1.0,
            0.0);
        }
        vec4 colorAndIlluminance = DirectionalLightSources[i].diffuseColorAndIlluminance;
        vec3 illuminance = colorAndIlluminance.rgb * colorAndIlluminance.a;
        source += scattering * directOcclusion * illuminance;
    }
    if (TemporalSettings.x > 0.0) {
        vec3 uvwUnjittered = (vec3(x, y, z) + vec3(0.5, 0.5, 0.5)) / VolumeDimensions.xyz;
        vec3 worldPositionUnjittered = volumeToWorld(uvwUnjittered, InvViewProj, Proj, VolumeNearFar.xy);
        vec3 viewPositionUnjittered = ((View) * (vec4(worldPositionUnjittered, 1.0))).xyz;
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

layout(local_size_x = 8, local_size_y = 8, local_size_z = 8)in;
void main() {
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
    LocalInvocationID = gl_LocalInvocationID;
    LocalInvocationIndex = gl_LocalInvocationIndex;
    GlobalInvocationID = gl_GlobalInvocationID;
    WorkGroupID = gl_WorkGroupID;
    Populate();
}

