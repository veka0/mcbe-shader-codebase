#version 310 es

/*
* Available Macros:
*
* Passes:
* - DIRECTIONAL_LIGHTING_PASS (not used)
* - DISCRETE_INDIRECT_COMBINED_LIGHTING_PASS (not used)
* - FALLBACK_PASS (not used)
*
* GPUBlockLighting:
* - GPU_BLOCK_LIGHTING__OFF
* - GPU_BLOCK_LIGHTING__ON
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF
* - POINT_LIGHT_SHADING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_CausticsMultiplier;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp usampler2D s_EmissiveAmbientLinearRoughness;
* - layout(binding = 10, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - layout(binding = 11, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
* - layout(binding = 12, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 13, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
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
* - uniform vec4 PointLightPreCalcValuesAndAmbientScalar;
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
* - uniform vec4 UndergroundFogColor;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
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
const int var_b7fc0[64] = int[](-1, 2, 3, -1, 0, 6, 7, -1, 1, 10, 11, -1, -1, -1, -1, -1, 4, 14, 16, -1, 8, 18, 20, -1, 12, 22, 24, -1, -1, -1, -1, -1, 5, 15, 17, -1, 9, 19, 21, -1, 13, 23, 25, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
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
const uint var_40c4f[3] = uint[](4u, 2u, 1u);
const uint var_4d3a3[3] = uint[](240u, 204u, 170u);
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
#ifdef GPU_BLOCK_LIGHTING__OFF
float var_6c9b6;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
layout(binding = 11, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_bb94e;
layout(binding = 10, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_47f76;
#endif
#ifdef POINT_LIGHT_SHADING__ON
layout(binding = 13, std430) buffer s_zLights { Light zLights[]; } var_9f9d2;
layout(binding = 12, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_1282d;
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
layout(binding = 11, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_bb94e;
layout(binding = 10, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_47f76;
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
uniform highp vec4 DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
#endif
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
uniform highp vec4 GpuEntryBufferCapacity;
#endif
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightNdLFloor;
uniform highp vec4 PointLightPreCalcValuesAndAmbientScalar;
uniform highp vec4 PointLightShadowAtlasResolution;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
uniform highp vec4 DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
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
in highp vec3 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
void func_2dbd9(inout uint arg_15cff, inout ivec3 arg_3d8dd) {
    uint loc_7f344 = arg_15cff & 3u;
    if ((loc_7f344 == 0u) || (loc_7f344 > 3u))
    {
        arg_3d8dd = ivec3(0);
        return;
    }
    int loc_d839a = (arg_15cff >= 4u) ? (-1) : 1;
    arg_3d8dd = ivec3((loc_7f344 == 1u) ? loc_d839a : 0, (loc_7f344 == 2u) ? loc_d839a : 0, (loc_7f344 == 3u) ? loc_d839a : 0);
}
#endif
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
void func_e3b7a(inout highp vec3 arg_8d32a, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp vec3 loc_f1110 = arg_8d32a;
    highp vec3 loc_75f4e = ClusterDimensions.xyz;
    highp vec2 loc_7c1c9 = ClusterDepthBounds.xy;
    highp vec4 loc_21c5a = PointLightPreCalcValuesAndAmbientScalar;
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
            loc_a71e8 = min(floor(clamp((log2(loc_ac0eb) - loc_21c5a.z) * loc_21c5a.x, 0.0, 1.0) * (loc_75f4e.z - 2.0)) + 2.0, loc_75f4e.z - 1.0);
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
void func_e37a7(inout int arg_7070b, inout highp float arg_43b7a, inout highp float arg_9499a, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c, inout highp float arg_77c90) {
    if (arg_7070b < 0)
    {
        arg_43b7a = 1.0;
        arg_9499a = 0.0;
        return;
    }
    highp vec3 loc_8868e = arg_aee55 - var_9f9d2.zLights[arg_7070b].position.xyz;
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
    highp vec4 loc_87a38 = var_9f9d2.zLights[arg_7070b].shadowFaceUV0;
    highp vec3 loc_baa89;
    if (loc_f3fad == 1)
    {
        loc_87a38 = var_9f9d2.zLights[arg_7070b].shadowFaceUV1;
        loc_baa89 = vec3(-loc_8a9f7.z, loc_8a9f7.y, loc_8a9f7.x);
    }
    else
    {
        highp vec3 loc_a4212;
        if (loc_f3fad == 2)
        {
            loc_87a38 = var_9f9d2.zLights[arg_7070b].shadowFaceUV2;
            loc_a4212 = vec3(-loc_8a9f7.x, -loc_8a9f7.z, -loc_8a9f7.y);
        }
        else
        {
            highp vec3 loc_38505;
            if (loc_f3fad == 3)
            {
                loc_87a38 = var_9f9d2.zLights[arg_7070b].shadowFaceUV3;
                loc_38505 = vec3(-loc_8a9f7.x, loc_8a9f7.z, loc_8a9f7.y);
            }
            else
            {
                highp vec3 loc_fd3cf;
                if (loc_f3fad == 4)
                {
                    loc_87a38 = var_9f9d2.zLights[arg_7070b].shadowFaceUV4;
                    loc_fd3cf = vec3(-loc_8a9f7.x, loc_8a9f7.y, -loc_8a9f7.z);
                }
                else
                {
                    highp vec3 loc_0c356;
                    if (loc_f3fad == 5)
                    {
                        loc_87a38 = var_9f9d2.zLights[arg_7070b].shadowFaceUV5;
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
    bool loc_da9b7 = loc_87a38.z == 0.0;
    bool loc_20dc6;
    if (loc_da9b7)
    {
        loc_20dc6 = loc_87a38.w == 0.0;
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
    highp vec4 loc_6a946 = PointLightProj * vec4(loc_baa89, 1.0);
    highp float loc_ee959 = clamp(dot(normalize(-loc_8868e), normalize(arg_1111c)), PointLightNdLFloor.x, 1.0);
    loc_6a946.z -= ((PointLightShadowParams1.x + (PointLightShadowParams1.y * (sqrt(1.0 - (loc_ee959 * loc_ee959)) / loc_ee959))) * (PointLightShadowAtlasResolution.z / max((loc_87a38.z - loc_87a38.x) * PointLightShadowAtlasResolution.x, 1.0)));
    highp float loc_d799e = loc_6a946.w;
    highp vec4 loc_9858b = loc_6a946;
    highp vec4 loc_87f4b = loc_9858b / vec4(loc_d799e);
    loc_6a946 = loc_87f4b;
    highp vec2 loc_329bf = vec2(0.5) / PointLightShadowAtlasResolution.xy;
    highp vec2 loc_dbd7f = loc_87a38.zw - loc_87a38.xy;
    highp vec2 loc_4a8b9 = loc_dbd7f * PointLightShadowAtlasResolution.xy;
    highp float loc_ad7d9 = (textureLod(s_PointLightShadowTextureAtlas, clamp(loc_87a38.xy + (((floor(((loc_87f4b.xy * 0.5) + vec2(0.5)) * loc_4a8b9) + vec2(0.5)) / loc_4a8b9) * loc_dbd7f), loc_87a38.xy + loc_329bf, loc_87a38.zw - loc_329bf), 0.0).x * 2.0) - 1.0;
    highp float loc_591c8;
    if (loc_ad7d9 >= loc_6a946.z)
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
        highp vec4 loc_cb0be = PointLightInvProj * vec4(loc_6a946.xy, loc_ad7d9, 1.0);
        highp vec4 loc_05114 = loc_cb0be;
        highp float loc_0585d = loc_05114.w;
        highp vec3 loc_af870 = loc_cb0be.xyz / vec3(loc_0585d);
        loc_05114.x = loc_af870.x;
        loc_05114.y = loc_af870.y;
        loc_05114.z = loc_af870.z;
        loc_d7fd8 = 1.0 - smoothstep(0.0, 1.0, (length(loc_baa89) - length(loc_05114.xyz)) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z);
    }
    else
    {
        loc_d7fd8 = 1.0;
    }
    arg_43b7a = loc_d7fd8;
    arg_9499a = loc_591c8;
}
void func_673ac(inout int arg_13769, inout highp float arg_43b7a, inout highp float arg_7f337, inout highp vec3 arg_0a2b9, inout highp vec3 arg_29ac4, inout highp vec3 arg_f6a53, inout highp vec3 arg_4f9dc, inout highp float arg_8bccf) {
    if (arg_13769 < 0)
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp vec3 loc_8dfd7 = var_9f9d2.zLights[arg_13769].position.xyz - arg_29ac4;
    highp vec3 loc_8cb9b = loc_8dfd7;
    highp float loc_16a27;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_16a27 = loc_1829d * loc_1829d;
    }
    else
    {
        loc_16a27 = dot(loc_8dfd7, loc_8dfd7);
    }
    if (loc_16a27 >= (var_9f9d2.zLights[arg_13769].position.w * var_9f9d2.zLights[arg_13769].position.w))
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp float loc_a011d;
    highp float loc_22c1c;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0)
    {
        highp float loc_412fd;
        highp float loc_b2a04;
        func_e37a7(arg_13769, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_22c1c = loc_b2a04;
        loc_a011d = loc_412fd;
    }
    else
    {
        loc_22c1c = 1.0;
        loc_a011d = 1.0;
    }
    highp float loc_4c5a5 = loc_16a27 / ((var_9f9d2.zLights[arg_13769].position.w * var_9f9d2.zLights[arg_13769].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_ef515 = clamp(1.0 - (loc_4c5a5 * loc_4c5a5), 0.0, 1.0);
    highp float loc_5f09f = (1.0 / max(loc_16a27, 0.100000001490116119384765625)) * (loc_ef515 * loc_ef515);
    highp float loc_ae18a;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_ae18a = loc_5f09f * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_5f09f) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_ae18a = loc_5f09f;
    }
    arg_43b7a = loc_22c1c;
    arg_7f337 = loc_a011d;
    arg_0a2b9 = (var_9f9d2.zLights[arg_13769].color.xyz * var_9f9d2.zLights[arg_13769].color.w) * loc_ae18a;
}
void func_742b6(inout highp vec3 arg_33c3b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec3 arg_efe4b, inout highp vec3 arg_81f79, inout highp vec2 arg_92c2f, inout highp vec3 arg_58ffc, inout highp float arg_d96ac, inout highp vec3 arg_7f6c9, inout highp vec3 arg_5a8cd, inout highp vec3 arg_4fa31, inout highp float arg_9502a) {
    bool loc_a0bb1;
    int loc_5afa9;
    int loc_3379d;
    func_e3b7a(arg_33c3b, loc_3379d, loc_5afa9, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        return;
    }
    highp vec3 loc_15ce8;
    highp vec3 loc_728b6;
    loc_728b6 = vec3(0.0);
    loc_15ce8 = vec3(0.0);
    highp vec3 loc_334a8;
    highp vec3 loc_5937c;
    for (int loc_6165e = loc_5afa9; loc_6165e < loc_3379d; loc_728b6 = loc_5937c, loc_15ce8 = loc_334a8, loc_6165e++)
    {
        int loc_954ff = int(var_1282d.zLightLookupArray[loc_6165e].lookup);
        if (loc_954ff < 0)
        {
            break;
        }
        highp vec3 loc_ed90f = normalize((u_view * vec4(var_9f9d2.zLights[loc_954ff].position.xyz, 1.0)).xyz - arg_33c3b);
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
        highp vec3 loc_ae550;
        highp float loc_369b6;
        highp float loc_c0937;
        func_673ac(loc_954ff, loc_c0937, loc_369b6, loc_ae550, arg_7f6c9, arg_5a8cd, arg_4fa31, arg_9502a);
        loc_334a8 = loc_15ce8 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_9502a)) * (loc_ec1c7 * vec3(0.3183098733425140380859375))) * loc_369b6) + (((loc_ec1c7 * vec3(0.3183098733425140380859375)) * (arg_9502a * max((dot(-arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_c0937)) * loc_ae550) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_5937c = loc_728b6 + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_369b6) * loc_ae550) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_15ce8;
    arg_90b60 = loc_728b6;
}
void func_2a836(inout highp vec3 arg_286fc, inout highp vec3 arg_9017f, inout highp vec3 arg_229fe, inout highp vec3 arg_29328, inout highp vec3 arg_c3199, inout highp vec3 arg_e13a9, inout highp vec3 arg_83a50, inout highp vec3 arg_f0c09, inout highp vec3 arg_f55d7, inout highp vec2 arg_06c95, inout highp vec3 arg_96ff7, inout highp float arg_cc5db, inout highp vec3 arg_7d49a, inout highp float arg_39aac) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0))
    {
        arg_286fc = vec3(0.0);
        arg_9017f = vec3(0.0);
        return;
    }
    highp vec3 loc_65972;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_65972 = (arg_229fe + (arg_29328 - (arg_c3199 * dot(arg_29328, arg_c3199)))) + WorldOrigin.xyz;
    }
    else
    {
        loc_65972 = arg_e13a9;
    }
    highp vec3 loc_8066b;
    highp vec3 loc_192f5;
    func_742b6(arg_83a50, loc_192f5, loc_8066b, arg_f0c09, arg_f55d7, arg_06c95, arg_96ff7, arg_cc5db, arg_e13a9, loc_65972, arg_7d49a, arg_39aac);
    arg_286fc = loc_192f5 * (1.0 - PointLightPreCalcValuesAndAmbientScalar.w);
    arg_9017f = loc_8066b * (1.0 - PointLightPreCalcValuesAndAmbientScalar.w);
}
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
void func_2dbd9(inout uint arg_15cff, inout ivec3 arg_3d8dd) {
    uint loc_7f344 = arg_15cff & 3u;
    if ((loc_7f344 == 0u) || (loc_7f344 > 3u))
    {
        arg_3d8dd = ivec3(0);
        return;
    }
    int loc_d839a = (arg_15cff >= 4u) ? (-1) : 1;
    arg_3d8dd = ivec3((loc_7f344 == 1u) ? loc_d839a : 0, (loc_7f344 == 2u) ? loc_d839a : 0, (loc_7f344 == 3u) ? loc_d839a : 0);
}
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
void func_fff8e(inout uint arg_45009, inout ivec3 arg_25482, inout uint arg_a965a, inout ivec3 arg_f7dc9) {
    uint loc_a0cb4 = (arg_45009 + 4123u) + ((uint(arg_25482.z - (-1)) * 18u) + uint(arg_25482.x - (-1)));
    uint loc_50d99 = loc_a0cb4 + 1u;
    bool loc_11974 = arg_25482.y >= 0;
    bool loc_6fa15;
    if (loc_11974)
    {
        loc_6fa15 = arg_25482.y < 15;
    }
    else
    {
        loc_6fa15 = loc_11974;
    }
    if (loc_6fa15)
    {
        uint loc_b118b = uint(arg_25482.y);
        uint loc_a385f = (var_bb94e.VoxelBuffer[loc_a0cb4].data >> loc_b118b) & 3u;
        uint loc_95bf0 = ((var_bb94e.VoxelBuffer[loc_a0cb4].data >> 16u) >> loc_b118b) & 3u;
        uint loc_6dacb = (var_bb94e.VoxelBuffer[loc_50d99].data >> loc_b118b) & 3u;
        uint loc_f9969 = ((var_bb94e.VoxelBuffer[loc_50d99].data >> 16u) >> loc_b118b) & 3u;
        arg_a965a = ((((loc_a385f & 1u) | ((loc_a385f & 2u) << 1u)) | (((loc_95bf0 & 1u) | ((loc_95bf0 & 2u) << 1u)) << 1u)) | (((loc_6dacb & 1u) | ((loc_6dacb & 2u) << 1u)) << 4u)) | (((loc_f9969 & 1u) | ((loc_f9969 & 2u) << 1u)) << 5u);
        return;
    }
    if (arg_25482.y < 0)
    {
        ivec3 loc_9596e = arg_f7dc9;
        uint loc_9e3a2 = (uint(loc_9596e.x - (-1)) * 18u) + uint(loc_9596e.z - (-1));
        uint loc_f2544 = loc_9e3a2 / 32u;
        uint loc_2dbd6 = loc_9e3a2 % 32u;
        uint loc_9766b = arg_45009 + 4429u;
        uint loc_a4225 = var_bb94e.VoxelBuffer[loc_9766b + loc_f2544].data >> loc_2dbd6;
        uint loc_63c72;
        if (loc_2dbd6 > 12u)
        {
            loc_63c72 = loc_a4225 | (var_bb94e.VoxelBuffer[(loc_9766b + loc_f2544) + 1u].data << (32u - loc_2dbd6));
        }
        else
        {
            loc_63c72 = loc_a4225;
        }
        uint loc_680e3 = (loc_63c72 & 3u) | ((loc_63c72 >> 16u) & 12u);
        uint loc_9a4d6 = (((var_bb94e.VoxelBuffer[loc_a0cb4].data & 1u) | (((var_bb94e.VoxelBuffer[loc_a0cb4].data >> 16u) & 1u) << 1u)) | ((var_bb94e.VoxelBuffer[loc_50d99].data & 1u) << 2u)) | (((var_bb94e.VoxelBuffer[loc_50d99].data >> 16u) & 1u) << 3u);
        arg_a965a = ((loc_680e3 & 3u) | ((loc_680e3 & 12u) << 2u)) | (((loc_9a4d6 & 3u) | ((loc_9a4d6 & 12u) << 2u)) << 2u);
        return;
    }
    uint loc_3413e = ((((var_bb94e.VoxelBuffer[loc_a0cb4].data >> 15u) & 1u) | (((var_bb94e.VoxelBuffer[loc_a0cb4].data >> 31u) & 1u) << 1u)) | (((var_bb94e.VoxelBuffer[loc_50d99].data >> 15u) & 1u) << 2u)) | (((var_bb94e.VoxelBuffer[loc_50d99].data >> 31u) & 1u) << 3u);
    ivec3 loc_f0131 = arg_f7dc9;
    uint loc_3a44a = (uint(loc_f0131.x - (-1)) * 18u) + uint(loc_f0131.z - (-1));
    uint loc_1d03f = loc_3a44a / 32u;
    uint loc_dcf35 = loc_3a44a % 32u;
    uint loc_38235 = arg_45009 + 4440u;
    uint loc_c3396 = var_bb94e.VoxelBuffer[loc_38235 + loc_1d03f].data >> loc_dcf35;
    uint loc_f671b;
    if (loc_dcf35 > 12u)
    {
        loc_f671b = loc_c3396 | (var_bb94e.VoxelBuffer[(loc_38235 + loc_1d03f) + 1u].data << (32u - loc_dcf35));
    }
    else
    {
        loc_f671b = loc_c3396;
    }
    uint loc_88411 = (loc_f671b & 3u) | ((loc_f671b >> 16u) & 12u);
    arg_a965a = ((loc_3413e & 3u) | ((loc_3413e & 12u) << 2u)) | (((loc_88411 & 3u) | ((loc_88411 & 12u) << 2u)) << 2u);
}
void func_93a41(inout uint arg_d6211, inout int arg_401db, inout highp vec3 arg_aa7d7) {
    if (var_bb94e.VoxelBuffer[arg_d6211[arg_401db]].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_17ab1 = vec4(uvec4(var_bb94e.VoxelBuffer[arg_d6211[arg_401db]].data, var_bb94e.VoxelBuffer[arg_d6211[arg_401db]].data >> 8u, var_bb94e.VoxelBuffer[arg_d6211[arg_401db]].data >> 16u, var_bb94e.VoxelBuffer[arg_d6211[arg_401db]].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_17ab1;
    arg_aa7d7 = (loc_17ab1.xyz * loc_3ff2a.w) * 6.0;
}
void func_33953(inout uint arg_a601e, inout highp vec3 arg_aa7d7) {
    if (var_bb94e.VoxelBuffer[arg_a601e].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_11fc1 = vec4(uvec4(var_bb94e.VoxelBuffer[arg_a601e].data, var_bb94e.VoxelBuffer[arg_a601e].data >> 8u, var_bb94e.VoxelBuffer[arg_a601e].data >> 16u, var_bb94e.VoxelBuffer[arg_a601e].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_11fc1;
    arg_aa7d7 = (loc_11fc1.xyz * loc_3ff2a.w) * 6.0;
}
void func_e0a6a(inout int arg_528e6, inout uint arg_2d77f, inout highp vec3 arg_534d1, inout highp vec3 arg_13804, inout highp vec3 arg_18a62, inout uint arg_92f3d) {
    bool loc_c7009 = var_b7fc0[arg_528e6] >= 0;
    bool loc_40b62;
    if (loc_c7009)
    {
        loc_40b62 = !((var_bb94e.VoxelBuffer[arg_2d77f].data & (1u << uint(var_b7fc0[arg_528e6]))) != 0u);
    }
    else
    {
        loc_40b62 = loc_c7009;
    }
    if (loc_40b62)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    uint loc_58bb3;
    if (var_b7fc0[arg_528e6] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_13804 - arg_18a62) & uvec3(15u);
        loc_58bb3 = arg_92f3d + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        uvec3 loc_441ec = uvec3(arg_13804 - (floor(arg_13804 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_bb94e.VoxelBuffer[(arg_92f3d + 4097u) + uint(var_b7fc0[arg_528e6])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    highp vec3 loc_5d636;
    func_33953(loc_58bb3, loc_5d636);
    arg_534d1 = loc_5d636;
}
void func_fc671(inout ivec3 arg_0f663, inout ivec3 arg_f5018, inout ivec3 arg_8bf68, inout ivec3 arg_9cf5c, inout uint arg_8b393, inout ivec3 arg_77cac, inout uint arg_e0e36, inout ivec3 arg_293d7, inout highp vec3 arg_69bef, inout highp vec3 arg_2f737, inout highp vec2 arg_53d93) {
    uvec3 loc_d3438 = uvec3(arg_0f663 - arg_f5018);
    uvec3 loc_a3b5a = loc_d3438;
    uvec3 loc_b95f1 = uvec3(arg_8bf68 - arg_f5018);
    uvec3 loc_f77e2 = loc_b95f1;
    uvec3 loc_459f4 = loc_d3438;
    uint loc_dfe3c = ((loc_459f4.x * 4u) + (loc_459f4.y * 2u)) + loc_459f4.z;
    uvec3 loc_de201 = loc_b95f1;
    uint loc_55d14 = ((loc_de201.x * 4u) + (loc_de201.y * 2u)) + loc_de201.z;
    uvec3 loc_94dfc = uvec3(abs(arg_f5018 - arg_9cf5c));
    uint loc_a7f5e = ((loc_94dfc.x * 4u) + (loc_94dfc.y * 2u)) + loc_94dfc.z;
    highp float loc_3cb02[4];
    loc_3cb02[0] = float((arg_8b393 & (1u << loc_a7f5e)) == 0u);
    loc_3cb02[1] = float((arg_8b393 & (1u << (loc_a7f5e ^ loc_dfe3c))) == 0u);
    loc_3cb02[2] = float((arg_8b393 & (1u << (loc_a7f5e ^ loc_55d14))) == 0u);
    loc_3cb02[3] = float((arg_8b393 & (1u << ((loc_a7f5e ^ loc_dfe3c) ^ loc_55d14))) == 0u);
    bool loc_eafd0 = all(greaterThanEqual(arg_f5018, ivec3(0)));
    bool loc_34d11;
    if (loc_eafd0)
    {
        loc_34d11 = all(lessThan(arg_77cac, ivec3(16)));
    }
    else
    {
        loc_34d11 = loc_eafd0;
    }
    highp vec3 loc_d5877[4];
    if (loc_34d11)
    {
        uint loc_c0464[4];
        loc_c0464[0] = arg_e0e36 + ((uint(arg_f5018.y) + (uint(arg_f5018.z) * 16u)) + (uint(arg_f5018.x) * 256u));
        loc_c0464[1] = loc_c0464[0] + ((loc_a3b5a.y + (loc_a3b5a.z * 16u)) + (loc_a3b5a.x * 256u));
        loc_c0464[2] = loc_c0464[0] + ((loc_f77e2.y + (loc_f77e2.z * 16u)) + (loc_f77e2.x * 256u));
        loc_c0464[3] = loc_c0464[1] + ((loc_f77e2.y + (loc_f77e2.z * 16u)) + (loc_f77e2.x * 256u));
        for (int loc_b61ea = 0; loc_b61ea < 4; loc_b61ea++)
        {
            highp vec3 loc_8d5d6;
            if (loc_3cb02[loc_b61ea] != 0.0)
            {
                highp vec3 loc_21cfc;
                func_93a41(loc_c0464, loc_b61ea, loc_21cfc);
                loc_8d5d6 = loc_21cfc;
            }
            else
            {
                loc_8d5d6 = vec3(0.0);
            }
            loc_d5877[loc_b61ea] = loc_8d5d6;
        }
    }
    else
    {
        uint loc_ac42f = arg_e0e36 + 4096u;
        for (int loc_3ddd4 = 0; loc_3ddd4 < 4; loc_3ddd4++)
        {
            loc_d5877[loc_3ddd4] = vec3(0.0);
            if (loc_3cb02[loc_3ddd4] != 0.0)
            {
                ivec3 loc_fe1d1[4] = arg_293d7;
                highp vec3 loc_13d2e = arg_69bef + vec3(loc_fe1d1[loc_3ddd4]);
                highp vec3 loc_d657b = loc_13d2e - arg_69bef;
                int loc_00371 = ((((int(loc_d657b.x < 0.0) | (int(loc_d657b.x >= 16.0) << 1)) | (int(loc_d657b.y < 0.0) << 2)) | (int(loc_d657b.y >= 16.0) << 3)) | (int(loc_d657b.z < 0.0) << 4)) | (int(loc_d657b.z >= 16.0) << 5);
                highp vec3 loc_83d45;
                func_e0a6a(loc_00371, loc_ac42f, loc_83d45, loc_13d2e, arg_69bef, arg_e0e36);
                loc_d5877[loc_3ddd4] = loc_83d45;
            }
        }
    }
    if ((((loc_3cb02[0] + loc_3cb02[1]) + loc_3cb02[2]) + loc_3cb02[3]) >= 4.0)
    {
        arg_2f737 = mix(mix(loc_d5877[0], loc_d5877[1], vec3(arg_53d93.x)), mix(loc_d5877[2], loc_d5877[3], vec3(arg_53d93.x)), vec3(arg_53d93.y));
        return;
    }
    highp float loc_5b627 = ((1.0 - arg_53d93.x) * (1.0 - arg_53d93.y)) * loc_3cb02[0];
    highp float loc_7da39 = (arg_53d93.x * (1.0 - arg_53d93.y)) * loc_3cb02[1];
    highp float loc_cb7e2 = ((1.0 - arg_53d93.x) * arg_53d93.y) * loc_3cb02[2];
    highp float loc_345a0 = (arg_53d93.x * arg_53d93.y) * loc_3cb02[3];
    highp float loc_5bc00 = ((loc_5b627 + loc_7da39) + loc_cb7e2) + loc_345a0;
    highp vec3 loc_925af;
    if (loc_5bc00 > 0.0)
    {
        loc_925af = ((((loc_d5877[0] * loc_5b627) + (loc_d5877[1] * loc_7da39)) + (loc_d5877[2] * loc_cb7e2)) + (loc_d5877[3] * loc_345a0)) / vec3(loc_5bc00);
    }
    else
    {
        loc_925af = vec3(0.0);
    }
    arg_2f737 = loc_925af;
}
void func_2ab53(inout int arg_689f7, inout highp vec3 arg_534d1, inout highp vec3 arg_13804, inout highp vec3 arg_18a62, inout uint arg_92f3d) {
    bool loc_c7009 = var_b7fc0[arg_689f7] >= 0;
    bool loc_e4976;
    if (loc_c7009)
    {
        loc_e4976 = true;
    }
    else
    {
        loc_e4976 = loc_c7009;
    }
    if (loc_e4976)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    uint loc_58bb3;
    if (var_b7fc0[arg_689f7] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_13804 - arg_18a62) & uvec3(15u);
        loc_58bb3 = arg_92f3d + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        uvec3 loc_441ec = uvec3(arg_13804 - (floor(arg_13804 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_bb94e.VoxelBuffer[(arg_92f3d + 4097u) + uint(var_b7fc0[arg_689f7])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    highp vec3 loc_5d636;
    func_33953(loc_58bb3, loc_5d636);
    arg_534d1 = loc_5d636;
}
void func_ec180(inout int arg_eae48, inout uint arg_ccc49, inout highp vec3 arg_534d1, inout highp vec3 arg_13804, inout highp vec3 arg_18a62) {
    bool loc_c7009 = var_b7fc0[arg_eae48] >= 0;
    bool loc_aa1a7;
    if (loc_c7009)
    {
        loc_aa1a7 = !((var_bb94e.VoxelBuffer[arg_ccc49 + 4096u].data & (1u << uint(var_b7fc0[arg_eae48]))) != 0u);
    }
    else
    {
        loc_aa1a7 = loc_c7009;
    }
    if (loc_aa1a7)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    uint loc_58bb3;
    if (var_b7fc0[arg_eae48] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_13804 - arg_18a62) & uvec3(15u);
        loc_58bb3 = arg_ccc49 + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        uvec3 loc_441ec = uvec3(arg_13804 - (floor(arg_13804 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_bb94e.VoxelBuffer[(arg_ccc49 + 4097u) + uint(var_b7fc0[arg_eae48])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    highp vec3 loc_5d636;
    func_33953(loc_58bb3, loc_5d636);
    arg_534d1 = loc_5d636;
}
void func_a3588(inout highp vec3 arg_a5dcd, inout highp vec3 arg_6139f, inout uint arg_75c69, inout highp vec3 arg_fadf1) {
    highp vec3 loc_1815d = arg_a5dcd - arg_6139f;
    int loc_dfc70 = ((((int(loc_1815d.x < 0.0) | (int(loc_1815d.x >= 16.0) << 1)) | (int(loc_1815d.y < 0.0) << 2)) | (int(loc_1815d.y >= 16.0) << 3)) | (int(loc_1815d.z < 0.0) << 4)) | (int(loc_1815d.z >= 16.0) << 5);
    if (var_b7fc0[loc_dfc70] < 0)
    {
        highp vec3 loc_27904;
        func_2ab53(loc_dfc70, loc_27904, arg_a5dcd, arg_6139f, arg_75c69);
        arg_fadf1 = loc_27904;
        return;
    }
    highp vec3 loc_08e85;
    func_ec180(loc_dfc70, arg_75c69, loc_08e85, arg_a5dcd, arg_6139f);
    arg_fadf1 = loc_08e85;
}
void func_269a6(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_924f2, inout uint arg_85962, inout ivec3 arg_5357c, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_02a32 = uvec3(arg_924f2);
        uint loc_e0607 = arg_85962 + ((loc_02a32.y + (loc_02a32.z * 16u)) + (loc_02a32.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_19b2e = vec3(arg_5357c);
    highp vec3 loc_45361;
    func_a3588(loc_19b2e, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_87677(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_283b9, inout uint arg_85962, inout ivec3 arg_438a8, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_ed900 = uvec3(arg_283b9 + ivec3(0, 0, 1));
        uint loc_e0607 = arg_85962 + ((loc_ed900.y + (loc_ed900.z * 16u)) + (loc_ed900.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_492df = vec3(arg_438a8 + ivec3(0, 0, 1));
    highp vec3 loc_45361;
    func_a3588(loc_492df, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_8e24a(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_5cd5c, inout uint arg_85962, inout ivec3 arg_6dd6f, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_9117a = uvec3(arg_5cd5c + ivec3(0, 1, 0));
        uint loc_e0607 = arg_85962 + ((loc_9117a.y + (loc_9117a.z * 16u)) + (loc_9117a.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_bcb98 = vec3(arg_6dd6f + ivec3(0, 1, 0));
    highp vec3 loc_45361;
    func_a3588(loc_bcb98, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_fd360(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_6740d, inout uint arg_85962, inout ivec3 arg_b3829, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_e4e26 = uvec3(arg_6740d + ivec3(0, 1, 1));
        uint loc_e0607 = arg_85962 + ((loc_e4e26.y + (loc_e4e26.z * 16u)) + (loc_e4e26.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_d9067 = vec3(arg_b3829 + ivec3(0, 1, 1));
    highp vec3 loc_45361;
    func_a3588(loc_d9067, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_0b7c2(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_ce1e5, inout uint arg_85962, inout ivec3 arg_a834e, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_388a8 = uvec3(arg_ce1e5 + ivec3(1, 0, 0));
        uint loc_e0607 = arg_85962 + ((loc_388a8.y + (loc_388a8.z * 16u)) + (loc_388a8.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_79192 = vec3(arg_a834e + ivec3(1, 0, 0));
    highp vec3 loc_45361;
    func_a3588(loc_79192, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_dcccf(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_90312, inout uint arg_85962, inout ivec3 arg_ab946, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_c1e8b = uvec3(arg_90312 + ivec3(1, 0, 1));
        uint loc_e0607 = arg_85962 + ((loc_c1e8b.y + (loc_c1e8b.z * 16u)) + (loc_c1e8b.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_e60d2 = vec3(arg_ab946 + ivec3(1, 0, 1));
    highp vec3 loc_45361;
    func_a3588(loc_e60d2, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_70277(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_5d8a7, inout uint arg_85962, inout ivec3 arg_a0082, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_5483e = uvec3(arg_5d8a7 + ivec3(1, 1, 0));
        uint loc_e0607 = arg_85962 + ((loc_5483e.y + (loc_5483e.z * 16u)) + (loc_5483e.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_f1e40 = vec3(arg_a0082 + ivec3(1, 1, 0));
    highp vec3 loc_45361;
    func_a3588(loc_f1e40, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_e43d6(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_eefc1, inout uint arg_85962, inout ivec3 arg_3528f, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_8b407 = uvec3(arg_eefc1 + ivec3(1));
        uint loc_e0607 = arg_85962 + ((loc_8b407.y + (loc_8b407.z * 16u)) + (loc_8b407.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_8f72a = vec3(arg_3528f + ivec3(1));
    highp vec3 loc_45361;
    func_a3588(loc_8f72a, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
#endif
void main() {
    highp vec3 var_86075 = v_projPosition;
    highp vec4 var_6a67c = v_texcoord0;
    highp vec2 var_3146f = (floor(v_texcoord0.xy * SceneResolutionAndRecipResolution.xy) + vec2(0.5)) * SceneResolutionAndRecipResolution.zw;
    var_6a67c.x = var_3146f.x;
    var_6a67c.y = var_3146f.y;
    highp vec2 var_1fa6b = var_6a67c.xy;
    var_1fa6b = vec2(var_1fa6b.x, 1.0 - var_1fa6b.y);
    highp float var_c2b62 = var_1fa6b.x;
    highp float var_ace1a = var_1fa6b.y;
    highp vec2 var_1f0c1 = vec2(var_c2b62, 1.0 - var_ace1a);
    var_1fa6b = var_1f0c1;
    highp vec2 var_ae1f9 = (var_1f0c1 * 2.0) - vec2(1.0);
    var_86075.x = var_ae1f9.x;
    var_86075.y = var_ae1f9.y;
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    highp vec4 var_af032 = texture(s_Normal, var_6a67c.xy);
    highp vec2 var_0d5fa = var_af032.xy;
    highp vec4 var_4435a = texture(s_SceneDepth, var_6a67c.xy);
    highp float var_5cef3 = (var_4435a.x * 2.0) - 1.0;
    highp vec4 var_604b0 = vec4(var_86075.xy, var_5cef3, 1.0);
    highp mat4 var_4fa47 = u_invProj;
    highp mat4 var_498b7 = u_invProj;
    highp mat4 var_4882d = u_invProj;
    highp mat4 var_78c1b = u_invProj;
    highp mat4 var_40575 = u_invProj;
    highp float var_eb413 = var_604b0.x;
    highp float var_ac116 = var_604b0.y;
    highp float var_f2b7c = var_604b0.w;
    highp float var_0357c = var_604b0.z;
    highp float var_2c821 = var_604b0.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_4fa47[0].x, var_ac116 * var_498b7[1].y, var_f2b7c * var_4882d[3].z, (var_0357c * var_78c1b[2].w) + (var_2c821 * var_40575[3].w));
    var_604b0 = var_9666f;
    highp float var_d799e = var_604b0.w;
    highp vec4 var_64ba6 = var_9666f / vec4(var_d799e);
    var_604b0 = var_64ba6;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_2bcb3 = vec4(var_86075.xy + vec2(SubPixelOffset.x, -SubPixelOffset.y), var_5cef3, 1.0);
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
    highp vec3 var_18300 = (u_invView * vec4(var_3ee7d.xyz, 1.0)).xyz - WorldOrigin.xyz;
    highp vec3 var_c6246 = var_3ee7d.xyz;
    highp vec3 var_30060 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_c6246)), normalize(dFdy(var_c6246)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_1e1c8 = vec3(QuantizationParameters.z * 0.5) - mod(var_18300, vec3(QuantizationParameters.z));
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    highp vec2 var_3ccf7 = var_0d5fa;
    highp vec3 var_6604f = vec3(var_af032.xy, (1.0 - abs(var_3ccf7.x)) - abs(var_3ccf7.y));
    highp vec2 var_46b19;
    if (var_6604f.z < 0.0)
    {
        var_46b19 = (vec2(1.0) - abs(var_6604f.yx)) * ((step(vec2(0.0), var_6604f.xy) * 2.0) - vec2(1.0));
    }
    else
    {
        var_46b19 = var_6604f.xy;
    }
    var_6604f.x = var_46b19.x;
    var_6604f.y = var_46b19.y;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_8e1a2 = normalize(normalize(var_6604f));
    highp vec3 var_5ef61 = normalize((u_view * vec4(var_8e1a2, 0.0)).xyz);
#endif
    highp vec4 var_16593 = texture(s_ColorMetalnessSubsurface, var_6a67c.xy);
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_4ac0e = var_16593;
    highp float var_dc7ce = clamp(2.007874011993408203125 * (var_4ac0e.w - 0.501960813999176025390625), 0.0, 1.0);
#endif
    uvec4 var_91eac = texelFetch(s_EmissiveAmbientLinearRoughness, ivec2(vec2(textureSize(s_EmissiveAmbientLinearRoughness, 0)) * var_6a67c.xy), 0);
#ifdef POINT_LIGHT_SHADING__OFF
    uvec4 var_8f579 = var_91eac;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    uvec4 var_a0fc9 = var_91eac;
    uint var_4b676 = var_a0fc9.x & 65535u;
    uvec2 var_49e6b = uvec2(var_4b676 >> 8u, var_4b676 & 255u);
    highp vec2 var_c01c5 = vec2(float(var_49e6b.x), float(var_49e6b.y)) * vec2(0.0039215688593685626983642578125);
    uvec4 var_8f579 = var_91eac;
#endif
    highp float var_8a297 = float(var_8f579.w & 255u) * 0.0039215688593685626983642578125;
    uvec2 var_c02ad = var_91eac.yz;
    uint var_39af7 = var_c02ad.x & 65535u;
    uint var_32bfc = var_c02ad.y & 65535u;
    highp vec4 var_bfd02 = vec4(uvec4(var_39af7 >> 8u, var_39af7 & 255u, var_32bfc >> 8u, var_32bfc & 255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 var_1f94c = var_bfd02;
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
    highp vec4 var_95d52 = vec4((var_bfd02.xyz * var_1f94c.w) * 6.0, float(((var_91eac.w & 61696u) & 65535u) >> 8u) * 0.0039215688593685626983642578125);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_477c2 = (u_invView * vec4(var_64ba6.xyz, 1.0)).xyz;
    highp vec3 var_b8b72 = var_64ba6.xyz;
    highp vec3 var_1375d = vec3(var_86075.xy, var_5cef3);
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
    highp vec3 var_d4eff = var_16593.xyz;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec4 var_95d52 = vec4((var_bfd02.xyz * var_1f94c.w) * 6.0, float(((var_91eac.w & 61696u) & 65535u) >> 8u) * 0.0039215688593685626983642578125);
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
    uint var_dee15 = ((((var_91eac.w & 3584u) & 65535u) >> 8u) >> uint(1)) & 7u;
    ivec3 var_e68c0;
    func_2dbd9(var_dee15, var_e68c0);
    highp vec3 var_6ac3a = vec3(var_e68c0);
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec4 var_33613 = var_95d52;
    bool var_7cf61 = any(notEqual(var_6ac3a, vec3(0.0)));
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
    highp vec3 var_d4eff = var_16593.xyz;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec3 var_a23f6;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_b2786;
    func_9b87e(var_b2786, var_d4eff);
    highp vec3 var_515f2 = vec3(0.039999999105930328369140625 * (1.0 - var_dc7ce)) + (var_b2786 * var_dc7ce);
    highp vec3 var_bb88d = var_1375d;
    highp vec3 var_c5dd0 = -(var_b8b72 / vec3(length(var_b8b72) + 9.9999997473787516355514526367188e-05));
    highp float var_c6ac5 = clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_4ac0e.w), 0.0, 1.0) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
    highp vec3 var_39930;
    highp vec3 var_950c6;
    if (var_bb88d.z != 1.0)
    {
        highp vec3 var_5ea35;
        highp vec3 var_3cf91;
        func_2a836(var_3cf91, var_5ea35, var_18300, var_1e1c8, var_30060, var_477c2, var_b8b72, var_5ef61, var_c5dd0, var_c01c5, var_515f2, var_dc7ce, var_8e1a2, var_c6ac5);
        var_950c6 = var_3cf91;
        var_39930 = var_5ea35;
    }
    else
    {
        var_950c6 = vec3(0.0);
        var_39930 = vec3(0.0);
    }
    highp vec4 var_e3941 = var_95d52;
    bool var_7cf61 = any(notEqual(var_6ac3a, vec3(0.0)));
    highp vec3 var_a23f6;
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
    if (var_7cf61)
    {
        var_a23f6 = var_6ac3a;
    }
    else
    {
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
        var_a23f6 = normalize(normalize(var_6604f));
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
        var_a23f6 = var_8e1a2;
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
    }
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
    bool var_ef987 = DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0;
    bool var_32cd7;
    if (var_ef987)
    {
        var_32cd7 = DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled.z != 0.0;
    }
    else
    {
        var_32cd7 = var_ef987;
    }
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
    highp vec3 var_f07c9;
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
    highp vec3 var_39930;
    highp vec3 var_f07c9;
    if (var_bb88d.z != 1.0)
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    if ((DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled.z != 0.0) && (!((uint(floor(var_33613.w * 255.0)) & 1u) != 0u)))
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
    if (var_32cd7 && (!((uint(floor(var_e3941.w * 255.0)) & 1u) != 0u)))
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    {
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
        highp vec3 var_2f804 = (u_invView * vec4(var_64ba6.xyz, 1.0)).xyz - WorldOrigin.xyz;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
        highp vec3 var_2f804 = var_477c2 - WorldOrigin.xyz;
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
        bool var_6aa68;
        if (var_7cf61)
        {
            highp float var_056f4 = dot(var_2f804, abs(var_a23f6));
            var_6aa68 = abs(var_056f4 - round(var_056f4)) > 0.001000000047497451305389404296875;
        }
        else
        {
            var_6aa68 = var_7cf61;
        }
        highp vec3 var_1939b = (var_2f804 - vec3(0.5)) + (var_a23f6 * 0.0199999995529651641845703125);
        highp vec3 var_6d520 = var_a23f6;
        highp vec3 var_2e7d8 = floor(var_1939b * 0.0625) * 16.0;
        highp vec3 var_ed65b = var_1939b - var_2e7d8;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
        ivec4 var_7e91f = ivec4(ivec3(floor(vec3(ivec3(floor(var_1939b))) * vec3(0.0625))), 0);
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
        ivec4 var_7e91f = ivec4(ivec3(floor(vec3(ivec3(floor(var_1939b))) * vec3(0.0625))), 2);
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
        ivec4 var_cff55 = var_7e91f;
        int var_ab334 = (var_cff55.x & 65535) | (var_cff55.y << 16);
        int var_76717 = (var_cff55.z & 65535) | (var_cff55.w << 16);
        ivec4 var_4e614 = var_7e91f;
        uint var_8af53 = uint(var_4e614.x) * 1540483477u;
        uint var_330d0 = uint(var_4e614.y) * 1540483477u;
        uint var_3870b = uint(var_4e614.z) * 1540483477u;
        uint var_30f73 = uint(var_4e614.w) * 1540483477u;
        uint var_5376d = ((((((2293326976u ^ ((var_8af53 ^ (var_8af53 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_330d0 ^ (var_330d0 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_3870b ^ (var_3870b >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_30f73 ^ (var_30f73 >> uint(24))) * 1540483477u);
        uint var_d02c9 = (var_5376d ^ (var_5376d >> uint(13))) * 1540483477u;
        uint var_15a6d = var_d02c9 ^ (var_d02c9 >> uint(15));
        uint var_c6bd0 = (var_15a6d ^ (var_15a6d >> uint(16))) & 65535u;
        uint var_c4ba2 = var_c6bd0 | uint(var_c6bd0 == 0u);
        uint var_980a9 = uint(GpuEntryBufferCapacity.x);
        int var_d6224;
        uint var_75570;
        bool var_87a71;
        uint var_8e0b6;
        var_8e0b6 = 0u;
        var_87a71 = false;
        var_75570 = var_c4ba2 & (var_980a9 - 1u);
        var_d6224 = 0;
        bool var_4f504;
        uint var_d350f;
        uint var_e1ab1;
        uint var_79d95;
        bool var_a0c0a;
        for (;;)
        {
            if (var_d6224 < 8)
            {
                uint var_a70f2 = uint(var_47f76.GpuEntryBuffer[var_75570].hash) & 65535u;
                bool var_734de = var_a70f2 == var_c4ba2;
                bool var_e4213;
                if (var_734de)
                {
                    var_e4213 = var_47f76.GpuEntryBuffer[var_75570].packed_xy == var_ab334;
                }
                else
                {
                    var_e4213 = var_734de;
                }
                bool var_ec5a7;
                if (var_e4213)
                {
                    var_ec5a7 = var_47f76.GpuEntryBuffer[var_75570].packed_zw == var_76717;
                }
                else
                {
                    var_ec5a7 = var_e4213;
                }
                if (var_87a71)
                {
                    var_e1ab1 = var_8e0b6;
                }
                else
                {
                    uint var_5ebd4;
                    if (var_ec5a7)
                    {
                        var_5ebd4 = uint(var_47f76.GpuEntryBuffer[var_75570].user_data);
                    }
                    else
                    {
                        var_5ebd4 = var_8e0b6;
                    }
                    var_e1ab1 = var_5ebd4;
                }
                var_4f504 = var_87a71 || var_ec5a7;
                var_d350f = (var_75570 + 1u) & (var_980a9 - 1u);
                if (var_4f504 || (var_a70f2 == 0u))
                {
                    var_a0c0a = var_4f504;
                    var_79d95 = var_e1ab1;
                    break;
                }
                var_8e0b6 = var_e1ab1;
                var_87a71 = var_4f504;
                var_75570 = var_d350f;
                var_d6224++;
                continue;
            }
            else
            {
                var_a0c0a = var_87a71;
                var_79d95 = var_8e0b6;
                break;
            }
        }
        uint var_7cd4b = var_79d95 >> 2u;
        highp vec3 var_63ffa;
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
        highp vec3 var_acaee;
        highp vec3 var_63ffa;
        func_2a836(var_63ffa, var_acaee, var_18300, var_1e1c8, var_30060, var_477c2, var_b8b72, var_5ef61, var_c5dd0, var_c01c5, var_515f2, var_dc7ce, var_8e1a2, var_c6ac5);
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
        if (var_a0c0a)
        {
            highp vec3 var_5a967 = var_1939b + vec3(0.5);
            highp vec3 var_1cdfc = var_5a967;
            highp float var_63d52;
            if (var_6d520.x > 0.0)
            {
                var_63d52 = ceil(var_1cdfc.x) - 1.0;
            }
            else
            {
                var_63d52 = floor(var_1cdfc.x);
            }
            highp float var_8ec6a;
            if (var_6d520.y > 0.0)
            {
                var_8ec6a = ceil(var_1cdfc.y) - 1.0;
            }
            else
            {
                var_8ec6a = floor(var_1cdfc.y);
            }
            highp float var_87b77;
            if (var_6d520.z > 0.0)
            {
                var_87b77 = ceil(var_1cdfc.z) - 1.0;
            }
            else
            {
                var_87b77 = floor(var_1cdfc.z);
            }
            ivec3 var_ffa79 = ivec3(int(var_63d52), int(var_8ec6a), int(var_87b77));
            ivec3 var_6465d = clamp(ivec3(round(var_5a967)) - ivec3(1), var_ffa79 - ivec3(1), var_ffa79);
            ivec3 var_9b1c3 = var_6465d - ivec3(var_2e7d8);
            ivec3 var_6b6eb = var_9b1c3;
            uint var_bd8ca;
            func_fff8e(var_7cd4b, var_6b6eb, var_bd8ca, var_9b1c3);
            uint var_dea39;
            uint var_72ac2;
            if (dot(var_a23f6, var_a23f6) > 0.0)
            {
                uvec3 var_64769 = uvec3(var_ffa79 - var_6465d);
                uint var_73565 = ((var_64769.x * 4u) + (var_64769.y * 2u)) + var_64769.z;
                uint var_d8b01;
                if (var_6aa68)
                {
                    var_d8b01 = var_bd8ca & (~(1u << var_73565));
                }
                else
                {
                    var_d8b01 = var_bd8ca;
                }
                highp vec3 var_c5090 = abs(var_a23f6);
                bool var_e69eb = var_c5090.x >= var_c5090.y;
                bool var_5e8e6;
                if (var_e69eb)
                {
                    var_5e8e6 = var_c5090.x >= var_c5090.z;
                }
                else
                {
                    var_5e8e6 = var_e69eb;
                }
                uint var_a5020;
                if (var_5e8e6)
                {
                    var_a5020 = 0u;
                }
                else
                {
                    uint var_72a09;
                    if (var_c5090.y >= var_c5090.z)
                    {
                        var_72a09 = 1u;
                    }
                    else
                    {
                        var_72a09 = 2u;
                    }
                    var_a5020 = var_72a09;
                }
                uint var_9d8e5;
                if ((var_d8b01 & (1u << var_73565)) != 0u)
                {
                    var_9d8e5 = var_73565 ^ var_40c4f[var_a5020];
                }
                else
                {
                    var_9d8e5 = var_73565;
                }
                uint var_b34d3;
                if ((var_9d8e5 & var_40c4f[var_a5020]) != 0u)
                {
                    var_b34d3 = var_4d3a3[var_a5020] ^ 255u;
                }
                else
                {
                    var_b34d3 = var_4d3a3[var_a5020];
                }
                uint var_5ff8b = (var_40c4f[var_a5020] == 4u) ? 2u : 4u;
                uint var_ea2c2 = (var_40c4f[var_a5020] == 1u) ? 2u : 1u;
                uint var_66a4f = (1u << (var_9d8e5 ^ var_5ff8b)) | (1u << (var_9d8e5 ^ var_ea2c2));
                uint var_c97e0;
                if ((var_d8b01 & var_66a4f) == var_66a4f)
                {
                    var_c97e0 = var_b34d3 | (1u << ((var_9d8e5 ^ var_5ff8b) ^ var_ea2c2));
                }
                else
                {
                    var_c97e0 = var_b34d3;
                }
                var_72ac2 = var_9d8e5;
                var_dea39 = var_c97e0 | var_d8b01;
            }
            else
            {
                var_72ac2 = 0u;
                var_dea39 = var_bd8ca;
            }
            highp vec3 var_0a31b;
            if (var_7cf61)
            {
                highp vec3 var_8bf4b = abs(var_a23f6);
                highp vec3 var_e2369 = var_8bf4b.zxy;
                highp vec3 var_998ba = var_8bf4b.yzx;
                highp float var_27fb9 = dot(var_ed65b, var_e2369);
                highp float var_ec7ec = dot(var_ed65b, var_998ba);
                highp float var_250b7 = floor(var_27fb9);
                highp float var_d1328 = floor(var_ec7ec);
                highp vec3 var_685e3 = ((var_8bf4b * dot(vec3(var_9b1c3 + ivec3(uvec3(uint((var_72ac2 & 4u) != 0u), uint((var_72ac2 & 2u) != 0u), uint((var_72ac2 & 1u) != 0u)))), var_8bf4b)) + (var_e2369 * var_250b7)) + (var_998ba * var_d1328);
                ivec3 var_d9715 = ivec3(var_685e3);
                ivec3 var_cf607 = ivec3(var_685e3 + var_e2369);
                ivec3 var_2f6b4 = ivec3(var_685e3 + var_998ba);
                ivec3 var_01f99 = ivec3((var_685e3 + var_e2369) + var_998ba);
                ivec3 var_00d8b[4] = ivec3[](var_d9715, var_cf607, var_2f6b4, var_01f99);
                highp vec2 var_e4a1f = vec2(var_27fb9 - var_250b7, var_ec7ec - var_d1328);
                highp vec3 var_0ce08;
                func_fc671(var_cf607, var_d9715, var_2f6b4, var_9b1c3, var_dea39, var_01f99, var_7cd4b, var_00d8b, var_2e7d8, var_0ce08, var_e4a1f);
                var_0a31b = var_0ce08;
            }
            else
            {
                highp vec3 var_1d6fd = clamp(fract(var_1939b), vec3(0.0), vec3(1.0));
                ivec3 var_095fb = var_6465d - ivec3(var_2e7d8);
                bool var_0ef27 = all(greaterThanEqual(var_095fb, ivec3(0)));
                bool var_05ccd;
                if (var_0ef27)
                {
                    var_05ccd = all(lessThan(var_095fb, ivec3(15)));
                }
                else
                {
                    var_05ccd = var_0ef27;
                }
                highp float var_8c271 = float((var_dea39 & 1u) == 0u);
                highp float var_ab029 = float((var_dea39 & 2u) == 0u);
                highp float var_e5766 = float((var_dea39 & 4u) == 0u);
                highp float var_5b0d6 = float((var_dea39 & 8u) == 0u);
                highp float var_acb4b = float((var_dea39 & 16u) == 0u);
                highp float var_4ee2e = float((var_dea39 & 32u) == 0u);
                highp float var_30f1d = float((var_dea39 & 64u) == 0u);
                highp float var_82b80 = float((var_dea39 & 128u) == 0u);
                highp vec3 var_7ee7f;
                func_269a6(var_8c271, var_7ee7f, var_05ccd, var_095fb, var_7cd4b, var_6465d, var_2e7d8);
                highp vec3 var_61fee;
                func_87677(var_ab029, var_61fee, var_05ccd, var_095fb, var_7cd4b, var_6465d, var_2e7d8);
                highp vec3 var_2d7b2;
                func_8e24a(var_e5766, var_2d7b2, var_05ccd, var_095fb, var_7cd4b, var_6465d, var_2e7d8);
                highp vec3 var_8d415;
                func_fd360(var_5b0d6, var_8d415, var_05ccd, var_095fb, var_7cd4b, var_6465d, var_2e7d8);
                highp vec3 var_d44c6;
                func_0b7c2(var_acb4b, var_d44c6, var_05ccd, var_095fb, var_7cd4b, var_6465d, var_2e7d8);
                highp vec3 var_dd80a;
                func_dcccf(var_4ee2e, var_dd80a, var_05ccd, var_095fb, var_7cd4b, var_6465d, var_2e7d8);
                highp vec3 var_f3e62;
                func_70277(var_30f1d, var_f3e62, var_05ccd, var_095fb, var_7cd4b, var_6465d, var_2e7d8);
                highp vec3 var_93e8b;
                func_e43d6(var_82b80, var_93e8b, var_05ccd, var_095fb, var_7cd4b, var_6465d, var_2e7d8);
                highp float var_81471 = 1.0 - var_1d6fd.x;
                highp float var_7f7a1 = 1.0 - var_1d6fd.y;
                highp float var_89196 = 1.0 - var_1d6fd.z;
                highp float var_378db = ((var_81471 * var_7f7a1) * var_89196) * var_8c271;
                highp float var_32cd4 = ((var_81471 * var_7f7a1) * var_1d6fd.z) * var_ab029;
                highp float var_082e6 = ((var_81471 * var_1d6fd.y) * var_89196) * var_e5766;
                highp float var_16f28 = ((var_81471 * var_1d6fd.y) * var_1d6fd.z) * var_5b0d6;
                highp float var_54764 = ((var_1d6fd.x * var_7f7a1) * var_89196) * var_acb4b;
                highp float var_3324d = ((var_1d6fd.x * var_7f7a1) * var_1d6fd.z) * var_4ee2e;
                highp float var_b7dec = ((var_1d6fd.x * var_1d6fd.y) * var_89196) * var_30f1d;
                highp float var_30d9c = ((var_1d6fd.x * var_1d6fd.y) * var_1d6fd.z) * var_82b80;
                highp float var_fe1c0 = ((((((var_378db + var_32cd4) + var_082e6) + var_16f28) + var_54764) + var_3324d) + var_b7dec) + var_30d9c;
                highp vec3 var_4cdcf;
                if (var_fe1c0 > 0.0)
                {
                    var_4cdcf = ((((((((var_7ee7f * var_378db) + (var_61fee * var_32cd4)) + (var_2d7b2 * var_082e6)) + (var_8d415 * var_16f28)) + (var_d44c6 * var_54764)) + (var_dd80a * var_3324d)) + (var_f3e62 * var_b7dec)) + (var_93e8b * var_30d9c)) / vec3(var_fe1c0);
                }
                else
                {
                    var_4cdcf = vec3(0.0);
                }
                var_0a31b = var_4cdcf;
            }
            var_63ffa = var_0a31b;
        }
        else
        {
            var_63ffa = vec3(0.0);
        }
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
        var_f07c9 = var_63ffa;
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
        var_39930 = var_acaee;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    }
    else
    {
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
        var_f07c9 = vec3(0.0);
        var_39930 = vec3(0.0);
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
        var_f07c9 = var_95d52.xyz;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    }
#endif
    highp vec4 var_92054 = SkyAmbientLightColorIntensity;
    highp float var_46bec = var_8a297 * var_8a297;
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec3 var_67064 = vec3(var_86075.xy, (texture(s_SceneDepth, var_6a67c.xy).x * 2.0) - 1.0);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_67064 = var_1375d;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec3 var_67064 = vec3(var_86075.xy, var_5cef3);
#endif
    highp float var_c0c38 = ((var_67064.z * 0.5) + 0.5) * 65535.0;
    highp float var_fd346 = floor(var_c0c38);
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    bgfx_FragData0 = vec4((texture(s_Normal, var_6a67c.xy).xy * 0.5) + vec2(0.5), var_fd346 * 1.525902189314365386962890625e-05, var_c0c38 - var_fd346);
    bgfx_FragData1 = vec4(((vec3(1.0) * (1.0 - clamp(2.007874011993408203125 * (var_16593.w - 0.501960813999176025390625), 0.0, 1.0))) * max((vec4((var_bfd02.xyz * var_1f94c.w) * 6.0, var_6c9b6).xyz * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_46bec * var_46bec) * var_8a297, (var_8a297 * var_8a297) * var_8a297, CameraLightIntensity.y)) * var_92054.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w, 1.0);
    bgfx_FragData2 = vec4(0.0, 0.0, 0.0, 1.0);
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    bgfx_FragData0 = vec4((var_0d5fa * 0.5) + vec2(0.5), var_fd346 * 1.525902189314365386962890625e-05, var_c0c38 - var_fd346);
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
    bgfx_FragData1 = vec4(var_f07c9 + (((vec3(1.0) * (1.0 - var_dc7ce)) * max((vec4((var_bfd02.xyz * var_1f94c.w) * 6.0, var_6c9b6).xyz * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_46bec * var_46bec) * var_8a297, (var_8a297 * var_8a297) * var_8a297, CameraLightIntensity.y)) * var_92054.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w), 1.0);
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
    bgfx_FragData1 = vec4(var_950c6 + (((vec3(1.0) * (1.0 - var_dc7ce)) * max((var_f07c9 * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_46bec * var_46bec) * var_8a297, (var_8a297 * var_8a297) * var_8a297, CameraLightIntensity.y)) * var_92054.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w), 1.0);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    bgfx_FragData2 = vec4(var_39930, 1.0);
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    bgfx_FragData1 = vec4(((vec3(1.0) * (1.0 - clamp(2.007874011993408203125 * (var_16593.w - 0.501960813999176025390625), 0.0, 1.0))) * max((var_f07c9 * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_46bec * var_46bec) * var_8a297, (var_8a297 * var_8a297) * var_8a297, CameraLightIntensity.y)) * var_92054.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w, 1.0);
    bgfx_FragData2 = vec4(0.0, 0.0, 0.0, 1.0);
#endif
}
