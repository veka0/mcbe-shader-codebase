#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS
* - DEPTH_ONLY_OPAQUE_PASS
* - FORWARD_PBR_ALPHA_TEST_PASS
* - FORWARD_PBR_OPAQUE_PASS
* - FORWARD_PBR_TRANSPARENT_PASS
*
* Change_Color:
* - CHANGE_COLOR__MULTI
* - CHANGE_COLOR__OFF
* - CHANGE_COLOR__ON
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON
*/

#extension GL_EXT_texture_cube_map_array : enable
#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragData[gl_MaxDrawBuffers];
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

#ifndef DEPTH_ONLY_OPAQUE_PASS
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
#endif
#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec3 vec3_splat(float _x) {
    return vec3(_x, _x, _x);
}
vec4 vec4_splat(float _x) {
    return vec4(_x, _x, _x, _x);
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
uniform vec4 SubsurfaceUniform;
uniform vec4 DeferredWaterAndDirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex;
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
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 HudOpacity;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 IBLParameters;
uniform vec4 EmissiveUniform;
uniform vec4 FogSkyBlend;
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
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SkyHorizonColor;
uniform vec4 SubPixelOffset;
uniform vec4 SubsurfaceScatteringContributionAndFalloffScale;
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
layout(std430, binding = 2)buffer s_LightLookupArray { LightData LightLookupArray[]; };
layout(std430, binding = 3)buffer s_Lights { Light Lights[]; };
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

StandardSurfaceInput StandardTemplate_DefaultInput(FragmentInput fragInput) {
    StandardSurfaceInput result;
    result.UV = vec2(0, 0);
    result.Color = vec3(1, 1, 1);
    result.Alpha = 1.0;
    result.bitangent = fragInput.bitangent;
    result.layerUv = fragInput.layerUv;
    result.normal = fragInput.normal;
    result.prevWorldPos = fragInput.prevWorldPos;
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
#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 applyOverlayColor(vec4 diffuse, const vec4 overlayColor) {
    diffuse.rgb = mix(diffuse.rgb, overlayColor.rgb, overlayColor.a);
    return diffuse;
}
#endif
#if defined(CHANGE_COLOR__MULTI)&& ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 applyMultiColorChange(vec4 diffuse, vec3 changeColor, vec3 multiplicativeTintColor) {
    vec2 colorMask = diffuse.rg;
    diffuse.rgb = colorMask.rrr * changeColor;
    diffuse.rgb = mix(diffuse.rgb, colorMask.ggg * multiplicativeTintColor.rgb, ceil(colorMask.g));
    return diffuse;
}
#endif
#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec4 applyChangeColor(vec4 diffuse, vec4 changeColor, vec3 multiplicativeTintColor, float shouldChangeAlpha) {
    #ifdef CHANGE_COLOR__MULTI
    diffuse = applyMultiColorChange(diffuse, changeColor.rgb, multiplicativeTintColor);
    #endif
    #ifdef CHANGE_COLOR__ON
    diffuse.rgb = mix(diffuse.rgb, diffuse.rgb * changeColor.rgb, diffuse.a);
    diffuse.a *= changeColor.a;
    #endif
    diffuse.a = max(shouldChangeAlpha, diffuse.a);
    return diffuse;
}
#endif
#ifndef DEPTH_ONLY_OPAQUE_PASS
bool shouldDiscard(vec3 diffuse, float alpha, float epsilon) {
    bool result = false;
    #ifndef CHANGE_COLOR__OFF
    result = alpha < epsilon;
    #endif
    #ifdef CHANGE_COLOR__OFF
    result = alpha < 0.5;
    #endif
    return result;
}
vec4 getActorAlbedoNoColorChange(vec2 uv) {
    vec4 albedo = MatColor;
    albedo *= textureSample(s_MatTexture, uv);
    #ifdef MASKED_MULTITEXTURE__ON
    vec4 tex1 = textureSample(s_MatTexture1, uv);
    float maskedTexture = float((tex1.r + tex1.g + tex1.b) * (1.0f - tex1.a) > 0.0);
    albedo = mix(tex1, albedo, maskedTexture);
    #endif
    return albedo;
}
#endif
#if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
void SurfaceFinalColorOverrideBase(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
}
#endif
#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec3 transformCubemapDirectionForScreen(vec3 R) {
    if (abs(R.y) > abs(R.x)&& abs(R.y) > abs(R.z)) {
        R.z *= -1.0;
    }
    else {
        R.y *= -1.0;
    }
    return R;
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
float getIBLMipLevel(float linearRoughness, float numMips) {
    float x = 1.0 - linearRoughness;
    return (1.0 - (x * x)) * (numMips - 1.0);
}
vec3 evaluateIndirectSpecular(sampler2D brdfLUT, vec3 indirectLight, float linearRoughness, float nDotv, vec3 f0) {
    vec2 envDFGUV = vec2(nDotv, linearRoughness);
    vec2 envDFG = textureSample(brdfLUT, envDFGUV).rg;
    return indirectLight * (f0 * envDFG.x + envDFG.y);
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
float calculateFogIntensityFadedVanilla(float cameraDepth, float maxDistance, float fogStart, float fogEnd, float fogAlpha) {
    float distance = cameraDepth / maxDistance;
    distance += fogAlpha;
    return clamp((distance - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}
vec3 applyFogVanilla(vec3 diffuse, vec3 fogColor, float fogIntensity) {
    return mix(diffuse, fogColor, fogIntensity);
}
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

#if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
vec3 PreExposeLighting(vec3 color, float averageLuminance) {
    return color * (0.18f / averageLuminance);
}
vec3 UnExposeLighting(vec3 color, float averageLuminance) {
    return color / (0.18f / averageLuminance);
}
void ActorApplyPBR(FragmentInput fragInput, StandardSurfaceInput surfaceInput, StandardSurfaceOutput surfaceOutput, inout FragmentOutput fragOutput) {
    vec3 color = surfaceOutput.Albedo;
    if (PreExposureEnabled.x > 0.0) {
        float exposure = textureSample(s_PreviousFrameAverageLuminance, vec2(0.5, 0.5)).r;
        color = PreExposeLighting(color, exposure);
    }
    fragOutput.Color0.rgb = color;
}
#endif
struct CompositingOutput {
    vec3 mLitColor;
};

vec4 standardComposite(StandardSurfaceOutput stdOutput, CompositingOutput compositingOutput) {
    return vec4(compositingOutput.mLitColor, stdOutput.Alpha);
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
#ifdef DEPTH_ONLY_PASS
void ActorSurfAlpha(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    vec4 albedo = getActorAlbedoNoColorChange(surfaceInput.texcoord0);
    float alpha = albedo.a;
    alpha = mix(alpha, alpha * OverlayColor.a, TintedAlphaTestEnabled.x);
    if (shouldDiscard(albedo.rgb, alpha, ActorFPEpsilon.x)) {
        discard;
    }
}
#endif
#ifdef DEPTH_ONLY_OPAQUE_PASS
void ActorSurfOpaque(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
}
#endif
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
float bilinearTransmittance(vec4 samples, vec2 weights, float comparisonValue, float falloffScale) {
    vec4 transmittanceValues = 1.0 - smoothstep(0.0, 1.0, (comparisonValue - samples) * falloffScale);
    return bilinearFilter(transmittanceValues, weights);
}
bool pointInFrustum(vec4 projPos) {
    return projPos.x >= -1.0 && projPos.x <= 1.0 &&
    projPos.y >= -1.0 && projPos.y <= 1.0 &&
    projPos.z >= -1.0 && projPos.z <= 1.0;
}
int GetShadowCascade(int lightIndex, vec3 worldPos, out vec4 projPos, out mat4 invProj) {
    projPos = ((DirectionalLightSourceShadowProj0[lightIndex]) * (vec4(worldPos, 1.0)));
    if (pointInFrustum(projPos)) {
        invProj = DirectionalLightSourceShadowInvProj0[lightIndex];
        return 0;
    }
    projPos = ((DirectionalLightSourceShadowProj1[lightIndex]) * (vec4(worldPos, 1.0)));
    if (pointInFrustum(projPos)) {
        invProj = DirectionalLightSourceShadowInvProj1[lightIndex];
        return 1;
    }
    projPos = ((DirectionalLightSourceShadowProj2[lightIndex]) * (vec4(worldPos, 1.0)));
    if (pointInFrustum(projPos)) {
        invProj = DirectionalLightSourceShadowInvProj2[lightIndex];
        return 2;
    }
    projPos = ((DirectionalLightSourceShadowProj3[lightIndex]) * (vec4(worldPos, 1.0)));
    if (pointInFrustum(projPos)) {
        invProj = DirectionalLightSourceShadowInvProj3[lightIndex];
        return 3;
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
    vec4 playerProjPos = ((PlayerShadowProj) * (vec4(worldPos, 1.0)));
    float bias = ShadowBias[playerCascade] + ShadowSlopeBias[playerCascade] * clamp(tan(acos(NdL)), 0.0, 1.0);
    playerProjPos.z -= bias;
    playerProjPos.z = min(playerProjPos.z, 1.0);
    vec2 playerUv = (vec2(playerProjPos.x, playerProjPos.y) * 0.5f + 0.5f) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(2.0 * 1.0 + 0.5f), 1, MaxFilterWidth);
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
float GetFilteredShadow(int cascadeIndex, float projZ, int cascade, vec2 uv, float bias, float falloffScale, out float transmittance) {
    if (cascadeIndex < 0) {
        transmittance = 1.0;
        return 1.0;
    }
    const int MaxFilterWidth = 9;
    int filterWidth = clamp(int(ShadowPCFWidth[cascade] * 1.0 + 0.5), 1, MaxFilterWidth);
    int filterOffset = filterWidth / 2;
    float amt = 0.f;
    vec2 baseUv = uv * CascadeShadowResolutions[cascade];
    projZ = projZ * 0.5 + 0.5;
    baseUv.y += 1.0 - CascadeShadowResolutions[cascade];
    float transmittanceTotal = 0.0;
    for(int iy = 0; iy < filterWidth; ++ iy) {
        for(int ix = 0; ix < filterWidth; ++ ix) {
            float y = float(iy - filterOffset) + 0.5f;
            float x = float(ix - filterOffset) + 0.5f;
            vec2 offset = vec2(x, y) * ShadowFilterOffsetAndRangeFarAndMapSize.x;
            vec3 uvw = vec3(baseUv + (offset * CascadeShadowResolutions[cascade]), (float(cascadeIndex) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(cascade));
            vec4 shadowSamples = textureGather(s_ShadowCascades, uvw, 0);
            vec2 weights = bilinearWeights(ShadowFilterOffsetAndRangeFarAndMapSize.z, uvw.xy);
            amt += bilinearPCF(shadowSamples, weights, projZ - bias);
            transmittanceTotal += bilinearTransmittance(shadowSamples, weights, projZ, falloffScale);
        }
    }
    transmittance = transmittanceTotal / float(filterWidth * filterWidth);
    return amt / float(filterWidth * filterWidth);
}
float GetShadowAmount(int lightIndex, vec3 worldPos, float NdL, float viewDepth, float transmittanceFalloffScale, out float transmittance) {
    float amt = 1.0;
    float cloudAmt = 1.0;
    float playerAmt = 1.0;
    vec4 projPos;
    mat4 invProj;
    int cascade = GetShadowCascade(lightIndex, worldPos, projPos, invProj);
    if (cascade != -1) {
        float bias = ShadowBias[cascade] + ShadowSlopeBias[cascade] * clamp(tan(acos(NdL)), 0.0, 1.0);
        vec2 uv = vec2(projPos.x, projPos.y) * 0.5f + 0.5f;
        float shadowMapDepthRange = length(((invProj) * (vec4(0.0, 0.0, 1.0, 0.0))));
        float falloffScale = transmittanceFalloffScale * shadowMapDepthRange;
        amt = GetFilteredShadow(int(DirectionalLightSourceShadowCascadeNumber[lightIndex].x), projPos.z, cascade, uv, bias, falloffScale, transmittance);
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
vec3 calculateRf0(vec3 albedo, float metalness) {
    float reflectance = 0.5;
    float dielectricF0 = 0.16f * reflectance * reflectance * (1.0f - metalness);
    vec3 rf0 = vec3_splat(dielectricF0) + albedo * metalness;
    return rf0;
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
vec3 worldToNdc(vec3 worldPos, mat4 viewProj) {
    vec4 clipSpacePos = ((viewProj) * (vec4(worldPos, 1.0)));
    vec3 ndc = clipSpacePos.xyz / clipSpacePos.w;
    return ndc;
}
vec2 worldToUv(vec3 worldPos, mat4 viewProj) {
    vec3 ndc = worldToNdc(worldPos, viewProj);
    ndc.y *= -1.0;
    vec2 uv = 0.5 * (ndc.xy + vec2(1.0, 1.0));
    uv = (vec2((uv).x, 1.0 - (uv).y));
    return uv;
}
int getWaterDepthIndex(int cascadeNumber) {
    return cascadeNumber * int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + int(DeferredWaterAndDirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.y);
}
bool isUnderwaterAndReceivesDirectionalLight(vec3 objectWorldPos, int lightIdx, out float lightDistance) {
    mat4 surfaceViewProj = DirectionalLightSourceWaterSurfaceViewProj[lightIdx];
    mat4 invSurfaceViewProj = DirectionalLightSourceInvWaterSurfaceViewProj[lightIdx];
    int cascadeNumber = int(DirectionalLightSourceShadowCascadeNumber[lightIdx].x);
    if (cascadeNumber < 0) {
        return false;
    }
    vec3 objectPositionSunClipSpace = worldToNdc(objectWorldPos, surfaceViewProj);
    vec2 uv = worldToUv(objectWorldPos, surfaceViewProj);
    float sampledDepth = textureSample(s_ShadowCascades, vec3(uv, getWaterDepthIndex(cascadeNumber))).r;
    sampledDepth = sampledDepth * 2.0f - 1.0f;
    if (objectPositionSunClipSpace.z > sampledDepth) {
        vec4 sampledProjPos = vec4(objectPositionSunClipSpace.xy, sampledDepth, 1.0);
        vec4 sampledWaterSurfaceWorldPos = ((invSurfaceViewProj) * (sampledProjPos));
        lightDistance = length(sampledWaterSurfaceWorldPos.xyz - objectWorldPos);
        return true;
    }
    return false;
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
    vec4 surfaceProjPos = ((PointLightProj) * (vec4(surfaceViewPosition, 1.0)));
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
        vec3 lightPos = ((View) * (vec4(Lights[lightIndex].position.xyz, 1.0))).xyz;
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
void evaluateDirectionalLightsDirectContribution(inout PBRLightingContributions lightContrib, float viewDepth, vec3 n, vec3 v, vec3 color, float metalness, float linearRoughness, float subsurface, vec3 rf0, vec3 worldPosition, vec3 worldNormal, float skyAmbient, vec2 causticsMultiplier) {
    if (abs(skyAmbient) < 0.0001) {
        return;
    }
    int lightCount = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    for(int i = 0; i < lightCount; i ++ ) {
        float directOcclusion = 1.0;
        float subsurfaceTransmittance = 1.0;
        if (areCascadedShadowsEnabled(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x)) {
            vec3 sl = normalize(((View) * (DirectionalLightSourceShadowDirection[i])).xyz);
            float nDotsl = max(dot(n, sl), 0.0);
            directOcclusion = GetShadowAmount(
                i,
                worldPosition,
                nDotsl,
                viewDepth,
                SubsurfaceScatteringContributionAndFalloffScale.y,
                subsurfaceTransmittance
            );
        }
        vec3 waterTransmittance = vec3_splat(1.0);
        if (bool(DeferredWaterAndDirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.x)) {
            float lightDistance = 0.0;
            isUnderwaterAndReceivesDirectionalLight(worldPosition, i, lightDistance);
            waterTransmittance = exp(-WaterExtinctionCoefficients.rgb * lightDistance);
        }
        vec3 l = normalize(((View) * (DirectionalLightSourceWorldSpaceDirection[i])).xyz);
        vec4 colorAndIlluminance = DirectionalLightSourceDiffuseColorAndIlluminance[i];
        vec3 illuminance = colorAndIlluminance.rgb * colorAndIlluminance.a;
        vec3 diffuse = vec3_splat(0.0);
        vec3 specular = vec3_splat(0.0);
        BSDF_VanillaMinecraft(n, l, v, color, metalness, linearRoughness, subsurface, rf0, DiffuseSpecularEmissiveAmbientTermToggles.x, DiffuseSpecularEmissiveAmbientTermToggles.y, diffuse, specular);
        lightContrib.directDiffuse += diffuse * directOcclusion * illuminance * waterTransmittance * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x * causticsMultiplier[i];
        lightContrib.directSpecular += specular * directOcclusion * illuminance * waterTransmittance * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x * causticsMultiplier[i];
    }
}
vec3 evaluateIndirectLightingDiffuseContribution(vec3 albedo, float blockAmbientContribution, float skyAmbientContribution, float ambientFadeInMultiplier, vec4 ambientTint) {
    vec3 sampledAmbient = evaluateSampledAmbient(blockAmbientContribution, ambientTint, BlockBaseAmbientLightColorIntensity.a, skyAmbientContribution, SkyAmbientLightColorIntensity, CameraLightIntensity.y, ambientFadeInMultiplier);
    return albedo * sampledAmbient * DiffuseSpecularEmissiveAmbientTermToggles.w;
}
vec3 evaluateEmissiveContribution(vec3 albedo, float emissive) {
    return DiffuseSpecularEmissiveAmbientTermToggles.z * desaturate(albedo, EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y) * vec3_splat(emissive) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x;
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
bool isCloseEnoughToSeePointLightSpecular(float dist, out float percentOfSpecularFade) {
    float distPointLightSpecularFadeOut_Begin = PointLightSpecularFadeOutParameters.x;
    float distPointLightSpecularFadeOut_End = PointLightSpecularFadeOutParameters.y;
    return isCloseEnoughToSeePointLightTerm(dist, distPointLightSpecularFadeOut_Begin, distPointLightSpecularFadeOut_End, percentOfSpecularFade);
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
float calculatePointLightFadeInAmbient(float percentOfDiffuseFade, bool noDiscreteLight) {
    float ambientBlockContributionNaught = PointLightDiffuseFadeOutParameters.z;
    float ambientBlockContributionFinal = PointLightDiffuseFadeOutParameters.w;
    float fadeInAmbient = ambientBlockContributionNaught;
    fadeInAmbient += ((ambientBlockContributionFinal - ambientBlockContributionNaught) * percentOfDiffuseFade);
    if (noDiscreteLight) {
        fadeInAmbient = ambientBlockContributionFinal;
    }
    return fadeInAmbient;
}
PBRLightingContributions evaluateFragmentLighting(PBRFragmentInfo fragmentInfo) {
    PBRLightingContributions lightContrib;
    lightContrib.directDiffuse = vec3_splat(0.0);
    lightContrib.directSpecular = vec3_splat(0.0);
    lightContrib.indirectDiffuse = vec3_splat(0.0);
    lightContrib.indirectSpecular = vec3_splat(0.0);
    lightContrib.emissive = vec3_splat(0.0);
    float dist = getPointLightViewDistance(fragmentInfo.viewPosition);
    float percentOfSpecularFade = 0.0f;
    bool shouldCalculateSpecularTerm = isCloseEnoughToSeePointLightSpecular(dist, percentOfSpecularFade);
    float fadeOutSpecularMultiplier = 1.0f - percentOfSpecularFade;
    float percentOfDiffuseFade = 0.0f;
    bool shouldCalculateDiffuseTerm = isCloseEnoughToSeePointLightDiffuse(dist, percentOfDiffuseFade);
    float fadeOutDiffuseMultiplier = 1.0f - percentOfDiffuseFade;
    float viewDistance = length(fragmentInfo.viewPosition);
    vec3 viewDir = -(fragmentInfo.viewPosition / viewDistance);
    float subsurface = fragmentInfo.subsurface * SubsurfaceScatteringContributionAndFalloffScale.x;
    vec4 ambientTint = vec4(0.0, 0.0, 0.0, 1.0);
    bool noDiscreteLight = true;
    if (fragmentInfo.ndcPosition.z != 1.0) {
        evaluateDirectionalLightsDirectContribution(
            lightContrib,
            fragmentInfo.viewPosition.z,
            fragmentInfo.viewNormal,
            viewDir,
            fragmentInfo.albedo,
            fragmentInfo.metalness,
            fragmentInfo.roughness,
            subsurface,
            fragmentInfo.rf0,
            fragmentInfo.worldPosition,
            fragmentInfo.worldNormal,
            fragmentInfo.skyAmbientContribution,
        fragmentInfo.causticsMultiplier);
        DiscreteLightingContributions discreteLightContrib = evaluateDiscreteLightsDirectContribution(
            fragmentInfo.lightClusterUV, fragmentInfo.viewPosition.xyz, fragmentInfo.viewNormal, viewDir,
            fragmentInfo.albedo,
            fragmentInfo.metalness,
            fragmentInfo.roughness,
            subsurface,
            fragmentInfo.rf0,
            fragmentInfo.worldPosition,
            fragmentInfo.worldNormal,
            shouldCalculateDiffuseTerm,
            shouldCalculateSpecularTerm,
        noDiscreteLight);
        ambientTint = discreteLightContrib.ambientTint;
        lightContrib.directDiffuse += discreteLightContrib.diffuse * fadeOutDiffuseMultiplier;
        lightContrib.directSpecular += discreteLightContrib.specular * fadeOutSpecularMultiplier;
    }
    lightContrib.emissive += evaluateEmissiveContribution(fragmentInfo.albedo, fragmentInfo.emissive);
    float fadeInAmbient = calculatePointLightFadeInAmbient(percentOfDiffuseFade, noDiscreteLight);
    lightContrib.indirectDiffuse += evaluateIndirectLightingDiffuseContribution(
        (1.0 - fragmentInfo.metalness) * fragmentInfo.albedo.rgb,
        fragmentInfo.blockAmbientContribution,
        fragmentInfo.skyAmbientContribution,
        fadeInAmbient,
    ambientTint);
    return lightContrib;
}
vec4 evaluateFragmentColor(PBRFragmentInfo fragmentInfo) {
    PBRLightingContributions lightContrib = evaluateFragmentLighting(fragmentInfo);
    vec3 surfaceRadiance = lightContrib.indirectDiffuse + lightContrib.directDiffuse + lightContrib.directSpecular + lightContrib.emissive;
    float viewDistance = length(fragmentInfo.viewPosition);
    vec3 viewDirWorld = worldSpaceViewDir(fragmentInfo.worldPosition.xyz);
    vec3 outColor = evaluateAtmosphericAndVolumetricScattering(surfaceRadiance, viewDirWorld, viewDistance, fragmentInfo.ndcPosition, AtmosphericScatteringToggles.x != 0.0, VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0, AtmosphericScatteringToggles.y != 0.0);
    return vec4(outColor, 1.0);
}
float getSkyProbeVisibility(float skyAmbientContribution, float skyFadeStart, float skyFadeEnd) {
    float skyProbeVisRange = max(skyFadeStart - skyFadeEnd, 1.0);
    float skyProbeVisibility = clamp((skyAmbientContribution * 16.0f - skyFadeEnd) / skyProbeVisRange, 0.0, 1.0);
    skyProbeVisibility = pow(skyProbeVisibility, 3.0f);
    return skyProbeVisibility * IBLParameters.x;
}
vec3 getProbeLighting(highp samplerCubeArray environmentProbes, float lastProbeIdx, float skyProbeVisibility, float linearRoughness, vec3 v, vec3 n, float numMips, float blendFactor, float contribution, bool isPreExposureEnabled) {
    vec3 R = transformCubemapDirectionForScreen(reflect(v, n));
    float iblMipLevel = getIBLMipLevel(linearRoughness, numMips);
    int curr = int(lastProbeIdx);
    int prev = (curr + 3 - 1)% 3;
    vec3 preFilteredColorCurrent = textureSample(environmentProbes, vec4(R, curr), iblMipLevel).rgb;
    vec3 preFilteredColorPrevious = textureSample(environmentProbes, vec4(R, prev), iblMipLevel).rgb;
    vec3 preFilteredColor = mix(preFilteredColorPrevious, preFilteredColorCurrent, blendFactor);
    if (isPreExposureEnabled) {
        preFilteredColor = UnExposeLighting(preFilteredColor, 1.0);
    }
    return preFilteredColor * skyProbeVisibility * contribution;
}
vec3 calculateIndirectSpecularProbeOnly(PBRFragmentInfo fragmentData, sampler2D brdfLUT, highp samplerCubeArray environmentProbes, float lastProbeIdx, float numMips, float blendFactor, float skyVisibility, float contribution, bool isPreExposureEnabled) {
    float viewDistance = length(fragmentData.viewPosition);
    vec3 viewDir = -(fragmentData.viewPosition / viewDistance);
    vec3 viewDirWorld = worldSpaceViewDir(fragmentData.worldPosition.xyz);
    vec3 indirectProbeLight = getProbeLighting(
        environmentProbes,
        lastProbeIdx,
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
vec2 GenerateWave(vec2 position, vec2 direction, float frequency, float time) {
    float x = dot(direction, position) * frequency + time;
    float wave = pow((sin(x) + 1.0) / 2.0, WaterSurfaceWaveParameters.y);
    float d = (wave * cos(x)) * -1.0;
    return vec2(wave, d);
}
float fBm_ocean(vec2 position, float currentTime) {
    float currentFrequency = WaterSurfaceParameters.x;
    vec2 currentPosition = position;
    float currentSpeed = WaterSurfaceWaveParameters.x;
    float randomValue = 0.0;
    float currentWeight = 1.0;
    float totalHeight = 0.0;
    float totalWeights = 0.0;
    for(uint octave = uint(0); octave < uint(WaterSurfaceParameters.y); octave ++ ) {
        vec2 randomWaveDirection = vec2(sin(randomValue), cos(randomValue));
        vec2 wave = GenerateWave(currentPosition, randomWaveDirection, currentFrequency, currentTime * currentSpeed);
        totalHeight += wave.x * currentWeight;
        totalWeights += currentWeight;
        currentPosition += randomWaveDirection * wave.y * currentWeight * WaterSurfaceOctaveParameters.x;
        currentWeight = mix(currentWeight, 0.0, WaterSurfaceOctaveParameters.y);
        currentFrequency *= WaterSurfaceOctaveParameters.z;
        currentSpeed *= WaterSurfaceOctaveParameters.w;
        randomValue += 1.399;
    }
    return totalHeight / totalWeights;
}
float calculateCausticsMultiplier(vec3 steveSpacePosition, int lightIndex) {
    if (bool(CausticsParameters.x)) {
        vec3 worldPosition = steveSpacePosition - WorldOrigin.xyz;
        vec2 uv = worldToUv(worldPosition, DirectionalLightSourceCausticsViewProj[lightIndex]) * float(CausticsParameters.y);
        float waterDepth = 0.0f;
        bool isPointUnderWater = isUnderwaterAndReceivesDirectionalLight(steveSpacePosition, lightIndex, waterDepth);
        float outCaustics = 1.0f;
        if (bool(CausticsTextureParameters.x)&& isPointUnderWater) {
            uv = vec2(uv.x - floor(uv.x), uv.y - floor(uv.y));
            uv.y = float(CausticsTextureParameters.y) + uv.y * (float(CausticsTextureParameters.z) - float(CausticsTextureParameters.y));
            outCaustics = textureSample(s_CausticsTexture, uv).r * 2.f;
        } else if (isPointUnderWater) {
            outCaustics = fBm_ocean(uv, Time.x);
        }
        return pow(outCaustics, float(int(CausticsParameters.z))) * float(int(CausticsParameters.z) + 1);
    }
    return 1.0f;
}
void ComputePBR(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    PBRFragmentInfo fragmentData;
    vec4 viewPosition = ((View) * (((World) * (vec4(surfaceInput.worldPos, 1.0)))));
    vec4 clipPosition = ((Proj) * (viewPosition));
    vec3 ndcPosition = clipPosition.xyz / clipPosition.w;
    vec2 uv = (ndcPosition.xy + vec2(1.0, 1.0)) / 2.0;
    vec4 worldNormal = vec4(normalize(surfaceOutput.ViewSpaceNormal), 1.0);
    vec4 viewNormal = ((View) * (worldNormal));
    fragmentData.lightClusterUV = uv;
    fragmentData.worldPosition = surfaceInput.worldPos;
    fragmentData.viewPosition = viewPosition.xyz;
    fragmentData.ndcPosition = ndcPosition;
    fragmentData.worldNormal = worldNormal.xyz;
    fragmentData.viewNormal = viewNormal.xyz;
    fragmentData.albedo = surfaceOutput.Albedo;
    fragmentData.metalness = surfaceOutput.Metallic;
    fragmentData.roughness = surfaceOutput.Roughness;
    fragmentData.emissive = surfaceOutput.Emissive;
    fragmentData.subsurface = surfaceOutput.Subsurface;
    fragmentData.rf0 = calculateRf0(fragmentData.albedo, fragmentData.metalness);
    fragmentData.blockAmbientContribution = TileLightIntensity.x;
    fragmentData.skyAmbientContribution = TileLightIntensity.y;
    fragmentData.causticsMultiplier = vec2(calculateCausticsMultiplier(surfaceInput.worldPos.xyz, 0), calculateCausticsMultiplier(surfaceInput.worldPos.xyz, 1));
    float skyVisibility = getSkyProbeVisibility(
        fragmentData.skyAmbientContribution,
        IBLSkyFadeParameters.x,
        IBLSkyFadeParameters.y
    );
    vec3 colorNoIndirectSpec = evaluateFragmentColor(fragmentData).rgb;
    vec3 indirectSpecularColor = vec3_splat(0.0f);
    if (IBLParameters.x != 0.0f) {
        indirectSpecularColor = calculateIndirectSpecularProbeOnly(
            fragmentData,
            s_BrdfLUT,
            s_SpecularIBLRecords,
            LastSpecularIBLIdx.x,
            IBLParameters.y,
            IBLParameters.w,
            skyVisibility,
            IBLParameters.z,
        PreExposureEnabled.x > 0.0f);
        float viewDistance = length(fragmentData.viewPosition);
        vec3 viewDirWorld = worldSpaceViewDir(fragmentData.worldPosition.xyz);
        indirectSpecularColor = evaluateAtmosphericAndVolumetricScatteringFogIntensityOnly(indirectSpecularColor, viewDirWorld, viewDistance, ndcPosition, AtmosphericScatteringToggles.x != 0.0, VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0, AtmosphericScatteringToggles.y != 0.0);
    }
    surfaceOutput.Albedo = colorNoIndirectSpec.rgb + indirectSpecularColor;
}

const int kInvalidPBRTextureHandle = 0xffff;
const int kPBRTextureDataFlagHasMaterialTexture = (1 << 0);
const int kPBRTextureDataFlagHasSubsurfaceChannel = (1 << 1);
const int kPBRTextureDataFlagHasNormalTexture = (1 << 2);
const int kPBRTextureDataFlagHasHeightMapTexture = (1 << 3);
vec4 applyActorDiffusePBR(vec4 albedo, vec3 color) {
    albedo.rgb *= mix(vec3(1, 1, 1), color, ColorBased.x);
    albedo = applyOverlayColor(albedo, OverlayColor);
    return albedo;
}
vec4 glintBlend(const vec4 dest, const vec4 source) {
    return vec4(source.rgb * source.rgb, abs(source.a)) + vec4(dest.rgb, 0.0);
}
vec4 applyGlint(const vec4 diffuse, const vec4 layerUV, const sampler2D glintTexture, const vec4 glintColor, const vec4 tileLightColor) {
    vec4 tex1 = textureSample(glintTexture, fract(layerUV.xy)).rgbr * glintColor;
    vec4 tex2 = textureSample(glintTexture, fract(layerUV.zw)).rgbr * glintColor;
    vec4 glint = (tex1 + tex2) * tileLightColor;
    glint = glintBlend(diffuse, glint);
    glint.a = diffuse.a;
    return glint;
}
vec4 applyActorGlintDiffusePBR(StandardSurfaceInput surfaceInput, vec4 albedo) {
    vec4 diffuse = applyActorDiffusePBR(albedo, surfaceInput.Color);
    diffuse = applyGlint(diffuse, surfaceInput.layerUv, s_MatTexture1, GlintColor, TileLightColor);
    return diffuse;
}
void ActorGlint_getPBRSurfaceOutputValues(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput, bool isAlphaTest) {
    vec4 albedo = getActorAlbedoNoColorChange(surfaceInput.UV);
    if (isAlphaTest && shouldDiscard(albedo.rgb, albedo.a, ActorFPEpsilon.x)) {
        discard;
    }
    albedo = applyChangeColor(albedo, ChangeColor, MultiplicativeTintColor.rgb, 0.0);
    vec4 diffuse = applyActorGlintDiffusePBR(surfaceInput, albedo);
    surfaceOutput.Albedo = diffuse.rgb;
    surfaceOutput.Alpha = diffuse.a;
    surfaceOutput.Roughness = 0.5;
    surfaceOutput.Metallic = 0.0;
    surfaceOutput.Emissive = 0.0;
    surfaceOutput.Subsurface = 0.0;
    surfaceOutput.ViewSpaceNormal = surfaceInput.normal;
}
#endif
#ifdef FORWARD_PBR_ALPHA_TEST_PASS
void ActorGlintSurfAlphaTest(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    ActorGlint_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, true);
    ComputePBR(surfaceInput, surfaceOutput);
}
#endif
#ifdef FORWARD_PBR_OPAQUE_PASS
void ActorGlintSurfOpaque(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    ActorGlint_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, false);
    ComputePBR(surfaceInput, surfaceOutput);
}
#endif
#ifdef FORWARD_PBR_TRANSPARENT_PASS
void ActorGlintSurfTransparent(in StandardSurfaceInput surfaceInput, inout StandardSurfaceOutput surfaceOutput) {
    ActorGlint_getPBRSurfaceOutputValues(surfaceInput, surfaceOutput, false);
    ComputePBR(surfaceInput, surfaceOutput);
}
#endif
void StandardTemplate_Opaque_Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    StandardSurfaceInput surfaceInput = StandardTemplate_DefaultInput(fragInput);
    StandardSurfaceOutput surfaceOutput = StandardTemplate_DefaultOutput();
    surfaceInput.UV = fragInput.texcoord0;
    surfaceInput.Color = fragInput.color0.xyz;
    surfaceInput.Alpha = fragInput.color0.a;
    #ifdef DEPTH_ONLY_PASS
    ActorSurfAlpha(surfaceInput, surfaceOutput);
    #endif
    #ifdef DEPTH_ONLY_OPAQUE_PASS
    ActorSurfOpaque(surfaceInput, surfaceOutput);
    #endif
    #ifdef FORWARD_PBR_ALPHA_TEST_PASS
    ActorGlintSurfAlphaTest(surfaceInput, surfaceOutput);
    #endif
    #ifdef FORWARD_PBR_OPAQUE_PASS
    ActorGlintSurfOpaque(surfaceInput, surfaceOutput);
    #endif
    #ifdef FORWARD_PBR_TRANSPARENT_PASS
    ActorGlintSurfTransparent(surfaceInput, surfaceOutput);
    #endif
    StandardTemplate_CustomSurfaceShaderEntryIdentity(surfaceInput.UV, fragInput.worldPos, surfaceOutput);
    DirectionalLight primaryLight;
    vec3 worldLightDirection = LightWorldSpaceDirection.xyz;
    primaryLight.ViewSpaceDirection = ((View) * (vec4(worldLightDirection, 0))).xyz;
    primaryLight.Intensity = LightDiffuseColorAndIlluminance.rgb * LightDiffuseColorAndIlluminance.w;
    CompositingOutput compositingOutput;
    compositingOutput.mLitColor = computeLighting_Unlit(fragInput, surfaceInput, surfaceOutput, primaryLight);
    fragOutput.Color0 = standardComposite(surfaceOutput, compositingOutput);
    #if defined(DEPTH_ONLY_OPAQUE_PASS)|| defined(DEPTH_ONLY_PASS)
    SurfaceFinalColorOverrideBase(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
    #if ! defined(DEPTH_ONLY_OPAQUE_PASS)&& ! defined(DEPTH_ONLY_PASS)
    ActorApplyPBR(fragInput, surfaceInput, surfaceOutput, fragOutput);
    #endif
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.bitangent = v_bitangent;
    fragmentInput.color0 = v_color0;
    fragmentInput.layerUv = v_layerUv;
    fragmentInput.normal = v_normal;
    fragmentInput.prevWorldPos = v_prevWorldPos;
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
    StandardTemplate_Opaque_Frag(fragmentInput, fragmentOutput);
    bgfx_FragData[0] = fragmentOutput.Color0; ;
}

