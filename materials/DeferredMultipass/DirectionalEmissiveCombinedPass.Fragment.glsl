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
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF (not used)
* - POINT_LIGHT_SHADING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
* - uniform lowp sampler2D s_Normal;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - layout(binding = 10, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 11, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
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
* - uniform vec4 PointLightPreCalcValues;
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
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightSourceShadowDirection;
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection;
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
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
uniform highp vec4 WorldOrigin;
in highp vec3 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
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
void func_d749b(inout highp vec4 arg_765b5, inout highp vec3 arg_87514, inout highp vec3 arg_c03dc, inout highp vec3 arg_58fab, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_ae81a, inout highp float arg_485b3, inout highp vec3 arg_c7286, inout highp vec2 arg_3e2b4, inout highp vec3 arg_08b90, inout highp vec3 arg_bcfb6, inout highp float arg_b14d8, inout highp float arg_67b92) {
    bool loc_10906 = DirectionalLightSkyLightHeuristicToggles.x != 0.0;
    bool loc_d0d08;
    if (loc_10906)
    {
        loc_d0d08 = abs(arg_765b5.z) < 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_d0d08 = loc_10906;
    }
    if (loc_d0d08)
    {
        arg_87514 = vec3(0.0);
        arg_c03dc = vec3(0.0);
        return;
    }
    highp float loc_0f714;
    highp float loc_f89fe;
    if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
    {
        highp float loc_05e4d = max(dot(arg_58fab, normalize((u_view * DirectionalLightSourceShadowDirection).xyz)), 0.0);
        highp vec3 loc_28854 = arg_adf73 + ((arg_c100b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_05e4d, 0.0, 1.0));
        int loc_933da = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
        highp float loc_b1e8b;
        highp float loc_84203;
        loc_84203 = 1.0;
        loc_b1e8b = 1.0;
        int loc_0b773;
        highp float loc_a77da;
        highp float loc_288b6;
        for (int loc_840b5 = 0, loc_8c11c = 0; loc_840b5 < loc_933da; loc_8c11c = loc_0b773, loc_84203 = loc_288b6, loc_b1e8b = loc_a77da, loc_840b5++)
        {
            int loc_3ddd0 = min((loc_8c11c + int(CascadesPerSet[loc_840b5])), 8);
            loc_288b6 = loc_84203;
            loc_a77da = loc_b1e8b;
            loc_0b773 = loc_8c11c;
            int loc_620dd;
            highp float loc_ac3e2;
            highp float loc_6ac75;
            for (; loc_0b773 < loc_3ddd0; loc_288b6 = loc_6ac75, loc_a77da = loc_ac3e2, loc_0b773 = loc_620dd)
            {
                highp vec4 loc_0391e = CascadesShadowProj[loc_0b773] * vec4(loc_28854, 1.0);
                highp vec3 loc_f82b9 = abs(loc_0391e.xyz);
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
                    highp vec4 loc_569e5 = loc_0391e;
                    highp vec4 loc_49c0e = NdLFloor;
                    highp float loc_34935 = clamp(loc_05e4d, loc_49c0e[loc_0b773], 1.0);
                    highp float loc_bac6a = CascadesParameters[loc_0b773].y + (CascadesParameters[loc_0b773].z * (sqrt(1.0 - (loc_34935 * loc_34935)) / loc_34935));
                    highp float loc_d3a5b = SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z * length(CascadesShadowInvProj[loc_0b773] * vec4(0.0, 0.0, 1.0, 0.0));
                    int loc_98038;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_98038 = 1;
                    }
                    else
                    {
                        loc_98038 = clamp(int(CascadesParameters[loc_0b773].w + 0.5), 1, 9);
                    }
                    int loc_960ef = loc_98038 / 2;
                    highp vec2 loc_63e61 = ((vec2(loc_569e5.x, loc_569e5.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_0b773].x;
                    highp float loc_7263a = (loc_569e5.z * 0.5) + 0.5;
                    loc_63e61.y += (1.0 - CascadesParameters[loc_0b773].x);
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
                            highp vec2 loc_3cc8b = loc_63e61 + ((vec2(float(loc_6a5e1 - loc_960ef) + 0.5, float(loc_8ad4e - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_0b773].x);
                            highp vec4 loc_0c1b5 = textureGather(s_ShadowCascades, vec3(loc_3cc8b, float(loc_0b773)));
                            highp vec4 loc_1e988 = loc_0c1b5;
                            highp vec2 loc_89c3c = fract((loc_3cc8b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            highp vec4 loc_0edfa = vec4(1.0) - smoothstep(vec4(0.0), vec4(1.0), (vec4(loc_7263a) - loc_0c1b5) * loc_d3a5b);
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
                    loc_6ac75 = min(loc_288b6, loc_94392 / float(loc_98038 * loc_98038));
                    loc_ac3e2 = min(loc_a77da, loc_89b67 / float(loc_98038 * loc_98038));
                    loc_620dd = loc_3ddd0;
                }
                else
                {
                    loc_6ac75 = loc_288b6;
                    loc_ac3e2 = loc_a77da;
                    loc_620dd = loc_0b773 + 1;
                }
            }
        }
        highp float loc_55d77;
        if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
        {
            highp vec4 loc_a39dc = NdLFloor;
            highp float loc_80bb3;
            func_59bf3(loc_28854, loc_05e4d, loc_a39dc, loc_80bb3);
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
            highp vec4 loc_ac654 = loc_8ad63;
            loc_ac654 = loc_8ad63 / vec4(loc_ac654.w);
            highp float loc_12cc8 = clamp(loc_05e4d, loc_c8015.x, 1.0);
            loc_ac654.z -= ((CascadesParameters[0].y + (CascadesParameters[0].z * (sqrt(1.0 - (loc_12cc8 * loc_12cc8)) / loc_12cc8))) / loc_ac654.w);
            highp vec2 loc_340fb = ((vec2(loc_ac654.x, loc_ac654.y) * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
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
            loc_ac654.z = (loc_ac654.z * 0.5) + 0.5;
            loc_340fb.y += (1.0 - CascadesParameters[0].x);
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
                    highp vec3 loc_53ff4 = vec3(loc_340fb + ((vec2(float(loc_e18e2 - loc_15bcb) + 0.5, float(loc_5837b - loc_15bcb) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_0e3bc);
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_003c8 = loc_894a5 + float(textureLod(s_ShadowCascades, loc_53ff4, 0.0).x >= loc_ac654.z);
                    }
                    else
                    {
                        highp vec4 loc_bf06a = step(vec4(loc_ac654.z), textureGather(s_ShadowCascades, loc_53ff4));
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
        loc_f89fe = loc_84203;
        loc_0f714 = mix(min(loc_b1e8b, min(loc_55d77, loc_80289)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_ae81a.z));
    }
    else
    {
        loc_f89fe = 1.0;
        loc_0f714 = 1.0;
    }
    highp vec3 loc_52f44 = normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz);
    highp vec4 loc_85a44 = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp vec3 loc_08df4 = ((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_85a44.w) * arg_485b3) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight.x;
    highp float loc_947b2 = max(dot(arg_58fab, loc_52f44), 0.0);
    highp float loc_fefd5 = max(dot(arg_58fab, arg_c7286), 0.0);
    highp float loc_d8782 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
    highp float loc_65d74 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
    highp vec3 loc_77b0a = normalize(loc_52f44 + arg_c7286);
    highp float loc_3edd2 = max(arg_3e2b4.x, 0.0500000007450580596923828125);
    highp float loc_009bf = loc_3edd2 * loc_3edd2;
    highp float loc_3da81 = loc_009bf * loc_009bf;
    highp float loc_206e3 = max(dot(arg_58fab, loc_77b0a), 0.0);
    highp float loc_c16ab = (((loc_3da81 - 1.0) * loc_206e3) * loc_206e3) + 1.0;
    highp float loc_4fd72 = loc_009bf * 0.5;
    highp float loc_e86cf = clamp(1.0 - max(dot(arg_c7286, loc_77b0a), 0.0), 0.0, 1.0);
    highp float loc_9b2bc = loc_e86cf * loc_e86cf;
    highp vec3 loc_00b7f = arg_08b90 + ((vec3(1.0) - arg_08b90) * ((loc_9b2bc * loc_9b2bc) * loc_e86cf));
    highp vec3 loc_82e5e = arg_bcfb6 * (1.0 - arg_b14d8);
    arg_87514 = ((((((vec3(1.0) - loc_00b7f) * mix(loc_947b2, max((dot(arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_d8782 * loc_d8782), 0.0), arg_67b92)) * (loc_82e5e * vec3(0.3183098733425140380859375))) * loc_0f714) + (((loc_82e5e * vec3(0.3183098733425140380859375)) * (arg_67b92 * max((dot(-arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_65d74 * loc_65d74), 0.0))) * loc_f89fe)) * loc_08df4) * DiffuseSpecularEmissiveAmbientTermToggles.x;
    arg_c03dc = ((((((loc_00b7f * (loc_3da81 / ((loc_c16ab * loc_c16ab) * 3.1415927410125732421875))) * ((loc_fefd5 / (((loc_fefd5 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)) * (loc_947b2 / (((loc_947b2 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_947b2) * loc_fefd5) + 9.9999997473787516355514526367188e-05)) * loc_947b2) * loc_0f714) * loc_08df4) * DiffuseSpecularEmissiveAmbientTermToggles.y;
}
void main() {
    highp vec4 var_99c96 = texture(s_Normal, v_texcoord0.xy);
    highp vec4 var_11add = texture(s_SceneDepth, v_texcoord0.xy);
    highp float var_88b76 = (var_11add.x * 2.0) - 1.0;
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
    highp vec3 var_c6246 = var_3ee7d.xyz;
    highp vec3 var_4caf6 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_c6246)), normalize(dFdy(var_c6246)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_fc769 = mod(var_d5564, vec3(QuantizationParameters.z));
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
    highp vec3 var_3948f = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_40107 = normalize((u_view * vec4(var_3948f, 0.0)).xyz);
    highp vec4 var_83ee2 = texture(s_ColorMetalnessSubsurface, v_texcoord0.xy);
    highp vec4 var_4ac0e = var_83ee2;
    highp float var_4efeb = clamp(2.007874011993408203125 * (var_4ac0e.w - 0.501960813999176025390625), 0.0, 1.0);
    highp vec4 var_03883 = texture(s_EmissiveAmbientLinearRoughness, v_texcoord0.xy);
    highp vec4 var_81433 = var_03883;
    highp vec2 var_37f75 = var_03883.wx;
    highp vec3 var_9b682 = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_54046 = var_20845.xyz;
    highp vec3 var_9e11a = var_83ee2.xyz;
    highp vec3 var_6bb78;
    func_9b87e(var_6bb78, var_9e11a);
    highp vec3 var_5987a = vec3(0.039999999105930328369140625 * (1.0 - var_4efeb)) + (var_6bb78 * var_4efeb);
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
    highp float var_ba621;
    if (var_94c07)
    {
        var_ba621 = pow((texture(s_CausticsTexture, vec3((var_9b682 - WorldOrigin.xyz).xz * CausticsParameters.y, CausticsTextureParameters.y)).x * 2.0) * clamp(var_3948f.y, 0.0, 1.0), CausticsParameters.z) * (CausticsParameters.z + 1.0);
    }
    else
    {
        var_ba621 = 1.0;
    }
    highp vec3 var_45a07 = vec3(v_projPosition.xy, var_88b76);
    highp vec3 var_a9d8b = -(var_54046 / vec3(length(var_54046) + 9.9999997473787516355514526367188e-05));
    highp float var_22b17 = clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_4ac0e.w), 0.0, 1.0) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
    highp vec3 var_8e129;
    highp vec3 var_82cbc;
    if (var_45a07.z != 1.0)
    {
        highp vec3 var_8bbda = var_54046;
        highp vec3 var_e8d77;
        if (int(QuantizationParameters.y) > 0)
        {
            var_e8d77 = (var_d5564 - (var_fc769 - (var_4caf6 * dot(var_fc769, var_4caf6)))) + WorldOrigin.xyz;
        }
        else
        {
            var_e8d77 = var_9b682;
        }
        highp vec3 var_0edfc;
        highp vec3 var_5ea35;
        func_d749b(var_81433, var_5ea35, var_0edfc, var_40107, var_e8d77, var_3948f, var_8bbda, var_ba621, var_a9d8b, var_37f75, var_5987a, var_6bb78, var_4efeb, var_22b17);
        var_82cbc = var_5ea35;
        var_8e129 = var_0edfc;
    }
    else
    {
        var_82cbc = vec3(0.0);
        var_8e129 = vec3(0.0);
    }
    highp vec4 var_fa474 = vec4((var_82cbc + var_8e129) + (((mix(var_6bb78, vec3(dot(var_6bb78, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_37f75.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), 1.0);
    highp vec4 var_38beb;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec3 var_02f69 = var_fa474.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_38beb = vec4(var_02f69.x, var_02f69.y, var_02f69.z, var_fa474.w);
    }
    else
    {
        var_38beb = var_fa474;
    }
    bgfx_FragColor = var_38beb;
}
