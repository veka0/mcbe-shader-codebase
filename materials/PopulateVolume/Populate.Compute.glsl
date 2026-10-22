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
* - uniform lowp sampler2DArray s_CascadedShadowBuffer;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 11, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2DArray s_ScatteringBufferOut;
* - uniform lowp sampler2D s_ScreenSpaceWaterBackFaceDepthAndNormal;
* - uniform lowp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 12, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
* - layout(binding = 13, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 14, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 15, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
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
* - uniform vec4 PointLightPreCalcValuesAndAmbientScalar;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowAtlasResolution;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PreExposureEnabled;
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

#ifdef THREAD_LIMIT__LIMITED_AT128
layout(local_size_x = 8, local_size_y = 8, local_size_z = 2) in;
#endif
#ifdef THREAD_LIMIT__LIMITED_AT256
layout(local_size_x = 8, local_size_y = 8, local_size_z = 4) in;
#endif
#ifdef THREAD_LIMIT__NATIVE
layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;
#endif
struct BiomeInfo {
    vec4 waterExtinctionCoefficients;
    vec4 waterAlbedoExtinction;
    vec4 waterSurfaceParameters;
    vec4 waterSurfaceWaveParameters;
    vec4 waterSurfaceOctaveParameters;
};

#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
struct Light {
    vec4 position;
    vec4 color;
    vec4 shadowFaceUV0;
    vec4 shadowFaceUV1;
    vec4 shadowFaceUV2;
    vec4 shadowFaceUV3;
    vec4 shadowFaceUV4;
    vec4 shadowFaceUV5;
};
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
const int var_30d2d[64] = int[](-1, 2, 3, -1, 0, 6, 7, -1, 1, 10, 11, -1, -1, -1, -1, -1, 4, 14, 16, -1, 8, 18, 20, -1, 12, 22, 24, -1, -1, -1, -1, -1, 5, 15, 17, -1, 9, 19, 21, -1, 13, 23, 25, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
struct VoxelNode {
    uint data;
};
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) || defined(POINT_LIGHT_SHADING__ON)

#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
struct LightData {
    float lookup;
};
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
const uint var_a6f79[3] = uint[](4u, 2u, 1u);
const uint var_083eb[3] = uint[](240u, 204u, 170u);
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
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
    vec4 position;
    vec4 color;
    vec4 shadowFaceUV0;
    vec4 shadowFaceUV1;
    vec4 shadowFaceUV2;
    vec4 shadowFaceUV3;
    vec4 shadowFaceUV4;
    vec4 shadowFaceUV5;
};

struct LightData {
    float lookup;
};

