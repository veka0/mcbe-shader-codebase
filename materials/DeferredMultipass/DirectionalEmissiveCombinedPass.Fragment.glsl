#version 310 es

/*
* Available Macros:
*
* Passes:
* - ATMOSPHERICS_PASS (not used)
* - DIRECTIONAL_EMISSIVE_COMBINED_PASS (not used)
* - DISCRETE_INDIRECT_COMBINED_PASS (not used)
* - FALLBACK_PASS (not used)
* - VOLUMETRIC_SCATTERING_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
* - uniform lowp sampler2D s_Normal;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - layout(binding = 10, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 11, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 12, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BiomeBlendingLastUpdatePosition;
* - uniform vec4 BiomeBlendingParameters;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
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
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform mat4 DirectionalLightSourceCausticsViewProj[2];
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
* - uniform vec4 DirectionalLightSourceShadowDirection[2];
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
* - uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 Time;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WaterSurfaceEnabled;
* - uniform vec4 WaterSurfaceOctaveParameters;
* - uniform vec4 WaterSurfaceParameters;
* - uniform vec4 WaterSurfaceWaveParameters;
* - uniform vec4 WorldOrigin;
*/

precision mediump float;
precision highp int;
uniform highp mat4 CascadesShadowInvProj[8];
uniform highp mat4 CascadesShadowProj[8];
uniform highp mat4 CloudShadowProj;
uniform highp mat4 DirectionalLightSourceCausticsViewProj[2];
uniform highp mat4 PlayerShadowProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_EmissiveAmbientLinearRoughness;
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2DArray s_CausticsTexture;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp vec4 CascadesParameters[8];
uniform highp vec4 CascadesPerSet;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
uniform highp vec4 CloudShadowsVisible;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform highp vec4 DirectionalLightSourceShadowDirection[2];
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform highp vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 NdLFloor;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform highp vec4 SubPixelOffset;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 Time;
uniform highp vec4 WaterSurfaceOctaveParameters;
uniform highp vec4 WaterSurfaceParameters;
uniform highp vec4 WaterSurfaceWaveParameters;
uniform highp vec4 WorldOrigin;
in highp vec3 v_projPosition;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
mat4 var_9796c;
void func_17084(inout highp vec4 arg_c59ed, inout int arg_a0aa6, inout highp vec3 arg_0d628, inout highp mat4 arg_d64be, inout bool arg_5e3ed, inout highp mat4 arg_4ee81) {
    arg_c59ed = CascadesShadowProj[arg_a0aa6] * vec4(arg_0d628, 1.0);
    highp vec4 loc_108af = arg_c59ed;
    bool loc_3c9c6 = loc_108af.x >= (-1.0);
    bool loc_b786b;
    if (loc_3c9c6)
    {
        loc_b786b = loc_108af.x <= 1.0;
    }
    else
    {
        loc_b786b = loc_3c9c6;
    }
    bool loc_537c4;
    if (loc_b786b)
    {
        loc_537c4 = loc_108af.y >= (-1.0);
    }
    else
    {
        loc_537c4 = loc_b786b;
    }
    bool loc_32c46;
    if (loc_537c4)
    {
        loc_32c46 = loc_108af.y <= 1.0;
    }
    else
    {
        loc_32c46 = loc_537c4;
    }
    bool loc_88a47;
    if (loc_32c46)
    {
        loc_88a47 = loc_108af.z >= (-1.0);
    }
    else
    {
        loc_88a47 = loc_32c46;
    }
    bool loc_7078d;
    if (loc_88a47)
    {
        loc_7078d = loc_108af.z <= 1.0;
    }
    else
    {
        loc_7078d = loc_88a47;
    }
    if (loc_7078d)
    {
        arg_d64be = CascadesShadowInvProj[arg_a0aa6];
        arg_5e3ed = true;
        return;
    }
    arg_d64be = arg_4ee81;
    arg_5e3ed = false;
}
void func_59bf3(inout highp vec3 arg_3a8bb, inout highp float arg_13db0, inout highp vec4 arg_f7c69, inout highp float arg_7a26d) {
    highp vec4 loc_90e3d = PlayerShadowProj * vec4(arg_3a8bb, 1.0);
    highp float loc_fcb6d = clamp(arg_13db0, arg_f7c69.x, 1.0);
    loc_90e3d.z -= (CascadesParameters[0].y + (CascadesParameters[0].z * (sqrt(1.0 - (loc_fcb6d * loc_fcb6d)) / loc_fcb6d)));
    loc_90e3d.z = min(loc_90e3d.z, 1.0);
    highp vec2 loc_f9579 = ((vec2(loc_90e3d.x, loc_90e3d.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    int loc_ec55d = (QuantizationParameters.x != 0.0) ? 1 : 2;
    int loc_ed2e2 = loc_ec55d / 2;
    loc_90e3d.z = (loc_90e3d.z * 0.5) + 0.5;
    loc_f9579.y += (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    bool loc_2c837 = loc_f9579.x >= 0.0;
    bool loc_d06e3;
    if (loc_2c837)
    {
        loc_d06e3 = loc_f9579.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_d06e3 = loc_2c837;
    }
    bool loc_c7ec9;
    if (loc_d06e3)
    {
        loc_c7ec9 = loc_f9579.y >= (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    }
    else
    {
        loc_c7ec9 = loc_d06e3;
    }
    bool loc_8e2b9;
    if (loc_c7ec9)
    {
        loc_8e2b9 = loc_f9579.y < 1.0;
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
            highp vec2 loc_6d158 = loc_f9579 + ((vec2(float(loc_02668 - loc_ed2e2) + 0.5, float(loc_467f0 - loc_ed2e2) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            highp vec3 loc_f4800 = vec3(loc_6d158.x, loc_6d158.y, loc_51c21);
            if (QuantizationParameters.x != 0.0)
            {
                loc_8daf8 = loc_72f9e + float(textureLod(s_ShadowCascades, loc_f4800, 0.0).x >= loc_90e3d.z);
            }
            else
            {
                highp vec4 loc_1f2f1 = step(vec4(loc_90e3d.z), textureGather(s_ShadowCascades, loc_f4800));
                highp vec2 loc_127fb = fract((loc_f4800.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_8daf8 = loc_72f9e + mix(mix(loc_1f2f1.w, loc_1f2f1.z, loc_127fb.x), mix(loc_1f2f1.x, loc_1f2f1.y, loc_127fb.x), loc_127fb.y);
            }
        }
    }
    arg_7a26d = loc_9af5f / float(loc_ec55d * loc_ec55d);
}
void func_42001(inout highp vec4 arg_3156b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec3 arg_218ea, inout highp vec3 arg_016ce, inout highp vec3 arg_68e47, inout highp vec3 arg_a9fca, inout highp vec2 arg_f36e7, inout highp vec3 arg_81f79, inout highp vec3 arg_58ffc, inout highp vec3 arg_cff01, inout highp float arg_5416d, inout highp float arg_cdb42) {
    bool loc_10906 = DirectionalLightSkyLightHeuristicToggles.x != 0.0;
    bool loc_d0d08;
    if (loc_10906)
    {
        loc_d0d08 = abs(arg_3156b.z) < 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_d0d08 = loc_10906;
    }
    if (loc_d0d08)
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        return;
    }
    int loc_29e34 = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    highp vec3 loc_7d7d3;
    highp vec3 loc_6ee08;
    highp mat4 loc_a7108;
    loc_6ee08 = vec3(0.0);
    loc_7d7d3 = vec3(0.0);
    loc_a7108 = var_9796c;
    highp vec3 loc_fde0c;
    highp vec3 loc_f20d9;
    highp mat4 loc_f3340;
    for (int loc_0c559 = 0; loc_0c559 < loc_29e34; loc_6ee08 = loc_f20d9, loc_7d7d3 = loc_fde0c, loc_0c559++, loc_a7108 = loc_f3340)
    {
        highp float loc_c6386;
        highp float loc_a416a;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            highp float loc_29bbf = max(dot(arg_218ea, normalize((u_view * DirectionalLightSourceShadowDirection[loc_0c559]).xyz)), 0.0);
            highp vec4 loc_25c1d = NdLFloor;
            highp vec3 loc_f94a5 = arg_016ce + ((arg_68e47 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_29bbf, 0.0, 1.0));
            highp float loc_68750;
            highp float loc_cb15a;
            highp mat4 loc_6ca81;
            loc_6ca81 = loc_a7108;
            loc_cb15a = 1.0;
            loc_68750 = 1.0;
            int loc_e55e8;
            highp float loc_5ebc8;
            highp float loc_6f625;
            highp mat4 loc_fdd84;
            for (int loc_7a536 = 0, loc_6ddca = 0; loc_7a536 < 4; loc_6ca81 = loc_fdd84, loc_6ddca = loc_e55e8, loc_cb15a = loc_6f625, loc_68750 = loc_5ebc8, loc_7a536++)
            {
                int loc_39b80 = int(CascadesPerSet[loc_7a536]);
                highp mat4 loc_7f87f;
                loc_7f87f = loc_6ca81;
                highp mat4 loc_e1f5c;
                for (int loc_cca25 = 0; loc_cca25 < loc_39b80; loc_7f87f = loc_e1f5c, loc_cca25++)
                {
                    int loc_7b6c0 = loc_6ddca + loc_cca25;
                    if (loc_7b6c0 >= 8)
                    {
                        loc_fdd84 = loc_7f87f;
                        loc_6f625 = loc_cb15a;
                        loc_5ebc8 = loc_68750;
                        break;
                    }
                    highp vec4 loc_0a9a7;
                    bool loc_3ffa4;
                    func_17084(loc_0a9a7, loc_7b6c0, loc_f94a5, loc_e1f5c, loc_3ffa4, loc_7f87f);
                    highp vec4 loc_569e5 = loc_0a9a7;
                    if (!loc_3ffa4)
                    {
                        continue;
                    }
                    highp float loc_34935 = clamp(loc_29bbf, loc_25c1d[loc_7b6c0], 1.0);
                    highp float loc_bac6a = CascadesParameters[loc_7b6c0].y + (CascadesParameters[loc_7b6c0].z * (sqrt(1.0 - (loc_34935 * loc_34935)) / loc_34935));
                    highp float loc_1699c = SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z * length(loc_e1f5c * vec4(0.0, 0.0, 1.0, 0.0));
                    int loc_98038;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_98038 = 1;
                    }
                    else
                    {
                        loc_98038 = clamp(int(CascadesParameters[loc_7b6c0].w + 0.5), 1, 9);
                    }
                    int loc_960ef = loc_98038 / 2;
                    highp vec2 loc_63e61 = ((vec2(loc_569e5.x, loc_569e5.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_7b6c0].x;
                    highp float loc_7263a = (loc_569e5.z * 0.5) + 0.5;
                    loc_63e61.y += (1.0 - CascadesParameters[loc_7b6c0].x);
                    highp float loc_94392;
                    highp float loc_89b67;
                    loc_89b67 = 0.0;
                    loc_94392 = 0.0;
                    highp float loc_bb531;
                    highp float loc_c824b;
                    for (int loc_8ad4e = 0; loc_8ad4e < loc_98038; loc_89b67 = loc_c824b, loc_94392 = loc_bb531, loc_8ad4e++)
                    {
                        loc_c824b = loc_89b67;
                        loc_bb531 = loc_94392;
                        highp float loc_8794a;
                        highp float loc_befb6;
                        for (int loc_6a5e1 = 0; loc_6a5e1 < loc_98038; loc_c824b = loc_befb6, loc_bb531 = loc_8794a, loc_6a5e1++)
                        {
                            highp vec2 loc_3cc8b = loc_63e61 + ((vec2(float(loc_6a5e1 - loc_960ef) + 0.5, float(loc_8ad4e - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_7b6c0].x);
                            highp vec4 loc_0c1b5 = textureGather(s_ShadowCascades, vec3(loc_3cc8b, float(loc_7b6c0)));
                            highp vec4 loc_1e988 = loc_0c1b5;
                            highp vec2 loc_89c3c = fract((loc_3cc8b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            highp vec4 loc_0edfa = vec4(1.0) - smoothstep(vec4(0.0), vec4(1.0), (vec4(loc_7263a) - loc_0c1b5) * loc_1699c);
                            highp vec2 loc_df6bc = loc_89c3c;
                            loc_8794a = loc_bb531 + mix(mix(loc_0edfa.w, loc_0edfa.z, loc_df6bc.x), mix(loc_0edfa.x, loc_0edfa.y, loc_df6bc.x), loc_df6bc.y);
                            if (QuantizationParameters.x != 0.0)
                            {
                                loc_befb6 = loc_c824b + float(loc_1e988.w >= (loc_7263a - loc_bac6a));
                            }
                            else
                            {
                                highp vec4 loc_6da26 = step(vec4(loc_7263a - loc_bac6a), loc_0c1b5);
                                highp vec2 loc_4ce21 = loc_89c3c;
                                loc_befb6 = loc_c824b + mix(mix(loc_6da26.w, loc_6da26.z, loc_4ce21.x), mix(loc_6da26.x, loc_6da26.y, loc_4ce21.x), loc_4ce21.y);
                            }
                        }
                    }
                    loc_fdd84 = loc_e1f5c;
                    loc_6f625 = min(loc_cb15a, loc_94392 / float(loc_98038 * loc_98038));
                    loc_5ebc8 = min(loc_68750, loc_89b67 / float(loc_98038 * loc_98038));
                    break;
                }
                loc_e55e8 = loc_6ddca + loc_39b80;
            }
            highp float loc_2c1f0;
            if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
            {
                highp vec4 loc_ebb95 = NdLFloor;
                highp float loc_a7053;
                func_59bf3(loc_f94a5, loc_29bbf, loc_ebb95, loc_a7053);
                loc_2c1f0 = min(loc_68750, loc_a7053);
            }
            else
            {
                loc_2c1f0 = loc_68750;
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
            highp float loc_70c88;
            if (loc_b7807)
            {
                highp vec4 loc_87693 = NdLFloor;
                highp vec4 loc_d4de6 = CloudShadowProj * vec4(loc_f94a5, 1.0);
                highp vec4 loc_dec83 = loc_d4de6;
                loc_dec83 = loc_d4de6 / vec4(loc_dec83.w);
                highp float loc_94797 = clamp(loc_29bbf, loc_87693.x, 1.0);
                loc_dec83.z -= ((CascadesParameters[0].y + (CascadesParameters[0].z * (sqrt(1.0 - (loc_94797 * loc_94797)) / loc_94797))) / loc_dec83.w);
                highp vec2 loc_54a33 = ((vec2(loc_dec83.x, loc_dec83.y) * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
                int loc_4504c;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_4504c = 1;
                }
                else
                {
                    loc_4504c = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z + 0.5), 1, 9);
                }
                int loc_64293 = loc_4504c / 2;
                loc_dec83.z = (loc_dec83.z * 0.5) + 0.5;
                loc_54a33.y += (1.0 - CascadesParameters[0].x);
                highp float loc_f538a = dot(CascadesPerSet, vec4(1.0));
                highp float loc_39767;
                loc_39767 = 0.0;
                highp float loc_90c45;
                for (int loc_9c272 = 0; loc_9c272 < loc_4504c; loc_39767 = loc_90c45, loc_9c272++)
                {
                    loc_90c45 = loc_39767;
                    highp float loc_88f9d;
                    for (int loc_a8e1a = 0; loc_a8e1a < loc_4504c; loc_90c45 = loc_88f9d, loc_a8e1a++)
                    {
                        highp vec3 loc_8bcb2 = vec3(loc_54a33 + ((vec2(float(loc_a8e1a - loc_64293) + 0.5, float(loc_9c272 - loc_64293) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_f538a);
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_88f9d = loc_90c45 + float(textureLod(s_ShadowCascades, loc_8bcb2, 0.0).x >= loc_dec83.z);
                        }
                        else
                        {
                            highp vec4 loc_6717d = step(vec4(loc_dec83.z), textureGather(s_ShadowCascades, loc_8bcb2));
                            highp vec2 loc_d9651 = fract((loc_8bcb2.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            loc_88f9d = loc_90c45 + mix(mix(loc_6717d.w, loc_6717d.z, loc_d9651.x), mix(loc_6717d.x, loc_6717d.y, loc_d9651.x), loc_d9651.y);
                        }
                    }
                }
                highp float loc_b85fb = loc_39767 / float(loc_4504c * loc_4504c);
                highp float loc_5d6fc;
                if (loc_b85fb < 1.0)
                {
                    loc_5d6fc = min(loc_2c1f0, max(loc_b85fb, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                }
                else
                {
                    loc_5d6fc = loc_2c1f0;
                }
                loc_70c88 = loc_5d6fc;
            }
            else
            {
                loc_70c88 = loc_2c1f0;
            }
            loc_f3340 = loc_6ca81;
            loc_a416a = loc_cb15a;
            loc_c6386 = mix(loc_70c88, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_a9fca.z));
        }
        else
        {
            loc_f3340 = loc_a7108;
            loc_a416a = 1.0;
            loc_c6386 = 1.0;
        }
        highp vec3 loc_921fd = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_0c559]).xyz);
        highp vec4 loc_fe4ce = DirectionalLightSourceDiffuseColorAndIlluminance[loc_0c559];
        highp vec3 loc_49071 = ((DirectionalLightSourceDiffuseColorAndIlluminance[loc_0c559].xyz * loc_fe4ce.w) * arg_f36e7[loc_0c559]) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
        highp float loc_1e1bf = max(dot(arg_218ea, loc_921fd), 0.0);
        highp float loc_af6fd = max(dot(arg_218ea, arg_81f79), 0.0);
        highp float loc_2d61b = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp float loc_c20a0 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp vec3 loc_a125f = normalize(loc_921fd + arg_81f79);
        highp float loc_df5d9 = max(arg_3156b.w, 0.0500000007450580596923828125);
        highp float loc_a68f1 = loc_df5d9 * loc_df5d9;
        highp float loc_ad517 = loc_a68f1 * loc_a68f1;
        highp float loc_cd10e = max(dot(arg_218ea, loc_a125f), 0.0);
        highp float loc_6be3a = (((loc_ad517 - 1.0) * loc_cd10e) * loc_cd10e) + 1.0;
        highp float loc_ad7fb = loc_a68f1 * 0.5;
        highp float loc_00ee9 = clamp(1.0 - max(dot(arg_81f79, loc_a125f), 0.0), 0.0, 1.0);
        highp float loc_a177b = loc_00ee9 * loc_00ee9;
        highp vec3 loc_d5257 = arg_58ffc + ((vec3(1.0) - arg_58ffc) * ((loc_a177b * loc_a177b) * loc_00ee9));
        highp vec3 loc_b92e1 = arg_cff01 * (1.0 - arg_5416d);
        loc_fde0c = loc_7d7d3 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_218ea, loc_921fd) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_cdb42)) * (loc_b92e1 * vec3(0.3183098733425140380859375))) * loc_c6386) + (((loc_b92e1 * vec3(0.3183098733425140380859375)) * (arg_cdb42 * max((dot(-arg_218ea, loc_921fd) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_a416a)) * loc_49071) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_f20d9 = loc_6ee08 + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_c6386) * loc_49071) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_7d7d3;
    arg_90b60 = loc_6ee08;
}
void main() {
    highp vec4 var_158bd = texture(s_Normal, v_texcoord0);
    highp vec4 var_d6549 = texture(s_SceneDepth, v_texcoord0);
    highp float var_88b76 = (var_d6549.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_88b76, 1.0);
    highp mat4 var_3460a = u_invProj;
    highp float var_eb413 = var_df846.x;
    highp float var_ac116 = var_df846.y;
    highp float var_f2b7c = var_df846.w;
    highp float var_0357c = var_df846.z;
    highp float var_2c821 = var_df846.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_3460a[0].x, var_ac116 * var_3460a[1].y, var_f2b7c * var_3460a[3].z, (var_0357c * var_3460a[2].w) + (var_2c821 * var_3460a[3].w));
    var_df846 = var_9666f;
    highp float var_d799e = var_df846.w;
    highp vec4 var_20845 = var_9666f / vec4(var_d799e);
    var_df846 = var_20845;
    highp vec4 var_1c342 = vec4(v_projPosition.xy + vec2(SubPixelOffset.x, -SubPixelOffset.y), var_88b76, 1.0);
    highp mat4 var_3ebcc = u_invProj;
    highp float var_a6256 = var_1c342.x;
    highp float var_05401 = var_1c342.y;
    highp float var_b8669 = var_1c342.w;
    highp float var_259fc = var_1c342.z;
    highp float var_f8db3 = var_1c342.w;
    highp vec4 var_fa2eb = vec4(var_a6256 * var_3ebcc[0].x, var_05401 * var_3ebcc[1].y, var_b8669 * var_3ebcc[3].z, (var_259fc * var_3ebcc[2].w) + (var_f8db3 * var_3ebcc[3].w));
    var_1c342 = var_fa2eb;
    highp float var_f7138 = var_1c342.w;
    highp vec4 var_3ee7d = var_fa2eb / vec4(var_f7138);
    var_1c342 = var_3ee7d;
    highp vec3 var_d5564 = (u_invView * vec4(var_3ee7d.xyz, 1.0)).xyz - WorldOrigin.xyz;
    highp vec3 var_e3d8f = var_3ee7d.xyz;
    highp vec3 var_eebcb = dFdx(var_e3d8f);
    highp vec3 var_211c8 = dFdy(var_e3d8f);
    highp vec3 var_61c47 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(var_eebcb), normalize(var_211c8))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_fc769 = mod(var_d5564, vec3(QuantizationParameters.z));
    highp vec2 var_745cb = var_158bd.xy;
    highp vec3 var_b0cb0 = vec3(var_158bd.xy, (1.0 - abs(var_745cb.x)) - abs(var_745cb.y));
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
    highp vec3 var_effba = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_b9e03 = normalize((u_view * vec4(var_effba, 0.0)).xyz);
    highp vec4 var_124e5 = texture(s_ColorMetalnessSubsurface, v_texcoord0);
    highp vec4 var_4ac0e = var_124e5;
    highp float var_9c3c2 = clamp(2.007874011993408203125 * (var_4ac0e.w - 0.501960813999176025390625), 0.0, 1.0);
    highp vec4 var_8c5b7 = texture(s_EmissiveAmbientLinearRoughness, v_texcoord0);
    highp vec3 var_09a52 = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_54046 = var_20845.xyz;
    highp vec3 var_000c6 = pow(max(var_124e5.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
    highp vec3 var_5d51a = vec3(0.039999999105930328369140625 * (1.0 - var_9c3c2)) + (var_000c6 * var_9c3c2);
    bool var_ff669 = CausticsParameters.x != 0.0;
    bool var_94c07;
    if (var_ff669)
    {
        var_94c07 = CausticsParameters.w != 0.0;
    }
    else
    {
        var_94c07 = var_ff669;
    }
    highp float var_30c68;
    if (var_94c07)
    {
        highp vec4 var_1195d = DirectionalLightSourceCausticsViewProj[0] * vec4(var_09a52 - WorldOrigin.xyz, 1.0);
        highp vec4 var_3ab6f = var_1195d;
        highp vec3 var_08d24 = var_1195d.xyz / vec3(var_3ab6f.w);
        var_08d24.y *= (-1.0);
        highp vec2 var_a8b6a = (var_08d24.xy + vec2(1.0)) * 0.5;
        highp float var_236dd = var_a8b6a.x;
        highp float var_44bd7 = var_a8b6a.y;
        highp vec2 var_3a399 = vec2(var_236dd, 1.0 - var_44bd7);
        var_a8b6a = var_3a399;
        highp vec2 var_e259e = var_3a399 * CausticsParameters.y;
        highp float var_057f4;
        if (CausticsTextureParameters.x != 0.0)
        {
            highp float var_3e5be = var_e259e.x;
            highp float var_31a58 = var_e259e.x;
            highp float var_13623 = var_3e5be - floor(var_31a58);
            highp float var_891d4 = var_e259e.y;
            highp float var_ae62a = var_e259e.y;
            highp float var_4a595 = var_891d4 - floor(var_ae62a);
            var_e259e = vec2(var_13623, var_4a595);
            var_057f4 = texture(s_CausticsTexture, vec3(var_13623, var_4a595, CausticsTextureParameters.y)).x * 2.0;
        }
        else
        {
            highp float var_174a2;
            highp float var_46142;
            highp vec2 var_fb2a7;
            var_fb2a7 = var_e259e;
            var_46142 = 0.0;
            var_174a2 = 0.0;
            highp float var_de54f;
            highp float var_bf353;
            highp vec2 var_1d4c8;
            highp float var_82b5f;
            highp float var_eb337;
            highp float var_4a4e9;
            highp float var_67f3a;
            uint var_194f1 = 0u;
            highp float var_66997 = 0.0;
            highp float var_5e4f2 = WaterSurfaceWaveParameters.x;
            highp float var_33211 = WaterSurfaceParameters.x;
            highp float var_a89f8 = 1.0;
            for (; var_194f1 < uint(WaterSurfaceParameters.y); var_a89f8 = var_82b5f, var_33211 = var_eb337, var_fb2a7 = var_1d4c8, var_5e4f2 = var_4a4e9, var_66997 = var_67f3a, var_46142 = var_bf353, var_174a2 = var_de54f, var_194f1++)
            {
                highp vec2 var_3bb7b = vec2(sin(var_66997), cos(var_66997));
                highp float var_88bb1 = (dot(var_3bb7b, var_fb2a7) * var_33211) + (Time.x * var_5e4f2);
                highp float var_3b02d = pow((sin(var_88bb1) + 1.0) * 0.5, WaterSurfaceWaveParameters.y);
                highp vec2 var_88aa7 = vec2(var_3b02d, (var_3b02d * cos(var_88bb1)) * (-1.0));
                var_de54f = var_174a2 + (var_88aa7.x * var_a89f8);
                var_bf353 = var_46142 + var_a89f8;
                var_1d4c8 = var_fb2a7 + (((var_3bb7b * var_88aa7.y) * var_a89f8) * WaterSurfaceOctaveParameters.x);
                var_82b5f = mix(var_a89f8, 0.0, WaterSurfaceOctaveParameters.y);
                var_eb337 = var_33211 * WaterSurfaceOctaveParameters.z;
                var_4a4e9 = var_5e4f2 * WaterSurfaceOctaveParameters.w;
                var_67f3a = var_66997 + 1.39900004863739013671875;
            }
            var_057f4 = var_174a2 / var_46142;
        }
        var_30c68 = pow(var_057f4, float(int(CausticsParameters.z))) * float(int(CausticsParameters.z) + 1);
    }
    else
    {
        var_30c68 = 1.0;
    }
    bool var_7744c = CausticsParameters.x != 0.0;
    bool var_abeb3;
    if (var_7744c)
    {
        var_abeb3 = CausticsParameters.w != 0.0;
    }
    else
    {
        var_abeb3 = var_7744c;
    }
    highp float var_ba9ef;
    if (var_abeb3)
    {
        highp vec4 var_1108d = DirectionalLightSourceCausticsViewProj[1] * vec4(var_09a52 - WorldOrigin.xyz, 1.0);
        highp vec4 var_a7f50 = var_1108d;
        highp vec3 var_255ec = var_1108d.xyz / vec3(var_a7f50.w);
        var_255ec.y *= (-1.0);
        highp vec2 var_01cca = (var_255ec.xy + vec2(1.0)) * 0.5;
        highp float var_8cd8f = var_01cca.x;
        highp float var_89b5f = var_01cca.y;
        highp vec2 var_c124c = vec2(var_8cd8f, 1.0 - var_89b5f);
        var_01cca = var_c124c;
        highp vec2 var_77e0b = var_c124c * CausticsParameters.y;
        highp float var_90a6f;
        if (CausticsTextureParameters.x != 0.0)
        {
            highp float var_f3fb9 = var_77e0b.x;
            highp float var_f44ef = var_77e0b.x;
            highp float var_dd69e = var_f3fb9 - floor(var_f44ef);
            highp float var_d010a = var_77e0b.y;
            highp float var_045b0 = var_77e0b.y;
            highp float var_2ec8c = var_d010a - floor(var_045b0);
            var_77e0b = vec2(var_dd69e, var_2ec8c);
            var_90a6f = texture(s_CausticsTexture, vec3(var_dd69e, var_2ec8c, CausticsTextureParameters.y)).x * 2.0;
        }
        else
        {
            highp float var_51f47;
            highp float var_7e6e4;
            highp vec2 var_17c08;
            var_17c08 = var_77e0b;
            var_7e6e4 = 0.0;
            var_51f47 = 0.0;
            highp float var_e4b37;
            highp float var_86e2d;
            highp vec2 var_876ab;
            highp float var_1178e;
            highp float var_6ad2b;
            highp float var_7daad;
            highp float var_9a33c;
            uint var_feb1b = 0u;
            highp float var_48339 = 0.0;
            highp float var_67730 = WaterSurfaceWaveParameters.x;
            highp float var_91d14 = WaterSurfaceParameters.x;
            highp float var_8ee51 = 1.0;
            for (; var_feb1b < uint(WaterSurfaceParameters.y); var_8ee51 = var_1178e, var_91d14 = var_6ad2b, var_17c08 = var_876ab, var_67730 = var_7daad, var_48339 = var_9a33c, var_7e6e4 = var_86e2d, var_51f47 = var_e4b37, var_feb1b++)
            {
                highp vec2 var_d3782 = vec2(sin(var_48339), cos(var_48339));
                highp float var_e735d = (dot(var_d3782, var_17c08) * var_91d14) + (Time.x * var_67730);
                highp float var_aaba4 = pow((sin(var_e735d) + 1.0) * 0.5, WaterSurfaceWaveParameters.y);
                highp vec2 var_52610 = vec2(var_aaba4, (var_aaba4 * cos(var_e735d)) * (-1.0));
                var_e4b37 = var_51f47 + (var_52610.x * var_8ee51);
                var_86e2d = var_7e6e4 + var_8ee51;
                var_876ab = var_17c08 + (((var_d3782 * var_52610.y) * var_8ee51) * WaterSurfaceOctaveParameters.x);
                var_1178e = mix(var_8ee51, 0.0, WaterSurfaceOctaveParameters.y);
                var_6ad2b = var_91d14 * WaterSurfaceOctaveParameters.z;
                var_7daad = var_67730 * WaterSurfaceOctaveParameters.w;
                var_9a33c = var_48339 + 1.39900004863739013671875;
            }
            var_90a6f = var_51f47 / var_7e6e4;
        }
        var_ba9ef = pow(var_90a6f, float(int(CausticsParameters.z))) * float(int(CausticsParameters.z) + 1);
    }
    else
    {
        var_ba9ef = 1.0;
    }
    highp vec3 var_45a07 = vec3(v_projPosition.xy, var_88b76);
    highp vec3 var_98c8c = -(var_54046 / vec3(length(var_54046) + 9.9999997473787516355514526367188e-05));
    highp float var_121d0 = clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_4ac0e.w), 0.0, 1.0) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
    highp vec3 var_87018;
    highp vec3 var_5c108;
    if (var_45a07.z != 1.0)
    {
        highp vec3 var_92517 = var_54046;
        highp vec3 var_73edc;
        if (int(QuantizationParameters.y) > 0)
        {
            var_73edc = (var_d5564 - (var_fc769 - (var_61c47 * dot(var_fc769, var_61c47)))) + WorldOrigin.xyz;
        }
        else
        {
            var_73edc = var_09a52;
        }
        highp vec2 var_b51ae = vec2(var_30c68, var_ba9ef);
        highp vec3 var_a53cf;
        highp vec3 var_e520d;
        func_42001(var_8c5b7, var_e520d, var_a53cf, var_b9e03, var_73edc, var_effba, var_92517, var_b51ae, var_98c8c, var_5d51a, var_000c6, var_9c3c2, var_121d0);
        var_5c108 = var_e520d;
        var_87018 = var_a53cf;
    }
    else
    {
        var_5c108 = vec3(0.0);
        var_87018 = vec3(0.0);
    }
    highp vec4 var_27ed3 = vec4((var_5c108 + var_87018) + (((mix(var_000c6, vec3(dot(var_000c6, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_8c5b7.x)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), 1.0);
    highp vec4 var_38beb;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec3 var_02f69 = var_27ed3.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_38beb = vec4(var_02f69.x, var_02f69.y, var_02f69.z, var_27ed3.w);
    }
    else
    {
        var_38beb = var_27ed3;
    }
    bgfx_FragColor = var_38beb;
}
