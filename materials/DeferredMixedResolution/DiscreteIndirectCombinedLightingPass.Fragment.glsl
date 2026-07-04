#version 310 es

/*
* Available Macros:
*
* Passes:
* - CAUSTICS_MULTIPLIER_PASS (not used)
* - DIRECTIONAL_LIGHTING_PASS (not used)
* - DISCRETE_INDIRECT_COMBINED_LIGHTING_PASS (not used)
* - FALLBACK_PASS (not used)
* - SURFACE_RADIANCE_UPSCALE_PASS (not used)
*
* GPUBlockLighting:
* - GPU_BLOCK_LIGHTING__OFF
* - GPU_BLOCK_LIGHTING__ON
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF
* - POINT_LIGHT_SHADING__ON
*
* Upscaling:
* - UPSCALING__OFF (not used)
* - UPSCALING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_CausticsMultiplier;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_DiffuseLighting;
* - uniform lowp usampler2D s_EmissiveAmbientLinearRoughness;
* - layout(binding = 14, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_NormalsAndDepthLighting;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform lowp sampler2D s_SpecularLighting;
* - layout(binding = 15, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
* - layout(binding = 16, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 17, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraAmbientContribution;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 CascadesParameters[8];
* - uniform vec4 CascadesPerSet;
* - uniform mat4 CascadesShadowInvProj[8];
* - uniform mat4 CascadesShadowProj[8];
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 CloudShadowsVisible;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 DownsampleResolutionAndRecipResolution;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 LightingUpscaleParams;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform vec4 PointLightPreCalcValues;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowAtlasResolution;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SceneResolutionAndRecipResolution;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkySamplesConfig;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 Time;
* - uniform vec4 UndergroundFogColor;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterAlbedoExtinction;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WaterSurfaceEnabledAndExtinctionDistShift;
* - uniform vec4 WaterSurfaceOctaveParameters;
* - uniform vec4 WaterSurfaceParameters;
* - uniform vec4 WaterSurfaceWaveParameters;
* - uniform vec4 WorldOrigin;
*/

precision mediump float;
precision highp int;
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
struct Light {
    highp vec4 position;
    highp vec4 color;
    highp vec4 shadowFaceUV0;
    highp vec4 shadowFaceUV1;
    highp vec4 shadowFaceUV2;
    highp vec4 shadowFaceUV3;
    highp vec4 shadowFaceUV4;
    highp vec4 shadowFaceUV5;
};
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
struct VoxelNode {
    uint data;
};
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)

#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
struct LightData {
    highp float lookup;
};
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
const int var_7138c[64] = int[](-1, 2, 3, -1, 0, 6, 7, -1, 1, 10, 11, -1, -1, -1, -1, -1, 4, 14, 16, -1, 8, 18, 20, -1, 12, 22, 24, -1, -1, -1, -1, -1, 5, 15, 17, -1, 9, 19, 21, -1, 13, 23, 25, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
struct GpuVolumeEntry {
    int packed_xy;
    int packed_zw;
    int hash;
    int user_data;
};
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)

#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
const uvec3 var_e4221[8] = uvec3[](uvec3(0u, 0u, 1u), uvec3(0u, 0u, 1u), uvec3(0u, 1u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u), uvec3(1u, 0u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u));
const uvec3 var_a8b51[8] = uvec3[](uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(0u, 1u, 1u), uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 1u, 0u), uvec3(1u, 1u, 0u));
struct Light {
    highp vec4 position;
    highp vec4 color;
    highp vec4 shadowFaceUV0;
    highp vec4 shadowFaceUV1;
    highp vec4 shadowFaceUV2;
    highp vec4 shadowFaceUV3;
    highp vec4 shadowFaceUV4;
    highp vec4 shadowFaceUV5;
};

struct LightData {
    highp float lookup;
};

