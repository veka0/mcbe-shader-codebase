#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_DEFERRED_SHADING_PASS
* - DO_INDIRECT_SPECULAR_SHADING_PASS
* - FALLBACK_PASS
*/

#ifdef DO_INDIRECT_SPECULAR_SHADING_PASS
#extension GL_EXT_shader_texture_lod : enable
#define texture2DLod textureLod
#define texture2DGrad textureGrad
#define texture2DProjLod textureProjLod
#define texture2DProjGrad textureProjGrad
#define textureCubeLod textureLod
#define textureCubeGrad textureGrad
#endif
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec3 v_projPosition;
varying vec2 v_texcoord0;
struct NoopSampler {
    int noop;
};

#ifndef FALLBACK_PASS
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
uniform vec4 SunDir;
uniform vec4 PointLightShadowParams1;
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
uniform vec4 SkyZenithColor;
uniform vec4 IBLSkyFadeParameters;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 WaterSurfaceParameters;
uniform vec4 CameraLightIntensity;
uniform vec4 CausticsParameters;
uniform vec4 CausticsTextureParameters;
uniform vec4 WorldOrigin;
uniform mat4 CloudShadowProj;
uniform vec4 ClusterDimensions;
uniform mat4 DirectionalLightSourceShadowInvProj1[2];
uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
uniform vec4 CurrentFace;
uniform vec4 DeferredWaterAndDirectionalLightWaterAbsorptionEnabledAndWaterDepthMapCascadeIndex;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform mat4 DirectionalLightSourceCausticsViewProj[2];
uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform vec4 DirectionalLightSourceIsSun[2];
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 MoonDir;
uniform vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform vec4 DirectionalLightSourceShadowDirection[2];
uniform vec4 WaterSurfaceEnabled;
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
uniform vec4 FogColor;
uniform vec4 FogSkyBlend;
uniform vec4 IBLParameters;
uniform vec4 MoonColor;
uniform mat4 PlayerShadowProj;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 PointLightSpecularFadeOutParameters;
uniform vec4 PreExposureEnabled;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 SSRParameters;
uniform vec4 ShadowPCFWidth;
uniform vec4 ShadowSlopeBias;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SkyHorizonColor;
uniform vec4 SkyProbeUVFadeParameters;
uniform vec4 SubsurfaceScatteringContribution;
uniform vec4 SunColor;
uniform vec4 Time;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeScatteringEnabled;
uniform vec4 WaterAbsorptionCoefficients;
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
    vec3 position;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    vec3 projPosition;
    vec2 texcoord0;
};

