#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_OPAQUE_PASS
* - FORWARD_PBR_TRANSPARENT_PASS
* - OPAQUE_PASS
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF (not used)
* - RENDER_AS_BILLBOARDS__ON (not used)
*
* Seasons:
* - SEASONS__OFF
* - SEASONS__ON
*/

#ifdef FORWARD_PBR_TRANSPARENT_PASS
#extension GL_EXT_shader_texture_lod : enable
#define texture2DLod textureLod
#define texture2DGrad textureGrad
#define texture2DProjLod textureProjLod
#define texture2DProjGrad textureProjGrad
#define textureCubeLod textureLod
#define textureCubeGrad textureGrad
#endif
#define shadow2D(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DArray(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DProj(_sampler, _coord)textureProj(_sampler, _coord)
#ifdef FORWARD_PBR_TRANSPARENT_PASS
#extension GL_EXT_texture_array : enable
#endif
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
#if ! defined(FORWARD_PBR_TRANSPARENT_PASS)&& ! defined(OPAQUE_PASS)
out vec4 bgfx_FragColor;
#endif
#if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
out vec4 bgfx_FragData[gl_MaxDrawBuffers];
#endif
varying vec3 v_bitangent;
varying vec4 v_color0;
varying vec4 v_fog;
varying vec2 v_lightmapUV;
varying vec3 v_normal;
#if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
flat varying int v_pbrTextureId;
#endif
varying vec3 v_tangent;
centroid varying vec2 v_texcoord0;
varying vec3 v_worldPos;
struct NoopSampler {
    int noop;
};

