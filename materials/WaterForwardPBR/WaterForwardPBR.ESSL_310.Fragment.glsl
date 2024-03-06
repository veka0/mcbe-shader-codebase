#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS
* - DO_WATER_FULL_SCREEN_DRAW_PASS
* - DO_WATER_SHADING_PASS
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

#define shadow2D(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DArray(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DProj(_sampler, _coord)textureProj(_sampler, _coord)
#ifndef DEPTH_ONLY_PASS
#extension GL_EXT_texture_array : enable
#endif
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
#ifdef DEPTH_ONLY_PASS
out vec4 bgfx_FragColor;
#endif
#ifndef DEPTH_ONLY_PASS
out vec4 bgfx_FragData[gl_MaxDrawBuffers];
#endif
varying vec3 v_bitangent;
#ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
varying vec4 v_color0;
#endif
#ifdef DO_WATER_SHADING_PASS
flat varying int v_frontFacing;
#endif
#ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
varying vec2 v_lightmapUV;
#endif
varying vec3 v_normal;
#ifdef DO_WATER_FULL_SCREEN_DRAW_PASS
varying vec3 v_projPosition;
#endif
#ifdef DO_WATER_SHADING_PASS
flat varying int v_pbrTextureId;
#endif
varying vec3 v_tangent;
centroid varying vec2 v_texcoord0;
varying vec3 v_worldPos;
struct NoopSampler {
    int noop;
};

#ifndef DEPTH_ONLY_PASS
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
#ifdef DO_WATER_SHADING_PASS
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
uniform vec4 u_viewTexel;
uniform vec4 ShadowBias;
uniform vec4 SunDir;
uniform vec4 PointLightShadowParams1;
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
uniform vec4 DefaultWaterCoefficient;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform vec4 RedCentralWaterCoefficient;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 CascadeShadowResolutions;
uniform vec4 u_alphaRef4;
uniform vec4 FogAndDistanceControl;
uniform vec4 AtmosphericScattering;
uniform vec4 ClusterSize;
uniform vec4 SkyZenithColor;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 BlueCentralWaterCoefficient;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraLightIntensity;
uniform vec4 WorldOrigin;
uniform mat4 CloudShadowProj;
uniform vec4 ClusterDimensions;
uniform vec4 PreExposureEnabled;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 SubsurfaceScatteringContribution;
uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 VolumeNearFar;
uniform vec4 EnabledWaterLightingFeatures;
uniform vec4 ShadowParams;
uniform vec4 MoonColor;
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidth;
uniform vec4 ShadowPCFWidth;
uniform vec4 FogColor;
uniform vec4 FogSkyBlend;
uniform vec4 GlobalRoughness;
uniform vec4 SkyHorizonColor;
uniform vec4 GreenCentralWaterCoefficient;
uniform vec4 IsCameraUnderwater;
uniform vec4 LightDiffuseColorAndIlluminance;
uniform vec4 LightWorldSpaceDirection;
uniform vec4 MaterialID;
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 MoonDir;
uniform mat4 PlayerShadowProj;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 PointLightSpecularFadeOutParameters;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SubPixelOffset;
uniform vec4 SunColor;
uniform vec4 ViewPositionAndTime;
uniform vec4 VolumeDimensions;
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
    #ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
    vec4 color0;
    vec2 lightmapUV;
    #endif
    vec4 normal;
    #ifdef DO_WATER_SHADING_PASS
    int pbrTextureId;
    #endif
    vec3 position;
    vec4 tangent;
    vec2 texcoord0;
    #if defined(INSTANCING__ON)&& ! defined(DO_WATER_FULL_SCREEN_DRAW_PASS)
    vec4 instanceData0;
    vec4 instanceData1;
    vec4 instanceData2;
    #endif
};

