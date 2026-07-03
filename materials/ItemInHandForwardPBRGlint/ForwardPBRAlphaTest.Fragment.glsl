#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - FORWARD_PBR_ALPHA_TEST_PASS (not used)
* - FORWARD_PBR_OPAQUE_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF
* - MULTI_COLOR_TINT__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_GlintTexture;
* - layout(binding = 3, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 4, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 CascadeShadowResolutions;
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform vec4 ChangeColor;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ColorBased;
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
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
* - uniform vec4 FogControl;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 GlintColor;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightInvProj;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform mat4 PrevWorld;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowPrecisionRoundingParameters;
* - uniform vec4 ShadowQuantizationParameters;
* - uniform vec4 ShadowSlopeBias;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 Time;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
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

layout(binding = 4, std430) buffer s_Lights { Light Lights[]; } var_f704e;
layout(binding = 3, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_05882;
uniform highp mat4 CloudShadowProj;
uniform highp mat4 DirectionalLightSourceCausticsViewProj[2];
uniform highp mat4 DirectionalLightSourceInvWaterSurfaceViewProj[2];
uniform highp mat4 DirectionalLightSourceShadowInvProj0[2];
uniform highp mat4 DirectionalLightSourceShadowInvProj1[2];
uniform highp mat4 DirectionalLightSourceShadowInvProj2[2];
uniform highp mat4 DirectionalLightSourceShadowInvProj3[2];
uniform highp mat4 DirectionalLightSourceShadowProj0[2];
uniform highp mat4 DirectionalLightSourceShadowProj1[2];
uniform highp mat4 DirectionalLightSourceShadowProj2[2];
uniform highp mat4 DirectionalLightSourceShadowProj3[2];
uniform highp mat4 DirectionalLightSourceWaterSurfaceViewProj[2];
uniform highp mat4 PlayerShadowProj;
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_model[4];
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_proj;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2D s_GlintTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_CausticsTexture;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 BlockLightIndirectSpecularIntensity;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadeShadowResolutions;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
uniform highp vec4 ChangeColor;
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ClusterNearFarWidthHeight;
uniform highp vec4 ClusterSize;
uniform highp vec4 ColorBased;
uniform highp vec4 ConvolutionType;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform highp vec4 DirectionalLightSourceIsSun[2];
uniform highp vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform highp vec4 DirectionalLightSourceShadowDirection[2];
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform highp vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform highp vec4 DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 GlintColor;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 LastSpecularIBLIdx;
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightDiffuseFadeOutParameters;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 PointLightSpecularFadeOutParameters;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 ShadowBias;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform highp vec4 ShadowPCFWidth;
uniform highp vec4 ShadowPrecisionRoundingParameters;
uniform highp vec4 ShadowQuantizationParameters;
uniform highp vec4 ShadowSlopeBias;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 TileLightColor;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 Time;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WaterExtinctionCoefficients;
uniform highp vec4 WaterSurfaceOctaveParameters;
uniform highp vec4 WaterSurfaceParameters;
uniform highp vec4 WaterSurfaceWaveParameters;
uniform highp vec4 WorldOrigin;
in highp vec4 v_color0;
in highp vec4 v_glintUV;
in highp vec4 v_mers;
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
mat4 var_62632;
float var_2ce5b;
int var_e7b23;
float var_5e514;
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
void func_c9a22(inout int arg_9852b, inout highp float arg_7a26d, inout highp float arg_98f56, inout int arg_c1240, inout highp vec4 arg_5b51a, inout highp float arg_af650, inout highp float arg_e6df6) {
    if (arg_9852b < 0)
    {
        arg_7a26d = 1.0;
        arg_98f56 = 1.0;
        return;
    }
    int loc_042af;
    if (ShadowQuantizationParameters.x != 0.0)
    {
        loc_042af = 1;
    }
    else
    {
        loc_042af = clamp(int(ShadowPCFWidth[arg_c1240] + 0.5), 1, 9);
    }
    int loc_ddf3c = loc_042af / 2;
    highp vec2 loc_45a5e = ((vec2(arg_5b51a.x, arg_5b51a.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions[arg_c1240];
    highp float loc_820a9 = (arg_5b51a.z * 0.5) + 0.5;
    loc_45a5e.y += (1.0 - CascadeShadowResolutions[arg_c1240]);
    highp float loc_36d1e;
    highp float loc_76a21;
    loc_76a21 = 0.0;
    loc_36d1e = 0.0;
    highp float loc_4cd6d;
    highp float loc_dcabb;
    for (int loc_0588a = 0; loc_0588a < loc_042af; loc_76a21 = loc_dcabb, loc_36d1e = loc_4cd6d, loc_0588a++)
    {
        loc_dcabb = loc_76a21;
        loc_4cd6d = loc_36d1e;
        highp float loc_c3d98;
        highp float loc_cf9df;
        for (int loc_0b600 = 0; loc_0b600 < loc_042af; loc_dcabb = loc_cf9df, loc_4cd6d = loc_c3d98, loc_0b600++)
        {
            highp vec3 loc_6815f = vec3(loc_45a5e + ((vec2(float(loc_0b600 - loc_ddf3c) + 0.5, float(loc_0588a - loc_ddf3c) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadeShadowResolutions[arg_c1240]), (float(arg_9852b) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(arg_c1240));
            highp vec4 loc_82338 = textureGather(s_ShadowCascades, loc_6815f);
            highp vec4 loc_bbed9 = loc_82338;
            highp vec2 loc_49675 = fract((loc_6815f.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
            highp vec4 loc_0505f = vec4(1.0) - smoothstep(vec4(0.0), vec4(1.0), (vec4(loc_820a9) - loc_82338) * arg_af650);
            highp vec2 loc_f9006 = loc_49675;
            loc_c3d98 = loc_4cd6d + mix(mix(loc_0505f.w, loc_0505f.z, loc_f9006.x), mix(loc_0505f.x, loc_0505f.y, loc_f9006.x), loc_f9006.y);
            if (ShadowQuantizationParameters.x != 0.0)
            {
                loc_cf9df = loc_dcabb + float(loc_bbed9.w >= (loc_820a9 - arg_e6df6));
            }
            else
            {
                highp vec4 loc_27ff4 = step(vec4(loc_820a9 - arg_e6df6), loc_82338);
                highp vec2 loc_18eef = loc_49675;
                loc_cf9df = loc_dcabb + mix(mix(loc_27ff4.w, loc_27ff4.z, loc_18eef.x), mix(loc_27ff4.x, loc_27ff4.y, loc_18eef.x), loc_18eef.y);
            }
        }
    }
    arg_7a26d = loc_36d1e / float(loc_042af * loc_042af);
    arg_98f56 = loc_76a21 / float(loc_042af * loc_042af);
}
void func_54dfd(inout highp vec3 arg_3a8bb, inout highp float arg_642e1, inout highp float arg_7a26d) {
    highp vec4 loc_012e2 = PlayerShadowProj * vec4(arg_3a8bb, 1.0);
    loc_012e2.z -= (ShadowBias.x + (ShadowSlopeBias.x * clamp(sqrt(1.0 - (arg_642e1 * arg_642e1)) / arg_642e1, 0.0, 1.0)));
    loc_012e2.z = min(loc_012e2.z, 1.0);
    highp vec2 loc_f9579 = ((vec2(loc_012e2.x, loc_012e2.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    int loc_cfab6 = (ShadowQuantizationParameters.x != 0.0) ? 1 : 2;
    int loc_ed2e2 = loc_cfab6 / 2;
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
    for (int loc_467f0 = 0; loc_467f0 < loc_cfab6; loc_9af5f = loc_72f9e, loc_467f0++)
    {
        loc_72f9e = loc_9af5f;
        highp float loc_8daf8;
        for (int loc_02668 = 0; loc_02668 < loc_cfab6; loc_72f9e = loc_8daf8, loc_02668++)
        {
            highp vec2 loc_fae00 = loc_f9579 + ((vec2(float(loc_02668 - loc_ed2e2) + 0.5, float(loc_467f0 - loc_ed2e2) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            highp vec3 loc_e5a12 = vec3(loc_fae00.x, loc_fae00.y, (DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0) + 1.0);
            if (ShadowQuantizationParameters.x != 0.0)
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
    arg_7a26d = loc_9af5f / float(loc_cfab6 * loc_cfab6);
}
void func_33e00(inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec3 arg_218ea, inout highp vec3 arg_016ce, inout highp vec3 arg_68e47, inout highp vec3 arg_470f5, inout highp vec2 arg_c288e, inout highp vec3 arg_81f79, inout highp vec4 arg_9647e, inout highp vec3 arg_58ffc, inout highp vec3 arg_df759, inout highp float arg_cdb42) {
    bool loc_10906 = DirectionalLightSkyLightHeuristicToggles.x != 0.0;
    bool loc_050e1;
    if (loc_10906)
    {
        loc_050e1 = abs(TileLightIntensity.y) < 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_050e1 = loc_10906;
    }
    if (loc_050e1)
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
    for (int loc_a5f76 = 0; loc_a5f76 < loc_a14ca; loc_0bf4d = loc_3ac48, loc_9d63a = loc_f1b97, loc_7a912 = loc_f5dfb, loc_bd26f = loc_1a85e, loc_a5f76++)
    {
        highp float loc_f1dc4;
        highp float loc_a416a;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            highp float loc_7b050 = max(dot(arg_218ea, normalize((u_view * DirectionalLightSourceShadowDirection[loc_a5f76]).xyz)), 0.0);
            highp vec3 loc_a89f9 = arg_016ce + ((arg_68e47 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_7b050, 0.0, 1.0));
            int loc_dc137;
            highp vec4 loc_d73c9;
            highp mat4 loc_b250f;
            func_9040f(loc_a5f76, loc_a89f9, loc_b250f, loc_d73c9, loc_dc137, loc_bd26f);
            highp vec4 loc_08b3b = loc_d73c9;
            highp float loc_2f871;
            highp float loc_be413;
            if (loc_dc137 != (-1))
            {
                highp float loc_de50b = ShadowBias[loc_dc137] + (ShadowSlopeBias[loc_dc137] * clamp(sqrt(1.0 - (loc_7b050 * loc_7b050)) / loc_7b050, 0.0, 1.0));
                highp float loc_9a3cf = SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z * length(loc_b250f * vec4(0.0, 0.0, 1.0, 0.0));
                int loc_82d7a = int(DirectionalLightSourceShadowCascadeNumber[loc_a5f76].x);
                highp float loc_47769;
                highp float loc_079c0;
                func_c9a22(loc_82d7a, loc_079c0, loc_47769, loc_dc137, loc_08b3b, loc_9a3cf, loc_de50b);
                highp float loc_ad256;
                if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
                {
                    highp float loc_93efa;
                    func_54dfd(loc_a89f9, loc_7b050, loc_93efa);
                    loc_ad256 = min(loc_47769, loc_93efa);
                }
                else
                {
                    loc_ad256 = loc_47769;
                }
                bool loc_5d7ab = int(DirectionalLightSourceIsSun[loc_a5f76].x) > 0;
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
                    if (ShadowQuantizationParameters.x != 0.0)
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
                            if (ShadowQuantizationParameters.x != 0.0)
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
        highp vec3 loc_791d7;
        if (DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.x != 0.0)
        {
            int loc_1db61 = int(DirectionalLightSourceShadowCascadeNumber[loc_a5f76].x);
            highp float loc_a3c1d;
            if (loc_1db61 >= 0)
            {
                highp vec4 loc_4a6c4 = DirectionalLightSourceWaterSurfaceViewProj[loc_a5f76] * vec4(v_worldPos, 1.0);
                highp vec4 loc_f5c51 = loc_4a6c4;
                highp vec3 loc_18955 = loc_4a6c4.xyz / vec3(loc_f5c51.w);
                highp vec3 loc_14f1d = loc_18955;
                highp vec4 loc_fed43 = DirectionalLightSourceWaterSurfaceViewProj[loc_a5f76] * vec4(v_worldPos, 1.0);
                highp vec4 loc_7aafc = loc_fed43;
                highp vec3 loc_b2964 = loc_fed43.xyz / vec3(loc_7aafc.w);
                loc_b2964.y *= (-1.0);
                highp vec2 loc_e2892 = (loc_b2964.xy + vec2(1.0)) * 0.5;
                highp float loc_c3fee = loc_e2892.x;
                highp float loc_f8aea = loc_e2892.y;
                highp float loc_f8be2 = 1.0 - loc_f8aea;
                loc_e2892 = vec2(loc_c3fee, loc_f8be2);
                highp vec4 loc_b2d02 = texture(s_ShadowCascades, vec3(loc_c3fee, loc_f8be2, float((loc_1db61 * int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w)) + int(DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.y))));
                highp float loc_838c1 = (loc_b2d02.x * 2.0) - 1.0;
                highp float loc_08f0c;
                if (loc_14f1d.z > loc_838c1)
                {
                    loc_08f0c = length((DirectionalLightSourceInvWaterSurfaceViewProj[loc_a5f76] * vec4(loc_18955.xy, loc_838c1, 1.0)).xyz - v_worldPos);
                }
                else
                {
                    loc_08f0c = 0.0;
                }
                loc_a3c1d = loc_08f0c;
            }
            else
            {
                loc_a3c1d = 0.0;
            }
            loc_791d7 = exp((-WaterExtinctionCoefficients.xyz) * loc_a3c1d);
        }
        else
        {
            loc_791d7 = vec3(1.0);
        }
        highp vec3 loc_921fd = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_a5f76]).xyz);
        highp vec4 loc_5b55e = DirectionalLightSourceDiffuseColorAndIlluminance[loc_a5f76];
        highp vec3 loc_cf53a = (((DirectionalLightSourceDiffuseColorAndIlluminance[loc_a5f76].xyz * loc_5b55e.w) * loc_791d7) * arg_c288e[loc_a5f76]) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
        highp float loc_1e1bf = max(dot(arg_218ea, loc_921fd), 0.0);
        highp float loc_af6fd = max(dot(arg_218ea, arg_81f79), 0.0);
        highp float loc_2d61b = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp float loc_c20a0 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp vec3 loc_a125f = normalize(loc_921fd + arg_81f79);
        highp float loc_6004f = max(arg_9647e.z, 0.0500000007450580596923828125);
        highp float loc_a68f1 = loc_6004f * loc_6004f;
        highp float loc_ad517 = loc_a68f1 * loc_a68f1;
        highp float loc_cd10e = max(dot(arg_218ea, loc_a125f), 0.0);
        highp float loc_6be3a = (((loc_ad517 - 1.0) * loc_cd10e) * loc_cd10e) + 1.0;
        highp float loc_ad7fb = loc_a68f1 * 0.5;
        highp float loc_00ee9 = clamp(1.0 - max(dot(arg_81f79, loc_a125f), 0.0), 0.0, 1.0);
        highp float loc_a177b = loc_00ee9 * loc_00ee9;
        highp vec3 loc_d5257 = arg_58ffc + ((vec3(1.0) - arg_58ffc) * ((loc_a177b * loc_a177b) * loc_00ee9));
        highp vec3 loc_17063 = arg_df759 * (1.0 - arg_9647e.x);
        loc_f1b97 = loc_9d63a + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_218ea, loc_921fd) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_cdb42)) * (loc_17063 * vec3(0.3183098733425140380859375))) * loc_f1dc4) + (((loc_17063 * vec3(0.3183098733425140380859375)) * (arg_cdb42 * max((dot(-arg_218ea, loc_921fd) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_a416a)) * loc_cf53a) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_3ac48 = loc_0bf4d + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_f1dc4) * loc_cf53a) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_9d63a;
    arg_90b60 = loc_0bf4d;
}
void func_b9aa9(inout highp float arg_6def2, inout highp vec2 arg_3fa1b, inout highp float arg_d7c97, inout highp vec3 arg_36c0c, inout highp vec3 arg_1915d) {
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
void func_36e28(inout highp vec3 arg_48e40, inout highp vec3 arg_1a26b, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp float loc_28341 = -arg_48e40.z;
    highp vec2 loc_25da3 = (arg_1a26b.xy + vec2(1.0)) * vec2(0.5);
    highp vec3 loc_fd394 = ClusterDimensions.xyz;
    highp vec2 loc_703d4 = ClusterNearFarWidthHeight.zw;
    highp vec2 loc_d7b5c = ClusterSize.xy;
    highp vec2 loc_909cb = ClusterNearFarWidthHeight.xy;
    highp float loc_5de3f;
    func_b9aa9(loc_28341, loc_909cb, loc_5de3f, arg_48e40, loc_fd394);
    highp vec3 loc_60667 = vec3(floor((loc_25da3.x * loc_703d4.x) / loc_d7b5c.x), floor((loc_25da3.y * loc_703d4.y) / loc_d7b5c.y), loc_5de3f);
    bool loc_ce27d = loc_60667.x < 0.0;
    bool loc_f15a5;
    if (!loc_ce27d)
    {
        loc_f15a5 = loc_60667.y < 0.0;
    }
    else
    {
        loc_f15a5 = loc_ce27d;
    }
    bool loc_7bab6;
    if (!loc_f15a5)
    {
        loc_7bab6 = loc_60667.z < 0.0;
    }
    else
    {
        loc_7bab6 = loc_f15a5;
    }
    bool loc_a526b;
    if (!loc_7bab6)
    {
        loc_a526b = loc_60667.x >= ClusterDimensions.x;
    }
    else
    {
        loc_a526b = loc_7bab6;
    }
    bool loc_6d7c9;
    if (!loc_a526b)
    {
        loc_6d7c9 = loc_60667.y >= ClusterDimensions.y;
    }
    else
    {
        loc_6d7c9 = loc_a526b;
    }
    bool loc_fc058;
    if (!loc_6d7c9)
    {
        loc_fc058 = loc_60667.z >= ClusterDimensions.z;
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
    int loc_14533 = int((loc_60667.x + (loc_60667.y * ClusterDimensions.x)) + ((loc_60667.z * ClusterDimensions.x) * ClusterDimensions.y)) * int(ClusterDimensions.w);
    arg_e45b8 = loc_14533 + int(ClusterDimensions.w);
    arg_fadf1 = loc_14533;
    arg_d7f4c = true;
}
void func_2bf5a(inout int arg_60bb3, inout highp float arg_9eee0, inout highp float arg_6b488, inout highp vec3 arg_0623c, inout highp vec3 arg_147a6, inout highp float arg_77c90) {
    if (var_f704e.Lights[arg_60bb3].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        arg_6b488 = 1.0;
        return;
    }
    highp vec3 loc_8d02b = arg_0623c - var_f704e.Lights[arg_60bb3].position.xyz;
    highp vec3 loc_0b3e9 = abs(loc_8d02b);
    bool loc_ab77c = loc_0b3e9.x >= loc_0b3e9.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_0b3e9.x >= loc_0b3e9.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    if (loc_ca7f9)
    {
        loc_0b3e9 = vec3(loc_0b3e9.y, loc_0b3e9.z, loc_0b3e9.x);
    }
    else
    {
        if (loc_0b3e9.y >= loc_0b3e9.z)
        {
            loc_0b3e9 = vec3(loc_0b3e9.x, loc_0b3e9.z, loc_0b3e9.y);
        }
    }
    highp vec4 loc_96f5f = PointLightProj * vec4(loc_0b3e9, 1.0);
    highp float loc_2b08f = dot(normalize(-loc_8d02b), normalize(arg_147a6));
    loc_96f5f.z -= (PointLightShadowParams1.x + (PointLightShadowParams1.y * clamp(sqrt(1.0 - (loc_2b08f * loc_2b08f)) / loc_2b08f, 0.0, 1.0)));
    loc_96f5f /= vec4(loc_96f5f.w);
    highp vec3 loc_778fd = loc_8d02b;
    bool loc_fe444 = abs(loc_778fd.y) > abs(loc_778fd.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_778fd.y) > abs(loc_778fd.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_778fd.z *= (-1.0);
    }
    else
    {
        loc_778fd.y *= (-1.0);
    }
    highp float loc_4c50b = (textureLod(s_PointLightShadowTextureArray, vec4(loc_778fd, float(var_f704e.Lights[arg_60bb3].shadowProbeIndex)), 0.0).x * 2.0) - 1.0;
    highp float loc_591c8;
    if (loc_4c50b >= loc_96f5f.z)
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
        highp vec4 loc_932a9 = PointLightInvProj * vec4(loc_96f5f.xy, loc_4c50b, 1.0);
        highp vec4 loc_85f94 = loc_932a9;
        highp float loc_0585d = loc_85f94.w;
        highp vec3 loc_6d5dc = loc_932a9.xyz / vec3(loc_0585d);
        loc_85f94 = vec4(loc_6d5dc.x, loc_6d5dc.y, loc_6d5dc.z, loc_932a9.w);
        loc_d7fd8 = 1.0 - smoothstep(0.0, 1.0, (length(loc_0b3e9) - length(loc_6d5dc.xyz)) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z);
    }
    else
    {
        loc_d7fd8 = 1.0;
    }
    arg_9eee0 = loc_d7fd8;
    arg_6b488 = loc_591c8;
}
void func_2c6c7(inout highp vec4 arg_86e96, inout int arg_3df6f, inout highp float arg_43b7a, inout highp float arg_7f337, inout highp vec3 arg_24936, inout highp vec3 arg_f6a53, inout highp vec3 arg_4f9dc, inout highp float arg_8bccf) {
    arg_86e96 = vec4(0.0);
    if (arg_3df6f < 0)
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_24936 = vec3(0.0);
        return;
    }
    highp vec3 loc_569de = var_f704e.Lights[arg_3df6f].position.xyz - v_worldPos;
    highp vec3 loc_8cb9b = loc_569de;
    highp float loc_4343f;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_4343f = loc_1829d * loc_1829d;
    }
    else
    {
        loc_4343f = dot(loc_569de, loc_569de);
    }
    if (loc_4343f >= (var_f704e.Lights[arg_3df6f].position.w * var_f704e.Lights[arg_3df6f].position.w))
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_24936 = vec3(0.0);
        return;
    }
    highp float loc_cddfe;
    highp float loc_a011d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_412fd;
        highp float loc_b2a04;
        func_2bf5a(arg_3df6f, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_a011d = loc_b2a04;
        loc_cddfe = loc_412fd;
    }
    else
    {
        loc_a011d = 1.0;
        loc_cddfe = 1.0;
    }
    highp float loc_fd676 = loc_4343f / ((var_f704e.Lights[arg_3df6f].position.w * var_f704e.Lights[arg_3df6f].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_fcfce = clamp(1.0 - (loc_fd676 * loc_fd676), 0.0, 1.0);
    highp float loc_e1ff6 = (1.0 / max(loc_4343f, 9.9999997473787516355514526367188e-05)) * (loc_fcfce * loc_fcfce);
    highp float loc_a0a0b;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_a0a0b = loc_e1ff6 * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_e1ff6) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_a0a0b = loc_e1ff6;
    }
    if (loc_cddfe > 0.0)
    {
        highp vec3 loc_e1408 = var_f704e.Lights[arg_3df6f].color.xyz * loc_a0a0b;
        arg_86e96 = vec4(loc_e1408.x, loc_e1408.y, loc_e1408.z, arg_86e96.w);
        arg_86e96.w = 1.0 - (loc_4343f / ((var_f704e.Lights[arg_3df6f].position.w * var_f704e.Lights[arg_3df6f].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_24936 = ((var_f704e.Lights[arg_3df6f].color.xyz * var_f704e.Lights[arg_3df6f].color.w) * loc_a0a0b) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_9596a(inout bool arg_9a2b4, inout bool arg_b6724, inout highp vec3 arg_3289d, inout highp vec3 arg_98547, inout highp vec4 arg_33e52, inout highp vec3 arg_dc0ef, inout highp vec3 arg_96daa, inout highp vec3 arg_89c41, inout highp vec3 arg_e4e64, inout highp vec3 arg_061f9, inout highp vec4 arg_0791b, inout highp vec3 arg_04538, inout highp vec3 arg_ef8ef, inout highp float arg_105b9, inout highp vec3 arg_5a8cd, inout highp vec3 arg_4fa31) {
    highp vec4 loc_fa2ec = vec4(0.0);
    if (!(arg_9a2b4 || arg_b6724))
    {
        arg_3289d = vec3(0.0);
        arg_98547 = vec3(0.0);
        arg_33e52 = loc_fa2ec;
        return;
    }
    bool loc_9f3ca;
    int loc_2aee5;
    int loc_9d2b5;
    func_36e28(arg_dc0ef, arg_96daa, loc_9d2b5, loc_2aee5, loc_9f3ca);
    if (!loc_9f3ca)
    {
        arg_3289d = vec3(0.0);
        arg_98547 = vec3(0.0);
        arg_33e52 = loc_fa2ec;
        return;
    }
    int loc_23246;
    highp vec3 loc_33c65;
    highp vec3 loc_983e3;
    loc_983e3 = vec3(0.0);
    loc_33c65 = vec3(0.0);
    loc_23246 = 0;
    int loc_62c27;
    highp vec3 loc_ed2f2;
    highp vec3 loc_7c75a;
    highp vec4 loc_0944f;
    for (int loc_0ad25 = loc_2aee5; loc_0ad25 < loc_9d2b5; loc_983e3 = loc_7c75a, loc_33c65 = loc_ed2f2, loc_23246 = loc_62c27, loc_0ad25++)
    {
        int loc_fb87b = int(var_05882.LightLookupArray[loc_0ad25].lookup);
        if (loc_fb87b < 0)
        {
            break;
        }
        highp vec3 loc_8c356 = normalize((u_view * vec4(var_f704e.Lights[loc_fb87b].position.xyz, 1.0)).xyz - arg_89c41);
        highp vec3 loc_6691c;
        highp vec3 loc_07fc6;
        highp vec3 loc_20211;
        if (arg_b6724)
        {
            highp vec3 loc_6cd2d;
            highp vec3 loc_577c9;
            highp vec3 loc_0a326;
            if (arg_9a2b4)
            {
                highp float loc_dad67 = max(dot(arg_e4e64, loc_8c356), 0.0);
                highp float loc_237eb = max(dot(arg_e4e64, arg_061f9), 0.0);
                highp float loc_57238 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp float loc_2e0cd = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp vec3 loc_608b6 = normalize(loc_8c356 + arg_061f9);
                highp float loc_598a0 = max(arg_0791b.z, 0.0500000007450580596923828125);
                highp float loc_59789 = loc_598a0 * loc_598a0;
                highp float loc_30f4c = loc_59789 * loc_59789;
                highp float loc_7f729 = max(dot(arg_e4e64, loc_608b6), 0.0);
                highp float loc_15617 = (((loc_30f4c - 1.0) * loc_7f729) * loc_7f729) + 1.0;
                highp float loc_fabe5 = loc_59789 * 0.5;
                highp float loc_c2dc6 = clamp(1.0 - max(dot(arg_061f9, loc_608b6), 0.0), 0.0, 1.0);
                highp float loc_66601 = loc_c2dc6 * loc_c2dc6;
                highp vec3 loc_1800c = arg_04538 + ((vec3(1.0) - arg_04538) * ((loc_66601 * loc_66601) * loc_c2dc6));
                highp vec3 loc_3fba7 = arg_ef8ef * (1.0 - arg_0791b.x);
                loc_0a326 = (((loc_1800c * (loc_30f4c / ((loc_15617 * loc_15617) * 3.1415927410125732421875))) * ((loc_237eb / (((loc_237eb * (1.0 - loc_fabe5)) + loc_fabe5) + 9.9999997473787516355514526367188e-05)) * (loc_dad67 / (((loc_dad67 * (1.0 - loc_fabe5)) + loc_fabe5) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_dad67) * loc_237eb) + 9.9999997473787516355514526367188e-05)) * loc_dad67;
                loc_577c9 = (loc_3fba7 * vec3(0.3183098733425140380859375)) * (arg_105b9 * max((dot(-arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2e0cd * loc_2e0cd), 0.0));
                loc_6cd2d = ((vec3(1.0) - loc_1800c) * mix(loc_dad67, max((dot(arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_57238 * loc_57238), 0.0), arg_105b9)) * (loc_3fba7 * vec3(0.3183098733425140380859375));
            }
            else
            {
                highp float loc_36134 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp float loc_0a512 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp vec3 loc_37b65 = arg_ef8ef * (1.0 - arg_0791b.x);
                loc_0a326 = vec3(0.0);
                loc_577c9 = (loc_37b65 * vec3(0.3183098733425140380859375)) * (arg_105b9 * max((dot(-arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_0a512 * loc_0a512), 0.0));
                loc_6cd2d = (loc_37b65 * vec3(0.3183098733425140380859375)) * mix(max(dot(arg_e4e64, loc_8c356), 0.0), max((dot(arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_36134 * loc_36134), 0.0), arg_105b9);
            }
            loc_20211 = loc_0a326;
            loc_07fc6 = loc_577c9;
            loc_6691c = loc_6cd2d;
        }
        else
        {
            highp vec3 loc_d6eaa;
            if (arg_9a2b4)
            {
                highp float loc_58d66 = max(dot(arg_e4e64, loc_8c356), 0.0);
                highp float loc_697ca = max(dot(arg_e4e64, arg_061f9), 0.0);
                highp vec3 loc_74f40 = normalize(loc_8c356 + arg_061f9);
                highp float loc_4d9a7 = max(arg_0791b.z, 0.0500000007450580596923828125);
                highp float loc_22daf = loc_4d9a7 * loc_4d9a7;
                highp float loc_d671e = loc_22daf * loc_22daf;
                highp float loc_92683 = max(dot(arg_e4e64, loc_74f40), 0.0);
                highp float loc_d2f7c = (((loc_d671e - 1.0) * loc_92683) * loc_92683) + 1.0;
                highp float loc_1faff = loc_22daf * 0.5;
                highp float loc_b0056 = clamp(1.0 - max(dot(arg_061f9, loc_74f40), 0.0), 0.0, 1.0);
                highp float loc_feb30 = loc_b0056 * loc_b0056;
                loc_d6eaa = ((((arg_04538 + ((vec3(1.0) - arg_04538) * ((loc_feb30 * loc_feb30) * loc_b0056))) * (loc_d671e / ((loc_d2f7c * loc_d2f7c) * 3.1415927410125732421875))) * ((loc_697ca / (((loc_697ca * (1.0 - loc_1faff)) + loc_1faff) + 9.9999997473787516355514526367188e-05)) * (loc_58d66 / (((loc_58d66 * (1.0 - loc_1faff)) + loc_1faff) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_58d66) * loc_697ca) + 9.9999997473787516355514526367188e-05)) * loc_58d66;
            }
            else
            {
                loc_d6eaa = vec3(0.0);
            }
            loc_20211 = loc_d6eaa;
            loc_07fc6 = vec3(0.0);
            loc_6691c = vec3(0.0);
        }
        loc_62c27 = loc_23246 + 1;
        highp vec3 loc_d78ed;
        highp float loc_43c35;
        highp float loc_c6492;
        func_2c6c7(loc_0944f, loc_fb87b, loc_c6492, loc_43c35, loc_d78ed, arg_5a8cd, arg_4fa31, arg_105b9);
        loc_fa2ec += loc_0944f;
        loc_ed2f2 = loc_33c65 + ((((loc_6691c * loc_43c35) + (loc_07fc6 * loc_c6492)) * loc_d78ed) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_7c75a = loc_983e3 + (((loc_20211 * loc_43c35) * loc_d78ed) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    if (loc_23246 > 0)
    {
        highp vec3 loc_6dcb8 = loc_fa2ec.xyz / vec3(float(loc_23246));
        loc_fa2ec = vec4(loc_6dcb8.x, loc_6dcb8.y, loc_6dcb8.z, loc_fa2ec.w);
        loc_fa2ec.w /= float(loc_23246);
    }
    arg_3289d = loc_33c65;
    arg_98547 = loc_983e3;
    arg_33e52 = loc_fa2ec;
}
void func_59d20(inout highp vec4 arg_f362c, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec4 loc_7dca1 = vec4(0.0, 0.0, 0.0, 1.0);
    highp float loc_2178c = TileLightIntensity.x * TileLightIntensity.x;
    highp vec3 loc_bfffc = (((AmbientLightParams.xyz * AmbientLightParams.w) * (1.0 - TileLightIntensity.x)) + (((clamp(vec3(loc_2178c + (loc_7dca1.x * loc_7dca1.w), (loc_2178c * ((((loc_2178c * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_7dca1.y * loc_7dca1.w), (loc_2178c * (((loc_2178c * loc_2178c) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_7dca1.z * loc_7dca1.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x) * TileLightIntensity.x)) * arg_f362c.x;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_bfffc, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_bfffc, 1.0);
}
void func_fa624(inout highp vec4 arg_f362c, inout highp vec4 arg_85834) {
    highp vec4 loc_7dca1 = vec4(0.0, 0.0, 0.0, 1.0);
    highp float loc_2178c = TileLightIntensity.x * TileLightIntensity.x;
    highp vec3 loc_37908 = (((AmbientLightParams.xyz * AmbientLightParams.w) * (1.0 - TileLightIntensity.x)) + (((clamp(vec3(loc_2178c + (loc_7dca1.x * loc_7dca1.w), (loc_2178c * ((((loc_2178c * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_7dca1.y * loc_7dca1.w), (loc_2178c * (((loc_2178c * loc_2178c) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_7dca1.z * loc_7dca1.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x) * TileLightIntensity.x)) * arg_f362c.x;
    if (0.0 >= dot(loc_37908, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_37908, 1.0);
}
void main() {
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_6f02f = v_color0;
#endif
    highp vec4 var_e7d71 = v_mers;
    highp vec3 var_fde9e = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_27c73 = vec4(var_fde9e.x, var_fde9e.y, var_fde9e.z, vec4(1.0).w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec2 var_e2e9b = var_fde9e.xy;
#endif
    highp vec4 var_52763 = (GlintColor * (texture(s_GlintTexture, fract(v_glintUV.xy)).xyzx + texture(s_GlintTexture, fract(v_glintUV.zw)).xyzx)) * TileLightColor;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_a09e5 = vec4(var_52763.xyz * var_52763.xyz, abs(var_52763.w)) + vec4(mix(mix(var_27c73, var_27c73 * ChangeColor, vec4(var_6f02f.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w)), 0.0);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_a09e5 = vec4(var_52763.xyz * var_52763.xyz, abs(var_52763.w)) + vec4(mix(mix((var_fde9e.xxx * ChangeColor.xyz).xyz, var_fde9e.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_e2e9b.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)), 0.0);
#endif
    var_a09e5.w = 1.0;
    highp vec4 var_b580a = var_a09e5;
    if (var_b580a.w < 0.5)
    {
        discard;
    }
    highp vec3 var_509ec = pow(max(var_a09e5.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
    highp vec4 var_9f386 = u_view * (u_model[0] * vec4(v_worldPos, 1.0));
    highp vec4 var_e87e0 = u_proj * var_9f386;
    highp vec4 var_b8928 = var_e87e0;
    highp vec3 var_1b091 = var_e87e0.xyz / vec3(var_b8928.w);
    highp vec4 var_89669 = vec4(normalize(v_normal), 1.0);
    highp vec3 var_566b2 = var_9f386.xyz;
    highp vec3 var_71ab1 = var_89669.xyz;
    highp vec3 var_3b587 = (u_view * var_89669).xyz;
    highp vec3 var_7e3f5 = vec3(0.039999999105930328369140625 * (1.0 - var_e7d71.x)) + (var_509ec * var_e7d71.x);
    highp float var_49182;
    if (CausticsParameters.x != 0.0)
    {
        int var_73b1b = int(DirectionalLightSourceShadowCascadeNumber[0].x);
        bool var_98743;
        if (var_73b1b >= 0)
        {
            highp vec4 var_ab7bf = DirectionalLightSourceWaterSurfaceViewProj[0] * vec4(v_worldPos, 1.0);
            highp vec4 var_412ca = var_ab7bf;
            highp vec3 var_d9d7f = var_ab7bf.xyz / vec3(var_412ca.w);
            highp vec4 var_1342d = DirectionalLightSourceWaterSurfaceViewProj[0] * vec4(v_worldPos, 1.0);
            highp vec4 var_e4630 = var_1342d;
            highp vec3 var_f4c6b = var_1342d.xyz / vec3(var_e4630.w);
            var_f4c6b.y *= (-1.0);
            highp vec2 var_331e7 = (var_f4c6b.xy + vec2(1.0)) * 0.5;
            highp float var_9ae35 = var_331e7.x;
            highp float var_3ff4b = var_331e7.y;
            highp float var_23b33 = 1.0 - var_3ff4b;
            var_331e7 = vec2(var_9ae35, var_23b33);
            bool var_28cea;
            if (var_d9d7f.z > ((texture(s_ShadowCascades, vec3(var_9ae35, var_23b33, float((var_73b1b * int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w)) + int(DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.y)))).x * 2.0) - 1.0))
            {
                var_28cea = true;
            }
            else
            {
                var_28cea = false;
            }
            var_98743 = var_28cea;
        }
        else
        {
            var_98743 = false;
        }
        highp float var_ac788;
        if (var_98743)
        {
            highp vec4 var_87b1f = DirectionalLightSourceCausticsViewProj[0] * vec4(v_worldPos - WorldOrigin.xyz, 1.0);
            highp vec4 var_314a4 = var_87b1f;
            highp vec3 var_3e72a = var_87b1f.xyz / vec3(var_314a4.w);
            var_3e72a.y *= (-1.0);
            highp vec2 var_9b904 = (var_3e72a.xy + vec2(1.0)) * 0.5;
            highp float var_74cec = var_9b904.x;
            highp float var_83bc9 = var_9b904.y;
            highp vec2 var_7c780 = vec2(var_74cec, 1.0 - var_83bc9);
            var_9b904 = var_7c780;
            highp vec2 var_76b19 = var_7c780 * CausticsParameters.y;
            highp float var_3e30b;
            if (CausticsTextureParameters.x != 0.0)
            {
                highp float var_135a8 = var_76b19.x;
                highp float var_6a7fe = var_76b19.x;
                highp float var_63ebc = var_135a8 - floor(var_6a7fe);
                highp float var_d5fea = var_76b19.y;
                highp float var_efc51 = var_76b19.y;
                highp float var_a12ce = var_d5fea - floor(var_efc51);
                var_76b19 = vec2(var_63ebc, var_a12ce);
                var_3e30b = texture(s_CausticsTexture, vec3(var_63ebc, var_a12ce, CausticsTextureParameters.y)).x * 2.0;
            }
            else
            {
                highp float var_25f77;
                highp float var_879d8;
                highp vec2 var_e71da;
                var_e71da = var_76b19;
                var_879d8 = 0.0;
                var_25f77 = 0.0;
                highp float var_57178;
                highp float var_fcdcc;
                highp vec2 var_4c67a;
                highp float var_7f51d;
                highp float var_385fa;
                highp float var_7620f;
                highp float var_ae16d;
                uint var_0f999 = 0u;
                highp float var_12e07 = 0.0;
                highp float var_a026e = WaterSurfaceWaveParameters.x;
                highp float var_4d1ae = WaterSurfaceParameters.x;
                highp float var_3b488 = 1.0;
                for (; var_0f999 < uint(WaterSurfaceParameters.y); var_3b488 = var_7f51d, var_4d1ae = var_385fa, var_e71da = var_4c67a, var_a026e = var_7620f, var_12e07 = var_ae16d, var_879d8 = var_fcdcc, var_25f77 = var_57178, var_0f999++)
                {
                    highp vec2 var_fbb0e = vec2(sin(var_12e07), cos(var_12e07));
                    highp float var_c3add = (dot(var_fbb0e, var_e71da) * var_4d1ae) + (Time.x * var_a026e);
                    highp float var_8e092 = pow((sin(var_c3add) + 1.0) * 0.5, WaterSurfaceWaveParameters.y);
                    highp vec2 var_c9741 = vec2(var_8e092, (var_8e092 * cos(var_c3add)) * (-1.0));
                    var_57178 = var_25f77 + (var_c9741.x * var_3b488);
                    var_fcdcc = var_879d8 + var_3b488;
                    var_4c67a = var_e71da + (((var_fbb0e * var_c9741.y) * var_3b488) * WaterSurfaceOctaveParameters.x);
                    var_7f51d = mix(var_3b488, 0.0, WaterSurfaceOctaveParameters.y);
                    var_385fa = var_4d1ae * WaterSurfaceOctaveParameters.z;
                    var_7620f = var_a026e * WaterSurfaceOctaveParameters.w;
                    var_ae16d = var_12e07 + 1.39900004863739013671875;
                }
                var_3e30b = var_25f77 / var_879d8;
            }
            var_ac788 = pow(var_3e30b, float(int(CausticsParameters.z))) * float(int(CausticsParameters.z) + 1);
        }
        else
        {
            var_ac788 = 1.0;
        }
        var_49182 = var_ac788;
    }
    else
    {
        var_49182 = 1.0;
    }
    highp float var_280ef;
    if (CausticsParameters.x != 0.0)
    {
        int var_9531b = int(DirectionalLightSourceShadowCascadeNumber[1].x);
        bool var_61d45;
        if (var_9531b >= 0)
        {
            highp vec4 var_b32d4 = DirectionalLightSourceWaterSurfaceViewProj[1] * vec4(v_worldPos, 1.0);
            highp vec4 var_3dcc5 = var_b32d4;
            highp vec3 var_e4a33 = var_b32d4.xyz / vec3(var_3dcc5.w);
            highp vec4 var_a39f0 = DirectionalLightSourceWaterSurfaceViewProj[1] * vec4(v_worldPos, 1.0);
            highp vec4 var_307c8 = var_a39f0;
            highp vec3 var_e810f = var_a39f0.xyz / vec3(var_307c8.w);
            var_e810f.y *= (-1.0);
            highp vec2 var_7c120 = (var_e810f.xy + vec2(1.0)) * 0.5;
            highp float var_9f33e = var_7c120.x;
            highp float var_c811a = var_7c120.y;
            highp float var_de214 = 1.0 - var_c811a;
            var_7c120 = vec2(var_9f33e, var_de214);
            bool var_7ae94;
            if (var_e4a33.z > ((texture(s_ShadowCascades, vec3(var_9f33e, var_de214, float((var_9531b * int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w)) + int(DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.y)))).x * 2.0) - 1.0))
            {
                var_7ae94 = true;
            }
            else
            {
                var_7ae94 = false;
            }
            var_61d45 = var_7ae94;
        }
        else
        {
            var_61d45 = false;
        }
        highp float var_7e3b5;
        if (var_61d45)
        {
            highp vec4 var_d007d = DirectionalLightSourceCausticsViewProj[1] * vec4(v_worldPos - WorldOrigin.xyz, 1.0);
            highp vec4 var_f6ea6 = var_d007d;
            highp vec3 var_a60c8 = var_d007d.xyz / vec3(var_f6ea6.w);
            var_a60c8.y *= (-1.0);
            highp vec2 var_5f3df = (var_a60c8.xy + vec2(1.0)) * 0.5;
            highp float var_b4854 = var_5f3df.x;
            highp float var_f2637 = var_5f3df.y;
            highp vec2 var_f8276 = vec2(var_b4854, 1.0 - var_f2637);
            var_5f3df = var_f8276;
            highp vec2 var_ca86d = var_f8276 * CausticsParameters.y;
            highp float var_1a30b;
            if (CausticsTextureParameters.x != 0.0)
            {
                highp float var_cc82f = var_ca86d.x;
                highp float var_6cffd = var_ca86d.x;
                highp float var_de63e = var_cc82f - floor(var_6cffd);
                highp float var_1ddcf = var_ca86d.y;
                highp float var_ca4f1 = var_ca86d.y;
                highp float var_daf47 = var_1ddcf - floor(var_ca4f1);
                var_ca86d = vec2(var_de63e, var_daf47);
                var_1a30b = texture(s_CausticsTexture, vec3(var_de63e, var_daf47, CausticsTextureParameters.y)).x * 2.0;
            }
            else
            {
                highp float var_1bd34;
                highp float var_3dcb9;
                highp vec2 var_0b7eb;
                var_0b7eb = var_ca86d;
                var_3dcb9 = 0.0;
                var_1bd34 = 0.0;
                highp float var_c112c;
                highp float var_55a1f;
                highp vec2 var_42765;
                highp float var_ffaae;
                highp float var_bbb92;
                highp float var_c72ba;
                highp float var_07226;
                uint var_598c9 = 0u;
                highp float var_0881a = 0.0;
                highp float var_0ee2f = WaterSurfaceWaveParameters.x;
                highp float var_423e1 = WaterSurfaceParameters.x;
                highp float var_6b51b = 1.0;
                for (; var_598c9 < uint(WaterSurfaceParameters.y); var_6b51b = var_ffaae, var_423e1 = var_bbb92, var_0b7eb = var_42765, var_0ee2f = var_c72ba, var_0881a = var_07226, var_3dcb9 = var_55a1f, var_1bd34 = var_c112c, var_598c9++)
                {
                    highp vec2 var_a8cfe = vec2(sin(var_0881a), cos(var_0881a));
                    highp float var_d8776 = (dot(var_a8cfe, var_0b7eb) * var_423e1) + (Time.x * var_0ee2f);
                    highp float var_32291 = pow((sin(var_d8776) + 1.0) * 0.5, WaterSurfaceWaveParameters.y);
                    highp vec2 var_dbc3d = vec2(var_32291, (var_32291 * cos(var_d8776)) * (-1.0));
                    var_c112c = var_1bd34 + (var_dbc3d.x * var_6b51b);
                    var_55a1f = var_3dcb9 + var_6b51b;
                    var_42765 = var_0b7eb + (((var_a8cfe * var_dbc3d.y) * var_6b51b) * WaterSurfaceOctaveParameters.x);
                    var_ffaae = mix(var_6b51b, 0.0, WaterSurfaceOctaveParameters.y);
                    var_bbb92 = var_423e1 * WaterSurfaceOctaveParameters.z;
                    var_c72ba = var_0ee2f * WaterSurfaceOctaveParameters.w;
                    var_07226 = var_0881a + 1.39900004863739013671875;
                }
                var_1a30b = var_1bd34 / var_3dcb9;
            }
            var_7e3b5 = pow(var_1a30b, float(int(CausticsParameters.z))) * float(int(CausticsParameters.z) + 1);
        }
        else
        {
            var_7e3b5 = 1.0;
        }
        var_280ef = var_7e3b5;
    }
    else
    {
        var_280ef = 1.0;
    }
    highp float var_995a5 = clamp(((TileLightIntensity.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_7e163 = length(var_566b2);
    highp vec3 var_5bd0a = var_1b091;
    highp float var_2a1b2;
    highp vec4 var_9a0a9;
    highp vec3 var_8ac24;
    highp vec3 var_c7425;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_9dc54;
        if (ShadowQuantizationParameters.y > 0.0)
        {
            highp vec3 var_78b5c = v_worldPos - WorldOrigin.xyz;
            highp vec3 var_96336 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_566b2)), normalize(dFdy(var_566b2)))), 0.0)).xyz) / vec3(ShadowPrecisionRoundingParameters.x)) * ShadowPrecisionRoundingParameters.x);
            highp vec3 var_afdf0 = mod(var_78b5c, vec3(ShadowQuantizationParameters.z));
            var_9dc54 = (round((var_78b5c - (var_afdf0 - (var_96336 * dot(var_afdf0, var_96336)))) / vec3(ShadowPrecisionRoundingParameters.y)) * ShadowPrecisionRoundingParameters.y) + WorldOrigin.xyz;
        }
        else
        {
            var_9dc54 = v_worldPos;
        }
        highp vec3 var_0996e = -(var_566b2 / vec3(length(var_566b2) + 9.9999997473787516355514526367188e-05));
        highp float var_e27f2 = var_e7d71.w * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
        highp vec3 var_1bccf = var_566b2;
        highp vec2 var_1e6e5 = vec2(var_49182, var_280ef);
        highp vec3 var_1d975;
        highp vec3 var_3d209;
        func_33e00(var_3d209, var_1d975, var_3b587, var_9dc54, var_71ab1, var_1bccf, var_1e6e5, var_0996e, var_e7d71, var_7e3f5, var_509ec, var_e27f2);
        highp vec3 var_850d6 = var_566b2;
        highp float var_a89c0;
        if (ManhattanDistAttenuationEnabled.x > 0.0)
        {
            var_a89c0 = (abs(var_850d6.x) + abs(var_850d6.y)) + abs(var_850d6.z);
        }
        else
        {
            var_a89c0 = length(var_566b2);
        }
        bool var_3ca7e = PointLightSpecularFadeOutParameters.x > 0.0;
        highp float var_f999d;
        if (var_3ca7e)
        {
            var_f999d = smoothstep(PointLightSpecularFadeOutParameters.x, PointLightSpecularFadeOutParameters.y, var_a89c0);
        }
        else
        {
            var_f999d = 0.0;
        }
        bool var_d0403 = !var_3ca7e;
        bool var_0e52c;
        if (!var_d0403)
        {
            var_0e52c = var_3ca7e && (var_a89c0 < PointLightSpecularFadeOutParameters.y);
        }
        else
        {
            var_0e52c = var_d0403;
        }
        bool var_fe0c8 = PointLightDiffuseFadeOutParameters.x > 0.0;
        highp float var_8de40;
        if (var_fe0c8)
        {
            var_8de40 = smoothstep(PointLightDiffuseFadeOutParameters.x, PointLightDiffuseFadeOutParameters.y, var_a89c0);
        }
        else
        {
            var_8de40 = 0.0;
        }
        bool var_fc9d4 = !var_fe0c8;
        bool var_b088a;
        if (!var_fc9d4)
        {
            var_b088a = var_fe0c8 && (var_a89c0 < PointLightDiffuseFadeOutParameters.y);
        }
        else
        {
            var_b088a = var_fc9d4;
        }
        highp vec3 var_90dd5 = var_566b2;
        highp vec4 var_b2434;
        highp vec3 var_5aa7a;
        highp vec3 var_f28bd;
        func_9596a(var_0e52c, var_b088a, var_f28bd, var_5aa7a, var_b2434, var_90dd5, var_1b091, var_566b2, var_3b587, var_0996e, var_e7d71, var_7e3f5, var_509ec, var_e27f2, var_9dc54, var_71ab1);
        var_c7425 = var_3d209 + (var_f28bd * (1.0 - var_8de40));
        var_8ac24 = var_1d975 + (var_5aa7a * (1.0 - var_f999d));
        var_9a0a9 = var_b2434;
        var_2a1b2 = var_8de40;
    }
    else
    {
        var_c7425 = vec3(0.0);
        var_8ac24 = vec3(0.0);
        var_9a0a9 = vec4(0.0, 0.0, 0.0, 1.0);
        var_2a1b2 = 0.0;
    }
    highp float var_64c6f;
    if (true)
    {
        var_64c6f = PointLightDiffuseFadeOutParameters.w;
    }
    else
    {
        var_64c6f = PointLightDiffuseFadeOutParameters.z + ((PointLightDiffuseFadeOutParameters.w - PointLightDiffuseFadeOutParameters.z) * var_2a1b2);
    }
    highp vec4 var_61a60 = var_9a0a9;
    highp float var_99f7d = TileLightIntensity.x * TileLightIntensity.x;
    highp vec4 var_52027 = SkyAmbientLightColorIntensity;
    highp float var_8f806 = TileLightIntensity.y * TileLightIntensity.y;
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
    highp vec3 var_aacc4;
    if (var_68aa1)
    {
        highp vec4 var_2fd23 = vec4(1.0);
        highp vec4 var_8490a = SkyAmbientLightColorIntensity;
        var_aacc4 = max(((clamp(vec3(1.0 + (var_2fd23.x * var_2fd23.w), 1.0 + (var_2fd23.y * var_2fd23.w), 1.0 + (var_2fd23.z * var_2fd23.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * 1.0) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_8490a.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_aacc4 = vec3(0.0);
    }
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_79b3e = clamp((((length(var_566b2) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_79b3e > 0.0)
        {
            highp vec3 var_fe67e;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_fe67e = FogColor.xyz * max(var_aacc4, vec3(1.0));
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
    highp vec4 var_2db3b = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_97573 = var_2db3b;
    highp vec4 var_aaab9;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_115ba = (var_1b091.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_1b091, 1.0);
        highp float var_8cf8f = var_115ba.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_115ba.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_aaab9 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_aaab9 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_dcdcd = var_aaab9;
    highp vec3 var_0324e;
    if (IBLParameters.x != 0.0)
    {
        highp vec3 var_7914f = reflect(normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_71ab1);
        bool var_fb1b0 = abs(var_7914f.y) > abs(var_7914f.x);
        bool var_50203;
        if (var_fb1b0)
        {
            var_50203 = abs(var_7914f.y) > abs(var_7914f.z);
        }
        else
        {
            var_50203 = var_fb1b0;
        }
        if (var_50203)
        {
            var_7914f.z *= (-1.0);
        }
        else
        {
            var_7914f.y *= (-1.0);
        }
        highp float var_0f441;
        if (int(ConvolutionType.x) == 1)
        {
            highp float var_ff54b = 1.0 - var_e7d71.z;
            var_0f441 = (1.0 - (var_ff54b * var_ff54b)) * (IBLParameters.y - 1.0);
        }
        else
        {
            highp float var_bd7a8 = 1.0 - var_e7d71.z;
            highp float var_e5afa = var_bd7a8 * var_bd7a8;
            highp float var_d59d7 = var_e5afa * var_e5afa;
            var_0f441 = (1.0 - (var_d59d7 * var_d59d7)) * (IBLParameters.y - 1.0);
        }
        int var_ae27f = int(LastSpecularIBLIdx.x);
        highp vec3 var_67eb4 = mix(textureLod(s_SpecularIBLRecords, vec4(var_7914f, float((var_ae27f + 2) % 3)), var_0f441).xyz, textureLod(s_SpecularIBLRecords, vec4(var_7914f, float(var_ae27f)), var_0f441).xyz, vec3(IBLParameters.w));
        highp vec3 var_99477;
        if (PreExposureEnabled.x > 0.0)
        {
            var_99477 = var_67eb4 * vec3(301.72412109375);
        }
        else
        {
            var_99477 = var_67eb4;
        }
        highp vec3 var_84ff0 = (var_99477 * (((var_995a5 * var_995a5) * var_995a5) * IBLParameters.x)) * IBLParameters.z;
        highp vec3 var_da3af;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec4 var_617d6;
            func_59d20(var_e7d71, var_84ff0, var_617d6);
            highp vec4 var_fb83f = var_617d6;
            highp vec3 var_5279b;
            if (var_fb83f.w == 1.0)
            {
                var_5279b = var_617d6.xyz;
            }
            else
            {
                var_5279b = var_84ff0;
            }
            var_da3af = var_5279b;
        }
        else
        {
            var_da3af = var_84ff0;
        }
        highp vec2 var_745fd = vec2(clamp(dot(var_3b587, -(var_566b2 / vec3(var_7e163))), 0.0, 1.0), var_e7d71.z);
        var_745fd.y = 1.0 - var_745fd.y;
        highp vec2 var_7d2be = texture(s_BrdfLUT, var_745fd).xy;
        highp vec3 var_fe0f6 = var_da3af * ((var_7e3f5 * var_7d2be.x) + vec3(var_7d2be.y));
        highp vec3 var_67472;
        if (AtmosphericScatteringToggles.x != 0.0)
        {
            var_67472 = var_fe0f6 * (1.0 - clamp((((var_7e163 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0));
        }
        else
        {
            var_67472 = var_fe0f6 * (1.0 - clamp((((var_7e163 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
        }
        highp vec3 var_0ffc6;
        if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
        {
            highp vec2 var_0a57b = VolumeNearFar.xy;
            highp vec2 var_9ec98 = (var_1b091.xy + vec2(1.0)) * 0.5;
            highp vec4 var_197cc = u_invProj * vec4(var_1b091, 1.0);
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
        var_0324e = var_0ffc6;
    }
    else
    {
        highp vec3 var_e2657;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec4 var_6eb02;
            func_fa624(var_e7d71, var_6eb02);
            highp vec2 var_6d176 = vec2(clamp(dot(var_3b587, -(var_566b2 / vec3(var_7e163))), 0.0, 1.0), var_e7d71.z);
            var_6d176.y = 1.0 - var_6d176.y;
            highp vec2 var_864a0 = texture(s_BrdfLUT, var_6d176).xy;
            var_e2657 = var_6eb02.xyz * ((var_7e3f5 * var_864a0.x) + vec3(var_864a0.y));
        }
        else
        {
            var_e2657 = vec3(0.0);
        }
        var_0324e = var_e2657;
    }
    highp vec3 var_c43dc = vec4(var_aaab9.xyz + (mix((((((var_509ec * (1.0 - var_e7d71.x)) * max(((clamp(vec3(var_99f7d + (var_61a60.x * var_61a60.w), (var_99f7d * ((((var_99f7d * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_61a60.y * var_61a60.w), (var_99f7d * (((var_99f7d * var_99f7d) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_61a60.z * var_61a60.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * var_64c6f) + ((SkyAmbientLightColorIntensity.xyz * mix((var_8f806 * var_8f806) * TileLightIntensity.y, (TileLightIntensity.y * TileLightIntensity.y) * TileLightIntensity.y, CameraLightIntensity.y)) * var_52027.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_c7425) + var_8ac24) + (((mix(var_509ec, vec3(dot(var_509ec, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_e7d71.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_2db3b.xyz, vec3(var_97573.w)) * var_dcdcd.w), 1.0).xyz + var_0324e;
    highp vec3 var_bbce3;
    if (PreExposureEnabled.x > 0.0)
    {
        var_bbce3 = var_c43dc * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_bbce3 = var_c43dc;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_7ed87 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_7ed87;
    highp vec4 var_c6f70 = u_prevViewProj * vec4(v_prevWorldPos, 1.0);
    highp vec4 var_96bda = var_c6f70;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_82203 = ((var_c6f70 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_82203;
    highp vec2 var_e953a = var_7ed87.xy - var_82203.xy;
    bgfx_FragData[0] = vec4(var_bbce3.x, var_bbce3.y, var_bbce3.z, vec4(var_5e514, var_5e514, var_5e514, 1.0).w);
    bgfx_FragData[1] = vec4(vec4(0.0).x, vec4(0.0).y, var_e953a.x, var_e953a.y);
}
