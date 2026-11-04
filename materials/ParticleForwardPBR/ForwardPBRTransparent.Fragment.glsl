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
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF (not used)
* - POINT_LIGHT_SHADING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 10, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_MERSTexture;
* - uniform lowp sampler2D s_NormalTexture;
* - layout(binding = 11, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform lowp sampler2D s_ParticleTexture;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 12, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
* - layout(binding = 13, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 14, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MERSUniforms;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform vec4 PBRTextureFlags;
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

#extension GL_EXT_texture_cube_map_array : require
precision mediump float;
precision highp int;
const int var_5b963[64] = int[](-1, 2, 3, -1, 0, 6, 7, -1, 1, 10, 11, -1, -1, -1, -1, -1, 4, 14, 16, -1, 8, 18, 20, -1, 12, 22, 24, -1, -1, -1, -1, -1, 5, 15, 17, -1, 9, 19, 21, -1, 13, 23, 25, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
struct VoxelNode {
    uint data;
};

struct GpuVolumeEntry {
    int packed_xy;
    int packed_zw;
    int hash;
    int user_data;
};

layout(binding = 12, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_2593d;
layout(binding = 10, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_6e28c;
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
uniform highp sampler2D s_MERSTexture;
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
uniform highp vec4 BlockLightIndirectSpecularIntensity;
uniform highp vec4 CameraAmbientContribution;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadesParameters[8];
uniform highp vec4 CascadesPerSet;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
uniform highp vec4 CloudShadowsVisible;
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 ConvolutionType;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightSourceShadowDirection;
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection;
uniform highp vec4 DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 GpuEntryBufferCapacity;
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
uniform highp vec4 UndergroundFogColor;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WorldOrigin;
in highp vec4 v_color0;
in highp vec3 v_coloredLighting;
in highp vec4 v_fog;
in highp vec3 v_normal;
in highp vec2 v_texcoord0;
in highp vec2 v_vanillaLighting;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_66b9c(inout highp vec3 arg_5a7d1, inout highp vec4 arg_37ddf) {
    if (ColorGrading_OptimizeGammaCorrection.x != 0.0)
    {
        arg_5a7d1 = pow(max(arg_37ddf.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
        return;
    }
    else
    {
        highp vec3 loc_be4c0 = arg_37ddf.xyz;
        highp vec3 loc_d634f = arg_37ddf.xyz * vec3(0.077399380505084991455078125);
        highp vec3 loc_1f157 = pow((arg_37ddf.xyz + vec3(0.054999999701976776123046875)) * vec3(0.947867333889007568359375), vec3(2.400000095367431640625));
        highp float loc_e81ff;
        if (loc_be4c0.x <= 0.040449999272823333740234375)
        {
            loc_e81ff = loc_d634f.x;
        }
        else
        {
            loc_e81ff = loc_1f157.x;
        }
        loc_be4c0.x = loc_e81ff;
        highp float loc_007b0;
        if (loc_be4c0.y <= 0.040449999272823333740234375)
        {
            loc_007b0 = loc_d634f.y;
        }
        else
        {
            loc_007b0 = loc_1f157.y;
        }
        loc_be4c0.y = loc_007b0;
        highp float loc_fa4a6;
        if (loc_be4c0.z <= 0.040449999272823333740234375)
        {
            loc_fa4a6 = loc_d634f.z;
        }
        else
        {
            loc_fa4a6 = loc_1f157.z;
        }
        loc_be4c0.z = loc_fa4a6;
        arg_5a7d1 = loc_be4c0;
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
void func_cdaba(inout highp vec3 arg_87514, inout highp vec3 arg_c03dc, inout highp vec3 arg_58fab, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_ae81a, inout highp float arg_bfb77, inout highp vec3 arg_c7286, inout highp float arg_e0484, inout highp vec3 arg_08b90, inout highp vec3 arg_bcfb6, inout highp float arg_b14d8, inout highp float arg_67b92) {
    bool loc_10906 = DirectionalLightSkyLightHeuristicToggles.x != 0.0;
    bool loc_5818b;
    if (loc_10906)
    {
        loc_5818b = abs(v_vanillaLighting.y) < 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_5818b = loc_10906;
    }
    if (loc_5818b)
    {
        arg_87514 = vec3(0.0);
        arg_c03dc = vec3(0.0);
        return;
    }
    highp float loc_0f714;
    highp float loc_f89fe;
    if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.x) == 1)
    {
        highp float loc_05e4d = max(dot(arg_58fab, normalize((u_view * DirectionalLightSourceShadowDirection).xyz)), 0.0);
        highp vec3 loc_28854 = arg_adf73 + ((arg_c100b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_05e4d, 0.0, 1.0));
        int loc_933da = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
        highp float loc_b1e8b;
        highp float loc_84203;
        loc_84203 = 1.0;
        loc_b1e8b = 1.0;
        int loc_9517d;
        highp float loc_a77da;
        highp float loc_288b6;
        for (int loc_840b5 = 0, loc_8c11c = 0; loc_840b5 < loc_933da; loc_8c11c = loc_9517d, loc_84203 = loc_288b6, loc_b1e8b = loc_a77da, loc_840b5++)
        {
            int loc_3ddd0 = min((loc_8c11c + int(CascadesPerSet[loc_840b5])), 8);
            loc_288b6 = loc_84203;
            loc_a77da = loc_b1e8b;
            loc_9517d = loc_8c11c;
            int loc_620dd;
            highp float loc_ac3e2;
            highp float loc_6ac75;
            for (; loc_9517d < loc_3ddd0; loc_288b6 = loc_6ac75, loc_a77da = loc_ac3e2, loc_9517d = loc_620dd)
            {
                highp vec4 loc_03329 = CascadesShadowProj[loc_9517d] * vec4(loc_28854, 1.0);
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
                    highp float loc_34935 = clamp(loc_05e4d, loc_49c0e[loc_9517d], 1.0);
                    highp float loc_bac6a = CascadesParameters[loc_9517d].y + (CascadesParameters[loc_9517d].z * (sqrt(1.0 - (loc_34935 * loc_34935)) / loc_34935));
                    highp float loc_d3a5b = SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z * length(CascadesShadowInvProj[loc_9517d] * vec4(0.0, 0.0, 1.0, 0.0));
                    int loc_98038;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_98038 = 1;
                    }
                    else
                    {
                        loc_98038 = clamp(int(CascadesParameters[loc_9517d].w + 0.5), 1, 9);
                    }
                    int loc_960ef = loc_98038 / 2;
                    highp vec2 loc_81ff2 = ((loc_03329.xy * 0.5) + vec2(0.5)) * CascadesParameters[loc_9517d].x;
                    highp float loc_7263a = (loc_9a7eb.z * 0.5) + 0.5;
                    loc_81ff2.y += (1.0 - CascadesParameters[loc_9517d].x);
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
                            highp vec2 loc_3cc8b = loc_81ff2 + ((vec2(float(loc_6a5e1 - loc_960ef) + 0.5, float(loc_8ad4e - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_9517d].x);
                            highp vec4 loc_0c1b5 = textureGather(s_ShadowCascades, vec3(loc_3cc8b, float(loc_9517d)));
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
                    loc_620dd = loc_9517d + 1;
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
        bool loc_34091;
        if (loc_77735)
        {
            loc_34091 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.y) > 0;
        }
        else
        {
            loc_34091 = loc_77735;
        }
        highp float loc_80289;
        if (loc_34091)
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
        loc_f89fe = loc_84203;
        loc_0f714 = mix(min(loc_b1e8b, min(loc_55d77, loc_80289)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_ae81a.z));
    }
    else
    {
        loc_f89fe = 1.0;
        loc_0f714 = 1.0;
    }
    highp vec3 loc_52f44 = normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz);
    highp vec4 loc_77e5a = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp vec3 loc_f0a2f = ((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_77e5a.w) * arg_bfb77) * DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled.x;
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
    arg_87514 = ((((((vec3(1.0) - loc_00b7f) * mix(loc_947b2, max((dot(arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_d8782 * loc_d8782), 0.0), arg_67b92)) * (loc_82e5e * vec3(0.3183098733425140380859375))) * loc_0f714) + (((loc_82e5e * vec3(0.3183098733425140380859375)) * (arg_67b92 * max((dot(-arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_65d74 * loc_65d74), 0.0))) * loc_f89fe)) * loc_f0a2f) * DiffuseSpecularEmissiveAmbientTermToggles.x;
    arg_c03dc = ((((((loc_00b7f * (loc_3da81 / ((loc_c16ab * loc_c16ab) * 3.1415927410125732421875))) * ((loc_fefd5 / (((loc_fefd5 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)) * (loc_947b2 / (((loc_947b2 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_947b2) * loc_fefd5) + 9.9999997473787516355514526367188e-05)) * loc_947b2) * loc_0f714) * loc_f0a2f) * DiffuseSpecularEmissiveAmbientTermToggles.y;
}
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
        uint loc_a385f = (var_2593d.VoxelBuffer[loc_a0cb4].data >> loc_b118b) & 3u;
        uint loc_95bf0 = ((var_2593d.VoxelBuffer[loc_a0cb4].data >> 16u) >> loc_b118b) & 3u;
        uint loc_6dacb = (var_2593d.VoxelBuffer[loc_50d99].data >> loc_b118b) & 3u;
        uint loc_f9969 = ((var_2593d.VoxelBuffer[loc_50d99].data >> 16u) >> loc_b118b) & 3u;
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
        uint loc_a4225 = var_2593d.VoxelBuffer[loc_9766b + loc_f2544].data >> loc_2dbd6;
        uint loc_63c72;
        if (loc_2dbd6 > 12u)
        {
            loc_63c72 = loc_a4225 | (var_2593d.VoxelBuffer[(loc_9766b + loc_f2544) + 1u].data << (32u - loc_2dbd6));
        }
        else
        {
            loc_63c72 = loc_a4225;
        }
        uint loc_680e3 = (loc_63c72 & 3u) | ((loc_63c72 >> 16u) & 12u);
        uint loc_9a4d6 = (((var_2593d.VoxelBuffer[loc_a0cb4].data & 1u) | (((var_2593d.VoxelBuffer[loc_a0cb4].data >> 16u) & 1u) << 1u)) | ((var_2593d.VoxelBuffer[loc_50d99].data & 1u) << 2u)) | (((var_2593d.VoxelBuffer[loc_50d99].data >> 16u) & 1u) << 3u);
        arg_a965a = ((loc_680e3 & 3u) | ((loc_680e3 & 12u) << 2u)) | (((loc_9a4d6 & 3u) | ((loc_9a4d6 & 12u) << 2u)) << 2u);
        return;
    }
    uint loc_3413e = ((((var_2593d.VoxelBuffer[loc_a0cb4].data >> 15u) & 1u) | (((var_2593d.VoxelBuffer[loc_a0cb4].data >> 31u) & 1u) << 1u)) | (((var_2593d.VoxelBuffer[loc_50d99].data >> 15u) & 1u) << 2u)) | (((var_2593d.VoxelBuffer[loc_50d99].data >> 31u) & 1u) << 3u);
    ivec3 loc_f0131 = arg_f7dc9;
    uint loc_3a44a = (uint(loc_f0131.x - (-1)) * 18u) + uint(loc_f0131.z - (-1));
    uint loc_1d03f = loc_3a44a / 32u;
    uint loc_dcf35 = loc_3a44a % 32u;
    uint loc_38235 = arg_45009 + 4440u;
    uint loc_c3396 = var_2593d.VoxelBuffer[loc_38235 + loc_1d03f].data >> loc_dcf35;
    uint loc_f671b;
    if (loc_dcf35 > 12u)
    {
        loc_f671b = loc_c3396 | (var_2593d.VoxelBuffer[(loc_38235 + loc_1d03f) + 1u].data << (32u - loc_dcf35));
    }
    else
    {
        loc_f671b = loc_c3396;
    }
    uint loc_88411 = (loc_f671b & 3u) | ((loc_f671b >> 16u) & 12u);
    arg_a965a = ((loc_3413e & 3u) | ((loc_3413e & 12u) << 2u)) | (((loc_88411 & 3u) | ((loc_88411 & 12u) << 2u)) << 2u);
}
void func_0f254(inout int arg_ed9b7, inout uint arg_efebd, inout highp vec3 arg_aa7d7, inout highp vec3 arg_13804, inout highp vec3 arg_18a62, inout uint arg_92f3d) {
    bool loc_c7009 = var_5b963[arg_ed9b7] >= 0;
    bool loc_fcec2;
    if (loc_c7009)
    {
        loc_fcec2 = !((arg_efebd & (1u << uint(var_5b963[arg_ed9b7]))) != 0u);
    }
    else
    {
        loc_fcec2 = loc_c7009;
    }
    if (loc_fcec2)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    uint loc_b098c;
    if (var_5b963[arg_ed9b7] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_13804 - arg_18a62) & uvec3(15u);
        loc_b098c = arg_92f3d + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        uvec3 loc_441ec = uvec3(arg_13804 - (floor(arg_13804 * 0.0625) * 16.0)) & uvec3(15u);
        loc_b098c = (var_2593d.VoxelBuffer[(arg_92f3d + 4097u) + uint(var_5b963[arg_ed9b7])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    highp vec4 loc_11fc1 = vec4(uvec4(var_2593d.VoxelBuffer[loc_b098c].data, var_2593d.VoxelBuffer[loc_b098c].data >> 8u, var_2593d.VoxelBuffer[loc_b098c].data >> 16u, var_2593d.VoxelBuffer[loc_b098c].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_11fc1;
    arg_aa7d7 = (loc_11fc1.xyz * loc_3ff2a.w) * 6.0;
}
void func_d903a(inout highp vec4 arg_d4081, inout highp float arg_19032, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec3 loc_94d26 = (arg_d4081.xyz * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x;
    highp vec3 loc_cfa08 = mix(AmbientLightParams.xyz * AmbientLightParams.w, loc_94d26, vec3(clamp(dot(loc_94d26, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), 0.0, 1.0))) * arg_19032;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_cfa08, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_cfa08, 1.0);
}
void main() {
    highp vec4 var_eba1c = texture(s_ParticleTexture, v_texcoord0) * vec4(v_color0.xyz, v_color0.w);
    highp vec4 var_bfab4 = var_eba1c;
    highp vec3 var_c6e56 = mix(var_eba1c.xyz, v_fog.xyz, vec3(v_fog.w));
    var_bfab4.x = var_c6e56.x;
    var_bfab4.y = var_c6e56.y;
    var_bfab4.z = var_c6e56.z;
    highp vec3 var_a236f;
    func_66b9c(var_a236f, var_bfab4);
    int var_bec18 = int(PBRTextureFlags.x);
    highp float var_0c9e7;
    highp float var_000e0;
    highp float var_ee885;
    highp float var_90d31;
    if ((var_bec18 & 1) == 1)
    {
        highp vec4 var_4035b = texture(s_MERSTexture, v_texcoord0);
        highp float var_b362d;
        if ((var_bec18 & 2) == 2)
        {
            var_b362d = var_4035b.w;
        }
        else
        {
            var_b362d = MERSUniforms.w;
        }
        var_90d31 = var_b362d;
        var_ee885 = var_4035b.z;
        var_000e0 = var_4035b.y;
        var_0c9e7 = var_4035b.x;
    }
    else
    {
        var_90d31 = MERSUniforms.w;
        var_ee885 = MERSUniforms.z;
        var_000e0 = MERSUniforms.y;
        var_0c9e7 = MERSUniforms.x;
    }
    highp vec3 var_256a8;
    if ((var_bec18 & 4) == 4)
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
    highp vec3 var_b4b34 = normalize(var_256a8);
    highp vec4 var_e14aa = vec4(var_b4b34, 0.0);
    highp vec3 var_864e9 = var_e14aa.xyz;
    highp vec3 var_a4bd4 = (u_view * var_e14aa).xyz;
    highp vec3 var_5c650 = var_930c5.xyz;
    highp vec3 var_d1d69 = normalize(v_normal);
    bvec3 var_8d14e = greaterThanEqual(abs(var_d1d69), vec3(0.9900000095367431640625));
    highp vec3 var_b9aeb = vec3(ivec3(any(lessThan(var_d1d69, vec3(-0.5))) ? (-1) : 1) * ivec3(int(var_8d14e.x), int(var_8d14e.y), int(var_8d14e.z)));
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
    highp vec3 var_11406;
    if (var_fc5fc)
    {
        highp vec3 var_a35f2 = v_worldPos - WorldOrigin.xyz;
        highp vec3 var_66e39 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_5c650)), normalize(dFdy(var_5c650)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
        highp vec3 var_2872c = vec3(QuantizationParameters.z * 0.5) - mod(var_a35f2, vec3(QuantizationParameters.z));
        var_11406 = (var_a35f2 + (var_2872c - (var_66e39 * dot(var_2872c, var_66e39)))) + WorldOrigin.xyz;
    }
    else
    {
        var_11406 = v_worldPos;
    }
    highp vec3 var_3af3e;
    if ((((v_coloredLighting.x + v_coloredLighting.y) + v_coloredLighting.z) < 9.9999997473787516355514526367188e-05) && (v_vanillaLighting.x > 9.9999997473787516355514526367188e-05))
    {
        highp float var_67623 = v_vanillaLighting.x * v_vanillaLighting.x;
        var_3af3e = clamp(vec3(var_67623, var_67623 * ((((var_67623 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625), var_67623 * (((var_67623 * var_67623) * 0.60000002384185791015625) + 0.4000000059604644775390625)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_3af3e = v_coloredLighting;
    }
    highp vec4 var_8d364 = vec4(var_3af3e, 0.0);
    highp vec3 var_dd12c = vec3(0.039999999105930328369140625 * (1.0 - var_0c9e7)) + (var_a236f * var_0c9e7);
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
    highp float var_b82c9;
    if (var_94c07)
    {
        var_b82c9 = pow((texture(s_CausticsTexture, vec3((v_worldPos - WorldOrigin.xyz).xz * CausticsParameters.y, CausticsTextureParameters.y)).x * 2.0) * clamp(var_b4b34.y, 0.0, 1.0), CausticsParameters.z) * (CausticsParameters.z + 1.0);
    }
    else
    {
        var_b82c9 = 1.0;
    }
    highp float var_9050d = clamp(((v_vanillaLighting.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_106e2 = length(var_5c650);
    highp vec3 var_5bd0a = var_12830;
    highp vec3 var_48867;
    highp vec3 var_a4a04;
    highp vec3 var_eb774;
    highp vec3 var_9bf27;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_384dc = -(var_5c650 / vec3(length(var_5c650) + 9.9999997473787516355514526367188e-05));
        highp float var_4162b = var_90d31 * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
        highp vec3 var_6cfc2 = var_5c650;
        highp vec3 var_b5d88;
        if (int(QuantizationParameters.y) > 0)
        {
            var_b5d88 = var_11406;
        }
        else
        {
            var_b5d88 = v_worldPos;
        }
        highp vec3 var_e520d;
        highp vec3 var_12f6e;
        func_cdaba(var_12f6e, var_e520d, var_a4bd4, var_b5d88, var_864e9, var_6cfc2, var_b82c9, var_384dc, var_ee885, var_dd12c, var_a236f, var_0c9e7, var_4162b);
        highp vec4 var_512e0 = var_8d364;
        bool var_f91fc = any(notEqual(var_b9aeb, vec3(0.0)));
        highp vec3 var_2111b;
        if (var_f91fc)
        {
            var_2111b = var_b9aeb;
        }
        else
        {
            var_2111b = var_864e9;
        }
        highp vec3 var_e6ab0;
        if ((DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled.z != 0.0) && (!((uint(floor(var_512e0.w * 255.0)) & 1u) != 0u)))
        {
            highp vec3 var_bde2b = v_worldPos - WorldOrigin.xyz;
            bool var_2b694;
            if (var_f91fc)
            {
                highp float var_78b3d = dot(var_bde2b, abs(var_2111b));
                var_2b694 = abs(var_78b3d - round(var_78b3d)) > 0.001000000047497451305389404296875;
            }
            else
            {
                var_2b694 = var_f91fc;
            }
            highp vec3 var_f7ba1 = (var_bde2b - vec3(0.5)) + (var_2111b * 0.0199999995529651641845703125);
            highp vec3 var_8ac5d = var_2111b;
            highp vec3 var_f1c8c = floor(var_f7ba1 * 0.0625) * 16.0;
            highp vec3 var_be08f = var_f7ba1 - var_f1c8c;
            ivec4 var_7f823 = ivec4(ivec3(floor(vec3(ivec3(floor(var_f7ba1))) * vec3(0.0625))), 0);
            ivec4 var_a2c78 = var_7f823;
            int var_8282d = (var_a2c78.x & 65535) | (var_a2c78.y << 16);
            int var_db019 = (var_a2c78.z & 65535) | (var_a2c78.w << 16);
            ivec4 var_e83d2 = var_7f823;
            uint var_dbe8c = uint(var_e83d2.x) * 1540483477u;
            uint var_35207 = uint(var_e83d2.y) * 1540483477u;
            uint var_c7c69 = uint(var_e83d2.z) * 1540483477u;
            uint var_7c89d = uint(var_e83d2.w) * 1540483477u;
            uint var_ea647 = ((((((2293326976u ^ ((var_dbe8c ^ (var_dbe8c >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_35207 ^ (var_35207 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_c7c69 ^ (var_c7c69 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_7c89d ^ (var_7c89d >> uint(24))) * 1540483477u);
            uint var_66e52 = (var_ea647 ^ (var_ea647 >> uint(13))) * 1540483477u;
            uint var_02650 = var_66e52 ^ (var_66e52 >> uint(15));
            uint var_b516a = (var_02650 ^ (var_02650 >> uint(16))) & 65535u;
            uint var_0b021 = var_b516a | uint(var_b516a == 0u);
            uint var_0fd8c = uint(GpuEntryBufferCapacity.x);
            int var_4bfc3;
            uint var_1bd82;
            bool var_59b60;
            uint var_e4d40;
            var_e4d40 = 0u;
            var_59b60 = false;
            var_1bd82 = var_0b021 & (var_0fd8c - 1u);
            var_4bfc3 = 0;
            bool var_40c1a;
            uint var_d40b4;
            uint var_8d8f4;
            uint var_d9aef;
            bool var_4680b;
            for (;;)
            {
                if (var_4bfc3 < 8)
                {
                    uint var_b3275 = uint(var_6e28c.GpuEntryBuffer[var_1bd82].hash) & 65535u;
                    bool var_079e7 = var_b3275 == var_0b021;
                    bool var_88b02;
                    if (var_079e7)
                    {
                        var_88b02 = var_6e28c.GpuEntryBuffer[var_1bd82].packed_xy == var_8282d;
                    }
                    else
                    {
                        var_88b02 = var_079e7;
                    }
                    bool var_4f663;
                    if (var_88b02)
                    {
                        var_4f663 = var_6e28c.GpuEntryBuffer[var_1bd82].packed_zw == var_db019;
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
                            var_fbc90 = uint(var_6e28c.GpuEntryBuffer[var_1bd82].user_data);
                        }
                        else
                        {
                            var_fbc90 = var_e4d40;
                        }
                        var_8d8f4 = var_fbc90;
                    }
                    var_40c1a = var_59b60 || var_4f663;
                    var_d40b4 = (var_1bd82 + 1u) & (var_0fd8c - 1u);
                    if (var_40c1a || (var_b3275 == 0u))
                    {
                        var_4680b = var_40c1a;
                        var_d9aef = var_8d8f4;
                        break;
                    }
                    var_e4d40 = var_8d8f4;
                    var_59b60 = var_40c1a;
                    var_1bd82 = var_d40b4;
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
            uint var_b548d = var_d9aef >> 2u;
            highp vec3 var_740c9;
            if (var_4680b)
            {
                highp vec3 var_d3ea7 = var_f7ba1 + vec3(0.5);
                highp vec3 var_83391 = var_d3ea7;
                highp float var_b37f4;
                if (var_8ac5d.x > 0.0)
                {
                    var_b37f4 = ceil(var_83391.x) - 1.0;
                }
                else
                {
                    var_b37f4 = floor(var_83391.x);
                }
                highp float var_b0d7b;
                if (var_8ac5d.y > 0.0)
                {
                    var_b0d7b = ceil(var_83391.y) - 1.0;
                }
                else
                {
                    var_b0d7b = floor(var_83391.y);
                }
                highp float var_7f87a;
                if (var_8ac5d.z > 0.0)
                {
                    var_7f87a = ceil(var_83391.z) - 1.0;
                }
                else
                {
                    var_7f87a = floor(var_83391.z);
                }
                ivec3 var_935ea = ivec3(int(var_b37f4), int(var_b0d7b), int(var_7f87a));
                ivec3 var_bf341 = clamp(ivec3(round(var_d3ea7)) - ivec3(1), var_935ea - ivec3(1), var_935ea);
                ivec3 var_0a72f = var_bf341 - ivec3(var_f1c8c);
                ivec3 var_bfc97 = var_0a72f;
                uint var_6fcab;
                func_fff8e(var_b548d, var_bfc97, var_6fcab, var_0a72f);
                uint var_5fb86;
                uint var_a6fc9;
                if (dot(var_2111b, var_2111b) > 0.0)
                {
                    uvec3 var_c205b = uvec3(var_935ea - var_bf341);
                    uint var_ab5f4 = ((var_c205b.x * 4u) + (var_c205b.y * 2u)) + var_c205b.z;
                    uint var_bdca4;
                    if (var_2b694)
                    {
                        var_bdca4 = var_6fcab & (~(1u << var_ab5f4));
                    }
                    else
                    {
                        var_bdca4 = var_6fcab;
                    }
                    highp vec3 var_64cec = abs(var_2111b);
                    bool var_a9495 = var_64cec.x >= var_64cec.y;
                    bool var_73031;
                    if (var_a9495)
                    {
                        var_73031 = var_64cec.x >= var_64cec.z;
                    }
                    else
                    {
                        var_73031 = var_a9495;
                    }
                    uint var_d8d47;
                    uint var_31a82;
                    if (var_73031)
                    {
                        var_31a82 = 240u;
                        var_d8d47 = 4u;
                    }
                    else
                    {
                        uint var_d675c;
                        uint var_65b2b;
                        if (var_64cec.y >= var_64cec.z)
                        {
                            var_65b2b = 204u;
                            var_d675c = 2u;
                        }
                        else
                        {
                            var_65b2b = 170u;
                            var_d675c = 1u;
                        }
                        var_31a82 = var_65b2b;
                        var_d8d47 = var_d675c;
                    }
                    uint var_44881;
                    if ((var_bdca4 & (1u << var_ab5f4)) != 0u)
                    {
                        var_44881 = var_ab5f4 ^ var_d8d47;
                    }
                    else
                    {
                        var_44881 = var_ab5f4;
                    }
                    uint var_4eacf;
                    if ((var_44881 & var_d8d47) != 0u)
                    {
                        var_4eacf = var_31a82 ^ 255u;
                    }
                    else
                    {
                        var_4eacf = var_31a82;
                    }
                    uint var_c027a = (var_d8d47 == 4u) ? 2u : 4u;
                    uint var_bfcb1 = (var_d8d47 == 1u) ? 2u : 1u;
                    uint var_233b3 = (1u << (var_44881 ^ var_c027a)) | (1u << (var_44881 ^ var_bfcb1));
                    uint var_94d03;
                    if ((var_bdca4 & var_233b3) == var_233b3)
                    {
                        var_94d03 = var_4eacf | (1u << ((var_44881 ^ var_c027a) ^ var_bfcb1));
                    }
                    else
                    {
                        var_94d03 = var_4eacf;
                    }
                    var_a6fc9 = var_44881;
                    var_5fb86 = var_94d03 | var_bdca4;
                }
                else
                {
                    var_a6fc9 = 0u;
                    var_5fb86 = var_6fcab;
                }
                highp vec3 var_049a7;
                if (var_f91fc)
                {
                    highp vec3 var_b22a1 = abs(var_2111b);
                    highp vec3 var_a369c = var_b22a1.zxy;
                    highp vec3 var_73f90 = var_b22a1.yzx;
                    highp float var_cbae7 = dot(var_be08f, var_a369c);
                    highp float var_743bb = dot(var_be08f, var_73f90);
                    highp float var_a9e19 = floor(var_cbae7);
                    highp float var_b5d82 = floor(var_743bb);
                    highp vec3 var_0c8db = ((var_b22a1 * dot(vec3(var_0a72f + ivec3(uvec3(uint((var_a6fc9 & 4u) != 0u), uint((var_a6fc9 & 2u) != 0u), uint((var_a6fc9 & 1u) != 0u)))), var_b22a1)) + (var_a369c * var_a9e19)) + (var_73f90 * var_b5d82);
                    ivec3 var_7e508 = ivec3(var_0c8db);
                    ivec3 var_3675d = ivec3(var_0c8db + var_a369c);
                    ivec3 var_a2765 = var_3675d - var_7e508;
                    ivec3 var_197f4 = ivec3(var_0c8db + var_73f90) - var_7e508;
                    highp vec2 var_10632 = vec2(var_cbae7 - var_a9e19, var_743bb - var_b5d82);
                    ivec3 var_52739 = var_7e508;
                    ivec3 var_d1289 = var_a2765;
                    ivec3 var_130a5 = var_197f4;
                    uvec3 var_c0c7e = uvec3(var_a2765);
                    uint var_61f05 = ((var_c0c7e.x * 4u) + (var_c0c7e.y * 2u)) + var_c0c7e.z;
                    uvec3 var_2c751 = uvec3(var_197f4);
                    uint var_8c783 = ((var_2c751.x * 4u) + (var_2c751.y * 2u)) + var_2c751.z;
                    uvec3 var_fb5c6 = uvec3(abs(var_7e508 - var_0a72f));
                    uint var_5e7fc = ((var_fb5c6.x * 4u) + (var_fb5c6.y * 2u)) + var_fb5c6.z;
                    bool var_f2e69 = all(greaterThanEqual(var_7e508, ivec3(0)));
                    bool var_1adf6;
                    if (var_f2e69)
                    {
                        var_1adf6 = all(lessThan((var_3675d + var_197f4), ivec3(16)));
                    }
                    else
                    {
                        var_1adf6 = var_f2e69;
                    }
                    uint var_104c1;
                    uint var_dbb81;
                    uint var_e9198;
                    uint var_c88d4;
                    if (var_1adf6)
                    {
                        var_c88d4 = (uint(var_130a5.y) + (uint(var_130a5.z) * 16u)) + (uint(var_130a5.x) * 256u);
                        var_e9198 = (uint(var_d1289.y) + (uint(var_d1289.z) * 16u)) + (uint(var_d1289.x) * 256u);
                        var_dbb81 = var_b548d + ((uint(var_52739.y) + (uint(var_52739.z) * 16u)) + (uint(var_52739.x) * 256u));
                        var_104c1 = 0u;
                    }
                    else
                    {
                        var_c88d4 = 0u;
                        var_e9198 = 0u;
                        var_dbb81 = 0u;
                        var_104c1 = var_2593d.VoxelBuffer[var_b548d + 4096u].data;
                    }
                    highp vec3 var_fe6ff;
                    highp float var_41ca7;
                    var_41ca7 = 0.0;
                    var_fe6ff = vec3(0.0);
                    highp vec3 var_c68ef;
                    highp float var_1c492;
                    for (uint var_146a6 = 0u; var_146a6 < 4u; var_41ca7 = var_1c492, var_fe6ff = var_c68ef, var_146a6++)
                    {
                        uint var_70228 = var_146a6 & 1u;
                        uint var_0ce17 = var_146a6 >> 1u;
                        if ((var_5fb86 & (1u << ((var_5e7fc ^ (var_70228 * var_61f05)) ^ (var_0ce17 * var_8c783)))) != 0u)
                        {
                            var_1c492 = var_41ca7;
                            var_c68ef = var_fe6ff;
                            continue;
                        }
                        highp vec2 var_289b9 = mix(vec2(1.0) - var_10632, var_10632, vec2(float(var_70228), float(var_0ce17)));
                        highp float var_ec0d4 = var_289b9.x * var_289b9.y;
                        highp vec3 var_9ff1a;
                        if (var_1adf6)
                        {
                            uint var_67087 = (var_dbb81 + (var_70228 * var_e9198)) + (var_0ce17 * var_c88d4);
                            highp vec4 var_b6be8 = vec4(uvec4(var_2593d.VoxelBuffer[var_67087].data, var_2593d.VoxelBuffer[var_67087].data >> 8u, var_2593d.VoxelBuffer[var_67087].data >> 16u, var_2593d.VoxelBuffer[var_67087].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
                            highp vec4 var_aab3b = var_b6be8;
                            var_9ff1a = (var_b6be8.xyz * var_aab3b.w) * 6.0;
                        }
                        else
                        {
                            highp vec3 var_24c48 = var_f1c8c + vec3((var_7e508 + (ivec3(int(var_70228)) * var_a2765)) + (ivec3(int(var_0ce17)) * var_197f4));
                            highp vec3 var_82554 = var_24c48 - var_f1c8c;
                            int var_1d5c4 = ((((int(var_82554.x < 0.0) | (int(var_82554.x >= 16.0) << 1)) | (int(var_82554.y < 0.0) << 2)) | (int(var_82554.y >= 16.0) << 3)) | (int(var_82554.z < 0.0) << 4)) | (int(var_82554.z >= 16.0) << 5);
                            highp vec3 var_59d3d;
                            func_0f254(var_1d5c4, var_104c1, var_59d3d, var_24c48, var_f1c8c, var_b548d);
                            var_9ff1a = var_59d3d;
                        }
                        var_1c492 = var_41ca7 + var_ec0d4;
                        var_c68ef = var_fe6ff + (var_9ff1a * var_ec0d4);
                    }
                    highp vec3 var_680df;
                    if (var_41ca7 > 0.0)
                    {
                        var_680df = var_fe6ff / vec3(var_41ca7);
                    }
                    else
                    {
                        var_680df = vec3(0.0);
                    }
                    var_049a7 = var_680df;
                }
                else
                {
                    highp vec3 var_6f53f = clamp(fract(var_f7ba1), vec3(0.0), vec3(1.0));
                    ivec3 var_e0f98 = var_bf341 - ivec3(var_f1c8c);
                    bool var_f14fb = all(greaterThanEqual(var_e0f98, ivec3(0)));
                    bool var_e3f61;
                    if (var_f14fb)
                    {
                        var_e3f61 = all(lessThan(var_e0f98, ivec3(15)));
                    }
                    else
                    {
                        var_e3f61 = var_f14fb;
                    }
                    uint var_62b8a;
                    if (!var_e3f61)
                    {
                        var_62b8a = var_2593d.VoxelBuffer[var_b548d + 4096u].data;
                    }
                    else
                    {
                        var_62b8a = 0u;
                    }
                    highp vec3 var_d3d7a;
                    highp float var_a0d46;
                    var_a0d46 = 0.0;
                    var_d3d7a = vec3(0.0);
                    highp vec3 var_42244;
                    highp float var_86b5c;
                    for (uint var_3902d = 0u; var_3902d < 8u; var_a0d46 = var_86b5c, var_d3d7a = var_42244, var_3902d++)
                    {
                        if ((var_5fb86 & (1u << var_3902d)) != 0u)
                        {
                            var_86b5c = var_a0d46;
                            var_42244 = var_d3d7a;
                            continue;
                        }
                        uvec3 var_73bc0 = uvec3(uint((var_3902d & 4u) != 0u), uint((var_3902d & 2u) != 0u), uint((var_3902d & 1u) != 0u));
                        highp vec3 var_97016 = mix(vec3(1.0) - var_6f53f, var_6f53f, vec3(var_73bc0));
                        highp float var_5bd3f = (var_97016.x * var_97016.y) * var_97016.z;
                        highp vec3 var_19e3e;
                        if (var_e3f61)
                        {
                            uvec3 var_f4699 = uvec3(var_e0f98) + var_73bc0;
                            uint var_b83e5 = var_b548d + ((var_f4699.y + (var_f4699.z * 16u)) + (var_f4699.x * 256u));
                            highp vec4 var_2eacf = vec4(uvec4(var_2593d.VoxelBuffer[var_b83e5].data, var_2593d.VoxelBuffer[var_b83e5].data >> 8u, var_2593d.VoxelBuffer[var_b83e5].data >> 16u, var_2593d.VoxelBuffer[var_b83e5].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
                            highp vec4 var_710e5 = var_2eacf;
                            var_19e3e = (var_2eacf.xyz * var_710e5.w) * 6.0;
                        }
                        else
                        {
                            highp vec3 var_da4aa = vec3(var_bf341 + ivec3(var_73bc0));
                            highp vec3 var_1e5a1 = var_da4aa - var_f1c8c;
                            int var_e6e10 = ((((int(var_1e5a1.x < 0.0) | (int(var_1e5a1.x >= 16.0) << 1)) | (int(var_1e5a1.y < 0.0) << 2)) | (int(var_1e5a1.y >= 16.0) << 3)) | (int(var_1e5a1.z < 0.0) << 4)) | (int(var_1e5a1.z >= 16.0) << 5);
                            highp vec3 var_404a7;
                            func_0f254(var_e6e10, var_62b8a, var_404a7, var_da4aa, var_f1c8c, var_b548d);
                            var_19e3e = var_404a7;
                        }
                        var_86b5c = var_a0d46 + var_5bd3f;
                        var_42244 = var_d3d7a + (var_19e3e * var_5bd3f);
                    }
                    highp vec3 var_d7b6a;
                    if (var_a0d46 > 0.0)
                    {
                        var_d7b6a = var_d3d7a / vec3(var_a0d46);
                    }
                    else
                    {
                        var_d7b6a = vec3(0.0);
                    }
                    var_049a7 = var_d7b6a;
                }
                var_740c9 = var_049a7;
            }
            else
            {
                var_740c9 = vec3(0.0);
            }
            var_e6ab0 = var_740c9;
        }
        else
        {
            var_e6ab0 = var_8d364.xyz;
        }
        highp vec4 var_dda78 = SkyAmbientLightColorIntensity;
        highp float var_18213 = v_vanillaLighting.y * v_vanillaLighting.y;
        var_9bf27 = var_12f6e;
        var_eb774 = var_e520d;
        var_a4a04 = ((var_a236f * (1.0 - var_0c9e7)) * max((var_e6ab0 * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_18213 * var_18213) * v_vanillaLighting.y, (v_vanillaLighting.y * v_vanillaLighting.y) * v_vanillaLighting.y, CameraLightIntensity.y)) * var_dda78.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w;
        var_48867 = ((mix(var_a236f, vec3(dot(var_a236f, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_000e0)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x;
    }
    else
    {
        var_9bf27 = vec3(0.0);
        var_eb774 = vec3(0.0);
        var_a4a04 = vec3(0.0);
        var_48867 = vec3(0.0);
    }
    highp vec3 var_d4470 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
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
    highp vec3 var_9e815;
    if (var_68aa1)
    {
        highp vec4 var_38d79 = SkyAmbientLightColorIntensity;
        var_9e815 = max((vec3(1.0) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_38d79.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_9e815 = vec3(0.0);
    }
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_79b3e = clamp((((length(var_5c650) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_79b3e > 0.0)
        {
            highp vec3 var_44083;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_44083 = FogColor.xyz * max(var_9e815, vec3(1.0));
            }
            else
            {
                highp vec4 var_a0aa2 = SunColor;
                highp vec4 var_ea036 = MoonColor;
                highp vec3 var_bacde = var_d4470;
                highp float var_9281d = 1.0 - smoothstep(FogSkyBlend.x - FogSkyBlend.w, FogSkyBlend.z - FogSkyBlend.w, var_bacde.y);
                highp float var_99d92 = dot(var_d4470, SunDir.xyz);
                highp float var_b6eed = dot(var_d4470, MoonDir.xyz);
                highp vec3 var_5d345 = var_d4470;
                highp float var_070ce = 1.0 - smoothstep(FogSkyBlend.x - FogSkyBlend.w, FogSkyBlend.y, var_5d345.y);
                highp float var_824a6 = clamp(pow(max(var_99d92, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_3b3ff = clamp(pow(max(var_b6eed, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_3d1af = 1.809999942779541015625 - (var_824a6 * 1.7999999523162841796875);
                highp float var_db5e0 = 1.809999942779541015625 - (var_3b3ff * 1.7999999523162841796875);
                highp vec3 var_bda89 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3((var_070ce * var_070ce) * var_070ce)) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_a0aa2.w * (0.75 * ((var_99d92 * var_99d92) + 1.0))) + (var_ea036.w * (0.75 * ((var_b6eed * var_b6eed) + 1.0))))) + (((SkyHorizonColor.xyz * ((var_9281d * var_9281d) * var_9281d)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_a0aa2.w) * AtmosphericScattering.y) * var_824a6) * (0.0361000001430511474609375 / (var_3d1af * sqrt(var_3d1af)))) + ((((MoonColor.xyz * var_ea036.w) * AtmosphericScattering.z) * var_3b3ff) * (0.0361000001430511474609375 / (var_db5e0 * sqrt(var_db5e0))))));
                highp vec3 var_5d060;
                if (AtmosphericScatteringToggles.w != 0.0)
                {
                    var_5d060 = mix(UndergroundFogColor.xyz, var_bda89, vec3(max(CameraAmbientContribution.y, v_vanillaLighting.y)));
                }
                else
                {
                    var_5d060 = var_bda89;
                }
                var_44083 = var_5d060;
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
    highp vec4 var_164a6 = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_45187 = var_164a6;
    highp vec4 var_bde45;
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
        var_bde45 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_bde45 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_063c9 = var_bde45;
    highp vec3 var_86d4f;
    if (IBLParameters.x != 0.0)
    {
        highp vec3 var_a8715;
        highp vec3 var_dd3fd;
        if (QuantizationParameters.w > 0.0)
        {
            var_dd3fd = (u_view * vec4(var_11406, 1.0)).xyz;
            var_a8715 = var_11406;
        }
        else
        {
            var_dd3fd = var_5c650;
            var_a8715 = v_worldPos;
        }
        highp vec3 var_a56d9 = reflect(normalize(var_a8715 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_864e9);
        highp float var_0f441;
        if (int(ConvolutionType.x) == 1)
        {
            highp float var_9a0e5 = 1.0 - var_ee885;
            var_0f441 = (1.0 - (var_9a0e5 * var_9a0e5)) * (IBLParameters.y - 1.0);
        }
        else
        {
            highp float var_c17b7 = 1.0 - var_ee885;
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
        highp vec3 var_713f8 = (var_99477 * (((var_9050d * var_9050d) * var_9050d) * IBLParameters.x)) * IBLParameters.z;
        highp vec3 var_da3af;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec4 var_26642;
            func_d903a(var_8d364, var_0c9e7, var_713f8, var_26642);
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
        highp vec2 var_dea35 = vec2(clamp(dot(var_a4bd4, -normalize(var_dd3fd)), 0.0, 1.0), var_ee885);
        var_dea35.y = 1.0 - var_dea35.y;
        highp vec2 var_7d2be = texture(s_BrdfLUT, var_dea35).xy;
        highp vec3 var_fe0f6 = var_da3af * ((var_dd12c * var_7d2be.x) + vec3(var_7d2be.y));
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
        var_86d4f = var_0ffc6;
    }
    else
    {
        var_86d4f = vec3(0.0);
    }
    highp vec3 var_42f1f = vec4(var_bde45.xyz + (mix(((var_a4a04 + var_9bf27) + var_eb774) + var_48867, var_164a6.xyz, vec3(var_45187.w)) * var_063c9.w), 1.0).xyz + var_86d4f;
    highp vec4 var_a4d45 = vec4(var_42f1f, var_bfab4.w);
    highp vec3 var_005bf;
    if (PreExposureEnabled.x > 0.0)
    {
        var_005bf = var_42f1f * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_005bf = var_42f1f;
    }
    var_a4d45.x = var_005bf.x;
    var_a4d45.y = var_005bf.y;
    var_a4d45.z = var_005bf.z;
    bgfx_FragData0 = var_a4d45;
}
