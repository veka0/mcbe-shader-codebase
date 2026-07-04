#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - WATER_SURFACE_PASS (not used)
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
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 13, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 14, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 15, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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

#ifdef POINT_LIGHT_SHADING__ON
#extension GL_EXT_texture_cube_map_array : require
#endif
precision mediump float;
precision highp int;
#ifdef POINT_LIGHT_SHADING__ON
struct Light {
    highp vec4 position;
    highp vec4 color;
    int shadowProbeIndex;
    int pad0;
    int pad1;
    int pad2;
};

struct LightData {
    highp float lookup;
};

int var_e7b23;
layout(binding = 15, std430) buffer s_zLights { Light zLights[]; } var_caa57;
layout(binding = 14, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_419d0;
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
uniform highp sampler2D s_EmissiveAmbientLinearRoughness;
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp sampler3D s_SkyAmbientSamples;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
#endif
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
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
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
uniform highp vec4 PointLightDiffuseFadeOutParameters;
uniform highp vec4 PointLightNdLFloor;
uniform highp vec4 PointLightPreCalcValues;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 PointLightSpecularFadeOutParameters;
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
layout(location = 0) out highp vec4 bgfx_FragColor;
void func_dc62c(inout highp float arg_e6305) {
    if (SkySamplesConfig.x > 0.5)
    {
        arg_e6305 = textureLod(s_SkyAmbientSamples, vec3(v_texcoord0.xy, 1.0), 0.0).y;
        return;
    }
    else
    {
        arg_e6305 = 1.0;
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
void func_b2538(inout highp vec4 arg_6739f, inout highp vec3 arg_b6d8c, inout highp vec3 arg_488fe, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_ae81a, inout highp vec3 arg_c7286) {
    bool loc_10906 = DirectionalLightSkyLightHeuristicToggles.x != 0.0;
    bool loc_d0d08;
    if (loc_10906)
    {
        loc_d0d08 = abs(arg_6739f.z) < 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_d0d08 = loc_10906;
    }
    if (loc_d0d08)
    {
        arg_b6d8c = vec3(0.0);
        return;
    }
    highp float loc_7c8be;
    if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
    {
        highp float loc_05e4d = max(dot(arg_488fe, normalize((u_view * DirectionalLightSourceShadowDirection).xyz)), 0.0);
        highp vec3 loc_28854 = arg_adf73 + ((arg_c100b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_05e4d, 0.0, 1.0));
        int loc_40b65 = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
        highp float loc_414cb;
        loc_414cb = 1.0;
        int loc_fdb66;
        highp float loc_077b9;
        for (int loc_018d5 = 0, loc_591f5 = 0; loc_018d5 < loc_40b65; loc_591f5 = loc_fdb66, loc_414cb = loc_077b9, loc_018d5++)
        {
            int loc_8c1cb = min((loc_591f5 + int(CascadesPerSet[loc_018d5])), 8);
            loc_077b9 = loc_414cb;
            loc_fdb66 = loc_591f5;
            int loc_0249d;
            highp float loc_849eb;
            for (; loc_fdb66 < loc_8c1cb; loc_077b9 = loc_849eb, loc_fdb66 = loc_0249d)
            {
                highp vec4 loc_0391e = CascadesShadowProj[loc_fdb66] * vec4(loc_28854, 1.0);
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
                    highp float loc_34935 = clamp(loc_05e4d, loc_49c0e[loc_fdb66], 1.0);
                    highp float loc_bac6a = CascadesParameters[loc_fdb66].y + (CascadesParameters[loc_fdb66].z * (sqrt(1.0 - (loc_34935 * loc_34935)) / loc_34935));
                    int loc_70c69;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_70c69 = 1;
                    }
                    else
                    {
                        loc_70c69 = clamp(int(CascadesParameters[loc_fdb66].w + 0.5), 1, 9);
                    }
                    int loc_960ef = loc_70c69 / 2;
                    highp vec2 loc_63e61 = ((vec2(loc_569e5.x, loc_569e5.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_fdb66].x;
                    highp float loc_6c9d9 = (loc_569e5.z * 0.5) + 0.5;
                    loc_63e61.y += (1.0 - CascadesParameters[loc_fdb66].x);
                    highp float loc_60326;
                    loc_60326 = 0.0;
                    highp float loc_641ba;
                    for (int loc_d663a = 0; loc_d663a < loc_70c69; loc_60326 = loc_641ba, loc_d663a++)
                    {
                        loc_641ba = loc_60326;
                        highp float loc_106c7;
                        for (int loc_07ee5 = 0; loc_07ee5 < loc_70c69; loc_641ba = loc_106c7, loc_07ee5++)
                        {
                            highp vec2 loc_53530 = loc_63e61 + ((vec2(float(loc_07ee5 - loc_960ef) + 0.5, float(loc_d663a - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_fdb66].x);
                            highp vec4 loc_b5d2e = textureGather(s_ShadowCascades, vec3(loc_53530, float(loc_fdb66)));
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
                    loc_0249d = loc_fdb66 + 1;
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
        loc_7c8be = mix(min(loc_414cb, min(loc_55d77, loc_80289)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_ae81a.z));
    }
    else
    {
        loc_7c8be = 1.0;
    }
    highp vec3 loc_d841a = normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz);
    highp vec4 loc_1d9d1 = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp float loc_f4016 = max(dot(arg_488fe, loc_d841a), 0.0);
    highp float loc_c3997 = max(dot(arg_488fe, arg_c7286), 0.0);
    highp vec3 loc_77b0a = normalize(loc_d841a + arg_c7286);
    highp float loc_129b6 = max(arg_6739f.w, 0.0500000007450580596923828125);
    highp float loc_009bf = loc_129b6 * loc_129b6;
    highp float loc_96073 = loc_009bf * loc_009bf;
    highp float loc_206e3 = max(dot(arg_488fe, loc_77b0a), 0.0);
    highp float loc_53226 = (((loc_96073 - 1.0) * loc_206e3) * loc_206e3) + 1.0;
    highp float loc_1c1ce = loc_009bf * 0.5;
    highp float loc_b6403 = clamp(1.0 - max(dot(arg_c7286, loc_77b0a), 0.0), 0.0, 1.0);
    highp float loc_afe8c = loc_b6403 * loc_b6403;
    arg_b6d8c = (((((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((loc_afe8c * loc_afe8c) * loc_b6403))) * (loc_96073 / ((loc_53226 * loc_53226) * 3.1415927410125732421875))) * ((loc_c3997 / (((loc_c3997 * (1.0 - loc_1c1ce)) + loc_1c1ce) + 9.9999997473787516355514526367188e-05)) * (loc_f4016 / (((loc_f4016 * (1.0 - loc_1c1ce)) + loc_1c1ce) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_f4016) * loc_c3997) + 9.9999997473787516355514526367188e-05)) * loc_f4016) * loc_7c8be) * (((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_1d9d1.w) * 1.0) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight.x)) * DiffuseSpecularEmissiveAmbientTermToggles.y;
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
void func_8fc55(inout int arg_0ec26, inout highp float arg_9eee0, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c) {
    if (var_caa57.zLights[arg_0ec26].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        return;
    }
    highp vec3 loc_44ea9 = arg_aee55 - var_caa57.zLights[arg_0ec26].position.xyz;
    highp vec3 loc_b2243 = abs(loc_44ea9);
    bool loc_ab77c = loc_b2243.x >= loc_b2243.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_b2243.x >= loc_b2243.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    if (loc_ca7f9)
    {
        loc_b2243 = vec3(loc_b2243.y, loc_b2243.z, loc_b2243.x);
    }
    else
    {
        if (loc_b2243.y >= loc_b2243.z)
        {
            loc_b2243 = vec3(loc_b2243.x, loc_b2243.z, loc_b2243.y);
        }
    }
    highp vec4 loc_02fd5 = PointLightProj * vec4(loc_b2243, 1.0);
    highp float loc_2f407 = clamp(dot(normalize(-loc_44ea9), normalize(arg_1111c)), PointLightNdLFloor.x, 1.0);
    loc_02fd5.z -= (PointLightShadowParams1.x + (PointLightShadowParams1.y * (sqrt(1.0 - (loc_2f407 * loc_2f407)) / loc_2f407)));
    loc_02fd5 /= vec4(loc_02fd5.w);
    highp vec3 loc_13db4 = loc_44ea9;
    bool loc_fe444 = abs(loc_13db4.y) > abs(loc_13db4.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_13db4.y) > abs(loc_13db4.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_13db4.z *= (-1.0);
    }
    else
    {
        loc_13db4.y *= (-1.0);
    }
    highp float loc_591c8;
    if (((textureLod(s_PointLightShadowTextureArray, vec4(loc_13db4, float(var_caa57.zLights[arg_0ec26].shadowProbeIndex)), 0.0).x * 2.0) - 1.0) >= loc_02fd5.z)
    {
        loc_591c8 = 1.0;
    }
    else
    {
        loc_591c8 = 0.0;
    }
    arg_9eee0 = loc_591c8;
}
void func_046a1(inout int arg_2f306, inout highp float arg_43b7a, inout highp vec3 arg_0a2b9, inout highp vec3 arg_29ac4, inout highp vec3 arg_ab1f6, inout highp vec3 arg_81f82) {
    if (arg_2f306 < 0)
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp vec3 loc_8dfd7 = var_caa57.zLights[arg_2f306].position.xyz - arg_29ac4;
    highp vec3 loc_8cb9b = loc_8dfd7;
    highp float loc_c64bb;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_c64bb = loc_1829d * loc_1829d;
    }
    else
    {
        loc_c64bb = dot(loc_8dfd7, loc_8dfd7);
    }
    if (loc_c64bb >= (var_caa57.zLights[arg_2f306].position.w * var_caa57.zLights[arg_2f306].position.w))
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp float loc_a011d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_1b78e;
        func_8fc55(arg_2f306, loc_1b78e, arg_ab1f6, arg_81f82);
        loc_a011d = loc_1b78e;
    }
    else
    {
        loc_a011d = 1.0;
    }
    highp float loc_4c5a5 = loc_c64bb / ((var_caa57.zLights[arg_2f306].position.w * var_caa57.zLights[arg_2f306].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_fcfce = clamp(1.0 - (loc_4c5a5 * loc_4c5a5), 0.0, 1.0);
    highp float loc_e1ff6 = (1.0 / max(loc_c64bb, 9.9999997473787516355514526367188e-05)) * (loc_fcfce * loc_fcfce);
    highp float loc_ae18a;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_ae18a = loc_e1ff6 * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_e1ff6) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_ae18a = loc_e1ff6;
    }
    arg_43b7a = loc_a011d;
    arg_0a2b9 = (var_caa57.zLights[arg_2f306].color.xyz * var_caa57.zLights[arg_2f306].color.w) * loc_ae18a;
}
void func_7c01f(inout bool arg_9a2b4, inout bool arg_b6724, inout highp vec3 arg_3289d, inout highp vec3 arg_33c3b, inout highp vec3 arg_c5372, inout highp vec3 arg_061f9, inout highp vec4 arg_33915, inout highp vec3 arg_f6a53, inout highp vec3 arg_4f9dc, inout highp vec3 arg_8bccf) {
    if (!(arg_9a2b4 || arg_b6724))
    {
        arg_3289d = vec3(0.0);
        return;
    }
    bool loc_a0bb1;
    int loc_79315;
    int loc_822f5;
    func_06412(arg_33c3b, loc_822f5, loc_79315, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_3289d = vec3(0.0);
        return;
    }
    highp vec3 loc_79fad;
    loc_79fad = vec3(0.0);
    highp vec3 loc_d884d;
    for (int loc_97a60 = loc_79315; loc_97a60 < loc_822f5; loc_79fad = loc_d884d, loc_97a60++)
    {
        int loc_f153e = int(var_419d0.zLightLookupArray[loc_97a60].lookup);
        if (loc_f153e < 0)
        {
            break;
        }
        highp vec3 loc_c1aab = normalize((u_view * vec4(var_caa57.zLights[loc_f153e].position.xyz, 1.0)).xyz - arg_33c3b);
        highp vec3 loc_20211;
        if (arg_b6724)
        {
            highp vec3 loc_a5496;
            if (arg_9a2b4)
            {
                highp float loc_97c1f = max(dot(arg_c5372, loc_c1aab), 0.0);
                highp float loc_207e1 = max(dot(arg_c5372, arg_061f9), 0.0);
                highp vec3 loc_608b6 = normalize(loc_c1aab + arg_061f9);
                highp float loc_167d6 = max(arg_33915.w, 0.0500000007450580596923828125);
                highp float loc_59789 = loc_167d6 * loc_167d6;
                highp float loc_9f4ec = loc_59789 * loc_59789;
                highp float loc_7f729 = max(dot(arg_c5372, loc_608b6), 0.0);
                highp float loc_7a105 = (((loc_9f4ec - 1.0) * loc_7f729) * loc_7f729) + 1.0;
                highp float loc_0e094 = loc_59789 * 0.5;
                highp float loc_caa23 = clamp(1.0 - max(dot(arg_061f9, loc_608b6), 0.0), 0.0, 1.0);
                highp float loc_a19b2 = loc_caa23 * loc_caa23;
                loc_a5496 = ((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((loc_a19b2 * loc_a19b2) * loc_caa23))) * (loc_9f4ec / ((loc_7a105 * loc_7a105) * 3.1415927410125732421875))) * ((loc_207e1 / (((loc_207e1 * (1.0 - loc_0e094)) + loc_0e094) + 9.9999997473787516355514526367188e-05)) * (loc_97c1f / (((loc_97c1f * (1.0 - loc_0e094)) + loc_0e094) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_97c1f) * loc_207e1) + 9.9999997473787516355514526367188e-05)) * loc_97c1f;
            }
            else
            {
                loc_a5496 = vec3(0.0);
            }
            loc_20211 = loc_a5496;
        }
        else
        {
            highp vec3 loc_cd248;
            if (arg_9a2b4)
            {
                highp float loc_fb758 = max(dot(arg_c5372, loc_c1aab), 0.0);
                highp float loc_3c3a6 = max(dot(arg_c5372, arg_061f9), 0.0);
                highp vec3 loc_74f40 = normalize(loc_c1aab + arg_061f9);
                highp float loc_c1447 = max(arg_33915.w, 0.0500000007450580596923828125);
                highp float loc_22daf = loc_c1447 * loc_c1447;
                highp float loc_abdef = loc_22daf * loc_22daf;
                highp float loc_92683 = max(dot(arg_c5372, loc_74f40), 0.0);
                highp float loc_ac620 = (((loc_abdef - 1.0) * loc_92683) * loc_92683) + 1.0;
                highp float loc_8cf9d = loc_22daf * 0.5;
                highp float loc_785f4 = clamp(1.0 - max(dot(arg_061f9, loc_74f40), 0.0), 0.0, 1.0);
                highp float loc_09b3c = loc_785f4 * loc_785f4;
                loc_cd248 = ((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((loc_09b3c * loc_09b3c) * loc_785f4))) * (loc_abdef / ((loc_ac620 * loc_ac620) * 3.1415927410125732421875))) * ((loc_3c3a6 / (((loc_3c3a6 * (1.0 - loc_8cf9d)) + loc_8cf9d) + 9.9999997473787516355514526367188e-05)) * (loc_fb758 / (((loc_fb758 * (1.0 - loc_8cf9d)) + loc_8cf9d) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_fb758) * loc_3c3a6) + 9.9999997473787516355514526367188e-05)) * loc_fb758;
            }
            else
            {
                loc_cd248 = vec3(0.0);
            }
            loc_20211 = loc_cd248;
        }
        highp vec3 loc_e029b;
        highp float loc_2eec8;
        func_046a1(loc_f153e, loc_2eec8, loc_e029b, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_d884d = loc_79fad + (((loc_20211 * loc_2eec8) * loc_e029b) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_3289d = loc_79fad;
}
void func_1a758(inout highp vec3 arg_4f139, inout highp vec3 arg_d5e4d, inout highp vec3 arg_24250, inout highp vec3 arg_b40e7, inout highp vec3 arg_7191d, inout highp vec3 arg_9b157, inout highp vec3 arg_e0647, inout highp vec4 arg_143ce, inout highp vec3 arg_83a2c) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0))
    {
        arg_4f139 = arg_d5e4d;
        return;
    }
    highp vec3 loc_88b27 = arg_24250;
    highp float loc_7639d;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        loc_7639d = (abs(loc_88b27.x) + abs(loc_88b27.y)) + abs(loc_88b27.z);
    }
    else
    {
        loc_7639d = length(arg_24250);
    }
    bool loc_464cb = PointLightSpecularFadeOutParameters.x > 0.0;
    highp float loc_f4966;
    if (loc_464cb)
    {
        loc_f4966 = smoothstep(PointLightSpecularFadeOutParameters.x, PointLightSpecularFadeOutParameters.y, loc_7639d);
    }
    else
    {
        loc_f4966 = 0.0;
    }
    bool loc_49ba4 = !loc_464cb;
    bool loc_a1eb6;
    if (!loc_49ba4)
    {
        loc_a1eb6 = loc_464cb && (loc_7639d < PointLightSpecularFadeOutParameters.y);
    }
    else
    {
        loc_a1eb6 = loc_49ba4;
    }
    bool loc_6ebf5 = PointLightDiffuseFadeOutParameters.x > 0.0;
    bool loc_70859 = !loc_6ebf5;
    bool loc_35c37;
    if (!loc_70859)
    {
        loc_35c37 = loc_6ebf5 && (loc_7639d < PointLightDiffuseFadeOutParameters.y);
    }
    else
    {
        loc_35c37 = loc_70859;
    }
    highp vec3 loc_80145;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_80145 = arg_b40e7;
    }
    else
    {
        loc_80145 = arg_7191d;
    }
    highp vec3 loc_7d0c6;
    func_7c01f(loc_a1eb6, loc_35c37, loc_7d0c6, arg_24250, arg_9b157, arg_e0647, arg_143ce, arg_7191d, loc_80145, arg_83a2c);
    arg_4f139 = arg_d5e4d + (loc_7d0c6 * (1.0 - loc_f4966));
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
    highp vec4 var_1c342 = vec4(v_projPosition.xy + vec2(SubPixelOffset.x, -SubPixelOffset.y), var_b8e9f, 1.0);
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
    highp vec3 var_da92c = (u_invView * vec4(var_3ee7d.xyz, 1.0)).xyz - WorldOrigin.xyz;
    highp vec3 var_c6246 = var_3ee7d.xyz;
    highp vec3 var_a58e2 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_c6246)), normalize(dFdy(var_c6246)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_1cdb8 = mod(var_da92c, vec3(QuantizationParameters.z));
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_c301d = (var_da92c - (var_1cdb8 - (var_a58e2 * dot(var_1cdb8, var_a58e2)))) + WorldOrigin.xyz;
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
    highp vec3 var_73ad8 = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_ba5f8 = normalize((u_view * vec4(var_73ad8, 0.0)).xyz);
    highp vec4 var_922b7 = texture(s_EmissiveAmbientLinearRoughness, v_texcoord0.xy);
    highp float var_1ca06;
    if (var_b8e9f == 1.0)
    {
        highp float var_92116;
        func_dc62c(var_92116);
        var_1ca06 = var_92116;
    }
    else
    {
        var_1ca06 = var_922b7.z;
    }
    highp vec3 var_f29fe = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_1245c = var_20845.xyz;
    highp vec3 var_603d9 = -(var_1245c / vec3(length(var_1245c) + 9.9999997473787516355514526367188e-05));
    highp vec3 var_cd224 = var_1245c;
    highp vec3 var_7ace7;
    if (int(QuantizationParameters.y) > 0)
    {
#ifdef POINT_LIGHT_SHADING__OFF
        var_7ace7 = (var_da92c - (var_1cdb8 - (var_a58e2 * dot(var_1cdb8, var_a58e2)))) + WorldOrigin.xyz;
#endif
#ifdef POINT_LIGHT_SHADING__ON
        var_7ace7 = var_c301d;
#endif
    }
    else
    {
        var_7ace7 = var_f29fe;
    }
    highp vec3 var_c27b4;
    func_b2538(var_922b7, var_c27b4, var_ba5f8, var_7ace7, var_73ad8, var_cd224, var_603d9);
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_5071d;
    func_1a758(var_5071d, var_c27b4, var_1245c, var_c301d, var_f29fe, var_ba5f8, var_603d9, var_922b7, var_73ad8);
#endif
    highp float var_e08b9 = clamp(((var_922b7.z * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_523df = clamp(1.0 - max(dot(var_603d9, var_ba5f8), 0.0), 0.0, 1.0);
    highp float var_b623b = var_523df * var_523df;
    highp vec4 var_eead9 = vec4(0.0, 0.0, 0.0, 1.0);
    highp float var_2748f = var_922b7.y * var_922b7.y;
    highp vec4 var_08c01 = SkyAmbientLightColorIntensity;
    highp float var_2351d = var_922b7.z * var_922b7.z;
#ifdef POINT_LIGHT_SHADING__OFF
    highp vec3 var_bf39f = (((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((var_b623b * var_b623b) * var_523df))) * (1.0 - (((var_e08b9 * var_e08b9) * var_e08b9) * IBLParameters.x))) * max((clamp(vec3(var_2748f + (var_eead9.x * var_eead9.w), (var_2748f * ((((var_2748f * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_eead9.y * var_eead9.w), (var_2748f * (((var_2748f * var_2748f) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_eead9.z * var_eead9.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_2351d * var_2351d) * var_922b7.z, (var_922b7.z * var_922b7.z) * var_922b7.z, CameraLightIntensity.y)) * var_08c01.w), AmbientLightParams.xyz * AmbientLightParams.w)) + var_c27b4;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_bf39f = (((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((var_b623b * var_b623b) * var_523df))) * (1.0 - (((var_e08b9 * var_e08b9) * var_e08b9) * IBLParameters.x))) * max((clamp(vec3(var_2748f + (var_eead9.x * var_eead9.w), (var_2748f * ((((var_2748f * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_eead9.y * var_eead9.w), (var_2748f * (((var_2748f * var_2748f) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_eead9.z * var_eead9.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_2351d * var_2351d) * var_922b7.z, (var_922b7.z * var_922b7.z) * var_922b7.z, CameraLightIntensity.y)) * var_08c01.w), AmbientLightParams.xyz * AmbientLightParams.w)) + var_5071d;
#endif
    highp vec3 var_6d83f = normalize(var_f29fe - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
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
        highp float var_79b3e = clamp((((length(var_1245c) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_79b3e > 0.0)
        {
            highp vec3 var_44083;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_44083 = FogColor.xyz * max(var_d9480, vec3(1.0));
            }
            else
            {
                highp vec4 var_b7ccc = SunColor;
                highp vec4 var_b150c = MoonColor;
                highp vec3 var_89f5b = var_6d83f;
                highp float var_097a5 = smoothstep(FogSkyBlend.z - FogSkyBlend.w, FogSkyBlend.x - FogSkyBlend.w, var_89f5b.y);
                highp float var_6a7f4 = dot(var_6d83f, SunDir.xyz);
                highp float var_0994e = dot(var_6d83f, MoonDir.xyz);
                highp vec3 var_061a3 = var_6d83f;
                highp float var_870fe = smoothstep(FogSkyBlend.y, FogSkyBlend.x - FogSkyBlend.w, var_061a3.y);
                highp float var_3dd79 = clamp(pow(max(var_6a7f4, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_82a52 = clamp(pow(max(var_0994e, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_3a2c2 = 1.809999942779541015625 - (var_3dd79 * 1.7999999523162841796875);
                highp float var_dc465 = 1.809999942779541015625 - (var_82a52 * 1.7999999523162841796875);
                highp vec3 var_55128 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_870fe * var_870fe) * var_870fe, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_b7ccc.w * (0.75 * ((var_6a7f4 * var_6a7f4) + 1.0))) + (var_b150c.w * (0.75 * ((var_0994e * var_0994e) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_097a5 * var_097a5) * var_097a5, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_b7ccc.w) * AtmosphericScattering.y) * var_3dd79) * (0.0361000001430511474609375 / (var_3a2c2 * sqrt(var_3a2c2)))) + ((((MoonColor.xyz * var_b150c.w) * AtmosphericScattering.z) * var_82a52) * (0.0361000001430511474609375 / (var_dc465 * sqrt(var_dc465))))));
                highp vec3 var_9d0d4;
                if (AtmosphericScatteringToggles.w != 0.0)
                {
                    var_9d0d4 = mix(UndergroundFogColor.xyz, var_55128, vec3(max(CameraAmbientContribution.y, var_1ca06)));
                }
                else
                {
                    var_9d0d4 = var_55128;
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
    highp vec4 var_18176 = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_c4a65 = var_18176;
    highp vec4 var_929fb;
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
        var_929fb = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_64811.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_64811.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_929fb = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_3ac5a = var_929fb;
    highp vec4 var_910bf = vec4(var_929fb.xyz + (mix(var_bf39f + (((mix(vec3(0.0), vec3(0.0), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_922b7.x)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_18176.xyz, vec3(var_c4a65.w)) * var_3ac5a.w), 1.0);
    highp vec4 var_e9949 = var_910bf;
    highp vec4 var_eea6e;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec3 var_02f69 = var_910bf.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_eea6e = vec4(var_02f69.x, var_02f69.y, var_02f69.z, var_910bf.w);
    }
    else
    {
        var_eea6e = var_910bf;
    }
    var_e9949 = var_eea6e;
    highp float var_9aa0f = dot(var_603d9, var_ba5f8);
    highp float var_29ef9;
    func_4efb5(var_9aa0f, var_29ef9);
    var_e9949.w = 1.0 - var_29ef9;
    bgfx_FragColor = var_e9949;
}
