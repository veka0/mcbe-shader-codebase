#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - POPULATE_PASS (not used)
*
* GPUBlockLighting:
* - GPU_BLOCK_LIGHTING__OFF
* - GPU_BLOCK_LIGHTING__ON
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF
* - POINT_LIGHT_SHADING__ON
*
* ThreadLimit:
* - THREAD_LIMIT__LIMITED_AT128
* - THREAD_LIMIT__LIMITED_AT256
* - THREAD_LIMIT__NATIVE
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2DArray s_CurrentLightingBuffer;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_PreviousLightingBuffer;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_ScreenSpaceWaterBackFaceDepthAndNormal;
* - uniform lowp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 13, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 14, std430) buffer s_zGpuEntryBufferBuffer { GpuVolumeEntry s_zGpuEntryBuffer[]; };
* - layout(binding = 15, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 16, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
* - layout(binding = 17, std430) buffer s_zVoxelBufferBuffer { VoxelNode s_zVoxelBuffer[]; };
*
* Uniforms:
* - uniform vec4 AirAlbedoExtinction;
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BiomeBlendingLastUpdatePosition;
* - uniform vec4 BiomeBlendingParameters;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraAmbientContribution;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 CameraUnderwaterAndWaterSurfaceBiasAndFalloff;
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
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 HeightFogScaleBias;
* - uniform vec4 HenyeyGreensteinG;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 JitterOffset;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MinAmbientValue;
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
* - uniform mat4 PrevInvProj;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkySamplesConfig;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TemporalSettings;
* - uniform vec4 Time;
* - uniform vec4 UndergroundFogColor;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 VolumeShadowSettings;
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
#ifdef THREAD_LIMIT__LIMITED_AT128
layout(local_size_x = 8, local_size_y = 8, local_size_z = 2) in;
#endif
#ifdef THREAD_LIMIT__LIMITED_AT256
layout(local_size_x = 8, local_size_y = 8, local_size_z = 4) in;
#endif
#ifdef THREAD_LIMIT__NATIVE
layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
struct Light {
    vec4 position;
    vec4 color;
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
#ifdef GPU_BLOCK_LIGHTING__ON
const int var_d93d2[64] = int[](-1, 2, 3, -1, 0, 6, 7, -1, 1, 10, 11, -1, -1, -1, -1, -1, 4, 14, 16, -1, 8, 18, 20, -1, 12, 22, 24, -1, -1, -1, -1, -1, 5, 15, 17, -1, 9, 19, 21, -1, 13, 23, 25, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
struct GpuVolumeEntry {
    int packed_xy;
    int packed_zw;
    int hash;
    int user_data;
};

const uvec3 var_a8473[8] = uvec3[](uvec3(0u, 0u, 1u), uvec3(0u, 0u, 1u), uvec3(0u, 1u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u), uvec3(1u, 0u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u));
const uvec3 var_a719c[8] = uvec3[](uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(0u, 1u, 1u), uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 1u, 0u), uvec3(1u, 1u, 0u));
const vec3 var_223ba[8] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(1.0, 0.0, 0.0), vec3(1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(1.0, 0.0, 0.0));
const vec3 var_0f733[8] = vec3[](vec3(0.0, 1.0, 1.0), vec3(1.0, 0.0, 1.0), vec3(0.0, 1.0, 1.0), vec3(0.0, 1.0, 1.0), vec3(1.0, 0.0, 1.0), vec3(1.0, 0.0, 1.0), vec3(1.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0));
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
struct Light {
    vec4 position;
    vec4 color;
    int shadowProbeIndex;
    int id;
    int pad0;
    int pad1;
};

#endif
struct BiomeInfo {
    vec4 waterExtinctionCoefficients;
    vec4 waterAlbedoExtinction;
    vec4 waterSurfaceParameters;
    vec4 waterSurfaceWaveParameters;
    vec4 waterSurfaceOctaveParameters;
};

#ifdef POINT_LIGHT_SHADING__ON
struct LightData {
    float lookup;
};

int var_e7b23;
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
layout(binding = 16, std430) buffer s_zLights { Light zLights[]; } var_57932;
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
layout(binding = 17, std430) buffer s_zVoxelBuffer { VoxelNode zVoxelBuffer[]; } var_ed75e;
layout(binding = 14, std430) buffer s_zGpuEntryBuffer { GpuVolumeEntry zGpuEntryBuffer[]; } var_5ae14;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
layout(binding = 16, std430) buffer s_zLights { Light zLights[]; } var_57932;
#endif
layout(binding = 13, std430) buffer s_zBiomeInfoBuffer { BiomeInfo zBiomeInfoBuffer[]; } var_37ad9;
#ifdef POINT_LIGHT_SHADING__ON
layout(binding = 15, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_cb747;
#endif
layout(location = 0, binding = 9, rgba16f) uniform writeonly highp image2DArray s_CurrentLightingBuffer;
uniform highp sampler2D s_BiomeBlendingMap;
uniform highp sampler2D s_ScreenSpaceWaterBackFaceDepthAndNormal;
uniform highp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
uniform highp sampler2DArray s_PreviousLightingBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp sampler3D s_SkyAmbientSamples;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
#endif
uniform mat4 CascadesShadowProj[8];
uniform mat4 CloudShadowProj;
uniform mat4 PlayerShadowProj;
#ifdef POINT_LIGHT_SHADING__ON
uniform mat4 PointLightProj;
#endif
uniform mat4 PrevInvProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 AirAlbedoExtinction;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 BiomeBlendingLastUpdatePosition;
uniform vec4 BiomeBlendingParameters;
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform vec4 CameraAmbientContribution;
uniform vec4 CameraUnderwaterAndWaterSurfaceBiasAndFalloff;
uniform vec4 CascadesParameters[8];
uniform vec4 CascadesPerSet;
uniform vec4 CloudShadowsVisible;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 ClusterDepthBounds;
uniform vec4 ClusterDimensions;
#endif
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 DirectionalLightSkyLightHeuristicToggles;
uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform vec4 DirectionalLightSourceWorldSpaceDirection;
#ifdef GPU_BLOCK_LIGHTING__ON
uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
#endif
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform vec4 FogAndDistanceControl;
#ifdef GPU_BLOCK_LIGHTING__ON
uniform vec4 GpuEntryBufferCapacity;
#endif
uniform vec4 HeightFogScaleBias;
uniform vec4 HenyeyGreensteinG;
uniform vec4 JitterOffset;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 ManhattanDistAttenuationEnabled;
#endif
uniform vec4 MinAmbientValue;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 PointLightAttenuationWindow;
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 PointLightPreCalcValues;
#endif
uniform vec4 QuantizationParameters;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SkySamplesConfig;
uniform vec4 TemporalSettings;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
#endif
uniform vec4 VolumeShadowSettings;
uniform vec4 WaterAlbedoExtinction;
#ifdef GPU_BLOCK_LIGHTING__ON
uniform vec4 WorldOrigin;
#endif
uniform vec4 u_prevWorldPosOffset;
void func_8ab59(inout bool arg_5e3ed) {
    if (BiomeBlendingParameters.x > 0.0)
    {
        arg_5e3ed = true;
        return;
    }
    arg_5e3ed = false;
}
void func_4b3c6(inout vec3 arg_99162, inout vec4 arg_029c1) {
    int loc_738fb = int(BiomeBlendingParameters.z * 0.5);
    float loc_9e9be = (arg_99162.x - BiomeBlendingLastUpdatePosition.x) / BiomeBlendingLastUpdatePosition.w;
    float loc_3eb23 = (arg_99162.z - BiomeBlendingLastUpdatePosition.z) / BiomeBlendingLastUpdatePosition.w;
    ivec2 loc_f487d = ivec2(loc_738fb + int(floor(loc_9e9be)), loc_738fb + int(floor(loc_3eb23)));
    loc_f487d.x = clamp(loc_f487d.x, 0, int(BiomeBlendingParameters.z) - 1);
    loc_f487d.y = clamp(loc_f487d.y, 0, int(BiomeBlendingParameters.z) - 1);
    int loc_debb5 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d, 0).x * 255.0));
    int loc_5f53d = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(1, 0), 0).x * 255.0));
    int loc_e5728 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(0, 1), 0).x * 255.0));
    int loc_629bd = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(1), 0).x * 255.0));
    if (((loc_debb5 == loc_5f53d) && (loc_5f53d == loc_e5728)) && (loc_e5728 == loc_629bd))
    {
        arg_029c1 = var_37ad9.zBiomeInfoBuffer[loc_debb5].waterAlbedoExtinction;
        return;
    }
    float loc_0d854 = fract(loc_9e9be);
    float loc_00e44 = fract(loc_3eb23);
    vec4 loc_14145 = vec4((1.0 - loc_0d854) * (1.0 - loc_00e44), loc_0d854 * (1.0 - loc_00e44), (1.0 - loc_0d854) * loc_00e44, loc_0d854 * loc_00e44);
    arg_029c1 = (((var_37ad9.zBiomeInfoBuffer[loc_debb5].waterAlbedoExtinction * loc_14145.x) + (var_37ad9.zBiomeInfoBuffer[loc_5f53d].waterAlbedoExtinction * loc_14145.y)) + (var_37ad9.zBiomeInfoBuffer[loc_e5728].waterAlbedoExtinction * loc_14145.z)) + (var_37ad9.zBiomeInfoBuffer[loc_629bd].waterAlbedoExtinction * loc_14145.w);
}
void func_b5ebb(inout vec3 arg_9de81, inout vec4 arg_dde0d) {
    bool loc_a9f27;
    func_8ab59(loc_a9f27);
    if (loc_a9f27)
    {
        vec3 loc_a1b82 = arg_9de81;
        vec4 loc_29eab;
        func_4b3c6(loc_a1b82, loc_29eab);
        arg_dde0d = loc_29eab;
        return;
    }
    arg_dde0d = WaterAlbedoExtinction;
}
#ifdef GPU_BLOCK_LIGHTING__ON
void func_f4166(inout uint arg_3b6d5, inout vec3 arg_aa7d7) {
    if (var_ed75e.zVoxelBuffer[arg_3b6d5].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    vec4 loc_c066d = vec4(uvec4(var_ed75e.zVoxelBuffer[arg_3b6d5].data, var_ed75e.zVoxelBuffer[arg_3b6d5].data >> 8u, var_ed75e.zVoxelBuffer[arg_3b6d5].data >> 16u, var_ed75e.zVoxelBuffer[arg_3b6d5].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    vec4 loc_0dc9c = loc_c066d;
    arg_aa7d7 = (loc_c066d.xyz * loc_0dc9c.w) * 6.0;
}
void func_97457(inout vec3 arg_54c75, inout vec3 arg_0a653, inout uint arg_b5a6d, inout vec3 arg_cfabd) {
    vec3 loc_3eeaf = arg_54c75 - arg_0a653;
    int loc_1a9f5 = ((((int(loc_3eeaf.x < 0.0) | (int(loc_3eeaf.x >= 16.0) << 1)) | (int(loc_3eeaf.y < 0.0) << 2)) | (int(loc_3eeaf.y >= 16.0) << 3)) | (int(loc_3eeaf.z < 0.0) << 4)) | (int(loc_3eeaf.z >= 16.0) << 5);
    if (var_d93d2[loc_1a9f5] < 0)
    {
        uvec3 loc_23b8c = uvec3(arg_54c75 - arg_0a653) & uvec3(15u);
        uint loc_e0607 = arg_b5a6d + ((loc_23b8c.y + (loc_23b8c.z * 16u)) + (loc_23b8c.x * 256u));
        vec3 loc_f6126;
        func_f4166(loc_e0607, loc_f6126);
        arg_cfabd = loc_f6126;
        return;
    }
    if (!((var_ed75e.zVoxelBuffer[arg_b5a6d + 4096u].data & (1u << uint(var_d93d2[loc_1a9f5]))) != 0u))
    {
        arg_cfabd = vec3(0.0);
        return;
    }
    uvec3 loc_27255 = uvec3(arg_54c75 - (floor(arg_54c75 * 0.0625) * 16.0)) & uvec3(15u);
    uint loc_8f6af = (var_ed75e.zVoxelBuffer[(arg_b5a6d + 4097u) + uint(var_d93d2[loc_1a9f5])].data >> 2u) + ((loc_27255.y + (loc_27255.z * 16u)) + (loc_27255.x * 256u));
    vec3 loc_0b351;
    func_f4166(loc_8f6af, loc_0b351);
    arg_cfabd = loc_0b351;
}
#endif
void func_a0b5c(inout vec3 arg_9b0e1, inout float arg_7a26d) {
    vec4 loc_12ebe = PlayerShadowProj * vec4(arg_9b0e1, 1.0);
    loc_12ebe.z -= CascadesParameters[0].y;
    loc_12ebe.z = min(loc_12ebe.z, 1.0);
    vec2 loc_0d624 = ((loc_12ebe.xy * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    int loc_64b28;
    if (QuantizationParameters.x != 0.0)
    {
        loc_64b28 = 1;
    }
    else
    {
        loc_64b28 = clamp(int((2.0 * VolumeShadowSettings.x) + 0.5), 1, 9);
    }
    int loc_a4d0e = loc_64b28 / 2;
    vec2 loc_6828b = loc_0d624;
    loc_6828b.y += (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    loc_12ebe.z = (loc_12ebe.z * 0.5) + 0.5;
    loc_0d624 = loc_6828b;
    vec2 loc_9adef = vec2(loc_0d624.x, 1.0 - loc_0d624.y);
    bool loc_2c837 = loc_9adef.x >= 0.0;
    bool loc_d06e3;
    if (loc_2c837)
    {
        loc_d06e3 = loc_9adef.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_d06e3 = loc_2c837;
    }
    bool loc_da85e;
    if (loc_d06e3)
    {
        loc_da85e = loc_9adef.y >= 0.0;
    }
    else
    {
        loc_da85e = loc_d06e3;
    }
    bool loc_e80f2;
    if (loc_da85e)
    {
        loc_e80f2 = loc_9adef.y < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_e80f2 = loc_da85e;
    }
    if (!loc_e80f2)
    {
        arg_7a26d = 1.0;
        return;
    }
    float loc_304c3 = dot(CascadesPerSet, vec4(1.0)) + 1.0;
    float loc_e55e0;
    loc_e55e0 = 0.0;
    float loc_edd8a;
    for (int loc_e3b31 = 0; loc_e3b31 < loc_64b28; loc_e55e0 = loc_edd8a, loc_e3b31++)
    {
        loc_edd8a = loc_e55e0;
        float loc_5e275;
        for (int loc_d3328 = 0; loc_d3328 < loc_64b28; loc_edd8a = loc_5e275, loc_d3328++)
        {
            vec2 loc_49c98 = loc_0d624 + ((vec2(float(loc_d3328 - loc_a4d0e) + 0.5, float(loc_e3b31 - loc_a4d0e) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            vec3 loc_747f0 = vec3(loc_49c98.x, loc_49c98.y, loc_304c3);
            if (QuantizationParameters.x != 0.0)
            {
                loc_5e275 = loc_edd8a + float(textureLod(s_ShadowCascades, loc_747f0, 0.0).x >= loc_12ebe.z);
            }
            else
            {
                vec4 loc_8954e = step(vec4(loc_12ebe.z), textureGather(s_ShadowCascades, loc_747f0));
                vec2 loc_db73a = fract((loc_747f0.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_5e275 = loc_edd8a + mix(mix(loc_8954e.w, loc_8954e.z, loc_db73a.x), mix(loc_8954e.x, loc_8954e.y, loc_db73a.x), loc_db73a.y);
            }
        }
    }
    arg_7a26d = loc_e55e0 / float(loc_64b28 * loc_64b28);
}
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
void func_327ea() {
    int loc_da723 = int(GlobalInvocationID.x);
    int loc_1c644 = int(GlobalInvocationID.y);
    int loc_beae9 = int(GlobalInvocationID.z);
    if (((loc_da723 >= int(VolumeDimensions.x)) || (loc_1c644 >= int(VolumeDimensions.y))) || (loc_beae9 >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_8b342 = ((vec3(float(loc_da723), float(loc_1c644), float(loc_beae9)) + vec3(0.5)) + JitterOffset.xyz) / VolumeDimensions.xyz;
    vec3 loc_b4177 = loc_8b342;
    vec3 loc_777c2 = loc_8b342;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_8b342.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_caed6 = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_caed6;
    vec3 loc_16a16 = (u_view * vec4(loc_caed6, 1.0)).xyz;
    ivec2 loc_96650 = ivec2(gl_GlobalInvocationID.xy);
    vec2 loc_f3117 = texelFetch(s_ScreenSpaceWaterFrontFaceDepthAndNormal, loc_96650, 0).xy;
    vec2 loc_9e759 = texelFetch(s_ScreenSpaceWaterBackFaceDepthAndNormal, loc_96650, 0).xy;
    float loc_f2b43 = smoothstep(-0.5, 0.5, ((((loc_b4177.z - loc_f3117.x) * VolumeDimensions.z) * loc_f3117.y) - CameraUnderwaterAndWaterSurfaceBiasAndFalloff.y) / CameraUnderwaterAndWaterSurfaceBiasAndFalloff.z);
    float loc_8fa9c;
    if (loc_f2b43 >= 0.0)
    {
        float loc_efd00;
        if ((loc_b4177.z - loc_9e759.x) >= 0.0)
        {
            loc_efd00 = 0.0;
        }
        else
        {
            loc_efd00 = loc_f2b43;
        }
        loc_8fa9c = loc_efd00;
    }
    else
    {
        loc_8fa9c = loc_f2b43;
    }
    float loc_343cf;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_343cf = 1.0 - loc_8fa9c;
    }
    else
    {
        loc_343cf = loc_8fa9c;
    }
    vec4 loc_4397b;
    func_b5ebb(loc_caed6, loc_4397b);
    vec4 loc_12f1c = loc_4397b;
    float loc_ebd19 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_a9dfb = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_343cf);
    float loc_9fe9d = length(loc_16a16);
    float loc_ab2d8 = clamp((((loc_9fe9d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_360ed = mix(mix((AirAlbedoExtinction.xyz * loc_ebd19) * AirAlbedoExtinction.w, loc_4397b.xyz * loc_12f1c.w, vec3(loc_343cf)), vec3(0.0), vec3(loc_ab2d8));
    float loc_8068a = mix(mix(loc_ebd19 * AirAlbedoExtinction.w, loc_12f1c.w, loc_343cf), 0.0, loc_ab2d8);
    vec2 loc_3cb89 = vec2(0.0, CameraAmbientContribution.y);
    bool loc_f682a = SkySamplesConfig.x > 0.5;
    bool loc_39b3d;
    if (loc_f682a)
    {
        loc_39b3d = AtmosphericScatteringToggles.w > 0.5;
    }
    else
    {
        loc_39b3d = loc_f682a;
    }
    if (loc_39b3d)
    {
        vec3 loc_08c5f = loc_8b342;
        loc_08c5f.y = 1.0 - loc_08c5f.y;
        if (SkySamplesConfig.y > 0.5)
        {
            loc_08c5f.z -= SkySamplesConfig.z;
        }
        loc_08c5f.z = (exp(4.0 * loc_08c5f.z) - 1.0) * 0.0186573602259159088134765625;
        loc_3cb89 = textureLod(s_SkyAmbientSamples, loc_08c5f, 0.0).xy;
    }
    vec3 loc_fc3e3 = ((loc_360ed * 0.079577468335628509521484375) * max(((BlockBaseAmbientLightColorIntensity.xyz * loc_3cb89.x) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * loc_3cb89.y) * SkyAmbientLightColorIntensity.w), vec3(MinAmbientValue.x))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    bool loc_5b439 = !(DirectionalLightSkyLightHeuristicToggles.y != 0.0);
    bool loc_7e26a;
    if (!loc_5b439)
    {
        loc_7e26a = abs(loc_3cb89.y) > 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_7e26a = loc_5b439;
    }
    vec3 loc_7175c;
    if (loc_7e26a)
    {
        float loc_af838;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            int loc_c0de4 = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
            float loc_f6ac1;
            loc_f6ac1 = 1.0;
            int loc_29996;
            float loc_484ee;
            for (int loc_8a709 = 0, loc_0e4f2 = 0; loc_8a709 < loc_c0de4; loc_0e4f2 = loc_29996, loc_f6ac1 = loc_484ee, loc_8a709++)
            {
                int loc_79423 = min((loc_0e4f2 + int(CascadesPerSet[loc_8a709])), 8);
                loc_484ee = loc_f6ac1;
                loc_29996 = loc_0e4f2;
                int loc_a0458;
                float loc_5399e;
                for (; loc_29996 < loc_79423; loc_484ee = loc_5399e, loc_29996 = loc_a0458)
                {
                    vec4 loc_4a0d9 = CascadesShadowProj[loc_29996] * vec4(loc_caed6, 1.0);
                    vec3 loc_8d38c = abs(loc_4a0d9.xyz);
                    bool loc_45980 = loc_8d38c.x <= 1.0;
                    bool loc_f1421;
                    if (loc_45980)
                    {
                        loc_f1421 = loc_8d38c.y <= 1.0;
                    }
                    else
                    {
                        loc_f1421 = loc_45980;
                    }
                    bool loc_e36b7;
                    if (loc_f1421)
                    {
                        loc_e36b7 = loc_8d38c.z <= 1.0;
                    }
                    else
                    {
                        loc_e36b7 = loc_f1421;
                    }
                    if (loc_e36b7)
                    {
                        vec4 loc_38cc9 = loc_4a0d9;
                        int loc_3a40c;
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_3a40c = 1;
                        }
                        else
                        {
                            loc_3a40c = clamp(int((CascadesParameters[loc_29996].w * VolumeShadowSettings.x) + 0.5), 1, 9);
                        }
                        int loc_960ef = loc_3a40c / 2;
                        vec2 loc_dc4ac = ((loc_4a0d9.xy * 0.5) + vec2(0.5)) * CascadesParameters[loc_29996].x;
                        float loc_4fba3 = (loc_38cc9.z * 0.5) + 0.5;
                        loc_dc4ac.y += (1.0 - CascadesParameters[loc_29996].x);
                        float loc_3555e;
                        loc_3555e = 0.0;
                        float loc_801c0;
                        for (int loc_15249 = 0; loc_15249 < loc_3a40c; loc_3555e = loc_801c0, loc_15249++)
                        {
                            loc_801c0 = loc_3555e;
                            float loc_30840;
                            for (int loc_963d2 = 0; loc_963d2 < loc_3a40c; loc_801c0 = loc_30840, loc_963d2++)
                            {
                                vec2 loc_cced5 = loc_dc4ac + ((vec2(float(loc_963d2 - loc_960ef) + 0.5, float(loc_15249 - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_29996].x);
                                vec4 loc_fe3f0 = textureGather(s_ShadowCascades, vec3(loc_cced5, float(loc_29996)));
                                vec4 loc_26b65 = loc_fe3f0;
                                if (QuantizationParameters.x != 0.0)
                                {
                                    loc_30840 = loc_801c0 + float(loc_26b65.w >= (loc_4fba3 - CascadesParameters[loc_29996].y));
                                }
                                else
                                {
                                    vec4 loc_2f6b4 = step(vec4(loc_4fba3 - CascadesParameters[loc_29996].y), loc_fe3f0);
                                    vec2 loc_e2aba = fract((loc_cced5 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                    loc_30840 = loc_801c0 + mix(mix(loc_2f6b4.w, loc_2f6b4.z, loc_e2aba.x), mix(loc_2f6b4.x, loc_2f6b4.y, loc_e2aba.x), loc_e2aba.y);
                                }
                            }
                        }
                        loc_5399e = min(loc_484ee, loc_3555e / float(loc_3a40c * loc_3a40c));
                        loc_a0458 = loc_79423;
                    }
                    else
                    {
                        loc_5399e = loc_484ee;
                        loc_a0458 = loc_29996 + 1;
                    }
                }
            }
            float loc_f828f;
            if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
            {
                float loc_ad066;
                func_a0b5c(loc_caed6, loc_ad066);
                loc_f828f = loc_ad066;
            }
            else
            {
                loc_f828f = 1.0;
            }
            bool loc_8174b = int(CloudShadowsVisible.x) > 0;
            bool loc_b7807;
            if (loc_8174b)
            {
                loc_b7807 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
            }
            else
            {
                loc_b7807 = loc_8174b;
            }
            float loc_4a190;
            if (loc_b7807)
            {
                vec4 loc_bcd0f = CloudShadowProj * vec4(loc_caed6, 1.0);
                vec4 loc_bcbd7 = loc_bcd0f;
                loc_bcbd7 = loc_bcd0f / vec4(loc_bcbd7.w);
                loc_bcbd7.z -= (CascadesParameters[0].y / loc_bcbd7.w);
                int loc_c86ff;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_c86ff = 1;
                }
                else
                {
                    loc_c86ff = clamp(int((EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * VolumeShadowSettings.x) + 0.5), 1, 9);
                }
                int loc_7508d = loc_c86ff / 2;
                vec2 loc_37738 = ((loc_bcbd7.xy * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
                loc_37738.y += (1.0 - CascadesParameters[0].x);
                loc_bcbd7.z = (loc_bcbd7.z * 0.5) + 0.5;
                float loc_19cd0 = dot(CascadesPerSet, vec4(1.0));
                float loc_543e1;
                loc_543e1 = 0.0;
                float loc_0fce1;
                for (int loc_093cd = 0; loc_093cd < loc_c86ff; loc_543e1 = loc_0fce1, loc_093cd++)
                {
                    loc_0fce1 = loc_543e1;
                    float loc_16f2e;
                    for (int loc_fdb90 = 0; loc_fdb90 < loc_c86ff; loc_0fce1 = loc_16f2e, loc_fdb90++)
                    {
                        vec3 loc_d07c9 = vec3(loc_37738 + ((vec2(float(loc_fdb90 - loc_7508d) + 0.5, float(loc_093cd - loc_7508d) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_19cd0);
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_16f2e = loc_0fce1 + float(textureLod(s_ShadowCascades, loc_d07c9, 0.0).x >= loc_bcbd7.z);
                        }
                        else
                        {
                            vec4 loc_2ae6b = step(vec4(loc_bcbd7.z), textureGather(s_ShadowCascades, loc_d07c9));
                            vec2 loc_52300 = fract((loc_d07c9.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            loc_16f2e = loc_0fce1 + mix(mix(loc_2ae6b.w, loc_2ae6b.z, loc_52300.x), mix(loc_2ae6b.x, loc_2ae6b.y, loc_52300.x), loc_52300.y);
                        }
                    }
                }
                float loc_8a60e = loc_543e1 / float(loc_c86ff * loc_c86ff);
                float loc_26602;
                if (loc_8a60e < 1.0)
                {
                    loc_26602 = min(1.0, max(loc_8a60e, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                }
                else
                {
                    loc_26602 = 1.0;
                }
                loc_4a190 = loc_26602;
            }
            else
            {
                loc_4a190 = 1.0;
            }
            loc_af838 = mix(min(loc_f6ac1, min(loc_f828f, loc_4a190)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -0.0));
        }
        else
        {
            loc_af838 = 1.0;
        }
        float loc_44a26 = (1.0 + (loc_a9dfb * loc_a9dfb)) + ((2.0 * loc_a9dfb) * dot(-(loc_16a16 / vec3(loc_9fe9d)), normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_4de69 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_7175c = loc_fc3e3 + (((loc_360ed * loc_af838) * ((0.079577468335628509521484375 * (1.0 - (loc_a9dfb * loc_a9dfb))) / (loc_44a26 * sqrt(loc_44a26)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_4de69.w));
    }
    else
    {
        loc_7175c = loc_fc3e3;
    }
    if (TemporalSettings.x > 0.0)
    {
        vec3 loc_dfafd = (vec3(float(loc_da723), float(loc_1c644), float(loc_beae9)) + vec3(0.5)) / VolumeDimensions.xyz;
        vec3 loc_e9300 = loc_dfafd;
        vec2 loc_9d396 = VolumeNearFar.xy;
        float loc_fcd55 = (exp(4.0 * loc_e9300.z) - 1.0) * 0.0186573602259159088134765625;
        vec4 loc_62495 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcd55) * loc_9d396.x) + (loc_fcd55 * loc_9d396.y)), 1.0);
        vec4 loc_d7f13 = u_invViewProj * vec4((loc_dfafd.xy * 2.0) - vec2(1.0), loc_62495.z / loc_62495.w, 1.0);
        vec4 loc_d1c9b = loc_d7f13;
        vec4 loc_bf151 = u_prevViewProj * vec4((loc_d7f13.xyz / vec3(loc_d1c9b.w)) - u_prevWorldPosOffset.xyz, 1.0);
        vec4 loc_d9ce7 = loc_bf151;
        vec3 loc_ec028 = loc_bf151.xyz / vec3(loc_d9ce7.w);
        vec2 loc_1fa2a = VolumeNearFar.xy;
        vec2 loc_81f33 = (loc_ec028.xy + vec2(1.0)) * 0.5;
        vec4 loc_3fd1f = PrevInvProj * vec4(loc_ec028, 1.0);
        float loc_d255f = loc_81f33.x;
        vec3 loc_33e20 = vec3(loc_d255f, loc_81f33.y, log((53.598148345947265625 * ((((-loc_3fd1f.z) / loc_3fd1f.w) - loc_1fa2a.x) / (loc_1fa2a.y - loc_1fa2a.x))) + 1.0) * 0.25);
        ivec3 loc_dbdb4 = ivec3(VolumeDimensions.xyz);
        ivec3 loc_57985 = loc_dbdb4;
        vec3 loc_96ba4 = loc_33e20;
        float loc_53f43 = (loc_96ba4.z * float(loc_57985.z)) - 0.5;
        int loc_25a80 = clamp(int(loc_53f43), 0, loc_57985.z - 2);
        vec3 loc_34735 = VolumeDimensions.xyz * loc_33e20;
        imageStore(s_CurrentLightingBuffer, ivec3(loc_da723, loc_1c644, loc_beae9), mix(vec4(loc_7175c, loc_8068a), mix(textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80)), 0.0), textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80 + 1)), 0.0), vec4(clamp(loc_53f43 - float(loc_25a80), 0.0, 1.0))), vec4(mix(TemporalSettings.z, 0.0, clamp(length(clamp(loc_34735, vec3(0.0), vec3(loc_dbdb4)) - loc_34735) * TemporalSettings.y, 0.0, 1.0)))));
    }
    else
    {
        imageStore(s_CurrentLightingBuffer, ivec3(loc_da723, loc_1c644, loc_beae9), vec4(loc_7175c, loc_8068a));
    }
}
#endif
#ifdef POINT_LIGHT_SHADING__ON
void func_13ce0(inout vec3 arg_8311e, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    vec3 loc_70de6 = arg_8311e;
    vec3 loc_3195e = ClusterDimensions.xyz;
    vec2 loc_90806 = ClusterDepthBounds.xy;
    vec4 loc_920b1 = PointLightPreCalcValues;
    float loc_1ee6d = -loc_70de6.z;
    float loc_97566 = loc_1ee6d * ClusterDepthBounds.z;
    float loc_3dba6 = loc_97566 * ClusterDepthBounds.w;
    float loc_17f79;
    if (loc_1ee6d < loc_90806.x)
    {
        loc_17f79 = 0.0;
    }
    else
    {
        float loc_b1845;
        if (loc_1ee6d < loc_90806.y)
        {
            loc_b1845 = 1.0;
        }
        else
        {
            loc_b1845 = min(floor(clamp((log2(loc_1ee6d) - loc_920b1.z) * loc_920b1.x, 0.0, 1.0) * (loc_3195e.z - 2.0)) + 2.0, loc_3195e.z - 1.0);
        }
        loc_17f79 = loc_b1845;
    }
    vec3 loc_20e18 = vec3(min(floor(clamp((loc_70de6.x + loc_3dba6) / (2.0 * loc_3dba6), 0.0, 1.0) * loc_3195e.x), loc_3195e.x - 1.0), min(floor(clamp((loc_70de6.y + loc_97566) / (2.0 * loc_97566), 0.0, 1.0) * loc_3195e.y), loc_3195e.y - 1.0), loc_17f79);
    bool loc_ce27d = loc_20e18.x < 0.0;
    bool loc_f15a5;
    if (!loc_ce27d)
    {
        loc_f15a5 = loc_20e18.y < 0.0;
    }
    else
    {
        loc_f15a5 = loc_ce27d;
    }
    bool loc_7bab6;
    if (!loc_f15a5)
    {
        loc_7bab6 = loc_20e18.z < 0.0;
    }
    else
    {
        loc_7bab6 = loc_f15a5;
    }
    bool loc_a526b;
    if (!loc_7bab6)
    {
        loc_a526b = loc_20e18.x >= ClusterDimensions.x;
    }
    else
    {
        loc_a526b = loc_7bab6;
    }
    bool loc_6d7c9;
    if (!loc_a526b)
    {
        loc_6d7c9 = loc_20e18.y >= ClusterDimensions.y;
    }
    else
    {
        loc_6d7c9 = loc_a526b;
    }
    bool loc_fc058;
    if (!loc_6d7c9)
    {
        loc_fc058 = loc_20e18.z >= ClusterDimensions.z;
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
    int loc_14533 = int((loc_20e18.x + (loc_20e18.y * ClusterDimensions.x)) + ((loc_20e18.z * ClusterDimensions.x) * ClusterDimensions.y)) * int(ClusterDimensions.w);
    arg_e45b8 = loc_14533 + int(ClusterDimensions.w);
    arg_fadf1 = loc_14533;
    arg_d7f4c = true;
}
void func_c78d8(inout int arg_4a614, inout float arg_9eee0, inout vec3 arg_226c4) {
    if (var_57932.zLights[arg_4a614].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        return;
    }
    vec3 loc_48c8d = arg_226c4 - var_57932.zLights[arg_4a614].position.xyz;
    vec3 loc_0ca8f = abs(loc_48c8d);
    bool loc_ab77c = loc_0ca8f.x >= loc_0ca8f.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_0ca8f.x >= loc_0ca8f.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    if (loc_ca7f9)
    {
        loc_0ca8f = vec3(loc_0ca8f.y, loc_0ca8f.z, loc_0ca8f.x);
    }
    else
    {
        if (loc_0ca8f.y >= loc_0ca8f.z)
        {
            loc_0ca8f = vec3(loc_0ca8f.x, loc_0ca8f.z, loc_0ca8f.y);
        }
    }
    vec4 loc_e89cb = PointLightProj * vec4(loc_0ca8f, 1.0);
    loc_e89cb /= vec4(loc_e89cb.w);
    vec3 loc_2cd45 = loc_48c8d;
    bool loc_fe444 = abs(loc_2cd45.y) > abs(loc_2cd45.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_2cd45.y) > abs(loc_2cd45.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_2cd45.z *= (-1.0);
    }
    else
    {
        loc_2cd45.y *= (-1.0);
    }
    float loc_41e57;
    if (((textureLod(s_PointLightShadowTextureArray, vec4(loc_2cd45, float(var_57932.zLights[arg_4a614].shadowProbeIndex)), 0.0).x * 2.0) - 1.0) >= loc_e89cb.z)
    {
        loc_41e57 = 1.0;
    }
    else
    {
        loc_41e57 = 0.0;
    }
    arg_9eee0 = loc_41e57;
}
void func_5cce0(inout int arg_ff970, inout float arg_43b7a, inout vec3 arg_0a2b9, inout vec3 arg_39715) {
    if (arg_ff970 < 0)
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    vec3 loc_55323 = var_57932.zLights[arg_ff970].position.xyz - arg_39715;
    vec3 loc_757d0 = loc_55323;
    float loc_63f32;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        float loc_fe53a = (abs(loc_757d0.x) + abs(loc_757d0.y)) + abs(loc_757d0.z);
        loc_63f32 = loc_fe53a * loc_fe53a;
    }
    else
    {
        loc_63f32 = dot(loc_55323, loc_55323);
    }
    if (loc_63f32 >= (var_57932.zLights[arg_ff970].position.w * var_57932.zLights[arg_ff970].position.w))
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    float loc_b326d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        float loc_334de;
        func_c78d8(arg_ff970, loc_334de, arg_39715);
        loc_b326d = loc_334de;
    }
    else
    {
        loc_b326d = 1.0;
    }
    float loc_728c0 = loc_63f32 / ((var_57932.zLights[arg_ff970].position.w * var_57932.zLights[arg_ff970].position.w) + 9.9999997473787516355514526367188e-05);
    float loc_2a764 = clamp(1.0 - (loc_728c0 * loc_728c0), 0.0, 1.0);
    float loc_ea654 = (1.0 / max(loc_63f32, 0.100000001490116119384765625)) * (loc_2a764 * loc_2a764);
    float loc_5501b;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_5501b = loc_ea654 * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_ea654) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_5501b = loc_ea654;
    }
    arg_43b7a = loc_b326d;
    arg_0a2b9 = (var_57932.zLights[arg_ff970].color.xyz * var_57932.zLights[arg_ff970].color.w) * loc_5501b;
}
void func_0582d(inout vec3 arg_5cc04, inout vec3 arg_534d1, inout vec3 arg_81f82, inout float arg_1eba3, inout vec3 arg_1cde6, inout vec3 arg_e7cf5) {
    bool loc_a0bb1;
    int loc_79315;
    int loc_822f5;
    func_13ce0(arg_5cc04, loc_822f5, loc_79315, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    vec3 loc_ceaba;
    loc_ceaba = vec3(0.0);
    vec3 loc_3e87e;
    for (int loc_97a60 = loc_79315; loc_97a60 < loc_822f5; loc_ceaba = loc_3e87e, loc_97a60++)
    {
        int loc_99f11 = int(var_cb747.zLightLookupArray[loc_97a60].lookup);
        if (loc_99f11 < 0)
        {
            break;
        }
        vec3 loc_102a3;
        float loc_b0161;
        func_5cce0(loc_99f11, loc_b0161, loc_102a3, arg_81f82);
        float loc_57b1f = (1.0 + (arg_1eba3 * arg_1eba3)) + ((2.0 * arg_1eba3) * dot(arg_1cde6, normalize((u_view * vec4(var_57932.zLights[loc_99f11].position.xyz, 1.0)).xyz - arg_5cc04)));
        loc_3e87e = loc_ceaba + (((arg_e7cf5 * ((0.079577468335628509521484375 * (1.0 - (arg_1eba3 * arg_1eba3))) / (loc_57b1f * sqrt(loc_57b1f)))) * loc_b0161) * loc_102a3);
    }
    arg_534d1 = loc_ceaba;
}
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
void func_01cd3() {
    int loc_da723 = int(GlobalInvocationID.x);
    int loc_1c644 = int(GlobalInvocationID.y);
    int loc_beae9 = int(GlobalInvocationID.z);
    if (((loc_da723 >= int(VolumeDimensions.x)) || (loc_1c644 >= int(VolumeDimensions.y))) || (loc_beae9 >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_8b342 = ((vec3(float(loc_da723), float(loc_1c644), float(loc_beae9)) + vec3(0.5)) + JitterOffset.xyz) / VolumeDimensions.xyz;
    vec3 loc_b4177 = loc_8b342;
    vec3 loc_777c2 = loc_8b342;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_8b342.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_65ac0 = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_65ac0;
    vec3 loc_49313 = (u_view * vec4(loc_65ac0, 1.0)).xyz;
    ivec2 loc_96650 = ivec2(gl_GlobalInvocationID.xy);
    vec2 loc_f3117 = texelFetch(s_ScreenSpaceWaterFrontFaceDepthAndNormal, loc_96650, 0).xy;
    vec2 loc_9e759 = texelFetch(s_ScreenSpaceWaterBackFaceDepthAndNormal, loc_96650, 0).xy;
    float loc_f2b43 = smoothstep(-0.5, 0.5, ((((loc_b4177.z - loc_f3117.x) * VolumeDimensions.z) * loc_f3117.y) - CameraUnderwaterAndWaterSurfaceBiasAndFalloff.y) / CameraUnderwaterAndWaterSurfaceBiasAndFalloff.z);
    float loc_8fa9c;
    if (loc_f2b43 >= 0.0)
    {
        float loc_efd00;
        if ((loc_b4177.z - loc_9e759.x) >= 0.0)
        {
            loc_efd00 = 0.0;
        }
        else
        {
            loc_efd00 = loc_f2b43;
        }
        loc_8fa9c = loc_efd00;
    }
    else
    {
        loc_8fa9c = loc_f2b43;
    }
    float loc_343cf;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_343cf = 1.0 - loc_8fa9c;
    }
    else
    {
        loc_343cf = loc_8fa9c;
    }
    vec4 loc_4397b;
    func_b5ebb(loc_65ac0, loc_4397b);
    vec4 loc_12f1c = loc_4397b;
    float loc_ebd19 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_3fa4b = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_343cf);
    float loc_1595d = length(loc_49313);
    float loc_ab2d8 = clamp((((loc_1595d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_c5faf = mix(mix((AirAlbedoExtinction.xyz * loc_ebd19) * AirAlbedoExtinction.w, loc_4397b.xyz * loc_12f1c.w, vec3(loc_343cf)), vec3(0.0), vec3(loc_ab2d8));
    float loc_8068a = mix(mix(loc_ebd19 * AirAlbedoExtinction.w, loc_12f1c.w, loc_343cf), 0.0, loc_ab2d8);
    vec2 loc_3cb89 = vec2(0.0, CameraAmbientContribution.y);
    bool loc_f682a = SkySamplesConfig.x > 0.5;
    bool loc_39b3d;
    if (loc_f682a)
    {
        loc_39b3d = AtmosphericScatteringToggles.w > 0.5;
    }
    else
    {
        loc_39b3d = loc_f682a;
    }
    if (loc_39b3d)
    {
        vec3 loc_08c5f = loc_8b342;
        loc_08c5f.y = 1.0 - loc_08c5f.y;
        if (SkySamplesConfig.y > 0.5)
        {
            loc_08c5f.z -= SkySamplesConfig.z;
        }
        loc_08c5f.z = (exp(4.0 * loc_08c5f.z) - 1.0) * 0.0186573602259159088134765625;
        loc_3cb89 = textureLod(s_SkyAmbientSamples, loc_08c5f, 0.0).xy;
    }
    vec3 loc_fc3e3 = ((loc_c5faf * 0.079577468335628509521484375) * max(((BlockBaseAmbientLightColorIntensity.xyz * loc_3cb89.x) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * loc_3cb89.y) * SkyAmbientLightColorIntensity.w), vec3(MinAmbientValue.x))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    vec3 loc_09caf = -(loc_49313 / vec3(loc_1595d));
    bool loc_5b439 = !(DirectionalLightSkyLightHeuristicToggles.y != 0.0);
    bool loc_7e26a;
    if (!loc_5b439)
    {
        loc_7e26a = abs(loc_3cb89.y) > 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_7e26a = loc_5b439;
    }
    vec3 loc_1bbb0;
    if (loc_7e26a)
    {
        float loc_af838;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            int loc_c0de4 = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
            float loc_f6ac1;
            loc_f6ac1 = 1.0;
            int loc_29996;
            float loc_484ee;
            for (int loc_8a709 = 0, loc_0e4f2 = 0; loc_8a709 < loc_c0de4; loc_0e4f2 = loc_29996, loc_f6ac1 = loc_484ee, loc_8a709++)
            {
                int loc_79423 = min((loc_0e4f2 + int(CascadesPerSet[loc_8a709])), 8);
                loc_484ee = loc_f6ac1;
                loc_29996 = loc_0e4f2;
                int loc_a0458;
                float loc_5399e;
                for (; loc_29996 < loc_79423; loc_484ee = loc_5399e, loc_29996 = loc_a0458)
                {
                    vec4 loc_4a0d9 = CascadesShadowProj[loc_29996] * vec4(loc_65ac0, 1.0);
                    vec3 loc_8d38c = abs(loc_4a0d9.xyz);
                    bool loc_45980 = loc_8d38c.x <= 1.0;
                    bool loc_f1421;
                    if (loc_45980)
                    {
                        loc_f1421 = loc_8d38c.y <= 1.0;
                    }
                    else
                    {
                        loc_f1421 = loc_45980;
                    }
                    bool loc_e36b7;
                    if (loc_f1421)
                    {
                        loc_e36b7 = loc_8d38c.z <= 1.0;
                    }
                    else
                    {
                        loc_e36b7 = loc_f1421;
                    }
                    if (loc_e36b7)
                    {
                        vec4 loc_38cc9 = loc_4a0d9;
                        int loc_3a40c;
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_3a40c = 1;
                        }
                        else
                        {
                            loc_3a40c = clamp(int((CascadesParameters[loc_29996].w * VolumeShadowSettings.x) + 0.5), 1, 9);
                        }
                        int loc_960ef = loc_3a40c / 2;
                        vec2 loc_dc4ac = ((loc_4a0d9.xy * 0.5) + vec2(0.5)) * CascadesParameters[loc_29996].x;
                        float loc_4fba3 = (loc_38cc9.z * 0.5) + 0.5;
                        loc_dc4ac.y += (1.0 - CascadesParameters[loc_29996].x);
                        float loc_3555e;
                        loc_3555e = 0.0;
                        float loc_801c0;
                        for (int loc_15249 = 0; loc_15249 < loc_3a40c; loc_3555e = loc_801c0, loc_15249++)
                        {
                            loc_801c0 = loc_3555e;
                            float loc_30840;
                            for (int loc_963d2 = 0; loc_963d2 < loc_3a40c; loc_801c0 = loc_30840, loc_963d2++)
                            {
                                vec2 loc_cced5 = loc_dc4ac + ((vec2(float(loc_963d2 - loc_960ef) + 0.5, float(loc_15249 - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_29996].x);
                                vec4 loc_fe3f0 = textureGather(s_ShadowCascades, vec3(loc_cced5, float(loc_29996)));
                                vec4 loc_26b65 = loc_fe3f0;
                                if (QuantizationParameters.x != 0.0)
                                {
                                    loc_30840 = loc_801c0 + float(loc_26b65.w >= (loc_4fba3 - CascadesParameters[loc_29996].y));
                                }
                                else
                                {
                                    vec4 loc_2f6b4 = step(vec4(loc_4fba3 - CascadesParameters[loc_29996].y), loc_fe3f0);
                                    vec2 loc_e2aba = fract((loc_cced5 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                    loc_30840 = loc_801c0 + mix(mix(loc_2f6b4.w, loc_2f6b4.z, loc_e2aba.x), mix(loc_2f6b4.x, loc_2f6b4.y, loc_e2aba.x), loc_e2aba.y);
                                }
                            }
                        }
                        loc_5399e = min(loc_484ee, loc_3555e / float(loc_3a40c * loc_3a40c));
                        loc_a0458 = loc_79423;
                    }
                    else
                    {
                        loc_5399e = loc_484ee;
                        loc_a0458 = loc_29996 + 1;
                    }
                }
            }
            float loc_f828f;
            if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
            {
                float loc_ad066;
                func_a0b5c(loc_65ac0, loc_ad066);
                loc_f828f = loc_ad066;
            }
            else
            {
                loc_f828f = 1.0;
            }
            bool loc_8174b = int(CloudShadowsVisible.x) > 0;
            bool loc_b7807;
            if (loc_8174b)
            {
                loc_b7807 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
            }
            else
            {
                loc_b7807 = loc_8174b;
            }
            float loc_4a190;
            if (loc_b7807)
            {
                vec4 loc_bcd0f = CloudShadowProj * vec4(loc_65ac0, 1.0);
                vec4 loc_bcbd7 = loc_bcd0f;
                loc_bcbd7 = loc_bcd0f / vec4(loc_bcbd7.w);
                loc_bcbd7.z -= (CascadesParameters[0].y / loc_bcbd7.w);
                int loc_c86ff;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_c86ff = 1;
                }
                else
                {
                    loc_c86ff = clamp(int((EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * VolumeShadowSettings.x) + 0.5), 1, 9);
                }
                int loc_7508d = loc_c86ff / 2;
                vec2 loc_37738 = ((loc_bcbd7.xy * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
                loc_37738.y += (1.0 - CascadesParameters[0].x);
                loc_bcbd7.z = (loc_bcbd7.z * 0.5) + 0.5;
                float loc_19cd0 = dot(CascadesPerSet, vec4(1.0));
                float loc_543e1;
                loc_543e1 = 0.0;
                float loc_0fce1;
                for (int loc_093cd = 0; loc_093cd < loc_c86ff; loc_543e1 = loc_0fce1, loc_093cd++)
                {
                    loc_0fce1 = loc_543e1;
                    float loc_16f2e;
                    for (int loc_fdb90 = 0; loc_fdb90 < loc_c86ff; loc_0fce1 = loc_16f2e, loc_fdb90++)
                    {
                        vec3 loc_d07c9 = vec3(loc_37738 + ((vec2(float(loc_fdb90 - loc_7508d) + 0.5, float(loc_093cd - loc_7508d) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_19cd0);
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_16f2e = loc_0fce1 + float(textureLod(s_ShadowCascades, loc_d07c9, 0.0).x >= loc_bcbd7.z);
                        }
                        else
                        {
                            vec4 loc_2ae6b = step(vec4(loc_bcbd7.z), textureGather(s_ShadowCascades, loc_d07c9));
                            vec2 loc_52300 = fract((loc_d07c9.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            loc_16f2e = loc_0fce1 + mix(mix(loc_2ae6b.w, loc_2ae6b.z, loc_52300.x), mix(loc_2ae6b.x, loc_2ae6b.y, loc_52300.x), loc_52300.y);
                        }
                    }
                }
                float loc_8a60e = loc_543e1 / float(loc_c86ff * loc_c86ff);
                float loc_26602;
                if (loc_8a60e < 1.0)
                {
                    loc_26602 = min(1.0, max(loc_8a60e, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                }
                else
                {
                    loc_26602 = 1.0;
                }
                loc_4a190 = loc_26602;
            }
            else
            {
                loc_4a190 = 1.0;
            }
            loc_af838 = mix(min(loc_f6ac1, min(loc_f828f, loc_4a190)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -0.0));
        }
        else
        {
            loc_af838 = 1.0;
        }
        float loc_768e3 = (1.0 + (loc_3fa4b * loc_3fa4b)) + ((2.0 * loc_3fa4b) * dot(loc_09caf, normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_4de69 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_1bbb0 = loc_fc3e3 + (((loc_c5faf * loc_af838) * ((0.079577468335628509521484375 * (1.0 - (loc_3fa4b * loc_3fa4b))) / (loc_768e3 * sqrt(loc_768e3)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_4de69.w));
    }
    else
    {
        loc_1bbb0 = loc_fc3e3;
    }
    bool loc_15286 = VolumeScatteringEnabledAndPointLightVolumetricsEnabled.y != 0.0;
    bool loc_936b4;
    if (loc_15286)
    {
        loc_936b4 = DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0;
    }
    else
    {
        loc_936b4 = loc_15286;
    }
    vec3 loc_0bece;
    if (loc_936b4)
    {
        vec3 loc_92891;
        func_0582d(loc_49313, loc_92891, loc_65ac0, loc_3fa4b, loc_09caf, loc_c5faf);
        loc_0bece = loc_1bbb0 + loc_92891;
    }
    else
    {
        loc_0bece = loc_1bbb0;
    }
    if (TemporalSettings.x > 0.0)
    {
        vec3 loc_dfafd = (vec3(float(loc_da723), float(loc_1c644), float(loc_beae9)) + vec3(0.5)) / VolumeDimensions.xyz;
        vec3 loc_e9300 = loc_dfafd;
        vec2 loc_9d396 = VolumeNearFar.xy;
        float loc_fcd55 = (exp(4.0 * loc_e9300.z) - 1.0) * 0.0186573602259159088134765625;
        vec4 loc_62495 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcd55) * loc_9d396.x) + (loc_fcd55 * loc_9d396.y)), 1.0);
        vec4 loc_d7f13 = u_invViewProj * vec4((loc_dfafd.xy * 2.0) - vec2(1.0), loc_62495.z / loc_62495.w, 1.0);
        vec4 loc_d1c9b = loc_d7f13;
        vec4 loc_bf151 = u_prevViewProj * vec4((loc_d7f13.xyz / vec3(loc_d1c9b.w)) - u_prevWorldPosOffset.xyz, 1.0);
        vec4 loc_d9ce7 = loc_bf151;
        vec3 loc_ec028 = loc_bf151.xyz / vec3(loc_d9ce7.w);
        vec2 loc_1fa2a = VolumeNearFar.xy;
        vec2 loc_81f33 = (loc_ec028.xy + vec2(1.0)) * 0.5;
        vec4 loc_3fd1f = PrevInvProj * vec4(loc_ec028, 1.0);
        float loc_d255f = loc_81f33.x;
        vec3 loc_33e20 = vec3(loc_d255f, loc_81f33.y, log((53.598148345947265625 * ((((-loc_3fd1f.z) / loc_3fd1f.w) - loc_1fa2a.x) / (loc_1fa2a.y - loc_1fa2a.x))) + 1.0) * 0.25);
        ivec3 loc_dbdb4 = ivec3(VolumeDimensions.xyz);
        ivec3 loc_57985 = loc_dbdb4;
        vec3 loc_96ba4 = loc_33e20;
        float loc_53f43 = (loc_96ba4.z * float(loc_57985.z)) - 0.5;
        int loc_25a80 = clamp(int(loc_53f43), 0, loc_57985.z - 2);
        vec3 loc_34735 = VolumeDimensions.xyz * loc_33e20;
        imageStore(s_CurrentLightingBuffer, ivec3(loc_da723, loc_1c644, loc_beae9), mix(vec4(loc_0bece, loc_8068a), mix(textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80)), 0.0), textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80 + 1)), 0.0), vec4(clamp(loc_53f43 - float(loc_25a80), 0.0, 1.0))), vec4(mix(TemporalSettings.z, 0.0, clamp(length(clamp(loc_34735, vec3(0.0), vec3(loc_dbdb4)) - loc_34735) * TemporalSettings.y, 0.0, 1.0)))));
    }
    else
    {
        imageStore(s_CurrentLightingBuffer, ivec3(loc_da723, loc_1c644, loc_beae9), vec4(loc_0bece, loc_8068a));
    }
}
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
void func_d4e78() {
    int loc_da723 = int(GlobalInvocationID.x);
    int loc_1c644 = int(GlobalInvocationID.y);
    int loc_beae9 = int(GlobalInvocationID.z);
    if (((loc_da723 >= int(VolumeDimensions.x)) || (loc_1c644 >= int(VolumeDimensions.y))) || (loc_beae9 >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_8b342 = ((vec3(float(loc_da723), float(loc_1c644), float(loc_beae9)) + vec3(0.5)) + JitterOffset.xyz) / VolumeDimensions.xyz;
    vec3 loc_b4177 = loc_8b342;
    vec3 loc_777c2 = loc_8b342;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_8b342.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_4b174 = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_4b174;
    vec3 loc_16a16 = (u_view * vec4(loc_4b174, 1.0)).xyz;
    ivec2 loc_96650 = ivec2(gl_GlobalInvocationID.xy);
    vec2 loc_f3117 = texelFetch(s_ScreenSpaceWaterFrontFaceDepthAndNormal, loc_96650, 0).xy;
    vec2 loc_9e759 = texelFetch(s_ScreenSpaceWaterBackFaceDepthAndNormal, loc_96650, 0).xy;
    float loc_f2b43 = smoothstep(-0.5, 0.5, ((((loc_b4177.z - loc_f3117.x) * VolumeDimensions.z) * loc_f3117.y) - CameraUnderwaterAndWaterSurfaceBiasAndFalloff.y) / CameraUnderwaterAndWaterSurfaceBiasAndFalloff.z);
    float loc_8fa9c;
    if (loc_f2b43 >= 0.0)
    {
        float loc_efd00;
        if ((loc_b4177.z - loc_9e759.x) >= 0.0)
        {
            loc_efd00 = 0.0;
        }
        else
        {
            loc_efd00 = loc_f2b43;
        }
        loc_8fa9c = loc_efd00;
    }
    else
    {
        loc_8fa9c = loc_f2b43;
    }
    float loc_343cf;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_343cf = 1.0 - loc_8fa9c;
    }
    else
    {
        loc_343cf = loc_8fa9c;
    }
    vec4 loc_4397b;
    func_b5ebb(loc_4b174, loc_4397b);
    vec4 loc_12f1c = loc_4397b;
    float loc_ebd19 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_a9dfb = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_343cf);
    float loc_9fe9d = length(loc_16a16);
    float loc_ab2d8 = clamp((((loc_9fe9d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_62e93 = mix(mix((AirAlbedoExtinction.xyz * loc_ebd19) * AirAlbedoExtinction.w, loc_4397b.xyz * loc_12f1c.w, vec3(loc_343cf)), vec3(0.0), vec3(loc_ab2d8));
    float loc_8068a = mix(mix(loc_ebd19 * AirAlbedoExtinction.w, loc_12f1c.w, loc_343cf), 0.0, loc_ab2d8);
    vec2 loc_ea783 = vec2(0.0, CameraAmbientContribution.y);
    bool loc_f682a = SkySamplesConfig.x > 0.5;
    bool loc_39b3d;
    if (loc_f682a)
    {
        loc_39b3d = AtmosphericScatteringToggles.w > 0.5;
    }
    else
    {
        loc_39b3d = loc_f682a;
    }
    if (loc_39b3d)
    {
        vec3 loc_08c5f = loc_8b342;
        loc_08c5f.y = 1.0 - loc_08c5f.y;
        if (SkySamplesConfig.y > 0.5)
        {
            loc_08c5f.z -= SkySamplesConfig.z;
        }
        loc_08c5f.z = (exp(4.0 * loc_08c5f.z) - 1.0) * 0.0186573602259159088134765625;
        loc_ea783 = textureLod(s_SkyAmbientSamples, loc_08c5f, 0.0).xy;
    }
    vec3 loc_f8a58;
    if (DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled.w != 0.0)
    {
        vec3 loc_a150e = (loc_4b174 - WorldOrigin.xyz) + vec3(-0.5, -0.5, -0.4799999892711639404296875);
        ivec3 loc_3d422 = ivec3(floor(loc_a150e));
        vec3 loc_e6082 = floor(loc_a150e * 0.0625) * 16.0;
        vec3 loc_10c2e = loc_a150e - loc_e6082;
        ivec4 loc_984ab = ivec4((loc_3d422 - (ivec3(15) & (loc_3d422 >> ivec3(31)))) / ivec3(16), 0);
        ivec4 loc_bdc37 = loc_984ab;
        int loc_ef361 = (loc_bdc37.x & 65535) | (loc_bdc37.y << 16);
        int loc_10f25 = (loc_bdc37.z & 65535) | (loc_bdc37.w << 16);
        ivec4 loc_4e614 = loc_984ab;
        uint loc_48d5b = uint(loc_4e614.x) * 1540483477u;
        uint loc_d322d = uint(loc_4e614.y) * 1540483477u;
        uint loc_33724 = uint(loc_4e614.z) * 1540483477u;
        uint loc_05410 = uint(loc_4e614.w) * 1540483477u;
        uint loc_fd4f6 = ((((((2293326976u ^ ((loc_48d5b ^ (loc_48d5b >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_d322d ^ (loc_d322d >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_33724 ^ (loc_33724 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_05410 ^ (loc_05410 >> uint(24))) * 1540483477u);
        uint loc_2545b = (loc_fd4f6 ^ (loc_fd4f6 >> uint(13))) * 1540483477u;
        uint loc_19f5a = loc_2545b ^ (loc_2545b >> uint(15));
        uint loc_065df = (loc_19f5a ^ (loc_19f5a >> uint(16))) & 65535u;
        uint loc_19109 = loc_065df | uint(loc_065df == 0u);
        int loc_d6224;
        uint loc_bcfea;
        bool loc_87a71;
        int loc_f503c;
        loc_f503c = 0;
        loc_87a71 = false;
        loc_bcfea = loc_19109 & uint(GpuEntryBufferCapacity.x - 1.0);
        loc_d6224 = 0;
        bool loc_4f504;
        uint loc_85325;
        int loc_4035a;
        int loc_cfe5d;
        bool loc_a0c0a;
        for (;;)
        {
            if (loc_d6224 < 8)
            {
                uint loc_23c71 = uint(var_5ae14.zGpuEntryBuffer[loc_bcfea].hash) & 65535u;
                bool loc_734de = loc_23c71 == loc_19109;
                bool loc_166d2;
                if (loc_734de)
                {
                    loc_166d2 = var_5ae14.zGpuEntryBuffer[loc_bcfea].packed_xy == loc_ef361;
                }
                else
                {
                    loc_166d2 = loc_734de;
                }
                bool loc_09802;
                if (loc_166d2)
                {
                    loc_09802 = var_5ae14.zGpuEntryBuffer[loc_bcfea].packed_zw == loc_10f25;
                }
                else
                {
                    loc_09802 = loc_166d2;
                }
                if (loc_87a71)
                {
                    loc_4035a = loc_f503c;
                }
                else
                {
                    int loc_c38b2;
                    if (loc_09802)
                    {
                        loc_c38b2 = var_5ae14.zGpuEntryBuffer[loc_bcfea].user_data;
                    }
                    else
                    {
                        loc_c38b2 = loc_f503c;
                    }
                    loc_4035a = loc_c38b2;
                }
                loc_4f504 = loc_87a71 || loc_09802;
                loc_85325 = (loc_bcfea + 1u) & uint(GpuEntryBufferCapacity.x - 1.0);
                if (loc_4f504 || (loc_23c71 == 0u))
                {
                    loc_a0c0a = loc_4f504;
                    loc_cfe5d = loc_4035a;
                    break;
                }
                loc_f503c = loc_4035a;
                loc_87a71 = loc_4f504;
                loc_bcfea = loc_85325;
                loc_d6224++;
                continue;
            }
            else
            {
                loc_a0c0a = loc_87a71;
                loc_cfe5d = loc_f503c;
                break;
            }
        }
        uint loc_f8e5a = uint(loc_cfe5d >> int(2u));
        vec3 loc_9dfcc;
        if (loc_a0c0a)
        {
            vec3 loc_e9cfe = abs(vec3(0.0, 0.0, 0.100000001490116119384765625));
            vec3 loc_38482;
            if (any(greaterThanEqual(loc_e9cfe, vec3(1.0))))
            {
                vec3 loc_e187d = vec3(0.0, 0.0, 0.100000001490116119384765625);
                vec3 loc_0f5c1 = abs(vec3(0.0, 0.0, 0.100000001490116119384765625));
                float loc_fc63e = dot(loc_10c2e, loc_0f5c1);
                float loc_f7571 = dot(loc_10c2e, loc_0f5c1.zxy);
                float loc_3d321 = dot(loc_10c2e, loc_0f5c1.yzx);
                float loc_316c7;
                if (((loc_e187d.x + loc_e187d.y) + loc_e187d.z) > 0.0)
                {
                    loc_316c7 = ceil(loc_fc63e);
                }
                else
                {
                    loc_316c7 = floor(loc_fc63e);
                }
                float loc_b5544 = floor(loc_f7571);
                float loc_71b3f = floor(loc_3d321);
                vec3 loc_b0b0a = ((loc_0f5c1 * loc_316c7) + (loc_0f5c1.zxy * loc_b5544)) + (loc_0f5c1.yzx * loc_71b3f);
                vec3 loc_a7514 = loc_b0b0a + loc_0f5c1.zxy;
                vec3 loc_efd87 = loc_b0b0a + loc_0f5c1.yzx;
                vec3 loc_85c15 = (loc_b0b0a + loc_0f5c1.zxy) + loc_0f5c1.yzx;
                float loc_559ac = loc_f7571 - loc_b5544;
                float loc_cfe6d = loc_3d321 - loc_71b3f;
                float loc_1bffd = 1.0 - loc_559ac;
                float loc_9eba4 = 1.0 - loc_cfe6d;
                vec4 loc_c8459 = vec4(loc_1bffd * loc_9eba4, loc_559ac * loc_9eba4, loc_1bffd * loc_cfe6d, loc_559ac * loc_cfe6d);
                bool loc_66a92 = all(greaterThanEqual(loc_b0b0a, vec3(0.0)));
                bool loc_3aded;
                if (loc_66a92)
                {
                    loc_3aded = all(lessThan(loc_85c15, vec3(16.0)));
                }
                else
                {
                    loc_3aded = loc_66a92;
                }
                vec3 loc_3790a;
                vec3 loc_e618a;
                vec3 loc_7798e;
                vec3 loc_c026f;
                if (loc_3aded)
                {
                    uvec3 loc_76274 = uvec3(loc_b0b0a);
                    uint loc_ec371 = loc_f8e5a + ((loc_76274.y + (loc_76274.z * 16u)) + (loc_76274.x * 256u));
                    vec3 loc_ccbe3;
                    func_f4166(loc_ec371, loc_ccbe3);
                    uvec3 loc_3e46f = uvec3(loc_a7514);
                    uint loc_b0fec = loc_f8e5a + ((loc_3e46f.y + (loc_3e46f.z * 16u)) + (loc_3e46f.x * 256u));
                    vec3 loc_a7253;
                    func_f4166(loc_b0fec, loc_a7253);
                    uvec3 loc_20318 = uvec3(loc_efd87);
                    uint loc_9884e = loc_f8e5a + ((loc_20318.y + (loc_20318.z * 16u)) + (loc_20318.x * 256u));
                    vec3 loc_8b61c;
                    func_f4166(loc_9884e, loc_8b61c);
                    uvec3 loc_039c5 = uvec3(loc_85c15);
                    uint loc_0ad06 = loc_f8e5a + ((loc_039c5.y + (loc_039c5.z * 16u)) + (loc_039c5.x * 256u));
                    vec3 loc_6ebe7;
                    func_f4166(loc_0ad06, loc_6ebe7);
                    loc_c026f = loc_6ebe7;
                    loc_7798e = loc_8b61c;
                    loc_e618a = loc_a7253;
                    loc_3790a = loc_ccbe3;
                }
                else
                {
                    vec3 loc_a6ee2 = loc_e6082 + loc_b0b0a;
                    vec3 loc_37729;
                    func_97457(loc_a6ee2, loc_e6082, loc_f8e5a, loc_37729);
                    vec3 loc_49861 = loc_e6082 + loc_a7514;
                    vec3 loc_0a440;
                    func_97457(loc_49861, loc_e6082, loc_f8e5a, loc_0a440);
                    vec3 loc_c4461 = loc_e6082 + loc_efd87;
                    vec3 loc_7aa09;
                    func_97457(loc_c4461, loc_e6082, loc_f8e5a, loc_7aa09);
                    vec3 loc_98ea7 = loc_e6082 + loc_85c15;
                    vec3 loc_df625;
                    func_97457(loc_98ea7, loc_e6082, loc_f8e5a, loc_df625);
                    loc_c026f = loc_df625;
                    loc_7798e = loc_7aa09;
                    loc_e618a = loc_0a440;
                    loc_3790a = loc_37729;
                }
                loc_38482 = (((loc_3790a * loc_c8459.x) + (loc_e618a * loc_c8459.y)) + (loc_7798e * loc_c8459.z)) + (loc_c026f * loc_c8459.w);
            }
            else
            {
                vec3 loc_907d7 = floor(loc_10c2e);
                vec3 loc_41313 = loc_10c2e - loc_907d7;
                int loc_838c3 = (int(loc_41313.x >= loc_41313.y) | (int(loc_41313.y >= loc_41313.z) << 1)) | (int(loc_41313.x >= loc_41313.z) << 2);
                uvec3 loc_2256d = uvec3(loc_907d7);
                float loc_c9d33 = min(loc_41313.x, loc_41313.y);
                float loc_4279f = max(loc_41313.x, loc_41313.y);
                float loc_6c645 = min(loc_c9d33, loc_41313.z);
                float loc_9b92e = max(loc_4279f, loc_41313.z);
                float loc_2e4ef = max(min(loc_4279f, loc_41313.z), loc_c9d33);
                bool loc_59db7 = all(greaterThanEqual(loc_907d7, vec3(0.0)));
                bool loc_64535;
                if (loc_59db7)
                {
                    loc_64535 = all(lessThan(loc_907d7 + vec3(1.0), vec3(16.0)));
                }
                else
                {
                    loc_64535 = loc_59db7;
                }
                vec3 loc_f5360;
                vec3 loc_c730e;
                vec3 loc_9ef2b;
                vec3 loc_c705c;
                if (loc_64535)
                {
                    uvec3 loc_e7bc3 = loc_2256d;
                    uint loc_7c5b8 = loc_f8e5a + ((loc_e7bc3.y + (loc_e7bc3.z * 16u)) + (loc_e7bc3.x * 256u));
                    vec3 loc_e2dbc;
                    func_f4166(loc_7c5b8, loc_e2dbc);
                    uvec3 loc_4b2ae = loc_2256d + var_a8473[loc_838c3];
                    uint loc_5a2ce = loc_f8e5a + ((loc_4b2ae.y + (loc_4b2ae.z * 16u)) + (loc_4b2ae.x * 256u));
                    vec3 loc_bcf05;
                    func_f4166(loc_5a2ce, loc_bcf05);
                    uvec3 loc_e087a = loc_2256d + var_a719c[loc_838c3];
                    uint loc_fc69d = loc_f8e5a + ((loc_e087a.y + (loc_e087a.z * 16u)) + (loc_e087a.x * 256u));
                    vec3 loc_253f2;
                    func_f4166(loc_fc69d, loc_253f2);
                    uvec3 loc_f09be = loc_2256d + uvec3(1u);
                    uint loc_9db6e = loc_f8e5a + ((loc_f09be.y + (loc_f09be.z * 16u)) + (loc_f09be.x * 256u));
                    vec3 loc_5d322;
                    func_f4166(loc_9db6e, loc_5d322);
                    loc_c705c = loc_5d322;
                    loc_9ef2b = loc_253f2;
                    loc_c730e = loc_bcf05;
                    loc_f5360 = loc_e2dbc;
                }
                else
                {
                    vec3 loc_97e91 = loc_e6082 + loc_907d7;
                    vec3 loc_05d51;
                    func_97457(loc_97e91, loc_e6082, loc_f8e5a, loc_05d51);
                    vec3 loc_70bfd = loc_e6082 + (loc_907d7 + var_223ba[loc_838c3]);
                    vec3 loc_a5475;
                    func_97457(loc_70bfd, loc_e6082, loc_f8e5a, loc_a5475);
                    vec3 loc_4e4c2 = loc_e6082 + (loc_907d7 + var_0f733[loc_838c3]);
                    vec3 loc_2cf94;
                    func_97457(loc_4e4c2, loc_e6082, loc_f8e5a, loc_2cf94);
                    vec3 loc_fa2e7 = loc_e6082 + (loc_907d7 + vec3(1.0));
                    vec3 loc_dabf1;
                    func_97457(loc_fa2e7, loc_e6082, loc_f8e5a, loc_dabf1);
                    loc_c705c = loc_dabf1;
                    loc_9ef2b = loc_2cf94;
                    loc_c730e = loc_a5475;
                    loc_f5360 = loc_05d51;
                }
                loc_38482 = (((loc_f5360 * (1.0 - loc_9b92e)) + (loc_c730e * (loc_9b92e - loc_2e4ef))) + (loc_9ef2b * (loc_2e4ef - loc_6c645))) + (loc_c705c * loc_6c645);
            }
            loc_9dfcc = loc_38482;
        }
        else
        {
            loc_9dfcc = vec3(0.0);
        }
        loc_f8a58 = (loc_9dfcc * BlockBaseAmbientLightColorIntensity.xyz) * BlockBaseAmbientLightColorIntensity.w;
    }
    else
    {
        loc_f8a58 = (BlockBaseAmbientLightColorIntensity.xyz * loc_ea783.x) * BlockBaseAmbientLightColorIntensity.w;
    }
    vec3 loc_1f4b9 = ((loc_62e93 * 0.079577468335628509521484375) * max(loc_f8a58 + ((SkyAmbientLightColorIntensity.xyz * loc_ea783.y) * SkyAmbientLightColorIntensity.w), vec3(MinAmbientValue.x))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    bool loc_5b439 = !(DirectionalLightSkyLightHeuristicToggles.y != 0.0);
    bool loc_7e26a;
    if (!loc_5b439)
    {
        loc_7e26a = abs(loc_ea783.y) > 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_7e26a = loc_5b439;
    }
    vec3 loc_7175c;
    if (loc_7e26a)
    {
        float loc_af838;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            int loc_c0de4 = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
            float loc_f6ac1;
            loc_f6ac1 = 1.0;
            int loc_29996;
            float loc_484ee;
            for (int loc_8a709 = 0, loc_0e4f2 = 0; loc_8a709 < loc_c0de4; loc_0e4f2 = loc_29996, loc_f6ac1 = loc_484ee, loc_8a709++)
            {
                int loc_79423 = min((loc_0e4f2 + int(CascadesPerSet[loc_8a709])), 8);
                loc_484ee = loc_f6ac1;
                loc_29996 = loc_0e4f2;
                int loc_a0458;
                float loc_5399e;
                for (; loc_29996 < loc_79423; loc_484ee = loc_5399e, loc_29996 = loc_a0458)
                {
                    vec4 loc_4a0d9 = CascadesShadowProj[loc_29996] * vec4(loc_4b174, 1.0);
                    vec3 loc_8d38c = abs(loc_4a0d9.xyz);
                    bool loc_45980 = loc_8d38c.x <= 1.0;
                    bool loc_f1421;
                    if (loc_45980)
                    {
                        loc_f1421 = loc_8d38c.y <= 1.0;
                    }
                    else
                    {
                        loc_f1421 = loc_45980;
                    }
                    bool loc_e36b7;
                    if (loc_f1421)
                    {
                        loc_e36b7 = loc_8d38c.z <= 1.0;
                    }
                    else
                    {
                        loc_e36b7 = loc_f1421;
                    }
                    if (loc_e36b7)
                    {
                        vec4 loc_38cc9 = loc_4a0d9;
                        int loc_3a40c;
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_3a40c = 1;
                        }
                        else
                        {
                            loc_3a40c = clamp(int((CascadesParameters[loc_29996].w * VolumeShadowSettings.x) + 0.5), 1, 9);
                        }
                        int loc_960ef = loc_3a40c / 2;
                        vec2 loc_dc4ac = ((loc_4a0d9.xy * 0.5) + vec2(0.5)) * CascadesParameters[loc_29996].x;
                        float loc_4fba3 = (loc_38cc9.z * 0.5) + 0.5;
                        loc_dc4ac.y += (1.0 - CascadesParameters[loc_29996].x);
                        float loc_3555e;
                        loc_3555e = 0.0;
                        float loc_801c0;
                        for (int loc_15249 = 0; loc_15249 < loc_3a40c; loc_3555e = loc_801c0, loc_15249++)
                        {
                            loc_801c0 = loc_3555e;
                            float loc_30840;
                            for (int loc_963d2 = 0; loc_963d2 < loc_3a40c; loc_801c0 = loc_30840, loc_963d2++)
                            {
                                vec2 loc_cced5 = loc_dc4ac + ((vec2(float(loc_963d2 - loc_960ef) + 0.5, float(loc_15249 - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_29996].x);
                                vec4 loc_fe3f0 = textureGather(s_ShadowCascades, vec3(loc_cced5, float(loc_29996)));
                                vec4 loc_26b65 = loc_fe3f0;
                                if (QuantizationParameters.x != 0.0)
                                {
                                    loc_30840 = loc_801c0 + float(loc_26b65.w >= (loc_4fba3 - CascadesParameters[loc_29996].y));
                                }
                                else
                                {
                                    vec4 loc_2f6b4 = step(vec4(loc_4fba3 - CascadesParameters[loc_29996].y), loc_fe3f0);
                                    vec2 loc_e2aba = fract((loc_cced5 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                    loc_30840 = loc_801c0 + mix(mix(loc_2f6b4.w, loc_2f6b4.z, loc_e2aba.x), mix(loc_2f6b4.x, loc_2f6b4.y, loc_e2aba.x), loc_e2aba.y);
                                }
                            }
                        }
                        loc_5399e = min(loc_484ee, loc_3555e / float(loc_3a40c * loc_3a40c));
                        loc_a0458 = loc_79423;
                    }
                    else
                    {
                        loc_5399e = loc_484ee;
                        loc_a0458 = loc_29996 + 1;
                    }
                }
            }
            float loc_f828f;
            if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
            {
                float loc_ad066;
                func_a0b5c(loc_4b174, loc_ad066);
                loc_f828f = loc_ad066;
            }
            else
            {
                loc_f828f = 1.0;
            }
            bool loc_8174b = int(CloudShadowsVisible.x) > 0;
            bool loc_b7807;
            if (loc_8174b)
            {
                loc_b7807 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
            }
            else
            {
                loc_b7807 = loc_8174b;
            }
            float loc_4a190;
            if (loc_b7807)
            {
                vec4 loc_bcd0f = CloudShadowProj * vec4(loc_4b174, 1.0);
                vec4 loc_bcbd7 = loc_bcd0f;
                loc_bcbd7 = loc_bcd0f / vec4(loc_bcbd7.w);
                loc_bcbd7.z -= (CascadesParameters[0].y / loc_bcbd7.w);
                int loc_c86ff;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_c86ff = 1;
                }
                else
                {
                    loc_c86ff = clamp(int((EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * VolumeShadowSettings.x) + 0.5), 1, 9);
                }
                int loc_7508d = loc_c86ff / 2;
                vec2 loc_37738 = ((loc_bcbd7.xy * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
                loc_37738.y += (1.0 - CascadesParameters[0].x);
                loc_bcbd7.z = (loc_bcbd7.z * 0.5) + 0.5;
                float loc_19cd0 = dot(CascadesPerSet, vec4(1.0));
                float loc_543e1;
                loc_543e1 = 0.0;
                float loc_0fce1;
                for (int loc_093cd = 0; loc_093cd < loc_c86ff; loc_543e1 = loc_0fce1, loc_093cd++)
                {
                    loc_0fce1 = loc_543e1;
                    float loc_16f2e;
                    for (int loc_fdb90 = 0; loc_fdb90 < loc_c86ff; loc_0fce1 = loc_16f2e, loc_fdb90++)
                    {
                        vec3 loc_d07c9 = vec3(loc_37738 + ((vec2(float(loc_fdb90 - loc_7508d) + 0.5, float(loc_093cd - loc_7508d) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_19cd0);
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_16f2e = loc_0fce1 + float(textureLod(s_ShadowCascades, loc_d07c9, 0.0).x >= loc_bcbd7.z);
                        }
                        else
                        {
                            vec4 loc_2ae6b = step(vec4(loc_bcbd7.z), textureGather(s_ShadowCascades, loc_d07c9));
                            vec2 loc_52300 = fract((loc_d07c9.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            loc_16f2e = loc_0fce1 + mix(mix(loc_2ae6b.w, loc_2ae6b.z, loc_52300.x), mix(loc_2ae6b.x, loc_2ae6b.y, loc_52300.x), loc_52300.y);
                        }
                    }
                }
                float loc_8a60e = loc_543e1 / float(loc_c86ff * loc_c86ff);
                float loc_26602;
                if (loc_8a60e < 1.0)
                {
                    loc_26602 = min(1.0, max(loc_8a60e, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                }
                else
                {
                    loc_26602 = 1.0;
                }
                loc_4a190 = loc_26602;
            }
            else
            {
                loc_4a190 = 1.0;
            }
            loc_af838 = mix(min(loc_f6ac1, min(loc_f828f, loc_4a190)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -0.0));
        }
        else
        {
            loc_af838 = 1.0;
        }
        float loc_44a26 = (1.0 + (loc_a9dfb * loc_a9dfb)) + ((2.0 * loc_a9dfb) * dot(-(loc_16a16 / vec3(loc_9fe9d)), normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_4de69 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_7175c = loc_1f4b9 + (((loc_62e93 * loc_af838) * ((0.079577468335628509521484375 * (1.0 - (loc_a9dfb * loc_a9dfb))) / (loc_44a26 * sqrt(loc_44a26)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_4de69.w));
    }
    else
    {
        loc_7175c = loc_1f4b9;
    }
    if (TemporalSettings.x > 0.0)
    {
        vec3 loc_dfafd = (vec3(float(loc_da723), float(loc_1c644), float(loc_beae9)) + vec3(0.5)) / VolumeDimensions.xyz;
        vec3 loc_e9300 = loc_dfafd;
        vec2 loc_9d396 = VolumeNearFar.xy;
        float loc_fcd55 = (exp(4.0 * loc_e9300.z) - 1.0) * 0.0186573602259159088134765625;
        vec4 loc_62495 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcd55) * loc_9d396.x) + (loc_fcd55 * loc_9d396.y)), 1.0);
        vec4 loc_d7f13 = u_invViewProj * vec4((loc_dfafd.xy * 2.0) - vec2(1.0), loc_62495.z / loc_62495.w, 1.0);
        vec4 loc_d1c9b = loc_d7f13;
        vec4 loc_bf151 = u_prevViewProj * vec4((loc_d7f13.xyz / vec3(loc_d1c9b.w)) - u_prevWorldPosOffset.xyz, 1.0);
        vec4 loc_d9ce7 = loc_bf151;
        vec3 loc_ec028 = loc_bf151.xyz / vec3(loc_d9ce7.w);
        vec2 loc_1fa2a = VolumeNearFar.xy;
        vec2 loc_81f33 = (loc_ec028.xy + vec2(1.0)) * 0.5;
        vec4 loc_3fd1f = PrevInvProj * vec4(loc_ec028, 1.0);
        float loc_d255f = loc_81f33.x;
        vec3 loc_33e20 = vec3(loc_d255f, loc_81f33.y, log((53.598148345947265625 * ((((-loc_3fd1f.z) / loc_3fd1f.w) - loc_1fa2a.x) / (loc_1fa2a.y - loc_1fa2a.x))) + 1.0) * 0.25);
        ivec3 loc_dbdb4 = ivec3(VolumeDimensions.xyz);
        ivec3 loc_57985 = loc_dbdb4;
        vec3 loc_96ba4 = loc_33e20;
        float loc_53f43 = (loc_96ba4.z * float(loc_57985.z)) - 0.5;
        int loc_25a80 = clamp(int(loc_53f43), 0, loc_57985.z - 2);
        vec3 loc_34735 = VolumeDimensions.xyz * loc_33e20;
        imageStore(s_CurrentLightingBuffer, ivec3(loc_da723, loc_1c644, loc_beae9), mix(vec4(loc_7175c, loc_8068a), mix(textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80)), 0.0), textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80 + 1)), 0.0), vec4(clamp(loc_53f43 - float(loc_25a80), 0.0, 1.0))), vec4(mix(TemporalSettings.z, 0.0, clamp(length(clamp(loc_34735, vec3(0.0), vec3(loc_dbdb4)) - loc_34735) * TemporalSettings.y, 0.0, 1.0)))));
    }
    else
    {
        imageStore(s_CurrentLightingBuffer, ivec3(loc_da723, loc_1c644, loc_beae9), vec4(loc_7175c, loc_8068a));
    }
}
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
void func_584fc() {
    int loc_da723 = int(GlobalInvocationID.x);
    int loc_1c644 = int(GlobalInvocationID.y);
    int loc_beae9 = int(GlobalInvocationID.z);
    if (((loc_da723 >= int(VolumeDimensions.x)) || (loc_1c644 >= int(VolumeDimensions.y))) || (loc_beae9 >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_8b342 = ((vec3(float(loc_da723), float(loc_1c644), float(loc_beae9)) + vec3(0.5)) + JitterOffset.xyz) / VolumeDimensions.xyz;
    vec3 loc_b4177 = loc_8b342;
    vec3 loc_777c2 = loc_8b342;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_8b342.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_4f76f = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_4f76f;
    vec3 loc_49313 = (u_view * vec4(loc_4f76f, 1.0)).xyz;
    ivec2 loc_96650 = ivec2(gl_GlobalInvocationID.xy);
    vec2 loc_f3117 = texelFetch(s_ScreenSpaceWaterFrontFaceDepthAndNormal, loc_96650, 0).xy;
    vec2 loc_9e759 = texelFetch(s_ScreenSpaceWaterBackFaceDepthAndNormal, loc_96650, 0).xy;
    float loc_f2b43 = smoothstep(-0.5, 0.5, ((((loc_b4177.z - loc_f3117.x) * VolumeDimensions.z) * loc_f3117.y) - CameraUnderwaterAndWaterSurfaceBiasAndFalloff.y) / CameraUnderwaterAndWaterSurfaceBiasAndFalloff.z);
    float loc_8fa9c;
    if (loc_f2b43 >= 0.0)
    {
        float loc_efd00;
        if ((loc_b4177.z - loc_9e759.x) >= 0.0)
        {
            loc_efd00 = 0.0;
        }
        else
        {
            loc_efd00 = loc_f2b43;
        }
        loc_8fa9c = loc_efd00;
    }
    else
    {
        loc_8fa9c = loc_f2b43;
    }
    float loc_343cf;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_343cf = 1.0 - loc_8fa9c;
    }
    else
    {
        loc_343cf = loc_8fa9c;
    }
    vec4 loc_4397b;
    func_b5ebb(loc_4f76f, loc_4397b);
    vec4 loc_12f1c = loc_4397b;
    float loc_ebd19 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_3fa4b = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_343cf);
    float loc_1595d = length(loc_49313);
    float loc_ab2d8 = clamp((((loc_1595d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_450d3 = mix(mix((AirAlbedoExtinction.xyz * loc_ebd19) * AirAlbedoExtinction.w, loc_4397b.xyz * loc_12f1c.w, vec3(loc_343cf)), vec3(0.0), vec3(loc_ab2d8));
    float loc_8068a = mix(mix(loc_ebd19 * AirAlbedoExtinction.w, loc_12f1c.w, loc_343cf), 0.0, loc_ab2d8);
    vec2 loc_ea783 = vec2(0.0, CameraAmbientContribution.y);
    bool loc_f682a = SkySamplesConfig.x > 0.5;
    bool loc_39b3d;
    if (loc_f682a)
    {
        loc_39b3d = AtmosphericScatteringToggles.w > 0.5;
    }
    else
    {
        loc_39b3d = loc_f682a;
    }
    if (loc_39b3d)
    {
        vec3 loc_08c5f = loc_8b342;
        loc_08c5f.y = 1.0 - loc_08c5f.y;
        if (SkySamplesConfig.y > 0.5)
        {
            loc_08c5f.z -= SkySamplesConfig.z;
        }
        loc_08c5f.z = (exp(4.0 * loc_08c5f.z) - 1.0) * 0.0186573602259159088134765625;
        loc_ea783 = textureLod(s_SkyAmbientSamples, loc_08c5f, 0.0).xy;
    }
    vec3 loc_f8a58;
    if (DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled.w != 0.0)
    {
        vec3 loc_a150e = (loc_4f76f - WorldOrigin.xyz) + vec3(-0.5, -0.5, -0.4799999892711639404296875);
        ivec3 loc_3d422 = ivec3(floor(loc_a150e));
        vec3 loc_e6082 = floor(loc_a150e * 0.0625) * 16.0;
        vec3 loc_10c2e = loc_a150e - loc_e6082;
        ivec4 loc_984ab = ivec4((loc_3d422 - (ivec3(15) & (loc_3d422 >> ivec3(31)))) / ivec3(16), 0);
        ivec4 loc_bdc37 = loc_984ab;
        int loc_ef361 = (loc_bdc37.x & 65535) | (loc_bdc37.y << 16);
        int loc_10f25 = (loc_bdc37.z & 65535) | (loc_bdc37.w << 16);
        ivec4 loc_4e614 = loc_984ab;
        uint loc_48d5b = uint(loc_4e614.x) * 1540483477u;
        uint loc_d322d = uint(loc_4e614.y) * 1540483477u;
        uint loc_33724 = uint(loc_4e614.z) * 1540483477u;
        uint loc_05410 = uint(loc_4e614.w) * 1540483477u;
        uint loc_fd4f6 = ((((((2293326976u ^ ((loc_48d5b ^ (loc_48d5b >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_d322d ^ (loc_d322d >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_33724 ^ (loc_33724 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_05410 ^ (loc_05410 >> uint(24))) * 1540483477u);
        uint loc_2545b = (loc_fd4f6 ^ (loc_fd4f6 >> uint(13))) * 1540483477u;
        uint loc_19f5a = loc_2545b ^ (loc_2545b >> uint(15));
        uint loc_065df = (loc_19f5a ^ (loc_19f5a >> uint(16))) & 65535u;
        uint loc_19109 = loc_065df | uint(loc_065df == 0u);
        int loc_d6224;
        uint loc_bcfea;
        bool loc_87a71;
        int loc_f503c;
        loc_f503c = 0;
        loc_87a71 = false;
        loc_bcfea = loc_19109 & uint(GpuEntryBufferCapacity.x - 1.0);
        loc_d6224 = 0;
        bool loc_4f504;
        uint loc_85325;
        int loc_4035a;
        int loc_cfe5d;
        bool loc_a0c0a;
        for (;;)
        {
            if (loc_d6224 < 8)
            {
                uint loc_23c71 = uint(var_5ae14.zGpuEntryBuffer[loc_bcfea].hash) & 65535u;
                bool loc_734de = loc_23c71 == loc_19109;
                bool loc_166d2;
                if (loc_734de)
                {
                    loc_166d2 = var_5ae14.zGpuEntryBuffer[loc_bcfea].packed_xy == loc_ef361;
                }
                else
                {
                    loc_166d2 = loc_734de;
                }
                bool loc_09802;
                if (loc_166d2)
                {
                    loc_09802 = var_5ae14.zGpuEntryBuffer[loc_bcfea].packed_zw == loc_10f25;
                }
                else
                {
                    loc_09802 = loc_166d2;
                }
                if (loc_87a71)
                {
                    loc_4035a = loc_f503c;
                }
                else
                {
                    int loc_c38b2;
                    if (loc_09802)
                    {
                        loc_c38b2 = var_5ae14.zGpuEntryBuffer[loc_bcfea].user_data;
                    }
                    else
                    {
                        loc_c38b2 = loc_f503c;
                    }
                    loc_4035a = loc_c38b2;
                }
                loc_4f504 = loc_87a71 || loc_09802;
                loc_85325 = (loc_bcfea + 1u) & uint(GpuEntryBufferCapacity.x - 1.0);
                if (loc_4f504 || (loc_23c71 == 0u))
                {
                    loc_a0c0a = loc_4f504;
                    loc_cfe5d = loc_4035a;
                    break;
                }
                loc_f503c = loc_4035a;
                loc_87a71 = loc_4f504;
                loc_bcfea = loc_85325;
                loc_d6224++;
                continue;
            }
            else
            {
                loc_a0c0a = loc_87a71;
                loc_cfe5d = loc_f503c;
                break;
            }
        }
        uint loc_f8e5a = uint(loc_cfe5d >> int(2u));
        vec3 loc_9dfcc;
        if (loc_a0c0a)
        {
            vec3 loc_e9cfe = abs(vec3(0.0, 0.0, 0.100000001490116119384765625));
            vec3 loc_38482;
            if (any(greaterThanEqual(loc_e9cfe, vec3(1.0))))
            {
                vec3 loc_e187d = vec3(0.0, 0.0, 0.100000001490116119384765625);
                vec3 loc_0f5c1 = abs(vec3(0.0, 0.0, 0.100000001490116119384765625));
                float loc_fc63e = dot(loc_10c2e, loc_0f5c1);
                float loc_f7571 = dot(loc_10c2e, loc_0f5c1.zxy);
                float loc_3d321 = dot(loc_10c2e, loc_0f5c1.yzx);
                float loc_316c7;
                if (((loc_e187d.x + loc_e187d.y) + loc_e187d.z) > 0.0)
                {
                    loc_316c7 = ceil(loc_fc63e);
                }
                else
                {
                    loc_316c7 = floor(loc_fc63e);
                }
                float loc_b5544 = floor(loc_f7571);
                float loc_71b3f = floor(loc_3d321);
                vec3 loc_b0b0a = ((loc_0f5c1 * loc_316c7) + (loc_0f5c1.zxy * loc_b5544)) + (loc_0f5c1.yzx * loc_71b3f);
                vec3 loc_a7514 = loc_b0b0a + loc_0f5c1.zxy;
                vec3 loc_efd87 = loc_b0b0a + loc_0f5c1.yzx;
                vec3 loc_85c15 = (loc_b0b0a + loc_0f5c1.zxy) + loc_0f5c1.yzx;
                float loc_559ac = loc_f7571 - loc_b5544;
                float loc_cfe6d = loc_3d321 - loc_71b3f;
                float loc_1bffd = 1.0 - loc_559ac;
                float loc_9eba4 = 1.0 - loc_cfe6d;
                vec4 loc_c8459 = vec4(loc_1bffd * loc_9eba4, loc_559ac * loc_9eba4, loc_1bffd * loc_cfe6d, loc_559ac * loc_cfe6d);
                bool loc_66a92 = all(greaterThanEqual(loc_b0b0a, vec3(0.0)));
                bool loc_3aded;
                if (loc_66a92)
                {
                    loc_3aded = all(lessThan(loc_85c15, vec3(16.0)));
                }
                else
                {
                    loc_3aded = loc_66a92;
                }
                vec3 loc_3790a;
                vec3 loc_e618a;
                vec3 loc_7798e;
                vec3 loc_c026f;
                if (loc_3aded)
                {
                    uvec3 loc_76274 = uvec3(loc_b0b0a);
                    uint loc_ec371 = loc_f8e5a + ((loc_76274.y + (loc_76274.z * 16u)) + (loc_76274.x * 256u));
                    vec3 loc_ccbe3;
                    func_f4166(loc_ec371, loc_ccbe3);
                    uvec3 loc_3e46f = uvec3(loc_a7514);
                    uint loc_b0fec = loc_f8e5a + ((loc_3e46f.y + (loc_3e46f.z * 16u)) + (loc_3e46f.x * 256u));
                    vec3 loc_a7253;
                    func_f4166(loc_b0fec, loc_a7253);
                    uvec3 loc_20318 = uvec3(loc_efd87);
                    uint loc_9884e = loc_f8e5a + ((loc_20318.y + (loc_20318.z * 16u)) + (loc_20318.x * 256u));
                    vec3 loc_8b61c;
                    func_f4166(loc_9884e, loc_8b61c);
                    uvec3 loc_039c5 = uvec3(loc_85c15);
                    uint loc_0ad06 = loc_f8e5a + ((loc_039c5.y + (loc_039c5.z * 16u)) + (loc_039c5.x * 256u));
                    vec3 loc_6ebe7;
                    func_f4166(loc_0ad06, loc_6ebe7);
                    loc_c026f = loc_6ebe7;
                    loc_7798e = loc_8b61c;
                    loc_e618a = loc_a7253;
                    loc_3790a = loc_ccbe3;
                }
                else
                {
                    vec3 loc_a6ee2 = loc_e6082 + loc_b0b0a;
                    vec3 loc_37729;
                    func_97457(loc_a6ee2, loc_e6082, loc_f8e5a, loc_37729);
                    vec3 loc_49861 = loc_e6082 + loc_a7514;
                    vec3 loc_0a440;
                    func_97457(loc_49861, loc_e6082, loc_f8e5a, loc_0a440);
                    vec3 loc_c4461 = loc_e6082 + loc_efd87;
                    vec3 loc_7aa09;
                    func_97457(loc_c4461, loc_e6082, loc_f8e5a, loc_7aa09);
                    vec3 loc_98ea7 = loc_e6082 + loc_85c15;
                    vec3 loc_df625;
                    func_97457(loc_98ea7, loc_e6082, loc_f8e5a, loc_df625);
                    loc_c026f = loc_df625;
                    loc_7798e = loc_7aa09;
                    loc_e618a = loc_0a440;
                    loc_3790a = loc_37729;
                }
                loc_38482 = (((loc_3790a * loc_c8459.x) + (loc_e618a * loc_c8459.y)) + (loc_7798e * loc_c8459.z)) + (loc_c026f * loc_c8459.w);
            }
            else
            {
                vec3 loc_907d7 = floor(loc_10c2e);
                vec3 loc_41313 = loc_10c2e - loc_907d7;
                int loc_838c3 = (int(loc_41313.x >= loc_41313.y) | (int(loc_41313.y >= loc_41313.z) << 1)) | (int(loc_41313.x >= loc_41313.z) << 2);
                uvec3 loc_2256d = uvec3(loc_907d7);
                float loc_c9d33 = min(loc_41313.x, loc_41313.y);
                float loc_4279f = max(loc_41313.x, loc_41313.y);
                float loc_6c645 = min(loc_c9d33, loc_41313.z);
                float loc_9b92e = max(loc_4279f, loc_41313.z);
                float loc_2e4ef = max(min(loc_4279f, loc_41313.z), loc_c9d33);
                bool loc_59db7 = all(greaterThanEqual(loc_907d7, vec3(0.0)));
                bool loc_64535;
                if (loc_59db7)
                {
                    loc_64535 = all(lessThan(loc_907d7 + vec3(1.0), vec3(16.0)));
                }
                else
                {
                    loc_64535 = loc_59db7;
                }
                vec3 loc_f5360;
                vec3 loc_c730e;
                vec3 loc_9ef2b;
                vec3 loc_c705c;
                if (loc_64535)
                {
                    uvec3 loc_e7bc3 = loc_2256d;
                    uint loc_7c5b8 = loc_f8e5a + ((loc_e7bc3.y + (loc_e7bc3.z * 16u)) + (loc_e7bc3.x * 256u));
                    vec3 loc_e2dbc;
                    func_f4166(loc_7c5b8, loc_e2dbc);
                    uvec3 loc_4b2ae = loc_2256d + var_a8473[loc_838c3];
                    uint loc_5a2ce = loc_f8e5a + ((loc_4b2ae.y + (loc_4b2ae.z * 16u)) + (loc_4b2ae.x * 256u));
                    vec3 loc_bcf05;
                    func_f4166(loc_5a2ce, loc_bcf05);
                    uvec3 loc_e087a = loc_2256d + var_a719c[loc_838c3];
                    uint loc_fc69d = loc_f8e5a + ((loc_e087a.y + (loc_e087a.z * 16u)) + (loc_e087a.x * 256u));
                    vec3 loc_253f2;
                    func_f4166(loc_fc69d, loc_253f2);
                    uvec3 loc_f09be = loc_2256d + uvec3(1u);
                    uint loc_9db6e = loc_f8e5a + ((loc_f09be.y + (loc_f09be.z * 16u)) + (loc_f09be.x * 256u));
                    vec3 loc_5d322;
                    func_f4166(loc_9db6e, loc_5d322);
                    loc_c705c = loc_5d322;
                    loc_9ef2b = loc_253f2;
                    loc_c730e = loc_bcf05;
                    loc_f5360 = loc_e2dbc;
                }
                else
                {
                    vec3 loc_97e91 = loc_e6082 + loc_907d7;
                    vec3 loc_05d51;
                    func_97457(loc_97e91, loc_e6082, loc_f8e5a, loc_05d51);
                    vec3 loc_70bfd = loc_e6082 + (loc_907d7 + var_223ba[loc_838c3]);
                    vec3 loc_a5475;
                    func_97457(loc_70bfd, loc_e6082, loc_f8e5a, loc_a5475);
                    vec3 loc_4e4c2 = loc_e6082 + (loc_907d7 + var_0f733[loc_838c3]);
                    vec3 loc_2cf94;
                    func_97457(loc_4e4c2, loc_e6082, loc_f8e5a, loc_2cf94);
                    vec3 loc_fa2e7 = loc_e6082 + (loc_907d7 + vec3(1.0));
                    vec3 loc_dabf1;
                    func_97457(loc_fa2e7, loc_e6082, loc_f8e5a, loc_dabf1);
                    loc_c705c = loc_dabf1;
                    loc_9ef2b = loc_2cf94;
                    loc_c730e = loc_a5475;
                    loc_f5360 = loc_05d51;
                }
                loc_38482 = (((loc_f5360 * (1.0 - loc_9b92e)) + (loc_c730e * (loc_9b92e - loc_2e4ef))) + (loc_9ef2b * (loc_2e4ef - loc_6c645))) + (loc_c705c * loc_6c645);
            }
            loc_9dfcc = loc_38482;
        }
        else
        {
            loc_9dfcc = vec3(0.0);
        }
        loc_f8a58 = (loc_9dfcc * BlockBaseAmbientLightColorIntensity.xyz) * BlockBaseAmbientLightColorIntensity.w;
    }
    else
    {
        loc_f8a58 = (BlockBaseAmbientLightColorIntensity.xyz * loc_ea783.x) * BlockBaseAmbientLightColorIntensity.w;
    }
    vec3 loc_1f4b9 = ((loc_450d3 * 0.079577468335628509521484375) * max(loc_f8a58 + ((SkyAmbientLightColorIntensity.xyz * loc_ea783.y) * SkyAmbientLightColorIntensity.w), vec3(MinAmbientValue.x))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    vec3 loc_09caf = -(loc_49313 / vec3(loc_1595d));
    bool loc_5b439 = !(DirectionalLightSkyLightHeuristicToggles.y != 0.0);
    bool loc_7e26a;
    if (!loc_5b439)
    {
        loc_7e26a = abs(loc_ea783.y) > 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_7e26a = loc_5b439;
    }
    vec3 loc_1bbb0;
    if (loc_7e26a)
    {
        float loc_af838;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            int loc_c0de4 = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
            float loc_f6ac1;
            loc_f6ac1 = 1.0;
            int loc_29996;
            float loc_484ee;
            for (int loc_8a709 = 0, loc_0e4f2 = 0; loc_8a709 < loc_c0de4; loc_0e4f2 = loc_29996, loc_f6ac1 = loc_484ee, loc_8a709++)
            {
                int loc_79423 = min((loc_0e4f2 + int(CascadesPerSet[loc_8a709])), 8);
                loc_484ee = loc_f6ac1;
                loc_29996 = loc_0e4f2;
                int loc_a0458;
                float loc_5399e;
                for (; loc_29996 < loc_79423; loc_484ee = loc_5399e, loc_29996 = loc_a0458)
                {
                    vec4 loc_4a0d9 = CascadesShadowProj[loc_29996] * vec4(loc_4f76f, 1.0);
                    vec3 loc_8d38c = abs(loc_4a0d9.xyz);
                    bool loc_45980 = loc_8d38c.x <= 1.0;
                    bool loc_f1421;
                    if (loc_45980)
                    {
                        loc_f1421 = loc_8d38c.y <= 1.0;
                    }
                    else
                    {
                        loc_f1421 = loc_45980;
                    }
                    bool loc_e36b7;
                    if (loc_f1421)
                    {
                        loc_e36b7 = loc_8d38c.z <= 1.0;
                    }
                    else
                    {
                        loc_e36b7 = loc_f1421;
                    }
                    if (loc_e36b7)
                    {
                        vec4 loc_38cc9 = loc_4a0d9;
                        int loc_3a40c;
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_3a40c = 1;
                        }
                        else
                        {
                            loc_3a40c = clamp(int((CascadesParameters[loc_29996].w * VolumeShadowSettings.x) + 0.5), 1, 9);
                        }
                        int loc_960ef = loc_3a40c / 2;
                        vec2 loc_dc4ac = ((loc_4a0d9.xy * 0.5) + vec2(0.5)) * CascadesParameters[loc_29996].x;
                        float loc_4fba3 = (loc_38cc9.z * 0.5) + 0.5;
                        loc_dc4ac.y += (1.0 - CascadesParameters[loc_29996].x);
                        float loc_3555e;
                        loc_3555e = 0.0;
                        float loc_801c0;
                        for (int loc_15249 = 0; loc_15249 < loc_3a40c; loc_3555e = loc_801c0, loc_15249++)
                        {
                            loc_801c0 = loc_3555e;
                            float loc_30840;
                            for (int loc_963d2 = 0; loc_963d2 < loc_3a40c; loc_801c0 = loc_30840, loc_963d2++)
                            {
                                vec2 loc_cced5 = loc_dc4ac + ((vec2(float(loc_963d2 - loc_960ef) + 0.5, float(loc_15249 - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_29996].x);
                                vec4 loc_fe3f0 = textureGather(s_ShadowCascades, vec3(loc_cced5, float(loc_29996)));
                                vec4 loc_26b65 = loc_fe3f0;
                                if (QuantizationParameters.x != 0.0)
                                {
                                    loc_30840 = loc_801c0 + float(loc_26b65.w >= (loc_4fba3 - CascadesParameters[loc_29996].y));
                                }
                                else
                                {
                                    vec4 loc_2f6b4 = step(vec4(loc_4fba3 - CascadesParameters[loc_29996].y), loc_fe3f0);
                                    vec2 loc_e2aba = fract((loc_cced5 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                    loc_30840 = loc_801c0 + mix(mix(loc_2f6b4.w, loc_2f6b4.z, loc_e2aba.x), mix(loc_2f6b4.x, loc_2f6b4.y, loc_e2aba.x), loc_e2aba.y);
                                }
                            }
                        }
                        loc_5399e = min(loc_484ee, loc_3555e / float(loc_3a40c * loc_3a40c));
                        loc_a0458 = loc_79423;
                    }
                    else
                    {
                        loc_5399e = loc_484ee;
                        loc_a0458 = loc_29996 + 1;
                    }
                }
            }
            float loc_f828f;
            if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
            {
                float loc_ad066;
                func_a0b5c(loc_4f76f, loc_ad066);
                loc_f828f = loc_ad066;
            }
            else
            {
                loc_f828f = 1.0;
            }
            bool loc_8174b = int(CloudShadowsVisible.x) > 0;
            bool loc_b7807;
            if (loc_8174b)
            {
                loc_b7807 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
            }
            else
            {
                loc_b7807 = loc_8174b;
            }
            float loc_4a190;
            if (loc_b7807)
            {
                vec4 loc_bcd0f = CloudShadowProj * vec4(loc_4f76f, 1.0);
                vec4 loc_bcbd7 = loc_bcd0f;
                loc_bcbd7 = loc_bcd0f / vec4(loc_bcbd7.w);
                loc_bcbd7.z -= (CascadesParameters[0].y / loc_bcbd7.w);
                int loc_c86ff;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_c86ff = 1;
                }
                else
                {
                    loc_c86ff = clamp(int((EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * VolumeShadowSettings.x) + 0.5), 1, 9);
                }
                int loc_7508d = loc_c86ff / 2;
                vec2 loc_37738 = ((loc_bcbd7.xy * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
                loc_37738.y += (1.0 - CascadesParameters[0].x);
                loc_bcbd7.z = (loc_bcbd7.z * 0.5) + 0.5;
                float loc_19cd0 = dot(CascadesPerSet, vec4(1.0));
                float loc_543e1;
                loc_543e1 = 0.0;
                float loc_0fce1;
                for (int loc_093cd = 0; loc_093cd < loc_c86ff; loc_543e1 = loc_0fce1, loc_093cd++)
                {
                    loc_0fce1 = loc_543e1;
                    float loc_16f2e;
                    for (int loc_fdb90 = 0; loc_fdb90 < loc_c86ff; loc_0fce1 = loc_16f2e, loc_fdb90++)
                    {
                        vec3 loc_d07c9 = vec3(loc_37738 + ((vec2(float(loc_fdb90 - loc_7508d) + 0.5, float(loc_093cd - loc_7508d) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_19cd0);
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_16f2e = loc_0fce1 + float(textureLod(s_ShadowCascades, loc_d07c9, 0.0).x >= loc_bcbd7.z);
                        }
                        else
                        {
                            vec4 loc_2ae6b = step(vec4(loc_bcbd7.z), textureGather(s_ShadowCascades, loc_d07c9));
                            vec2 loc_52300 = fract((loc_d07c9.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            loc_16f2e = loc_0fce1 + mix(mix(loc_2ae6b.w, loc_2ae6b.z, loc_52300.x), mix(loc_2ae6b.x, loc_2ae6b.y, loc_52300.x), loc_52300.y);
                        }
                    }
                }
                float loc_8a60e = loc_543e1 / float(loc_c86ff * loc_c86ff);
                float loc_26602;
                if (loc_8a60e < 1.0)
                {
                    loc_26602 = min(1.0, max(loc_8a60e, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                }
                else
                {
                    loc_26602 = 1.0;
                }
                loc_4a190 = loc_26602;
            }
            else
            {
                loc_4a190 = 1.0;
            }
            loc_af838 = mix(min(loc_f6ac1, min(loc_f828f, loc_4a190)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -0.0));
        }
        else
        {
            loc_af838 = 1.0;
        }
        float loc_768e3 = (1.0 + (loc_3fa4b * loc_3fa4b)) + ((2.0 * loc_3fa4b) * dot(loc_09caf, normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_4de69 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_1bbb0 = loc_1f4b9 + (((loc_450d3 * loc_af838) * ((0.079577468335628509521484375 * (1.0 - (loc_3fa4b * loc_3fa4b))) / (loc_768e3 * sqrt(loc_768e3)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_4de69.w));
    }
    else
    {
        loc_1bbb0 = loc_1f4b9;
    }
    bool loc_15286 = VolumeScatteringEnabledAndPointLightVolumetricsEnabled.y != 0.0;
    bool loc_936b4;
    if (loc_15286)
    {
        loc_936b4 = DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0;
    }
    else
    {
        loc_936b4 = loc_15286;
    }
    vec3 loc_0bece;
    if (loc_936b4)
    {
        vec3 loc_92891;
        func_0582d(loc_49313, loc_92891, loc_4f76f, loc_3fa4b, loc_09caf, loc_450d3);
        loc_0bece = loc_1bbb0 + loc_92891;
    }
    else
    {
        loc_0bece = loc_1bbb0;
    }
    if (TemporalSettings.x > 0.0)
    {
        vec3 loc_dfafd = (vec3(float(loc_da723), float(loc_1c644), float(loc_beae9)) + vec3(0.5)) / VolumeDimensions.xyz;
        vec3 loc_e9300 = loc_dfafd;
        vec2 loc_9d396 = VolumeNearFar.xy;
        float loc_fcd55 = (exp(4.0 * loc_e9300.z) - 1.0) * 0.0186573602259159088134765625;
        vec4 loc_62495 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcd55) * loc_9d396.x) + (loc_fcd55 * loc_9d396.y)), 1.0);
        vec4 loc_d7f13 = u_invViewProj * vec4((loc_dfafd.xy * 2.0) - vec2(1.0), loc_62495.z / loc_62495.w, 1.0);
        vec4 loc_d1c9b = loc_d7f13;
        vec4 loc_bf151 = u_prevViewProj * vec4((loc_d7f13.xyz / vec3(loc_d1c9b.w)) - u_prevWorldPosOffset.xyz, 1.0);
        vec4 loc_d9ce7 = loc_bf151;
        vec3 loc_ec028 = loc_bf151.xyz / vec3(loc_d9ce7.w);
        vec2 loc_1fa2a = VolumeNearFar.xy;
        vec2 loc_81f33 = (loc_ec028.xy + vec2(1.0)) * 0.5;
        vec4 loc_3fd1f = PrevInvProj * vec4(loc_ec028, 1.0);
        float loc_d255f = loc_81f33.x;
        vec3 loc_33e20 = vec3(loc_d255f, loc_81f33.y, log((53.598148345947265625 * ((((-loc_3fd1f.z) / loc_3fd1f.w) - loc_1fa2a.x) / (loc_1fa2a.y - loc_1fa2a.x))) + 1.0) * 0.25);
        ivec3 loc_dbdb4 = ivec3(VolumeDimensions.xyz);
        ivec3 loc_57985 = loc_dbdb4;
        vec3 loc_96ba4 = loc_33e20;
        float loc_53f43 = (loc_96ba4.z * float(loc_57985.z)) - 0.5;
        int loc_25a80 = clamp(int(loc_53f43), 0, loc_57985.z - 2);
        vec3 loc_34735 = VolumeDimensions.xyz * loc_33e20;
        imageStore(s_CurrentLightingBuffer, ivec3(loc_da723, loc_1c644, loc_beae9), mix(vec4(loc_0bece, loc_8068a), mix(textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80)), 0.0), textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80 + 1)), 0.0), vec4(clamp(loc_53f43 - float(loc_25a80), 0.0, 1.0))), vec4(mix(TemporalSettings.z, 0.0, clamp(length(clamp(loc_34735, vec3(0.0), vec3(loc_dbdb4)) - loc_34735) * TemporalSettings.y, 0.0, 1.0)))));
    }
    else
    {
        imageStore(s_CurrentLightingBuffer, ivec3(loc_da723, loc_1c644, loc_beae9), vec4(loc_0bece, loc_8068a));
    }
}
#endif
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    func_327ea();
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
    func_01cd3();
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    func_d4e78();
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
    func_584fc();
#endif
}
