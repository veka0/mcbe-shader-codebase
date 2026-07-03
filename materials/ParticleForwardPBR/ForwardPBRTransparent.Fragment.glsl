#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_MERTexture;
* - uniform lowp sampler2D s_NormalTexture;
* - layout(binding = 5, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform lowp sampler2D s_ParticleTexture;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 12, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 13, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 14, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 ConvolutionType;
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
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MERSUniforms;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform vec4 PBRTextureFlags;
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
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 Time;
* - uniform vec4 ViewportScale;
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

#extension GL_EXT_texture_cube_map_array : require
precision mediump float;
precision highp int;
uniform highp mat4 CascadesShadowInvProj[8];
uniform highp mat4 CascadesShadowProj[8];
uniform highp mat4 CloudShadowProj;
uniform highp mat4 PlayerShadowProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_model[4];
uniform highp mat4 u_proj;
uniform highp mat4 u_view;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2D s_MERTexture;
uniform highp sampler2D s_NormalTexture;
uniform highp sampler2D s_ParticleTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_CausticsTexture;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadesParameters[8];
uniform highp vec4 CascadesPerSet;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
uniform highp vec4 CloudShadowsVisible;
uniform highp vec4 ConvolutionType;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightSourceShadowDirection;
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection;
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 LastSpecularIBLIdx;
uniform highp vec4 MERSUniforms;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 NdLFloor;
uniform highp vec4 PBRTextureFlags;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 Time;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WaterSurfaceOctaveParameters;
uniform highp vec4 WaterSurfaceParameters;
uniform highp vec4 WaterSurfaceWaveParameters;
uniform highp vec4 WorldOrigin;
in highp vec2 v_ambientLight;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec3 v_normal;
in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragColor;
float var_3a80b;
void func_fd1b4(inout highp vec4 arg_07931, inout bool arg_5e3ed) {
    if (arg_07931.w < 0.5)
    {
        arg_5e3ed = true;
        return;
    }
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
void func_6e0c8(inout highp vec2 arg_ea738, inout highp vec3 arg_87514, inout highp vec3 arg_c03dc, inout highp vec3 arg_58fab, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_3f549, inout highp float arg_485b3, inout highp vec3 arg_c7286, inout highp float arg_e0484, inout highp vec3 arg_08b90, inout highp vec3 arg_bcfb6, inout highp float arg_b14d8, inout highp float arg_67b92) {
    bool loc_10906 = DirectionalLightSkyLightHeuristicToggles.x != 0.0;
    bool loc_f429e;
    if (loc_10906)
    {
        loc_f429e = abs(arg_ea738.y) < 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_f429e = loc_10906;
    }
    if (loc_f429e)
    {
        arg_87514 = vec3(0.0);
        arg_c03dc = vec3(0.0);
        return;
    }
    highp float loc_acdcc;
    highp float loc_f89fe;
    if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
    {
        highp float loc_93b5c = max(dot(arg_58fab, normalize((u_view * DirectionalLightSourceShadowDirection).xyz)), 0.0);
        highp vec3 loc_28854 = arg_adf73 + ((arg_c100b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_93b5c, 0.0, 1.0));
        highp float loc_ac4b0;
        highp float loc_dc2a1;
        loc_dc2a1 = 1.0;
        loc_ac4b0 = 1.0;
        int loc_88f02;
        highp float loc_18e47;
        highp float loc_eaa78;
        for (int loc_ede9d = 0, loc_5b57c = 0; (loc_ede9d < 4) && (loc_5b57c < 8); loc_dc2a1 = loc_eaa78, loc_ac4b0 = loc_18e47, loc_5b57c = loc_88f02, loc_ede9d++)
        {
            int loc_724f1 = int(CascadesPerSet[loc_ede9d]);
            for (int loc_c0375 = 0; loc_c0375 < loc_724f1; loc_c0375++)
            {
                int loc_ad5ab = loc_5b57c + loc_c0375;
                if (loc_ad5ab >= 8)
                {
                    loc_eaa78 = loc_dc2a1;
                    loc_18e47 = loc_ac4b0;
                    break;
                }
                highp vec4 loc_d8b45 = CascadesShadowProj[loc_ad5ab] * vec4(loc_28854, 1.0);
                highp vec3 loc_f82b9 = abs(loc_d8b45.xyz);
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
                bool loc_da05c;
                if (loc_d55ba)
                {
                    loc_da05c = loc_f82b9.z <= 1.0;
                }
                else
                {
                    loc_da05c = loc_d55ba;
                }
                if (!loc_da05c)
                {
                    continue;
                }
                highp vec4 loc_e2716 = loc_d8b45;
                highp vec4 loc_ac786 = NdLFloor;
                highp float loc_e3626 = clamp(loc_93b5c, loc_ac786[loc_ad5ab], 1.0);
                highp float loc_0ebc3 = CascadesParameters[loc_ad5ab].y + (CascadesParameters[loc_ad5ab].z * (sqrt(1.0 - (loc_e3626 * loc_e3626)) / loc_e3626));
                highp float loc_21351 = SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z * length(CascadesShadowInvProj[loc_ad5ab] * vec4(0.0, 0.0, 1.0, 0.0));
                int loc_cf72f;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_cf72f = 1;
                }
                else
                {
                    loc_cf72f = clamp(int(CascadesParameters[loc_ad5ab].w + 0.5), 1, 9);
                }
                int loc_2b064 = loc_cf72f / 2;
                highp vec2 loc_c324a = ((vec2(loc_e2716.x, loc_e2716.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_ad5ab].x;
                highp float loc_19971 = (loc_e2716.z * 0.5) + 0.5;
                loc_c324a.y += (1.0 - CascadesParameters[loc_ad5ab].x);
                highp float loc_4e095;
                highp float loc_5c92c;
                loc_5c92c = 0.0;
                loc_4e095 = 0.0;
                highp float loc_444ba;
                highp float loc_898f0;
                for (int loc_e34b5 = 0; loc_e34b5 < loc_cf72f; loc_5c92c = loc_898f0, loc_4e095 = loc_444ba, loc_e34b5++)
                {
                    loc_898f0 = loc_5c92c;
                    loc_444ba = loc_4e095;
                    highp float loc_8ac7d;
                    highp float loc_3cd49;
                    for (int loc_3eaff = 0; loc_3eaff < loc_cf72f; loc_898f0 = loc_3cd49, loc_444ba = loc_8ac7d, loc_3eaff++)
                    {
                        highp vec2 loc_237bd = loc_c324a + ((vec2(float(loc_3eaff - loc_2b064) + 0.5, float(loc_e34b5 - loc_2b064) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_ad5ab].x);
                        highp vec4 loc_15033 = textureGather(s_ShadowCascades, vec3(loc_237bd, float(loc_ad5ab)));
                        highp vec4 loc_a366c = loc_15033;
                        highp vec2 loc_e2c03 = fract((loc_237bd * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                        highp vec4 loc_2d037 = vec4(1.0) - smoothstep(vec4(0.0), vec4(1.0), (vec4(loc_19971) - loc_15033) * loc_21351);
                        highp vec2 loc_7086f = loc_e2c03;
                        loc_8ac7d = loc_444ba + mix(mix(loc_2d037.w, loc_2d037.z, loc_7086f.x), mix(loc_2d037.x, loc_2d037.y, loc_7086f.x), loc_7086f.y);
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_3cd49 = loc_898f0 + float(loc_a366c.w >= (loc_19971 - loc_0ebc3));
                        }
                        else
                        {
                            highp vec4 loc_f7572 = step(vec4(loc_19971 - loc_0ebc3), loc_15033);
                            highp vec2 loc_df6bc = loc_e2c03;
                            loc_3cd49 = loc_898f0 + mix(mix(loc_f7572.w, loc_f7572.z, loc_df6bc.x), mix(loc_f7572.x, loc_f7572.y, loc_df6bc.x), loc_df6bc.y);
                        }
                    }
                }
                loc_eaa78 = min(loc_dc2a1, loc_4e095 / float(loc_cf72f * loc_cf72f));
                loc_18e47 = min(loc_ac4b0, loc_5c92c / float(loc_cf72f * loc_cf72f));
                break;
            }
            loc_88f02 = loc_5b57c + loc_724f1;
        }
        highp float loc_ace78;
        if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
        {
            highp vec4 loc_a39dc = NdLFloor;
            highp float loc_80bb3;
            func_59bf3(loc_28854, loc_93b5c, loc_a39dc, loc_80bb3);
            loc_ace78 = loc_80bb3;
        }
        else
        {
            loc_ace78 = 1.0;
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
        highp float loc_e5d4d;
        if (loc_b7d63)
        {
            highp vec4 loc_c8015 = NdLFloor;
            highp vec4 loc_8ad63 = CloudShadowProj * vec4(loc_28854, 1.0);
            highp vec4 loc_ac654 = loc_8ad63;
            loc_ac654 = loc_8ad63 / vec4(loc_ac654.w);
            highp float loc_12cc8 = clamp(loc_93b5c, loc_c8015.x, 1.0);
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
            loc_e5d4d = loc_1bbb8;
        }
        else
        {
            loc_e5d4d = 1.0;
        }
        loc_f89fe = loc_dc2a1;
        loc_acdcc = mix(min(loc_ac4b0, min(loc_ace78, loc_e5d4d)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_3f549.z));
    }
    else
    {
        loc_f89fe = 1.0;
        loc_acdcc = 1.0;
    }
    highp vec3 loc_52f44 = normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz);
    highp vec4 loc_85a44 = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp vec3 loc_08df4 = ((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_85a44.w) * arg_485b3) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight.x;
    highp float loc_947b2 = max(dot(arg_58fab, loc_52f44), 0.0);
    highp float loc_fefd5 = max(dot(arg_58fab, arg_c7286), 0.0);
    highp float loc_d8782 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
    highp float loc_65d74 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
    highp vec3 loc_77b0a = normalize(loc_52f44 + arg_c7286);
    highp float loc_b831c = max(arg_e0484, 0.0500000007450580596923828125);
    highp float loc_009bf = loc_b831c * loc_b831c;
    highp float loc_3da81 = loc_009bf * loc_009bf;
    highp float loc_206e3 = max(dot(arg_58fab, loc_77b0a), 0.0);
    highp float loc_c16ab = (((loc_3da81 - 1.0) * loc_206e3) * loc_206e3) + 1.0;
    highp float loc_4fd72 = loc_009bf * 0.5;
    highp float loc_e86cf = clamp(1.0 - max(dot(arg_c7286, loc_77b0a), 0.0), 0.0, 1.0);
    highp float loc_9b2bc = loc_e86cf * loc_e86cf;
    highp vec3 loc_00b7f = arg_08b90 + ((vec3(1.0) - arg_08b90) * ((loc_9b2bc * loc_9b2bc) * loc_e86cf));
    highp vec3 loc_82e5e = arg_bcfb6 * (1.0 - arg_b14d8);
    arg_87514 = ((((((vec3(1.0) - loc_00b7f) * mix(loc_947b2, max((dot(arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_d8782 * loc_d8782), 0.0), arg_67b92)) * (loc_82e5e * vec3(0.3183098733425140380859375))) * loc_acdcc) + (((loc_82e5e * vec3(0.3183098733425140380859375)) * (arg_67b92 * max((dot(-arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_65d74 * loc_65d74), 0.0))) * loc_f89fe)) * loc_08df4) * DiffuseSpecularEmissiveAmbientTermToggles.x;
    arg_c03dc = ((((((loc_00b7f * (loc_3da81 / ((loc_c16ab * loc_c16ab) * 3.1415927410125732421875))) * ((loc_fefd5 / (((loc_fefd5 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)) * (loc_947b2 / (((loc_947b2 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_947b2) * loc_fefd5) + 9.9999997473787516355514526367188e-05)) * loc_947b2) * loc_acdcc) * loc_08df4) * DiffuseSpecularEmissiveAmbientTermToggles.y;
}
void func_3da12(inout highp vec2 arg_c3b89, inout highp float arg_1615d, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec4 loc_3b1a9 = vec4(0.0, 0.0, 0.0, 1.0);
    highp float loc_3a313 = arg_c3b89.x * arg_c3b89.x;
    highp vec3 loc_eda12 = (((AmbientLightParams.xyz * AmbientLightParams.w) * (1.0 - arg_c3b89.x)) + ((clamp(vec3(loc_3a313 + (loc_3b1a9.x * loc_3b1a9.w), (loc_3a313 * ((((loc_3a313 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_3b1a9.y * loc_3b1a9.w), (loc_3a313 * (((loc_3a313 * loc_3a313) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_3b1a9.z * loc_3b1a9.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * arg_c3b89.x)) * arg_1615d;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_eda12, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_eda12, 1.0);
}
void main() {
    highp vec4 var_462d1 = v_color0;
    highp vec2 var_210d3 = v_ambientLight;
    highp vec4 var_6ca24 = v_fog;
    highp vec4 var_d71e7 = texture(s_ParticleTexture, v_texcoord0);
    highp vec4 var_bdc42 = var_d71e7;
    bool var_c9230;
    func_fd1b4(var_bdc42, var_c9230);
    if (var_c9230)
    {
        discard;
    }
    highp vec4 var_c11b4 = var_d71e7 * vec4(v_color0.xyz, var_462d1.w);
    highp vec3 var_9debc = mix(var_c11b4.xyz, v_fog.xyz, vec3(var_6ca24.w));
    highp vec4 var_10e34 = vec4(var_9debc.x, var_9debc.y, var_9debc.z, var_c11b4.w);
    highp vec3 var_87672 = pow(max(var_9debc.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
    int var_f3b79 = int(PBRTextureFlags.x);
    highp float var_cb0a2;
    highp float var_43954;
    highp float var_3d3f0;
    if ((var_f3b79 & 1) == 1)
    {
        highp vec3 var_f3e08 = texture(s_MERTexture, v_texcoord0).xyz;
        var_3d3f0 = var_f3e08.z;
        var_43954 = var_f3e08.y;
        var_cb0a2 = var_f3e08.x;
    }
    else
    {
        var_3d3f0 = MERSUniforms.z;
        var_43954 = MERSUniforms.y;
        var_cb0a2 = MERSUniforms.x;
    }
    highp vec3 var_256a8;
    if ((var_f3b79 & 4) == 4)
    {
        var_256a8 = (u_model[0] * vec4((texture(s_NormalTexture, v_texcoord0).xyz * 2.0) - vec3(1.0), 0.0)).xyz;
    }
    else
    {
        var_256a8 = v_normal;
    }
    highp vec4 var_930c5 = u_view * vec4(v_worldPos, 1.0);
    highp vec4 var_e87e0 = u_proj * var_930c5;
    highp vec4 var_b8928 = var_e87e0;
    highp vec3 var_12830 = var_e87e0.xyz / vec3(var_b8928.w);
    highp vec3 var_851fd = normalize(var_256a8);
    highp vec4 var_e14aa = vec4(var_851fd, 0.0);
    highp vec3 var_9c296 = var_e14aa.xyz;
    highp vec3 var_b6566 = (u_view * var_e14aa).xyz;
    highp vec3 var_5c650 = var_930c5.xyz;
    bool var_71d55 = QuantizationParameters.y > 0.0;
    bool var_fc5fc;
    if (!var_71d55)
    {
        var_fc5fc = QuantizationParameters.w > 0.0;
    }
    else
    {
        var_fc5fc = var_71d55;
    }
    highp vec3 var_65737;
    if (var_fc5fc)
    {
        highp vec3 var_a85cf = v_worldPos - WorldOrigin.xyz;
        highp vec3 var_1f1d3 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_5c650)), normalize(dFdy(var_5c650)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
        highp vec3 var_8ce38 = mod(var_a85cf, vec3(QuantizationParameters.z));
        var_65737 = (var_a85cf - (var_8ce38 - (var_1f1d3 * dot(var_8ce38, var_1f1d3)))) + WorldOrigin.xyz;
    }
    else
    {
        var_65737 = v_worldPos;
    }
    highp vec3 var_8b2f4 = vec3(0.039999999105930328369140625 * (1.0 - var_cb0a2)) + (var_87672 * var_cb0a2);
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
    highp float var_f9e0e;
    if (var_94c07)
    {
        highp vec2 var_4ab46 = (v_worldPos - WorldOrigin.xyz).xz * CausticsParameters.y;
        highp float var_57cde;
        if (CausticsTextureParameters.x != 0.0)
        {
            var_57cde = texture(s_CausticsTexture, vec3(var_4ab46, CausticsTextureParameters.y)).x * 2.0;
        }
        else
        {
            highp float var_174a2;
            highp float var_46142;
            highp vec2 var_fb2a7;
            var_fb2a7 = var_4ab46;
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
            var_57cde = var_174a2 / var_46142;
        }
        var_f9e0e = pow(var_57cde * clamp(var_851fd.y, 0.0, 1.0), float(int(CausticsParameters.z))) * float(int(CausticsParameters.z) + 1);
    }
    else
    {
        var_f9e0e = 1.0;
    }
    highp float var_62b20 = clamp(((var_210d3.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_106e2 = length(var_5c650);
    highp vec3 var_5bd0a = var_12830;
    highp vec3 var_ac739;
    highp vec3 var_158d9;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_380bf = -(var_5c650 / vec3(length(var_5c650) + 9.9999997473787516355514526367188e-05));
        highp float var_797a6 = MERSUniforms.w * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
        highp vec3 var_8bbda = var_5c650;
        highp vec3 var_a3c91;
        if (int(QuantizationParameters.y) > 0)
        {
            var_a3c91 = var_65737;
        }
        else
        {
            var_a3c91 = v_worldPos;
        }
        highp vec3 var_0edfc;
        highp vec3 var_5ea35;
        func_6e0c8(var_210d3, var_5ea35, var_0edfc, var_b6566, var_a3c91, var_9c296, var_8bbda, var_f9e0e, var_380bf, var_3d3f0, var_8b2f4, var_87672, var_cb0a2, var_797a6);
        var_158d9 = var_5ea35;
        var_ac739 = var_0edfc;
    }
    else
    {
        var_158d9 = vec3(0.0);
        var_ac739 = vec3(0.0);
    }
    highp vec4 var_436f6 = vec4(0.0, 0.0, 0.0, 1.0);
    highp float var_c93a8 = var_210d3.x * var_210d3.x;
    highp vec4 var_0386d = SkyAmbientLightColorIntensity;
    highp float var_35dc6 = var_210d3.y * var_210d3.y;
    highp vec3 var_95db2 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
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
    highp vec3 var_d9480;
    if (var_68aa1)
    {
        highp vec4 var_0e954 = vec4(1.0);
        highp vec4 var_4c0ec = SkyAmbientLightColorIntensity;
        var_d9480 = max((clamp(vec3(1.0 + (var_0e954.x * var_0e954.w), 1.0 + (var_0e954.y * var_0e954.w), 1.0 + (var_0e954.z * var_0e954.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_4c0ec.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_d9480 = vec3(0.0);
    }
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_79b3e = clamp((((length(var_5c650) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_79b3e > 0.0)
        {
            highp vec3 var_fe67e;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_fe67e = FogColor.xyz * max(var_d9480, vec3(1.0));
            }
            else
            {
                highp vec4 var_52ab1 = SunColor;
                highp vec4 var_c9ec4 = MoonColor;
                highp vec3 var_e3755 = var_95db2;
                highp float var_7b136 = FogSkyBlend.x - FogSkyBlend.w;
                highp float var_e285c = smoothstep(FogSkyBlend.y, var_7b136, var_e3755.y);
                highp float var_2ea2e = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_7b136, var_e3755.y);
                highp float var_ec0d7 = dot(var_95db2, SunDir.xyz);
                highp float var_f7518 = dot(var_95db2, MoonDir.xyz);
                highp float var_ae688 = clamp(pow(max(var_ec0d7, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_a74b4 = clamp(pow(max(var_f7518, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_6773c = 1.809999942779541015625 - (var_ae688 * 1.7999999523162841796875);
                highp float var_fed1e = 1.809999942779541015625 - (var_a74b4 * 1.7999999523162841796875);
                var_fe67e = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_e285c * var_e285c) * var_e285c, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_52ab1.w * (0.75 * ((var_ec0d7 * var_ec0d7) + 1.0))) + (var_c9ec4.w * (0.75 * ((var_f7518 * var_f7518) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_2ea2e * var_2ea2e) * var_2ea2e, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_52ab1.w) * AtmosphericScattering.y) * var_ae688) * (0.0361000001430511474609375 / (var_6773c * sqrt(var_6773c)))) + ((((MoonColor.xyz * var_c9ec4.w) * AtmosphericScattering.z) * var_a74b4) * (0.0361000001430511474609375 / (var_fed1e * sqrt(var_fed1e))))));
            }
            var_138a7 = var_fe67e;
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
    highp vec4 var_3492a = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_85107 = var_3492a;
    highp vec4 var_8158b;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_115ba = (var_12830.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_12830, 1.0);
        highp float var_8cf8f = var_115ba.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_115ba.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_8158b = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_8158b = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_56c3e = var_8158b;
    highp vec3 var_1a602;
    if (IBLParameters.x != 0.0)
    {
        highp vec3 var_a8715;
        highp vec3 var_dd3fd;
        if (QuantizationParameters.w > 0.0)
        {
            var_dd3fd = (u_view * vec4(var_65737, 1.0)).xyz;
            var_a8715 = var_65737;
        }
        else
        {
            var_dd3fd = var_5c650;
            var_a8715 = v_worldPos;
        }
        highp vec3 var_a56d9 = reflect(normalize(var_a8715 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_9c296);
        highp float var_0f441;
        if (int(ConvolutionType.x) == 1)
        {
            highp float var_9a0e5 = 1.0 - var_3d3f0;
            var_0f441 = (1.0 - (var_9a0e5 * var_9a0e5)) * (IBLParameters.y - 1.0);
        }
        else
        {
            highp float var_c17b7 = 1.0 - var_3d3f0;
            highp float var_e5afa = var_c17b7 * var_c17b7;
            highp float var_d59d7 = var_e5afa * var_e5afa;
            var_0f441 = (1.0 - (var_d59d7 * var_d59d7)) * (IBLParameters.y - 1.0);
        }
        int var_ae27f = int(LastSpecularIBLIdx.x);
        highp vec3 var_67eb4 = mix(textureLod(s_SpecularIBLRecords, vec4(var_a56d9, float((var_ae27f + 2) % 3)), var_0f441).xyz, textureLod(s_SpecularIBLRecords, vec4(var_a56d9, float(var_ae27f)), var_0f441).xyz, vec3(IBLParameters.w));
        highp vec3 var_99477;
        if (PreExposureEnabled.x > 0.0)
        {
            var_99477 = var_67eb4 * vec3(301.72412109375);
        }
        else
        {
            var_99477 = var_67eb4;
        }
        highp vec3 var_713f8 = (var_99477 * (((var_62b20 * var_62b20) * var_62b20) * IBLParameters.x)) * IBLParameters.z;
        highp vec3 var_da3af;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec4 var_26642;
            func_3da12(var_210d3, var_cb0a2, var_713f8, var_26642);
            highp vec4 var_fb83f = var_26642;
            highp vec3 var_5279b;
            if (var_fb83f.w == 1.0)
            {
                var_5279b = var_26642.xyz;
            }
            else
            {
                var_5279b = var_713f8;
            }
            var_da3af = var_5279b;
        }
        else
        {
            var_da3af = var_713f8;
        }
        highp vec2 var_dea35 = vec2(clamp(dot(var_b6566, -normalize(var_dd3fd)), 0.0, 1.0), var_3d3f0);
        var_dea35.y = 1.0 - var_dea35.y;
        highp vec2 var_7d2be = texture(s_BrdfLUT, var_dea35).xy;
        highp vec3 var_fe0f6 = var_da3af * ((var_8b2f4 * var_7d2be.x) + vec3(var_7d2be.y));
        highp vec3 var_67472;
        if (AtmosphericScatteringToggles.x != 0.0)
        {
            var_67472 = var_fe0f6 * (1.0 - clamp((((var_106e2 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0));
        }
        else
        {
            var_67472 = var_fe0f6 * (1.0 - clamp((((var_106e2 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
        }
        highp vec3 var_0ffc6;
        if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
        {
            highp vec2 var_0a57b = VolumeNearFar.xy;
            highp vec2 var_9ec98 = (var_12830.xy + vec2(1.0)) * 0.5;
            highp vec4 var_197cc = u_invProj * vec4(var_12830, 1.0);
            highp float var_80ecf = var_9ec98.x;
            ivec3 var_1d618 = ivec3(VolumeDimensions.xyz);
            highp vec3 var_1dd8d = vec3(var_80ecf, var_9ec98.y, log((53.598148345947265625 * ((((-var_197cc.z) / var_197cc.w) - var_0a57b.x) / (var_0a57b.y - var_0a57b.x))) + 1.0) * 0.25);
            highp float var_372cd = (var_1dd8d.z * float(var_1d618.z)) - 0.5;
            int var_a3560 = clamp(int(var_372cd), 0, var_1d618.z - 2);
            highp vec4 var_af436 = mix(textureLod(s_ScatteringBuffer, vec3(var_80ecf, var_9ec98.y, float(var_a3560)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_80ecf, var_9ec98.y, float(var_a3560 + 1)), 0.0), vec4(clamp(var_372cd - float(var_a3560), 0.0, 1.0)));
            var_0ffc6 = var_67472 * var_af436.w;
        }
        else
        {
            var_0ffc6 = var_67472;
        }
        var_1a602 = var_0ffc6;
    }
    else
    {
        var_1a602 = vec3(0.0);
    }
    highp vec3 var_4c4c1 = vec4(var_8158b.xyz + (mix((((((var_87672 * (1.0 - var_cb0a2)) * max((clamp(vec3(var_c93a8 + (var_436f6.x * var_436f6.w), (var_c93a8 * ((((var_c93a8 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_436f6.y * var_436f6.w), (var_c93a8 * (((var_c93a8 * var_c93a8) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_436f6.z * var_436f6.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_35dc6 * var_35dc6) * var_210d3.y, (var_210d3.y * var_210d3.y) * var_210d3.y, CameraLightIntensity.y)) * var_0386d.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_158d9) + var_ac739) + (((mix(var_87672, vec3(dot(var_87672, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_43954)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_3492a.xyz, vec3(var_85107.w)) * var_56c3e.w), 1.0).xyz + var_1a602;
    highp vec3 var_bb142;
    if (PreExposureEnabled.x > 0.0)
    {
        var_bb142 = var_4c4c1 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_bb142 = var_4c4c1;
    }
    bgfx_FragColor = vec4(var_bb142.x, var_bb142.y, var_bb142.z, vec4(var_3a80b, var_3a80b, var_3a80b, var_10e34.w).w);
}