#ifndef OPAQUE_PASS
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
#endif
#if defined(FORWARD_PBR_TRANSPARENT_PASS)||(defined(ALPHA_TEST_PASS)&& defined(SEASONS__ON))
vec3 vec3_splat(float _x) {
    return vec3(_x, _x, _x);
}
#endif
#ifdef FORWARD_PBR_TRANSPARENT_PASS
mat4 mtxFromRows(vec4 _0, vec4 _1, vec4 _2, vec4 _3) {
    return transpose(mat4(_0, _1, _2, _3));
}
mat3 mtxFromRows(vec3 _0, vec3 _1, vec3 _2) {
    return transpose(mat3(_0, _1, _2));
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
uniform vec4 ShadowBias;
uniform vec4 PointLightShadowParams1;
uniform vec4 u_viewTexel;
uniform vec4 ShadowSlopeBias;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
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
uniform vec4 ClusterSize;
uniform vec4 AtmosphericScattering;
uniform vec4 SkyZenithColor;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraLightIntensity;
uniform vec4 WorldOrigin;
uniform vec4 ViewPositionAndTime;
uniform mat4 CloudShadowProj;
uniform vec4 ClusterDimensions;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 ShadowParams;
uniform vec4 MoonColor;
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidth;
uniform vec4 VolumeDimensions;
uniform vec4 ShadowPCFWidth;
uniform vec4 FogColor;
uniform vec4 FogSkyBlend;
uniform vec4 IBLParameters;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 MoonDir;
uniform mat4 PlayerShadowProj;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 SunColor;
uniform vec4 PointLightSpecularFadeOutParameters;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SkyHorizonColor;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeScatteringEnabled;
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
struct DiscreteLightingContributions {
    vec3 diffuse;
    vec3 specular;
    vec3 ambientTint;
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

struct VertexInput {
    vec4 color0;
    vec2 lightmapUV;
    vec4 normal;
    #if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
    int pbrTextureId;
    #endif
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
    vec4 fog;
    vec2 lightmapUV;
    vec3 normal;
    #if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
    int pbrTextureId;
    #endif
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec3 bitangent;
    vec4 color0;
    vec4 fog;
    vec2 lightmapUV;
    vec3 normal;
    #if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
    int pbrTextureId;
    #endif
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_BrdfLUT;
uniform lowp sampler2D s_LightMapTexture;
uniform lowp sampler2D s_MatTexture;
uniform highp sampler2DShadow s_PlayerShadowMap;
uniform highp sampler2DArrayShadow s_PointLightShadowTextureArray;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform lowp sampler2D s_SeasonsTexture;
uniform highp sampler2DArrayShadow s_ShadowCascades;
uniform lowp samplerCube s_SpecularIBL;
layout(std430, binding = 1)buffer s_DirectionalLightSources { LightSourceWorldInfo DirectionalLightSources[]; };
layout(std430, binding = 2)buffer s_LightLookupArray { LightData LightLookupArray[]; };
layout(std430, binding = 4)buffer s_Lights { Light Lights[]; };
layout(std430, binding = 6)buffer s_PBRData { PBRTextureData PBRData[]; };
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec2 lightmapUV;
    vec3 bitangent;
    vec4 fog;
    vec3 normal;
    #if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
    int pbrTextureId;
    #endif
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
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
    result.lightmapUV = fragInput.lightmapUV;
    result.bitangent = fragInput.bitangent;
    result.fog = fragInput.fog;
    result.normal = fragInput.normal;
    #if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
    result.pbrTextureId = fragInput.pbrTextureId;
    #endif
    result.tangent = fragInput.tangent;
    result.texcoord0 = fragInput.texcoord0;
    result.worldPos = fragInput.worldPos;
    return result;
}
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

StandardSurfaceOutput StandardTemplate_DefaultOutput() {
    StandardSurfaceOutput result;
    result.Albedo = vec3(1, 1, 1);
    result.Alpha = 1.0;
    result.Metallic = 0.0;
    result.Roughness = 1.0;
    result.Occlusion = 0.0;
    result.Emissive = 0.0;
    result.AmbientLight = vec3(0.0, 0.0, 0.0);
    result.ViewSpaceNormal = vec3(0, 1, 0);
    return result;
}
#ifdef FORWARD_PBR_TRANSPARENT_PASS
float calculateFogIntensityFadedVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd, float fogAlpha) {
    float distance = cameraDepth / maxDistance;
    distance += fogAlpha;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
#endif
#ifndef OPAQUE_PASS
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
#endif
#if defined(SEASONS__ON)&&(defined(ALPHA_TEST_PASS)|| defined(FORWARD_PBR_TRANSPARENT_PASS))
vec4 applySeasons(vec3 vertexColor, float vertexAlpha, vec4 diffuse) {
    vec2 uv = vertexColor.xy;
    diffuse.rgb *= mix(vec3(1.0, 1.0, 1.0), textureSample(s_SeasonsTexture, uv).rgb * 2.0, vertexColor.b);
    diffuse.rgb *= vec3_splat(vertexAlpha);
    diffuse.a = 1.0;
    return diffuse;
}
#endif
#if ! defined(FORWARD_PBR_TRANSPARENT_PASS)&& ! defined(OPAQUE_PASS)
void RenderChunkApplyFog(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = applyFogVanilla(fragOutput.Color0.rgb, FogColor.rgb, surfaceInput.fog.a);
}
#endif
struct CompositingOutput {
    vec3 mLitColor;
};

vec4 standardComposite(StandardSurfaceOutput stdOutput, CompositingOutput compositingOutput) {
    return vec4(compositingOutput.mLitColor, stdOutput.Alpha);
}
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};

#if ! defined(FORWARD_PBR_TRANSPARENT_PASS)&& ! defined(OPAQUE_PASS)
vec3 computeLighting_RenderChunk(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return textureSample(s_LightMapTexture, stdInput.lightmapUV).rgb * stdOutput.Albedo;
}
#endif
#if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_PASS)
void RenderChunkSurfAlpha(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 diffuse = textureSample(s_MatTexture, surfaceInput.UV);
    const float ALPHA_THRESHOLD = 0.5;
    if (diffuse.a < ALPHA_THRESHOLD) {
        discard;
    }
    #if defined(ALPHA_TEST_PASS)&& defined(SEASONS__OFF)
    diffuse.rgb *= surfaceInput.Color.rgb;
    #endif
    #if defined(ALPHA_TEST_PASS)&& defined(SEASONS__ON)
    diffuse = applySeasons(surfaceInput.Color, surfaceInput.Alpha, diffuse);
    #endif
    #ifdef ALPHA_TEST_PASS
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
    #endif
}
#endif
#ifdef DEPTH_ONLY_OPAQUE_PASS
void RenderChunkSurfOpaque(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
}
#endif
#if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
vec3 computeLighting_Unlit(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return stdOutput.Albedo;
}
#endif
#ifdef FORWARD_PBR_TRANSPARENT_PASS
float saturatedLinearRemapZeroToOne(float value, float zeroValue, float oneValue) {
    return clamp((((value) * (1.f / (oneValue - zeroValue))) + -zeroValue / (oneValue - zeroValue)), 0.0, 1.0);
}
vec3 calculateTangentNormalFromHeightmap(sampler2D heightmapTexture, vec2 heightmapUV, float mipLevel) {
    vec3 tangentNormal = vec3(0.f, 0.f, 1.f);
    const float kHeightMapPixelEdgeWidth = 1.0f / 12.0f;
    const float kHeightMapDepth = 4.0f;
    const float kRecipHeightMapDepth = 1.0f / kHeightMapDepth;
    float fadeForLowerMips = saturatedLinearRemapZeroToOne(mipLevel, 2.f, 1.f);
    if (fadeForLowerMips > 0.f)
    {
        vec2 widthHeight = vec2(textureSize(heightmapTexture, 0));
        vec2 pixelCoord = heightmapUV * widthHeight;
        {
            const float kNudgePixelCentreDistEpsilon = 0.0625f;
            const float kNudgeUvEpsilon = 0.25f / 65536.f;
            vec2 nudgeSampleCoord = fract(pixelCoord);
            if (abs(nudgeSampleCoord.x - 0.5) < kNudgePixelCentreDistEpsilon)
            {
                heightmapUV.x += (nudgeSampleCoord.x > 0.5f) ? kNudgeUvEpsilon : -kNudgeUvEpsilon;
            }
            if (abs(nudgeSampleCoord.y - 0.5) < kNudgePixelCentreDistEpsilon)
            {
                heightmapUV.y += (nudgeSampleCoord.y > 0.5f) ? kNudgeUvEpsilon : -kNudgeUvEpsilon;
            }
        }
        vec4 heightSamples = textureGather(heightmapTexture, heightmapUV, 0);
        vec2 subPixelCoord = fract(pixelCoord + 0.5f);
        const float kBevelMode = 0.0f;
        vec2 axisSamplePair = (subPixelCoord.y > 0.5f) ? heightSamples.xy : heightSamples.wz;
        float axisBevelCentreSampleCoord = subPixelCoord.x;
        axisBevelCentreSampleCoord += ((axisSamplePair.x > axisSamplePair.y) ? kHeightMapPixelEdgeWidth : -kHeightMapPixelEdgeWidth) * kBevelMode;
        ivec2 axisSampleIndices = ivec2(clamp(vec2(axisBevelCentreSampleCoord - kHeightMapPixelEdgeWidth, axisBevelCentreSampleCoord + kHeightMapPixelEdgeWidth) * 2.f, 0.0, 1.0));
        tangentNormal.x = (axisSamplePair[axisSampleIndices.x] - axisSamplePair[axisSampleIndices.y]);
        axisSamplePair = (subPixelCoord.x > 0.5f) ? heightSamples.zy : heightSamples.wx;
        axisBevelCentreSampleCoord = subPixelCoord.y;
        axisBevelCentreSampleCoord += ((axisSamplePair.x > axisSamplePair.y) ? kHeightMapPixelEdgeWidth : -kHeightMapPixelEdgeWidth) * kBevelMode;
        axisSampleIndices = ivec2(clamp(vec2(axisBevelCentreSampleCoord - kHeightMapPixelEdgeWidth, axisBevelCentreSampleCoord + kHeightMapPixelEdgeWidth) * 2.f, 0.0, 1.0));
        tangentNormal.y = (axisSamplePair[axisSampleIndices.x] - axisSamplePair[axisSampleIndices.y]);
        tangentNormal.z = kRecipHeightMapDepth;
        tangentNormal = normalize(tangentNormal);
        tangentNormal.xy *= fadeForLowerMips;
    }
    return tangentNormal;
}
vec2 getPBRDataUV(vec2 surfaceUV, vec2 uvScale, vec2 uvBias) {
    return (((surfaceUV) * (uvScale)) + uvBias);
}
void applyPBRValuesToSurfaceOutput(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput, PBRTextureData pbrTextureData) {
    vec2 normalUVScale = vec2(pbrTextureData.colourToNormalUvScale0, pbrTextureData.colourToNormalUvScale1);
    vec2 normalUVBias = vec2(pbrTextureData.colourToNormalUvBias0, pbrTextureData.colourToNormalUvBias1);
    vec2 materialUVScale = vec2(pbrTextureData.colourToMaterialUvScale0, pbrTextureData.colourToMaterialUvScale1);
    vec2 materialUVBias = vec2(pbrTextureData.colourToMaterialUvBias0, pbrTextureData.colourToMaterialUvBias1);
    int kPBRTextureDataFlagHasMaterialTexture = (1 << 0);
    int kPBRTextureDataFlagHasNormalTexture = (1 << 1);
    int kPBRTextureDataFlagHasHeightMapTexture = (1 << 2);
    vec3 tangentNormal = vec3(0, 0, 1);
    if ((pbrTextureData.flags & kPBRTextureDataFlagHasNormalTexture) == kPBRTextureDataFlagHasNormalTexture)
    {
        vec2 uv = getPBRDataUV(surfaceInput.UV, normalUVScale, normalUVBias);
        tangentNormal = textureSample(s_MatTexture, uv).xyz * 2.f - 1.f;
    }
    else if ((pbrTextureData.flags & kPBRTextureDataFlagHasHeightMapTexture) == kPBRTextureDataFlagHasHeightMapTexture)
    {
        vec2 normalUv = getPBRDataUV(surfaceInput.UV, normalUVScale, normalUVBias);
        float normalMipLevel = min(pbrTextureData.maxMipNormal - pbrTextureData.maxMipColour, pbrTextureData.maxMipNormal);
        tangentNormal = calculateTangentNormalFromHeightmap(s_MatTexture, normalUv, normalMipLevel);
    }
    float emissive = pbrTextureData.uniformEmissive;
    float metalness = pbrTextureData.uniformMetalness;
    float linearRoughness = pbrTextureData.uniformRoughness;
    if ((pbrTextureData.flags & kPBRTextureDataFlagHasMaterialTexture) == kPBRTextureDataFlagHasMaterialTexture)
    {
        vec2 uv = getPBRDataUV(surfaceInput.UV, materialUVScale, materialUVBias);
        vec3 texel = textureSample(s_MatTexture, uv).rgb;
        metalness = texel.r;
        emissive = texel.g;
        linearRoughness = texel.b;
    }
    mat3 tbn = mtxFromRows(
        normalize(surfaceInput.tangent),
        normalize(surfaceInput.bitangent),
        normalize(surfaceInput.normal)
    );
    tbn = transpose(tbn);
    surfaceOutput.Roughness = linearRoughness;
    surfaceOutput.Metallic = metalness;
    surfaceOutput.Emissive = emissive;
    surfaceOutput.ViewSpaceNormal = ((tbn) * (tangentNormal)).xyz;
}
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
    return floor(log2(viewSpaceDepth / 1.5f) * ((maxSlices - 2.0f) / nearFarLog) + 2.0f);
}
vec3 getClusterIndex(vec2 uv, float viewSpaceDepth, vec3 clusterDimensions, vec2 clusterNearFar, vec2 screenSize, vec2 clusterSize) {
    float viewportX = uv.x * screenSize.x;
    float viewportY = uv.y * screenSize.y;
    float clusterIdxX = floor(viewportX / clusterSize.x);
    float clusterIdxY = floor(viewportY / clusterSize.y);
    float clusterIdxZ = getClusterDepthIndex(viewSpaceDepth, clusterDimensions.z, clusterNearFar);
    return vec3(clusterIdxX, clusterIdxY, clusterIdxZ);
}
float luminance(vec3 clr) {
    return dot(clr, vec3(0.2126, 0.7152, 0.0722));
}
float lumaPerceptual(vec3 color) {
    vec3 perceptualLuminance = vec3(0.299, 0.587, 0.114);
    return dot(perceptualLuminance, color);
}
vec3 desaturate(vec3 color, float amount) {
    float lum = luminance(color);
    return mix(color, vec3(lum, lum, lum), amount);
}
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

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
int GetShadowCascade(int lightIndex, vec3 worldPos, out vec4 projPos) {
    LightSourceWorldInfo light = DirectionalLightSources[lightIndex];
    for(int c = 0; c < 4; ++ c) {
        mat4 proj;
        if (c == 0) {
            proj = light.shadowProj0;
        } else if (c == 1) {
            proj = light.shadowProj1;
        } else if (c == 2) {
            proj = light.shadowProj2;
        } else if (c == 3) {
            proj = light.shadowProj3;
        }
        projPos = ((proj) * (vec4(worldPos, 1.0)));
        projPos /= projPos.w;
        vec3 posDiff = clamp(projPos.xyz, vec3(-1.0, - 1.0, - 1.0), vec3(1.0, 1.0, 1.0)) - projPos.xyz;
        if (length(posDiff) == 0.0) {
            return c;
        }
    }
    return - 1;
}
float GetFilteredCloudShadow(vec3 worldPos, float NdL) {
    const int cloudCascade = 0;
    vec4 cloudProjPos = ((CloudShadowProj) * (vec4(worldPos, 1.0)));
    cloudProjPos /= cloudProjPos.w;
    float bias = ShadowBias[cloudCascade] + ShadowSlopeBias[cloudCascade] * clamp(tan(acos(NdL)), 0.0, 1.0);
    cloudProjPos.z -= bias / cloudProjPos.w;
    vec2 cloudUv = (vec2(cloudProjPos.x, cloudProjPos.y) * 0.5f + 0.5f) * CascadeShadowResolutions[cloudCascade];
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * 1.0 + 0.5f), 1, MaxFilterWidth);
    int filterOffset = filterWidth / 2;
    float amt = 0.f;
    cloudProjPos.z = cloudProjPos.z * 0.5 + 0.5;
    cloudUv.y += 1.0 - CascadeShadowResolutions[cloudCascade];
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * ShadowParams.x;
            amt += shadow2DArray(s_ShadowCascades, vec4(cloudUv + (offset * CascadeShadowResolutions[cloudCascade]), DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * float(2), cloudProjPos.z));
        }
    }
    return amt / float(filterWidth * filterWidth);
}
float GetPlayerShadow(vec3 worldPos, float NdL) {
    const int playerCascade = 0;
    vec4 playerProjPos = ((PlayerShadowProj) * (vec4(worldPos, 1.0)));
    playerProjPos /= playerProjPos.w;
    float bias = ShadowBias[playerCascade] + ShadowSlopeBias[playerCascade] * clamp(tan(acos(NdL)), 0.0, 1.0);
    playerProjPos.z -= bias / playerProjPos.w;
    playerProjPos.z = min(playerProjPos.z, 1.0);
    vec2 playerUv = (vec2(playerProjPos.x, playerProjPos.y) * 0.5f + 0.5f) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidth.y;
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(2.0 * 1.0 + 0.5f), 1, MaxFilterWidth);
    int filterOffset = filterWidth / 2;
    float amt = 0.f;
    playerProjPos.z = playerProjPos.z * 0.5 + 0.5;
    playerUv.y += 1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidth.y;
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidth.z;
            vec2 newUv = playerUv + (offset * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidth.y);
            if (newUv.x >= 0.0 && newUv.x < 1.0 && newUv.y >= 0.0 && newUv.y < 1.0) {
                amt += shadow2D(s_PlayerShadowMap, vec3(newUv, playerProjPos.z));
            }
            else {
                amt += 1.0f;
            }
        }
    }
    return amt / float(filterWidth * filterWidth);
}
float GetFilteredShadow(int cascadeIndex, float projZ, int cascade, vec2 uv) {
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(ShadowPCFWidth[cascade] * 1.0 + 0.5), 1, MaxFilterWidth);
    int filterOffset = filterWidth / 2;
    float amt = 0.f;
    vec2 baseUv = uv * CascadeShadowResolutions[cascade];
    projZ = projZ * 0.5 + 0.5;
    baseUv.y += 1.0 - CascadeShadowResolutions[cascade];
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * ShadowParams.x;
            if (cascadeIndex >= 0) {
                amt += shadow2DArray(s_ShadowCascades, vec4(baseUv + (offset * CascadeShadowResolutions[cascade]), (float(cascadeIndex) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(cascade), projZ));
            } else {
                amt += 1.0;
            }
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
        amt = GetFilteredShadow(DirectionalLightSources[lightIndex].shadowCascadeNumber, projPos.z, cascade, uv);
        if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidth.x) > 0) {
            playerAmt = GetPlayerShadow(worldPos, NdL);
            amt = min(amt, playerAmt);
        }
        if (DirectionalLightSources[lightIndex].isSun > 0 && int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0) {
            cloudAmt = GetFilteredCloudShadow(worldPos, NdL);
            if (cloudAmt < 1.0) {
                cloudAmt = max(cloudAmt, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w);
                amt = min(amt, cloudAmt);
            }
        }
        float shadowFade = smoothstep(max(0.0, ShadowParams.y - 8.0), ShadowParams.y, - viewDepth);
        amt = mix(amt, 1.0, shadowFade);
    }
    return amt;
}
float calculateFogIntensityFaded(float cameraDepth, float maxDistance, float fogStart, float fogEndMinusStartReciprocal, float fogAlpha) {
    float distance = cameraDepth / maxDistance;
    distance += fogAlpha;
    return clamp((distance - fogStart) * fogEndMinusStartReciprocal, 0.0, 1.0);
}
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
vec3 worldSpaceViewDir(vec3 worldPosition) {
    vec3 cameraPosition = ((InvView) * (vec4(0.f, 0.f, 0.f, 1.f))).xyz;
    return normalize(worldPosition - cameraPosition);
}
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
vec3 applyScattering(vec4 sourceExtinction, vec3 color) {
    return sourceExtinction.rgb + sourceExtinction.a * color;
}
struct TemporalAccumulationParameters {
    ivec3 dimensions;
    vec3 previousUvw;
    vec4 currentValue;
    float historyWeight;
    float frustumBoundaryFalloff;
};