#endif
#ifdef POINT_LIGHT_SHADING__ON
int var_e7b23;
#endif
layout(binding = 13, std430) buffer s_zBiomeInfoBuffer { BiomeInfo zBiomeInfoBuffer[]; } var_4886d;
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
layout(binding = 15, std430) buffer s_zLights { Light zLights[]; } var_eaf9f;
layout(binding = 14, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_d4998;
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
layout(binding = 12, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_f2df9;
layout(binding = 11, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_ceedc;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
layout(binding = 15, std430) buffer s_zLights { Light zLights[]; } var_eaf9f;
layout(binding = 14, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_d4998;
#endif
layout(location = 0, binding = 7, r32f) uniform readonly highp image2DArray s_CascadedShadowBuffer;
layout(location = 1, binding = 8, rgba16f) uniform writeonly highp image2DArray s_ScatteringBufferOut;
uniform highp sampler2D s_BiomeBlendingMap;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp sampler2D s_PointLightShadowTextureAtlas;
#endif
uniform highp sampler2D s_ScreenSpaceWaterBackFaceDepthAndNormal;
uniform highp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
uniform highp sampler3D s_SkyAmbientSamples;
#ifdef POINT_LIGHT_SHADING__ON
uniform mat4 PointLightProj;
#endif
uniform mat4 u_invViewProj;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 AirAlbedoExtinction;
uniform vec4 AtmosphericScatteringToggles;
uniform vec4 BiomeBlendingLastUpdatePosition;
uniform vec4 BiomeBlendingParameters;
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform vec4 CameraAmbientContribution;
uniform vec4 CameraUnderwaterAndWaterSurfaceBiasAndFalloff;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 ClusterDepthBounds;
uniform vec4 ClusterDimensions;
#endif
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 DirectionalLightSkyLightHeuristicToggles;
uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform vec4 DirectionalLightSourceWorldSpaceDirection;
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
#endif
#ifdef GPU_BLOCK_LIGHTING__ON
uniform vec4 DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
#endif
uniform vec4 FogAndDistanceControl;
#ifdef GPU_BLOCK_LIGHTING__ON
uniform vec4 GpuEntryBufferCapacity;
#endif
uniform vec4 HeightFogScaleBias;
uniform vec4 HenyeyGreensteinG;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 ManhattanDistAttenuationEnabled;
#endif
uniform vec4 MinAmbientValue;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 PointLightAttenuationWindow;
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 PointLightPreCalcValuesAndAmbientScalar;
uniform vec4 PointLightShadowAtlasResolution;
#endif
uniform vec4 RenderChunkFogAlpha;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SkySamplesConfig;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
#endif
uniform vec4 WaterAlbedoExtinction;
#ifdef GPU_BLOCK_LIGHTING__ON
uniform vec4 WorldOrigin;
#endif
void func_8ab59(inout bool arg_5e3ed) {
    if (BiomeBlendingParameters.x > 0.0)
    {
        arg_5e3ed = true;
        return;
    }
    arg_5e3ed = false;
}
void func_97ae5(inout vec3 arg_99162, inout vec4 arg_029c1) {
    int loc_738fb = int(BiomeBlendingParameters.z * 0.5);
    float loc_9e9be = (arg_99162.x - BiomeBlendingLastUpdatePosition.x) / BiomeBlendingLastUpdatePosition.w;
    float loc_3eb23 = (arg_99162.z - BiomeBlendingLastUpdatePosition.z) / BiomeBlendingLastUpdatePosition.w;
    ivec2 loc_f487d = ivec2(loc_738fb + int(floor(loc_9e9be)), loc_738fb + int(floor(loc_3eb23)));
    loc_f487d.x = clamp(loc_f487d.x, 0, int(BiomeBlendingParameters.z) - 1);
    loc_f487d.y = clamp(loc_f487d.y, 0, int(BiomeBlendingParameters.z) - 1);
    int loc_d3165 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d, 0).x * 255.0));
    int loc_0fad2 = (loc_d3165 >= int(BiomeBlendingParameters.w)) ? 0 : loc_d3165;
    int loc_f9483 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(1, 0), 0).x * 255.0));
    int loc_ca927 = (loc_f9483 >= int(BiomeBlendingParameters.w)) ? 0 : loc_f9483;
    int loc_41712 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(0, 1), 0).x * 255.0));
    int loc_850b3 = (loc_41712 >= int(BiomeBlendingParameters.w)) ? 0 : loc_41712;
    int loc_0e979 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(1), 0).x * 255.0));
    int loc_56228 = (loc_0e979 >= int(BiomeBlendingParameters.w)) ? 0 : loc_0e979;
    if (((loc_0fad2 == loc_ca927) && (loc_ca927 == loc_850b3)) && (loc_850b3 == loc_56228))
    {
        arg_029c1 = var_4886d.zBiomeInfoBuffer[loc_0fad2].waterAlbedoExtinction;
        return;
    }
    float loc_0d854 = fract(loc_9e9be);
    float loc_00e44 = fract(loc_3eb23);
    vec4 loc_14145 = vec4((1.0 - loc_0d854) * (1.0 - loc_00e44), loc_0d854 * (1.0 - loc_00e44), (1.0 - loc_0d854) * loc_00e44, loc_0d854 * loc_00e44);
    arg_029c1 = (((var_4886d.zBiomeInfoBuffer[loc_0fad2].waterAlbedoExtinction * loc_14145.x) + (var_4886d.zBiomeInfoBuffer[loc_ca927].waterAlbedoExtinction * loc_14145.y)) + (var_4886d.zBiomeInfoBuffer[loc_850b3].waterAlbedoExtinction * loc_14145.z)) + (var_4886d.zBiomeInfoBuffer[loc_56228].waterAlbedoExtinction * loc_14145.w);
}
void func_b5ebb(inout vec3 arg_9de81, inout vec4 arg_dde0d) {
    bool loc_a9f27;
    func_8ab59(loc_a9f27);
    if (loc_a9f27)
    {
        vec3 loc_a1b82 = arg_9de81;
        vec4 loc_29eab;
        func_97ae5(loc_a1b82, loc_29eab);
        arg_dde0d = loc_29eab;
        return;
    }
    arg_dde0d = WaterAlbedoExtinction;
}
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
void func_e9e34() {
    int loc_79ceb = int(gl_GlobalInvocationID.x);
    int loc_53256 = int(gl_GlobalInvocationID.y);
    int loc_9abbf = int(gl_GlobalInvocationID.z);
    if (((loc_79ceb >= int(VolumeDimensions.x)) || (loc_53256 >= int(VolumeDimensions.y))) || (loc_9abbf >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_a69bc = (vec3(float(loc_79ceb), float(loc_53256), float(loc_9abbf)) + vec3(0.5)) / VolumeDimensions.xyz;
    vec3 loc_b4177 = loc_a69bc;
    vec3 loc_777c2 = loc_a69bc;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_a69bc.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_f0c5d = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_f0c5d;
    vec3 loc_16a16 = (u_view * vec4(loc_f0c5d, 1.0)).xyz;
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
    float loc_62499;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_62499 = 1.0 - loc_8fa9c;
    }
    else
    {
        loc_62499 = loc_8fa9c;
    }
    vec4 loc_4397b;
    func_b5ebb(loc_f0c5d, loc_4397b);
    vec4 loc_a5348 = loc_4397b;
    float loc_2c406 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_fbcc6 = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_62499);
    float loc_9fe9d = length(loc_16a16);
    float loc_8ddfa = clamp((((loc_9fe9d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_6fb9b = mix(mix((AirAlbedoExtinction.xyz * loc_2c406) * AirAlbedoExtinction.w, loc_4397b.xyz * loc_a5348.w, vec3(loc_62499)), vec3(0.0), vec3(loc_8ddfa));
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
        vec3 loc_08c5f = loc_a69bc;
        loc_08c5f.y = 1.0 - loc_08c5f.y;
        if (SkySamplesConfig.y > 0.5)
        {
            loc_08c5f.z -= SkySamplesConfig.z;
        }
        loc_08c5f.z = (exp(4.0 * loc_08c5f.z) - 1.0) * 0.0186573602259159088134765625;
        loc_3cb89 = textureLod(s_SkyAmbientSamples, loc_08c5f, 0.0).xy;
    }
    vec3 loc_98d5d = ((loc_6fb9b * 0.079577468335628509521484375) * max(((BlockBaseAmbientLightColorIntensity.xyz * loc_3cb89.x) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * loc_3cb89.y) * SkyAmbientLightColorIntensity.w), vec3(MinAmbientValue.x))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
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
    vec3 loc_4c028;
    if (loc_7e26a)
    {
        float loc_93a3c = (1.0 + (loc_fbcc6 * loc_fbcc6)) + ((2.0 * loc_fbcc6) * dot(-(loc_16a16 / vec3(loc_9fe9d)), normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_f95d1 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_4c028 = loc_98d5d + (((loc_6fb9b * imageLoad(s_CascadedShadowBuffer, ivec3(loc_79ceb, loc_53256, loc_9abbf)).x) * ((0.079577468335628509521484375 * (1.0 - (loc_fbcc6 * loc_fbcc6))) / (loc_93a3c * sqrt(loc_93a3c)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_f95d1.w));
    }
    else
    {
        loc_4c028 = loc_98d5d;
    }
    imageStore(s_ScatteringBufferOut, ivec3(loc_79ceb, loc_53256, loc_9abbf), vec4(loc_4c028, mix(mix(loc_2c406 * AirAlbedoExtinction.w, loc_a5348.w, loc_62499), 0.0, loc_8ddfa)));
}
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
void func_d24d6(inout vec3 arg_8311e, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    vec3 loc_70de6 = arg_8311e;
    vec3 loc_3195e = ClusterDimensions.xyz;
    vec2 loc_90806 = ClusterDepthBounds.xy;
    vec4 loc_2773a = PointLightPreCalcValuesAndAmbientScalar;
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
            loc_b1845 = min(floor(clamp((log2(loc_1ee6d) - loc_2773a.z) * loc_2773a.x, 0.0, 1.0) * (loc_3195e.z - 2.0)) + 2.0, loc_3195e.z - 1.0);
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
void func_2a474(inout int arg_55dd7, inout float arg_9499a, inout vec3 arg_226c4) {
    if (arg_55dd7 < 0)
    {
        arg_9499a = 0.0;
        return;
    }
    vec3 loc_742e7 = arg_226c4 - var_eaf9f.zLights[arg_55dd7].position.xyz;
    vec3 loc_7cf5a = loc_742e7;
    vec3 loc_ae7bb = abs(loc_742e7);
    bool loc_ab77c = loc_ae7bb.x >= loc_ae7bb.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_ae7bb.x >= loc_ae7bb.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    int loc_f3fad;
    if (loc_ca7f9)
    {
        loc_f3fad = (loc_7cf5a.x >= 0.0) ? 0 : 1;
    }
    else
    {
        int loc_1358b;
        if (loc_ae7bb.y >= loc_ae7bb.z)
        {
            loc_1358b = (loc_7cf5a.y >= 0.0) ? 2 : 3;
        }
        else
        {
            loc_1358b = (loc_7cf5a.z >= 0.0) ? 4 : 5;
        }
        loc_f3fad = loc_1358b;
    }
    vec4 loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV0;
    vec3 loc_e85ed;
    if (loc_f3fad == 1)
    {
        loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV1;
        loc_e85ed = vec3(-loc_7cf5a.z, loc_7cf5a.y, loc_7cf5a.x);
    }
    else
    {
        vec3 loc_9e4d3;
        if (loc_f3fad == 2)
        {
            loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV2;
            loc_9e4d3 = vec3(-loc_7cf5a.x, -loc_7cf5a.z, -loc_7cf5a.y);
        }
        else
        {
            vec3 loc_69cfa;
            if (loc_f3fad == 3)
            {
                loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV3;
                loc_69cfa = vec3(-loc_7cf5a.x, loc_7cf5a.z, loc_7cf5a.y);
            }
            else
            {
                vec3 loc_c6606;
                if (loc_f3fad == 4)
                {
                    loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV4;
                    loc_c6606 = vec3(-loc_7cf5a.x, loc_7cf5a.y, -loc_7cf5a.z);
                }
                else
                {
                    vec3 loc_f4215;
                    if (loc_f3fad == 5)
                    {
                        loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV5;
                        loc_f4215 = vec3(loc_7cf5a.x, loc_7cf5a.y, loc_7cf5a.z);
                    }
                    else
                    {
                        loc_f4215 = vec3(loc_7cf5a.z, loc_7cf5a.y, -loc_7cf5a.x);
                    }
                    loc_c6606 = loc_f4215;
                }
                loc_69cfa = loc_c6606;
            }
            loc_9e4d3 = loc_69cfa;
        }
        loc_e85ed = loc_9e4d3;
    }
    bool loc_da9b7 = loc_d3136.z == 0.0;
    bool loc_20dc6;
    if (loc_da9b7)
    {
        loc_20dc6 = loc_d3136.w == 0.0;
    }
    else
    {
        loc_20dc6 = loc_da9b7;
    }
    if (loc_20dc6)
    {
        arg_9499a = 0.0;
        return;
    }
    vec4 loc_c2d15 = PointLightProj * vec4(loc_e85ed, 1.0);
    float loc_b2ff8 = loc_c2d15.w;
    vec4 loc_9c4e8 = loc_c2d15;
    vec4 loc_cb30a = loc_9c4e8 / vec4(loc_b2ff8);
    loc_c2d15 = loc_cb30a;
    vec2 loc_ac5d5 = vec2(0.5) / PointLightShadowAtlasResolution.xy;
    vec2 loc_f65fa = loc_d3136.zw - loc_d3136.xy;
    vec2 loc_1f655 = loc_f65fa * PointLightShadowAtlasResolution.xy;
    float loc_41e57;
    if (((textureLod(s_PointLightShadowTextureAtlas, clamp(loc_d3136.xy + (((floor(((loc_cb30a.xy * 0.5) + vec2(0.5)) * loc_1f655) + vec2(0.5)) / loc_1f655) * loc_f65fa), loc_d3136.xy + loc_ac5d5, loc_d3136.zw - loc_ac5d5), 0.0).x * 2.0) - 1.0) >= loc_c2d15.z)
    {
        loc_41e57 = 1.0;
    }
    else
    {
        loc_41e57 = 0.0;
    }
    arg_9499a = loc_41e57;
}
void func_3bf09(inout int arg_ff970, inout float arg_43b7a, inout vec3 arg_0a2b9, inout vec3 arg_39715) {
    if (arg_ff970 < 0)
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    vec3 loc_55323 = var_eaf9f.zLights[arg_ff970].position.xyz - arg_39715;
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
    if (loc_63f32 >= (var_eaf9f.zLights[arg_ff970].position.w * var_eaf9f.zLights[arg_ff970].position.w))
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    float loc_b326d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0)
    {
        float loc_334de;
        func_2a474(arg_ff970, loc_334de, arg_39715);
        loc_b326d = loc_334de;
    }
    else
    {
        loc_b326d = 1.0;
    }
    float loc_728c0 = loc_63f32 / ((var_eaf9f.zLights[arg_ff970].position.w * var_eaf9f.zLights[arg_ff970].position.w) + 9.9999997473787516355514526367188e-05);
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
    arg_0a2b9 = (var_eaf9f.zLights[arg_ff970].color.xyz * var_eaf9f.zLights[arg_ff970].color.w) * loc_5501b;
}
void func_0582d(inout vec3 arg_5cc04, inout vec3 arg_534d1, inout vec3 arg_81f82, inout float arg_1eba3, inout vec3 arg_1cde6, inout vec3 arg_e7cf5) {
    bool loc_a0bb1;
    int loc_79315;
    int loc_822f5;
    func_d24d6(arg_5cc04, loc_822f5, loc_79315, loc_a0bb1);
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
        int loc_99f11 = int(var_d4998.zLightLookupArray[loc_97a60].lookup);
        if (loc_99f11 < 0)
        {
            break;
        }
        vec3 loc_102a3;
        float loc_b0161;
        func_3bf09(loc_99f11, loc_b0161, loc_102a3, arg_81f82);
        float loc_57b1f = (1.0 + (arg_1eba3 * arg_1eba3)) + ((2.0 * arg_1eba3) * dot(arg_1cde6, normalize((u_view * vec4(var_eaf9f.zLights[loc_99f11].position.xyz, 1.0)).xyz - arg_5cc04)));
        loc_3e87e = loc_ceaba + (((arg_e7cf5 * ((0.079577468335628509521484375 * (1.0 - (arg_1eba3 * arg_1eba3))) / (loc_57b1f * sqrt(loc_57b1f)))) * loc_b0161) * loc_102a3);
    }
    arg_534d1 = loc_ceaba;
}
void func_76218() {
    int loc_79ceb = int(gl_GlobalInvocationID.x);
    int loc_53256 = int(gl_GlobalInvocationID.y);
    int loc_9abbf = int(gl_GlobalInvocationID.z);
    if (((loc_79ceb >= int(VolumeDimensions.x)) || (loc_53256 >= int(VolumeDimensions.y))) || (loc_9abbf >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_a69bc = (vec3(float(loc_79ceb), float(loc_53256), float(loc_9abbf)) + vec3(0.5)) / VolumeDimensions.xyz;
    vec3 loc_b4177 = loc_a69bc;
    vec3 loc_777c2 = loc_a69bc;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_a69bc.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_9f71f = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_9f71f;
    vec3 loc_49313 = (u_view * vec4(loc_9f71f, 1.0)).xyz;
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
    float loc_62499;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_62499 = 1.0 - loc_8fa9c;
    }
    else
    {
        loc_62499 = loc_8fa9c;
    }
    vec4 loc_4397b;
    func_b5ebb(loc_9f71f, loc_4397b);
    vec4 loc_a5348 = loc_4397b;
    float loc_2c406 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_1f492 = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_62499);
    float loc_1595d = length(loc_49313);
    float loc_8ddfa = clamp((((loc_1595d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_cdac6 = mix(mix((AirAlbedoExtinction.xyz * loc_2c406) * AirAlbedoExtinction.w, loc_4397b.xyz * loc_a5348.w, vec3(loc_62499)), vec3(0.0), vec3(loc_8ddfa));
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
        vec3 loc_08c5f = loc_a69bc;
        loc_08c5f.y = 1.0 - loc_08c5f.y;
        if (SkySamplesConfig.y > 0.5)
        {
            loc_08c5f.z -= SkySamplesConfig.z;
        }
        loc_08c5f.z = (exp(4.0 * loc_08c5f.z) - 1.0) * 0.0186573602259159088134765625;
        loc_3cb89 = textureLod(s_SkyAmbientSamples, loc_08c5f, 0.0).xy;
    }
    vec3 loc_98d5d = ((loc_cdac6 * 0.079577468335628509521484375) * max(((BlockBaseAmbientLightColorIntensity.xyz * loc_3cb89.x) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * loc_3cb89.y) * SkyAmbientLightColorIntensity.w), vec3(MinAmbientValue.x))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
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
    vec3 loc_10973;
    if (loc_7e26a)
    {
        float loc_095bd = (1.0 + (loc_1f492 * loc_1f492)) + ((2.0 * loc_1f492) * dot(loc_09caf, normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_f95d1 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_10973 = loc_98d5d + (((loc_cdac6 * imageLoad(s_CascadedShadowBuffer, ivec3(loc_79ceb, loc_53256, loc_9abbf)).x) * ((0.079577468335628509521484375 * (1.0 - (loc_1f492 * loc_1f492))) / (loc_095bd * sqrt(loc_095bd)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_f95d1.w));
    }
    else
    {
        loc_10973 = loc_98d5d;
    }
    bool loc_15286 = VolumeScatteringEnabledAndPointLightVolumetricsEnabled.y != 0.0;
    bool loc_1a69f;
    if (loc_15286)
    {
        loc_1a69f = DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0;
    }
    else
    {
        loc_1a69f = loc_15286;
    }
    vec3 loc_c7184;
    if (loc_1a69f)
    {
        vec3 loc_e1cc9;
        func_0582d(loc_49313, loc_e1cc9, loc_9f71f, loc_1f492, loc_09caf, loc_cdac6);
        loc_c7184 = loc_10973 + (loc_e1cc9 * (1.0 - PointLightPreCalcValuesAndAmbientScalar.w));
    }
    else
    {
        loc_c7184 = loc_10973;
    }
    imageStore(s_ScatteringBufferOut, ivec3(loc_79ceb, loc_53256, loc_9abbf), vec4(loc_c7184, mix(mix(loc_2c406 * AirAlbedoExtinction.w, loc_a5348.w, loc_62499), 0.0, loc_8ddfa)));
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
        uint loc_a385f = (var_f2df9.VoxelBuffer[loc_a0cb4].data >> loc_b118b) & 3u;
        uint loc_95bf0 = ((var_f2df9.VoxelBuffer[loc_a0cb4].data >> 16u) >> loc_b118b) & 3u;
        uint loc_6dacb = (var_f2df9.VoxelBuffer[loc_50d99].data >> loc_b118b) & 3u;
        uint loc_f9969 = ((var_f2df9.VoxelBuffer[loc_50d99].data >> 16u) >> loc_b118b) & 3u;
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
        uint loc_a4225 = var_f2df9.VoxelBuffer[loc_9766b + loc_f2544].data >> loc_2dbd6;
        uint loc_63c72;
        if (loc_2dbd6 > 12u)
        {
            loc_63c72 = loc_a4225 | (var_f2df9.VoxelBuffer[(loc_9766b + loc_f2544) + 1u].data << (32u - loc_2dbd6));
        }
        else
        {
            loc_63c72 = loc_a4225;
        }
        uint loc_680e3 = (loc_63c72 & 3u) | ((loc_63c72 >> 16u) & 12u);
        uint loc_9a4d6 = (((var_f2df9.VoxelBuffer[loc_a0cb4].data & 1u) | (((var_f2df9.VoxelBuffer[loc_a0cb4].data >> 16u) & 1u) << 1u)) | ((var_f2df9.VoxelBuffer[loc_50d99].data & 1u) << 2u)) | (((var_f2df9.VoxelBuffer[loc_50d99].data >> 16u) & 1u) << 3u);
        arg_a965a = ((loc_680e3 & 3u) | ((loc_680e3 & 12u) << 2u)) | (((loc_9a4d6 & 3u) | ((loc_9a4d6 & 12u) << 2u)) << 2u);
        return;
    }
    uint loc_3413e = ((((var_f2df9.VoxelBuffer[loc_a0cb4].data >> 15u) & 1u) | (((var_f2df9.VoxelBuffer[loc_a0cb4].data >> 31u) & 1u) << 1u)) | (((var_f2df9.VoxelBuffer[loc_50d99].data >> 15u) & 1u) << 2u)) | (((var_f2df9.VoxelBuffer[loc_50d99].data >> 31u) & 1u) << 3u);
    ivec3 loc_f0131 = arg_f7dc9;
    uint loc_3a44a = (uint(loc_f0131.x - (-1)) * 18u) + uint(loc_f0131.z - (-1));
    uint loc_1d03f = loc_3a44a / 32u;
    uint loc_dcf35 = loc_3a44a % 32u;
    uint loc_38235 = arg_45009 + 4440u;
    uint loc_c3396 = var_f2df9.VoxelBuffer[loc_38235 + loc_1d03f].data >> loc_dcf35;
    uint loc_f671b;
    if (loc_dcf35 > 12u)
    {
        loc_f671b = loc_c3396 | (var_f2df9.VoxelBuffer[(loc_38235 + loc_1d03f) + 1u].data << (32u - loc_dcf35));
    }
    else
    {
        loc_f671b = loc_c3396;
    }
    uint loc_88411 = (loc_f671b & 3u) | ((loc_f671b >> 16u) & 12u);
    arg_a965a = ((loc_3413e & 3u) | ((loc_3413e & 12u) << 2u)) | (((loc_88411 & 3u) | ((loc_88411 & 12u) << 2u)) << 2u);
}
void func_f0f8c(inout uint arg_047d2, inout vec3 arg_aa7d7) {
    if (var_f2df9.VoxelBuffer[arg_047d2].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    vec4 loc_951c2 = vec4(uvec4(var_f2df9.VoxelBuffer[arg_047d2].data, var_f2df9.VoxelBuffer[arg_047d2].data >> 8u, var_f2df9.VoxelBuffer[arg_047d2].data >> 16u, var_f2df9.VoxelBuffer[arg_047d2].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    vec4 loc_0dc9c = loc_951c2;
    arg_aa7d7 = (loc_951c2.xyz * loc_0dc9c.w) * 6.0;
}
void func_e760e(inout int arg_689f7, inout vec3 arg_534d1, inout vec3 arg_13804, inout vec3 arg_18a62, inout uint arg_92f3d) {
    bool loc_c7009 = var_30d2d[arg_689f7] >= 0;
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
    if (var_30d2d[arg_689f7] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_13804 - arg_18a62) & uvec3(15u);
        loc_58bb3 = arg_92f3d + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        uvec3 loc_441ec = uvec3(arg_13804 - (floor(arg_13804 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_f2df9.VoxelBuffer[(arg_92f3d + 4097u) + uint(var_30d2d[arg_689f7])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    vec3 loc_0b351;
    func_f0f8c(loc_58bb3, loc_0b351);
    arg_534d1 = loc_0b351;
}
void func_5b69f(inout int arg_eae48, inout uint arg_ccc49, inout vec3 arg_534d1, inout vec3 arg_13804, inout vec3 arg_18a62) {
    bool loc_c7009 = var_30d2d[arg_eae48] >= 0;
    bool loc_aa1a7;
    if (loc_c7009)
    {
        loc_aa1a7 = !((var_f2df9.VoxelBuffer[arg_ccc49 + 4096u].data & (1u << uint(var_30d2d[arg_eae48]))) != 0u);
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
    if (var_30d2d[arg_eae48] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_13804 - arg_18a62) & uvec3(15u);
        loc_58bb3 = arg_ccc49 + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        uvec3 loc_441ec = uvec3(arg_13804 - (floor(arg_13804 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_f2df9.VoxelBuffer[(arg_ccc49 + 4097u) + uint(var_30d2d[arg_eae48])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    vec3 loc_0b351;
    func_f0f8c(loc_58bb3, loc_0b351);
    arg_534d1 = loc_0b351;
}
void func_25574(inout vec3 arg_504ca, inout vec3 arg_7231f, inout uint arg_75c69, inout vec3 arg_fadf1) {
    vec3 loc_3eeaf = arg_504ca - arg_7231f;
    int loc_dfc70 = ((((int(loc_3eeaf.x < 0.0) | (int(loc_3eeaf.x >= 16.0) << 1)) | (int(loc_3eeaf.y < 0.0) << 2)) | (int(loc_3eeaf.y >= 16.0) << 3)) | (int(loc_3eeaf.z < 0.0) << 4)) | (int(loc_3eeaf.z >= 16.0) << 5);
    if (var_30d2d[loc_dfc70] < 0)
    {
        vec3 loc_6db33;
        func_e760e(loc_dfc70, loc_6db33, arg_504ca, arg_7231f, arg_75c69);
        arg_fadf1 = loc_6db33;
        return;
    }
    vec3 loc_5086d;
    func_5b69f(loc_dfc70, arg_75c69, loc_5086d, arg_504ca, arg_7231f);
    arg_fadf1 = loc_5086d;
}
void func_65d7c(inout float arg_40206, inout vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_924f2, inout uint arg_85962, inout ivec3 arg_22ce3, inout vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_02a32 = uvec3(arg_924f2);
        uint loc_e0607 = arg_85962 + ((loc_02a32.y + (loc_02a32.z * 16u)) + (loc_02a32.x * 256u));
        vec3 loc_f6126;
        func_f0f8c(loc_e0607, loc_f6126);
        arg_e2a96 = loc_f6126;
        return;
    }
    vec3 loc_34245 = vec3(arg_22ce3);
    vec3 loc_df982;
    func_25574(loc_34245, arg_8532d, arg_85962, loc_df982);
    arg_e2a96 = loc_df982;
}
void func_70c8c(inout float arg_40206, inout vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_283b9, inout uint arg_85962, inout ivec3 arg_1f2f2, inout vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_ed900 = uvec3(arg_283b9 + ivec3(0, 0, 1));
        uint loc_e0607 = arg_85962 + ((loc_ed900.y + (loc_ed900.z * 16u)) + (loc_ed900.x * 256u));
        vec3 loc_f6126;
        func_f0f8c(loc_e0607, loc_f6126);
        arg_e2a96 = loc_f6126;
        return;
    }
    vec3 loc_2b205 = vec3(arg_1f2f2 + ivec3(0, 0, 1));
    vec3 loc_df982;
    func_25574(loc_2b205, arg_8532d, arg_85962, loc_df982);
    arg_e2a96 = loc_df982;
}
void func_47a12(inout float arg_40206, inout vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_5cd5c, inout uint arg_85962, inout ivec3 arg_e0e74, inout vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_9117a = uvec3(arg_5cd5c + ivec3(0, 1, 0));
        uint loc_e0607 = arg_85962 + ((loc_9117a.y + (loc_9117a.z * 16u)) + (loc_9117a.x * 256u));
        vec3 loc_f6126;
        func_f0f8c(loc_e0607, loc_f6126);
        arg_e2a96 = loc_f6126;
        return;
    }
    vec3 loc_fffca = vec3(arg_e0e74 + ivec3(0, 1, 0));
    vec3 loc_df982;
    func_25574(loc_fffca, arg_8532d, arg_85962, loc_df982);
    arg_e2a96 = loc_df982;
}
void func_78b73(inout float arg_40206, inout vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_6740d, inout uint arg_85962, inout ivec3 arg_3e26e, inout vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_e4e26 = uvec3(arg_6740d + ivec3(0, 1, 1));
        uint loc_e0607 = arg_85962 + ((loc_e4e26.y + (loc_e4e26.z * 16u)) + (loc_e4e26.x * 256u));
        vec3 loc_f6126;
        func_f0f8c(loc_e0607, loc_f6126);
        arg_e2a96 = loc_f6126;
        return;
    }
    vec3 loc_50824 = vec3(arg_3e26e + ivec3(0, 1, 1));
    vec3 loc_df982;
    func_25574(loc_50824, arg_8532d, arg_85962, loc_df982);
    arg_e2a96 = loc_df982;
}
void func_05295(inout float arg_40206, inout vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_ce1e5, inout uint arg_85962, inout ivec3 arg_ac640, inout vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_388a8 = uvec3(arg_ce1e5 + ivec3(1, 0, 0));
        uint loc_e0607 = arg_85962 + ((loc_388a8.y + (loc_388a8.z * 16u)) + (loc_388a8.x * 256u));
        vec3 loc_f6126;
        func_f0f8c(loc_e0607, loc_f6126);
        arg_e2a96 = loc_f6126;
        return;
    }
    vec3 loc_0ab51 = vec3(arg_ac640 + ivec3(1, 0, 0));
    vec3 loc_df982;
    func_25574(loc_0ab51, arg_8532d, arg_85962, loc_df982);
    arg_e2a96 = loc_df982;
}
void func_c0f47(inout float arg_40206, inout vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_90312, inout uint arg_85962, inout ivec3 arg_cf5c6, inout vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_c1e8b = uvec3(arg_90312 + ivec3(1, 0, 1));
        uint loc_e0607 = arg_85962 + ((loc_c1e8b.y + (loc_c1e8b.z * 16u)) + (loc_c1e8b.x * 256u));
        vec3 loc_f6126;
        func_f0f8c(loc_e0607, loc_f6126);
        arg_e2a96 = loc_f6126;
        return;
    }
    vec3 loc_a7227 = vec3(arg_cf5c6 + ivec3(1, 0, 1));
    vec3 loc_df982;
    func_25574(loc_a7227, arg_8532d, arg_85962, loc_df982);
    arg_e2a96 = loc_df982;
}
void func_8b8c2(inout float arg_40206, inout vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_5d8a7, inout uint arg_85962, inout ivec3 arg_d287f, inout vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_5483e = uvec3(arg_5d8a7 + ivec3(1, 1, 0));
        uint loc_e0607 = arg_85962 + ((loc_5483e.y + (loc_5483e.z * 16u)) + (loc_5483e.x * 256u));
        vec3 loc_f6126;
        func_f0f8c(loc_e0607, loc_f6126);
        arg_e2a96 = loc_f6126;
        return;
    }
    vec3 loc_9bbb3 = vec3(arg_d287f + ivec3(1, 1, 0));
    vec3 loc_df982;
    func_25574(loc_9bbb3, arg_8532d, arg_85962, loc_df982);
    arg_e2a96 = loc_df982;
}
void func_33262(inout float arg_40206, inout vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_eefc1, inout uint arg_85962, inout ivec3 arg_b96d4, inout vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_8b407 = uvec3(arg_eefc1 + ivec3(1));
        uint loc_e0607 = arg_85962 + ((loc_8b407.y + (loc_8b407.z * 16u)) + (loc_8b407.x * 256u));
        vec3 loc_f6126;
        func_f0f8c(loc_e0607, loc_f6126);
        arg_e2a96 = loc_f6126;
        return;
    }
    vec3 loc_426d1 = vec3(arg_b96d4 + ivec3(1));
    vec3 loc_df982;
    func_25574(loc_426d1, arg_8532d, arg_85962, loc_df982);
    arg_e2a96 = loc_df982;
}
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
void func_6525f() {
    int loc_79ceb = int(gl_GlobalInvocationID.x);
    int loc_53256 = int(gl_GlobalInvocationID.y);
    int loc_9abbf = int(gl_GlobalInvocationID.z);
    if (((loc_79ceb >= int(VolumeDimensions.x)) || (loc_53256 >= int(VolumeDimensions.y))) || (loc_9abbf >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_a69bc = (vec3(float(loc_79ceb), float(loc_53256), float(loc_9abbf)) + vec3(0.5)) / VolumeDimensions.xyz;
    vec3 loc_b4177 = loc_a69bc;
    vec3 loc_777c2 = loc_a69bc;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_a69bc.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_c8767 = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_c8767;
    vec3 loc_16a16 = (u_view * vec4(loc_c8767, 1.0)).xyz;
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
    float loc_62499;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_62499 = 1.0 - loc_8fa9c;
    }
    else
    {
        loc_62499 = loc_8fa9c;
    }
    vec4 loc_4397b;
    func_b5ebb(loc_c8767, loc_4397b);
    vec4 loc_a5348 = loc_4397b;
    float loc_2c406 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_fbcc6 = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_62499);
    float loc_9fe9d = length(loc_16a16);
    float loc_8ddfa = clamp((((loc_9fe9d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_72282 = mix(mix((AirAlbedoExtinction.xyz * loc_2c406) * AirAlbedoExtinction.w, loc_4397b.xyz * loc_a5348.w, vec3(loc_62499)), vec3(0.0), vec3(loc_8ddfa));
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
        vec3 loc_08c5f = loc_a69bc;
        loc_08c5f.y = 1.0 - loc_08c5f.y;
        if (SkySamplesConfig.y > 0.5)
        {
            loc_08c5f.z -= SkySamplesConfig.z;
        }
        loc_08c5f.z = (exp(4.0 * loc_08c5f.z) - 1.0) * 0.0186573602259159088134765625;
        loc_ea783 = textureLod(s_SkyAmbientSamples, loc_08c5f, 0.0).xy;
    }
    vec3 loc_13ec4;
    if (DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled.z != 0.0)
    {
        vec3 loc_05fa0 = loc_c8767 - WorldOrigin.xyz;
        vec3 loc_61ba6 = loc_05fa0 - vec3(0.5);
        vec3 loc_e93b5 = vec3(0.0);
        vec3 loc_a6f3b = floor(loc_61ba6 * 0.0625) * 16.0;
        ivec4 loc_5d362 = ivec4(ivec3(floor(vec3(ivec3(floor(loc_61ba6))) * vec3(0.0625))), 0);
        ivec4 loc_bdc37 = loc_5d362;
        int loc_ab334 = (loc_bdc37.x & 65535) | (loc_bdc37.y << 16);
        int loc_76717 = (loc_bdc37.z & 65535) | (loc_bdc37.w << 16);
        ivec4 loc_4e614 = loc_5d362;
        uint loc_48d5b = uint(loc_4e614.x) * 1540483477u;
        uint loc_d322d = uint(loc_4e614.y) * 1540483477u;
        uint loc_33724 = uint(loc_4e614.z) * 1540483477u;
        uint loc_05410 = uint(loc_4e614.w) * 1540483477u;
        uint loc_fd4f6 = ((((((2293326976u ^ ((loc_48d5b ^ (loc_48d5b >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_d322d ^ (loc_d322d >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_33724 ^ (loc_33724 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_05410 ^ (loc_05410 >> uint(24))) * 1540483477u);
        uint loc_2545b = (loc_fd4f6 ^ (loc_fd4f6 >> uint(13))) * 1540483477u;
        uint loc_19f5a = loc_2545b ^ (loc_2545b >> uint(15));
        uint loc_065df = (loc_19f5a ^ (loc_19f5a >> uint(16))) & 65535u;
        uint loc_c4ba2 = loc_065df | uint(loc_065df == 0u);
        uint loc_980a9 = uint(GpuEntryBufferCapacity.x);
        int loc_d6224;
        uint loc_75570;
        bool loc_87a71;
        uint loc_8e0b6;
        loc_8e0b6 = 0u;
        loc_87a71 = false;
        loc_75570 = loc_c4ba2 & (loc_980a9 - 1u);
        loc_d6224 = 0;
        bool loc_4f504;
        uint loc_d350f;
        uint loc_e1ab1;
        uint loc_79d95;
        bool loc_a0c0a;
        for (;;)
        {
            if (loc_d6224 < 8)
            {
                uint loc_a70f2 = uint(var_ceedc.GpuEntryBuffer[loc_75570].hash) & 65535u;
                bool loc_734de = loc_a70f2 == loc_c4ba2;
                bool loc_e4213;
                if (loc_734de)
                {
                    loc_e4213 = var_ceedc.GpuEntryBuffer[loc_75570].packed_xy == loc_ab334;
                }
                else
                {
                    loc_e4213 = loc_734de;
                }
                bool loc_ec5a7;
                if (loc_e4213)
                {
                    loc_ec5a7 = var_ceedc.GpuEntryBuffer[loc_75570].packed_zw == loc_76717;
                }
                else
                {
                    loc_ec5a7 = loc_e4213;
                }
                if (loc_87a71)
                {
                    loc_e1ab1 = loc_8e0b6;
                }
                else
                {
                    uint loc_5ebd4;
                    if (loc_ec5a7)
                    {
                        loc_5ebd4 = uint(var_ceedc.GpuEntryBuffer[loc_75570].user_data);
                    }
                    else
                    {
                        loc_5ebd4 = loc_8e0b6;
                    }
                    loc_e1ab1 = loc_5ebd4;
                }
                loc_4f504 = loc_87a71 || loc_ec5a7;
                loc_d350f = (loc_75570 + 1u) & (loc_980a9 - 1u);
                if (loc_4f504 || (loc_a70f2 == 0u))
                {
                    loc_a0c0a = loc_4f504;
                    loc_79d95 = loc_e1ab1;
                    break;
                }
                loc_8e0b6 = loc_e1ab1;
                loc_87a71 = loc_4f504;
                loc_75570 = loc_d350f;
                loc_d6224++;
                continue;
            }
            else
            {
                loc_a0c0a = loc_87a71;
                loc_79d95 = loc_8e0b6;
                break;
            }
        }
        uint loc_e47c3 = loc_79d95 >> 2u;
        vec3 loc_38937;
        if (loc_a0c0a)
        {
            vec3 loc_49211 = loc_05fa0;
            float loc_fd372;
            if (loc_e93b5.x > 0.0)
            {
                loc_fd372 = ceil(loc_49211.x) - 1.0;
            }
            else
            {
                loc_fd372 = floor(loc_49211.x);
            }
            float loc_6d63e;
            if (loc_e93b5.y > 0.0)
            {
                loc_6d63e = ceil(loc_49211.y) - 1.0;
            }
            else
            {
                loc_6d63e = floor(loc_49211.y);
            }
            float loc_2928b;
            if (loc_e93b5.z > 0.0)
            {
                loc_2928b = ceil(loc_49211.z) - 1.0;
            }
            else
            {
                loc_2928b = floor(loc_49211.z);
            }
            ivec3 loc_f6fc1 = ivec3(int(loc_fd372), int(loc_6d63e), int(loc_2928b));
            ivec3 loc_81175 = clamp(ivec3(round(loc_05fa0)) - ivec3(1), loc_f6fc1 - ivec3(1), loc_f6fc1);
            ivec3 loc_74515 = loc_81175 - ivec3(loc_a6f3b);
            ivec3 loc_6b6eb = loc_74515;
            uint loc_1e57d;
            func_fff8e(loc_e47c3, loc_6b6eb, loc_1e57d, loc_74515);
            vec3 loc_35412 = clamp(fract(loc_05fa0 - vec3(0.5)), vec3(0.0), vec3(1.0));
            ivec3 loc_e3844 = loc_81175 - ivec3(loc_a6f3b);
            bool loc_0aee9 = all(greaterThanEqual(loc_e3844, ivec3(0)));
            bool loc_b1639;
            if (loc_0aee9)
            {
                loc_b1639 = all(lessThan(loc_e3844, ivec3(15)));
            }
            else
            {
                loc_b1639 = loc_0aee9;
            }
            float loc_39241 = float((loc_1e57d & 1u) == 0u);
            float loc_71416 = float((loc_1e57d & 2u) == 0u);
            float loc_1b35f = float((loc_1e57d & 4u) == 0u);
            float loc_b1747 = float((loc_1e57d & 8u) == 0u);
            float loc_f5a8e = float((loc_1e57d & 16u) == 0u);
            float loc_56c0e = float((loc_1e57d & 32u) == 0u);
            float loc_c4b43 = float((loc_1e57d & 64u) == 0u);
            float loc_40a80 = float((loc_1e57d & 128u) == 0u);
            vec3 loc_36ec9;
            func_65d7c(loc_39241, loc_36ec9, loc_b1639, loc_e3844, loc_e47c3, loc_81175, loc_a6f3b);
            vec3 loc_32b4a;
            func_70c8c(loc_71416, loc_32b4a, loc_b1639, loc_e3844, loc_e47c3, loc_81175, loc_a6f3b);
            vec3 loc_de270;
            func_47a12(loc_1b35f, loc_de270, loc_b1639, loc_e3844, loc_e47c3, loc_81175, loc_a6f3b);
            vec3 loc_b1b0b;
            func_78b73(loc_b1747, loc_b1b0b, loc_b1639, loc_e3844, loc_e47c3, loc_81175, loc_a6f3b);
            vec3 loc_3a7b1;
            func_05295(loc_f5a8e, loc_3a7b1, loc_b1639, loc_e3844, loc_e47c3, loc_81175, loc_a6f3b);
            vec3 loc_bf9f2;
            func_c0f47(loc_56c0e, loc_bf9f2, loc_b1639, loc_e3844, loc_e47c3, loc_81175, loc_a6f3b);
            vec3 loc_4e916;
            func_8b8c2(loc_c4b43, loc_4e916, loc_b1639, loc_e3844, loc_e47c3, loc_81175, loc_a6f3b);
            vec3 loc_964fa;
            func_33262(loc_40a80, loc_964fa, loc_b1639, loc_e3844, loc_e47c3, loc_81175, loc_a6f3b);
            float loc_58f2a = 1.0 - loc_35412.x;
            float loc_bf315 = 1.0 - loc_35412.y;
            float loc_1facb = 1.0 - loc_35412.z;
            float loc_54099 = ((loc_58f2a * loc_bf315) * loc_1facb) * loc_39241;
            float loc_776b0 = ((loc_58f2a * loc_bf315) * loc_35412.z) * loc_71416;
            float loc_d6e48 = ((loc_58f2a * loc_35412.y) * loc_1facb) * loc_1b35f;
            float loc_a2e2e = ((loc_58f2a * loc_35412.y) * loc_35412.z) * loc_b1747;
            float loc_9cc4a = ((loc_35412.x * loc_bf315) * loc_1facb) * loc_f5a8e;
            float loc_5256d = ((loc_35412.x * loc_bf315) * loc_35412.z) * loc_56c0e;
            float loc_1fbb2 = ((loc_35412.x * loc_35412.y) * loc_1facb) * loc_c4b43;
            float loc_b39b8 = ((loc_35412.x * loc_35412.y) * loc_35412.z) * loc_40a80;
            float loc_8eb23 = ((((((loc_54099 + loc_776b0) + loc_d6e48) + loc_a2e2e) + loc_9cc4a) + loc_5256d) + loc_1fbb2) + loc_b39b8;
            vec3 loc_41fdf;
            if (loc_8eb23 > 0.0)
            {
                loc_41fdf = ((((((((loc_36ec9 * loc_54099) + (loc_32b4a * loc_776b0)) + (loc_de270 * loc_d6e48)) + (loc_b1b0b * loc_a2e2e)) + (loc_3a7b1 * loc_9cc4a)) + (loc_bf9f2 * loc_5256d)) + (loc_4e916 * loc_1fbb2)) + (loc_964fa * loc_b39b8)) / vec3(loc_8eb23);
            }
            else
            {
                loc_41fdf = vec3(0.0);
            }
            loc_38937 = loc_41fdf;
        }
        else
        {
            loc_38937 = vec3(0.0);
        }
        loc_13ec4 = loc_38937 * BlockBaseAmbientLightColorIntensity.w;
    }
    else
    {
        loc_13ec4 = (BlockBaseAmbientLightColorIntensity.xyz * loc_ea783.x) * BlockBaseAmbientLightColorIntensity.w;
    }
    vec3 loc_687db = ((loc_72282 * 0.079577468335628509521484375) * max(loc_13ec4 + ((SkyAmbientLightColorIntensity.xyz * loc_ea783.y) * SkyAmbientLightColorIntensity.w), vec3(MinAmbientValue.x))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
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
    vec3 loc_4c028;
    if (loc_7e26a)
    {
        float loc_93a3c = (1.0 + (loc_fbcc6 * loc_fbcc6)) + ((2.0 * loc_fbcc6) * dot(-(loc_16a16 / vec3(loc_9fe9d)), normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_f95d1 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_4c028 = loc_687db + (((loc_72282 * imageLoad(s_CascadedShadowBuffer, ivec3(loc_79ceb, loc_53256, loc_9abbf)).x) * ((0.079577468335628509521484375 * (1.0 - (loc_fbcc6 * loc_fbcc6))) / (loc_93a3c * sqrt(loc_93a3c)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_f95d1.w));
    }
    else
    {
        loc_4c028 = loc_687db;
    }
    imageStore(s_ScatteringBufferOut, ivec3(loc_79ceb, loc_53256, loc_9abbf), vec4(loc_4c028, mix(mix(loc_2c406 * AirAlbedoExtinction.w, loc_a5348.w, loc_62499), 0.0, loc_8ddfa)));
}
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
void func_d24d6(inout vec3 arg_8311e, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    vec3 loc_70de6 = arg_8311e;
    vec3 loc_3195e = ClusterDimensions.xyz;
    vec2 loc_90806 = ClusterDepthBounds.xy;
    vec4 loc_2773a = PointLightPreCalcValuesAndAmbientScalar;
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
            loc_b1845 = min(floor(clamp((log2(loc_1ee6d) - loc_2773a.z) * loc_2773a.x, 0.0, 1.0) * (loc_3195e.z - 2.0)) + 2.0, loc_3195e.z - 1.0);
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
void func_2a474(inout int arg_55dd7, inout float arg_9499a, inout vec3 arg_226c4) {
    if (arg_55dd7 < 0)
    {
        arg_9499a = 0.0;
        return;
    }
    vec3 loc_742e7 = arg_226c4 - var_eaf9f.zLights[arg_55dd7].position.xyz;
    vec3 loc_7cf5a = loc_742e7;
    vec3 loc_ae7bb = abs(loc_742e7);
    bool loc_ab77c = loc_ae7bb.x >= loc_ae7bb.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_ae7bb.x >= loc_ae7bb.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    int loc_f3fad;
    if (loc_ca7f9)
    {
        loc_f3fad = (loc_7cf5a.x >= 0.0) ? 0 : 1;
    }
    else
    {
        int loc_1358b;
        if (loc_ae7bb.y >= loc_ae7bb.z)
        {
            loc_1358b = (loc_7cf5a.y >= 0.0) ? 2 : 3;
        }
        else
        {
            loc_1358b = (loc_7cf5a.z >= 0.0) ? 4 : 5;
        }
        loc_f3fad = loc_1358b;
    }
    vec4 loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV0;
    vec3 loc_e85ed;
    if (loc_f3fad == 1)
    {
        loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV1;
        loc_e85ed = vec3(-loc_7cf5a.z, loc_7cf5a.y, loc_7cf5a.x);
    }
    else
    {
        vec3 loc_9e4d3;
        if (loc_f3fad == 2)
        {
            loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV2;
            loc_9e4d3 = vec3(-loc_7cf5a.x, -loc_7cf5a.z, -loc_7cf5a.y);
        }
        else
        {
            vec3 loc_69cfa;
            if (loc_f3fad == 3)
            {
                loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV3;
                loc_69cfa = vec3(-loc_7cf5a.x, loc_7cf5a.z, loc_7cf5a.y);
            }
            else
            {
                vec3 loc_c6606;
                if (loc_f3fad == 4)
                {
                    loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV4;
                    loc_c6606 = vec3(-loc_7cf5a.x, loc_7cf5a.y, -loc_7cf5a.z);
                }
                else
                {
                    vec3 loc_f4215;
                    if (loc_f3fad == 5)
                    {
                        loc_d3136 = var_eaf9f.zLights[arg_55dd7].shadowFaceUV5;
                        loc_f4215 = vec3(loc_7cf5a.x, loc_7cf5a.y, loc_7cf5a.z);
                    }
                    else
                    {
                        loc_f4215 = vec3(loc_7cf5a.z, loc_7cf5a.y, -loc_7cf5a.x);
                    }
                    loc_c6606 = loc_f4215;
                }
                loc_69cfa = loc_c6606;
            }
            loc_9e4d3 = loc_69cfa;
        }
        loc_e85ed = loc_9e4d3;
    }
    bool loc_da9b7 = loc_d3136.z == 0.0;
    bool loc_20dc6;
    if (loc_da9b7)
    {
        loc_20dc6 = loc_d3136.w == 0.0;
    }
    else
    {
        loc_20dc6 = loc_da9b7;
    }
    if (loc_20dc6)
    {
        arg_9499a = 0.0;
        return;
    }
    vec4 loc_c2d15 = PointLightProj * vec4(loc_e85ed, 1.0);
    float loc_b2ff8 = loc_c2d15.w;
    vec4 loc_9c4e8 = loc_c2d15;
    vec4 loc_cb30a = loc_9c4e8 / vec4(loc_b2ff8);
    loc_c2d15 = loc_cb30a;
    vec2 loc_ac5d5 = vec2(0.5) / PointLightShadowAtlasResolution.xy;
    vec2 loc_f65fa = loc_d3136.zw - loc_d3136.xy;
    vec2 loc_1f655 = loc_f65fa * PointLightShadowAtlasResolution.xy;
    float loc_41e57;
    if (((textureLod(s_PointLightShadowTextureAtlas, clamp(loc_d3136.xy + (((floor(((loc_cb30a.xy * 0.5) + vec2(0.5)) * loc_1f655) + vec2(0.5)) / loc_1f655) * loc_f65fa), loc_d3136.xy + loc_ac5d5, loc_d3136.zw - loc_ac5d5), 0.0).x * 2.0) - 1.0) >= loc_c2d15.z)
    {
        loc_41e57 = 1.0;
    }
    else
    {
        loc_41e57 = 0.0;
    }
    arg_9499a = loc_41e57;
}
void func_3bf09(inout int arg_ff970, inout float arg_43b7a, inout vec3 arg_0a2b9, inout vec3 arg_39715) {
    if (arg_ff970 < 0)
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    vec3 loc_55323 = var_eaf9f.zLights[arg_ff970].position.xyz - arg_39715;
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
    if (loc_63f32 >= (var_eaf9f.zLights[arg_ff970].position.w * var_eaf9f.zLights[arg_ff970].position.w))
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    float loc_b326d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0)
    {
        float loc_334de;
        func_2a474(arg_ff970, loc_334de, arg_39715);
        loc_b326d = loc_334de;
    }
    else
    {
        loc_b326d = 1.0;
    }
    float loc_728c0 = loc_63f32 / ((var_eaf9f.zLights[arg_ff970].position.w * var_eaf9f.zLights[arg_ff970].position.w) + 9.9999997473787516355514526367188e-05);
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
    arg_0a2b9 = (var_eaf9f.zLights[arg_ff970].color.xyz * var_eaf9f.zLights[arg_ff970].color.w) * loc_5501b;
}
void func_0582d(inout vec3 arg_5cc04, inout vec3 arg_534d1, inout vec3 arg_81f82, inout float arg_1eba3, inout vec3 arg_1cde6, inout vec3 arg_e7cf5) {
    bool loc_a0bb1;
    int loc_79315;
    int loc_822f5;
    func_d24d6(arg_5cc04, loc_822f5, loc_79315, loc_a0bb1);
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
        int loc_99f11 = int(var_d4998.zLightLookupArray[loc_97a60].lookup);
        if (loc_99f11 < 0)
        {
            break;
        }
        vec3 loc_102a3;
        float loc_b0161;
        func_3bf09(loc_99f11, loc_b0161, loc_102a3, arg_81f82);
        float loc_57b1f = (1.0 + (arg_1eba3 * arg_1eba3)) + ((2.0 * arg_1eba3) * dot(arg_1cde6, normalize((u_view * vec4(var_eaf9f.zLights[loc_99f11].position.xyz, 1.0)).xyz - arg_5cc04)));
        loc_3e87e = loc_ceaba + (((arg_e7cf5 * ((0.079577468335628509521484375 * (1.0 - (arg_1eba3 * arg_1eba3))) / (loc_57b1f * sqrt(loc_57b1f)))) * loc_b0161) * loc_102a3);
    }
    arg_534d1 = loc_ceaba;
}
void func_debb8() {
    int loc_79ceb = int(gl_GlobalInvocationID.x);
    int loc_53256 = int(gl_GlobalInvocationID.y);
    int loc_9abbf = int(gl_GlobalInvocationID.z);
    if (((loc_79ceb >= int(VolumeDimensions.x)) || (loc_53256 >= int(VolumeDimensions.y))) || (loc_9abbf >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_a69bc = (vec3(float(loc_79ceb), float(loc_53256), float(loc_9abbf)) + vec3(0.5)) / VolumeDimensions.xyz;
    vec3 loc_b4177 = loc_a69bc;
    vec3 loc_777c2 = loc_a69bc;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_a69bc.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_37221 = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_37221;
    vec3 loc_49313 = (u_view * vec4(loc_37221, 1.0)).xyz;
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
    float loc_62499;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_62499 = 1.0 - loc_8fa9c;
    }
    else
    {
        loc_62499 = loc_8fa9c;
    }
    vec4 loc_4397b;
    func_b5ebb(loc_37221, loc_4397b);
    vec4 loc_a5348 = loc_4397b;
    float loc_2c406 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_1f492 = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_62499);
    float loc_1595d = length(loc_49313);
    float loc_8ddfa = clamp((((loc_1595d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_78e52 = mix(mix((AirAlbedoExtinction.xyz * loc_2c406) * AirAlbedoExtinction.w, loc_4397b.xyz * loc_a5348.w, vec3(loc_62499)), vec3(0.0), vec3(loc_8ddfa));
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
        vec3 loc_08c5f = loc_a69bc;
        loc_08c5f.y = 1.0 - loc_08c5f.y;
        if (SkySamplesConfig.y > 0.5)
        {
            loc_08c5f.z -= SkySamplesConfig.z;
        }
        loc_08c5f.z = (exp(4.0 * loc_08c5f.z) - 1.0) * 0.0186573602259159088134765625;
        loc_ea783 = textureLod(s_SkyAmbientSamples, loc_08c5f, 0.0).xy;
    }
    bool loc_ef987 = DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0;
    bool loc_47c1b;
    if (loc_ef987)
    {
        loc_47c1b = DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled.z != 0.0;
    }
    else
    {
        loc_47c1b = loc_ef987;
    }
    vec3 loc_b3fdf;
    if (loc_47c1b)
    {
        vec3 loc_dc1f3 = loc_37221 - WorldOrigin.xyz;
        vec3 loc_d0845 = loc_dc1f3 + vec3(-0.5, -0.5, -0.4979999959468841552734375);
        vec3 loc_16caa = vec3(0.0, 0.0, 0.100000001490116119384765625);
        vec3 loc_a6f3b = floor(loc_d0845 * 0.0625) * 16.0;
        ivec4 loc_d46d8 = ivec4(ivec3(floor(vec3(ivec3(floor(loc_d0845))) * vec3(0.0625))), 2);
        ivec4 loc_bdc37 = loc_d46d8;
        int loc_ab334 = (loc_bdc37.x & 65535) | (loc_bdc37.y << 16);
        int loc_76717 = (loc_bdc37.z & 65535) | (loc_bdc37.w << 16);
        ivec4 loc_4e614 = loc_d46d8;
        uint loc_48d5b = uint(loc_4e614.x) * 1540483477u;
        uint loc_d322d = uint(loc_4e614.y) * 1540483477u;
        uint loc_33724 = uint(loc_4e614.z) * 1540483477u;
        uint loc_05410 = uint(loc_4e614.w) * 1540483477u;
        uint loc_fd4f6 = ((((((2293326976u ^ ((loc_48d5b ^ (loc_48d5b >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_d322d ^ (loc_d322d >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_33724 ^ (loc_33724 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((loc_05410 ^ (loc_05410 >> uint(24))) * 1540483477u);
        uint loc_2545b = (loc_fd4f6 ^ (loc_fd4f6 >> uint(13))) * 1540483477u;
        uint loc_19f5a = loc_2545b ^ (loc_2545b >> uint(15));
        uint loc_065df = (loc_19f5a ^ (loc_19f5a >> uint(16))) & 65535u;
        uint loc_c4ba2 = loc_065df | uint(loc_065df == 0u);
        uint loc_980a9 = uint(GpuEntryBufferCapacity.x);
        int loc_d6224;
        uint loc_75570;
        bool loc_87a71;
        uint loc_8e0b6;
        loc_8e0b6 = 0u;
        loc_87a71 = false;
        loc_75570 = loc_c4ba2 & (loc_980a9 - 1u);
        loc_d6224 = 0;
        bool loc_4f504;
        uint loc_d350f;
        uint loc_e1ab1;
        uint loc_79d95;
        bool loc_a0c0a;
        for (;;)
        {
            if (loc_d6224 < 8)
            {
                uint loc_a70f2 = uint(var_ceedc.GpuEntryBuffer[loc_75570].hash) & 65535u;
                bool loc_734de = loc_a70f2 == loc_c4ba2;
                bool loc_e4213;
                if (loc_734de)
                {
                    loc_e4213 = var_ceedc.GpuEntryBuffer[loc_75570].packed_xy == loc_ab334;
                }
                else
                {
                    loc_e4213 = loc_734de;
                }
                bool loc_ec5a7;
                if (loc_e4213)
                {
                    loc_ec5a7 = var_ceedc.GpuEntryBuffer[loc_75570].packed_zw == loc_76717;
                }
                else
                {
                    loc_ec5a7 = loc_e4213;
                }
                if (loc_87a71)
                {
                    loc_e1ab1 = loc_8e0b6;
                }
                else
                {
                    uint loc_5ebd4;
                    if (loc_ec5a7)
                    {
                        loc_5ebd4 = uint(var_ceedc.GpuEntryBuffer[loc_75570].user_data);
                    }
                    else
                    {
                        loc_5ebd4 = loc_8e0b6;
                    }
                    loc_e1ab1 = loc_5ebd4;
                }
                loc_4f504 = loc_87a71 || loc_ec5a7;
                loc_d350f = (loc_75570 + 1u) & (loc_980a9 - 1u);
                if (loc_4f504 || (loc_a70f2 == 0u))
                {
                    loc_a0c0a = loc_4f504;
                    loc_79d95 = loc_e1ab1;
                    break;
                }
                loc_8e0b6 = loc_e1ab1;
                loc_87a71 = loc_4f504;
                loc_75570 = loc_d350f;
                loc_d6224++;
                continue;
            }
            else
            {
                loc_a0c0a = loc_87a71;
                loc_79d95 = loc_8e0b6;
                break;
            }
        }
        uint loc_e47c3 = loc_79d95 >> 2u;
        vec3 loc_b9973;
        if (loc_a0c0a)
        {
            vec3 loc_24988 = loc_dc1f3 + vec3(0.0, 0.0, 0.0020000040531158447265625);
            vec3 loc_49211 = loc_24988;
            float loc_fd372;
            if (loc_16caa.x > 0.0)
            {
                loc_fd372 = ceil(loc_49211.x) - 1.0;
            }
            else
            {
                loc_fd372 = floor(loc_49211.x);
            }
            float loc_6d63e;
            if (loc_16caa.y > 0.0)
            {
                loc_6d63e = ceil(loc_49211.y) - 1.0;
            }
            else
            {
                loc_6d63e = floor(loc_49211.y);
            }
            float loc_2928b;
            if (loc_16caa.z > 0.0)
            {
                loc_2928b = ceil(loc_49211.z) - 1.0;
            }
            else
            {
                loc_2928b = floor(loc_49211.z);
            }
            ivec3 loc_9d74c = ivec3(int(loc_fd372), int(loc_6d63e), int(loc_2928b));
            ivec3 loc_3bf7c = clamp(ivec3(round(loc_24988)) - ivec3(1), loc_9d74c - ivec3(1), loc_9d74c);
            ivec3 loc_74515 = loc_3bf7c - ivec3(loc_a6f3b);
            ivec3 loc_6b6eb = loc_74515;
            uint loc_834ba;
            func_fff8e(loc_e47c3, loc_6b6eb, loc_834ba, loc_74515);
            uvec3 loc_e22cd = uvec3(loc_9d74c - loc_3bf7c);
            uint loc_a27f2 = ((loc_e22cd.x * 4u) + (loc_e22cd.y * 2u)) + loc_e22cd.z;
            vec3 loc_73f5b = abs(vec3(0.0, 0.0, 0.100000001490116119384765625));
            vec3 loc_edebc = loc_73f5b;
            bool loc_a1b7b = loc_edebc.x >= loc_edebc.y;
            bool loc_30266;
            if (loc_a1b7b)
            {
                loc_30266 = loc_edebc.x >= loc_edebc.z;
            }
            else
            {
                loc_30266 = loc_a1b7b;
            }
            uint loc_70925;
            if (loc_30266)
            {
                loc_70925 = 0u;
            }
            else
            {
                uint loc_d02b6;
                if (loc_edebc.y >= loc_edebc.z)
                {
                    loc_d02b6 = 1u;
                }
                else
                {
                    loc_d02b6 = 2u;
                }
                loc_70925 = loc_d02b6;
            }
            uint loc_9c2a6;
            if ((loc_834ba & (1u << loc_a27f2)) != 0u)
            {
                loc_9c2a6 = loc_a27f2 ^ var_a6f79[loc_70925];
            }
            else
            {
                loc_9c2a6 = loc_a27f2;
            }
            uint loc_5c478;
            if ((loc_9c2a6 & var_a6f79[loc_70925]) != 0u)
            {
                loc_5c478 = var_083eb[loc_70925] ^ 255u;
            }
            else
            {
                loc_5c478 = var_083eb[loc_70925];
            }
            uint loc_bb636 = (var_a6f79[loc_70925] == 4u) ? 2u : 4u;
            uint loc_a29f1 = (var_a6f79[loc_70925] == 1u) ? 2u : 1u;
            uint loc_a9057 = (1u << (loc_9c2a6 ^ loc_bb636)) | (1u << (loc_9c2a6 ^ loc_a29f1));
            uint loc_2f529;
            if ((loc_834ba & loc_a9057) == loc_a9057)
            {
                loc_2f529 = loc_5c478 | (1u << ((loc_9c2a6 ^ loc_bb636) ^ loc_a29f1));
            }
            else
            {
                loc_2f529 = loc_5c478;
            }
            uint loc_d49a1 = loc_2f529 | loc_834ba;
            vec3 loc_2b290 = clamp(fract(loc_dc1f3 + vec3(-0.5, -0.5, -0.4979999959468841552734375)), vec3(0.0), vec3(1.0));
            ivec3 loc_e3844 = loc_3bf7c - ivec3(loc_a6f3b);
            bool loc_0aee9 = all(greaterThanEqual(loc_e3844, ivec3(0)));
            bool loc_b1639;
            if (loc_0aee9)
            {
                loc_b1639 = all(lessThan(loc_e3844, ivec3(15)));
            }
            else
            {
                loc_b1639 = loc_0aee9;
            }
            float loc_39241 = float((loc_d49a1 & 1u) == 0u);
            float loc_71416 = float((loc_d49a1 & 2u) == 0u);
            float loc_1b35f = float((loc_d49a1 & 4u) == 0u);
            float loc_b1747 = float((loc_d49a1 & 8u) == 0u);
            float loc_f5a8e = float((loc_d49a1 & 16u) == 0u);
            float loc_56c0e = float((loc_d49a1 & 32u) == 0u);
            float loc_c4b43 = float((loc_d49a1 & 64u) == 0u);
            float loc_40a80 = float((loc_d49a1 & 128u) == 0u);
            vec3 loc_36ec9;
            func_65d7c(loc_39241, loc_36ec9, loc_b1639, loc_e3844, loc_e47c3, loc_3bf7c, loc_a6f3b);
            vec3 loc_32b4a;
            func_70c8c(loc_71416, loc_32b4a, loc_b1639, loc_e3844, loc_e47c3, loc_3bf7c, loc_a6f3b);
            vec3 loc_de270;
            func_47a12(loc_1b35f, loc_de270, loc_b1639, loc_e3844, loc_e47c3, loc_3bf7c, loc_a6f3b);
            vec3 loc_b1b0b;
            func_78b73(loc_b1747, loc_b1b0b, loc_b1639, loc_e3844, loc_e47c3, loc_3bf7c, loc_a6f3b);
            vec3 loc_3a7b1;
            func_05295(loc_f5a8e, loc_3a7b1, loc_b1639, loc_e3844, loc_e47c3, loc_3bf7c, loc_a6f3b);
            vec3 loc_bf9f2;
            func_c0f47(loc_56c0e, loc_bf9f2, loc_b1639, loc_e3844, loc_e47c3, loc_3bf7c, loc_a6f3b);
            vec3 loc_4e916;
            func_8b8c2(loc_c4b43, loc_4e916, loc_b1639, loc_e3844, loc_e47c3, loc_3bf7c, loc_a6f3b);
            vec3 loc_964fa;
            func_33262(loc_40a80, loc_964fa, loc_b1639, loc_e3844, loc_e47c3, loc_3bf7c, loc_a6f3b);
            float loc_58f2a = 1.0 - loc_2b290.x;
            float loc_bf315 = 1.0 - loc_2b290.y;
            float loc_1facb = 1.0 - loc_2b290.z;
            float loc_54099 = ((loc_58f2a * loc_bf315) * loc_1facb) * loc_39241;
            float loc_776b0 = ((loc_58f2a * loc_bf315) * loc_2b290.z) * loc_71416;
            float loc_d6e48 = ((loc_58f2a * loc_2b290.y) * loc_1facb) * loc_1b35f;
            float loc_a2e2e = ((loc_58f2a * loc_2b290.y) * loc_2b290.z) * loc_b1747;
            float loc_9cc4a = ((loc_2b290.x * loc_bf315) * loc_1facb) * loc_f5a8e;
            float loc_5256d = ((loc_2b290.x * loc_bf315) * loc_2b290.z) * loc_56c0e;
            float loc_1fbb2 = ((loc_2b290.x * loc_2b290.y) * loc_1facb) * loc_c4b43;
            float loc_b39b8 = ((loc_2b290.x * loc_2b290.y) * loc_2b290.z) * loc_40a80;
            float loc_8eb23 = ((((((loc_54099 + loc_776b0) + loc_d6e48) + loc_a2e2e) + loc_9cc4a) + loc_5256d) + loc_1fbb2) + loc_b39b8;
            vec3 loc_41fdf;
            if (loc_8eb23 > 0.0)
            {
                loc_41fdf = ((((((((loc_36ec9 * loc_54099) + (loc_32b4a * loc_776b0)) + (loc_de270 * loc_d6e48)) + (loc_b1b0b * loc_a2e2e)) + (loc_3a7b1 * loc_9cc4a)) + (loc_bf9f2 * loc_5256d)) + (loc_4e916 * loc_1fbb2)) + (loc_964fa * loc_b39b8)) / vec3(loc_8eb23);
            }
            else
            {
                loc_41fdf = vec3(0.0);
            }
            loc_b9973 = loc_41fdf;
        }
        else
        {
            loc_b9973 = vec3(0.0);
        }
        loc_b3fdf = (loc_b9973 * BlockBaseAmbientLightColorIntensity.w) * PointLightPreCalcValuesAndAmbientScalar.w;
    }
    else
    {
        loc_b3fdf = (BlockBaseAmbientLightColorIntensity.xyz * loc_ea783.x) * BlockBaseAmbientLightColorIntensity.w;
    }
    vec3 loc_687db = ((loc_78e52 * 0.079577468335628509521484375) * max(loc_b3fdf + ((SkyAmbientLightColorIntensity.xyz * loc_ea783.y) * SkyAmbientLightColorIntensity.w), vec3(MinAmbientValue.x))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
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
    vec3 loc_10973;
    if (loc_7e26a)
    {
        float loc_095bd = (1.0 + (loc_1f492 * loc_1f492)) + ((2.0 * loc_1f492) * dot(loc_09caf, normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_f95d1 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_10973 = loc_687db + (((loc_78e52 * imageLoad(s_CascadedShadowBuffer, ivec3(loc_79ceb, loc_53256, loc_9abbf)).x) * ((0.079577468335628509521484375 * (1.0 - (loc_1f492 * loc_1f492))) / (loc_095bd * sqrt(loc_095bd)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_f95d1.w));
    }
    else
    {
        loc_10973 = loc_687db;
    }
    bool loc_15286 = VolumeScatteringEnabledAndPointLightVolumetricsEnabled.y != 0.0;
    bool loc_1a69f;
    if (loc_15286)
    {
        loc_1a69f = DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0;
    }
    else
    {
        loc_1a69f = loc_15286;
    }
    vec3 loc_c7184;
    if (loc_1a69f)
    {
        vec3 loc_e1cc9;
        func_0582d(loc_49313, loc_e1cc9, loc_37221, loc_1f492, loc_09caf, loc_78e52);
        loc_c7184 = loc_10973 + (loc_e1cc9 * (1.0 - PointLightPreCalcValuesAndAmbientScalar.w));
    }
    else
    {
        loc_c7184 = loc_10973;
    }
    imageStore(s_ScatteringBufferOut, ivec3(loc_79ceb, loc_53256, loc_9abbf), vec4(loc_c7184, mix(mix(loc_2c406 * AirAlbedoExtinction.w, loc_a5348.w, loc_62499), 0.0, loc_8ddfa)));
}
#endif
void main() {
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__OFF)
    func_e9e34();
#endif
#if defined(GPU_BLOCK_LIGHTING__OFF) && defined(POINT_LIGHT_SHADING__ON)
    func_76218();
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__OFF)
    func_6525f();
#endif
#if defined(GPU_BLOCK_LIGHTING__ON) && defined(POINT_LIGHT_SHADING__ON)
    func_debb8();
#endif
}
