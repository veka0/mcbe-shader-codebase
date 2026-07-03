#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - POPULATE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2D s_CausticsTexture;
* - uniform lowp sampler2DArray s_CurrentLightingBuffer;
* - layout(binding = 5, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 6, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform highp sampler2DArray s_PointLightShadowTextureArray;
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
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 CameraUnderwaterAndWaterSurfaceBiasAndFalloff;
* - uniform vec4 CascadeShadowResolutions;
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform mat4 DirectionalLightSourceCausticsViewProj[2];
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
* - uniform mat4 DirectionalLightSourceInvWaterSurfaceViewProj[2];
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
* - uniform mat4 DirectionalLightSourceWaterSurfaceViewProj[2];
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
* - uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex;
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
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform mat4 PrevInvProj;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowQuantizationParameters;
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

layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;
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

layout(binding = 6, std430) buffer s_Lights { Light Lights[]; } var_35f52;
layout(binding = 5, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_57a44;
layout(location = 0, binding = 0, rgba16f) uniform writeonly highp image2DArray s_CurrentLightingBuffer;
uniform highp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
uniform highp sampler2DArray s_PointLightShadowTextureArray;
uniform highp sampler2DArray s_PreviousLightingBuffer;
uniform highp sampler2DArray s_ShadowCascades;
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
uniform vec4 ClusterDimensions;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 ClusterSize;
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
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
uniform vec4 PointLightShadowParams1;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 ShadowBias;
uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
uniform vec4 ShadowPCFWidth;
uniform vec4 ShadowQuantizationParameters;
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
void func_657f0(inout int arg_4b63b, inout float arg_7a26d, inout int arg_463e9, inout vec4 arg_ce1c7) {
    if (arg_4b63b < 0)
    {
        arg_7a26d = 1.0;
        return;
    }
    int loc_2aee1 = clamp(int((ShadowPCFWidth[arg_463e9] * VolumeShadowSettings.x) + 0.5), 1, 9);
    int loc_0ed83 = loc_2aee1 / 2;
    vec2 loc_df7dc = ((vec2(arg_ce1c7.x, arg_ce1c7.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions[arg_463e9];
    float loc_28bbd = (arg_ce1c7.z * 0.5) + 0.5;
    loc_df7dc.y += (1.0 - CascadeShadowResolutions[arg_463e9]);
    float loc_e55e0;
    loc_e55e0 = 0.0;
    float loc_190ec;
    for (int loc_43629 = 0; loc_43629 < loc_2aee1; loc_e55e0 = loc_190ec, loc_43629++)
    {
        loc_190ec = loc_e55e0;
        float loc_c9e88;
        for (int loc_e2f01 = 0; loc_e2f01 < loc_2aee1; loc_190ec = loc_c9e88, loc_e2f01++)
        {
            vec3 loc_828f0 = vec3(loc_df7dc + ((vec2(float(loc_e2f01 - loc_0ed83) + 0.5, float(loc_43629 - loc_0ed83) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSize.x) * CascadeShadowResolutions[arg_463e9]), (float(arg_4b63b) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(arg_463e9));
            vec4 loc_4020e = textureGather(s_ShadowCascades, loc_828f0);
            vec4 loc_bfcf1 = loc_4020e;
            if (ShadowQuantizationParameters.x != 0.0)
            {
                loc_c9e88 = loc_190ec + float(loc_bfcf1.w >= (loc_28bbd - ShadowBias[arg_463e9]));
            }
            else
            {
                vec4 loc_bd102 = step(vec4(loc_28bbd - ShadowBias[arg_463e9]), loc_4020e);
                vec2 loc_4fc5a = fract((loc_828f0.xy * ShadowFilterOffsetAndRangeFarAndMapSize.z) + vec2(0.5));
                loc_c9e88 = loc_190ec + mix(mix(loc_bd102.w, loc_bd102.z, loc_4fc5a.x), mix(loc_bd102.x, loc_bd102.y, loc_4fc5a.x), loc_4fc5a.y);
            }
        }
    }
    arg_7a26d = loc_e55e0 / float(loc_2aee1 * loc_2aee1);
}
void func_559d3(inout vec3 arg_9b0e1, inout float arg_7a26d) {
    vec4 loc_1c259 = PlayerShadowProj * vec4(arg_9b0e1, 1.0);
    loc_1c259.z -= ShadowBias.x;
    loc_1c259.z = min(loc_1c259.z, 1.0);
    vec2 loc_5ae5f = ((vec2(loc_1c259.x, loc_1c259.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    int loc_4e840 = clamp(int((2.0 * VolumeShadowSettings.x) + 0.5), 1, 9);
    int loc_a4d0e = loc_4e840 / 2;
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
    for (int loc_e3b31 = 0; loc_e3b31 < loc_4e840; loc_e55e0 = loc_edd8a, loc_e3b31++)
    {
        loc_edd8a = loc_e55e0;
        float loc_5e275;
        for (int loc_d3328 = 0; loc_d3328 < loc_4e840; loc_edd8a = loc_5e275, loc_d3328++)
        {
            vec2 loc_9d099 = loc_5ae5f + ((vec2(float(loc_d3328 - loc_a4d0e) + 0.5, float(loc_e3b31 - loc_a4d0e) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            vec3 loc_9a8d0 = vec3(loc_9d099.x, loc_9d099.y, (DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0) + 1.0);
            if (ShadowQuantizationParameters.x != 0.0)
            {
                loc_5e275 = loc_edd8a + float(textureLod(s_ShadowCascades, loc_9a8d0, 0.0).x >= loc_1c259.z);
            }
            else
            {
                vec4 loc_8954e = step(vec4(loc_1c259.z), textureGather(s_ShadowCascades, loc_9a8d0));
                vec2 loc_4fc5a = fract((loc_9a8d0.xy * ShadowFilterOffsetAndRangeFarAndMapSize.z) + vec2(0.5));
                loc_5e275 = loc_edd8a + mix(mix(loc_8954e.w, loc_8954e.z, loc_4fc5a.x), mix(loc_8954e.x, loc_8954e.y, loc_4fc5a.x), loc_4fc5a.y);
            }
        }
    }
    arg_7a26d = loc_e55e0 / float(loc_4e840 * loc_4e840);
}
void func_0210e(inout float arg_6def2, inout vec2 arg_3fa1b, inout float arg_d7c97, inout vec3 arg_36c0c, inout vec3 arg_1915d) {
    if (arg_6def2 < arg_3fa1b.x)
    {
        arg_d7c97 = -1.0;
        return;
    }
    if ((arg_6def2 >= arg_3fa1b.x) && (arg_6def2 <= 1.0))
    {
        arg_d7c97 = 0.0;
        return;
    }
    if ((arg_6def2 > 1.0) && (arg_6def2 <= 1.5))
    {
        arg_d7c97 = 1.0;
        return;
    }
    arg_d7c97 = floor((log2(arg_36c0c.z * (-0.666666686534881591796875)) * ((arg_1915d.z - 2.0) / log2(arg_3fa1b.y * 0.666666686534881591796875))) + 2.0);
}
void func_4147b(inout vec3 arg_bfa93, inout vec3 arg_580a2, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    float loc_3b38e = -arg_bfa93.z;
    vec2 loc_0d359 = arg_580a2.xy;
    vec3 loc_29493 = ClusterDimensions.xyz;
    vec2 loc_69b41 = ClusterNearFarWidthHeight.zw;
    vec2 loc_f1d2d = ClusterSize.xy;
    vec2 loc_2a810 = ClusterNearFarWidthHeight.xy;
    float loc_3b169;
    func_0210e(loc_3b38e, loc_2a810, loc_3b169, arg_bfa93, loc_29493);
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
void func_954e5(inout int arg_9fa2f, inout float arg_c05a6, inout vec3 arg_451b8) {
    if (var_35f52.Lights[arg_9fa2f].shadowProbeIndex < 0)
    {
        arg_c05a6 = 1.0;
        return;
    }
    vec3 loc_8c2a1 = arg_451b8 - var_35f52.Lights[arg_9fa2f].position.xyz;
    vec3 loc_6a771 = loc_8c2a1;
    vec3 loc_8b86f = abs(loc_8c2a1);
    vec3 loc_112b2 = vec3(0.0);
    bool loc_ab77c = loc_8b86f.x >= loc_8b86f.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_8b86f.x >= loc_8b86f.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    if (loc_ca7f9)
    {
        loc_8b86f = vec3(loc_8b86f.y, loc_8b86f.z, loc_8b86f.x);
        if (loc_6a771.x > 0.0)
        {
            vec3 loc_8c620 = ((loc_8c2a1 * (1.0 / loc_8c2a1.x)) * 0.5) + vec3(0.5);
            loc_112b2 = vec3(1.0 - loc_8c620.z, loc_8c620.y, 0.0);
        }
        else
        {
            vec3 loc_22496 = ((loc_8c2a1 * (1.0 / dot(loc_8c2a1, vec3(-1.0, 0.0, 0.0)))) * 0.5) + vec3(0.5);
            loc_112b2 = vec3(loc_22496.z, loc_22496.y, 1.0);
        }
    }
    else
    {
        if (loc_8b86f.y >= loc_8b86f.z)
        {
            loc_8b86f = vec3(loc_8b86f.x, loc_8b86f.z, loc_8b86f.y);
            if (loc_6a771.y > 0.0)
            {
                vec3 loc_4a1fc = ((loc_8c2a1 * (1.0 / loc_8c2a1.y)) * 0.5) + vec3(0.5);
                loc_112b2 = vec3(loc_4a1fc.x, 1.0 - loc_4a1fc.z, 2.0);
            }
            else
            {
                vec3 loc_672eb = ((loc_8c2a1 * (1.0 / dot(loc_8c2a1, vec3(0.0, -1.0, 0.0)))) * 0.5) + vec3(0.5);
                loc_112b2 = vec3(loc_672eb.x, loc_672eb.z, 3.0);
            }
        }
        else
        {
            if (loc_6a771.z > 0.0)
            {
                vec3 loc_d03ee = ((loc_8c2a1 * (1.0 / loc_8c2a1.z)) * 0.5) + vec3(0.5);
                loc_112b2 = vec3(loc_d03ee.x, loc_d03ee.y, 4.0);
            }
            else
            {
                vec3 loc_34938 = ((loc_8c2a1 * (1.0 / dot(loc_8c2a1, vec3(0.0, 0.0, -1.0)))) * 0.5) + vec3(0.5);
                loc_112b2 = vec3(1.0 - loc_34938.x, loc_34938.y, 5.0);
            }
        }
    }
    loc_8b86f.z *= (-1.0);
    vec4 loc_6d0fa = PointLightProj * vec4(loc_8b86f, 1.0);
    loc_6d0fa /= vec4(loc_6d0fa.w);
    float loc_12b91;
    loc_12b91 = 0.0;
    float loc_614b8;
    for (int loc_5cb7b = 0; loc_5cb7b < 4; loc_12b91 = loc_614b8, loc_5cb7b++)
    {
        loc_614b8 = loc_12b91;
        float loc_0820f;
        for (int loc_ca850 = 0; loc_ca850 < 4; loc_614b8 = loc_0820f, loc_ca850++)
        {
            vec2 loc_80927 = vec2(float(loc_ca850 - 2) + 0.5, float(loc_5cb7b - 2) + 0.5) * PointLightShadowParams1.w;
            vec3 loc_794de = vec3(loc_112b2.x + loc_80927.x, (1.0 - loc_112b2.y) + loc_80927.y, loc_112b2.z);
            vec3 loc_4dc41 = loc_794de;
            vec3 loc_71092 = loc_794de;
            if (loc_4dc41.y > 1.0)
            {
                switch (int(loc_4dc41.z))
                {
                    case 0:
                    {
                        loc_71092.z = 3.0;
                        loc_71092.x = 2.0 - loc_4dc41.y;
                        loc_71092.y = loc_4dc41.x;
                        break;
                    }
                    case 1:
                    {
                        loc_71092.z = 3.0;
                        loc_71092.x = loc_4dc41.y - 1.0;
                        loc_71092.y = 1.0 - loc_4dc41.x;
                        break;
                    }
                    case 2:
                    {
                        loc_71092.z = 4.0;
                        loc_71092.x = loc_4dc41.x;
                        loc_71092.y = loc_4dc41.y - 1.0;
                        break;
                    }
                    case 3:
                    {
                        loc_71092.z = 5.0;
                        loc_71092.x = 1.0 - loc_4dc41.x;
                        loc_71092.y = 2.0 - loc_4dc41.y;
                        break;
                    }
                    case 4:
                    {
                        loc_71092.z = 3.0;
                        loc_71092.x = loc_4dc41.x;
                        loc_71092.y = loc_4dc41.y - 1.0;
                        break;
                    }
                    case 5:
                    {
                        loc_71092.z = 3.0;
                        loc_71092.x = 1.0 - loc_4dc41.x;
                        loc_71092.y = 2.0 - loc_4dc41.y;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            else
            {
                if (loc_4dc41.y < 0.0)
                {
                    switch (int(loc_4dc41.z))
                    {
                        case 0:
                        {
                            loc_71092.z = 2.0;
                            loc_71092.x = 1.0 + loc_4dc41.y;
                            loc_71092.y = 1.0 - loc_4dc41.x;
                            break;
                        }
                        case 1:
                        {
                            loc_71092.z = 2.0;
                            loc_71092.x = -loc_4dc41.y;
                            loc_71092.y = loc_4dc41.x;
                            break;
                        }
                        case 2:
                        {
                            loc_71092.z = 5.0;
                            loc_71092.x = 1.0 - loc_4dc41.x;
                            loc_71092.y = -loc_4dc41.y;
                            break;
                        }
                        case 3:
                        {
                            loc_71092.z = 4.0;
                            loc_71092.x = loc_4dc41.x;
                            loc_71092.y = 1.0 + loc_4dc41.y;
                            break;
                        }
                        case 4:
                        {
                            loc_71092.z = 2.0;
                            loc_71092.x = loc_4dc41.x;
                            loc_71092.y = 1.0 + loc_4dc41.y;
                            break;
                        }
                        case 5:
                        {
                            loc_71092.z = 2.0;
                            loc_71092.x = 1.0 - loc_4dc41.x;
                            loc_71092.y = -loc_4dc41.y;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            vec2 loc_dbd60 = loc_71092.xy;
            if (loc_dbd60.x > 1.0)
            {
                switch (int(loc_71092.z))
                {
                    case 0:
                    {
                        loc_71092.z = 5.0;
                        loc_71092.x = loc_dbd60.x - 1.0;
                        loc_71092.y = loc_dbd60.y;
                        break;
                    }
                    case 1:
                    {
                        loc_71092.z = 4.0;
                        loc_71092.x = loc_dbd60.x - 1.0;
                        loc_71092.y = loc_dbd60.y;
                        break;
                    }
                    case 2:
                    {
                        loc_71092.z = 0.0;
                        loc_71092.x = 1.0 - loc_dbd60.y;
                        loc_71092.y = loc_dbd60.x - 1.0;
                        break;
                    }
                    case 3:
                    {
                        loc_71092.z = 0.0;
                        loc_71092.x = loc_dbd60.y;
                        loc_71092.y = 2.0 - loc_dbd60.x;
                        break;
                    }
                    case 4:
                    {
                        loc_71092.z = 0.0;
                        loc_71092.x = loc_dbd60.x - 1.0;
                        loc_71092.y = loc_dbd60.y;
                        break;
                    }
                    case 5:
                    {
                        loc_71092.z = 1.0;
                        loc_71092.x = loc_dbd60.x - 1.0;
                        loc_71092.y = loc_dbd60.y;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            else
            {
                if (loc_dbd60.x < 0.0)
                {
                    switch (int(loc_71092.z))
                    {
                        case 0:
                        {
                            loc_71092.z = 4.0;
                            loc_71092.x = 1.0 + loc_dbd60.x;
                            loc_71092.y = loc_dbd60.y;
                            break;
                        }
                        case 1:
                        {
                            loc_71092.z = 5.0;
                            loc_71092.x = 1.0 + loc_dbd60.x;
                            loc_71092.y = loc_dbd60.y;
                            break;
                        }
                        case 2:
                        {
                            loc_71092.z = 1.0;
                            loc_71092.x = loc_dbd60.y;
                            loc_71092.y = -loc_dbd60.x;
                            break;
                        }
                        case 3:
                        {
                            loc_71092.z = 1.0;
                            loc_71092.x = 1.0 - loc_dbd60.y;
                            loc_71092.y = 1.0 + loc_dbd60.x;
                            break;
                        }
                        case 4:
                        {
                            loc_71092.z = 1.0;
                            loc_71092.x = 1.0 + loc_dbd60.x;
                            loc_71092.y = loc_dbd60.y;
                            break;
                        }
                        case 5:
                        {
                            loc_71092.z = 0.0;
                            loc_71092.x = 1.0 + loc_dbd60.x;
                            loc_71092.y = loc_dbd60.y;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            vec3 loc_9ce68 = loc_71092;
            loc_9ce68.z = float(var_35f52.Lights[arg_9fa2f].shadowProbeIndex * 6) + loc_9ce68.z;
            vec4 loc_b25ca = step(vec4(loc_6d0fa.z), textureGather(s_PointLightShadowTextureArray, loc_9ce68));
            vec2 loc_10bfd = fract((loc_9ce68.xy * (1.0 / PointLightShadowParams1.w)) + vec2(0.5));
            loc_0820f = loc_614b8 + mix(mix(loc_b25ca.w, loc_b25ca.z, loc_10bfd.x), mix(loc_b25ca.x, loc_b25ca.y, loc_10bfd.x), loc_10bfd.y);
        }
    }
    arg_c05a6 = loc_12b91 * 0.0625;
}
void func_dca5d(inout int arg_5e661, inout vec3 arg_62394, inout vec3 arg_525e6) {
    if (arg_5e661 < 0)
    {
        arg_62394 = vec3(0.0);
        return;
    }
    vec3 loc_c75ea = var_35f52.Lights[arg_5e661].position.xyz - arg_525e6;
    vec3 loc_757d0 = loc_c75ea;
    float loc_06567;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        float loc_fe53a = (abs(loc_757d0.x) + abs(loc_757d0.y)) + abs(loc_757d0.z);
        loc_06567 = loc_fe53a * loc_fe53a;
    }
    else
    {
        loc_06567 = dot(loc_c75ea, loc_c75ea);
    }
    if (loc_06567 >= (var_35f52.Lights[arg_5e661].position.w * var_35f52.Lights[arg_5e661].position.w))
    {
        arg_62394 = vec3(0.0);
        return;
    }
    float loc_4a238;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        float loc_334de;
        func_954e5(arg_5e661, loc_334de, arg_525e6);
        loc_4a238 = loc_334de;
    }
    else
    {
        loc_4a238 = 1.0;
    }
    if (loc_4a238 <= 0.0)
    {
        arg_62394 = vec3(0.0);
        return;
    }
    float loc_11dd6 = loc_06567 / (var_35f52.Lights[arg_5e661].position.w * var_35f52.Lights[arg_5e661].position.w);
    float loc_f4af9 = clamp(1.0 - (loc_11dd6 * loc_11dd6), 0.0, 1.0);
    float loc_7abdc = (1.0 / max(loc_06567, 9.9999997473787516355514526367188e-05)) * (loc_f4af9 * loc_f4af9);
    float loc_6f7ba;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_6f7ba = loc_7abdc * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_7abdc) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_6f7ba = loc_7abdc;
    }
    arg_62394 = (((var_35f52.Lights[arg_5e661].color.xyz * var_35f52.Lights[arg_5e661].color.w) * loc_6f7ba) * loc_4a238) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_d7ccf(inout vec3 arg_dc0ef, inout vec3 arg_96daa, inout vec3 arg_534d1, inout vec3 arg_154f5, inout float arg_1690a, inout vec3 arg_0a773, inout vec3 arg_be743, inout vec3 arg_9e095) {
    bool loc_9f3ca;
    int loc_9b40b;
    int loc_fbf40;
    func_4147b(arg_dc0ef, arg_96daa, loc_fbf40, loc_9b40b, loc_9f3ca);
    if (!loc_9f3ca)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    vec3 loc_127d4;
    loc_127d4 = vec3(0.0);
    vec3 loc_38b6a;
    for (int loc_bee0c = loc_9b40b; loc_bee0c < loc_fbf40; loc_127d4 = loc_38b6a, loc_bee0c++)
    {
        int loc_0cd1c = int(var_57a44.LightLookupArray[loc_bee0c].lookup);
        if (loc_0cd1c < 0)
        {
            break;
        }
        vec3 loc_c70d5;
        func_dca5d(loc_0cd1c, loc_c70d5, arg_154f5);
        float loc_766aa = (1.0 + (arg_1690a * arg_1690a)) + ((2.0 * arg_1690a) * dot(arg_0a773, normalize((u_view * vec4(var_35f52.Lights[loc_0cd1c].position.xyz, 1.0)).xyz - arg_be743)));
        loc_38b6a = loc_127d4 + ((arg_9e095 * ((0.079577468335628509521484375 * (1.0 - (arg_1690a * arg_1690a))) / (loc_766aa * sqrt(loc_766aa)))) * loc_c70d5);
    }
    arg_534d1 = loc_127d4;
}
void func_262c6() {
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
    vec3 loc_81938;
    if (abs(AmbientContribution.y) > 9.9999997473787516355514526367188e-05)
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
                float loc_5fedd;
                if (loc_e65af != (-1))
                {
                    int loc_c603b = int(DirectionalLightSourceShadowCascadeNumber[loc_ddd6b].x);
                    float loc_53776;
                    func_657f0(loc_c603b, loc_53776, loc_e65af, loc_d1f6d);
                    float loc_33c7f;
                    if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
                    {
                        float loc_0ae52;
                        func_559d3(loc_35d28, loc_0ae52);
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
                    float loc_f6f0f;
                    if (loc_35ca5)
                    {
                        vec4 loc_91a1e = CloudShadowProj * vec4(loc_35d28, 1.0);
                        vec4 loc_57064 = loc_91a1e;
                        loc_57064 = loc_91a1e / vec4(loc_57064.w);
                        loc_57064.z -= (ShadowBias.x / loc_57064.w);
                        vec2 loc_c3492 = ((vec2(loc_57064.x, loc_57064.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions.x;
                        int loc_651a4 = clamp(int((EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * VolumeShadowSettings.x) + 0.5), 1, 9);
                        int loc_53051 = loc_651a4 / 2;
                        loc_57064.z = (loc_57064.z * 0.5) + 0.5;
                        loc_c3492.y += (1.0 - CascadeShadowResolutions.x);
                        float loc_2c1e1;
                        loc_2c1e1 = 0.0;
                        float loc_7f700;
                        for (int loc_0f0ca = 0; loc_0f0ca < loc_651a4; loc_2c1e1 = loc_7f700, loc_0f0ca++)
                        {
                            loc_7f700 = loc_2c1e1;
                            float loc_13c41;
                            for (int loc_bf3e3 = 0; loc_bf3e3 < loc_651a4; loc_7f700 = loc_13c41, loc_bf3e3++)
                            {
                                vec3 loc_66e4b = vec3(loc_c3492 + ((vec2(float(loc_bf3e3 - loc_53051) + 0.5, float(loc_0f0ca - loc_53051) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSize.x) * CascadeShadowResolutions.x), DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0);
                                if (ShadowQuantizationParameters.x != 0.0)
                                {
                                    loc_13c41 = loc_7f700 + float(textureLod(s_ShadowCascades, loc_66e4b, 0.0).x >= loc_57064.z);
                                }
                                else
                                {
                                    vec4 loc_12907 = step(vec4(loc_57064.z), textureGather(s_ShadowCascades, loc_66e4b));
                                    vec2 loc_12a8d = fract((loc_66e4b.xy * ShadowFilterOffsetAndRangeFarAndMapSize.z) + vec2(0.5));
                                    loc_13c41 = loc_7f700 + mix(mix(loc_12907.w, loc_12907.z, loc_12a8d.x), mix(loc_12907.x, loc_12907.y, loc_12a8d.x), loc_12a8d.y);
                                }
                            }
                        }
                        float loc_ecda2 = loc_2c1e1 / float(loc_651a4 * loc_651a4);
                        float loc_c6ba0;
                        if (loc_ecda2 < 1.0)
                        {
                            loc_c6ba0 = min(loc_33c7f, max(loc_ecda2, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                        }
                        else
                        {
                            loc_c6ba0 = loc_33c7f;
                        }
                        loc_f6f0f = loc_c6ba0;
                    }
                    else
                    {
                        loc_f6f0f = loc_33c7f;
                    }
                    loc_5fedd = mix(loc_f6f0f, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSize.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSize.y, -0.0));
                }
                else
                {
                    loc_5fedd = 1.0;
                }
                loc_e5184 = loc_5fedd;
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
        func_d7ccf(loc_2a622, loc_6e675, loc_0e452, loc_35d28, loc_4fe0b, loc_d517c, loc_3ced2, loc_8d3b7);
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
    func_262c6();
}