struct FragmentInput {
    vec3 projPosition;
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_BrdfLUT;
uniform lowp sampler2D s_CausticsTexture;
uniform lowp sampler2D s_ColorMetalnessSubsurface;
uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
uniform lowp sampler2D s_Normal;
uniform highp sampler2DArray s_PointLightShadowTextureArray;
uniform lowp sampler2D s_PreviousFrameAverageLuminance;
uniform lowp sampler2D s_SSRTexture;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform lowp sampler2D s_SceneDepth;
uniform highp sampler2DArray s_ShadowCascades;
uniform lowp samplerCube s_SpecularIBLCurrent;
uniform lowp samplerCube s_SpecularIBLPrevious;
layout(std430, binding = 4)buffer s_LightLookupArray { LightData LightLookupArray[]; };
layout(std430, binding = 5)buffer s_Lights { Light Lights[]; };
#ifndef FALLBACK_PASS
vec3 color_degamma(vec3 clr) {
    float e = 2.2;
    return pow(max(clr, vec3(0.0, 0.0, 0.0)), vec3(e, e, e));
}
vec4 color_degamma(vec4 clr) {
    return vec4(color_degamma(clr.rgb), clr.a);
}
#endif
#ifdef DO_DEFERRED_SHADING_PASS
float luminance(vec3 clr) {
    return dot(clr, vec3(0.2126, 0.7152, 0.0722));
}
vec3 desaturate(vec3 color, float amount) {
    float lum = luminance(color);
    return mix(color, vec3(lum, lum, lum), amount);
}
#endif
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#ifndef FALLBACK_PASS
vec4 projToView(vec4 p, mat4 inverseProj) {
    p = vec4(
        p.x * inverseProj[0][0],
        p.y * inverseProj[1][1],
        p.w * inverseProj[3][2],
        p.z * inverseProj[2][3] + p.w * inverseProj[3][3]
    );
    p /= p.w;
    return p;
}
vec2 octWrap(vec2 v) {
    return (1.0 - abs(v.yx)) * ((2.0 * step(0.0, v)) - 1.0);
}
vec3 octToNdirSnorm(vec2 p) {
    vec3 n = vec3(p.xy, 1.0 - abs(p.x) - abs(p.y));
    n.xy = (n.z < 0.0) ? octWrap(n.xy) : n.xy;
    return normalize(n);
}
void unpackMetalnessSubsurface(float metalnessSubsurface, out float metalness, out float subsurface) {
    metalness = clamp((255.0 / 127.0) * (metalnessSubsurface - (128.0 / 255.0)), 0.0, 1.0);
    subsurface = clamp((255.0 / 127.0) * ((127.0 / 255.0) - metalnessSubsurface), 0.0, 1.0);
}
vec3 PreExposeLighting(vec3 color, float averageLuminance) {
    return color * (0.18f / averageLuminance);
}
#endif
#ifdef DO_INDIRECT_SPECULAR_SHADING_PASS
vec3 UnExposeLighting(vec3 color, float averageLuminance) {
    return color / (0.18f / averageLuminance);
}
#endif
#ifndef FALLBACK_PASS
vec3 calculateRf0(vec3 albedo, float metalness) {
    float reflectance = 0.5;
    float dielectricF0 = 0.16f * reflectance * reflectance * (1.0f - metalness);
    vec3 rf0 = vec3_splat(dielectricF0) + albedo * metalness;
    return rf0;
}
PBRFragmentInfo getPBRFragmentInfo(FragmentInput fragInput) {
    vec2 uv = fragInput.texcoord0;
    float z = textureSample(s_SceneDepth, uv).r;
    z = z * 2.0f - 1.0f;
    vec4 viewPosition = projToView(vec4(fragInput.projPosition.xy, z, 1.0), InvProj);
    vec4 worldPosition = ((InvView) * (vec4(viewPosition.xyz, 1.0)));
    vec2 n = textureSample(s_Normal, uv).xy;
    vec3 worldNorm = normalize(octToNdirSnorm(n.xy));
    vec3 viewNorm = normalize(((View) * (vec4(worldNorm, 0.0))).xyz);
    vec4 cm = textureSample(s_ColorMetalnessSubsurface, uv);
    float metalness;
    float subsurface;
    unpackMetalnessSubsurface(cm.a, metalness, subsurface);
    vec4 ear = textureSample(s_EmissiveAmbientLinearRoughness, uv);
    float blockAmbientContribution = ear.g;
    float skyAmbientContribution = ear.b;
    float roughness = ear.a;
    PBRFragmentInfo result;
    result.lightClusterUV = uv;
    result.worldPosition = worldPosition.xyz;
    result.viewPosition = viewPosition.xyz;
    result.ndcPosition = vec3(fragInput.projPosition.xy, z);
    result.worldNormal = worldNorm;
    result.viewNormal = viewNorm;
    result.albedo = color_degamma(cm.rgb);
    result.metalness = metalness;
    result.roughness = roughness;
    result.emissive = ear.r;
    result.subsurface = subsurface;
    result.blockAmbientContribution = blockAmbientContribution;
    result.skyAmbientContribution = skyAmbientContribution;
    result.rf0 = calculateRf0(result.albedo, result.metalness);
    return result;
}
#endif
#ifdef DO_DEFERRED_SHADING_PASS
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

#endif
#ifndef FALLBACK_PASS
float calculateFogIntensityFadedVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd, float fogAlpha) {
    float distance = cameraDepth / maxDistance;
    distance += fogAlpha;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
#endif
#ifdef DO_DEFERRED_SHADING_PASS
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
#endif
#ifdef DO_INDIRECT_SPECULAR_SHADING_PASS
vec3 transformCubemapDirectionForScreen(vec3 R) {
    if (abs(R.y) > abs(R.x)&& abs(R.y) > abs(R.z)) {
        R.z *= -1.0;
    }
    else {
        R.y *= -1.0;
    }
    return R;
}
float getIBLMipLevel(float linearRoughness, float numMips) {
    float x = 1.0 - linearRoughness;
    return (1.0 - (x * x)) * (numMips - 1.0);
}
vec3 evaluateIndirectSpecular(sampler2D brdfLUT, vec3 indirectLight, float linearRoughness, float nDotv, vec3 f0) {
    vec2 envDFGUV = vec2(nDotv, linearRoughness);
    vec2 envDFG = textureSample(brdfLUT, envDFGUV).rg;
    return indirectLight * (f0 * envDFG.x + envDFG.y);
}
#endif
#ifndef FALLBACK_PASS
float calculateFogIntensityFaded(float cameraDepth, float maxDistance, float fogStart, float fogEndMinusStartReciprocal, float fogAlpha) {
    float distance = cameraDepth / maxDistance;
    distance += fogAlpha;
    return clamp((distance - fogStart) * fogEndMinusStartReciprocal, 0.0, 1.0);
}
#endif
#ifdef DO_DEFERRED_SHADING_PASS
vec3 applyFog(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
float getHorizonBlend(float start, float end, float x) {
    float horizon = smoothstep(start, end, x);
    horizon = horizon * horizon * horizon;
    return clamp(horizon, 0.0, 1.0);
}
float getRayleighContribution(float VdL, float strength) {
    float rayleigh = 0.5 * (VdL + 1.0);
    return (rayleigh * rayleigh) * strength;
}
#endif
#ifndef FALLBACK_PASS
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

#endif
#ifdef DO_DEFERRED_SHADING_PASS
vec3 calculateSkyColor(AtmosphereParams params, vec3 V) {
    float startHorizon = params.horizonBlendStart;
    float endHorizon = params.horizonBlendMin - params.horizonBlendMax;
    float mieStartHorizon = params.mieStart - params.horizonBlendMax;
    vec3 sunColor = params.sunColor.a * params.sunColor.rgb;
    vec3 moonColor = params.moonColor.a * params.moonColor.rgb;
    float horizon = getHorizonBlend(startHorizon, endHorizon, V.y);
    float mieHorizon = getHorizonBlend(mieStartHorizon, endHorizon, V.y);
    vec3 zenithColor = params.skyZenithColor;
    vec3 horizonColor = params.skyHorizonColor;
    float sunVdL = dot(V, params.sunDir);
    float moonVdL = dot(V, params.moonDir);
    float sunRay = getRayleighContribution(sunVdL, params.sunColor.a);
    float moonRay = getRayleighContribution(moonVdL, params.moonColor.a);
    const float kThreeOverSixteenPi = (3.0 / (16.0 * 3.1415926535897932384626433832795));
    vec3 rayleighColor = params.rayleighStrength * mix(zenithColor, horizonColor, horizon);
    vec3 rayleigh = rayleighColor * kThreeOverSixteenPi * (sunRay + moonRay);
    float miePower = params.sunGlareShape;
    float mieSunVdL = clamp(pow(max(sunVdL, 0.0), miePower), 0.0, 1.0);
    float mieMoonVdL = clamp(pow(max(moonVdL, 0.0), miePower), 0.0, 1.0);
    const float kMieEccentricity = -0.9;
    const float kTwoMieEccentricity = kMieEccentricity * 2.0;
    const float kSquaredMieEccentricity = kMieEccentricity * kMieEccentricity;
    const float kOnePlusSquaredMieEccentricity = 1.0 + kSquaredMieEccentricity;
    const float kSquaredInverseSquaredMieEccentricity = (1.0 - kSquaredMieEccentricity) * (1.0 - kSquaredMieEccentricity);
    float sunPhase = kSquaredInverseSquaredMieEccentricity / pow((kOnePlusSquaredMieEccentricity - kTwoMieEccentricity * -mieSunVdL), 1.5);
    float moonPhase = kSquaredInverseSquaredMieEccentricity / pow((kOnePlusSquaredMieEccentricity - kTwoMieEccentricity * -mieMoonVdL), 1.5);
    const float kOneOverFourPi = (1.0 / (4.0 * 3.1415926535897932384626433832795));
    vec3 mieSun = params.sunMieStrength * sunColor * mieSunVdL * sunPhase;
    vec3 mieMoon = params.moonMieStrength * moonColor * mieMoonVdL * moonPhase;
    vec3 mieColor = horizonColor * mieHorizon;
    vec3 mie = kOneOverFourPi * mieColor * (mieSun + mieMoon);
    return rayleigh + mie;
}
AtmosphereParams getAtmosphereParams() {
    AtmosphereParams params;
    params.sunDir = SunDir.xyz;
    params.moonDir = MoonDir.xyz;
    params.sunColor = SunColor;
    params.moonColor = MoonColor;
    params.skyZenithColor = SkyZenithColor.rgb;
    params.skyHorizonColor = SkyHorizonColor.rgb;
    params.fogColor = FogColor;
    params.horizonBlendMin = FogSkyBlend.x;
    params.horizonBlendStart = FogSkyBlend.y;
    params.mieStart = FogSkyBlend.z;
    params.horizonBlendMax = FogSkyBlend.w;
    params.rayleighStrength = AtmosphericScattering.x;
    params.sunMieStrength = AtmosphericScattering.y;
    params.moonMieStrength = AtmosphericScattering.z;
    params.sunGlareShape = AtmosphericScattering.w;
    return params;
}
#endif
#ifndef FALLBACK_PASS
vec3 worldSpaceViewDir(vec3 worldPosition) {
    vec3 cameraPosition = ((InvView) * (vec4(0.f, 0.f, 0.f, 1.f))).xyz;
    return normalize(worldPosition - cameraPosition);
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
#endif
#ifdef DO_DEFERRED_SHADING_PASS
vec3 applyScattering(vec4 sourceExtinction, vec3 color) {
    return sourceExtinction.rgb + sourceExtinction.a * color;
}
#endif
#ifndef FALLBACK_PASS
struct TemporalAccumulationParameters {
    ivec3 dimensions;
    vec3 previousUvw;
    vec4 currentValue;
    float historyWeight;
    float frustumBoundaryFalloff;
};

#endif
#ifdef DO_DEFERRED_SHADING_PASS
vec3 evaluateAtmosphericAndVolumetricScattering(vec3 surfaceRadiance, vec3 viewDirWorld, float viewDistance, vec3 ndcPosition, bool enableAtmosphericScattering, bool enableVolumeScattering, bool enableBlendWithSky) {
    vec3 fogAppliedColor;
    if (enableAtmosphericScattering) {
        float fogIntensity = calculateFogIntensityFaded(viewDistance, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y, RenderChunkFogAlpha.x);
        if (fogIntensity > 0.0) {
            vec3 fogColor = vec3(0.0, 0.0, 0.0);
            if (!enableBlendWithSky) {
                fogColor = FogColor.rgb;
            }
            else {
                fogColor = calculateSkyColor(getAtmosphereParams(), viewDirWorld);
            }
            fogAppliedColor = applyFog(surfaceRadiance, fogColor, fogIntensity);
        }
        else {
            fogAppliedColor = surfaceRadiance;
        }
    }
    else {
        float fogIntensity = calculateFogIntensityFadedVanilla(viewDistance, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y, RenderChunkFogAlpha.x);
        fogAppliedColor = applyFogVanilla(surfaceRadiance, FogColor.rgb, fogIntensity);
    }
    vec3 outColor;
    if (enableVolumeScattering) {
        vec3 uvw = ndcToVolume(ndcPosition, InvProj, VolumeNearFar.xy);
        vec4 sourceExtinction = sampleVolume(s_ScatteringBuffer, ivec3(VolumeDimensions.xyz), uvw);
        outColor = applyScattering(sourceExtinction, fogAppliedColor);
    }
    else {
        outColor = fogAppliedColor;
    }
    return outColor;
}
vec3 evaluateEmissiveContribution(vec3 albedo, float emissive) {
    return DiffuseSpecularEmissiveAmbientTermToggles.z * desaturate(albedo, EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y) * vec3_splat(emissive) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x;
}
void IBLDeferredLighting(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    PBRFragmentInfo fragmentInfo = getPBRFragmentInfo(fragInput);
    vec3 surfaceRadiance = evaluateEmissiveContribution(fragmentInfo.albedo, fragmentInfo.emissive);
    float viewDistance = length(fragmentInfo.viewPosition);
    vec3 viewDirWorld = worldSpaceViewDir(fragmentInfo.worldPosition.xyz);
    if (viewDirWorld.y < 0.1) {
        viewDirWorld.y = 0.1f;
        viewDirWorld = normalize(viewDirWorld);
    }
    vec3 fogAppliedColor = evaluateAtmosphericAndVolumetricScattering(surfaceRadiance, viewDirWorld, viewDistance, fragmentInfo.ndcPosition, AtmosphericScatteringToggles.x != 0.0, VolumeScatteringEnabled.x != 0.0, AtmosphericScatteringToggles.y != 0.0);
    if (CurrentFace.x == float(3)) {
        float fade = SkyProbeUVFadeParameters.w;
        fogAppliedColor *= fade;
    }
    else if (CurrentFace.x != float(2)) {
        vec2 uv = (fragmentInfo.ndcPosition.xy + vec2(1.0, 1.0)) / 2.0;
        float fadeStart = SkyProbeUVFadeParameters.x;
        float fadeEnd = SkyProbeUVFadeParameters.y;
        float fadeRange = fadeStart - fadeEnd + 1e - 5;
        float fade = (clamp(uv.y, fadeEnd, fadeStart) - fadeEnd) / fadeRange;
        fade = max(fade, SkyProbeUVFadeParameters.w);
        fogAppliedColor *= fade;
    }
    if (PreExposureEnabled.x > 0.0) {
        fogAppliedColor = PreExposeLighting(fogAppliedColor, 1.0);
    }
    fragOutput.Color0.rgb = fogAppliedColor;
    fragOutput.Color0.a = 1.0f;
}
#endif
#ifdef DO_INDIRECT_SPECULAR_SHADING_PASS
vec3 evaluateAtmosphericAndVolumetricScatteringFogIntensityOnly(vec3 surfaceRadiance, vec3 viewDirWorld, float viewDistance, vec3 ndcPosition, bool enableAtmosphericScattering, bool enableVolumeScattering, bool enableBlendWithSky) {
    vec3 fogAppliedColor;
    if (enableAtmosphericScattering) {
        float fogIntensity = calculateFogIntensityFaded(viewDistance, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y, RenderChunkFogAlpha.x);
        fogAppliedColor = surfaceRadiance * (1.0 - fogIntensity);
    }
    else {
        float fogIntensity = calculateFogIntensityFadedVanilla(viewDistance, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y, RenderChunkFogAlpha.x);
        fogAppliedColor = surfaceRadiance * (1.0 - fogIntensity);
    }
    vec3 outColor;
    if (enableVolumeScattering) {
        vec3 uvw = ndcToVolume(ndcPosition, InvProj, VolumeNearFar.xy);
        vec4 sourceExtinction = sampleVolume(s_ScatteringBuffer, ivec3(VolumeDimensions.xyz), uvw);
        outColor = sourceExtinction.a * fogAppliedColor;
    }
    else {
        outColor = fogAppliedColor;
    }
    return outColor;
}
float getSkyProbeVisibility(float skyAmbientContribution, float skyFadeStart, float skyFadeEnd) {
    float skyProbeVisRange = max(skyFadeStart - skyFadeEnd, 1.0);
    float skyProbeVisibility = clamp((skyAmbientContribution * 16.0f - skyFadeEnd) / skyProbeVisRange, 0.0, 1.0);
    skyProbeVisibility = pow(skyProbeVisibility, 3.0f);
    return skyProbeVisibility * IBLParameters.x;
}
vec3 getProbeLighting(samplerCube currentEnvironmentProbe, samplerCube previousEnvironmentProbe, float skyProbeVisibility, float linearRoughness, vec3 v, vec3 n, float numMips, float blendFactor, float contribution, bool isPreExposureEnabled) {
    vec3 R = transformCubemapDirectionForScreen(reflect(v, n));
    float iblMipLevel = getIBLMipLevel(linearRoughness, numMips);
    vec3 preFilteredColorCurrent = textureCubeLod(currentEnvironmentProbe, R, iblMipLevel).rgb;
    vec3 preFilteredColorPrevious = textureCubeLod(previousEnvironmentProbe, R, iblMipLevel).rgb;
    vec3 preFilteredColor = mix(preFilteredColorPrevious, preFilteredColorCurrent, blendFactor);
    if (isPreExposureEnabled) {
        preFilteredColor = UnExposeLighting(preFilteredColor, 1.0);
    }
    return preFilteredColor * skyProbeVisibility * contribution;
}
vec3 calculateIndirectSpecularProbeOnly(PBRFragmentInfo fragmentData, sampler2D brdfLUT, samplerCube currentEnvironmentProbe, samplerCube previousEnvironmentProbe, float numMips, float blendFactor, float skyVisibility, float contribution, bool isPreExposureEnabled) {
    float viewDistance = length(fragmentData.viewPosition);
    vec3 viewDir = -(fragmentData.viewPosition / viewDistance);
    vec3 viewDirWorld = worldSpaceViewDir(fragmentData.worldPosition.xyz);
    vec3 indirectProbeLight = getProbeLighting(
        currentEnvironmentProbe,
        previousEnvironmentProbe,
        skyVisibility,
        fragmentData.roughness,
        viewDirWorld,
        fragmentData.worldNormal,
        numMips,
        blendFactor,
        contribution,
    isPreExposureEnabled);
    vec3 indirectSpecularColor = evaluateIndirectSpecular(brdfLUT, indirectProbeLight, fragmentData.roughness, clamp(dot(fragmentData.viewNormal, viewDir), 0.0, 1.0), fragmentData.rf0);
    return indirectSpecularColor;
}
vec3 calculateIndirectSpecular(PBRFragmentInfo fragmentData, sampler2D brdfLUT, sampler2D ssrTexture, samplerCube currentEnvironmentProbe, samplerCube previousEnvironmentProbe, float numMips, float blendFactor, float skyVisibility, float ssrContribution, float iblContribution, bool isPreExposureEnabled, float exposure) {
    float viewDistance = length(fragmentData.viewPosition);
    vec3 viewDir = -(fragmentData.viewPosition / viewDistance);
    vec3 viewDirWorld = worldSpaceViewDir(fragmentData.worldPosition.xyz);
    vec3 rf0 = calculateRf0(fragmentData.albedo, fragmentData.metalness);
    vec2 uv = (fragmentData.ndcPosition.xy + 1.0) * 0.5f;
    vec4 ssrLight = textureSample(ssrTexture, uv);
    if (isPreExposureEnabled) {
        ssrLight.rgb = UnExposeLighting(ssrLight.rgb, exposure);
    }
    vec3 indirectProbeLight = getProbeLighting(
        currentEnvironmentProbe,
        previousEnvironmentProbe,
        skyVisibility,
        fragmentData.roughness,
        viewDirWorld,
        fragmentData.worldNormal,
        numMips,
        blendFactor,
        iblContribution,
    isPreExposureEnabled);
    float ssrIntensity = ssrLight.a * ssrContribution;
    vec3 incomingLight = mix(indirectProbeLight.rgb, ssrLight.rgb, ssrIntensity);
    vec3 indirectSpecularColor = evaluateIndirectSpecular(brdfLUT, incomingLight, fragmentData.roughness, clamp(dot(fragmentData.viewNormal, viewDir), 0.0, 1.0), rf0);
    return indirectSpecularColor;
}
void IndirectSpecularLighting(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    PBRFragmentInfo fragmentInfo = getPBRFragmentInfo(fragInput);
    vec3 indirectSpecularColor = vec3_splat(0.0f);
    float exposure = 0.0f;
    if (PreExposureEnabled.x > 0.0) {
        exposure = textureSample(s_PreviousFrameAverageLuminance, vec2(0.5, 0.5)).r;
    }
    float skyVisibility = getSkyProbeVisibility(
        fragmentInfo.skyAmbientContribution,
        IBLSkyFadeParameters.x,
        IBLSkyFadeParameters.y
    );
    if (SSRParameters.x != 0.0f) {
        indirectSpecularColor = calculateIndirectSpecular(
            fragmentInfo,
            s_BrdfLUT,
            s_SSRTexture,
            s_SpecularIBLCurrent,
            s_SpecularIBLPrevious,
            IBLParameters.y,
            IBLParameters.w,
            skyVisibility,
            SSRParameters.y,
            IBLParameters.z,
            PreExposureEnabled.x > 0.0f,
        exposure);
    }
    else {
        indirectSpecularColor = calculateIndirectSpecularProbeOnly(
            fragmentInfo,
            s_BrdfLUT,
            s_SpecularIBLCurrent,
            s_SpecularIBLPrevious,
            IBLParameters.y,
            IBLParameters.w,
            skyVisibility,
            IBLParameters.z,
        PreExposureEnabled.x > 0.0f);
    }
    float viewDistance = length(fragmentInfo.viewPosition);
    vec3 viewDirWorld = worldSpaceViewDir(fragmentInfo.worldPosition.xyz);
    vec3 indirectSpecWithFog = evaluateAtmosphericAndVolumetricScatteringFogIntensityOnly(indirectSpecularColor, viewDirWorld, viewDistance, fragmentInfo.ndcPosition, AtmosphericScatteringToggles.x != 0.0, VolumeScatteringEnabled.x != 0.0, AtmosphericScatteringToggles.y != 0.0);
    if (PreExposureEnabled.x > 0.0) {
        indirectSpecWithFog.rgb = PreExposeLighting(indirectSpecWithFog.rgb, exposure);
    }
    vec4 color = vec4(indirectSpecWithFog, 1.0);
    fragOutput.Color0 = color;
}
#endif
#ifdef FALLBACK_PASS
void DeferredLighting(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    fragOutput.Color0 = vec4(0.0, 0.0, 0.0, 0.0);
}
#endif
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.projPosition = v_projPosition;
    fragmentInput.texcoord0 = v_texcoord0;
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
    #ifdef DO_DEFERRED_SHADING_PASS
    IBLDeferredLighting(fragmentInput, fragmentOutput);
    #endif
    #ifdef DO_INDIRECT_SPECULAR_SHADING_PASS
    IndirectSpecularLighting(fragmentInput, fragmentOutput);
    #endif
    #ifdef FALLBACK_PASS
    DeferredLighting(fragmentInput, fragmentOutput);
    #endif
    bgfx_FragColor = fragmentOutput.Color0;
}

