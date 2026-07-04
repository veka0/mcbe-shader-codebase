#version 310 es

/*
* Available Macros:
*
* Passes:
* - CAUSTICS_MULTIPLIER_PASS (not used)
* - DIRECTIONAL_LIGHTING_PASS (not used)
* - DIRECTIONAL_LIGHTING_PASS0_PASS (not used)
* - DIRECTIONAL_LIGHTING_PASS1_PASS (not used)
* - DISCRETE_INDIRECT_COMBINED_LIGHTING_PASS (not used)
* - FALLBACK_PASS (not used)
* - SURFACE_RADIANCE_UPSCALE_PASS (not used)
* - TILE_CLASSIFICATION_PASS (not used)
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
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_NormalsAndDepthLighting;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform lowp sampler2D s_SpecularLighting;
* - layout(binding = 14, std430) buffer s_zGpuEntryBufferBuffer { GpuVolumeEntry s_zGpuEntryBuffer[]; };
* - layout(binding = 15, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 16, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
* - layout(binding = 17, std430) buffer s_zVoxelBufferBuffer { VoxelNode s_zVoxelBuffer[]; };
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
* - uniform vec4 TilingParams;
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

#ifdef POINT_LIGHT_SHADING__ON
#extension GL_EXT_texture_cube_map_array : require
#endif
precision mediump float;
precision highp int;
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
struct Light {
    highp vec4 position;
    highp vec4 color;
    int shadowProbeIndex;
    int id;
    int pad0;
    int pad1;
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
const int var_d93d2[64] = int[](-1, 2, 3, -1, 0, 6, 7, -1, 1, 10, 11, -1, -1, -1, -1, -1, 4, 14, 16, -1, 8, 18, 20, -1, 12, 22, 24, -1, -1, -1, -1, -1, 5, 15, 17, -1, 9, 19, 21, -1, 13, 23, 25, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
struct GpuVolumeEntry {
    int packed_xy;
    int packed_zw;
    int hash;
    int user_data;
};
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)

#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
int var_e5848;
layout(binding = 16, std430) buffer s_zLights { Light zLights[]; } var_9a53b;
layout(binding = 15, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_43367;
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
const uvec3 var_89819[8] = uvec3[](uvec3(0u, 0u, 1u), uvec3(0u, 0u, 1u), uvec3(0u, 1u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u), uvec3(1u, 0u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u));
const uvec3 var_54404[8] = uvec3[](uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(0u, 1u, 1u), uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 1u, 0u), uvec3(1u, 1u, 0u));
const vec3 var_fd1f1[8] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(1.0, 0.0, 0.0), vec3(1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(1.0, 0.0, 0.0));
const vec3 var_93959[8] = vec3[](vec3(0.0, 1.0, 1.0), vec3(1.0, 0.0, 1.0), vec3(0.0, 1.0, 1.0), vec3(0.0, 1.0, 1.0), vec3(1.0, 0.0, 1.0), vec3(1.0, 0.0, 1.0), vec3(1.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0));
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
struct Light {
    highp vec4 position;
    highp vec4 color;
    int shadowProbeIndex;
    int id;
    int pad0;
    int pad1;
};

struct LightData {
    highp float lookup;
};

int var_e5848;
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
layout(binding = 17, std430) buffer s_zVoxelBuffer { VoxelNode zVoxelBuffer[]; } var_fd862;
layout(binding = 14, std430) buffer s_zGpuEntryBuffer { GpuVolumeEntry zGpuEntryBuffer[]; } var_41ba9;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
layout(binding = 16, std430) buffer s_zLights { Light zLights[]; } var_9a53b;
layout(binding = 15, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_43367;
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
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
uniform highp sampler2D s_SceneDepth;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
#endif
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
in highp vec3 v_projPosition;
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
        arg_e45b8 = var_e5848;
        arg_fadf1 = var_e5848;
        arg_d7f4c = false;
        return;
    }
    int loc_14533 = int((loc_05e3f.x + (loc_05e3f.y * ClusterDimensions.x)) + ((loc_05e3f.z * ClusterDimensions.x) * ClusterDimensions.y)) * int(ClusterDimensions.w);
    arg_e45b8 = loc_14533 + int(ClusterDimensions.w);
    arg_fadf1 = loc_14533;
    arg_d7f4c = true;
}
void func_bbb6d(inout int arg_826b5, inout highp float arg_9eee0, inout highp float arg_6b488, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c, inout highp float arg_77c90) {
    if (var_9a53b.zLights[arg_826b5].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        arg_6b488 = 1.0;
        return;
    }
    highp vec3 loc_44ea9 = arg_aee55 - var_9a53b.zLights[arg_826b5].position.xyz;
    highp vec3 loc_0b3e9 = abs(loc_44ea9);
    bool loc_ab77c = loc_0b3e9.x >= loc_0b3e9.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_0b3e9.x >= loc_0b3e9.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    if (loc_ca7f9)
    {
        loc_0b3e9 = vec3(loc_0b3e9.y, loc_0b3e9.z, loc_0b3e9.x);
    }
    else
    {
        if (loc_0b3e9.y >= loc_0b3e9.z)
        {
            loc_0b3e9 = vec3(loc_0b3e9.x, loc_0b3e9.z, loc_0b3e9.y);
        }
    }
    highp vec4 loc_6114a = PointLightProj * vec4(loc_0b3e9, 1.0);
    highp float loc_2f407 = clamp(dot(normalize(-loc_44ea9), normalize(arg_1111c)), PointLightNdLFloor.x, 1.0);
    loc_6114a.z -= (PointLightShadowParams1.x + (PointLightShadowParams1.y * (sqrt(1.0 - (loc_2f407 * loc_2f407)) / loc_2f407)));
    loc_6114a /= vec4(loc_6114a.w);
    highp vec3 loc_f715f = loc_44ea9;
    bool loc_fe444 = abs(loc_f715f.y) > abs(loc_f715f.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_f715f.y) > abs(loc_f715f.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_f715f.z *= (-1.0);
    }
    else
    {
        loc_f715f.y *= (-1.0);
    }
    highp float loc_e670f = (textureLod(s_PointLightShadowTextureArray, vec4(loc_f715f, float(var_9a53b.zLights[arg_826b5].shadowProbeIndex)), 0.0).x * 2.0) - 1.0;
    highp float loc_591c8;
    if (loc_e670f >= loc_6114a.z)
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
        highp vec4 loc_932a9 = PointLightInvProj * vec4(loc_6114a.xy, loc_e670f, 1.0);
        highp vec4 loc_85f94 = loc_932a9;
        highp float loc_0585d = loc_85f94.w;
        highp vec3 loc_6d5dc = loc_932a9.xyz / vec3(loc_0585d);
        loc_85f94 = vec4(loc_6d5dc.x, loc_6d5dc.y, loc_6d5dc.z, loc_932a9.w);
        loc_d7fd8 = 1.0 - smoothstep(0.0, 1.0, (length(loc_0b3e9) - length(loc_6d5dc.xyz)) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z);
    }
    else
    {
        loc_d7fd8 = 1.0;
    }
    arg_9eee0 = loc_d7fd8;
    arg_6b488 = loc_591c8;
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
    highp vec3 loc_8dfd7 = var_9a53b.zLights[arg_0b9bc].position.xyz - arg_29ac4;
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
    if (loc_9eb1a >= (var_9a53b.zLights[arg_0b9bc].position.w * var_9a53b.zLights[arg_0b9bc].position.w))
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
        func_bbb6d(arg_0b9bc, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_a011d = loc_b2a04;
        loc_cddfe = loc_412fd;
    }
    else
    {
        loc_a011d = 1.0;
        loc_cddfe = 1.0;
    }
    highp float loc_4c5a5 = loc_9eb1a / ((var_9a53b.zLights[arg_0b9bc].position.w * var_9a53b.zLights[arg_0b9bc].position.w) + 9.9999997473787516355514526367188e-05);
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
        highp vec3 loc_8226d = var_9a53b.zLights[arg_0b9bc].color.xyz * loc_219c5;
        arg_e84ec = vec4(loc_8226d.x, loc_8226d.y, loc_8226d.z, arg_e84ec.w);
        arg_e84ec.w = 1.0 - (loc_9eb1a / ((var_9a53b.zLights[arg_0b9bc].position.w * var_9a53b.zLights[arg_0b9bc].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_0a2b9 = (var_9a53b.zLights[arg_0b9bc].color.xyz * var_9a53b.zLights[arg_0b9bc].color.w) * loc_219c5;
}
void func_83c45(inout highp vec3 arg_33c3b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec4 arg_fadf1, inout highp vec3 arg_efe4b, inout highp vec3 arg_81f79, inout highp vec2 arg_92c2f, inout highp vec3 arg_58ffc, inout highp float arg_d96ac, inout highp vec3 arg_e6b36, inout highp vec3 arg_b8e73, inout highp vec3 arg_775e2, inout highp float arg_bfa42) {
    highp vec4 loc_a386e = vec4(0.0);
    bool loc_a0bb1;
    int loc_490eb;
    int loc_c476d;
    func_06412(arg_33c3b, loc_c476d, loc_490eb, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        arg_fadf1 = loc_a386e;
        return;
    }
    int loc_23246;
    highp vec3 loc_45a05;
    highp vec3 loc_b9311;
    loc_b9311 = vec3(0.0);
    loc_45a05 = vec3(0.0);
    loc_23246 = 0;
    int loc_62c27;
    highp vec3 loc_50935;
    highp vec3 loc_bfd6d;
    highp vec4 loc_6407e;
    for (int loc_86630 = loc_490eb; loc_86630 < loc_c476d; loc_b9311 = loc_bfd6d, loc_45a05 = loc_50935, loc_23246 = loc_62c27, loc_86630++)
    {
        int loc_dbe64 = int(var_43367.zLightLookupArray[loc_86630].lookup);
        if (loc_dbe64 < 0)
        {
            break;
        }
        highp vec3 loc_ed90f = normalize((u_view * vec4(var_9a53b.zLights[loc_dbe64].position.xyz, 1.0)).xyz - arg_33c3b);
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
        loc_62c27 = loc_23246 + 1;
        highp vec3 loc_49548;
        highp float loc_bbe0d;
        highp float loc_0721a;
        func_b155c(loc_6407e, loc_dbe64, loc_0721a, loc_bbe0d, loc_49548, arg_e6b36, arg_b8e73, arg_775e2, arg_bfa42);
        loc_a386e += loc_6407e;
        loc_50935 = loc_45a05 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_bfa42)) * (loc_ec1c7 * vec3(0.3183098733425140380859375))) * loc_bbe0d) + (((loc_ec1c7 * vec3(0.3183098733425140380859375)) * (arg_bfa42 * max((dot(-arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_0721a)) * loc_49548) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_bfd6d = loc_b9311 + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_bbe0d) * loc_49548) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    if (loc_23246 > 0)
    {
        highp vec3 loc_6dcb8 = loc_a386e.xyz / vec3(float(loc_23246));
        loc_a386e = vec4(loc_6dcb8.x, loc_6dcb8.y, loc_6dcb8.z, loc_a386e.w);
        loc_a386e.w /= float(loc_23246);
    }
    arg_534d1 = loc_45a05;
    arg_90b60 = loc_b9311;
    arg_fadf1 = loc_a386e;
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
    func_83c45(arg_6f73b, loc_5ded5, loc_46c24, loc_750c4, arg_56f56, arg_9c753, arg_a995c, arg_7e9dc, arg_4e72a, arg_68647, loc_62dd1, arg_602b8, arg_15153);
    arg_534d1 = loc_5ded5;
    arg_90b60 = loc_46c24;
    arg_d4ca2 = loc_750c4;
}
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
void func_f73f0(inout uint arg_a6daa, inout highp vec3 arg_aa7d7) {
    if (var_fd862.zVoxelBuffer[arg_a6daa].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_96d01 = vec4(uvec4(var_fd862.zVoxelBuffer[arg_a6daa].data, var_fd862.zVoxelBuffer[arg_a6daa].data >> 8u, var_fd862.zVoxelBuffer[arg_a6daa].data >> 16u, var_fd862.zVoxelBuffer[arg_a6daa].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_96d01;
    arg_aa7d7 = (loc_96d01.xyz * loc_3ff2a.w) * 6.0;
}
void func_968b0(inout highp vec3 arg_cbb88, inout highp vec3 arg_951a8, inout uint arg_b5a6d, inout highp vec3 arg_cfabd) {
    highp vec3 loc_1815d = arg_cbb88 - arg_951a8;
    int loc_1a9f5 = ((((int(loc_1815d.x < 0.0) | (int(loc_1815d.x >= 16.0) << 1)) | (int(loc_1815d.y < 0.0) << 2)) | (int(loc_1815d.y >= 16.0) << 3)) | (int(loc_1815d.z < 0.0) << 4)) | (int(loc_1815d.z >= 16.0) << 5);
    if (var_d93d2[loc_1a9f5] < 0)
    {
        uvec3 loc_23b8c = uvec3(arg_cbb88 - arg_951a8) & uvec3(15u);
        uint loc_e0607 = arg_b5a6d + ((loc_23b8c.y + (loc_23b8c.z * 16u)) + (loc_23b8c.x * 256u));
        highp vec3 loc_bf963;
        func_f73f0(loc_e0607, loc_bf963);
        arg_cfabd = loc_bf963;
        return;
    }
    if (!((var_fd862.zVoxelBuffer[arg_b5a6d + 4096u].data & (1u << uint(var_d93d2[loc_1a9f5]))) != 0u))
    {
        arg_cfabd = vec3(0.0);
        return;
    }
    uvec3 loc_27255 = uvec3(arg_cbb88 - (floor(arg_cbb88 * 0.0625) * 16.0)) & uvec3(15u);
    uint loc_8f6af = (var_fd862.zVoxelBuffer[(arg_b5a6d + 4097u) + uint(var_d93d2[loc_1a9f5])].data >> 2u) + ((loc_27255.y + (loc_27255.z * 16u)) + (loc_27255.x * 256u));
    highp vec3 loc_5d636;
    func_f73f0(loc_8f6af, loc_5d636);
    arg_cfabd = loc_5d636;
}
#endif
void main() {
    highp vec2 var_6460b = (floor(v_texcoord0.xy * SceneResolutionAndRecipResolution.xy) + vec2(0.5)) * SceneResolutionAndRecipResolution.zw;
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    highp vec4 var_af032 = texture(s_Normal, var_6460b.xy);
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec2 var_9279d = var_6460b.xy;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    highp vec2 var_1ba39 = var_af032.xy;
    highp vec2 var_9279d = var_6460b.xy;
    highp vec4 var_4435a = texture(s_SceneDepth, var_6460b.xy);
    highp float var_6abed = (var_4435a.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_6abed, 1.0);
    highp mat4 var_4fa47 = u_invProj;
    highp mat4 var_498b7 = u_invProj;
    highp mat4 var_4882d = u_invProj;
    highp mat4 var_78c1b = u_invProj;
    highp mat4 var_40575 = u_invProj;
    highp float var_eb413 = var_df846.x;
    highp float var_ac116 = var_df846.y;
    highp float var_f2b7c = var_df846.w;
    highp float var_0357c = var_df846.z;
    highp float var_2c821 = var_df846.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_4fa47[0].x, var_ac116 * var_498b7[1].y, var_f2b7c * var_4882d[3].z, (var_0357c * var_78c1b[2].w) + (var_2c821 * var_40575[3].w));
    var_df846 = var_9666f;
    highp float var_d799e = var_df846.w;
    highp vec4 var_be58f = var_9666f / vec4(var_d799e);
    var_df846 = var_be58f;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_1c342 = vec4(v_projPosition.xy + vec2(SubPixelOffset.x, -SubPixelOffset.y), var_6abed, 1.0);
    highp mat4 var_2949d = u_invProj;
    highp mat4 var_e6914 = u_invProj;
    highp mat4 var_164c7 = u_invProj;
    highp mat4 var_b5866 = u_invProj;
    highp mat4 var_bb46a = u_invProj;
    highp float var_a6256 = var_1c342.x;
    highp float var_05401 = var_1c342.y;
    highp float var_b8669 = var_1c342.w;
    highp float var_259fc = var_1c342.z;
    highp float var_f8db3 = var_1c342.w;
    highp vec4 var_fa2eb = vec4(var_a6256 * var_2949d[0].x, var_05401 * var_e6914[1].y, var_b8669 * var_164c7[3].z, (var_259fc * var_b5866[2].w) + (var_f8db3 * var_bb46a[3].w));
    var_1c342 = var_fa2eb;
    highp float var_f7138 = var_1c342.w;
    highp vec4 var_3ee7d = var_fa2eb / vec4(var_f7138);
    var_1c342 = var_3ee7d;
    highp vec3 var_4a328 = (u_invView * vec4(var_3ee7d.xyz, 1.0)).xyz - WorldOrigin.xyz;
    highp vec3 var_c6246 = var_3ee7d.xyz;
    highp vec3 var_a2653 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_c6246)), normalize(dFdy(var_c6246)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_f3008 = vec3(QuantizationParameters.z * 0.5) - mod(var_4a328, vec3(QuantizationParameters.z));
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    highp vec2 var_3ccf7 = var_1ba39;
    highp vec3 var_b0cb0 = vec3(var_af032.xy, (1.0 - abs(var_3ccf7.x)) - abs(var_3ccf7.y));
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
    highp vec3 var_55f63 = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_888d0 = normalize((u_view * vec4(var_55f63, 0.0)).xyz);
#endif
    highp vec4 var_a6473 = texture(s_ColorMetalnessSubsurface, var_9279d);
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_4ac0e = var_a6473;
    highp float var_fa0f3 = clamp(2.007874011993408203125 * (var_4ac0e.w - 0.501960813999176025390625), 0.0, 1.0);
#endif
    uvec4 var_9e1cf = texelFetch(s_EmissiveAmbientLinearRoughness, ivec2(vec2(textureSize(s_EmissiveAmbientLinearRoughness, 0)) * var_9279d), 0);
    uvec4 var_1f03a = var_9e1cf;
#ifdef POINT_LIGHT_SHADING__ON
    uint var_4b676 = var_1f03a.x & 65535u;
    uvec2 var_49e6b = uvec2(var_4b676 >> 8u, var_4b676 & 255u);
    highp vec2 var_4dc93 = vec2(float(var_49e6b.x), float(var_49e6b.y)) * vec2(0.0039215688593685626983642578125);
#endif
    highp float var_12ee5 = float(var_1f03a.w) * 0.0039215688593685626983642578125;
    uvec2 var_c02ad = var_9e1cf.yz;
    uint var_39af7 = var_c02ad.x & 65535u;
    uint var_32bfc = var_c02ad.y & 65535u;
    highp vec4 var_96071 = vec4(uvec4(var_39af7 >> 8u, var_39af7 & 255u, var_32bfc >> 8u, var_32bfc & 255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 var_da2fb = var_96071;
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_7c188 = (u_invView * vec4(var_be58f.xyz, 1.0)).xyz;
    highp vec3 var_16398 = var_be58f.xyz;
    highp vec3 var_4211e = vec3(v_projPosition.xy, var_6abed);
    highp vec3 var_9e11a = var_a6473.xyz;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec3 var_b3c17;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_b2786;
    func_9b87e(var_b2786, var_9e11a);
    highp vec3 var_05442 = vec3(0.039999999105930328369140625 * (1.0 - var_fa0f3)) + (var_b2786 * var_fa0f3);
    highp vec3 var_5bd0a = var_4211e;
    highp vec3 var_19bb2 = -(var_16398 / vec3(length(var_16398) + 9.9999997473787516355514526367188e-05));
    highp float var_3ef11 = clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_4ac0e.w), 0.0, 1.0) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
    highp vec4 var_a98a2;
    highp vec3 var_08229;
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
    highp vec3 var_b3c17;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
    highp vec3 var_0eeee;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    if (var_5bd0a.z != 1.0)
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    if (DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled.w != 0.0)
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    {
#endif
#ifdef POINT_LIGHT_SHADING__ON
        highp vec4 var_7accf;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
        highp vec3 var_018f5 = (((u_invView * vec4(var_be58f.xyz, 1.0)).xyz - WorldOrigin.xyz) - vec3(0.5)) + (var_55f63 * 0.20000000298023223876953125);
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
        highp vec3 var_abdf4;
        highp vec3 var_e318f;
        func_4f458(var_e318f, var_abdf4, var_7accf, var_4a328, var_f3008, var_a2653, var_7c188, var_16398, var_888d0, var_19bb2, var_4dc93, var_05442, var_fa0f3, var_55f63, var_3ef11);
        var_0eeee = var_e318f;
        var_08229 = var_abdf4;
        var_a98a2 = var_7accf;
    }
    else
    {
        var_0eeee = vec3(0.0);
        var_08229 = vec3(0.0);
        var_a98a2 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec3 var_b3c17;
    if (DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled.w != 0.0)
    {
        highp vec3 var_018f5 = ((var_7c188 - WorldOrigin.xyz) - vec3(0.5)) + (var_55f63 * 0.20000000298023223876953125);
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
        ivec3 var_42d37 = ivec3(floor(var_018f5));
        highp vec3 var_cd5cf = floor(var_018f5 * 0.0625) * 16.0;
        highp vec3 var_482e8 = var_018f5 - var_cd5cf;
        ivec4 var_984ab = ivec4((var_42d37 - (ivec3(15) & (var_42d37 >> ivec3(31)))) / ivec3(16), 0);
        ivec4 var_cff55 = var_984ab;
        int var_ef361 = (var_cff55.x & 65535) | (var_cff55.y << 16);
        int var_10f25 = (var_cff55.z & 65535) | (var_cff55.w << 16);
        ivec4 var_4e614 = var_984ab;
        uint var_8af53 = uint(var_4e614.x) * 1540483477u;
        uint var_330d0 = uint(var_4e614.y) * 1540483477u;
        uint var_3870b = uint(var_4e614.z) * 1540483477u;
        uint var_30f73 = uint(var_4e614.w) * 1540483477u;
        uint var_5376d = ((((((2293326976u ^ ((var_8af53 ^ (var_8af53 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_330d0 ^ (var_330d0 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_3870b ^ (var_3870b >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_30f73 ^ (var_30f73 >> uint(24))) * 1540483477u);
        uint var_d02c9 = (var_5376d ^ (var_5376d >> uint(13))) * 1540483477u;
        uint var_15a6d = var_d02c9 ^ (var_d02c9 >> uint(15));
        uint var_c6bd0 = (var_15a6d ^ (var_15a6d >> uint(16))) & 65535u;
        uint var_19109 = var_c6bd0 | uint(var_c6bd0 == 0u);
        int var_d6224;
        uint var_bcfea;
        bool var_87a71;
        int var_f503c;
        var_f503c = 0;
        var_87a71 = false;
        var_bcfea = var_19109 & uint(GpuEntryBufferCapacity.x - 1.0);
        var_d6224 = 0;
        bool var_4f504;
        uint var_85325;
        int var_4035a;
        int var_cfe5d;
        bool var_a0c0a;
        for (;;)
        {
            if (var_d6224 < 8)
            {
                uint var_23c71 = uint(var_41ba9.zGpuEntryBuffer[var_bcfea].hash) & 65535u;
                bool var_734de = var_23c71 == var_19109;
                bool var_166d2;
                if (var_734de)
                {
                    var_166d2 = var_41ba9.zGpuEntryBuffer[var_bcfea].packed_xy == var_ef361;
                }
                else
                {
                    var_166d2 = var_734de;
                }
                bool var_09802;
                if (var_166d2)
                {
                    var_09802 = var_41ba9.zGpuEntryBuffer[var_bcfea].packed_zw == var_10f25;
                }
                else
                {
                    var_09802 = var_166d2;
                }
                if (var_87a71)
                {
                    var_4035a = var_f503c;
                }
                else
                {
                    int var_c38b2;
                    if (var_09802)
                    {
                        var_c38b2 = var_41ba9.zGpuEntryBuffer[var_bcfea].user_data;
                    }
                    else
                    {
                        var_c38b2 = var_f503c;
                    }
                    var_4035a = var_c38b2;
                }
                var_4f504 = var_87a71 || var_09802;
                var_85325 = (var_bcfea + 1u) & uint(GpuEntryBufferCapacity.x - 1.0);
                if (var_4f504 || (var_23c71 == 0u))
                {
                    var_a0c0a = var_4f504;
                    var_cfe5d = var_4035a;
                    break;
                }
                var_f503c = var_4035a;
                var_87a71 = var_4f504;
                var_bcfea = var_85325;
                var_d6224++;
                continue;
            }
            else
            {
                var_a0c0a = var_87a71;
                var_cfe5d = var_f503c;
                break;
            }
        }
        uint var_f8e5a = uint(var_cfe5d >> int(2u));
        highp vec3 var_502ab;
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
        highp vec3 var_c2c85;
        highp vec3 var_502ab;
        func_4f458(var_502ab, var_c2c85, var_7accf, var_4a328, var_f3008, var_a2653, var_7c188, var_16398, var_888d0, var_19bb2, var_4dc93, var_05442, var_fa0f3, var_55f63, var_3ef11);
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
        if (var_a0c0a)
        {
            highp vec3 var_2712f;
            if (any(greaterThanEqual(abs(var_55f63), vec3(1.0))))
            {
                highp vec3 var_c2195 = var_55f63;
                highp vec3 var_3e9f3 = abs(var_55f63);
                highp vec3 var_6de19 = var_3e9f3.zxy;
                highp vec3 var_7f629 = var_3e9f3.yzx;
                highp float var_c5cae = dot(var_482e8, var_3e9f3);
                highp float var_d19db = dot(var_482e8, var_6de19);
                highp float var_b9d4a = dot(var_482e8, var_7f629);
                highp float var_40c36;
                if (((var_c2195.x + var_c2195.y) + var_c2195.z) > 0.0)
                {
                    var_40c36 = ceil(var_c5cae);
                }
                else
                {
                    var_40c36 = floor(var_c5cae);
                }
                highp float var_2761e = floor(var_d19db);
                highp float var_3bdc3 = floor(var_b9d4a);
                highp vec3 var_d90d3 = ((var_3e9f3 * var_40c36) + (var_6de19 * var_2761e)) + (var_7f629 * var_3bdc3);
                highp vec3 var_1ab36 = var_d90d3 + var_6de19;
                highp vec3 var_6781d = var_d90d3 + var_7f629;
                highp vec3 var_72463 = (var_d90d3 + var_6de19) + var_7f629;
                highp float var_131e3 = var_d19db - var_2761e;
                highp float var_44acd = var_b9d4a - var_3bdc3;
                highp float var_84650 = 1.0 - var_131e3;
                highp float var_58c47 = 1.0 - var_44acd;
                highp vec4 var_5a263 = vec4(var_84650 * var_58c47, var_131e3 * var_58c47, var_84650 * var_44acd, var_131e3 * var_44acd);
                bool var_66a92 = all(greaterThanEqual(var_d90d3, vec3(0.0)));
                bool var_3aded;
                if (var_66a92)
                {
                    var_3aded = all(lessThan(var_72463, vec3(16.0)));
                }
                else
                {
                    var_3aded = var_66a92;
                }
                highp vec3 var_d70c9;
                highp vec3 var_40454;
                highp vec3 var_854dc;
                highp vec3 var_aa437;
                if (var_3aded)
                {
                    uvec3 var_35df1 = uvec3(var_d90d3);
                    uint var_ec371 = var_f8e5a + ((var_35df1.y + (var_35df1.z * 16u)) + (var_35df1.x * 256u));
                    highp vec3 var_02f5f;
                    func_f73f0(var_ec371, var_02f5f);
                    uvec3 var_7a0fb = uvec3(var_1ab36);
                    uint var_b0fec = var_f8e5a + ((var_7a0fb.y + (var_7a0fb.z * 16u)) + (var_7a0fb.x * 256u));
                    highp vec3 var_074d3;
                    func_f73f0(var_b0fec, var_074d3);
                    uvec3 var_0c6ec = uvec3(var_6781d);
                    uint var_9884e = var_f8e5a + ((var_0c6ec.y + (var_0c6ec.z * 16u)) + (var_0c6ec.x * 256u));
                    highp vec3 var_64c84;
                    func_f73f0(var_9884e, var_64c84);
                    uvec3 var_fa1c3 = uvec3(var_72463);
                    uint var_0ad06 = var_f8e5a + ((var_fa1c3.y + (var_fa1c3.z * 16u)) + (var_fa1c3.x * 256u));
                    highp vec3 var_6c0ad;
                    func_f73f0(var_0ad06, var_6c0ad);
                    var_aa437 = var_6c0ad;
                    var_854dc = var_64c84;
                    var_40454 = var_074d3;
                    var_d70c9 = var_02f5f;
                }
                else
                {
                    highp vec3 var_3e0cb = var_cd5cf + var_d90d3;
                    highp vec3 var_1f366;
                    func_968b0(var_3e0cb, var_cd5cf, var_f8e5a, var_1f366);
                    highp vec3 var_99e8d = var_cd5cf + var_1ab36;
                    highp vec3 var_62cbe;
                    func_968b0(var_99e8d, var_cd5cf, var_f8e5a, var_62cbe);
                    highp vec3 var_fe2fa = var_cd5cf + var_6781d;
                    highp vec3 var_f4cc9;
                    func_968b0(var_fe2fa, var_cd5cf, var_f8e5a, var_f4cc9);
                    highp vec3 var_b8703 = var_cd5cf + var_72463;
                    highp vec3 var_c53e0;
                    func_968b0(var_b8703, var_cd5cf, var_f8e5a, var_c53e0);
                    var_aa437 = var_c53e0;
                    var_854dc = var_f4cc9;
                    var_40454 = var_62cbe;
                    var_d70c9 = var_1f366;
                }
                var_2712f = (((var_d70c9 * var_5a263.x) + (var_40454 * var_5a263.y)) + (var_854dc * var_5a263.z)) + (var_aa437 * var_5a263.w);
            }
            else
            {
                highp vec3 var_eb613 = floor(var_482e8);
                highp vec3 var_8b514 = var_482e8 - var_eb613;
                int var_21999 = (int(var_8b514.x >= var_8b514.y) | (int(var_8b514.y >= var_8b514.z) << 1)) | (int(var_8b514.x >= var_8b514.z) << 2);
                uvec3 var_2256d = uvec3(var_eb613);
                highp float var_c8154 = min(var_8b514.x, var_8b514.y);
                highp float var_ed6ba = max(var_8b514.x, var_8b514.y);
                highp float var_6d122 = min(var_c8154, var_8b514.z);
                highp float var_f4126 = max(var_ed6ba, var_8b514.z);
                highp float var_46f74 = max(min(var_ed6ba, var_8b514.z), var_c8154);
                bool var_59db7 = all(greaterThanEqual(var_eb613, vec3(0.0)));
                bool var_64535;
                if (var_59db7)
                {
                    var_64535 = all(lessThan(var_eb613 + vec3(1.0), vec3(16.0)));
                }
                else
                {
                    var_64535 = var_59db7;
                }
                highp vec3 var_6d82c;
                highp vec3 var_5c15a;
                highp vec3 var_95cfd;
                highp vec3 var_e6f25;
                if (var_64535)
                {
                    uvec3 var_ac072 = var_2256d;
                    uint var_7c5b8 = var_f8e5a + ((var_ac072.y + (var_ac072.z * 16u)) + (var_ac072.x * 256u));
                    highp vec3 var_a7c87;
                    func_f73f0(var_7c5b8, var_a7c87);
                    uvec3 var_94f35 = var_2256d + var_89819[var_21999];
                    uint var_5a2ce = var_f8e5a + ((var_94f35.y + (var_94f35.z * 16u)) + (var_94f35.x * 256u));
                    highp vec3 var_26297;
                    func_f73f0(var_5a2ce, var_26297);
                    uvec3 var_12b35 = var_2256d + var_54404[var_21999];
                    uint var_fc69d = var_f8e5a + ((var_12b35.y + (var_12b35.z * 16u)) + (var_12b35.x * 256u));
                    highp vec3 var_afebe;
                    func_f73f0(var_fc69d, var_afebe);
                    uvec3 var_7f762 = var_2256d + uvec3(1u);
                    uint var_9db6e = var_f8e5a + ((var_7f762.y + (var_7f762.z * 16u)) + (var_7f762.x * 256u));
                    highp vec3 var_b805f;
                    func_f73f0(var_9db6e, var_b805f);
                    var_e6f25 = var_b805f;
                    var_95cfd = var_afebe;
                    var_5c15a = var_26297;
                    var_6d82c = var_a7c87;
                }
                else
                {
                    highp vec3 var_32402 = var_cd5cf + var_eb613;
                    highp vec3 var_63155;
                    func_968b0(var_32402, var_cd5cf, var_f8e5a, var_63155);
                    highp vec3 var_3cfc7 = var_cd5cf + (var_eb613 + var_fd1f1[var_21999]);
                    highp vec3 var_e4550;
                    func_968b0(var_3cfc7, var_cd5cf, var_f8e5a, var_e4550);
                    highp vec3 var_33851 = var_cd5cf + (var_eb613 + var_93959[var_21999]);
                    highp vec3 var_4add5;
                    func_968b0(var_33851, var_cd5cf, var_f8e5a, var_4add5);
                    highp vec3 var_3178f = var_cd5cf + (var_eb613 + vec3(1.0));
                    highp vec3 var_22f84;
                    func_968b0(var_3178f, var_cd5cf, var_f8e5a, var_22f84);
                    var_e6f25 = var_22f84;
                    var_95cfd = var_4add5;
                    var_5c15a = var_e4550;
                    var_6d82c = var_63155;
                }
                var_2712f = (((var_6d82c * (1.0 - var_f4126)) + (var_5c15a * (var_f4126 - var_46f74))) + (var_95cfd * (var_46f74 - var_6d122))) + (var_e6f25 * var_6d122);
            }
            var_502ab = var_2712f;
        }
        else
        {
            var_502ab = vec3(0.0);
        }
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
        var_b3c17 = var_502ab;
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
        var_08229 = var_c2c85;
        var_a98a2 = var_7accf;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    }
    else
    {
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
        var_b3c17 = vec3(0.0);
        var_08229 = vec3(0.0);
        var_a98a2 = vec4(0.0, 0.0, 0.0, 1.0);
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
        var_b3c17 = (var_96071.xyz * var_da2fb.w) * 6.0;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    }
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_79192 = var_a98a2;
#endif
    highp vec4 var_ad7b8 = SkyAmbientLightColorIntensity;
    highp float var_e77f5 = var_12ee5 * var_12ee5;
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec3 var_14151 = vec3(v_projPosition.xy, (texture(s_SceneDepth, var_6460b.xy).x * 2.0) - 1.0);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_14151 = var_4211e;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    highp vec3 var_14151 = vec3(v_projPosition.xy, var_6abed);
#endif
    highp float var_c72d4 = ((var_14151.z * 0.5) + 0.5) * 65535.0;
    highp float var_cbefe = floor(var_c72d4);
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    bgfx_FragData0 = vec4(((vec3(1.0) * (1.0 - clamp(2.007874011993408203125 * (var_a6473.w - 0.501960813999176025390625), 0.0, 1.0))) * max((((var_96071.xyz * var_da2fb.w) * 6.0) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_e77f5 * var_e77f5) * var_12ee5, (var_12ee5 * var_12ee5) * var_12ee5, CameraLightIntensity.y)) * var_ad7b8.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w, 1.0);
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    bgfx_FragData0 = vec4(((vec3(1.0) * (1.0 - clamp(2.007874011993408203125 * (var_a6473.w - 0.501960813999176025390625), 0.0, 1.0))) * max((var_b3c17 * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_e77f5 * var_e77f5) * var_12ee5, (var_12ee5 * var_12ee5) * var_12ee5, CameraLightIntensity.y)) * var_ad7b8.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w, 1.0);
#endif
#ifdef POINT_LIGHT_SHADING__OFF
    bgfx_FragData1 = vec4(0.0, 0.0, 0.0, 1.0);
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    bgfx_FragData2 = vec4((texture(s_Normal, var_6460b.xy).xy * 0.5) + vec2(0.5), var_cbefe * 1.525902189314365386962890625e-05, var_c72d4 - var_cbefe);
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
    bgfx_FragData0 = vec4(var_b3c17 + (((vec3(1.0) * (1.0 - var_fa0f3)) * max(((((var_96071.xyz * var_da2fb.w) * 6.0) + (var_a98a2.xyz * var_79192.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_e77f5 * var_e77f5) * var_12ee5, (var_12ee5 * var_12ee5) * var_12ee5, CameraLightIntensity.y)) * var_ad7b8.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w), 1.0);
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
    bgfx_FragData0 = vec4(var_0eeee + (((vec3(1.0) * (1.0 - var_fa0f3)) * max(((var_b3c17 + (var_a98a2.xyz * var_79192.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_e77f5 * var_e77f5) * var_12ee5, (var_12ee5 * var_12ee5) * var_12ee5, CameraLightIntensity.y)) * var_ad7b8.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w), 1.0);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    bgfx_FragData1 = vec4(var_08229, 1.0);
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)
    bgfx_FragData2 = vec4((var_1ba39 * 0.5) + vec2(0.5), var_cbefe * 1.525902189314365386962890625e-05, var_c72d4 - var_cbefe);
#endif
}
