#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - WATER_SURFACE_PASS (not used)
*
* GPUBlockLighting:
* - GPU_BLOCK_LIGHTING__OFF (not used)
* - GPU_BLOCK_LIGHTING__ON (not used)
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF
* - POINT_LIGHT_SHADING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp usampler2D s_EmissiveAmbientLinearRoughness;
* - layout(binding = 12, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 13, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
* - layout(binding = 14, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 15, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 16, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BiomeBlendingLastUpdatePosition;
* - uniform vec4 BiomeBlendingParameters;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraAmbientContribution;
* - uniform vec4 CameraIsUnderwater;
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
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
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
#ifdef POINT_LIGHT_SHADING__ON
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

int var_e7b23;
layout(binding = 16, std430) buffer s_zLights { Light zLights[]; } var_232b7;
layout(binding = 15, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_d7f5e;
#endif
uniform highp mat4 CascadesShadowProj[8];
uniform highp mat4 CloudShadowProj;
uniform highp mat4 PlayerShadowProj;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp mat4 PointLightProj;
#endif
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_Normal;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp sampler2D s_PointLightShadowTextureAtlas;
#endif
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp sampler3D s_SkyAmbientSamples;
uniform highp usampler2D s_EmissiveAmbientLinearRoughness;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraAmbientContribution;
uniform highp vec4 CameraIsUnderwater;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadesParameters[8];
uniform highp vec4 CascadesPerSet;
uniform highp vec4 CloudShadowsVisible;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ClusterDepthBounds;
uniform highp vec4 ClusterDimensions;
#endif
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightSourceShadowDirection;
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection;
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ManhattanDistAttenuationEnabled;
#endif
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 NdLFloor;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightNdLFloor;
uniform highp vec4 PointLightPreCalcValues;
uniform highp vec4 PointLightShadowAtlasResolution;
uniform highp vec4 PointLightShadowParams1;
#endif
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkySamplesConfig;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SubPixelOffset;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 UndergroundFogColor;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WorldOrigin;
in highp vec3 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_3785d(inout highp float arg_63999, inout highp vec2 arg_df074) {
    if (SkySamplesConfig.x > 0.5)
    {
        arg_63999 = textureLod(s_SkyAmbientSamples, vec3(arg_df074.x, arg_df074.y, 1.0), 0.0).y;
        return;
    }
    else
    {
        arg_63999 = 1.0;
        return;
    }
}
void func_0b88d(inout highp vec3 arg_3a8bb, inout highp float arg_13db0, inout highp vec4 arg_f7c69, inout highp float arg_7a26d) {
    highp vec4 loc_0024a = PlayerShadowProj * vec4(arg_3a8bb, 1.0);
    highp float loc_fcb6d = clamp(arg_13db0, arg_f7c69.x, 1.0);
    loc_0024a.z -= (CascadesParameters[0].y + (CascadesParameters[0].z * (sqrt(1.0 - (loc_fcb6d * loc_fcb6d)) / loc_fcb6d)));
    loc_0024a.z = min(loc_0024a.z, 1.0);
    int loc_ec55d = (QuantizationParameters.x != 0.0) ? 1 : 2;
    int loc_ed2e2 = loc_ec55d / 2;
    highp vec2 loc_a2590 = ((loc_0024a.xy * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    loc_a2590.y += (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    loc_0024a.z = (loc_0024a.z * 0.5) + 0.5;
    highp vec2 loc_8a24c = loc_a2590;
    highp vec2 loc_76046 = vec2(loc_8a24c.x, 1.0 - loc_8a24c.y);
    bool loc_2c837 = loc_76046.x >= 0.0;
    bool loc_d06e3;
    if (loc_2c837)
    {
        loc_d06e3 = loc_76046.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_d06e3 = loc_2c837;
    }
    bool loc_da85e;
    if (loc_d06e3)
    {
        loc_da85e = loc_76046.y >= 0.0;
    }
    else
    {
        loc_da85e = loc_d06e3;
    }
    bool loc_e80f2;
    if (loc_da85e)
    {
        loc_e80f2 = loc_76046.y < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
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
    highp float loc_51c21 = dot(CascadesPerSet, vec4(1.0)) + 1.0;
    highp float loc_9af5f;
    loc_9af5f = 0.0;
    highp float loc_72f9e;
    for (int loc_467f0 = 0; loc_467f0 < loc_ec55d; loc_9af5f = loc_72f9e, loc_467f0++)
    {
        loc_72f9e = loc_9af5f;
        highp float loc_8daf8;
        for (int loc_02668 = 0; loc_02668 < loc_ec55d; loc_72f9e = loc_8daf8, loc_02668++)
        {
            highp vec2 loc_6d158 = loc_a2590 + ((vec2(float(loc_02668 - loc_ed2e2) + 0.5, float(loc_467f0 - loc_ed2e2) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            highp vec3 loc_f4800 = vec3(loc_6d158.x, loc_6d158.y, loc_51c21);
            if (QuantizationParameters.x != 0.0)
            {
                loc_8daf8 = loc_72f9e + float(textureLod(s_ShadowCascades, loc_f4800, 0.0).x >= loc_0024a.z);
            }
            else
            {
                highp vec4 loc_1f2f1 = step(vec4(loc_0024a.z), textureGather(s_ShadowCascades, loc_f4800));
                highp vec2 loc_127fb = fract((loc_f4800.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_8daf8 = loc_72f9e + mix(mix(loc_1f2f1.w, loc_1f2f1.z, loc_127fb.x), mix(loc_1f2f1.x, loc_1f2f1.y, loc_127fb.x), loc_127fb.y);
            }
        }
    }
    arg_7a26d = loc_9af5f / float(loc_ec55d * loc_ec55d);
}
void func_8b9e3(inout highp float arg_4edfb, inout highp vec3 arg_8d0ce, inout highp vec3 arg_488fe, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_ae81a, inout highp vec3 arg_c7286, inout highp vec2 arg_3e2b4) {
    bool loc_10906 = DirectionalLightSkyLightHeuristicToggles.x != 0.0;
    bool loc_7c329;
    if (loc_10906)
    {
        loc_7c329 = abs(arg_4edfb) < 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_7c329 = loc_10906;
    }
    if (loc_7c329)
    {
        arg_8d0ce = vec3(0.0);
        return;
    }
    highp float loc_3df28;
    if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
    {
        highp float loc_05e4d = max(dot(arg_488fe, normalize((u_view * DirectionalLightSourceShadowDirection).xyz)), 0.0);
        highp vec3 loc_28854 = arg_adf73 + ((arg_c100b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_05e4d, 0.0, 1.0));
        int loc_40b65 = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
        highp float loc_414cb;
        loc_414cb = 1.0;
        int loc_1ffc7;
        highp float loc_077b9;
        for (int loc_018d5 = 0, loc_591f5 = 0; loc_018d5 < loc_40b65; loc_591f5 = loc_1ffc7, loc_414cb = loc_077b9, loc_018d5++)
        {
            int loc_8c1cb = min((loc_591f5 + int(CascadesPerSet[loc_018d5])), 8);
            loc_077b9 = loc_414cb;
            loc_1ffc7 = loc_591f5;
            int loc_0249d;
            highp float loc_849eb;
            for (; loc_1ffc7 < loc_8c1cb; loc_077b9 = loc_849eb, loc_1ffc7 = loc_0249d)
            {
                highp vec4 loc_03329 = CascadesShadowProj[loc_1ffc7] * vec4(loc_28854, 1.0);
                highp vec3 loc_f82b9 = abs(loc_03329.xyz);
                bool loc_54586 = loc_f82b9.x <= 1.0;
                bool loc_d55ba;
                if (loc_54586)
                {
                    loc_d55ba = loc_f82b9.y <= 1.0;
                }
                else
                {
                    loc_d55ba = loc_54586;
                }
                bool loc_18633;
                if (loc_d55ba)
                {
                    loc_18633 = loc_f82b9.z <= 1.0;
                }
                else
                {
                    loc_18633 = loc_d55ba;
                }
                if (loc_18633)
                {
                    highp vec4 loc_9a7eb = loc_03329;
                    highp vec4 loc_49c0e = NdLFloor;
                    highp float loc_34935 = clamp(loc_05e4d, loc_49c0e[loc_1ffc7], 1.0);
                    highp float loc_bac6a = CascadesParameters[loc_1ffc7].y + (CascadesParameters[loc_1ffc7].z * (sqrt(1.0 - (loc_34935 * loc_34935)) / loc_34935));
                    int loc_70c69;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_70c69 = 1;
                    }
                    else
                    {
                        loc_70c69 = clamp(int(CascadesParameters[loc_1ffc7].w + 0.5), 1, 9);
                    }
                    int loc_960ef = loc_70c69 / 2;
                    highp vec2 loc_81ff2 = ((loc_03329.xy * 0.5) + vec2(0.5)) * CascadesParameters[loc_1ffc7].x;
                    highp float loc_6c9d9 = (loc_9a7eb.z * 0.5) + 0.5;
                    loc_81ff2.y += (1.0 - CascadesParameters[loc_1ffc7].x);
                    highp float loc_60326;
                    loc_60326 = 0.0;
                    highp float loc_641ba;
                    for (int loc_d663a = 0; loc_d663a < loc_70c69; loc_60326 = loc_641ba, loc_d663a++)
                    {
                        loc_641ba = loc_60326;
                        highp float loc_106c7;
                        for (int loc_07ee5 = 0; loc_07ee5 < loc_70c69; loc_641ba = loc_106c7, loc_07ee5++)
                        {
                            highp vec2 loc_53530 = loc_81ff2 + ((vec2(float(loc_07ee5 - loc_960ef) + 0.5, float(loc_d663a - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_1ffc7].x);
                            highp vec4 loc_b5d2e = textureGather(s_ShadowCascades, vec3(loc_53530, float(loc_1ffc7)));
                            highp vec4 loc_1e988 = loc_b5d2e;
                            if (QuantizationParameters.x != 0.0)
                            {
                                loc_106c7 = loc_641ba + float(loc_1e988.w >= (loc_6c9d9 - loc_bac6a));
                            }
                            else
                            {
                                highp vec4 loc_6da26 = step(vec4(loc_6c9d9 - loc_bac6a), loc_b5d2e);
                                highp vec2 loc_70d8a = fract((loc_53530 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                loc_106c7 = loc_641ba + mix(mix(loc_6da26.w, loc_6da26.z, loc_70d8a.x), mix(loc_6da26.x, loc_6da26.y, loc_70d8a.x), loc_70d8a.y);
                            }
                        }
                    }
                    loc_849eb = min(loc_077b9, loc_60326 / float(loc_70c69 * loc_70c69));
                    loc_0249d = loc_8c1cb;
                }
                else
                {
                    loc_849eb = loc_077b9;
                    loc_0249d = loc_1ffc7 + 1;
                }
            }
        }
        highp float loc_55d77;
        if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
        {
            highp vec4 loc_a39dc = NdLFloor;
            highp float loc_80bb3;
            func_0b88d(loc_28854, loc_05e4d, loc_a39dc, loc_80bb3);
            loc_55d77 = loc_80bb3;
        }
        else
        {
            loc_55d77 = 1.0;
        }
        bool loc_77735 = int(CloudShadowsVisible.x) > 0;
        bool loc_b7d63;
        if (loc_77735)
        {
            loc_b7d63 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
        }
        else
        {
            loc_b7d63 = loc_77735;
        }
        highp float loc_80289;
        if (loc_b7d63)
        {
            highp vec4 loc_c8015 = NdLFloor;
            highp vec4 loc_8ad63 = CloudShadowProj * vec4(loc_28854, 1.0);
            highp vec4 loc_d3526 = loc_8ad63;
            loc_d3526 = loc_8ad63 / vec4(loc_d3526.w);
            highp float loc_12cc8 = clamp(loc_05e4d, loc_c8015.x, 1.0);
            loc_d3526.z -= ((CascadesParameters[0].y + (CascadesParameters[0].z * (sqrt(1.0 - (loc_12cc8 * loc_12cc8)) / loc_12cc8))) / loc_d3526.w);
            int loc_44da4;
            if (QuantizationParameters.x != 0.0)
            {
                loc_44da4 = 1;
            }
            else
            {
                loc_44da4 = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z + 0.5), 1, 9);
            }
            int loc_15bcb = loc_44da4 / 2;
            highp vec2 loc_38f48 = ((loc_d3526.xy * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
            loc_38f48.y += (1.0 - CascadesParameters[0].x);
            loc_d3526.z = (loc_d3526.z * 0.5) + 0.5;
            highp float loc_0e3bc = dot(CascadesPerSet, vec4(1.0));
            highp float loc_99071;
            loc_99071 = 0.0;
            highp float loc_894a5;
            for (int loc_5837b = 0; loc_5837b < loc_44da4; loc_99071 = loc_894a5, loc_5837b++)
            {
                loc_894a5 = loc_99071;
                highp float loc_003c8;
                for (int loc_e18e2 = 0; loc_e18e2 < loc_44da4; loc_894a5 = loc_003c8, loc_e18e2++)
                {
                    highp vec3 loc_53ff4 = vec3(loc_38f48 + ((vec2(float(loc_e18e2 - loc_15bcb) + 0.5, float(loc_5837b - loc_15bcb) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_0e3bc);
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_003c8 = loc_894a5 + float(textureLod(s_ShadowCascades, loc_53ff4, 0.0).x >= loc_d3526.z);
                    }
                    else
                    {
                        highp vec4 loc_bf06a = step(vec4(loc_d3526.z), textureGather(s_ShadowCascades, loc_53ff4));
                        highp vec2 loc_8d41d = fract((loc_53ff4.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                        loc_003c8 = loc_894a5 + mix(mix(loc_bf06a.w, loc_bf06a.z, loc_8d41d.x), mix(loc_bf06a.x, loc_bf06a.y, loc_8d41d.x), loc_8d41d.y);
                    }
                }
            }
            highp float loc_a9287 = loc_99071 / float(loc_44da4 * loc_44da4);
            highp float loc_1bbb8;
            if (loc_a9287 < 1.0)
            {
                loc_1bbb8 = min(1.0, max(loc_a9287, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
            }
            else
            {
                loc_1bbb8 = 1.0;
            }
            loc_80289 = loc_1bbb8;
        }
        else
        {
            loc_80289 = 1.0;
        }
        loc_3df28 = mix(min(loc_414cb, min(loc_55d77, loc_80289)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_ae81a.z));
    }
    else
    {
        loc_3df28 = 1.0;
    }
    highp vec3 loc_d841a = normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz);
    highp vec4 loc_ef3fc = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp float loc_0d36c = max(dot(arg_488fe, loc_d841a), 0.0);
    highp float loc_d58e5 = max(dot(arg_488fe, arg_c7286), 0.0);
    highp vec3 loc_77b0a = normalize(loc_d841a + arg_c7286);
    highp float loc_3edd2 = max(arg_3e2b4.x, 0.0500000007450580596923828125);
    highp float loc_009bf = loc_3edd2 * loc_3edd2;
    highp float loc_53f89 = loc_009bf * loc_009bf;
    highp float loc_206e3 = max(dot(arg_488fe, loc_77b0a), 0.0);
    highp float loc_fab2f = (((loc_53f89 - 1.0) * loc_206e3) * loc_206e3) + 1.0;
    highp float loc_e1425 = loc_009bf * 0.5;
    highp float loc_bb6db = clamp(1.0 - max(dot(arg_c7286, loc_77b0a), 0.0), 0.0, 1.0);
    highp float loc_9eea3 = loc_bb6db * loc_bb6db;
    arg_8d0ce = (((((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((loc_9eea3 * loc_9eea3) * loc_bb6db))) * (loc_53f89 / ((loc_fab2f * loc_fab2f) * 3.1415927410125732421875))) * ((loc_d58e5 / (((loc_d58e5 * (1.0 - loc_e1425)) + loc_e1425) + 9.9999997473787516355514526367188e-05)) * (loc_0d36c / (((loc_0d36c * (1.0 - loc_e1425)) + loc_e1425) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_0d36c) * loc_d58e5) + 9.9999997473787516355514526367188e-05)) * loc_0d36c) * loc_3df28) * (((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_ef3fc.w) * 1.0) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled.x)) * DiffuseSpecularEmissiveAmbientTermToggles.y;
}
#ifdef POINT_LIGHT_SHADING__ON
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
void func_4e8d4(inout int arg_7070b, inout highp float arg_9499a, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c) {
    if (arg_7070b < 0)
    {
        arg_9499a = 0.0;
        return;
    }
    highp vec3 loc_8868e = arg_aee55 - var_232b7.zLights[arg_7070b].position.xyz;
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
    highp vec4 loc_332aa = var_232b7.zLights[arg_7070b].shadowFaceUV0;
    highp vec3 loc_a2a55;
    if (loc_f3fad == 1)
    {
        loc_332aa = var_232b7.zLights[arg_7070b].shadowFaceUV1;
        loc_a2a55 = vec3(-loc_8a9f7.z, loc_8a9f7.y, loc_8a9f7.x);
    }
    else
    {
        highp vec3 loc_a4212;
        if (loc_f3fad == 2)
        {
            loc_332aa = var_232b7.zLights[arg_7070b].shadowFaceUV2;
            loc_a4212 = vec3(-loc_8a9f7.x, -loc_8a9f7.z, -loc_8a9f7.y);
        }
        else
        {
            highp vec3 loc_38505;
            if (loc_f3fad == 3)
            {
                loc_332aa = var_232b7.zLights[arg_7070b].shadowFaceUV3;
                loc_38505 = vec3(-loc_8a9f7.x, loc_8a9f7.z, loc_8a9f7.y);
            }
            else
            {
                highp vec3 loc_fd3cf;
                if (loc_f3fad == 4)
                {
                    loc_332aa = var_232b7.zLights[arg_7070b].shadowFaceUV4;
                    loc_fd3cf = vec3(-loc_8a9f7.x, loc_8a9f7.y, -loc_8a9f7.z);
                }
                else
                {
                    highp vec3 loc_0c356;
                    if (loc_f3fad == 5)
                    {
                        loc_332aa = var_232b7.zLights[arg_7070b].shadowFaceUV5;
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
        loc_a2a55 = loc_a4212;
    }
    bool loc_da9b7 = loc_332aa.z == 0.0;
    bool loc_20dc6;
    if (loc_da9b7)
    {
        loc_20dc6 = loc_332aa.w == 0.0;
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
    highp vec4 loc_9327f = PointLightProj * vec4(loc_a2a55, 1.0);
    highp float loc_ee959 = clamp(dot(normalize(-loc_8868e), normalize(arg_1111c)), PointLightNdLFloor.x, 1.0);
    loc_9327f.z -= ((PointLightShadowParams1.x + (PointLightShadowParams1.y * (sqrt(1.0 - (loc_ee959 * loc_ee959)) / loc_ee959))) * (PointLightShadowAtlasResolution.z / max((loc_332aa.z - loc_332aa.x) * PointLightShadowAtlasResolution.x, 1.0)));
    highp float loc_d799e = loc_9327f.w;
    highp vec4 loc_9858b = loc_9327f;
    highp vec4 loc_8e487 = loc_9858b / vec4(loc_d799e);
    loc_9327f = loc_8e487;
    highp vec2 loc_81233 = vec2(0.5) / PointLightShadowAtlasResolution.xy;
    highp vec2 loc_4501d = loc_332aa.zw - loc_332aa.xy;
    highp vec2 loc_b2c5a = loc_4501d * PointLightShadowAtlasResolution.xy;
    highp float loc_591c8;
    if (((textureLod(s_PointLightShadowTextureAtlas, clamp(loc_332aa.xy + (((floor(((loc_8e487.xy * 0.5) + vec2(0.5)) * loc_b2c5a) + vec2(0.5)) / loc_b2c5a) * loc_4501d), loc_332aa.xy + loc_81233, loc_332aa.zw - loc_81233), 0.0).x * 2.0) - 1.0) >= loc_9327f.z)
    {
        loc_591c8 = 1.0;
    }
    else
    {
        loc_591c8 = 0.0;
    }
    arg_9499a = loc_591c8;
}
void func_d321c(inout int arg_2f306, inout highp float arg_43b7a, inout highp vec3 arg_0a2b9, inout highp vec3 arg_29ac4, inout highp vec3 arg_ab1f6, inout highp vec3 arg_81f82) {
    if (arg_2f306 < 0)
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp vec3 loc_8dfd7 = var_232b7.zLights[arg_2f306].position.xyz - arg_29ac4;
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
    if (loc_16a27 >= (var_232b7.zLights[arg_2f306].position.w * var_232b7.zLights[arg_2f306].position.w))
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp float loc_a011d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_1b78e;
        func_4e8d4(arg_2f306, loc_1b78e, arg_ab1f6, arg_81f82);
        loc_a011d = loc_1b78e;
    }
    else
    {
        loc_a011d = 1.0;
    }
    highp float loc_4c5a5 = loc_16a27 / ((var_232b7.zLights[arg_2f306].position.w * var_232b7.zLights[arg_2f306].position.w) + 9.9999997473787516355514526367188e-05);
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
    arg_43b7a = loc_a011d;
    arg_0a2b9 = (var_232b7.zLights[arg_2f306].color.xyz * var_232b7.zLights[arg_2f306].color.w) * loc_ae18a;
}
void func_1cb59(inout highp vec3 arg_33c3b, inout highp vec3 arg_534d1, inout highp vec3 arg_c2c08, inout highp vec3 arg_81f79, inout highp vec2 arg_92c2f, inout highp vec3 arg_f6a53, inout highp vec3 arg_4f9dc, inout highp vec3 arg_8bccf) {
    bool loc_a0bb1;
    int loc_79315;
    int loc_822f5;
    func_06412(arg_33c3b, loc_822f5, loc_79315, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    highp vec3 loc_95dc0;
    loc_95dc0 = vec3(0.0);
    highp vec3 loc_e2a66;
    for (int loc_97a60 = loc_79315; loc_97a60 < loc_822f5; loc_95dc0 = loc_e2a66, loc_97a60++)
    {
        int loc_f153e = int(var_d7f5e.zLightLookupArray[loc_97a60].lookup);
        if (loc_f153e < 0)
        {
            break;
        }
        highp vec3 loc_82c7f = normalize((u_view * vec4(var_232b7.zLights[loc_f153e].position.xyz, 1.0)).xyz - arg_33c3b);
        highp float loc_7df00 = max(dot(arg_c2c08, loc_82c7f), 0.0);
        highp float loc_06773 = max(dot(arg_c2c08, arg_81f79), 0.0);
        highp vec3 loc_a125f = normalize(loc_82c7f + arg_81f79);
        highp float loc_69c3d = max(arg_92c2f.x, 0.0500000007450580596923828125);
        highp float loc_a68f1 = loc_69c3d * loc_69c3d;
        highp float loc_64c35 = loc_a68f1 * loc_a68f1;
        highp float loc_cd10e = max(dot(arg_c2c08, loc_a125f), 0.0);
        highp float loc_76800 = (((loc_64c35 - 1.0) * loc_cd10e) * loc_cd10e) + 1.0;
        highp float loc_92cc2 = loc_a68f1 * 0.5;
        highp float loc_c4df4 = clamp(1.0 - max(dot(arg_81f79, loc_a125f), 0.0), 0.0, 1.0);
        highp float loc_ab7db = loc_c4df4 * loc_c4df4;
        highp vec3 loc_e0cda;
        highp float loc_b342e;
        func_d321c(loc_f153e, loc_b342e, loc_e0cda, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_e2a66 = loc_95dc0 + ((((((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((loc_ab7db * loc_ab7db) * loc_c4df4))) * (loc_64c35 / ((loc_76800 * loc_76800) * 3.1415927410125732421875))) * ((loc_06773 / (((loc_06773 * (1.0 - loc_92cc2)) + loc_92cc2) + 9.9999997473787516355514526367188e-05)) * (loc_7df00 / (((loc_7df00 * (1.0 - loc_92cc2)) + loc_92cc2) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_7df00) * loc_06773) + 9.9999997473787516355514526367188e-05)) * loc_7df00) * loc_b342e) * loc_e0cda) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_95dc0;
}
void func_28bd8(inout highp vec3 arg_326b5, inout highp vec3 arg_179c6, inout highp vec3 arg_b40e7, inout highp vec3 arg_4225e, inout highp vec3 arg_4f097, inout highp vec3 arg_9ffae, inout highp vec3 arg_93b0c, inout highp vec2 arg_8115d, inout highp vec3 arg_407d2) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0))
    {
        arg_326b5 = arg_179c6;
        return;
    }
    highp vec3 loc_2eb4f;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_2eb4f = arg_b40e7;
    }
    else
    {
        loc_2eb4f = arg_4225e;
    }
    highp vec3 loc_2a9f6;
    func_1cb59(arg_4f097, loc_2a9f6, arg_9ffae, arg_93b0c, arg_8115d, arg_4225e, loc_2eb4f, arg_407d2);
    arg_326b5 = arg_179c6 + loc_2a9f6;
}
#endif
void func_4efb5(inout highp float arg_592e1, inout highp float arg_38961) {
    highp float loc_c7886;
    if (CameraIsUnderwater.x != 0.0)
    {
        highp float loc_8b429 = 1.7689001560211181640625 * (1.0 - (arg_592e1 * arg_592e1));
        if (loc_8b429 > 1.0)
        {
            arg_38961 = 0.0;
            return;
        }
        loc_c7886 = sqrt(1.0 - loc_8b429);
    }
    else
    {
        loc_c7886 = arg_592e1;
    }
    highp float loc_88258 = clamp(1.0 - loc_c7886, 0.0, 1.0);
    highp float loc_962bf = loc_88258 * loc_88258;
    arg_38961 = 0.980000019073486328125 - (0.980000019073486328125 * ((loc_962bf * loc_962bf) * loc_88258));
}
void main() {
    highp vec4 var_99c96 = texture(s_Normal, v_texcoord0.xy);
    highp vec4 var_11add = texture(s_SceneDepth, v_texcoord0.xy);
    highp float var_b8e9f = (var_11add.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_b8e9f, 1.0);
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
    highp vec4 var_20845 = var_9666f / vec4(var_d799e);
    var_df846 = var_20845;
    highp vec4 var_1c342 = vec4(v_projPosition.xy + vec2(SubPixelOffset.x, -SubPixelOffset.y), var_b8e9f, 1.0);
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
    highp vec3 var_3510f = (u_invView * vec4(var_3ee7d.xyz, 1.0)).xyz - WorldOrigin.xyz;
    highp vec3 var_c6246 = var_3ee7d.xyz;
    highp vec3 var_5b2ee = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_c6246)), normalize(dFdy(var_c6246)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_05eaf = vec3(QuantizationParameters.z * 0.5) - mod(var_3510f, vec3(QuantizationParameters.z));
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_85d40 = (var_3510f + (var_05eaf - (var_5b2ee * dot(var_05eaf, var_5b2ee)))) + WorldOrigin.xyz;
#endif
    highp vec2 var_745cb = var_99c96.xy;
    highp vec3 var_b0cb0 = vec3(var_99c96.xy, (1.0 - abs(var_745cb.x)) - abs(var_745cb.y));
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
    highp vec3 var_0e7a8 = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_d9513 = normalize((u_view * vec4(var_0e7a8, 0.0)).xyz);
    uvec4 var_cd9e5 = texelFetch(s_EmissiveAmbientLinearRoughness, ivec2(vec2(textureSize(s_EmissiveAmbientLinearRoughness, 0)) * v_texcoord0.xy), 0);
    uvec4 var_7d7dd = var_cd9e5;
    uint var_4b676 = var_7d7dd.x & 65535u;
    uvec2 var_49e6b = uvec2(var_4b676 >> 8u, var_4b676 & 255u);
    highp vec2 var_1fc8b = vec2(float(var_49e6b.x), float(var_49e6b.y)) * vec2(0.0039215688593685626983642578125);
    highp float var_c3f2d = float(var_7d7dd.w);
    highp float var_e4742 = var_c3f2d * 0.0039215688593685626983642578125;
    uvec2 var_c02ad = var_cd9e5.yz;
    uint var_39af7 = var_c02ad.x & 65535u;
    uint var_32bfc = var_c02ad.y & 65535u;
    highp vec4 var_4de3a = vec4(uvec4(var_39af7 >> 8u, var_39af7 & 255u, var_32bfc >> 8u, var_32bfc & 255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 var_13aee = var_4de3a;
    highp float var_d7433;
    if (var_b8e9f == 1.0)
    {
        highp vec2 var_5ba1d = v_texcoord0.xy;
        highp float var_ef4d6;
        func_3785d(var_ef4d6, var_5ba1d);
        var_d7433 = var_ef4d6;
    }
    else
    {
        var_d7433 = var_e4742;
    }
    highp vec3 var_cf6e2 = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_67861 = var_20845.xyz;
    highp vec3 var_614bf = -(var_67861 / vec3(length(var_67861) + 9.9999997473787516355514526367188e-05));
    highp vec3 var_cbd15 = var_67861;
    highp vec3 var_cfdac;
    if (int(QuantizationParameters.y) > 0)
    {
#ifdef POINT_LIGHT_SHADING__OFF
        var_cfdac = (var_3510f + (var_05eaf - (var_5b2ee * dot(var_05eaf, var_5b2ee)))) + WorldOrigin.xyz;
#endif
#ifdef POINT_LIGHT_SHADING__ON
        var_cfdac = var_85d40;
#endif
    }
    else
    {
        var_cfdac = var_cf6e2;
    }
    highp vec3 var_bdcf7;
    func_8b9e3(var_e4742, var_bdcf7, var_d9513, var_cfdac, var_0e7a8, var_cbd15, var_614bf, var_1fc8b);
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_66f3b;
    func_28bd8(var_66f3b, var_bdcf7, var_85d40, var_cf6e2, var_67861, var_d9513, var_614bf, var_1fc8b, var_0e7a8);
#endif
    highp float var_37e4f = clamp(((var_c3f2d * 0.062745101749897003173828125) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_45a56 = clamp(1.0 - max(dot(var_614bf, var_d9513), 0.0), 0.0, 1.0);
    highp float var_edda2 = var_45a56 * var_45a56;
    highp vec4 var_e4639 = SkyAmbientLightColorIntensity;
    highp float var_b040e = var_e4742 * var_e4742;
    highp vec3 var_6d83f = normalize(var_cf6e2 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
    bool var_9b186 = AtmosphericScatteringToggles.y != 0.0;
    bool var_2b2d2;
    if (var_9b186)
    {
        var_2b2d2 = AtmosphericScatteringToggles.z != 0.0;
    }
    else
    {
        var_2b2d2 = var_9b186;
    }
    bool var_68aa1;
    if (var_2b2d2)
    {
        var_68aa1 = DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0;
    }
    else
    {
        var_68aa1 = var_2b2d2;
    }
    highp vec3 var_936b4;
    if (var_68aa1)
    {
        highp vec4 var_1a32d = vec4(1.0);
        highp vec4 var_ee7a5 = SkyAmbientLightColorIntensity;
        var_936b4 = max(((vec3(1.0) + (vec3(1.0) * var_1a32d.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_ee7a5.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_936b4 = vec3(0.0);
    }
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_79b3e = clamp((((length(var_67861) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_79b3e > 0.0)
        {
            highp vec3 var_44083;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_44083 = FogColor.xyz * max(var_936b4, vec3(1.0));
            }
            else
            {
                highp vec4 var_a0aa2 = SunColor;
                highp vec4 var_ea036 = MoonColor;
                highp vec3 var_bacde = var_6d83f;
                highp float var_9281d = 1.0 - smoothstep(FogSkyBlend.x - FogSkyBlend.w, FogSkyBlend.z - FogSkyBlend.w, var_bacde.y);
                highp float var_99d92 = dot(var_6d83f, SunDir.xyz);
                highp float var_b6eed = dot(var_6d83f, MoonDir.xyz);
                highp vec3 var_5d345 = var_6d83f;
                highp float var_070ce = 1.0 - smoothstep(FogSkyBlend.x - FogSkyBlend.w, FogSkyBlend.y, var_5d345.y);
                highp float var_824a6 = clamp(pow(max(var_99d92, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_3b3ff = clamp(pow(max(var_b6eed, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_3d1af = 1.809999942779541015625 - (var_824a6 * 1.7999999523162841796875);
                highp float var_db5e0 = 1.809999942779541015625 - (var_3b3ff * 1.7999999523162841796875);
                highp vec3 var_5ec80 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3((var_070ce * var_070ce) * var_070ce)) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_a0aa2.w * (0.75 * ((var_99d92 * var_99d92) + 1.0))) + (var_ea036.w * (0.75 * ((var_b6eed * var_b6eed) + 1.0))))) + (((SkyHorizonColor.xyz * ((var_9281d * var_9281d) * var_9281d)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_a0aa2.w) * AtmosphericScattering.y) * var_824a6) * (0.0361000001430511474609375 / (var_3d1af * sqrt(var_3d1af)))) + ((((MoonColor.xyz * var_ea036.w) * AtmosphericScattering.z) * var_3b3ff) * (0.0361000001430511474609375 / (var_db5e0 * sqrt(var_db5e0))))));
                highp vec3 var_9d0d4;
                if (AtmosphericScatteringToggles.w != 0.0)
                {
                    var_9d0d4 = mix(UndergroundFogColor.xyz, var_5ec80, vec3(max(CameraAmbientContribution.y, var_d7433)));
                }
                else
                {
                    var_9d0d4 = var_5ec80;
                }
                var_44083 = var_9d0d4;
            }
            var_138a7 = var_44083;
        }
        else
        {
            var_138a7 = vec3(0.0);
        }
        var_bdb1d = var_79b3e;
        var_1bb57 = var_138a7;
    }
    else
    {
        var_bdb1d = 0.0;
        var_1bb57 = vec3(0.0);
    }
    highp vec4 var_04d76 = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_2bdb9 = var_04d76;
    highp vec4 var_31066;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_64811 = (vec3(v_projPosition.xy, var_b8e9f).xy + vec2(1.0)) * 0.5;
        highp vec4 var_cf4b5 = u_invProj * vec4(v_projPosition.xy, var_b8e9f, 1.0);
        highp float var_8cf8f = var_64811.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_64811.y, log((53.598148345947265625 * ((((-var_cf4b5.z) / var_cf4b5.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_31066 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_64811.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_64811.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_31066 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_8b3de = var_31066;
#ifdef POINT_LIGHT_SHADING__OFF
    highp vec3 var_b4d5b = mix(((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((var_edda2 * var_edda2) * var_45a56))) * (1.0 - (((var_37e4f * var_37e4f) * var_37e4f) * IBLParameters.x))) * max((((var_4de3a.xyz * var_13aee.w) * 6.0) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_b040e * var_b040e) * var_e4742, (var_e4742 * var_e4742) * var_e4742, CameraLightIntensity.y)) * var_e4639.w), AmbientLightParams.xyz * AmbientLightParams.w)) + var_bdcf7) + (((mix(vec3(0.0), vec3(0.0), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_1fc8b.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_04d76.xyz, vec3(var_2bdb9.w)) * var_8b3de.w;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_b4d5b = mix(((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((var_edda2 * var_edda2) * var_45a56))) * (1.0 - (((var_37e4f * var_37e4f) * var_37e4f) * IBLParameters.x))) * max((((var_4de3a.xyz * var_13aee.w) * 6.0) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_b040e * var_b040e) * var_e4742, (var_e4742 * var_e4742) * var_e4742, CameraLightIntensity.y)) * var_e4639.w), AmbientLightParams.xyz * AmbientLightParams.w)) + var_66f3b) + (((mix(vec3(0.0), vec3(0.0), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_1fc8b.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_04d76.xyz, vec3(var_2bdb9.w)) * var_8b3de.w;
#endif
    highp vec4 var_d0687 = vec4(var_31066.xyz + var_b4d5b, 1.0);
    highp vec4 var_f66c8 = var_d0687;
    highp vec4 var_eea6e;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec3 var_02f69 = var_d0687.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_eea6e = vec4(var_02f69.x, var_02f69.y, var_02f69.z, var_d0687.w);
    }
    else
    {
        var_eea6e = var_d0687;
    }
    var_f66c8 = var_eea6e;
    highp float var_9aa0f = dot(var_614bf, var_d9513);
    highp float var_29ef9;
    func_4efb5(var_9aa0f, var_29ef9);
    var_f66c8.w = 1.0 - var_29ef9;
    bgfx_FragData0 = var_f66c8;
}
