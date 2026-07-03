#version 310 es

/*
* Available Macros:
*
* Passes:
* - ATMOSPHERICS_PASS (not used)
* - DIRECTIONAL_EMISSIVE_COMBINED_PASS (not used)
* - DISCRETE_INDIRECT_COMBINED_PASS (not used)
* - DO_DEFERRED_SHADING_PASS (not used)
* - DO_INDIRECT_SPECULAR_SHADING_PASS (not used)
* - FALLBACK_PASS (not used)
* - VOLUMETRIC_SCATTERING_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - layout(binding = 1, std430) buffer s_BiomeInfoBufferBuffer { BiomeInfo s_BiomeInfoBuffer[]; };
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
* - layout(binding = 6, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 7, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SSRTexture;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
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
* - uniform vec4 CascadeShadowResolutions;
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform vec4 ClampViewVectors;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ConvolutionType;
* - uniform vec4 CurrentFace;
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
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
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
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SSRParameters;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowSlopeBias;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyProbeUVFadeParameters;
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
uniform highp mat4 CloudShadowProj;
uniform highp mat4 DirectionalLightSourceCausticsViewProj[2];
uniform highp mat4 DirectionalLightSourceShadowInvProj0[2];
uniform highp mat4 DirectionalLightSourceShadowInvProj1[2];
uniform highp mat4 DirectionalLightSourceShadowInvProj2[2];
uniform highp mat4 DirectionalLightSourceShadowInvProj3[2];
uniform highp mat4 DirectionalLightSourceShadowProj0[2];
uniform highp mat4 DirectionalLightSourceShadowProj1[2];
uniform highp mat4 DirectionalLightSourceShadowProj2[2];
uniform highp mat4 DirectionalLightSourceShadowProj3[2];
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
uniform highp vec4 CascadeShadowResolutions;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightExplicitCascadedShadowMapEnabled[2];
uniform highp vec4 DirectionalLightExplicitCascadedShadowMapIndices[2];
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform highp vec4 DirectionalLightSourceIsSun[2];
uniform highp vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform highp vec4 DirectionalLightSourceShadowDirection[2];
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform highp vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 ShadowBias;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform highp vec4 ShadowPCFWidth;
uniform highp vec4 ShadowSlopeBias;
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
mat4 var_62632;
float var_2ce5b;
void func_9040f(inout int arg_9f721, inout highp vec3 arg_f8577, inout highp mat4 arg_e27d9, inout highp vec4 arg_a2d38, inout int arg_ee338, inout highp mat4 arg_4ee81) {
    highp vec4 loc_06bbb = DirectionalLightSourceShadowProj0[arg_9f721] * vec4(arg_f8577, 1.0);
    highp vec4 loc_108af = loc_06bbb;
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
        arg_e27d9 = DirectionalLightSourceShadowInvProj0[arg_9f721];
        arg_a2d38 = loc_06bbb;
        arg_ee338 = 0;
        return;
    }
    highp vec4 loc_857da = DirectionalLightSourceShadowProj1[arg_9f721] * vec4(arg_f8577, 1.0);
    highp vec4 loc_6ed2f = loc_857da;
    bool loc_79540 = loc_6ed2f.x >= (-1.0);
    bool loc_60d02;
    if (loc_79540)
    {
        loc_60d02 = loc_6ed2f.x <= 1.0;
    }
    else
    {
        loc_60d02 = loc_79540;
    }
    bool loc_db52c;
    if (loc_60d02)
    {
        loc_db52c = loc_6ed2f.y >= (-1.0);
    }
    else
    {
        loc_db52c = loc_60d02;
    }
    bool loc_0bf1e;
    if (loc_db52c)
    {
        loc_0bf1e = loc_6ed2f.y <= 1.0;
    }
    else
    {
        loc_0bf1e = loc_db52c;
    }
    bool loc_cd494;
    if (loc_0bf1e)
    {
        loc_cd494 = loc_6ed2f.z >= (-1.0);
    }
    else
    {
        loc_cd494 = loc_0bf1e;
    }
    bool loc_3b7d6;
    if (loc_cd494)
    {
        loc_3b7d6 = loc_6ed2f.z <= 1.0;
    }
    else
    {
        loc_3b7d6 = loc_cd494;
    }
    if (loc_3b7d6)
    {
        arg_e27d9 = DirectionalLightSourceShadowInvProj1[arg_9f721];
        arg_a2d38 = loc_857da;
        arg_ee338 = 1;
        return;
    }
    highp vec4 loc_7216b = DirectionalLightSourceShadowProj2[arg_9f721] * vec4(arg_f8577, 1.0);
    highp vec4 loc_5934a = loc_7216b;
    bool loc_540c6 = loc_5934a.x >= (-1.0);
    bool loc_b8a11;
    if (loc_540c6)
    {
        loc_b8a11 = loc_5934a.x <= 1.0;
    }
    else
    {
        loc_b8a11 = loc_540c6;
    }
    bool loc_c0490;
    if (loc_b8a11)
    {
        loc_c0490 = loc_5934a.y >= (-1.0);
    }
    else
    {
        loc_c0490 = loc_b8a11;
    }
    bool loc_ab099;
    if (loc_c0490)
    {
        loc_ab099 = loc_5934a.y <= 1.0;
    }
    else
    {
        loc_ab099 = loc_c0490;
    }
    bool loc_6a75a;
    if (loc_ab099)
    {
        loc_6a75a = loc_5934a.z >= (-1.0);
    }
    else
    {
        loc_6a75a = loc_ab099;
    }
    bool loc_6a3da;
    if (loc_6a75a)
    {
        loc_6a3da = loc_5934a.z <= 1.0;
    }
    else
    {
        loc_6a3da = loc_6a75a;
    }
    if (loc_6a3da)
    {
        arg_e27d9 = DirectionalLightSourceShadowInvProj2[arg_9f721];
        arg_a2d38 = loc_7216b;
        arg_ee338 = 2;
        return;
    }
    highp vec4 loc_0e1bf = DirectionalLightSourceShadowProj3[arg_9f721] * vec4(arg_f8577, 1.0);
    highp vec4 loc_39bd3 = loc_0e1bf;
    bool loc_319eb = loc_39bd3.x >= (-1.0);
    bool loc_516c3;
    if (loc_319eb)
    {
        loc_516c3 = loc_39bd3.x <= 1.0;
    }
    else
    {
        loc_516c3 = loc_319eb;
    }
    bool loc_8ba34;
    if (loc_516c3)
    {
        loc_8ba34 = loc_39bd3.y >= (-1.0);
    }
    else
    {
        loc_8ba34 = loc_516c3;
    }
    bool loc_ff47d;
    if (loc_8ba34)
    {
        loc_ff47d = loc_39bd3.y <= 1.0;
    }
    else
    {
        loc_ff47d = loc_8ba34;
    }
    bool loc_0b734;
    if (loc_ff47d)
    {
        loc_0b734 = loc_39bd3.z >= (-1.0);
    }
    else
    {
        loc_0b734 = loc_ff47d;
    }
    bool loc_0e0bb;
    if (loc_0b734)
    {
        loc_0e0bb = loc_39bd3.z <= 1.0;
    }
    else
    {
        loc_0e0bb = loc_0b734;
    }
    if (loc_0e0bb)
    {
        arg_e27d9 = DirectionalLightSourceShadowInvProj3[arg_9f721];
        arg_a2d38 = loc_0e1bf;
        arg_ee338 = 3;
        return;
    }
    arg_e27d9 = arg_4ee81;
    arg_a2d38 = loc_0e1bf;
    arg_ee338 = -1;
}
void func_103b2(inout highp float arg_5b759, inout int arg_11220, inout highp float arg_ce9c6) {
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
void func_6ab74(inout int arg_a398d, inout highp float arg_7a26d, inout highp float arg_98f56, inout int arg_da0e3, inout highp vec4 arg_5b51a, inout highp float arg_af650, inout highp float arg_e6df6) {
    if (arg_a398d < 0)
    {
        arg_7a26d = 1.0;
        arg_98f56 = 1.0;
        return;
    }
    int loc_042af;
    if (QuantizationParameters.x != 0.0)
    {
        loc_042af = 1;
    }
    else
    {
        loc_042af = clamp(int(ShadowPCFWidth[arg_da0e3] + 0.5), 1, 9);
    }
    int loc_7cc8c = loc_042af / 2;
    highp vec2 loc_124e3 = ((vec2(arg_5b51a.x, arg_5b51a.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions[arg_da0e3];
    highp float loc_820a9 = (arg_5b51a.z * 0.5) + 0.5;
    loc_124e3.y += (1.0 - CascadeShadowResolutions[arg_da0e3]);
    highp float loc_36d1e;
    highp float loc_76a21;
    loc_76a21 = 0.0;
    loc_36d1e = 0.0;
    highp float loc_4cd6d;
    highp float loc_dcabb;
    for (int loc_a4059 = 0; loc_a4059 < loc_042af; loc_76a21 = loc_dcabb, loc_36d1e = loc_4cd6d, loc_a4059++)
    {
        loc_dcabb = loc_76a21;
        loc_4cd6d = loc_36d1e;
        highp float loc_c3d98;
        highp float loc_cf9df;
        for (int loc_7c187 = 0; loc_7c187 < loc_042af; loc_dcabb = loc_cf9df, loc_4cd6d = loc_c3d98, loc_7c187++)
        {
            highp float loc_18f34 = float(arg_da0e3);
            highp float loc_1e85b;
            func_103b2(loc_18f34, arg_a398d, loc_1e85b);
            highp vec2 loc_bfb93 = loc_124e3 + ((vec2(float(loc_7c187 - loc_7cc8c) + 0.5, float(loc_a4059 - loc_7cc8c) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadeShadowResolutions[arg_da0e3]);
            highp vec4 loc_16755 = textureGather(s_ShadowCascades, vec3(loc_bfb93, (float(arg_a398d) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(arg_da0e3)));
            if (loc_1e85b >= 0.0)
            {
                highp vec4 loc_e8b1b = textureGather(s_ShadowCascades, vec3(loc_bfb93, (float(arg_a398d) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + loc_1e85b));
                highp vec4 loc_6187c = loc_e8b1b;
                if (loc_16755.x < loc_6187c.x)
                {
                    loc_16755 = loc_e8b1b;
                }
            }
            highp vec2 loc_c9d40 = fract((loc_bfb93 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
            highp vec4 loc_0505f = vec4(1.0) - smoothstep(vec4(0.0), vec4(1.0), (vec4(loc_820a9) - loc_16755) * arg_af650);
            highp vec2 loc_f9006 = loc_c9d40;
            loc_c3d98 = loc_4cd6d + mix(mix(loc_0505f.w, loc_0505f.z, loc_f9006.x), mix(loc_0505f.x, loc_0505f.y, loc_f9006.x), loc_f9006.y);
            if (QuantizationParameters.x != 0.0)
            {
                loc_cf9df = loc_dcabb + float(loc_16755.w >= (loc_820a9 - arg_e6df6));
            }
            else
            {
                highp vec4 loc_27ff4 = step(vec4(loc_820a9 - arg_e6df6), loc_16755);
                highp vec2 loc_18eef = loc_c9d40;
                loc_cf9df = loc_dcabb + mix(mix(loc_27ff4.w, loc_27ff4.z, loc_18eef.x), mix(loc_27ff4.x, loc_27ff4.y, loc_18eef.x), loc_18eef.y);
            }
        }
    }
    arg_7a26d = loc_36d1e / float(loc_042af * loc_042af);
    arg_98f56 = loc_76a21 / float(loc_042af * loc_042af);
}
void func_5fe8d(inout highp vec3 arg_3a8bb, inout highp float arg_642e1, inout highp float arg_7a26d) {
    highp vec4 loc_012e2 = PlayerShadowProj * vec4(arg_3a8bb, 1.0);
    loc_012e2.z -= (ShadowBias.x + (ShadowSlopeBias.x * clamp(sqrt(1.0 - (arg_642e1 * arg_642e1)) / arg_642e1, 0.0, 1.0)));
    loc_012e2.z = min(loc_012e2.z, 1.0);
    highp vec2 loc_f9579 = ((vec2(loc_012e2.x, loc_012e2.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    int loc_ec55d = (QuantizationParameters.x != 0.0) ? 1 : 2;
    int loc_ed2e2 = loc_ec55d / 2;
    loc_012e2.z = (loc_012e2.z * 0.5) + 0.5;
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
    highp float loc_9af5f;
    loc_9af5f = 0.0;
    highp float loc_72f9e;
    for (int loc_467f0 = 0; loc_467f0 < loc_ec55d; loc_9af5f = loc_72f9e, loc_467f0++)
    {
        loc_72f9e = loc_9af5f;
        highp float loc_8daf8;
        for (int loc_02668 = 0; loc_02668 < loc_ec55d; loc_72f9e = loc_8daf8, loc_02668++)
        {
            highp vec2 loc_fae00 = loc_f9579 + ((vec2(float(loc_02668 - loc_ed2e2) + 0.5, float(loc_467f0 - loc_ed2e2) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            highp vec3 loc_e5a12 = vec3(loc_fae00.x, loc_fae00.y, (DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0) + 1.0);
            if (QuantizationParameters.x != 0.0)
            {
                loc_8daf8 = loc_72f9e + float(textureLod(s_ShadowCascades, loc_e5a12, 0.0).x >= loc_012e2.z);
            }
            else
            {
                highp vec4 loc_1f2f1 = step(vec4(loc_012e2.z), textureGather(s_ShadowCascades, loc_e5a12));
                highp vec2 loc_127fb = fract((loc_e5a12.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_8daf8 = loc_72f9e + mix(mix(loc_1f2f1.w, loc_1f2f1.z, loc_127fb.x), mix(loc_1f2f1.x, loc_1f2f1.y, loc_127fb.x), loc_127fb.y);
            }
        }
    }
    arg_7a26d = loc_9af5f / float(loc_ec55d * loc_ec55d);
}
void func_98953(inout highp vec4 arg_3156b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec3 arg_218ea, inout highp vec3 arg_016ce, inout highp vec3 arg_68e47, inout highp vec3 arg_470f5, inout highp vec2 arg_f36e7, inout highp vec3 arg_81f79, inout highp vec3 arg_58ffc, inout highp vec3 arg_cff01, inout highp float arg_5416d, inout highp float arg_cdb42) {
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
    int loc_a14ca = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    highp mat4 loc_bd26f;
    highp vec3 loc_9d63a;
    highp vec3 loc_0bf4d;
    loc_0bf4d = vec3(0.0);
    loc_9d63a = vec3(0.0);
    loc_bd26f = var_62632;
    highp vec3 loc_f1b97;
    highp vec3 loc_3ac48;
    highp mat4 loc_1a85e;
    highp float loc_f5dfb;
    highp float loc_7a912;
    for (int loc_e68b0 = 0; loc_e68b0 < loc_a14ca; loc_0bf4d = loc_3ac48, loc_9d63a = loc_f1b97, loc_7a912 = loc_f5dfb, loc_bd26f = loc_1a85e, loc_e68b0++)
    {
        highp float loc_f1dc4;
        highp float loc_a416a;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            highp float loc_7b050 = max(dot(arg_218ea, normalize((u_view * DirectionalLightSourceShadowDirection[loc_e68b0]).xyz)), 0.0);
            highp vec3 loc_a89f9 = arg_016ce + ((arg_68e47 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_7b050, 0.0, 1.0));
            int loc_dc137;
            highp vec4 loc_d73c9;
            highp mat4 loc_b250f;
            func_9040f(loc_e68b0, loc_a89f9, loc_b250f, loc_d73c9, loc_dc137, loc_bd26f);
            highp vec4 loc_08b3b = loc_d73c9;
            highp float loc_2f871;
            highp float loc_be413;
            if (loc_dc137 != (-1))
            {
                highp float loc_de50b = ShadowBias[loc_dc137] + (ShadowSlopeBias[loc_dc137] * clamp(sqrt(1.0 - (loc_7b050 * loc_7b050)) / loc_7b050, 0.0, 1.0));
                highp float loc_9a3cf = SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z * length(loc_b250f * vec4(0.0, 0.0, 1.0, 0.0));
                int loc_82d7a = int(DirectionalLightSourceShadowCascadeNumber[loc_e68b0].x);
                highp float loc_47769;
                highp float loc_079c0;
                func_6ab74(loc_82d7a, loc_079c0, loc_47769, loc_dc137, loc_08b3b, loc_9a3cf, loc_de50b);
                highp float loc_ad256;
                if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
                {
                    highp float loc_93efa;
                    func_5fe8d(loc_a89f9, loc_7b050, loc_93efa);
                    loc_ad256 = min(loc_47769, loc_93efa);
                }
                else
                {
                    loc_ad256 = loc_47769;
                }
                bool loc_5d7ab = int(DirectionalLightSourceIsSun[loc_e68b0].x) > 0;
                bool loc_643a4;
                if (loc_5d7ab)
                {
                    loc_643a4 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
                }
                else
                {
                    loc_643a4 = loc_5d7ab;
                }
                highp float loc_7f9a6;
                if (loc_643a4)
                {
                    highp vec4 loc_1a6df = CloudShadowProj * vec4(loc_a89f9, 1.0);
                    highp vec4 loc_aa9b7 = loc_1a6df;
                    loc_aa9b7 = loc_1a6df / vec4(loc_aa9b7.w);
                    loc_aa9b7.z -= ((ShadowBias.x + (ShadowSlopeBias.x * clamp(sqrt(1.0 - (loc_7b050 * loc_7b050)) / loc_7b050, 0.0, 1.0))) / loc_aa9b7.w);
                    highp vec2 loc_aec59 = ((vec2(loc_aa9b7.x, loc_aa9b7.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions.x;
                    int loc_a1fd4;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_a1fd4 = 1;
                    }
                    else
                    {
                        loc_a1fd4 = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z + 0.5), 1, 9);
                    }
                    int loc_52b94 = loc_a1fd4 / 2;
                    loc_aa9b7.z = (loc_aa9b7.z * 0.5) + 0.5;
                    loc_aec59.y += (1.0 - CascadeShadowResolutions.x);
                    highp float loc_ac935;
                    loc_ac935 = 0.0;
                    highp float loc_6f800;
                    for (int loc_2a37e = 0; loc_2a37e < loc_a1fd4; loc_ac935 = loc_6f800, loc_2a37e++)
                    {
                        loc_6f800 = loc_ac935;
                        highp float loc_91ddf;
                        for (int loc_09ee8 = 0; loc_09ee8 < loc_a1fd4; loc_6f800 = loc_91ddf, loc_09ee8++)
                        {
                            highp vec3 loc_d895e = vec3(loc_aec59 + ((vec2(float(loc_09ee8 - loc_52b94) + 0.5, float(loc_2a37e - loc_52b94) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadeShadowResolutions.x), DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0);
                            if (QuantizationParameters.x != 0.0)
                            {
                                loc_91ddf = loc_6f800 + float(textureLod(s_ShadowCascades, loc_d895e, 0.0).x >= loc_aa9b7.z);
                            }
                            else
                            {
                                highp vec4 loc_ef698 = step(vec4(loc_aa9b7.z), textureGather(s_ShadowCascades, loc_d895e));
                                highp vec2 loc_31e95 = fract((loc_d895e.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                loc_91ddf = loc_6f800 + mix(mix(loc_ef698.w, loc_ef698.z, loc_31e95.x), mix(loc_ef698.x, loc_ef698.y, loc_31e95.x), loc_31e95.y);
                            }
                        }
                    }
                    highp float loc_e0cb0 = loc_ac935 / float(loc_a1fd4 * loc_a1fd4);
                    highp float loc_3715f;
                    if (loc_e0cb0 < 1.0)
                    {
                        loc_3715f = min(loc_ad256, max(loc_e0cb0, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                    }
                    else
                    {
                        loc_3715f = loc_ad256;
                    }
                    loc_7f9a6 = loc_3715f;
                }
                else
                {
                    loc_7f9a6 = loc_ad256;
                }
                loc_be413 = loc_079c0;
                loc_2f871 = mix(loc_7f9a6, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_470f5.z));
            }
            else
            {
                loc_be413 = loc_7a912;
                loc_2f871 = 1.0;
            }
            loc_f5dfb = loc_be413;
            loc_1a85e = loc_b250f;
            loc_a416a = loc_be413;
            loc_f1dc4 = loc_2f871;
        }
        else
        {
            loc_f5dfb = loc_7a912;
            loc_1a85e = loc_bd26f;
            loc_a416a = 1.0;
            loc_f1dc4 = 1.0;
        }
        highp vec3 loc_921fd = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_e68b0]).xyz);
        highp vec4 loc_fe4ce = DirectionalLightSourceDiffuseColorAndIlluminance[loc_e68b0];
        highp vec3 loc_49071 = ((DirectionalLightSourceDiffuseColorAndIlluminance[loc_e68b0].xyz * loc_fe4ce.w) * arg_f36e7[loc_e68b0]) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
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
        loc_f1b97 = loc_9d63a + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_218ea, loc_921fd) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_cdb42)) * (loc_b92e1 * vec3(0.3183098733425140380859375))) * loc_f1dc4) + (((loc_b92e1 * vec3(0.3183098733425140380859375)) * (arg_cdb42 * max((dot(-arg_218ea, loc_921fd) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_a416a)) * loc_49071) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_3ac48 = loc_0bf4d + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_f1dc4) * loc_49071) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_9d63a;
    arg_90b60 = loc_0bf4d;
}
void main() {
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
    highp vec4 var_158bd = texture(s_Normal, v_texcoord0);
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
        func_98953(var_8c5b7, var_e520d, var_a53cf, var_b9e03, var_73edc, var_effba, var_92517, var_b51ae, var_98c8c, var_5d51a, var_000c6, var_9c3c2, var_121d0);
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