struct VertexOutput {
    vec4 position;
    vec3 bitangent;
    #ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
    vec4 color0;
    #endif
    #ifdef DO_WATER_SHADING_PASS
    int frontFacing;
    #endif
    #ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
    vec2 lightmapUV;
    #endif
    vec3 normal;
    #ifdef DO_WATER_FULL_SCREEN_DRAW_PASS
    vec3 projPosition;
    #endif
    #ifdef DO_WATER_SHADING_PASS
    int pbrTextureId;
    #endif
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentInput {
    vec3 bitangent;
    #ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
    vec4 color0;
    #endif
    #ifdef DO_WATER_SHADING_PASS
    int frontFacing;
    #endif
    #ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
    vec2 lightmapUV;
    #endif
    vec3 normal;
    #ifdef DO_WATER_FULL_SCREEN_DRAW_PASS
    vec3 projPosition;
    #endif
    #ifdef DO_WATER_SHADING_PASS
    int pbrTextureId;
    #endif
    vec3 tangent;
    vec2 texcoord0;
    vec3 worldPos;
};

struct FragmentOutput {
    vec4 Color0;
};

uniform lowp sampler2D s_LightMapTexture;
uniform lowp sampler2D s_MatTexture;
uniform highp sampler2DShadow s_PlayerShadowMap;
uniform highp sampler2DArrayShadow s_PointLightShadowTextureArray;
uniform lowp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform lowp sampler2D s_SceneColor;
uniform lowp sampler2D s_SceneDepth;
uniform lowp sampler2D s_SeasonsTexture;
uniform highp sampler2DArrayShadow s_ShadowCascades;
uniform lowp sampler2DArray s_WaterSurfaceDepthTextures;
layout(std430, binding = 0)buffer s_DirectionalLightSources { LightSourceWorldInfo DirectionalLightSources[]; };
layout(std430, binding = 1)buffer s_LightLookupArray { LightData LightLookupArray[]; };
layout(std430, binding = 3)buffer s_Lights { Light Lights[]; };
layout(std430, binding = 5)buffer s_PBRData { PBRTextureData PBRData[]; };
#ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
struct StandardSurfaceInput {
    vec2 UV;
    vec3 Color;
    float Alpha;
    vec2 lightmapUV;
    vec3 bitangent;
    #ifdef DO_WATER_SHADING_PASS
    int frontFacing;
    #endif
    vec3 normal;
    #ifdef DO_WATER_SHADING_PASS
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
    #ifdef DO_WATER_SHADING_PASS
    result.frontFacing = fragInput.frontFacing;
    #endif
    result.normal = fragInput.normal;
    #ifdef DO_WATER_SHADING_PASS
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
#endif
struct ColorTransform {
    float hue;
    float saturation;
    float luminance;
};

#ifdef DEPTH_ONLY_PASS
struct CompositingOutput {
    vec3 mLitColor;
};
#endif
#ifndef DEPTH_ONLY_PASS
mat3 getCIEXYZToRGBTransform() {
    return mat3(
        3.2404542, - 1.5371385, - 0.4985314,
        - 0.9692660, 1.8760108, 0.0415560,
        0.0556434, - 0.2040259, 1.0572252
    );
}
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
#endif
#ifdef DO_WATER_FULL_SCREEN_DRAW_PASS
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
#ifdef DO_WATER_SHADING_PASS
vec2 worldToNdc(vec3 worldPos, mat4 viewProj) {
    vec4 clipSpacePos = ((viewProj) * (vec4(worldPos, 1.0)));
    vec2 ndc = clipSpacePos.xy / clipSpacePos.w;
    ndc.y *= -1.0;
    return (vec2((ndc).x, 1.0 - (ndc).y));
}
vec3 getWorldPosFromDepthTexture(sampler2D depthTexture, vec2 uv, mat4 inverseView, mat4 inverseProj) {
    float depth = textureSample(depthTexture, uv).r;
    vec2 xy = uv * 2.0 - 1.0;
    xy.y *= -1.0;
    vec2 platformNdc = (vec2((xy).x, 1.0 - (xy).y));
    depth = depth * 2.0f - 1.0f;
    vec4 viewPosition = projToView(vec4(platformNdc, depth, 1.0), inverseProj);
    return ((inverseView) * (vec4(viewPosition.xyz, 1.0))).xyz;
}
vec2 worldToUv(vec3 worldPos, mat4 viewProj) {
    vec2 ndc = worldToNdc(worldPos, viewProj);
    vec2 uv = 0.5 * (ndc + vec2(1.0, 1.0));
    return uv;
}
struct CompositingOutput {
    vec3 mLitColor;
};
#endif

#ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
vec4 standardComposite(StandardSurfaceOutput stdOutput, CompositingOutput compositingOutput) {
    return vec4(compositingOutput.mLitColor, stdOutput.Alpha);
}
#endif
#ifdef DEPTH_ONLY_PASS
void StandardTemplate_FinalColorOverrideIdentity(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
}
#endif
#ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
void StandardTemplate_CustomSurfaceShaderEntryIdentity(vec2 uv, vec3 worldPosition, inout StandardSurfaceOutput surfaceOutput) {
}
struct DirectionalLight {
    vec3 ViewSpaceDirection;
    vec3 Intensity;
};
#endif
#ifdef DO_WATER_SHADING_PASS

vec3 computeLighting_Unlit(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return stdOutput.Albedo;
}
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
void applyPBRValuesToSurfaceOutput(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput, int pbrTextureId) {
    const int kInvalidPBRTextureHandle = 0xffff;
    if (pbrTextureId == kInvalidPBRTextureHandle) {
        return;
    }
    PBRTextureData pbrTextureData = PBRData[pbrTextureId];
    vec2 normalUVScale = vec2(pbrTextureData.colourToNormalUvScale0, pbrTextureData.colourToNormalUvScale1);
    vec2 normalUVBias = vec2(pbrTextureData.colourToNormalUvBias0, pbrTextureData.colourToNormalUvBias1);
    vec2 materialUVScale = vec2(pbrTextureData.colourToMaterialUvScale0, pbrTextureData.colourToMaterialUvScale1);
    vec2 materialUVBias = vec2(pbrTextureData.colourToMaterialUvBias0, pbrTextureData.colourToMaterialUvBias1);
    const int kPBRTextureDataFlagHasMaterialTexture = (1 << 0);
    const int kPBRTextureDataFlagHasNormalTexture = (1 << 1);
    const int kPBRTextureDataFlagHasHeightMapTexture = (1 << 2);
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
    float subsurface = pbrTextureData.uniformSubsurface;
    if ((pbrTextureData.flags & kPBRTextureDataFlagHasMaterialTexture) == kPBRTextureDataFlagHasMaterialTexture)
    {
        vec2 uv = getPBRDataUV(surfaceInput.UV, materialUVScale, materialUVBias);
        vec3 texel = textureSample(s_MatTexture, uv).rgb;
        metalness = texel.r;
        emissive = texel.g;
        linearRoughness = texel.b;
    }
    vec3 vertexNormal = surfaceInput.normal;
    if (surfaceInput.frontFacing != 0) {
        vertexNormal = -vertexNormal;
    }
    mat3 tbn = mtxFromRows(
        normalize(surfaceInput.tangent),
        normalize(surfaceInput.bitangent),
        normalize(vertexNormal)
    );
    tbn = transpose(tbn);
    surfaceOutput.Roughness = linearRoughness;
    surfaceOutput.Metallic = metalness;
    surfaceOutput.Emissive = emissive;
    surfaceOutput.Subsurface = subsurface;
    surfaceOutput.ViewSpaceNormal = ((tbn) * (tangentNormal)).xyz;
}
#endif
#if defined(DO_WATER_SHADING_PASS)&& defined(SEASONS__ON)
vec4 applySeasons(vec3 vertexColor, float vertexAlpha, vec4 diffuse) {
    vec2 uv = vertexColor.xy;
    diffuse.rgb *= mix(vec3(1.0, 1.0, 1.0), textureSample(s_SeasonsTexture, uv).rgb * 2.0, vertexColor.b);
    diffuse.rgb *= vec3_splat(vertexAlpha);
    diffuse.a = 1.0;
    return diffuse;
}
#endif
#ifdef DO_WATER_SHADING_PASS
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
#endif
#ifndef DEPTH_ONLY_PASS
vec3 worldSpaceViewDir(vec3 worldPosition) {
    vec3 cameraPosition = ((InvView) * (vec4(0.f, 0.f, 0.f, 1.f))).xyz;
    return normalize(worldPosition - cameraPosition);
}
#endif
#ifdef DO_WATER_SHADING_PASS
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

float calculateFogIntensityFadedVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd, float fogAlpha) {
    float distance = cameraDepth / maxDistance;
    distance += fogAlpha;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
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
#endif
#ifndef DEPTH_ONLY_PASS
float calculateCosRefractedAngle(float cosIncidentAngle, float index1, float index2) {
    float ratioSqr = (index1 / index2) * (index1 / index2);
    float cosRefractedAngleSqr = 1.0 - ratioSqr + ratioSqr * cosIncidentAngle * cosIncidentAngle;
    return sqrt(cosRefractedAngleSqr);
}
float sPolarizedReflection(float cosIncidentAngle, float cosRefractedAngle, float index1, float index2) {
    float param1 = index1 * cosIncidentAngle;
    float param2 = index2 * cosRefractedAngle;
    return (param1 - param2) / (param1 + param2);
}
float pPolarizedReflection(float cosIncidentAngle, float cosRefractedAngle, float index1, float index2) {
    float param1 = index1 * cosRefractedAngle;
    float param2 = index2 * cosIncidentAngle;
    return (param1 - param2) / (param1 + param2);
}
float calculateTransmissionUnpolarized(vec3 surfaceNormal, vec3 incidentDirection, float index1, float index2) {
    float cosIncidentAngle = dot(normalize(surfaceNormal), normalize(incidentDirection));
    float cosRefractedAngle = calculateCosRefractedAngle(cosIncidentAngle, index1, index2);
    return ((1.0 - sPolarizedReflection(cosIncidentAngle, cosRefractedAngle, index1, index2)) + (1.0 - pPolarizedReflection(cosIncidentAngle, cosRefractedAngle, index1, index2))) / 2.0;
}
float phaseWater(float cosIntersection) {
    return 3.0 / (16.0 * 3.1415926535897) * (1.0 + cosIntersection * cosIntersection);
}
float phaseParticles(float cosIntersection) {
    return (1.0f / (4.0f * 3.1415926535897)) * ((1.0 - (0.924 * 0.924))) / pow((1.0 + (0.924 * 0.924)) - 2.0f * 0.924 * cosIntersection, 1.5f);
}
float getPhaseFunctionResult(vec3 incidentDirection, vec3 scatteringDirection, float waterCoeff, float particleCoeff) {
    float cosIntersection = dot(normalize(-incidentDirection), normalize(scatteringDirection));
    return (waterCoeff * phaseWater(cosIntersection) + particleCoeff * phaseParticles(cosIntersection)) / (waterCoeff + particleCoeff);
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
float wrappedDiffuse(vec3 n, vec3 l, float w) {
    return max((dot(n, l) + w) / ((1.0 + w) * (1.0 + w)), 0.0);
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
    vec3 albedo = (1.0 - f) * (1.0 - metalness) * color;
    diffuse = nDotLSubsurf * BRDF_Diff_Lambertian(albedo) * diffuseEnabled;
    specular = nDotL * BRDF_Spec_CookTorrance(nDotL, nDotV, d, g, f) * specularEnabled;
}
#endif
#ifdef DO_WATER_SHADING_PASS
vec3 evaluateSampledAmbient(float blockAmbientContribution, vec4 blockAmbientTint, float blockBaseIntensity, float skyAmbientContribution, vec4 skyBaseColorIntensity, float cameraLightSkyIntensity, float ambientFadeInMultiplier) {
    float blockAmbientContributionBalanced = blockAmbientContribution * blockAmbientContribution;
    float rb = blockAmbientContributionBalanced + blockAmbientTint.r * blockAmbientTint.a;
    float gb = blockAmbientContributionBalanced * ((blockAmbientContributionBalanced * 0.6f + 0.4f) * 0.6f + 0.4f) + blockAmbientTint.g * blockAmbientTint.a;
    float bb = blockAmbientContributionBalanced * ((blockAmbientContributionBalanced * blockAmbientContributionBalanced) * 0.6f + 0.4f) + blockAmbientTint.b * blockAmbientTint.a;
    vec3 blockAmbientLightFinal = clamp(vec3(rb, gb, bb), vec3_splat(0.0), vec3_splat(1.0));
    vec3 sampledBlockAmbient = blockAmbientLightFinal * blockBaseIntensity * ambientFadeInMultiplier;
    float skyFalloffPow = mix(5.0, 3.0, cameraLightSkyIntensity);
    float skyFalloff = pow(skyAmbientContribution, skyFalloffPow);
    vec3 sampledSkyAmbient = skyFalloff * skyBaseColorIntensity.rgb * skyBaseColorIntensity.a;
    vec3 sampledAmbient = sampledBlockAmbient + sampledSkyAmbient;
    sampledAmbient = max(sampledAmbient, vec3_splat(0.03));
    return sampledAmbient;
}
#endif
#ifndef DEPTH_ONLY_PASS
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
#endif

#ifdef DEPTH_ONLY_PASS
vec3 computeLighting_Unlit(FragmentInput fragInput, StandardSurfaceInput stdInput, StandardSurfaceOutput stdOutput, DirectionalLight primaryLight) {
    return stdOutput.Albedo;
}
void WaterSurfDepthOnly(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
}
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #ifdef DEPTH_ONLY_PASS
    WaterSurfDepthOnly(surfaceInput, surfaceOutput);
    #endif
    #ifdef DO_WATER_SHADING_PASS
    WaterSurf(surfaceInput, surfaceOutput);
    #endif
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #ifdef DEPTH_ONLY_PASS
    StandardTemplate_FinalColorOverrideIdentity(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #ifdef DO_WATER_SHADING_PASS
    WaterFinal(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
}
#endif
#ifndef DEPTH_ONLY_PASS
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
float getOpticalDepth(vec3 startPos, vec3 endPos, float coefficient) {
    return length(endPos - startPos) * coefficient;
}
vec3 getRefractedDir(vec3 incidentDir, vec3 surfaceNormal, float index1, float index2) {
    float ratio = index2 / index1;
    float cosIncidentAngle = dot(-incidentDir, surfaceNormal);
    float cosRefractedAngle = calculateCosRefractedAngle(cosIncidentAngle, index1, index2);
    return normalize(incidentDir * ratio + surfaceNormal * (cosIncidentAngle * ratio - cosRefractedAngle));
}
float getReflectionContribution(vec3 viewSurfaceWorldPos, vec3 objectWorldPos, float scattering, float absorption, float objectColor) {
    float totalCoefficient = absorption + scattering;
    float attenuationFromObjectToViewpoint = getOpticalDepth(viewSurfaceWorldPos, objectWorldPos, totalCoefficient);
    return objectColor - objectColor * exp(-attenuationFromObjectToViewpoint);
}
float getScatteringContributionAboveWater(vec3 viewUnderWaterDir, vec3 lightUnderWaterDir, vec3 surfaceNormal, float depth, float stepLengthDivisor, float waterScattering, float particleScattering, float absorption) {
    float scattering = waterScattering + particleScattering;
    float totalCoefficient = absorption + scattering;
    if (stepLengthDivisor < 1.0f) {
        stepLengthDivisor = 1.0f;
    }
    float stepDepth = depth;
    float stepDepthLength = depth / stepLengthDivisor;
    float cosIncidentAngle = dot(-lightUnderWaterDir, surfaceNormal);
    float cosScatteringAngle = dot(viewUnderWaterDir, surfaceNormal);
    float totalIntensity = 0.0f;
    for(int i = 0; i < int(stepLengthDivisor); i ++ ) {
        float lightUnderWaterLength = stepDepth / cosIncidentAngle;
        float viewUnderWaterLength = stepDepth / cosScatteringAngle;
        totalIntensity += scattering * getPhaseFunctionResult(lightUnderWaterDir, viewUnderWaterDir, waterScattering, particleScattering) * exp(-(lightUnderWaterLength * totalCoefficient) - (viewUnderWaterLength * totalCoefficient));
        stepDepth -= stepDepthLength;
    }
    return totalIntensity;
}
float getScatteringContributionUnderwater(vec3 viewUnderWaterDir, vec3 lightUnderWaterDir, vec3 surfaceNormal, float depth, float distance, float stepLengthDivisor, float waterScattering, float particleScattering, float absorption) {
    float scattering = waterScattering + particleScattering;
    float totalCoefficient = absorption + scattering;
    if (stepLengthDivisor < 1.0f) {
        stepLengthDivisor = 1.0f;
    }
    float stepDepth = depth;
    float stepDistance = distance;
    float stepDistanceLength = distance / stepLengthDivisor;
    float cosIncidentAngle = dot(-lightUnderWaterDir, surfaceNormal);
    float cosScatteringAngle = dot(viewUnderWaterDir, surfaceNormal);
    float totalIntensity = 0.0f;
    for(int i = 0; i < int(stepLengthDivisor); i ++ ) {
        stepDepth = depth - stepDistanceLength * float(i) * cosScatteringAngle;
        float lightUnderWaterLength = stepDepth / cosIncidentAngle;
        totalIntensity += scattering * getPhaseFunctionResult(lightUnderWaterDir, viewUnderWaterDir, waterScattering, particleScattering) * exp(-(lightUnderWaterLength * totalCoefficient) - (stepDistance * totalCoefficient));
        stepDistance -= stepDistanceLength;
    }
    return totalIntensity;
}
void evaluateDirectionalLightsDirectContribution(vec3 waterSurfaceWorldPos, vec3 objectWorldPos, vec3 objectColor, vec3 waterSurfaceNormal, vec3 waterSubsurfaceNormal, vec3 viewDirWorld, vec3 viewUnderWaterDir, vec3 waterSurfaceColor, float linearRoughness, bool doRefraction, bool doSurfaceReflection, bool isCameraUnderwater, bool isRenderingSky, out vec3 surfaceReflectionColor, out vec3 refractedColor) {
    float rIntensity = 0.0;
    float gIntensity = 0.0;
    float bIntensity = 0.0;
    refractedColor = vec3_splat(0.0);
    surfaceReflectionColor = vec3_splat(0.0);
    int lightCount = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    float totalTransmission = 0.0f;
    for(int i = 0; i < lightCount; i ++ ) {
        vec4 colorAndIlluminance = DirectionalLightSources[i].diffuseColorAndIlluminance;
        vec3 lightDirWorld = normalize(-DirectionalLightSources[i].worldSpaceDirection.xyz);
        vec3 lightUnderWaterDir = getRefractedDir(lightDirWorld, waterSurfaceNormal, 1.000, 1.333);
        float depth = 1.0;
        float distance = length(waterSurfaceWorldPos - objectWorldPos);
        float transmission = clamp(calculateTransmissionUnpolarized(waterSurfaceNormal, - lightDirWorld, 1.000, 1.333), 0.0, 1.0);
        totalTransmission += transmission;
        float directOcclusion = 1.0;
        vec4 waterSurfaceViewPos = ((View) * (vec4(waterSurfaceWorldPos, 1.0)));
        if (areCascadedShadowsEnabled(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x)) {
            vec3 sl = normalize(((View) * (DirectionalLightSources[i].shadowDirection)).xyz);
            float nDotsl = 1.0f;
            if (doSurfaceReflection) {
                nDotsl = max(dot(waterSurfaceNormal, sl), 0.0);
            }
            directOcclusion = GetShadowAmount(
                i,
                waterSurfaceWorldPos,
                nDotsl,
            waterSurfaceViewPos.z);
        }
        if (doSurfaceReflection) {
            float reflectance = 1.0f - transmission;
            float waterF0 = 0.16f * reflectance * reflectance;
            vec3 specular = vec3_splat(0.0);
            vec3 diffuse = vec3_splat(0.0);
            BSDF_VanillaMinecraft(
                normalize(waterSubsurfaceNormal),
                - lightDirWorld,
                viewDirWorld,
                waterSurfaceColor,
                0.0f,
                linearRoughness,
                0.0f,
                vec3_splat(waterF0),
                DiffuseSpecularEmissiveAmbientTermToggles.x,
                DiffuseSpecularEmissiveAmbientTermToggles.y,
                diffuse,
            specular);
            vec3 illuminance = reflectance * colorAndIlluminance.rgb * colorAndIlluminance.a;
            surfaceReflectionColor += (diffuse + specular) * directOcclusion * illuminance * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
        }
        if (doRefraction) {
            float rScattering = 0.0;
            float gScattering = 0.0;
            float bScattering = 0.0;
            if (bool(EnabledWaterLightingFeatures.x)&&(!isRenderingSky)) {
                if (isCameraUnderwater) {
                    rScattering = getScatteringContributionUnderwater(viewUnderWaterDir, lightUnderWaterDir, waterSurfaceNormal, depth, distance, 1.0f, RedCentralWaterCoefficient.x, RedCentralWaterCoefficient.y, RedCentralWaterCoefficient.z);
                    gScattering = getScatteringContributionUnderwater(viewUnderWaterDir, lightUnderWaterDir, waterSurfaceNormal, depth, distance, 1.0f, GreenCentralWaterCoefficient.x, GreenCentralWaterCoefficient.y, GreenCentralWaterCoefficient.z);
                    bScattering = getScatteringContributionUnderwater(viewUnderWaterDir, lightUnderWaterDir, waterSurfaceNormal, depth, distance, 1.0f, BlueCentralWaterCoefficient.x, BlueCentralWaterCoefficient.y, BlueCentralWaterCoefficient.z);
                }
                else {
                    rScattering = getScatteringContributionAboveWater(viewUnderWaterDir, lightUnderWaterDir, waterSurfaceNormal, depth, 1.0f, RedCentralWaterCoefficient.x, RedCentralWaterCoefficient.y, RedCentralWaterCoefficient.z);
                    gScattering = getScatteringContributionAboveWater(viewUnderWaterDir, lightUnderWaterDir, waterSurfaceNormal, depth, 1.0f, GreenCentralWaterCoefficient.x, GreenCentralWaterCoefficient.y, GreenCentralWaterCoefficient.z);
                    bScattering = getScatteringContributionAboveWater(viewUnderWaterDir, lightUnderWaterDir, waterSurfaceNormal, depth, 1.0f, BlueCentralWaterCoefficient.x, BlueCentralWaterCoefficient.y, BlueCentralWaterCoefficient.z);
                }
            }
            rIntensity += transmission * directOcclusion * colorAndIlluminance.r * colorAndIlluminance.a * rScattering;
            gIntensity += transmission * directOcclusion * colorAndIlluminance.g * colorAndIlluminance.a * gScattering;
            bIntensity += transmission * directOcclusion * colorAndIlluminance.b * colorAndIlluminance.a * bScattering;
        }
    }
    float rReflection = 0.0;
    float gReflection = 0.0;
    float bReflection = 0.0;
    if (bool(EnabledWaterLightingFeatures.y)) {
        if (isRenderingSky) {
            rReflection = objectColor.r;
            gReflection = objectColor.g;
            bReflection = objectColor.b;
        }
        else {
            rReflection = getReflectionContribution(waterSurfaceWorldPos, objectWorldPos, RedCentralWaterCoefficient.x + RedCentralWaterCoefficient.y, RedCentralWaterCoefficient.z, objectColor.r);
            gReflection = getReflectionContribution(waterSurfaceWorldPos, objectWorldPos, GreenCentralWaterCoefficient.x + GreenCentralWaterCoefficient.y, GreenCentralWaterCoefficient.z, objectColor.g);
            bReflection = getReflectionContribution(waterSurfaceWorldPos, objectWorldPos, BlueCentralWaterCoefficient.x + BlueCentralWaterCoefficient.y, BlueCentralWaterCoefficient.z, objectColor.b);
        }
    }
    if (lightCount <= 0) {
        lightCount = 1;
    }
    totalTransmission = totalTransmission / float(lightCount);
    rIntensity += rReflection * totalTransmission;
    gIntensity += gReflection * totalTransmission;
    bIntensity += bReflection * totalTransmission;
    vec3 cieXYZ = vec3(
        rIntensity * vec3(0.286, 0.106, 0.0).x + gIntensity * vec3(0.048, 0.5, 0.066).x + bIntensity * vec3(0.112, 0.135, 1.0).x,
        rIntensity * vec3(0.286, 0.106, 0.0).y + gIntensity * vec3(0.048, 0.5, 0.066).y + bIntensity * vec3(0.112, 0.135, 1.0).y,
        rIntensity * vec3(0.286, 0.106, 0.0).z + gIntensity * vec3(0.048, 0.5, 0.066).z + bIntensity * vec3(0.112, 0.135, 1.0).z);
        refractedColor = ((getCIEXYZToRGBTransform()) * (cieXYZ));
    }
    #endif
    #ifdef DO_WATER_FULL_SCREEN_DRAW_PASS
    void WaterFullScreenFrag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
        float z = textureSample(s_SceneDepth, fragInput.texcoord0).r;
        vec4 viewPosition = projToView(vec4(fragInput.projPosition.xy, z, 1.0), InvProj);
        vec4 worldPosition = ((InvView) * (vec4(viewPosition.xyz, 1.0)));
        vec3 viewDirWorld = normalize(-worldSpaceViewDir(worldPosition.xyz));
        vec3 refractedColor = vec3_splat(0.0);
        vec3 waterSurfaceReflection = vec3_splat(0.0);
        vec3 cameraWorldPos = ((InvView) * (vec4(0.f, 0.f, 0.f, 1.f))).xyz;
        vec3 objectWorldPos = worldPosition.xyz;
        vec3 objectColor = textureSample(s_SceneColor, fragInput.texcoord0).rgb;
        vec3 bottomSurfaceNormal = vec3(0.0, 1.0, 0.0);
        evaluateDirectionalLightsDirectContribution(cameraWorldPos, objectWorldPos, objectColor, bottomSurfaceNormal, bottomSurfaceNormal, viewDirWorld, viewDirWorld, vec3(0.0, 0.0, 0.0), 0.0,
        true, false, bool(IsCameraUnderwater.x > 0.0), bool(1.0 - z < 0.0001),
    waterSurfaceReflection, refractedColor);
    fragOutput.Color0 = vec4(refractedColor, 1.0);
}
#endif
#ifdef DO_WATER_SHADING_PASS
void WaterSurf(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec3 viewDirWorld = normalize(-worldSpaceViewDir(surfaceInput.worldPos));
    vec3 refractedColor = vec3_splat(0.0);
    vec3 waterSurfaceReflection = vec3_splat(0.0);
    vec3 waterSurfaceNormal = normalize(surfaceOutput.ViewSpaceNormal);
    vec3 viewUnderWaterDir = -getRefractedDir(-viewDirWorld, waterSurfaceNormal, 1.000, 1.333);
    vec4 waterSurfaceColor = textureSample(s_MatTexture, surfaceInput.UV);
    RenderChunk_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, true);
    applyPBRValuesToSurfaceOutput(surfaceInput, surfaceOutput, surfaceInput.pbrTextureId);
    vec3 waterSurfaceWorldPos = surfaceInput.worldPos;
    vec2 sceneUv = worldToUv(waterSurfaceWorldPos, ViewProj);
    vec3 objectWorldPos = getWorldPosFromDepthTexture(s_SceneDepth, sceneUv, InvView, InvProj);
    vec3 objectColor = textureSample(s_SceneColor, sceneUv).rgb;
    evaluateDirectionalLightsDirectContribution(waterSurfaceWorldPos, objectWorldPos, objectColor, waterSurfaceNormal, surfaceOutput.ViewSpaceNormal, viewDirWorld, viewUnderWaterDir, waterSurfaceColor.rgb, surfaceOutput.Roughness,
        bool(IsCameraUnderwater.x <= 0.0), true, bool(IsCameraUnderwater.x > 0.0), false,
    waterSurfaceReflection, refractedColor);
    vec3 baseWaterColor = refractedColor + waterSurfaceReflection + waterSurfaceColor.rgb * DiffuseSpecularEmissiveAmbientTermToggles.w *
    evaluateSampledAmbient(surfaceInput.lightmapUV.x, vec4(1.0, 1.0, 1.0, 1.0), BlockBaseAmbientLightColorIntensity.a, surfaceInput.lightmapUV.y, SkyAmbientLightColorIntensity, CameraLightIntensity.y, 1.0);
    float viewDistance = length(waterSurfaceWorldPos);
    vec3 ndcPos = vec3(worldToNdc(waterSurfaceWorldPos, ViewProj), 0.0);
    surfaceOutput.Albedo.xyz = evaluateAtmosphericAndVolumetricScattering(baseWaterColor, - viewDirWorld, viewDistance, ndcPos, AtmosphericScatteringToggles.x != 0.0, VolumeScatteringEnabled.x != 0.0, AtmosphericScatteringToggles.y != 0.0);
}
void WaterFinal(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    if (IsCameraUnderwater.x > 0.0) {
        fragOutput.Color0.rgb = surfaceOutput.Albedo;
    }
    else {
        fragOutput.Color0 = vec4(surfaceOutput.Albedo, 1.0);
    }
}
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #ifdef DEPTH_ONLY_PASS
    WaterSurfDepthOnly(surfaceInput, surfaceOutput);
    #endif
    #ifdef DO_WATER_SHADING_PASS
    WaterSurf(surfaceInput, surfaceOutput);
    #endif
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #ifdef DEPTH_ONLY_PASS
    StandardTemplate_FinalColorOverrideIdentity(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #ifdef DO_WATER_SHADING_PASS
    WaterFinal(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
}
#endif
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.bitangent = v_bitangent;
    #ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
    fragmentInput.color0 = v_color0;
    #endif
    #ifdef DO_WATER_SHADING_PASS
    fragmentInput.frontFacing = int(gl_FrontFacing);
    #endif
    #ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
    fragmentInput.lightmapUV = v_lightmapUV;
    #endif
    fragmentInput.normal = v_normal;
    #ifdef DO_WATER_FULL_SCREEN_DRAW_PASS
    fragmentInput.projPosition = v_projPosition;
    #endif
    #ifdef DO_WATER_SHADING_PASS
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
    #ifndef DO_WATER_FULL_SCREEN_DRAW_PASS
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    #endif
    #ifdef DEPTH_ONLY_PASS
    bgfx_FragColor = fragmentOutput.Color0;
    #endif
    #ifdef DO_WATER_FULL_SCREEN_DRAW_PASS
    WaterFullScreenFrag(fragmentInput, fragmentOutput);
    #endif
    #ifndef DEPTH_ONLY_PASS
    bgfx_FragData[0] = fragmentOutput.Color0; ;
    #endif
}