vec3 getFresnelSchlickRoughness(float cosTheta, vec3 F0, float roughness) {
    float smoothness = 1.0 - roughness;
    return F0 + (max(F0, vec3_splat(smoothness)) - F0) * pow(1.0 - cosTheta, 5.0);
}
float getIBLMipLevel(float roughness, float numMips) {
    float x = 1.0 - roughness;
    return (1.0 - (x * x)) * (numMips - 1.0);
}
void BSDF_VanillaMinecraft(vec3 n, vec3 l, float nDotL, vec3 v, vec3 color, float metalness, float linearRoughness, vec3 rf0, inout vec3 diffuse, inout vec3 specular) {
    vec3 h = normalize(l + v);
    float nDotV = max(dot(n, v), 0.0);
    float roughness = linearRoughness * linearRoughness;
    float d = D_GGX_TrowbridgeReitz(n, h, roughness);
    float g = G_Smith(nDotL, nDotV, roughness);
    vec3 f = F_Schlick(v, h, rf0);
    vec3 albedo = (1.0 - f) * (1.0 - metalness) * color;
    diffuse = BRDF_Diff_Lambertian(albedo) * DiffuseSpecularEmissiveAmbientTermToggles.x;
    specular = BRDF_Spec_CookTorrance(nDotL, nDotV, d, g, f) * DiffuseSpecularEmissiveAmbientTermToggles.y;
}
void BSDF_VanillaMinecraft_DiffuseOnly(vec3 color, float metalness, inout vec3 diffuse) {
    vec3 albedo = (1.0 - metalness) * color;
    diffuse = BRDF_Diff_Lambertian(albedo) * DiffuseSpecularEmissiveAmbientTermToggles.x;
}
void BSDF_VanillaMinecraft_SpecularOnly(vec3 n, vec3 l, float nDotL, vec3 v, float metalness, float linearRoughness, vec3 rf0, inout vec3 specular) {
    vec3 h = normalize(l + v);
    float nDotV = max(dot(n, v), 0.0);
    float roughness = linearRoughness * linearRoughness;
    float d = D_GGX_TrowbridgeReitz(n, h, roughness);
    float g = G_Smith(nDotL, nDotV, roughness);
    vec3 f = F_Schlick(v, h, rf0);
    specular = BRDF_Spec_CookTorrance(nDotL, nDotV, d, g, f) * DiffuseSpecularEmissiveAmbientTermToggles.y;
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
float calculateDirectOcclusionForDiscreteLight(int lightIndex, vec3 surfaceWorldPos, vec3 surfaceWorldNormal) {
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
    vec4 surfaceProjPos = ((PointLightProj) * (vec4(surfaceViewPosition, 1.0)));
    float NdL = dot(-normalize(lightToPoint), surfaceWorldNormal);
    float bias = PointLightShadowParams1.x + PointLightShadowParams1.y * clamp(tan(acos(NdL)), 0.0, 1.0);
    surfaceProjPos.z += bias;
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
            directOcclusion += shadow2DArray(s_PointLightShadowTextureArray, vec4(offsetSampleCoordinates, surfaceProjPos.z));
        }
    }
    return directOcclusion / float(filterWidth * filterWidth);
}
DiscreteLightingContributions evaluateDiscreteLightsDirectContribution(vec2 lightClusterUV, vec3 surfacePos, vec3 n, vec3 v, vec3 color, float metalness, float linearRoughness, vec3 rf0, vec3 surfaceWorldPos, vec3 surfaceWorldNormal, bool calculateDiffuse, bool calculateSpecular, out bool noDiscreteLight) {
    DiscreteLightingContributions lightContrib;
    lightContrib.diffuse = vec3_splat(0.0);
    lightContrib.specular = vec3_splat(0.0);
    lightContrib.ambientTint = vec3_splat(0.0);
    if (!(calculateSpecular || calculateDiffuse))
    {
        return lightContrib;
    }
    vec3 clusterId = getClusterIndex(lightClusterUV, - surfacePos.z, ClusterDimensions.xyz, ClusterNearFarWidthHeight.xy, ClusterNearFarWidthHeight.zw, ClusterSize.xy);
    if (clusterId.x >= ClusterDimensions.x || clusterId.y >= ClusterDimensions.y || clusterId.z >= ClusterDimensions.z) {
        return lightContrib;
    }
    highp int clusterIdx = int(clusterId.x + clusterId.y * ClusterDimensions.x + clusterId.z * ClusterDimensions.x * ClusterDimensions.y);
    highp int rangeStart = clusterIdx * int(ClusterDimensions.w);
    highp int rangeEnd = rangeStart + int(ClusterDimensions.w);
    float surfaceDistanceFromCamera = 0.0f;
    if (ManhattanDistAttenuationEnabled.x > 0.0f) {
        vec3 surfaceGridPos = floor(surfaceWorldPos + WorldOrigin.xyz);
        vec3 cameraGridPos = floor(((InvView) * (vec4(0.0f, 0.0f, 0.0f, 1.0f))).xyz + WorldOrigin.xyz);
        vec3 gridDist = surfaceGridPos - cameraGridPos;
        surfaceDistanceFromCamera = abs(gridDist.x) + abs(gridDist.y) + abs(gridDist.z);
    }
    else {
        surfaceDistanceFromCamera = length(surfacePos);
    }
    int usedLightCount = 0;
    for(highp int i = rangeStart; i < rangeEnd; ++ i) {
        int lightIndex = int(LightLookupArray[i].lookup);
        if (lightIndex < 0) {
            break;
        }
        vec3 lightWorldDir = Lights[lightIndex].position.xyz - surfaceWorldPos.xyz;
        float squaredDistanceToLight = 0.0f;
        if (ManhattanDistAttenuationEnabled.x > 0.0f) {
            squaredDistanceToLight = abs(lightWorldDir.x) + abs(lightWorldDir.y) + abs(lightWorldDir.z);
            squaredDistanceToLight = dot(squaredDistanceToLight, squaredDistanceToLight);
        }
        else {
            squaredDistanceToLight = dot(lightWorldDir, lightWorldDir);
        }
        float r = Lights[lightIndex].position.w;
        if (squaredDistanceToLight >= r * r) {
            continue;
        }
        float directOcclusion = 1.0f;
        if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0) {
            directOcclusion = calculateDirectOcclusionForDiscreteLight(lightIndex, surfaceWorldPos, surfaceWorldNormal);
        }
        if (directOcclusion <= 0.0f) {
            continue;
        }
        vec3 lightPos = ((View) * (vec4(Lights[lightIndex].position.xyz, 1.0))).xyz;
        vec3 lightDir = lightPos - surfacePos;
        vec3 l = normalize(lightDir);
        float nDotl = max(dot(n, l), 0.0);
        float lightIntensity = Lights[lightIndex].color.a;
        float attenuation = getDistanceAttenuation(squaredDistanceToLight, r);
        vec3 lightColor = Lights[lightIndex].color.rgb;
        vec3 illuminance = lightColor * lightIntensity * attenuation * nDotl;
        vec3 diffuse = vec3_splat(0.0);
        vec3 specular = vec3_splat(0.0);
        if (calculateDiffuse) {
            if (calculateSpecular) {
                BSDF_VanillaMinecraft(n, l, nDotl, v, color, metalness, linearRoughness, rf0, diffuse, specular);
            }
            else {
                BSDF_VanillaMinecraft_DiffuseOnly(color, metalness, diffuse);
            }
        }
        else {
            if (calculateSpecular) {
                BSDF_VanillaMinecraft_SpecularOnly(n, l, nDotl, v, metalness, linearRoughness, rf0, specular);
            }
        }
        usedLightCount ++ ;
        lightContrib.ambientTint += mix(BlockBaseAmbientLightColorIntensity.rgb, lightColor, clamp(attenuation, 0.0f, 0.95f));
        lightContrib.diffuse += diffuse * directOcclusion * illuminance * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
        lightContrib.specular += specular * directOcclusion * illuminance * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
    }
    if (usedLightCount > 0) {
        lightContrib.ambientTint = lightContrib.ambientTint / float(usedLightCount);
        noDiscreteLight = false;
    }
    return lightContrib;
}
void evaluateDirectionalLightsDirectContribution(inout PBRLightingContributions lightContrib, float viewDepth, vec3 n, vec3 v, vec3 color, float metalness, float linearRoughness, vec3 rf0, vec3 worldPosition, vec3 worldNormal) {
    int lightCount = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    for(int i = 0; i < lightCount; i ++ ) {
        float directOcclusion = 1.0;
        if (areCascadedShadowsEnabled(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x)) {
            vec3 sl = normalize(((View) * (DirectionalLightSources[i].shadowDirection)).xyz);
            float nDotsl = max(dot(n, sl), 0.0);
            directOcclusion = GetShadowAmount(
                i,
                worldPosition,
                nDotsl,
                viewDepth
            );
        }
        vec3 l = normalize(((View) * (DirectionalLightSources[i].worldSpaceDirection)).xyz);
        float nDotl = max(dot(n, l), 0.0);
        vec4 colorAndIlluminance = DirectionalLightSources[i].diffuseColorAndIlluminance;
        vec3 illuminance = colorAndIlluminance.rgb * colorAndIlluminance.a * nDotl;
        vec3 diffuse = vec3_splat(0.0);
        vec3 specular = vec3_splat(0.0);
        BSDF_VanillaMinecraft(n, l, nDotl, v, color, metalness, linearRoughness, rf0, diffuse, specular);
        lightContrib.directDiffuse += diffuse * directOcclusion * illuminance * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
        lightContrib.directSpecular += specular * directOcclusion * illuminance * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
    }
}
vec3 evaluateSampledAmbient(float blockAmbientContribution, vec3 blockAmbientTint, float skyAmbientContribution, float ambientFadeInMultiplier) {
    if (blockAmbientTint.x <= 0.0f && blockAmbientTint.y <= 0.0f && blockAmbientTint.z <= 0.0f) {
        blockAmbientTint = vec3(1.0f, 1.0f, 1.0f);
    }
    blockAmbientTint = clamp(blockAmbientTint, vec3(0.1f, 0.1f, 0.1f), vec3(1.0f, 1.0f, 1.0f));
    vec3 sampledBlockAmbient = (blockAmbientContribution * blockAmbientContribution) * blockAmbientTint * BlockBaseAmbientLightColorIntensity.a * ambientFadeInMultiplier * lumaPerceptual(BlockBaseAmbientLightColorIntensity.rgb) / lumaPerceptual(blockAmbientTint);
    float skyFalloffPow = mix(5.0, 3.0, CameraLightIntensity.y);
    float skyFalloff = pow(skyAmbientContribution, skyFalloffPow);
    vec3 sampledSkyAmbient = skyFalloff * SkyAmbientLightColorIntensity.rgb * SkyAmbientLightColorIntensity.a;
    vec3 sampledAmbient = sampledBlockAmbient + sampledSkyAmbient;
    sampledAmbient = max(sampledAmbient, vec3_splat(0.03));
    return sampledAmbient;
}
void evaluateIndirectLightingContribution(inout PBRLightingContributions lightContrib, vec3 albedo, float blockAmbientContribution, float skyAmbientContribution, float ambientFadeInMultiplier, float linearRoughness, vec3 v, vec3 n, vec3 f0, vec3 ambientTint) {
    vec3 sampledAmbient = evaluateSampledAmbient(blockAmbientContribution, ambientTint, skyAmbientContribution, ambientFadeInMultiplier);
    lightContrib.indirectDiffuse += albedo * sampledAmbient * DiffuseSpecularEmissiveAmbientTermToggles.w;
    vec3 R = reflect(v, n);
    float nDotv = clamp(dot(n, v), 0.0, 1.0);
    float roughness = linearRoughness * linearRoughness;
    vec3 preFilteredColor = textureCubeLod(s_SpecularIBL, R, getIBLMipLevel(roughness, IBLParameters.y)).rgb;
    vec2 envDFG = textureSample(s_BrdfLUT, vec2(nDotv, 1.0 - roughness)).rg;
    vec3 F = getFresnelSchlickRoughness(nDotv, f0, roughness);
    lightContrib.indirectSpecular += preFilteredColor * (F * envDFG.x + envDFG.y) * IBLParameters.x * IBLParameters.z;
}
vec3 evaluateAtmosphericAndVolumetricScattering(vec3 surfaceRadiance, vec3 viewDirWorld, float viewDistance, vec3 ndcPosition) {
    vec3 fogAppliedColor;
    if (AtmosphericScatteringToggles.x != 0.0) {
        float fogIntensity = calculateFogIntensityFaded(viewDistance, FogAndDistanceControl.z, FogAndDistanceControl.x, FogAndDistanceControl.y, RenderChunkFogAlpha.x);
        if (fogIntensity > 0.0) {
            vec3 fogColor = vec3(0.0, 0.0, 0.0);
            if (AtmosphericScatteringToggles.y == 0.0) {
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
    if (VolumeScatteringEnabled.x != 0.0) {
        vec3 uvw = ndcToVolume(ndcPosition, InvProj, VolumeNearFar.xy);
        vec4 sourceExtinction = sampleVolume(s_ScatteringBuffer, ivec3(VolumeDimensions.xyz), uvw);
        outColor = applyScattering(sourceExtinction, fogAppliedColor);
    }
    else {
        outColor = fogAppliedColor;
    }
    return outColor;
}
vec4 evaluateFragmentColor(PBRFragmentInfo fragmentInfo) {
    PBRLightingContributions lightContrib;
    lightContrib.directDiffuse = vec3_splat(0.0);
    lightContrib.directSpecular = vec3_splat(0.0);
    lightContrib.indirectDiffuse = vec3_splat(0.0);
    lightContrib.indirectSpecular = vec3_splat(0.0);
    lightContrib.emissive = vec3_splat(0.0);
    float dist = 0.0f;
    if (ManhattanDistAttenuationEnabled.x > 0.0f) {
        dist = abs(fragmentInfo.viewPosition.x) + abs(fragmentInfo.viewPosition.y) + abs(fragmentInfo.viewPosition.z);
    }
    else {
        dist = length(fragmentInfo.viewPosition);
    }
    float distPointLightSpecularFadeOut_Begin = PointLightSpecularFadeOutParameters.x;
    float distPointLightSpecularFadeOut_End = PointLightSpecularFadeOutParameters.y;
    bool enablePointLightSpecularFade = distPointLightSpecularFadeOut_Begin > 0.0f;
    float percentOfSpecularFade = 0.0f;
    if (enablePointLightSpecularFade) {
        percentOfSpecularFade = smoothstep(distPointLightSpecularFadeOut_Begin, distPointLightSpecularFadeOut_End, dist);
    }
    float fadeOutSpecularMultiplier = 1.0f - percentOfSpecularFade;
    float distPointLightDiffuseFadeOut_Begin = PointLightDiffuseFadeOutParameters.x;
    float distPointLightDiffuseFadeOut_End = PointLightDiffuseFadeOutParameters.y;
    float ambientBlockContributionNaught = PointLightDiffuseFadeOutParameters.z;
    float ambientBlockContributionFinal = PointLightDiffuseFadeOutParameters.w;
    bool enablePointLightDiffuseFade = distPointLightDiffuseFadeOut_Begin > 0.0f;
    float percentOfDiffuseFade = 0.0f;
    float fadeInAmbient = ambientBlockContributionNaught;
    if (enablePointLightDiffuseFade) {
        percentOfDiffuseFade = smoothstep(distPointLightDiffuseFadeOut_Begin, distPointLightDiffuseFadeOut_End, dist);
        fadeInAmbient += ((ambientBlockContributionFinal - ambientBlockContributionNaught) * percentOfDiffuseFade);
    }
    float fadeOutDiffuseMultiplier = 1.0f - percentOfDiffuseFade;
    float reflectance = 0.5;
    float dielectricF0 = 0.16f * reflectance * reflectance * (1.0f - fragmentInfo.metalness);
    vec3 rf0 = vec3_splat(dielectricF0) + fragmentInfo.albedo * fragmentInfo.metalness;
    float viewDistance = length(fragmentInfo.viewPosition);
    vec3 viewDir = -(fragmentInfo.viewPosition / viewDistance);
    vec3 viewDirWorld = worldSpaceViewDir(fragmentInfo.worldPosition.xyz);
    vec3 ambientTint = vec3(1.0, 1.0, 1.0);
    bool noDiscreteLight = true;
    if (fragmentInfo.ndcPosition.z != 1.0) {
        evaluateDirectionalLightsDirectContribution(
            lightContrib,
            fragmentInfo.viewPosition.z, fragmentInfo.viewNormal, viewDir, fragmentInfo.albedo,
        fragmentInfo.metalness, fragmentInfo.roughness, rf0, fragmentInfo.worldPosition, fragmentInfo.worldNormal);
        bool shouldCalculateSpecularTerm = (!enablePointLightSpecularFade)||(enablePointLightSpecularFade && dist < distPointLightSpecularFadeOut_End);
        bool shouldCalculateDiffuseTerm = (!enablePointLightDiffuseFade)||(enablePointLightDiffuseFade && dist < distPointLightDiffuseFadeOut_End);
        DiscreteLightingContributions discreteLightContrib = evaluateDiscreteLightsDirectContribution(
            fragmentInfo.lightClusterUV, fragmentInfo.viewPosition.xyz, fragmentInfo.viewNormal, viewDir,
            fragmentInfo.albedo,
            fragmentInfo.metalness,
            fragmentInfo.roughness,
            rf0,
            fragmentInfo.worldPosition,
            fragmentInfo.worldNormal,
            shouldCalculateDiffuseTerm,
            shouldCalculateSpecularTerm,
        noDiscreteLight);
        ambientTint = discreteLightContrib.ambientTint;
        lightContrib.directDiffuse += discreteLightContrib.diffuse * fadeOutDiffuseMultiplier;
        lightContrib.directSpecular += discreteLightContrib.specular * fadeOutSpecularMultiplier;
    }
    lightContrib.emissive += DiffuseSpecularEmissiveAmbientTermToggles.z * desaturate(fragmentInfo.albedo, EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y) * vec3(fragmentInfo.emissive, fragmentInfo.emissive, fragmentInfo.emissive) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x;
    if (noDiscreteLight) {
        fadeInAmbient = ambientBlockContributionFinal;
    }
    evaluateIndirectLightingContribution(
        lightContrib,
        fragmentInfo.albedo.rgb,
        fragmentInfo.blockAmbientContribution,
        fragmentInfo.skyAmbientContribution,
        fadeInAmbient,
        fragmentInfo.roughness,
        viewDirWorld,
        fragmentInfo.worldNormal,
        rf0,
    ambientTint);
    vec3 surfaceRadiance = lightContrib.indirectDiffuse + lightContrib.directDiffuse + lightContrib.indirectSpecular + lightContrib.directSpecular + lightContrib.emissive;
    vec3 outColor = evaluateAtmosphericAndVolumetricScattering(surfaceRadiance, viewDirWorld, viewDistance, fragmentInfo.ndcPosition);
    return vec4(outColor, 1.0);
}
void RenderChunk_getPBRSurfaceOutputValues(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput, bool isAlphaTest) {
    vec4 diffuse = textureSample(s_MatTexture, surfaceInput.UV);
    if (isAlphaTest) {
        const float ALPHA_THRESHOLD = 0.5;
        if (diffuse.a < ALPHA_THRESHOLD) {
            discard;
        }
    }
    #ifdef SEASONS__OFF
    diffuse.rgb *= surfaceInput.Color.rgb;
    diffuse.a *= surfaceInput.Alpha;
    #endif
    #ifdef SEASONS__ON
    diffuse = applySeasons(surfaceInput.Color, surfaceInput.Alpha, diffuse);
    #endif
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
}
#endif
#if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
void RenderChunkSurfTransparent(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    #ifdef FORWARD_PBR_TRANSPARENT_PASS
    RenderChunk_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, true);
    applyPBRValuesToSurfaceOutput(surfaceInput, surfaceOutput, PBRData[surfaceInput.pbrTextureId]);
    PBRFragmentInfo fragmentData;
    vec4 viewPosition = ((View) * (vec4(surfaceInput.worldPos, 1.0)));
    vec4 clipPosition = ((Proj) * (viewPosition));
    vec3 ndcPosition = clipPosition.xyz / clipPosition.w;
    vec2 uv = (ndcPosition.xy + vec2(1.0, 1.0)) / 2.0;
    vec4 worldNormal = vec4(surfaceOutput.ViewSpaceNormal, 0.0);
    vec4 viewNormal = ((View) * (worldNormal));
    fragmentData.lightClusterUV = uv;
    fragmentData.worldPosition = surfaceInput.worldPos;
    fragmentData.viewPosition = viewPosition.xyz;
    fragmentData.ndcPosition = ndcPosition;
    fragmentData.worldNormal = worldNormal.xyz;
    fragmentData.viewNormal = viewNormal.xyz;
    fragmentData.albedo = surfaceOutput.Albedo;
    fragmentData.roughness = surfaceOutput.Roughness;
    fragmentData.metalness = surfaceOutput.Metallic;
    fragmentData.emissive = surfaceOutput.Emissive;
    fragmentData.blockAmbientContribution = surfaceInput.lightmapUV.x;
    fragmentData.skyAmbientContribution = surfaceInput.lightmapUV.y;
    surfaceOutput.Albedo = evaluateFragmentColor(fragmentData).rgb;
    #endif
    #ifdef OPAQUE_PASS
    surfaceOutput.Albedo = vec3(1.0, 1.0, 1.0);
    #endif
}
void RenderChunkApplyPBR(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    fragOutput.Color0.rgb = surfaceOutput.Albedo;
}
#endif
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #if defined(ALPHA_TEST_PASS)|| defined(DEPTH_ONLY_PASS)
    RenderChunkSurfAlpha(surfaceInput, surfaceOutput);
    #endif
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    RenderChunkSurfOpaque(surfaceInput, surfaceOutput);
    #endif
    #if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
    RenderChunkSurfTransparent(surfaceInput, surfaceOutput);
    #endif
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    #if ! defined(FORWARD_PBR_TRANSPARENT_PASS)&& ! defined(OPAQUE_PASS)
    compositingOutput.mLitColor = computeLighting_RenderChunk(fragInput, surfaceInput, surfaceOutput, primaryLight);
    #endif
    #if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    #endif
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #if ! defined(FORWARD_PBR_TRANSPARENT_PASS)&& ! defined(OPAQUE_PASS)
    RenderChunkApplyFog(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
    RenderChunkApplyPBR(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.bitangent = v_bitangent;
    fragmentInput.color0 = v_color0;
    fragmentInput.fog = v_fog;
    fragmentInput.lightmapUV = v_lightmapUV;
    fragmentInput.normal = v_normal;
    #if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
    fragmentInput.pbrTextureId = v_pbrTextureId;
    #endif
    fragmentInput.tangent = v_tangent;
    fragmentInput.texcoord0 = v_texcoord0;
    fragmentInput.worldPos = v_worldPos;
    fragmentOutput.Color0 = vec4(0, 0, 0, 0);
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
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    #if ! defined(FORWARD_PBR_TRANSPARENT_PASS)&& ! defined(OPAQUE_PASS)
    bgfx_FragColor = fragmentOutput.Color0;
    #endif
    #if defined(FORWARD_PBR_TRANSPARENT_PASS)|| defined(OPAQUE_PASS)
    bgfx_FragData[0] = fragmentOutput.Color0; ;
    #endif
}

