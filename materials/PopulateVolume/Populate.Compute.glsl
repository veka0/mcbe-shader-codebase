#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - POPULATE_PASS (not used)
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
* - layout(binding = 4, std430) buffer s_BiomeInfoBufferBuffer { BiomeInfo s_BiomeInfoBuffer[]; };
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2DArray s_CurrentLightingBuffer;
* - layout(binding = 7, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 8, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_PreviousLightingBuffer;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_ScreenSpaceWaterBackFaceDepthAndNormal;
* - uniform lowp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
*
* Uniforms:
* - uniform vec4 AirAlbedoExtinction;
* - uniform vec4 AmbientContribution;
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BiomeBlendingLastUpdatePosition;
* - uniform vec4 BiomeBlendingParameters;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 CameraUnderwaterAndWaterSurfaceBiasAndFalloff;
* - uniform vec4 CascadeShadowResolutions;
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightExplicitCascadedShadowMapEnabled[2];
* - uniform vec4 DirectionalLightExplicitCascadedShadowMapIndices[2];
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform mat4 DirectionalLightSourceCausticsViewProj[2];
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
* - uniform vec4 DirectionalLightSourceIsSun[2];
* - uniform vec4 DirectionalLightSourceShadowCascadeNumber[2];
* - uniform vec4 DirectionalLightSourceShadowDirection[2];
* - uniform mat4 DirectionalLightSourceShadowInvProj0[2];
* - uniform mat4 DirectionalLightSourceShadowInvProj1[2];
* - uniform mat4 DirectionalLightSourceShadowInvProj2[2];
* - uniform mat4 DirectionalLightSourceShadowInvProj3[2];
* - uniform mat4 DirectionalLightSourceShadowProj0[2];
* - uniform mat4 DirectionalLightSourceShadowProj1[2];
* - uniform mat4 DirectionalLightSourceShadowProj2[2];
* - uniform mat4 DirectionalLightSourceShadowProj3[2];
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
* - uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 HeightFogScaleBias;
* - uniform vec4 HenyeyGreensteinG;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 JitterOffset;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightInvProj;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform mat4 PrevInvProj;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowSlopeBias;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TemporalSettings;
* - uniform vec4 Time;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 VolumeShadowSettings;
* - uniform vec4 WaterAlbedoExtinction;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WorldOrigin;
*/

#extension GL_EXT_texture_cube_map_array : require
#ifdef THREAD_LIMIT__LIMITED_AT128
layout(local_size_x = 8, local_size_y = 8, local_size_z = 2) in;
#endif
#ifdef THREAD_LIMIT__LIMITED_AT256
layout(local_size_x = 8, local_size_y = 8, local_size_z = 4) in;
#endif
#ifdef THREAD_LIMIT__NATIVE
layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;
#endif
struct Light {
    vec4 position;
    vec4 color;
    int shadowProbeIndex;
    int pad0;
    int pad1;
    int pad2;
};

struct LightData {
    float lookup;
};

layout(binding = 8, std430) buffer s_Lights { Light Lights[]; } var_731a5;
layout(binding = 7, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_65cd1;
layout(location = 0, binding = 0, rgba16f) uniform writeonly highp image2DArray s_CurrentLightingBuffer;
uniform highp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
uniform highp sampler2DArray s_PreviousLightingBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
uniform mat4 CloudShadowProj;
uniform mat4 DirectionalLightSourceShadowProj0[2];
uniform mat4 DirectionalLightSourceShadowProj1[2];
uniform mat4 DirectionalLightSourceShadowProj2[2];
uniform mat4 DirectionalLightSourceShadowProj3[2];
uniform mat4 PlayerShadowProj;
uniform mat4 PointLightProj;
uniform mat4 PrevInvProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 AirAlbedoExtinction;
uniform vec4 AmbientContribution;
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform vec4 CameraUnderwaterAndWaterSurfaceBiasAndFalloff;
uniform vec4 CascadeShadowResolutions;
uniform vec4 ClusterDepthBounds;
uniform vec4 ClusterDimensions;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 ClusterSize;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 DirectionalLightExplicitCascadedShadowMapEnabled[2];
uniform vec4 DirectionalLightExplicitCascadedShadowMapIndices[2];
uniform vec4 DirectionalLightSkyLightHeuristicToggles;
uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform vec4 DirectionalLightSourceIsSun[2];
uniform vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform vec4 FogAndDistanceControl;
uniform vec4 HeightFogScaleBias;
uniform vec4 HenyeyGreensteinG;
uniform vec4 JitterOffset;
uniform vec4 ManhattanDistAttenuationEnabled;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 QuantizationParameters;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 ShadowBias;
uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform vec4 ShadowPCFWidth;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 TemporalSettings;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform vec4 VolumeShadowSettings;
uniform vec4 WaterAlbedoExtinction;
uniform vec4 u_prevWorldPosOffset;
int var_e7b23;
void func_41bc4(inout int arg_575b0, inout vec3 arg_6b44c, inout vec4 arg_a2d38, inout int arg_ee338) {
    vec4 loc_e7a06 = DirectionalLightSourceShadowProj0[arg_575b0] * vec4(arg_6b44c, 1.0);
    vec4 loc_88439 = loc_e7a06;
    bool loc_3c9c6 = loc_88439.x >= (-1.0);
    bool loc_b786b;
    if (loc_3c9c6)
    {
        loc_b786b = loc_88439.x <= 1.0;
    }
    else
    {
        loc_b786b = loc_3c9c6;
    }
    bool loc_537c4;
    if (loc_b786b)
    {
        loc_537c4 = loc_88439.y >= (-1.0);
    }
    else
    {
        loc_537c4 = loc_b786b;
    }
    bool loc_32c46;
    if (loc_537c4)
    {
        loc_32c46 = loc_88439.y <= 1.0;
    }
    else
    {
        loc_32c46 = loc_537c4;
    }
    bool loc_88a47;
    if (loc_32c46)
    {
        loc_88a47 = loc_88439.z >= (-1.0);
    }
    else
    {
        loc_88a47 = loc_32c46;
    }
    bool loc_7078d;
    if (loc_88a47)
    {
        loc_7078d = loc_88439.z <= 1.0;
    }
    else
    {
        loc_7078d = loc_88a47;
    }
    if (loc_7078d)
    {
        arg_a2d38 = loc_e7a06;
        arg_ee338 = 0;
        return;
    }
    vec4 loc_4fe51 = DirectionalLightSourceShadowProj1[arg_575b0] * vec4(arg_6b44c, 1.0);
    vec4 loc_bd20d = loc_4fe51;
    bool loc_79540 = loc_bd20d.x >= (-1.0);
    bool loc_60d02;
    if (loc_79540)
    {
        loc_60d02 = loc_bd20d.x <= 1.0;
    }
    else
    {
        loc_60d02 = loc_79540;
    }
    bool loc_db52c;
    if (loc_60d02)
    {
        loc_db52c = loc_bd20d.y >= (-1.0);
    }
    else
    {
        loc_db52c = loc_60d02;
    }
    bool loc_0bf1e;
    if (loc_db52c)
    {
        loc_0bf1e = loc_bd20d.y <= 1.0;
    }
    else
    {
        loc_0bf1e = loc_db52c;
    }
    bool loc_cd494;
    if (loc_0bf1e)
    {
        loc_cd494 = loc_bd20d.z >= (-1.0);
    }
    else
    {
        loc_cd494 = loc_0bf1e;
    }
    bool loc_3b7d6;
    if (loc_cd494)
    {
        loc_3b7d6 = loc_bd20d.z <= 1.0;
    }
    else
    {
        loc_3b7d6 = loc_cd494;
    }
    if (loc_3b7d6)
    {
        arg_a2d38 = loc_4fe51;
        arg_ee338 = 1;
        return;
    }
    vec4 loc_e62b8 = DirectionalLightSourceShadowProj2[arg_575b0] * vec4(arg_6b44c, 1.0);
    vec4 loc_dc87f = loc_e62b8;
    bool loc_540c6 = loc_dc87f.x >= (-1.0);
    bool loc_b8a11;
    if (loc_540c6)
    {
        loc_b8a11 = loc_dc87f.x <= 1.0;
    }
    else
    {
        loc_b8a11 = loc_540c6;
    }
    bool loc_c0490;
    if (loc_b8a11)
    {
        loc_c0490 = loc_dc87f.y >= (-1.0);
    }
    else
    {
        loc_c0490 = loc_b8a11;
    }
    bool loc_ab099;
    if (loc_c0490)
    {
        loc_ab099 = loc_dc87f.y <= 1.0;
    }
    else
    {
        loc_ab099 = loc_c0490;
    }
    bool loc_6a75a;
    if (loc_ab099)
    {
        loc_6a75a = loc_dc87f.z >= (-1.0);
    }
    else
    {
        loc_6a75a = loc_ab099;
    }
    bool loc_6a3da;
    if (loc_6a75a)
    {
        loc_6a3da = loc_dc87f.z <= 1.0;
    }
    else
    {
        loc_6a3da = loc_6a75a;
    }
    if (loc_6a3da)
    {
        arg_a2d38 = loc_e62b8;
        arg_ee338 = 2;
        return;
    }
    vec4 loc_f2f2e = DirectionalLightSourceShadowProj3[arg_575b0] * vec4(arg_6b44c, 1.0);
    vec4 loc_5f6d3 = loc_f2f2e;
    bool loc_319eb = loc_5f6d3.x >= (-1.0);
    bool loc_516c3;
    if (loc_319eb)
    {
        loc_516c3 = loc_5f6d3.x <= 1.0;
    }
    else
    {
        loc_516c3 = loc_319eb;
    }
    bool loc_8ba34;
    if (loc_516c3)
    {
        loc_8ba34 = loc_5f6d3.y >= (-1.0);
    }
    else
    {
        loc_8ba34 = loc_516c3;
    }
    bool loc_ff47d;
    if (loc_8ba34)
    {
        loc_ff47d = loc_5f6d3.y <= 1.0;
    }
    else
    {
        loc_ff47d = loc_8ba34;
    }
    bool loc_0b734;
    if (loc_ff47d)
    {
        loc_0b734 = loc_5f6d3.z >= (-1.0);
    }
    else
    {
        loc_0b734 = loc_ff47d;
    }
    bool loc_0e0bb;
    if (loc_0b734)
    {
        loc_0e0bb = loc_5f6d3.z <= 1.0;
    }
    else
    {
        loc_0e0bb = loc_0b734;
    }
    if (loc_0e0bb)
    {
        arg_a2d38 = loc_f2f2e;
        arg_ee338 = 3;
        return;
    }
    arg_a2d38 = loc_f2f2e;
    arg_ee338 = -1;
}
void func_a62da(inout float arg_5b759, inout int arg_11220, inout float arg_ce9c6) {
    bool loc_7827b = arg_5b759 == 0.0;
    bool loc_1d12d;
    if (loc_7827b)
    {
        loc_1d12d = DirectionalLightExplicitCascadedShadowMapEnabled[arg_11220].x != 0.0;
    }
    else
    {
        loc_1d12d = loc_7827b;
    }
    if (loc_1d12d)
    {
        arg_ce9c6 = DirectionalLightExplicitCascadedShadowMapIndices[arg_11220].x;
        return;
    }
    else
    {
        bool loc_b84d7 = arg_5b759 == 1.0;
        bool loc_41739;
        if (loc_b84d7)
        {
            loc_41739 = DirectionalLightExplicitCascadedShadowMapEnabled[arg_11220].y != 0.0;
        }
        else
        {
            loc_41739 = loc_b84d7;
        }
        if (loc_41739)
        {
            arg_ce9c6 = DirectionalLightExplicitCascadedShadowMapIndices[arg_11220].y;
            return;
        }
        else
        {
            bool loc_2ff3a = arg_5b759 == 2.0;
            bool loc_7eef5;
            if (loc_2ff3a)
            {
                loc_7eef5 = DirectionalLightExplicitCascadedShadowMapEnabled[arg_11220].z != 0.0;
            }
            else
            {
                loc_7eef5 = loc_2ff3a;
            }
            if (loc_7eef5)
            {
                arg_ce9c6 = DirectionalLightExplicitCascadedShadowMapIndices[arg_11220].z;
                return;
            }
            else
            {
                bool loc_6013b = arg_5b759 == 3.0;
                bool loc_035f1;
                if (loc_6013b)
                {
                    loc_035f1 = DirectionalLightExplicitCascadedShadowMapEnabled[arg_11220].w != 0.0;
                }
                else
                {
                    loc_035f1 = loc_6013b;
                }
                if (loc_035f1)
                {
                    arg_ce9c6 = DirectionalLightExplicitCascadedShadowMapIndices[arg_11220].w;
                    return;
                }
            }
        }
    }
    arg_ce9c6 = -1.0;
}
void func_dd822(inout int arg_786f6, inout float arg_7a26d, inout int arg_2c140, inout vec4 arg_ce1c7) {
    if (arg_786f6 < 0)
    {
        arg_7a26d = 1.0;
        return;
    }
    int loc_01130;
    if (QuantizationParameters.x != 0.0)
    {
        loc_01130 = 1;
    }
    else
    {
        loc_01130 = clamp(int((ShadowPCFWidth[arg_2c140] * VolumeShadowSettings.x) + 0.5), 1, 9);
    }
    int loc_2e5db = loc_01130 / 2;
    vec2 loc_ba3e5 = ((vec2(arg_ce1c7.x, arg_ce1c7.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions[arg_2c140];
    float loc_28bbd = (arg_ce1c7.z * 0.5) + 0.5;
    loc_ba3e5.y += (1.0 - CascadeShadowResolutions[arg_2c140]);
    float loc_e55e0;
    loc_e55e0 = 0.0;
    float loc_190ec;
    for (int loc_8d4e1 = 0; loc_8d4e1 < loc_01130; loc_e55e0 = loc_190ec, loc_8d4e1++)
    {
        loc_190ec = loc_e55e0;
        float loc_c9e88;
        for (int loc_6b5d4 = 0; loc_6b5d4 < loc_01130; loc_190ec = loc_c9e88, loc_6b5d4++)
        {
            float loc_60c9c = float(arg_2c140);
            float loc_82d90;
            func_a62da(loc_60c9c, arg_786f6, loc_82d90);
            vec2 loc_c44e4 = loc_ba3e5 + ((vec2(float(loc_6b5d4 - loc_2e5db) + 0.5, float(loc_8d4e1 - loc_2e5db) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadeShadowResolutions[arg_2c140]);
            vec4 loc_5a91a = textureGather(s_ShadowCascades, vec3(loc_c44e4, (float(arg_786f6) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(arg_2c140)));
            if (loc_82d90 >= 0.0)
            {
                vec4 loc_ff407 = textureGather(s_ShadowCascades, vec3(loc_c44e4, (float(arg_786f6) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + loc_82d90));
                vec4 loc_ff79b = loc_ff407;
                if (loc_5a91a.x < loc_ff79b.x)
                {
                    loc_5a91a = loc_ff407;
                }
            }
            if (QuantizationParameters.x != 0.0)
            {
                loc_c9e88 = loc_190ec + float(loc_5a91a.w >= (loc_28bbd - ShadowBias[arg_2c140]));
            }
            else
            {
                vec4 loc_bd102 = step(vec4(loc_28bbd - ShadowBias[arg_2c140]), loc_5a91a);
                vec2 loc_9bf82 = fract((loc_c44e4 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_c9e88 = loc_190ec + mix(mix(loc_bd102.w, loc_bd102.z, loc_9bf82.x), mix(loc_bd102.x, loc_bd102.y, loc_9bf82.x), loc_9bf82.y);
            }
        }
    }
    arg_7a26d = loc_e55e0 / float(loc_01130 * loc_01130);
}
void func_6eb8c(inout vec3 arg_9b0e1, inout float arg_7a26d) {
    vec4 loc_1c259 = PlayerShadowProj * vec4(arg_9b0e1, 1.0);
    loc_1c259.z -= ShadowBias.x;
    loc_1c259.z = min(loc_1c259.z, 1.0);
    vec2 loc_5ae5f = ((vec2(loc_1c259.x, loc_1c259.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
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
    loc_1c259.z = (loc_1c259.z * 0.5) + 0.5;
    loc_5ae5f.y += (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    bool loc_2c837 = loc_5ae5f.x >= 0.0;
    bool loc_d06e3;
    if (loc_2c837)
    {
        loc_d06e3 = loc_5ae5f.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_d06e3 = loc_2c837;
    }
    bool loc_c7ec9;
    if (loc_d06e3)
    {
        loc_c7ec9 = loc_5ae5f.y >= (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    }
    else
    {
        loc_c7ec9 = loc_d06e3;
    }
    bool loc_8e2b9;
    if (loc_c7ec9)
    {
        loc_8e2b9 = loc_5ae5f.y < 1.0;
    }
    else
    {
        loc_8e2b9 = loc_c7ec9;
    }
    if (!loc_8e2b9)
    {
        arg_7a26d = 1.0;
        return;
    }
    float loc_e55e0;
    loc_e55e0 = 0.0;
    float loc_edd8a;
    for (int loc_e3b31 = 0; loc_e3b31 < loc_64b28; loc_e55e0 = loc_edd8a, loc_e3b31++)
    {
        loc_edd8a = loc_e55e0;
        float loc_5e275;
        for (int loc_d3328 = 0; loc_d3328 < loc_64b28; loc_edd8a = loc_5e275, loc_d3328++)
        {
            vec2 loc_9d099 = loc_5ae5f + ((vec2(float(loc_d3328 - loc_a4d0e) + 0.5, float(loc_e3b31 - loc_a4d0e) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            vec3 loc_dc571 = vec3(loc_9d099.x, loc_9d099.y, (DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0) + 1.0);
            if (QuantizationParameters.x != 0.0)
            {
                loc_5e275 = loc_edd8a + float(textureLod(s_ShadowCascades, loc_dc571, 0.0).x >= loc_1c259.z);
            }
            else
            {
                vec4 loc_8954e = step(vec4(loc_1c259.z), textureGather(s_ShadowCascades, loc_dc571));
                vec2 loc_db73a = fract((loc_dc571.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_5e275 = loc_edd8a + mix(mix(loc_8954e.w, loc_8954e.z, loc_db73a.x), mix(loc_8954e.x, loc_8954e.y, loc_db73a.x), loc_db73a.y);
            }
        }
    }
    arg_7a26d = loc_e55e0 / float(loc_64b28 * loc_64b28);
}
void func_57d96(inout float arg_958de, inout vec2 arg_e6843, inout float arg_33edf, inout vec2 arg_410bb, inout vec3 arg_e0671) {
    if (arg_958de < arg_e6843.x)
    {
        arg_33edf = -1.0;
        return;
    }
    bool loc_4e95c = arg_958de >= arg_e6843.x;
    bool loc_6742e;
    if (loc_4e95c)
    {
        loc_6742e = arg_958de <= arg_410bb.x;
    }
    else
    {
        loc_6742e = loc_4e95c;
    }
    if (loc_6742e)
    {
        arg_33edf = 0.0;
        return;
    }
    bool loc_78834 = arg_958de > arg_410bb.x;
    bool loc_c9362;
    if (loc_78834)
    {
        loc_c9362 = arg_958de <= arg_410bb.y;
    }
    else
    {
        loc_c9362 = loc_78834;
    }
    if (loc_c9362)
    {
        arg_33edf = 1.0;
        return;
    }
    arg_33edf = floor((log2(arg_958de / arg_410bb.y) * ((arg_e0671.z - 2.0) / log2(arg_e6843.y / arg_410bb.y))) + 2.0);
}
void func_86391(inout vec3 arg_176e1, inout vec3 arg_580a2, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    float loc_3b38e = -arg_176e1.z;
    vec2 loc_0d359 = arg_580a2.xy;
    vec3 loc_29493 = ClusterDimensions.xyz;
    vec2 loc_69b41 = ClusterNearFarWidthHeight.zw;
    vec2 loc_f1d2d = ClusterSize.xy;
    vec2 loc_2a810 = ClusterNearFarWidthHeight.xy;
    vec2 loc_7d455 = ClusterDepthBounds.xy;
    float loc_3b169;
    func_57d96(loc_3b38e, loc_2a810, loc_3b169, loc_7d455, loc_29493);
    vec3 loc_20923 = vec3(floor((loc_0d359.x * loc_69b41.x) / loc_f1d2d.x), floor((loc_0d359.y * loc_69b41.y) / loc_f1d2d.y), loc_3b169);
    bool loc_ce27d = loc_20923.x < 0.0;
    bool loc_f15a5;
    if (!loc_ce27d)
    {
        loc_f15a5 = loc_20923.y < 0.0;
    }
    else
    {
        loc_f15a5 = loc_ce27d;
    }
    bool loc_7bab6;
    if (!loc_f15a5)
    {
        loc_7bab6 = loc_20923.z < 0.0;
    }
    else
    {
        loc_7bab6 = loc_f15a5;
    }
    bool loc_a526b;
    if (!loc_7bab6)
    {
        loc_a526b = loc_20923.x >= ClusterDimensions.x;
    }
    else
    {
        loc_a526b = loc_7bab6;
    }
    bool loc_6d7c9;
    if (!loc_a526b)
    {
        loc_6d7c9 = loc_20923.y >= ClusterDimensions.y;
    }
    else
    {
        loc_6d7c9 = loc_a526b;
    }
    bool loc_fc058;
    if (!loc_6d7c9)
    {
        loc_fc058 = loc_20923.z >= ClusterDimensions.z;
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
    int loc_14533 = int((loc_20923.x + (loc_20923.y * ClusterDimensions.x)) + ((loc_20923.z * ClusterDimensions.x) * ClusterDimensions.y)) * int(ClusterDimensions.w);
    arg_e45b8 = loc_14533 + int(ClusterDimensions.w);
    arg_fadf1 = loc_14533;
    arg_d7f4c = true;
}
void func_29f2f(inout int arg_0f3c7, inout float arg_9eee0, inout vec3 arg_451b8) {
    if (var_731a5.Lights[arg_0f3c7].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        return;
    }
    vec3 loc_4a72a = arg_451b8 - var_731a5.Lights[arg_0f3c7].position.xyz;
    vec3 loc_0ca8f = abs(loc_4a72a);
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
    vec4 loc_1eba1 = PointLightProj * vec4(loc_0ca8f, 1.0);
    loc_1eba1 /= vec4(loc_1eba1.w);
    vec3 loc_7225b = loc_4a72a;
    bool loc_fe444 = abs(loc_7225b.y) > abs(loc_7225b.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_7225b.y) > abs(loc_7225b.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_7225b.z *= (-1.0);
    }
    else
    {
        loc_7225b.y *= (-1.0);
    }
    float loc_41e57;
    if (((textureLod(s_PointLightShadowTextureArray, vec4(loc_7225b, float(var_731a5.Lights[arg_0f3c7].shadowProbeIndex)), 0.0).x * 2.0) - 1.0) >= loc_1eba1.z)
    {
        loc_41e57 = 1.0;
    }
    else
    {
        loc_41e57 = 0.0;
    }
    arg_9eee0 = loc_41e57;
}
void func_0a991(inout int arg_5a5a2, inout float arg_43b7a, inout vec3 arg_24936, inout vec3 arg_525e6) {
    if (arg_5a5a2 < 0)
    {
        arg_43b7a = 1.0;
        arg_24936 = vec3(0.0);
        return;
    }
    vec3 loc_c75ea = var_731a5.Lights[arg_5a5a2].position.xyz - arg_525e6;
    vec3 loc_757d0 = loc_c75ea;
    float loc_60aa0;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        float loc_fe53a = (abs(loc_757d0.x) + abs(loc_757d0.y)) + abs(loc_757d0.z);
        loc_60aa0 = loc_fe53a * loc_fe53a;
    }
    else
    {
        loc_60aa0 = dot(loc_c75ea, loc_c75ea);
    }
    if (loc_60aa0 >= (var_731a5.Lights[arg_5a5a2].position.w * var_731a5.Lights[arg_5a5a2].position.w))
    {
        arg_43b7a = 1.0;
        arg_24936 = vec3(0.0);
        return;
    }
    float loc_b326d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        float loc_334de;
        func_29f2f(arg_5a5a2, loc_334de, arg_525e6);
        loc_b326d = loc_334de;
    }
    else
    {
        loc_b326d = 1.0;
    }
    float loc_5b0fa = loc_60aa0 / ((var_731a5.Lights[arg_5a5a2].position.w * var_731a5.Lights[arg_5a5a2].position.w) + 9.9999997473787516355514526367188e-05);
    float loc_f4af9 = clamp(1.0 - (loc_5b0fa * loc_5b0fa), 0.0, 1.0);
    float loc_7abdc = (1.0 / max(loc_60aa0, 9.9999997473787516355514526367188e-05)) * (loc_f4af9 * loc_f4af9);
    float loc_67484;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_67484 = loc_7abdc * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_7abdc) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_67484 = loc_7abdc;
    }
    arg_43b7a = loc_b326d;
    arg_24936 = ((var_731a5.Lights[arg_5a5a2].color.xyz * var_731a5.Lights[arg_5a5a2].color.w) * loc_67484) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_ceeb4(inout vec3 arg_dc0ef, inout vec3 arg_96daa, inout vec3 arg_534d1, inout vec3 arg_81f82, inout float arg_369c8, inout vec3 arg_0a773, inout vec3 arg_be743, inout vec3 arg_e7cf5) {
    bool loc_9f3ca;
    int loc_9b40b;
    int loc_fbf40;
    func_86391(arg_dc0ef, arg_96daa, loc_fbf40, loc_9b40b, loc_9f3ca);
    if (!loc_9f3ca)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    vec3 loc_ceaba;
    loc_ceaba = vec3(0.0);
    vec3 loc_3e87e;
    for (int loc_bee0c = loc_9b40b; loc_bee0c < loc_fbf40; loc_ceaba = loc_3e87e, loc_bee0c++)
    {
        int loc_982e0 = int(var_65cd1.LightLookupArray[loc_bee0c].lookup);
        if (loc_982e0 < 0)
        {
            break;
        }
        vec3 loc_102a3;
        float loc_b0161;
        func_0a991(loc_982e0, loc_b0161, loc_102a3, arg_81f82);
        float loc_fc58a = (1.0 + (arg_369c8 * arg_369c8)) + ((2.0 * arg_369c8) * dot(arg_0a773, normalize((u_view * vec4(var_731a5.Lights[loc_982e0].position.xyz, 1.0)).xyz - arg_be743)));
        loc_3e87e = loc_ceaba + (((arg_e7cf5 * ((0.079577468335628509521484375 * (1.0 - (arg_369c8 * arg_369c8))) / (loc_fc58a * sqrt(loc_fc58a)))) * loc_b0161) * loc_102a3);
    }
    arg_534d1 = loc_ceaba;
}
void func_cc693() {
    int loc_b5e48 = int(GlobalInvocationID.x);
    int loc_45941 = int(GlobalInvocationID.y);
    int loc_beae9 = int(GlobalInvocationID.z);
    if (((loc_b5e48 >= int(VolumeDimensions.x)) || (loc_45941 >= int(VolumeDimensions.y))) || (loc_beae9 >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_6e675 = ((vec3(float(loc_b5e48), float(loc_45941), float(loc_beae9)) + vec3(0.5)) + JitterOffset.xyz) / VolumeDimensions.xyz;
    vec3 loc_1fa0b = loc_6e675;
    vec3 loc_777c2 = loc_6e675;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_6e675.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_35d28 = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_35d28;
    vec3 loc_3ced2 = (u_view * vec4(loc_35d28, 1.0)).xyz;
    vec2 loc_04947 = texelFetch(s_ScreenSpaceWaterFrontFaceDepthAndNormal, ivec2(loc_b5e48, loc_45941), 0).xy;
    float loc_e737b = smoothstep(-0.5, 0.5, ((((loc_1fa0b.z - loc_04947.x) * VolumeDimensions.z) * loc_04947.y) - CameraUnderwaterAndWaterSurfaceBiasAndFalloff.y) / CameraUnderwaterAndWaterSurfaceBiasAndFalloff.z);
    float loc_ac022;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_ac022 = 1.0 - loc_e737b;
    }
    else
    {
        loc_ac022 = loc_e737b;
    }
    float loc_305d0 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_4fe0b = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_ac022);
    float loc_1595d = length(loc_3ced2);
    float loc_cc74f = clamp((((loc_1595d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_8d3b7 = mix(mix((AirAlbedoExtinction.xyz * loc_305d0) * AirAlbedoExtinction.w, WaterAlbedoExtinction.xyz * WaterAlbedoExtinction.w, vec3(loc_ac022)), vec3(0.0), vec3(loc_cc74f));
    float loc_cf02a = mix(mix(loc_305d0 * AirAlbedoExtinction.w, WaterAlbedoExtinction.w, loc_ac022), 0.0, loc_cc74f);
    vec3 loc_db03d = ((loc_8d3b7 * 0.079577468335628509521484375) * max(((BlockBaseAmbientLightColorIntensity.xyz * AmbientContribution.x) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * AmbientContribution.y) * SkyAmbientLightColorIntensity.w), vec3(AmbientContribution.z))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    vec3 loc_d517c = -(loc_3ced2 / vec3(loc_1595d));
    bool loc_5b439 = !(DirectionalLightSkyLightHeuristicToggles.y != 0.0);
    bool loc_bc4cf;
    if (!loc_5b439)
    {
        loc_bc4cf = abs(AmbientContribution.y) > 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_bc4cf = loc_5b439;
    }
    vec3 loc_81938;
    if (loc_bc4cf)
    {
        int loc_c08a4 = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
        vec3 loc_b2f11;
        loc_b2f11 = loc_db03d;
        vec3 loc_5860f;
        for (int loc_ddd6b = 0; loc_ddd6b < loc_c08a4; loc_b2f11 = loc_5860f, loc_ddd6b++)
        {
            float loc_e5184;
            if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
            {
                int loc_e65af;
                vec4 loc_8a722;
                func_41bc4(loc_ddd6b, loc_35d28, loc_8a722, loc_e65af);
                vec4 loc_d1f6d = loc_8a722;
                float loc_9d0bb;
                if (loc_e65af != (-1))
                {
                    int loc_c603b = int(DirectionalLightSourceShadowCascadeNumber[loc_ddd6b].x);
                    float loc_53776;
                    func_dd822(loc_c603b, loc_53776, loc_e65af, loc_d1f6d);
                    float loc_33c7f;
                    if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
                    {
                        float loc_0ae52;
                        func_6eb8c(loc_35d28, loc_0ae52);
                        loc_33c7f = min(loc_53776, loc_0ae52);
                    }
                    else
                    {
                        loc_33c7f = loc_53776;
                    }
                    bool loc_e7933 = int(DirectionalLightSourceIsSun[loc_ddd6b].x) > 0;
                    bool loc_35ca5;
                    if (loc_e7933)
                    {
                        loc_35ca5 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
                    }
                    else
                    {
                        loc_35ca5 = loc_e7933;
                    }
                    float loc_67dd6;
                    if (loc_35ca5)
                    {
                        vec4 loc_91a1e = CloudShadowProj * vec4(loc_35d28, 1.0);
                        vec4 loc_57064 = loc_91a1e;
                        loc_57064 = loc_91a1e / vec4(loc_57064.w);
                        loc_57064.z -= (ShadowBias.x / loc_57064.w);
                        vec2 loc_421f7 = ((vec2(loc_57064.x, loc_57064.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions.x;
                        int loc_b80c6;
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_b80c6 = 1;
                        }
                        else
                        {
                            loc_b80c6 = clamp(int((EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * VolumeShadowSettings.x) + 0.5), 1, 9);
                        }
                        int loc_0ef5b = loc_b80c6 / 2;
                        loc_57064.z = (loc_57064.z * 0.5) + 0.5;
                        loc_421f7.y += (1.0 - CascadeShadowResolutions.x);
                        float loc_2c1e1;
                        loc_2c1e1 = 0.0;
                        float loc_7f700;
                        for (int loc_bf1b2 = 0; loc_bf1b2 < loc_b80c6; loc_2c1e1 = loc_7f700, loc_bf1b2++)
                        {
                            loc_7f700 = loc_2c1e1;
                            float loc_13c41;
                            for (int loc_09d40 = 0; loc_09d40 < loc_b80c6; loc_7f700 = loc_13c41, loc_09d40++)
                            {
                                vec3 loc_6703e = vec3(loc_421f7 + ((vec2(float(loc_09d40 - loc_0ef5b) + 0.5, float(loc_bf1b2 - loc_0ef5b) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadeShadowResolutions.x), DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0);
                                if (QuantizationParameters.x != 0.0)
                                {
                                    loc_13c41 = loc_7f700 + float(textureLod(s_ShadowCascades, loc_6703e, 0.0).x >= loc_57064.z);
                                }
                                else
                                {
                                    vec4 loc_12907 = step(vec4(loc_57064.z), textureGather(s_ShadowCascades, loc_6703e));
                                    vec2 loc_b6d05 = fract((loc_6703e.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                    loc_13c41 = loc_7f700 + mix(mix(loc_12907.w, loc_12907.z, loc_b6d05.x), mix(loc_12907.x, loc_12907.y, loc_b6d05.x), loc_b6d05.y);
                                }
                            }
                        }
                        float loc_ecda2 = loc_2c1e1 / float(loc_b80c6 * loc_b80c6);
                        float loc_c6ba0;
                        if (loc_ecda2 < 1.0)
                        {
                            loc_c6ba0 = min(loc_33c7f, max(loc_ecda2, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                        }
                        else
                        {
                            loc_c6ba0 = loc_33c7f;
                        }
                        loc_67dd6 = loc_c6ba0;
                    }
                    else
                    {
                        loc_67dd6 = loc_33c7f;
                    }
                    loc_9d0bb = mix(loc_67dd6, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -0.0));
                }
                else
                {
                    loc_9d0bb = 1.0;
                }
                loc_e5184 = loc_9d0bb;
            }
            else
            {
                loc_e5184 = 1.0;
            }
            float loc_72075 = (1.0 + (loc_4fe0b * loc_4fe0b)) + ((2.0 * loc_4fe0b) * dot(loc_d517c, normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_ddd6b]).xyz)));
            vec4 loc_1ff9f = DirectionalLightSourceDiffuseColorAndIlluminance[loc_ddd6b];
            loc_5860f = loc_b2f11 + (((loc_8d3b7 * loc_e5184) * ((0.079577468335628509521484375 * (1.0 - (loc_4fe0b * loc_4fe0b))) / (loc_72075 * sqrt(loc_72075)))) * (DirectionalLightSourceDiffuseColorAndIlluminance[loc_ddd6b].xyz * loc_1ff9f.w));
        }
        loc_81938 = loc_b2f11;
    }
    else
    {
        loc_81938 = loc_db03d;
    }
    vec3 loc_bf32c = loc_3ced2;
    float loc_8fec4;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        loc_8fec4 = (abs(loc_bf32c.x) + abs(loc_bf32c.y)) + abs(loc_bf32c.z);
    }
    else
    {
        loc_8fec4 = length(loc_3ced2);
    }
    bool loc_6ebf5 = PointLightDiffuseFadeOutParameters.x > 0.0;
    bool loc_49ba4 = !loc_6ebf5;
    bool loc_801c3;
    if (!loc_49ba4)
    {
        loc_801c3 = loc_6ebf5 && (loc_8fec4 < PointLightDiffuseFadeOutParameters.y);
    }
    else
    {
        loc_801c3 = loc_49ba4;
    }
    bool loc_15286 = VolumeScatteringEnabledAndPointLightVolumetricsEnabled.y != 0.0;
    bool loc_586db;
    if (loc_15286)
    {
        loc_586db = DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0;
    }
    else
    {
        loc_586db = loc_15286;
    }
    vec3 loc_0bece;
    if (loc_586db && loc_801c3)
    {
        vec3 loc_2a622 = loc_3ced2;
        vec3 loc_0e452;
        func_ceeb4(loc_2a622, loc_6e675, loc_0e452, loc_35d28, loc_4fe0b, loc_d517c, loc_3ced2, loc_8d3b7);
        loc_0bece = loc_81938 + loc_0e452;
    }
    else
    {
        loc_0bece = loc_81938;
    }
    if (TemporalSettings.x > 0.0)
    {
        vec3 loc_dfafd = (vec3(float(loc_b5e48), float(loc_45941), float(loc_beae9)) + vec3(0.5)) / VolumeDimensions.xyz;
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
        imageStore(s_CurrentLightingBuffer, ivec3(loc_b5e48, loc_45941, loc_beae9), mix(vec4(loc_0bece, loc_cf02a), mix(textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80)), 0.0), textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80 + 1)), 0.0), vec4(clamp(loc_53f43 - float(loc_25a80), 0.0, 1.0))), vec4(mix(TemporalSettings.z, 0.0, clamp(length(clamp(loc_34735, vec3(0.0), vec3(loc_dbdb4)) - loc_34735) * TemporalSettings.y, 0.0, 1.0)))));
    }
    else
    {
        imageStore(s_CurrentLightingBuffer, ivec3(loc_b5e48, loc_45941, loc_beae9), vec4(loc_0bece, loc_cf02a));
    }
}
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    func_cc693();
}
