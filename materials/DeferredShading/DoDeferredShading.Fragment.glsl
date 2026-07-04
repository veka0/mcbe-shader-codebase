#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_DEFERRED_SHADING_PASS (not used)
* - FALLBACK_PASS (not used)
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF
* - POINT_LIGHT_SHADING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp usampler2D s_EmissiveAmbientLinearRoughness;
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
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
layout(binding = 11, std430) buffer s_zLights { Light zLights[]; } var_aa32a;
layout(binding = 10, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_18f3b;
#endif
uniform highp mat4 CascadesShadowInvProj[8];
uniform highp mat4 CascadesShadowProj[8];
uniform highp mat4 CloudShadowProj;
uniform highp mat4 PlayerShadowProj;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
#endif
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_Normal;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp sampler2D s_PointLightShadowTextureAtlas;
#endif
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2DArray s_CausticsTexture;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp sampler3D s_SkyAmbientSamples;
uniform highp usampler2D s_EmissiveAmbientLinearRoughness;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraAmbientContribution;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadesParameters[8];
uniform highp vec4 CascadesPerSet;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
uniform highp vec4 CloudShadowsVisible;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ClusterDepthBounds;
uniform highp vec4 ClusterDimensions;
#endif
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
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
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
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 UndergroundFogColor;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WorldOrigin;
in highp vec3 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
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
void func_01a10(inout highp float arg_4edfb, inout highp vec3 arg_87514, inout highp vec3 arg_c03dc, inout highp vec3 arg_58fab, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_ae81a, inout highp float arg_485b3, inout highp vec3 arg_c7286, inout highp vec2 arg_3e2b4, inout highp vec3 arg_08b90, inout highp vec3 arg_bcfb6, inout highp float arg_b14d8, inout highp float arg_67b92) {
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
void func_be31c(inout int arg_7070b, inout highp float arg_43b7a, inout highp float arg_9499a, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c, inout highp float arg_77c90) {
    if (arg_7070b < 0)
    {
        arg_43b7a = 1.0;
        arg_9499a = 0.0;
        return;
    }
    highp vec3 loc_8868e = arg_aee55 - var_aa32a.zLights[arg_7070b].position.xyz;
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
    highp vec4 loc_cc567 = var_aa32a.zLights[arg_7070b].shadowFaceUV0;
    highp vec3 loc_baa89;
    if (loc_f3fad == 1)
    {
        loc_cc567 = var_aa32a.zLights[arg_7070b].shadowFaceUV1;
        loc_baa89 = vec3(-loc_8a9f7.z, loc_8a9f7.y, loc_8a9f7.x);
    }
    else
    {
        highp vec3 loc_a4212;
        if (loc_f3fad == 2)
        {
            loc_cc567 = var_aa32a.zLights[arg_7070b].shadowFaceUV2;
            loc_a4212 = vec3(-loc_8a9f7.x, -loc_8a9f7.z, -loc_8a9f7.y);
        }
        else
        {
            highp vec3 loc_38505;
            if (loc_f3fad == 3)
            {
                loc_cc567 = var_aa32a.zLights[arg_7070b].shadowFaceUV3;
                loc_38505 = vec3(-loc_8a9f7.x, loc_8a9f7.z, loc_8a9f7.y);
            }
            else
            {
                highp vec3 loc_fd3cf;
                if (loc_f3fad == 4)
                {
                    loc_cc567 = var_aa32a.zLights[arg_7070b].shadowFaceUV4;
                    loc_fd3cf = vec3(-loc_8a9f7.x, loc_8a9f7.y, -loc_8a9f7.z);
                }
                else
                {
                    highp vec3 loc_0c356;
                    if (loc_f3fad == 5)
                    {
                        loc_cc567 = var_aa32a.zLights[arg_7070b].shadowFaceUV5;
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
    bool loc_da9b7 = loc_cc567.z == 0.0;
    bool loc_20dc6;
    if (loc_da9b7)
    {
        loc_20dc6 = loc_cc567.w == 0.0;
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
    highp vec4 loc_c8835 = PointLightProj * vec4(loc_baa89, 1.0);
    highp float loc_2f407 = clamp(dot(normalize(-loc_8868e), normalize(arg_1111c)), PointLightNdLFloor.x, 1.0);
    loc_c8835.z -= (PointLightShadowParams1.x + (PointLightShadowParams1.y * (sqrt(1.0 - (loc_2f407 * loc_2f407)) / loc_2f407)));
    highp float loc_d799e = loc_c8835.w;
    highp vec4 loc_9858b = loc_c8835;
    highp vec4 loc_f9e0d = loc_9858b / vec4(loc_d799e);
    loc_c8835 = loc_f9e0d;
    highp vec2 loc_3b25d = vec2(0.5) / PointLightShadowAtlasResolution.xy;
    highp float loc_772b7 = (textureLod(s_PointLightShadowTextureAtlas, clamp(loc_cc567.xy + (((loc_f9e0d.xy * 0.5) + vec2(0.5)) * (loc_cc567.zw - loc_cc567.xy)), loc_cc567.xy + loc_3b25d, loc_cc567.zw - loc_3b25d), 0.0).x * 2.0) - 1.0;
    highp float loc_591c8;
    if (loc_772b7 >= loc_c8835.z)
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
        highp vec4 loc_932a9 = PointLightInvProj * vec4(loc_c8835.xy, loc_772b7, 1.0);
        highp vec4 loc_85f94 = loc_932a9;
        highp float loc_0585d = loc_85f94.w;
        highp vec3 loc_6d5dc = loc_932a9.xyz / vec3(loc_0585d);
        loc_85f94 = vec4(loc_6d5dc.x, loc_6d5dc.y, loc_6d5dc.z, loc_932a9.w);
        loc_d7fd8 = 1.0 - smoothstep(0.0, 1.0, (length(loc_baa89) - length(loc_6d5dc.xyz)) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z);
    }
    else
    {
        loc_d7fd8 = 1.0;
    }
    arg_43b7a = loc_d7fd8;
    arg_9499a = loc_591c8;
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
    highp vec3 loc_8dfd7 = var_aa32a.zLights[arg_0b9bc].position.xyz - arg_29ac4;
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
    if (loc_9eb1a >= (var_aa32a.zLights[arg_0b9bc].position.w * var_aa32a.zLights[arg_0b9bc].position.w))
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
        func_be31c(arg_0b9bc, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_a011d = loc_b2a04;
        loc_cddfe = loc_412fd;
    }
    else
    {
        loc_a011d = 1.0;
        loc_cddfe = 1.0;
    }
    highp float loc_4c5a5 = loc_9eb1a / ((var_aa32a.zLights[arg_0b9bc].position.w * var_aa32a.zLights[arg_0b9bc].position.w) + 9.9999997473787516355514526367188e-05);
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
        highp vec3 loc_8226d = var_aa32a.zLights[arg_0b9bc].color.xyz * loc_219c5;
        arg_e84ec = vec4(loc_8226d.x, loc_8226d.y, loc_8226d.z, arg_e84ec.w);
        arg_e84ec.w = 1.0 - (loc_9eb1a / ((var_aa32a.zLights[arg_0b9bc].position.w * var_aa32a.zLights[arg_0b9bc].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_0a2b9 = (var_aa32a.zLights[arg_0b9bc].color.xyz * var_aa32a.zLights[arg_0b9bc].color.w) * loc_219c5;
}
void func_8b00b(inout highp vec3 arg_33c3b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec4 arg_fadf1, inout highp vec3 arg_efe4b, inout highp vec3 arg_81f79, inout highp vec2 arg_92c2f, inout highp vec3 arg_58ffc, inout highp vec3 arg_cff01, inout highp float arg_5416d, inout highp vec3 arg_e6b36, inout highp vec3 arg_b8e73, inout highp vec3 arg_775e2, inout highp float arg_bfa42) {
    highp vec4 loc_a468d = vec4(0.0);
    bool loc_a0bb1;
    int loc_490eb;
    int loc_c476d;
    func_06412(arg_33c3b, loc_c476d, loc_490eb, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        arg_fadf1 = loc_a468d;
        return;
    }
    highp float loc_a55d6;
    highp vec3 loc_45a05;
    highp vec3 loc_b9311;
    loc_b9311 = vec3(0.0);
    loc_45a05 = vec3(0.0);
    loc_a55d6 = 0.0;
    highp float loc_96e3a;
    highp vec3 loc_50935;
    highp vec3 loc_bfd6d;
    highp vec4 loc_2348f;
    for (int loc_86630 = loc_490eb; loc_86630 < loc_c476d; loc_b9311 = loc_bfd6d, loc_45a05 = loc_50935, loc_a55d6 = loc_96e3a, loc_86630++)
    {
        int loc_dbe64 = int(var_18f3b.zLightLookupArray[loc_86630].lookup);
        if (loc_dbe64 < 0)
        {
            break;
        }
        highp vec3 loc_ed90f = normalize((u_view * vec4(var_aa32a.zLights[loc_dbe64].position.xyz, 1.0)).xyz - arg_33c3b);
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
        highp vec3 loc_b92e1 = arg_cff01 * (1.0 - arg_5416d);
        highp vec4 loc_55c3a = vec4(0.0);
        highp vec3 loc_49548;
        highp float loc_bbe0d;
        highp float loc_0721a;
        func_b155c(loc_2348f, loc_dbe64, loc_0721a, loc_bbe0d, loc_49548, arg_e6b36, arg_b8e73, arg_775e2, arg_bfa42);
        loc_55c3a = loc_2348f;
        highp vec3 loc_ef49b = loc_a468d.xyz + loc_2348f.xyz;
        loc_a468d = vec4(loc_ef49b.x, loc_ef49b.y, loc_ef49b.z, loc_a468d.w);
        loc_96e3a = loc_a55d6 + loc_55c3a.w;
        loc_50935 = loc_45a05 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_bfa42)) * (loc_b92e1 * vec3(0.3183098733425140380859375))) * loc_bbe0d) + (((loc_b92e1 * vec3(0.3183098733425140380859375)) * (arg_bfa42 * max((dot(-arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_0721a)) * loc_49548) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_bfd6d = loc_b9311 + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_bbe0d) * loc_49548) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    if (loc_a55d6 > 9.9999997473787516355514526367188e-05)
    {
        highp vec3 loc_70b77 = loc_a468d.xyz / vec3(loc_a55d6);
        loc_a468d = vec4(loc_70b77.x, loc_70b77.y, loc_70b77.z, loc_a468d.w);
        loc_a468d.w = clamp(loc_a55d6, 0.0, 1.0);
    }
    arg_534d1 = loc_45a05;
    arg_90b60 = loc_b9311;
    arg_fadf1 = loc_a468d;
}
void func_87d6a(inout highp vec3 arg_326b5, inout highp vec3 arg_179c6, inout highp vec3 arg_a0b83, inout highp vec3 arg_757dc, inout highp vec4 arg_d4ca2, inout highp vec3 arg_b40e7, inout highp vec3 arg_39f73, inout highp vec3 arg_d4087, inout highp vec3 arg_eeac1, inout highp vec3 arg_88895, inout highp vec2 arg_ea8b0, inout highp vec3 arg_b3d75, inout highp vec3 arg_77982, inout highp float arg_65463, inout highp vec3 arg_29396, inout highp float arg_41465) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0))
    {
        arg_326b5 = arg_179c6;
        arg_a0b83 = arg_757dc;
        arg_d4ca2 = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    highp vec3 loc_0b854;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_0b854 = arg_b40e7;
    }
    else
    {
        loc_0b854 = arg_39f73;
    }
    highp vec4 loc_25c44;
    highp vec3 loc_74e66;
    highp vec3 loc_2d2f4;
    func_8b00b(arg_d4087, loc_2d2f4, loc_74e66, loc_25c44, arg_eeac1, arg_88895, arg_ea8b0, arg_b3d75, arg_77982, arg_65463, arg_39f73, loc_0b854, arg_29396, arg_41465);
    arg_326b5 = arg_179c6 + loc_2d2f4;
    arg_a0b83 = arg_757dc + loc_74e66;
    arg_d4ca2 = loc_25c44;
}
#endif
void main() {
    highp vec4 var_99c96 = texture(s_Normal, v_texcoord0.xy);
    highp vec4 var_11add = texture(s_SceneDepth, v_texcoord0.xy);
    highp float var_12373 = (var_11add.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_12373, 1.0);
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
    highp vec4 var_1c342 = vec4(v_projPosition.xy + vec2(SubPixelOffset.x, -SubPixelOffset.y), var_12373, 1.0);
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
    highp vec3 var_dc0c3 = (u_invView * vec4(var_3ee7d.xyz, 1.0)).xyz - WorldOrigin.xyz;
    highp vec3 var_c6246 = var_3ee7d.xyz;
    highp vec3 var_6e9b6 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_c6246)), normalize(dFdy(var_c6246)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_38bcd = vec3(QuantizationParameters.z * 0.5) - mod(var_dc0c3, vec3(QuantizationParameters.z));
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_35826 = (var_dc0c3 + (var_38bcd - (var_6e9b6 * dot(var_38bcd, var_6e9b6)))) + WorldOrigin.xyz;
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
    highp vec3 var_b46fc = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_8efdc = normalize((u_view * vec4(var_b46fc, 0.0)).xyz);
    highp vec4 var_83ee2 = texture(s_ColorMetalnessSubsurface, v_texcoord0.xy);
    highp vec4 var_2a00e = var_83ee2;
    highp float var_d3d1d = clamp(2.007874011993408203125 * (var_2a00e.w - 0.501960813999176025390625), 0.0, 1.0);
    uvec4 var_cd9e5 = texelFetch(s_EmissiveAmbientLinearRoughness, ivec2(vec2(textureSize(s_EmissiveAmbientLinearRoughness, 0)) * v_texcoord0.xy), 0);
    uvec4 var_1f03a = var_cd9e5;
    uint var_4b676 = var_1f03a.x & 65535u;
    uvec2 var_49e6b = uvec2(var_4b676 >> 8u, var_4b676 & 255u);
    highp vec2 var_2d607 = vec2(float(var_49e6b.x), float(var_49e6b.y)) * vec2(0.0039215688593685626983642578125);
    uvec2 var_c02ad = var_cd9e5.yz;
    uint var_39af7 = var_c02ad.x & 65535u;
    uint var_32bfc = var_c02ad.y & 65535u;
    highp vec4 var_d745a = vec4(uvec4(var_39af7 >> 8u, var_39af7 & 255u, var_32bfc >> 8u, var_32bfc & 255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 var_d4730 = var_d745a;
    highp float var_27af0 = float(var_1f03a.w) * 0.0039215688593685626983642578125;
    highp float var_d7433;
    if (var_12373 == 1.0)
    {
        highp vec2 var_5ba1d = v_texcoord0.xy;
        highp float var_ef4d6;
        func_3785d(var_ef4d6, var_5ba1d);
        var_d7433 = var_ef4d6;
    }
    else
    {
        var_d7433 = var_27af0;
    }
    highp vec3 var_38fb5 = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_418c8 = var_20845.xyz;
    highp vec3 var_ce54f = vec3(v_projPosition.xy, var_12373);
    highp vec3 var_9e11a = var_83ee2.xyz;
    highp vec3 var_15547;
    func_9b87e(var_15547, var_9e11a);
    highp vec3 var_798fe = vec3(0.039999999105930328369140625 * (1.0 - var_d3d1d)) + (var_15547 * var_d3d1d);
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
        var_ba621 = pow((texture(s_CausticsTexture, vec3((var_38fb5 - WorldOrigin.xyz).xz * CausticsParameters.y, CausticsTextureParameters.y)).x * 2.0) * clamp(var_b46fc.y, 0.0, 1.0), CausticsParameters.z) * (CausticsParameters.z + 1.0);
    }
    else
    {
        var_ba621 = 1.0;
    }
    highp vec3 var_5bd0a = var_ce54f;
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_40fe3;
#endif
    highp vec3 var_3266d;
    highp vec3 var_03108;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_d0c5d = -(var_418c8 / vec3(length(var_418c8) + 9.9999997473787516355514526367188e-05));
        highp float var_5dd01 = clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_2a00e.w), 0.0, 1.0) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
        highp vec3 var_8bbda = var_418c8;
        highp vec3 var_b8a90;
        if (int(QuantizationParameters.y) > 0)
        {
#ifdef POINT_LIGHT_SHADING__OFF
            var_b8a90 = (var_dc0c3 + (var_38bcd - (var_6e9b6 * dot(var_38bcd, var_6e9b6)))) + WorldOrigin.xyz;
#endif
#ifdef POINT_LIGHT_SHADING__ON
            var_b8a90 = var_35826;
#endif
        }
        else
        {
            var_b8a90 = var_38fb5;
        }
        highp vec3 var_95b4a;
        highp vec3 var_8cf42;
        func_01a10(var_27af0, var_8cf42, var_95b4a, var_8efdc, var_b8a90, var_b46fc, var_8bbda, var_ba621, var_d0c5d, var_2d607, var_798fe, var_15547, var_d3d1d, var_5dd01);
#ifdef POINT_LIGHT_SHADING__ON
        highp vec4 var_b2434;
        highp vec3 var_79a86;
        highp vec3 var_7ac75;
        func_87d6a(var_7ac75, var_8cf42, var_79a86, var_95b4a, var_b2434, var_35826, var_38fb5, var_418c8, var_8efdc, var_d0c5d, var_2d607, var_798fe, var_15547, var_d3d1d, var_b46fc, var_5dd01);
        var_03108 = var_7ac75;
#endif
#ifdef POINT_LIGHT_SHADING__OFF
        var_03108 = var_8cf42;
        var_3266d = var_95b4a;
#endif
#ifdef POINT_LIGHT_SHADING__ON
        var_3266d = var_79a86;
        var_40fe3 = var_b2434;
#endif
    }
    else
    {
        var_03108 = vec3(0.0);
        var_3266d = vec3(0.0);
#ifdef POINT_LIGHT_SHADING__ON
        var_40fe3 = vec4(0.0, 0.0, 0.0, 1.0);
#endif
    }
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_faf4b = var_40fe3;
#endif
    highp vec4 var_0abab = SkyAmbientLightColorIntensity;
    highp float var_4f3c8 = var_27af0 * var_27af0;
    highp vec3 var_6d83f = normalize(var_38fb5 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
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
        highp float var_79b3e = clamp((((length(var_418c8) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
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
    highp vec4 var_51510 = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_d02c2 = var_51510;
    highp vec4 var_85a51;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_115ba = (var_ce54f.xy + vec2(1.0)) * 0.5;
        highp vec4 var_cf4b5 = u_invProj * vec4(v_projPosition.xy, var_12373, 1.0);
        highp float var_8cf8f = var_115ba.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_115ba.y, log((53.598148345947265625 * ((((-var_cf4b5.z) / var_cf4b5.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_85a51 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_85a51 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_c463d = var_85a51;
#ifdef POINT_LIGHT_SHADING__OFF
    highp vec3 var_4d302 = var_85a51.xyz + (mix((((((var_15547 * (1.0 - var_d3d1d)) * max((((var_d745a.xyz * var_d4730.w) * 6.0) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_4f3c8 * var_4f3c8) * var_27af0, (var_27af0 * var_27af0) * var_27af0, CameraLightIntensity.y)) * var_0abab.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_03108) + var_3266d) + (((mix(var_15547, vec3(dot(var_15547, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_2d607.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_51510.xyz, vec3(var_d02c2.w)) * var_c463d.w);
    highp vec4 var_dbc4c = vec4(var_4d302, 1.0);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_86dea = mix((((((var_15547 * (1.0 - var_d3d1d)) * max(((((var_d745a.xyz * var_d4730.w) * 6.0) + (var_40fe3.xyz * var_faf4b.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_4f3c8 * var_4f3c8) * var_27af0, (var_27af0 * var_27af0) * var_27af0, CameraLightIntensity.y)) * var_0abab.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_03108) + var_3266d) + (((mix(var_15547, vec3(dot(var_15547, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_2d607.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_51510.xyz, vec3(var_d02c2.w)) * var_c463d.w;
    highp vec4 var_dbc4c = vec4(var_85a51.xyz + var_86dea, 1.0);
#endif
    highp vec4 var_38beb;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec3 var_02f69 = var_dbc4c.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_38beb = vec4(var_02f69.x, var_02f69.y, var_02f69.z, var_dbc4c.w);
    }
    else
    {
        var_38beb = var_dbc4c;
    }
    bgfx_FragColor = var_38beb;
}