#endif
#ifdef POINT_LIGHT_SHADING__ON
int var_e7b23;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
layout(binding = 15, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_17e55;
layout(binding = 14, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_98704;
#endif
#ifdef POINT_LIGHT_SHADING__ON
layout(binding = 17, std430) buffer s_zLights { Light zLights[]; } var_4d0cf;
layout(binding = 16, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_4f100;
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
const uvec3 var_e4221[8] = uvec3[](uvec3(0u, 0u, 1u), uvec3(0u, 0u, 1u), uvec3(0u, 1u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u), uvec3(1u, 0u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u));
const uvec3 var_a8b51[8] = uvec3[](uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(0u, 1u, 1u), uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 1u, 0u), uvec3(1u, 1u, 0u));
layout(binding = 15, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_17e55;
layout(binding = 14, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_98704;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
#endif
#ifdef POINT_LIGHT_SHADING__ON
uniform highp mat4 u_view;
#endif
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_Normal;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp sampler2D s_PointLightShadowTextureAtlas;
#endif
uniform highp sampler2D s_SceneDepth;
uniform highp usampler2D s_EmissiveAmbientLinearRoughness;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ClusterDepthBounds;
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
#endif
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
#endif
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
uniform highp vec4 GpuEntryBufferCapacity;
#endif
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightNdLFloor;
uniform highp vec4 PointLightPreCalcValues;
uniform highp vec4 PointLightShadowAtlasResolution;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
uniform highp vec4 GpuEntryBufferCapacity;
#endif
uniform highp vec4 SceneResolutionAndRecipResolution;
uniform highp vec4 SkyAmbientLightColorIntensity;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 SubPixelOffset;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
uniform highp vec4 WorldOrigin;
#endif
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
#ifdef POINT_LIGHT_SHADING__ON
void func_9b87e(inout highp vec3 arg_3007f, inout highp vec3 arg_87bd1) {
    if (ColorGrading_OptimizeGammaCorrection.x != 0.0)
    {
        arg_3007f = pow(max(arg_87bd1, vec3(0.0)), vec3(2.2000000476837158203125));
        return;
    }
    else
    {
        highp vec3 loc_407b7 = arg_87bd1;
        highp vec3 loc_67ff9 = arg_87bd1 * vec3(0.077399380505084991455078125);
        highp vec3 loc_b63b1 = pow((arg_87bd1 + vec3(0.054999999701976776123046875)) * vec3(0.947867333889007568359375), vec3(2.400000095367431640625));
        highp float loc_e81ff;
        if (loc_407b7.x <= 0.040449999272823333740234375)
        {
            loc_e81ff = loc_67ff9.x;
        }
        else
        {
            loc_e81ff = loc_b63b1.x;
        }
        loc_407b7.x = loc_e81ff;
        highp float loc_007b0;
        if (loc_407b7.y <= 0.040449999272823333740234375)
        {
            loc_007b0 = loc_67ff9.y;
        }
        else
        {
            loc_007b0 = loc_b63b1.y;
        }
        loc_407b7.y = loc_007b0;
        highp float loc_fa4a6;
        if (loc_407b7.z <= 0.040449999272823333740234375)
        {
            loc_fa4a6 = loc_67ff9.z;
        }
        else
        {
            loc_fa4a6 = loc_b63b1.z;
        }
        loc_407b7.z = loc_fa4a6;
        arg_3007f = loc_407b7;
        return;
    }
}
void func_06412(inout highp vec3 arg_8d32a, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp vec3 loc_f1110 = arg_8d32a;
    highp vec3 loc_75f4e = ClusterDimensions.xyz;
    highp vec2 loc_7c1c9 = ClusterDepthBounds.xy;
    highp vec4 loc_c5992 = PointLightPreCalcValues;
    highp float loc_ac0eb = -loc_f1110.z;
    highp float loc_9e40d = loc_ac0eb * ClusterDepthBounds.z;
    highp float loc_fbce7 = loc_9e40d * ClusterDepthBounds.w;
    highp float loc_bee80;
    if (loc_ac0eb < loc_7c1c9.x)
    {
        loc_bee80 = 0.0;
    }
    else
    {
        highp float loc_a71e8;
        if (loc_ac0eb < loc_7c1c9.y)
        {
            loc_a71e8 = 1.0;
        }
        else
        {
            loc_a71e8 = min(floor(clamp((log2(loc_ac0eb) - loc_c5992.z) * loc_c5992.x, 0.0, 1.0) * (loc_75f4e.z - 2.0)) + 2.0, loc_75f4e.z - 1.0);
        }
        loc_bee80 = loc_a71e8;
    }
    highp vec3 loc_05e3f = vec3(min(floor(clamp((loc_f1110.x + loc_fbce7) / (2.0 * loc_fbce7), 0.0, 1.0) * loc_75f4e.x), loc_75f4e.x - 1.0), min(floor(clamp((loc_f1110.y + loc_9e40d) / (2.0 * loc_9e40d), 0.0, 1.0) * loc_75f4e.y), loc_75f4e.y - 1.0), loc_bee80);
    bool loc_ce27d = loc_05e3f.x < 0.0;
    bool loc_f15a5;
    if (!loc_ce27d)
    {
        loc_f15a5 = loc_05e3f.y < 0.0;
    }
    else
    {
        loc_f15a5 = loc_ce27d;
    }
    bool loc_7bab6;
    if (!loc_f15a5)
    {
        loc_7bab6 = loc_05e3f.z < 0.0;
    }
    else
    {
        loc_7bab6 = loc_f15a5;
    }
    bool loc_a526b;
    if (!loc_7bab6)
    {
        loc_a526b = loc_05e3f.x >= ClusterDimensions.x;
    }
    else
    {
        loc_a526b = loc_7bab6;
    }
    bool loc_6d7c9;
    if (!loc_a526b)
    {
        loc_6d7c9 = loc_05e3f.y >= ClusterDimensions.y;
    }
    else
    {
        loc_6d7c9 = loc_a526b;
    }
    bool loc_fc058;
    if (!loc_6d7c9)
    {
        loc_fc058 = loc_05e3f.z >= ClusterDimensions.z;
    }
    else
    {
        loc_fc058 = loc_6d7c9;
    }
    if (loc_fc058)
    {
        arg_e45b8 = var_e7b23;
        arg_fadf1 = var_e7b23;
        arg_d7f4c = false;
        return;
    }
    int loc_14533 = int((loc_05e3f.x + (loc_05e3f.y * ClusterDimensions.x)) + ((loc_05e3f.z * ClusterDimensions.x) * ClusterDimensions.y)) * int(ClusterDimensions.w);
    arg_e45b8 = loc_14533 + int(ClusterDimensions.w);
    arg_fadf1 = loc_14533;
    arg_d7f4c = true;
}
void func_be31c(inout int arg_7070b, inout highp float arg_43b7a, inout highp float arg_9499a, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c, inout highp float arg_77c90) {
    if (arg_7070b < 0)
    {
        arg_43b7a = 1.0;
        arg_9499a = 0.0;
        return;
    }
    highp vec3 loc_8868e = arg_aee55 - var_4d0cf.zLights[arg_7070b].position.xyz;
    highp vec3 loc_8a9f7 = loc_8868e;
    highp vec3 loc_7c88a = abs(loc_8868e);
    bool loc_ab77c = loc_7c88a.x >= loc_7c88a.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_7c88a.x >= loc_7c88a.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    int loc_f3fad;
    if (loc_ca7f9)
    {
        loc_f3fad = (loc_8a9f7.x >= 0.0) ? 0 : 1;
    }
    else
    {
        int loc_1358b;
        if (loc_7c88a.y >= loc_7c88a.z)
        {
            loc_1358b = (loc_8a9f7.y >= 0.0) ? 2 : 3;
        }
        else
        {
            loc_1358b = (loc_8a9f7.z >= 0.0) ? 4 : 5;
        }
        loc_f3fad = loc_1358b;
    }
    highp vec4 loc_cc567 = var_4d0cf.zLights[arg_7070b].shadowFaceUV0;
    highp vec3 loc_baa89;
    if (loc_f3fad == 1)
    {
        loc_cc567 = var_4d0cf.zLights[arg_7070b].shadowFaceUV1;
        loc_baa89 = vec3(-loc_8a9f7.z, loc_8a9f7.y, loc_8a9f7.x);
    }
    else
    {
        highp vec3 loc_a4212;
        if (loc_f3fad == 2)
        {
            loc_cc567 = var_4d0cf.zLights[arg_7070b].shadowFaceUV2;
            loc_a4212 = vec3(-loc_8a9f7.x, -loc_8a9f7.z, -loc_8a9f7.y);
        }
        else
        {
            highp vec3 loc_38505;
            if (loc_f3fad == 3)
            {
                loc_cc567 = var_4d0cf.zLights[arg_7070b].shadowFaceUV3;
                loc_38505 = vec3(-loc_8a9f7.x, loc_8a9f7.z, loc_8a9f7.y);
            }
            else
            {
                highp vec3 loc_fd3cf;
                if (loc_f3fad == 4)
                {
                    loc_cc567 = var_4d0cf.zLights[arg_7070b].shadowFaceUV4;
                    loc_fd3cf = vec3(-loc_8a9f7.x, loc_8a9f7.y, -loc_8a9f7.z);
                }
                else
                {
                    highp vec3 loc_0c356;
                    if (loc_f3fad == 5)
                    {
                        loc_cc567 = var_4d0cf.zLights[arg_7070b].shadowFaceUV5;
                        loc_0c356 = vec3(loc_8a9f7.x, loc_8a9f7.y, loc_8a9f7.z);
                    }
                    else
                    {
                        loc_0c356 = vec3(loc_8a9f7.z, loc_8a9f7.y, -loc_8a9f7.x);
                    }
                    loc_fd3cf = loc_0c356;
                }
                loc_38505 = loc_fd3cf;
            }
            loc_a4212 = loc_38505;
        }
        loc_baa89 = loc_a4212;
    }
    bool loc_da9b7 = loc_cc567.z == 0.0;
    bool loc_20dc6;
    if (loc_da9b7)
    {
        loc_20dc6 = loc_cc567.w == 0.0;
    }
    else
    {
        loc_20dc6 = loc_da9b7;
    }
    if (loc_20dc6)
    {
        arg_43b7a = 1.0;
        arg_9499a = 0.0;
        return;
    }
    highp vec4 loc_c8835 = PointLightProj * vec4(loc_baa89, 1.0);
    highp float loc_2f407 = clamp(dot(normalize(-loc_8868e), normalize(arg_1111c)), PointLightNdLFloor.x, 1.0);
    loc_c8835.z -= (PointLightShadowParams1.x + (PointLightShadowParams1.y * (sqrt(1.0 - (loc_2f407 * loc_2f407)) / loc_2f407)));
    highp float loc_d799e = loc_c8835.w;
    highp vec4 loc_9858b = loc_c8835;
    highp vec4 loc_f9e0d = loc_9858b / vec4(loc_d799e);
    loc_c8835 = loc_f9e0d;
    highp vec2 loc_3b25d = vec2(0.5) / PointLightShadowAtlasResolution.xy;
    highp float loc_772b7 = (textureLod(s_PointLightShadowTextureAtlas, clamp(loc_cc567.xy + (((loc_f9e0d.xy * 0.5) + vec2(0.5)) * (loc_cc567.zw - loc_cc567.xy)), loc_cc567.xy + loc_3b25d, loc_cc567.zw - loc_3b25d), 0.0).x * 2.0) - 1.0;
    highp float loc_591c8;
    if (loc_772b7 >= loc_c8835.z)
    {
        loc_591c8 = 1.0;
    }
    else
    {
        loc_591c8 = 0.0;
    }
    highp float loc_d7fd8;
    if (arg_77c90 > 0.0)
    {
        highp vec4 loc_932a9 = PointLightInvProj * vec4(loc_c8835.xy, loc_772b7, 1.0);
        highp vec4 loc_85f94 = loc_932a9;
        highp float loc_0585d = loc_85f94.w;
        highp vec3 loc_6d5dc = loc_932a9.xyz / vec3(loc_0585d);
        loc_85f94 = vec4(loc_6d5dc.x, loc_6d5dc.y, loc_6d5dc.z, loc_932a9.w);
        loc_d7fd8 = 1.0 - smoothstep(0.0, 1.0, (length(loc_baa89) - length(loc_6d5dc.xyz)) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z);
    }
    else
    {
        loc_d7fd8 = 1.0;
    }
    arg_43b7a = loc_d7fd8;
    arg_9499a = loc_591c8;
}
void func_b155c(inout highp vec4 arg_e84ec, inout int arg_0b9bc, inout highp float arg_43b7a, inout highp float arg_7f337, inout highp vec3 arg_0a2b9, inout highp vec3 arg_29ac4, inout highp vec3 arg_f6a53, inout highp vec3 arg_4f9dc, inout highp float arg_8bccf) {
    arg_e84ec = vec4(0.0);
    if (arg_0b9bc < 0)
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp vec3 loc_8dfd7 = var_4d0cf.zLights[arg_0b9bc].position.xyz - arg_29ac4;
    highp vec3 loc_8cb9b = loc_8dfd7;
    highp float loc_9eb1a;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_9eb1a = loc_1829d * loc_1829d;
    }
    else
    {
        loc_9eb1a = dot(loc_8dfd7, loc_8dfd7);
    }
    if (loc_9eb1a >= (var_4d0cf.zLights[arg_0b9bc].position.w * var_4d0cf.zLights[arg_0b9bc].position.w))
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp float loc_cddfe;
    highp float loc_a011d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_412fd;
        highp float loc_b2a04;
        func_be31c(arg_0b9bc, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_a011d = loc_b2a04;
        loc_cddfe = loc_412fd;
    }
    else
    {
        loc_a011d = 1.0;
        loc_cddfe = 1.0;
    }
    highp float loc_4c5a5 = loc_9eb1a / ((var_4d0cf.zLights[arg_0b9bc].position.w * var_4d0cf.zLights[arg_0b9bc].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_ef515 = clamp(1.0 - (loc_4c5a5 * loc_4c5a5), 0.0, 1.0);
    highp float loc_5f09f = (1.0 / max(loc_9eb1a, 0.100000001490116119384765625)) * (loc_ef515 * loc_ef515);
    highp float loc_219c5;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_219c5 = loc_5f09f * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_5f09f) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_219c5 = loc_5f09f;
    }
    if (loc_cddfe > 0.0)
    {
        highp vec3 loc_8226d = var_4d0cf.zLights[arg_0b9bc].color.xyz * loc_219c5;
        arg_e84ec = vec4(loc_8226d.x, loc_8226d.y, loc_8226d.z, arg_e84ec.w);
        arg_e84ec.w = 1.0 - (loc_9eb1a / ((var_4d0cf.zLights[arg_0b9bc].position.w * var_4d0cf.zLights[arg_0b9bc].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_0a2b9 = (var_4d0cf.zLights[arg_0b9bc].color.xyz * var_4d0cf.zLights[arg_0b9bc].color.w) * loc_219c5;
}
void func_26bee(inout highp vec3 arg_33c3b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec4 arg_fadf1, inout highp vec3 arg_efe4b, inout highp vec3 arg_81f79, inout highp vec2 arg_92c2f, inout highp vec3 arg_58ffc, inout highp float arg_d96ac, inout highp vec3 arg_e6b36, inout highp vec3 arg_b8e73, inout highp vec3 arg_775e2, inout highp float arg_bfa42) {
    highp vec4 loc_a468d = vec4(0.0);
    bool loc_a0bb1;
    int loc_490eb;
    int loc_c476d;
    func_06412(arg_33c3b, loc_c476d, loc_490eb, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        arg_fadf1 = loc_a468d;
        return;
    }
    highp float loc_a55d6;
    highp vec3 loc_45a05;
    highp vec3 loc_b9311;
    loc_b9311 = vec3(0.0);
    loc_45a05 = vec3(0.0);
    loc_a55d6 = 0.0;
    highp float loc_96e3a;
    highp vec3 loc_50935;
    highp vec3 loc_bfd6d;
    highp vec4 loc_2348f;
    for (int loc_86630 = loc_490eb; loc_86630 < loc_c476d; loc_b9311 = loc_bfd6d, loc_45a05 = loc_50935, loc_a55d6 = loc_96e3a, loc_86630++)
    {
        int loc_dbe64 = int(var_4f100.zLightLookupArray[loc_86630].lookup);
        if (loc_dbe64 < 0)
        {
            break;
        }
        highp vec3 loc_ed90f = normalize((u_view * vec4(var_4d0cf.zLights[loc_dbe64].position.xyz, 1.0)).xyz - arg_33c3b);
        highp float loc_1e1bf = max(dot(arg_efe4b, loc_ed90f), 0.0);
        highp float loc_af6fd = max(dot(arg_efe4b, arg_81f79), 0.0);
        highp float loc_2d61b = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp float loc_c20a0 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp vec3 loc_a125f = normalize(loc_ed90f + arg_81f79);
        highp float loc_69c3d = max(arg_92c2f.x, 0.0500000007450580596923828125);
        highp float loc_a68f1 = loc_69c3d * loc_69c3d;
        highp float loc_ad517 = loc_a68f1 * loc_a68f1;
        highp float loc_cd10e = max(dot(arg_efe4b, loc_a125f), 0.0);
        highp float loc_6be3a = (((loc_ad517 - 1.0) * loc_cd10e) * loc_cd10e) + 1.0;
        highp float loc_ad7fb = loc_a68f1 * 0.5;
        highp float loc_00ee9 = clamp(1.0 - max(dot(arg_81f79, loc_a125f), 0.0), 0.0, 1.0);
        highp float loc_a177b = loc_00ee9 * loc_00ee9;
        highp vec3 loc_d5257 = arg_58ffc + ((vec3(1.0) - arg_58ffc) * ((loc_a177b * loc_a177b) * loc_00ee9));
        highp vec3 loc_ec1c7 = vec3(1.0) * (1.0 - arg_d96ac);
        highp vec4 loc_55c3a = vec4(0.0);
        highp vec3 loc_49548;
        highp float loc_bbe0d;
        highp float loc_0721a;
        func_b155c(loc_2348f, loc_dbe64, loc_0721a, loc_bbe0d, loc_49548, arg_e6b36, arg_b8e73, arg_775e2, arg_bfa42);
        loc_55c3a = loc_2348f;
        highp vec3 loc_ef49b = loc_a468d.xyz + loc_2348f.xyz;
        loc_a468d = vec4(loc_ef49b.x, loc_ef49b.y, loc_ef49b.z, loc_a468d.w);
        loc_96e3a = loc_a55d6 + loc_55c3a.w;
        loc_50935 = loc_45a05 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_bfa42)) * (loc_ec1c7 * vec3(0.3183098733425140380859375))) * loc_bbe0d) + (((loc_ec1c7 * vec3(0.3183098733425140380859375)) * (arg_bfa42 * max((dot(-arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_0721a)) * loc_49548) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_bfd6d = loc_b9311 + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_bbe0d) * loc_49548) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    if (loc_a55d6 > 9.9999997473787516355514526367188e-05)
    {
        highp vec3 loc_70b77 = loc_a468d.xyz / vec3(loc_a55d6);
        loc_a468d = vec4(loc_70b77.x, loc_70b77.y, loc_70b77.z, loc_a468d.w);
        loc_a468d.w = clamp(loc_a55d6, 0.0, 1.0);
    }
    arg_534d1 = loc_45a05;
    arg_90b60 = loc_b9311;
    arg_fadf1 = loc_a468d;
}
void func_4f458(inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec4 arg_d4ca2, inout highp vec3 arg_229fe, inout highp vec3 arg_29328, inout highp vec3 arg_c3199, inout highp vec3 arg_68647, inout highp vec3 arg_6f73b, inout highp vec3 arg_56f56, inout highp vec3 arg_9c753, inout highp vec2 arg_a995c, inout highp vec3 arg_7e9dc, inout highp float arg_4e72a, inout highp vec3 arg_602b8, inout highp float arg_15153) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0))
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        arg_d4ca2 = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    highp vec3 loc_62dd1;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_62dd1 = (arg_229fe + (arg_29328 - (arg_c3199 * dot(arg_29328, arg_c3199)))) + WorldOrigin.xyz;
    }
    else
    {
        loc_62dd1 = arg_68647;
    }
    highp vec4 loc_750c4;
    highp vec3 loc_46c24;
    highp vec3 loc_5ded5;
    func_26bee(arg_6f73b, loc_5ded5, loc_46c24, loc_750c4, arg_56f56, arg_9c753, arg_a995c, arg_7e9dc, arg_4e72a, arg_68647, loc_62dd1, arg_602b8, arg_15153);
    arg_534d1 = loc_5ded5;
    arg_90b60 = loc_46c24;
    arg_d4ca2 = loc_750c4;
}
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
void func_33953(inout uint arg_a601e, inout highp vec3 arg_aa7d7) {
    if (var_17e55.VoxelBuffer[arg_a601e].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_11fc1 = vec4(uvec4(var_17e55.VoxelBuffer[arg_a601e].data, var_17e55.VoxelBuffer[arg_a601e].data >> 8u, var_17e55.VoxelBuffer[arg_a601e].data >> 16u, var_17e55.VoxelBuffer[arg_a601e].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_11fc1;
    arg_aa7d7 = (loc_11fc1.xyz * loc_3ff2a.w) * 6.0;
}
void func_593c8(inout highp vec3 arg_ca7c6, inout highp vec3 arg_951a8, inout uint arg_2632b, inout highp vec3 arg_e5233) {
    highp vec3 loc_1815d = arg_ca7c6 - arg_951a8;
    int loc_fa0d5 = ((((int(loc_1815d.x < 0.0) | (int(loc_1815d.x >= 16.0) << 1)) | (int(loc_1815d.y < 0.0) << 2)) | (int(loc_1815d.y >= 16.0) << 3)) | (int(loc_1815d.z < 0.0) << 4)) | (int(loc_1815d.z >= 16.0) << 5);
    uint loc_58bb3;
    if (var_7138c[loc_fa0d5] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_ca7c6 - arg_951a8) & uvec3(15u);
        loc_58bb3 = arg_2632b + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        if (!((var_17e55.VoxelBuffer[arg_2632b + 4096u].data & (1u << uint(var_7138c[loc_fa0d5]))) != 0u))
        {
            arg_e5233 = vec3(0.0);
            return;
        }
        uvec3 loc_441ec = uvec3(arg_ca7c6 - (floor(arg_ca7c6 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_17e55.VoxelBuffer[(arg_2632b + 4097u) + uint(var_7138c[loc_fa0d5])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    highp vec3 loc_5d636;
    func_33953(loc_58bb3, loc_5d636);
    arg_e5233 = loc_5d636;
}
#endif
void main() {
    highp vec2 var_879a5 = (floor(v_texcoord0.xy * SceneResolutionAndRecipResolution.xy) + vec2(0.5)) * SceneResolutionAndRecipResolution.zw;
    highp vec2 var_1fa6b = var_879a5.xy;
    var_1fa6b = vec2(var_1fa6b.x, 1.0 - var_1fa6b.y);
    highp float var_c2b62 = var_1fa6b.x;
    highp float var_ace1a = var_1fa6b.y;
    highp vec2 var_07058 = vec2(var_c2b62, 1.0 - var_ace1a);
    var_1fa6b = var_07058;
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    highp vec2 var_8c702 = (var_07058 * 2.0) - vec2(1.0);
#endif
    highp vec4 var_39d8d = texture(s_Normal, var_879a5.xy);
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec2 var_9279d = var_879a5.xy;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    highp vec2 var_9b1e9 = var_39d8d.xy;
    highp vec2 var_9279d = var_879a5.xy;
#endif
    highp vec4 var_e1c59 = texture(s_SceneDepth, var_879a5.xy);
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    highp float var_21ef4 = (var_e1c59.x * 2.0) - 1.0;
    highp vec4 var_19bd5 = vec4(var_8c702, var_21ef4, 1.0);
    highp mat4 var_4fa47 = u_invProj;
    highp mat4 var_498b7 = u_invProj;
    highp mat4 var_4882d = u_invProj;
    highp mat4 var_78c1b = u_invProj;
    highp mat4 var_40575 = u_invProj;
    highp float var_eb413 = var_19bd5.x;
    highp float var_ac116 = var_19bd5.y;
    highp float var_f2b7c = var_19bd5.w;
    highp float var_0357c = var_19bd5.z;
    highp float var_2c821 = var_19bd5.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_4fa47[0].x, var_ac116 * var_498b7[1].y, var_f2b7c * var_4882d[3].z, (var_0357c * var_78c1b[2].w) + (var_2c821 * var_40575[3].w));
    var_19bd5 = var_9666f;
    highp float var_d799e = var_19bd5.w;
    highp vec4 var_cee63 = var_9666f / vec4(var_d799e);
    var_19bd5 = var_cee63;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_2bcb3 = vec4(var_8c702.xy + vec2(SubPixelOffset.x, -SubPixelOffset.y), var_21ef4, 1.0);
    highp mat4 var_2949d = u_invProj;
    highp mat4 var_e6914 = u_invProj;
    highp mat4 var_164c7 = u_invProj;
    highp mat4 var_b5866 = u_invProj;
    highp mat4 var_bb46a = u_invProj;
    highp float var_a6256 = var_2bcb3.x;
    highp float var_05401 = var_2bcb3.y;
    highp float var_b8669 = var_2bcb3.w;
    highp float var_259fc = var_2bcb3.z;
    highp float var_f8db3 = var_2bcb3.w;
    highp vec4 var_fa2eb = vec4(var_a6256 * var_2949d[0].x, var_05401 * var_e6914[1].y, var_b8669 * var_164c7[3].z, (var_259fc * var_b5866[2].w) + (var_f8db3 * var_bb46a[3].w));
    var_2bcb3 = var_fa2eb;
    highp float var_f7138 = var_2bcb3.w;
    highp vec4 var_3ee7d = var_fa2eb / vec4(var_f7138);
    var_2bcb3 = var_3ee7d;
    highp vec3 var_c0220 = (u_invView * vec4(var_3ee7d.xyz, 1.0)).xyz - WorldOrigin.xyz;
    highp vec3 var_c6246 = var_3ee7d.xyz;
    highp vec3 var_0dd5c = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_c6246)), normalize(dFdy(var_c6246)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_2bcf8 = vec3(QuantizationParameters.z * 0.5) - mod(var_c0220, vec3(QuantizationParameters.z));
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    highp vec2 var_3ccf7 = var_9b1e9;
    highp vec3 var_b0cb0 = vec3(var_39d8d.xy, (1.0 - abs(var_3ccf7.x)) - abs(var_3ccf7.y));
    highp vec2 var_c65e0;
    if (var_b0cb0.z < 0.0)
    {
        var_c65e0 = (vec2(1.0) - abs(var_b0cb0.yx)) * ((step(vec2(0.0), var_b0cb0.xy) * 2.0) - vec2(1.0));
    }
    else
    {
        var_c65e0 = var_b0cb0.xy;
    }
    highp vec3 var_e6b69 = var_b0cb0;
    var_b0cb0 = vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z);
    highp vec3 var_6456b = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_5f7dd = normalize((u_view * vec4(var_6456b, 0.0)).xyz);
#endif
    highp vec4 var_62945 = texture(s_ColorMetalnessSubsurface, var_9279d);
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_4ac0e = var_62945;
    highp float var_626b8 = clamp(2.007874011993408203125 * (var_4ac0e.w - 0.501960813999176025390625), 0.0, 1.0);
#endif
    uvec4 var_9e1cf = texelFetch(s_EmissiveAmbientLinearRoughness, ivec2(vec2(textureSize(s_EmissiveAmbientLinearRoughness, 0)) * var_9279d), 0);
    uvec4 var_1f03a = var_9e1cf;
#ifdef POINT_LIGHT_SHADING__ON
    uint var_4b676 = var_1f03a.x & 65535u;
    uvec2 var_49e6b = uvec2(var_4b676 >> 8u, var_4b676 & 255u);
    highp vec2 var_e8237 = vec2(float(var_49e6b.x), float(var_49e6b.y)) * vec2(0.0039215688593685626983642578125);
#endif
    highp float var_05f4e = float(var_1f03a.w) * 0.0039215688593685626983642578125;
    uvec2 var_c02ad = var_9e1cf.yz;
    uint var_39af7 = var_c02ad.x & 65535u;
    uint var_32bfc = var_c02ad.y & 65535u;
    highp vec4 var_3f496 = vec4(uvec4(var_39af7 >> 8u, var_39af7 & 255u, var_32bfc >> 8u, var_32bfc & 255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 var_79cba = var_3f496;
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec3 var_0c780 = vec3((var_07058 * 2.0) - vec2(1.0), (var_e1c59.x * 2.0) - 1.0);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_e3756 = (u_invView * vec4(var_cee63.xyz, 1.0)).xyz;
    highp vec3 var_5b417 = var_cee63.xyz;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    highp vec3 var_0c780 = vec3(var_8c702, var_21ef4);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_9e11a = var_62945.xyz;
    highp vec3 var_b2786;
    func_9b87e(var_b2786, var_9e11a);
    highp vec3 var_c7b87 = vec3(0.039999999105930328369140625 * (1.0 - var_626b8)) + (var_b2786 * var_626b8);
#endif
    highp vec3 var_5bd0a = var_0c780;
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_68741 = -(var_5b417 / vec3(length(var_5b417) + 9.9999997473787516355514526367188e-05));
    highp float var_50757 = clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_4ac0e.w), 0.0, 1.0) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
#endif
#ifdef POINT_LIGHT_SHADING__OFF
    highp vec3 var_8014a;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_bb1f7;
    highp vec3 var_b232b;
    highp vec3 var_8014a;
#endif
    if (var_5bd0a.z != 1.0)
    {
#ifdef POINT_LIGHT_SHADING__ON
        highp vec4 var_651ec;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
        highp vec3 var_72de8;
#endif
#ifdef POINT_LIGHT_SHADING__ON
        highp vec3 var_abdf4;
        highp vec3 var_e318f;
        func_4f458(var_e318f, var_abdf4, var_651ec, var_c0220, var_2bcf8, var_0dd5c, var_e3756, var_5b417, var_5f7dd, var_68741, var_e8237, var_c7b87, var_626b8, var_6456b, var_50757);
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
        highp vec4 var_d28f5 = var_651ec;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
        highp vec3 var_72de8;
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
        if (DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled.w != 0.0)
        {
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
            highp vec3 var_e9045 = (((u_invView * vec4(var_cee63.xyz, 1.0)).xyz - WorldOrigin.xyz) - vec3(0.5)) + (var_6456b * 0.20000000298023223876953125);
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
            highp vec3 var_e9045 = ((var_e3756 - WorldOrigin.xyz) - vec3(0.5)) + (var_6456b * 0.20000000298023223876953125);
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
            ivec3 var_a2fbf = ivec3(floor(var_e9045));
            highp vec3 var_e55a8 = floor(var_e9045 * 0.0625) * 16.0;
            highp vec3 var_65d52 = var_e9045 - var_e55a8;
            ivec4 var_fb622 = ivec4((var_a2fbf - (ivec3(15) & (var_a2fbf >> ivec3(31)))) / ivec3(16), 0);
            ivec4 var_a2c78 = var_fb622;
            int var_8282d = (var_a2c78.x & 65535) | (var_a2c78.y << 16);
            int var_db019 = (var_a2c78.z & 65535) | (var_a2c78.w << 16);
            ivec4 var_e83d2 = var_fb622;
            uint var_dbe8c = uint(var_e83d2.x) * 1540483477u;
            uint var_35207 = uint(var_e83d2.y) * 1540483477u;
            uint var_c7c69 = uint(var_e83d2.z) * 1540483477u;
            uint var_7c89d = uint(var_e83d2.w) * 1540483477u;
            uint var_ea647 = ((((((2293326976u ^ ((var_dbe8c ^ (var_dbe8c >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_35207 ^ (var_35207 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_c7c69 ^ (var_c7c69 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_7c89d ^ (var_7c89d >> uint(24))) * 1540483477u);
            uint var_66e52 = (var_ea647 ^ (var_ea647 >> uint(13))) * 1540483477u;
            uint var_02650 = var_66e52 ^ (var_66e52 >> uint(15));
            uint var_b516a = (var_02650 ^ (var_02650 >> uint(16))) & 65535u;
            uint var_e9be1 = var_b516a | uint(var_b516a == 0u);
            int var_4bfc3;
            uint var_dc4a0;
            bool var_59b60;
            uint var_e4d40;
            var_e4d40 = 0u;
            var_59b60 = false;
            var_dc4a0 = var_e9be1 & uint(GpuEntryBufferCapacity.x - 1.0);
            var_4bfc3 = 0;
            bool var_40c1a;
            uint var_9cba6;
            uint var_8d8f4;
            uint var_d9aef;
            bool var_4680b;
            for (;;)
            {
                if (var_4bfc3 < 8)
                {
                    uint var_b3275 = uint(var_98704.GpuEntryBuffer[var_dc4a0].hash) & 65535u;
                    bool var_079e7 = var_b3275 == var_e9be1;
                    bool var_88b02;
                    if (var_079e7)
                    {
                        var_88b02 = var_98704.GpuEntryBuffer[var_dc4a0].packed_xy == var_8282d;
                    }
                    else
                    {
                        var_88b02 = var_079e7;
                    }
                    bool var_4f663;
                    if (var_88b02)
                    {
                        var_4f663 = var_98704.GpuEntryBuffer[var_dc4a0].packed_zw == var_db019;
                    }
                    else
                    {
                        var_4f663 = var_88b02;
                    }
                    if (var_59b60)
                    {
                        var_8d8f4 = var_e4d40;
                    }
                    else
                    {
                        uint var_fbc90;
                        if (var_4f663)
                        {
                            var_fbc90 = uint(var_98704.GpuEntryBuffer[var_dc4a0].user_data);
                        }
                        else
                        {
                            var_fbc90 = var_e4d40;
                        }
                        var_8d8f4 = var_fbc90;
                    }
                    var_40c1a = var_59b60 || var_4f663;
                    var_9cba6 = (var_dc4a0 + 1u) & uint(GpuEntryBufferCapacity.x - 1.0);
                    if (var_40c1a || (var_b3275 == 0u))
                    {
                        var_4680b = var_40c1a;
                        var_d9aef = var_8d8f4;
                        break;
                    }
                    var_e4d40 = var_8d8f4;
                    var_59b60 = var_40c1a;
                    var_dc4a0 = var_9cba6;
                    var_4bfc3++;
                    continue;
                }
                else
                {
                    var_4680b = var_59b60;
                    var_d9aef = var_e4d40;
                    break;
                }
            }
            uint var_ba630 = var_d9aef >> 2u;
            highp vec3 var_740c9;
            if (var_4680b)
            {
                highp vec3 var_840de;
                if (any(greaterThanEqual(abs(var_6456b), vec3(1.0))))
                {
                    highp vec3 var_523e6 = var_6456b;
                    highp vec3 var_34a44 = abs(var_6456b);
                    highp vec3 var_fabd5 = var_34a44.zxy;
                    highp vec3 var_5fd6a = var_34a44.yzx;
                    highp float var_bd489 = dot(var_65d52, var_34a44);
                    highp float var_a19ee = dot(var_65d52, var_fabd5);
                    highp float var_5b12c = dot(var_65d52, var_5fd6a);
                    highp float var_ba2c5;
                    if (((var_523e6.x + var_523e6.y) + var_523e6.z) > 0.0)
                    {
                        var_ba2c5 = ceil(var_bd489);
                    }
                    else
                    {
                        var_ba2c5 = floor(var_bd489);
                    }
                    highp float var_ab7b5 = floor(var_a19ee);
                    highp float var_cf4ab = floor(var_5b12c);
                    highp vec3 var_eebfd = ((var_34a44 * var_ba2c5) + (var_fabd5 * var_ab7b5)) + (var_5fd6a * var_cf4ab);
                    highp vec3 var_9d45f = var_eebfd + var_fabd5;
                    highp vec3 var_8ec6c = var_eebfd + var_5fd6a;
                    highp vec3 var_a2de2 = (var_eebfd + var_fabd5) + var_5fd6a;
                    highp float var_05440 = var_a19ee - var_ab7b5;
                    highp float var_a1ddc = var_5b12c - var_cf4ab;
                    highp float var_7d81d = 1.0 - var_05440;
                    highp float var_da39e = 1.0 - var_a1ddc;
                    highp vec4 var_f4a80 = vec4(var_7d81d * var_da39e, var_05440 * var_da39e, var_7d81d * var_a1ddc, var_05440 * var_a1ddc);
                    bool var_206b4 = all(greaterThanEqual(var_eebfd, vec3(0.0)));
                    bool var_e6d47;
                    if (var_206b4)
                    {
                        var_e6d47 = all(lessThan(var_a2de2, vec3(16.0)));
                    }
                    else
                    {
                        var_e6d47 = var_206b4;
                    }
                    highp vec3 var_cadfa;
                    highp vec3 var_aaf20;
                    highp vec3 var_9a4ca;
                    highp vec3 var_e4837;
                    if (var_e6d47)
                    {
                        uvec3 var_e709c = uvec3(var_eebfd);
                        uint var_119be = var_ba630 + ((var_e709c.y + (var_e709c.z * 16u)) + (var_e709c.x * 256u));
                        highp vec3 var_c5049;
                        func_33953(var_119be, var_c5049);
                        uvec3 var_99699 = uvec3(var_9d45f);
                        uint var_97a25 = var_ba630 + ((var_99699.y + (var_99699.z * 16u)) + (var_99699.x * 256u));
                        highp vec3 var_80d01;
                        func_33953(var_97a25, var_80d01);
                        uvec3 var_1a74d = uvec3(var_8ec6c);
                        uint var_c1a23 = var_ba630 + ((var_1a74d.y + (var_1a74d.z * 16u)) + (var_1a74d.x * 256u));
                        highp vec3 var_19337;
                        func_33953(var_c1a23, var_19337);
                        uvec3 var_8ca8c = uvec3(var_a2de2);
                        uint var_aea52 = var_ba630 + ((var_8ca8c.y + (var_8ca8c.z * 16u)) + (var_8ca8c.x * 256u));
                        highp vec3 var_12233;
                        func_33953(var_aea52, var_12233);
                        var_e4837 = var_12233;
                        var_9a4ca = var_19337;
                        var_aaf20 = var_80d01;
                        var_cadfa = var_c5049;
                    }
                    else
                    {
                        highp vec3 var_5f102 = var_e55a8 + var_eebfd;
                        highp vec3 var_946ba;
                        func_593c8(var_5f102, var_e55a8, var_ba630, var_946ba);
                        highp vec3 var_51e8a = var_e55a8 + var_9d45f;
                        highp vec3 var_da287;
                        func_593c8(var_51e8a, var_e55a8, var_ba630, var_da287);
                        highp vec3 var_89718 = var_e55a8 + var_8ec6c;
                        highp vec3 var_bde57;
                        func_593c8(var_89718, var_e55a8, var_ba630, var_bde57);
                        highp vec3 var_31e74 = var_e55a8 + var_a2de2;
                        highp vec3 var_4e7d6;
                        func_593c8(var_31e74, var_e55a8, var_ba630, var_4e7d6);
                        var_e4837 = var_4e7d6;
                        var_9a4ca = var_bde57;
                        var_aaf20 = var_da287;
                        var_cadfa = var_946ba;
                    }
                    var_840de = (((var_cadfa * var_f4a80.x) + (var_aaf20 * var_f4a80.y)) + (var_9a4ca * var_f4a80.z)) + (var_e4837 * var_f4a80.w);
                }
                else
                {
                    highp vec3 var_ca98c = floor(var_65d52);
                    highp vec3 var_fec25 = var_65d52 - var_ca98c;
                    int var_1a22c = (int(var_fec25.x >= var_fec25.y) | (int(var_fec25.y >= var_fec25.z) << 1)) | (int(var_fec25.x >= var_fec25.z) << 2);
                    uvec3 var_562c9 = uvec3(var_ca98c);
                    highp float var_660d6 = min(var_fec25.x, var_fec25.y);
                    highp float var_7e10f = max(var_fec25.x, var_fec25.y);
                    highp float var_e2241 = min(var_660d6, var_fec25.z);
                    highp float var_57cd4 = max(var_7e10f, var_fec25.z);
                    highp float var_9bcc6 = max(min(var_7e10f, var_fec25.z), var_660d6);
                    bool var_e0b29 = all(greaterThanEqual(var_ca98c, vec3(0.0)));
                    bool var_c2b6d;
                    if (var_e0b29)
                    {
                        var_c2b6d = all(lessThan(var_ca98c + vec3(1.0), vec3(16.0)));
                    }
                    else
                    {
                        var_c2b6d = var_e0b29;
                    }
                    highp vec3 var_d71a8;
                    highp vec3 var_b0855;
                    highp vec3 var_51916;
                    highp vec3 var_77ab5;
                    if (var_c2b6d)
                    {
                        uvec3 var_ac914 = var_562c9;
                        uint var_e79d2 = var_ba630 + ((var_ac914.y + (var_ac914.z * 16u)) + (var_ac914.x * 256u));
                        highp vec3 var_5ec12;
                        func_33953(var_e79d2, var_5ec12);
                        uvec3 var_a2325 = var_562c9 + var_e4221[var_1a22c];
                        uint var_1659c = var_ba630 + ((var_a2325.y + (var_a2325.z * 16u)) + (var_a2325.x * 256u));
                        highp vec3 var_d1b22;
                        func_33953(var_1659c, var_d1b22);
                        uvec3 var_c4f29 = var_562c9 + var_a8b51[var_1a22c];
                        uint var_ead17 = var_ba630 + ((var_c4f29.y + (var_c4f29.z * 16u)) + (var_c4f29.x * 256u));
                        highp vec3 var_edee1;
                        func_33953(var_ead17, var_edee1);
                        uvec3 var_632a4 = var_562c9 + uvec3(1u);
                        uint var_a75a5 = var_ba630 + ((var_632a4.y + (var_632a4.z * 16u)) + (var_632a4.x * 256u));
                        highp vec3 var_446c0;
                        func_33953(var_a75a5, var_446c0);
                        var_77ab5 = var_446c0;
                        var_51916 = var_edee1;
                        var_b0855 = var_d1b22;
                        var_d71a8 = var_5ec12;
                    }
                    else
                    {
                        highp vec3 var_df1d5 = var_e55a8 + var_ca98c;
                        highp vec3 var_99a9d;
                        func_593c8(var_df1d5, var_e55a8, var_ba630, var_99a9d);
                        highp vec3 var_3c711 = var_e55a8 + (var_ca98c + vec3(var_e4221[var_1a22c]));
                        highp vec3 var_de0a1;
                        func_593c8(var_3c711, var_e55a8, var_ba630, var_de0a1);
                        highp vec3 var_fda56 = var_e55a8 + (var_ca98c + vec3(var_a8b51[var_1a22c]));
                        highp vec3 var_db77f;
                        func_593c8(var_fda56, var_e55a8, var_ba630, var_db77f);
                        highp vec3 var_cff91 = var_e55a8 + (var_ca98c + vec3(1.0));
                        highp vec3 var_a94b1;
                        func_593c8(var_cff91, var_e55a8, var_ba630, var_a94b1);
                        var_77ab5 = var_a94b1;
                        var_51916 = var_db77f;
                        var_b0855 = var_de0a1;
                        var_d71a8 = var_99a9d;
                    }
                    var_840de = (((var_d71a8 * (1.0 - var_57cd4)) + (var_b0855 * (var_57cd4 - var_9bcc6))) + (var_51916 * (var_9bcc6 - var_e2241))) + (var_77ab5 * var_e2241);
                }
                var_740c9 = var_840de;
            }
            else
            {
                var_740c9 = vec3(0.0);
            }
            var_72de8 = var_740c9;
        }
        else
        {
            var_72de8 = (var_3f496.xyz * var_79cba.w) * 6.0;
        }
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
        highp vec4 var_0a56c = var_651ec;
#endif
        highp vec4 var_fdcaa = SkyAmbientLightColorIntensity;
        highp float var_03390 = var_05f4e * var_05f4e;
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
        var_8014a = ((vec3(1.0) * (1.0 - clamp(2.007874011993408203125 * (var_62945.w - 0.501960813999176025390625), 0.0, 1.0))) * max((((var_3f496.xyz * var_79cba.w) * 6.0) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_03390 * var_03390) * var_05f4e, (var_05f4e * var_05f4e) * var_05f4e, CameraLightIntensity.y)) * var_fdcaa.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w;
#endif
#ifdef POINT_LIGHT_SHADING__ON
        var_8014a = var_e318f;
        var_b232b = var_abdf4;
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
        var_bb1f7 = ((vec3(1.0) * (1.0 - var_626b8)) * max(((((var_3f496.xyz * var_79cba.w) * 6.0) + (var_651ec.xyz * var_d28f5.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_03390 * var_03390) * var_05f4e, (var_05f4e * var_05f4e) * var_05f4e, CameraLightIntensity.y)) * var_fdcaa.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
        var_8014a = ((vec3(1.0) * (1.0 - clamp(2.007874011993408203125 * (var_62945.w - 0.501960813999176025390625), 0.0, 1.0))) * max((var_72de8 * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_03390 * var_03390) * var_05f4e, (var_05f4e * var_05f4e) * var_05f4e, CameraLightIntensity.y)) * var_fdcaa.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
        var_bb1f7 = ((vec3(1.0) * (1.0 - var_626b8)) * max(((var_72de8 + (var_651ec.xyz * var_0a56c.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_03390 * var_03390) * var_05f4e, (var_05f4e * var_05f4e) * var_05f4e, CameraLightIntensity.y)) * var_fdcaa.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w;
#endif
    }
    else
    {
        var_8014a = vec3(0.0);
#ifdef POINT_LIGHT_SHADING__ON
        var_b232b = vec3(0.0);
        var_bb1f7 = vec3(0.0);
#endif
    }
    highp vec3 var_0c789 = var_0c780;
    highp float var_70857 = ((var_0c789.z * 0.5) + 0.5) * 65535.0;
    highp float var_461e5 = floor(var_70857);
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    bgfx_FragData0 = vec4((var_39d8d.xy * 0.5) + vec2(0.5), var_461e5 * 1.525902189314365386962890625e-05, var_70857 - var_461e5);
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
    bgfx_FragData0 = vec4((var_9b1e9 * 0.5) + vec2(0.5), var_461e5 * 1.525902189314365386962890625e-05, var_70857 - var_461e5);
#endif
#ifdef POINT_LIGHT_SHADING__OFF
    bgfx_FragData1 = vec4(var_8014a, 1.0);
    bgfx_FragData2 = vec4(0.0, 0.0, 0.0, 1.0);
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
    bgfx_FragData0 = vec4((var_9b1e9 * 0.5) + vec2(0.5), var_461e5 * 1.525902189314365386962890625e-05, var_70857 - var_461e5);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    bgfx_FragData1 = vec4(var_8014a + var_bb1f7, 1.0);
    bgfx_FragData2 = vec4(var_b232b, 1.0);
#endif
}
