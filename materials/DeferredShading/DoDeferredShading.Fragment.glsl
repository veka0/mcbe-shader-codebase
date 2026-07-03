#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_DEFERRED_SHADING_PASS (not used)
* - DO_INDIRECT_SPECULAR_SHADING_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2D s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
* - layout(binding = 4, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 5, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform highp sampler2DArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SSRTexture;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
*
* Uniforms:
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 CameraLightIntensity;
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
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SSRParameters;
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

layout(binding = 5, std430) buffer s_Lights { Light Lights[]; } var_fdac4;
layout(binding = 4, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_5851a;
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
uniform highp mat4 PointLightProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_CausticsTexture;
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_EmissiveAmbientLinearRoughness;
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2DArray s_PointLightShadowTextureArray;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadeShadowResolutions;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ClusterNearFarWidthHeight;
uniform highp vec4 ClusterSize;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
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
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightDiffuseFadeOutParameters;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 PointLightSpecularFadeOutParameters;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 ShadowBias;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
uniform highp vec4 ShadowPCFWidth;
uniform highp vec4 ShadowQuantizationParameters;
uniform highp vec4 ShadowSlopeBias;
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
uniform highp vec4 WaterExtinctionCoefficients;
uniform highp vec4 WaterSurfaceOctaveParameters;
uniform highp vec4 WaterSurfaceParameters;
uniform highp vec4 WaterSurfaceWaveParameters;
uniform highp vec4 WorldOrigin;
in highp vec3 v_projPosition;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
mat4 var_62632;
float var_2ce5b;
int var_e7b23;
bool var_a33e3;
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
void func_1aef6(inout int arg_a1e9d, inout highp float arg_7a26d, inout highp float arg_98f56, inout int arg_24aec, inout highp vec4 arg_5b51a, inout highp float arg_af650, inout highp float arg_e6df6) {
    if (arg_a1e9d < 0)
    {
        arg_7a26d = 1.0;
        arg_98f56 = 1.0;
        return;
    }
    int loc_c21a5 = clamp(int(ShadowPCFWidth[arg_24aec] + 0.5), 1, 9);
    int loc_d6315 = loc_c21a5 / 2;
    highp vec2 loc_de8d2 = ((vec2(arg_5b51a.x, arg_5b51a.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions[arg_24aec];
    highp float loc_820a9 = (arg_5b51a.z * 0.5) + 0.5;
    loc_de8d2.y += (1.0 - CascadeShadowResolutions[arg_24aec]);
    highp float loc_36d1e;
    highp float loc_76a21;
    loc_76a21 = 0.0;
    loc_36d1e = 0.0;
    highp float loc_4cd6d;
    highp float loc_dcabb;
    for (int loc_6331b = 0; loc_6331b < loc_c21a5; loc_76a21 = loc_dcabb, loc_36d1e = loc_4cd6d, loc_6331b++)
    {
        loc_dcabb = loc_76a21;
        loc_4cd6d = loc_36d1e;
        highp float loc_c3d98;
        highp float loc_cf9df;
        for (int loc_b330d = 0; loc_b330d < loc_c21a5; loc_dcabb = loc_cf9df, loc_4cd6d = loc_c3d98, loc_b330d++)
        {
            highp vec3 loc_65200 = vec3(loc_de8d2 + ((vec2(float(loc_b330d - loc_d6315) + 0.5, float(loc_6331b - loc_d6315) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSize.x) * CascadeShadowResolutions[arg_24aec]), (float(arg_a1e9d) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(arg_24aec));
            highp vec4 loc_82338 = textureGather(s_ShadowCascades, loc_65200);
            highp vec4 loc_bbed9 = loc_82338;
            highp vec2 loc_201e7 = fract((loc_65200.xy * ShadowFilterOffsetAndRangeFarAndMapSize.z) + vec2(0.5));
            highp vec4 loc_0505f = vec4(1.0) - smoothstep(vec4(0.0), vec4(1.0), (vec4(loc_820a9) - loc_82338) * arg_af650);
            highp vec2 loc_f9006 = loc_201e7;
            loc_c3d98 = loc_4cd6d + mix(mix(loc_0505f.w, loc_0505f.z, loc_f9006.x), mix(loc_0505f.x, loc_0505f.y, loc_f9006.x), loc_f9006.y);
            if (ShadowQuantizationParameters.x != 0.0)
            {
                loc_cf9df = loc_dcabb + float(loc_bbed9.w >= (loc_820a9 - arg_e6df6));
            }
            else
            {
                highp vec4 loc_27ff4 = step(vec4(loc_820a9 - arg_e6df6), loc_82338);
                highp vec2 loc_18eef = loc_201e7;
                loc_cf9df = loc_dcabb + mix(mix(loc_27ff4.w, loc_27ff4.z, loc_18eef.x), mix(loc_27ff4.x, loc_27ff4.y, loc_18eef.x), loc_18eef.y);
            }
        }
    }
    arg_7a26d = loc_36d1e / float(loc_c21a5 * loc_c21a5);
    arg_98f56 = loc_76a21 / float(loc_c21a5 * loc_c21a5);
}
void func_7a524(inout highp vec3 arg_3a8bb, inout highp float arg_e038b, inout highp float arg_5a4a1) {
    highp vec4 loc_57cee = PlayerShadowProj * vec4(arg_3a8bb, 1.0);
    loc_57cee.z -= (ShadowBias.x + (ShadowSlopeBias.x * clamp(tan(acos(arg_e038b)), 0.0, 1.0)));
    loc_57cee.z = min(loc_57cee.z, 1.0);
    highp vec2 loc_f5a38 = ((vec2(loc_57cee.x, loc_57cee.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    loc_57cee.z = (loc_57cee.z * 0.5) + 0.5;
    loc_f5a38.y += (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    bool loc_2c837 = loc_f5a38.x >= 0.0;
    bool loc_d06e3;
    if (loc_2c837)
    {
        loc_d06e3 = loc_f5a38.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_d06e3 = loc_2c837;
    }
    bool loc_c7ec9;
    if (loc_d06e3)
    {
        loc_c7ec9 = loc_f5a38.y >= (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    }
    else
    {
        loc_c7ec9 = loc_d06e3;
    }
    bool loc_8e2b9;
    if (loc_c7ec9)
    {
        loc_8e2b9 = loc_f5a38.y < 1.0;
    }
    else
    {
        loc_8e2b9 = loc_c7ec9;
    }
    if (!loc_8e2b9)
    {
        arg_5a4a1 = 1.0;
        return;
    }
    highp float loc_fb589;
    loc_fb589 = 0.0;
    highp float loc_d6abd;
    for (int loc_92f2a = 0; loc_92f2a < 2; loc_fb589 = loc_d6abd, loc_92f2a++)
    {
        loc_d6abd = loc_fb589;
        highp float loc_78ad8;
        for (int loc_cca52 = 0; loc_cca52 < 2; loc_d6abd = loc_78ad8, loc_cca52++)
        {
            highp vec2 loc_3bfb1 = loc_f5a38 + ((vec2(float(loc_cca52 - 1) + 0.5, float(loc_92f2a - 1) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            highp vec3 loc_82357 = vec3(loc_3bfb1.x, loc_3bfb1.y, (DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0) + 1.0);
            if (ShadowQuantizationParameters.x != 0.0)
            {
                loc_78ad8 = loc_d6abd + float(textureLod(s_ShadowCascades, loc_82357, 0.0).x >= loc_57cee.z);
            }
            else
            {
                highp vec4 loc_1f2f1 = step(vec4(loc_57cee.z), textureGather(s_ShadowCascades, loc_82357));
                highp vec2 loc_b1a62 = fract((loc_82357.xy * ShadowFilterOffsetAndRangeFarAndMapSize.z) + vec2(0.5));
                loc_78ad8 = loc_d6abd + mix(mix(loc_1f2f1.w, loc_1f2f1.z, loc_b1a62.x), mix(loc_1f2f1.x, loc_1f2f1.y, loc_b1a62.x), loc_b1a62.y);
            }
        }
    }
    arg_5a4a1 = loc_fb589 * 0.25;
}
void func_5d237(inout highp vec3 arg_a9d63, inout highp vec4 arg_582d0, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec3 arg_02c40, inout highp vec3 arg_abe00, inout highp vec4 arg_d9294, inout highp vec2 arg_c288e, inout highp vec3 arg_99739, inout highp vec3 arg_85276, inout highp vec3 arg_cff01, inout highp float arg_5416d, inout highp float arg_24e02) {
    highp vec3 loc_6c7ae;
    if (ShadowQuantizationParameters.y > 0.0)
    {
        highp vec3 loc_598a0 = arg_a9d63 - WorldOrigin.xyz;
        highp vec3 loc_ed4f5 = normalize(cross(normalize(dFdx(loc_598a0)), normalize(dFdy(loc_598a0))));
        highp vec3 loc_8f42c = mod(loc_598a0, vec3(ShadowQuantizationParameters.z));
        loc_6c7ae = arg_a9d63 - (loc_8f42c - (loc_ed4f5 * dot(loc_8f42c, loc_ed4f5)));
    }
    else
    {
        loc_6c7ae = arg_a9d63;
    }
    if (abs(arg_582d0.z) < 9.9999997473787516355514526367188e-05)
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        return;
    }
    int loc_a14ca = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    highp mat4 loc_bd26f;
    highp vec3 loc_122db;
    highp vec3 loc_0bf4d;
    loc_0bf4d = vec3(0.0);
    loc_122db = vec3(0.0);
    loc_bd26f = var_62632;
    highp vec3 loc_12766;
    highp vec3 loc_3ac48;
    highp mat4 loc_1a85e;
    highp float loc_f5dfb;
    highp float loc_7a912;
    for (int loc_10f85 = 0; loc_10f85 < loc_a14ca; loc_0bf4d = loc_3ac48, loc_122db = loc_12766, loc_7a912 = loc_f5dfb, loc_bd26f = loc_1a85e, loc_10f85++)
    {
        highp float loc_75755;
        highp float loc_27a4b;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            highp float loc_955a9 = max(dot(arg_02c40, normalize((u_view * DirectionalLightSourceShadowDirection[loc_10f85]).xyz)), 0.0);
            int loc_dc8b4;
            highp vec4 loc_d73c9;
            highp mat4 loc_b250f;
            func_9040f(loc_10f85, loc_6c7ae, loc_b250f, loc_d73c9, loc_dc8b4, loc_bd26f);
            highp vec4 loc_08b3b = loc_d73c9;
            highp float loc_8766b;
            highp float loc_be413;
            if (loc_dc8b4 != (-1))
            {
                highp float loc_0877b = ShadowBias[loc_dc8b4] + (ShadowSlopeBias[loc_dc8b4] * clamp(tan(acos(loc_955a9)), 0.0, 1.0));
                highp float loc_9a3cf = SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z * length(loc_b250f * vec4(0.0, 0.0, 1.0, 0.0));
                int loc_82d7a = int(DirectionalLightSourceShadowCascadeNumber[loc_10f85].x);
                highp float loc_47769;
                highp float loc_079c0;
                func_1aef6(loc_82d7a, loc_079c0, loc_47769, loc_dc8b4, loc_08b3b, loc_9a3cf, loc_0877b);
                highp float loc_ad256;
                if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
                {
                    highp float loc_93efa;
                    func_7a524(loc_6c7ae, loc_955a9, loc_93efa);
                    loc_ad256 = min(loc_47769, loc_93efa);
                }
                else
                {
                    loc_ad256 = loc_47769;
                }
                bool loc_5d7ab = int(DirectionalLightSourceIsSun[loc_10f85].x) > 0;
                bool loc_643a4;
                if (loc_5d7ab)
                {
                    loc_643a4 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
                }
                else
                {
                    loc_643a4 = loc_5d7ab;
                }
                highp float loc_e4c4c;
                if (loc_643a4)
                {
                    highp vec4 loc_1a6df = CloudShadowProj * vec4(loc_6c7ae, 1.0);
                    highp vec4 loc_09c0a = loc_1a6df;
                    loc_09c0a = loc_1a6df / vec4(loc_09c0a.w);
                    loc_09c0a.z -= ((ShadowBias.x + (ShadowSlopeBias.x * clamp(tan(acos(loc_955a9)), 0.0, 1.0))) / loc_09c0a.w);
                    highp vec2 loc_74cbe = ((vec2(loc_09c0a.x, loc_09c0a.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions.x;
                    int loc_b64c0 = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z + 0.5), 1, 9);
                    int loc_ed3d9 = loc_b64c0 / 2;
                    loc_09c0a.z = (loc_09c0a.z * 0.5) + 0.5;
                    loc_74cbe.y += (1.0 - CascadeShadowResolutions.x);
                    highp float loc_ac935;
                    loc_ac935 = 0.0;
                    highp float loc_6f800;
                    for (int loc_96ac8 = 0; loc_96ac8 < loc_b64c0; loc_ac935 = loc_6f800, loc_96ac8++)
                    {
                        loc_6f800 = loc_ac935;
                        highp float loc_91ddf;
                        for (int loc_75999 = 0; loc_75999 < loc_b64c0; loc_6f800 = loc_91ddf, loc_75999++)
                        {
                            highp vec3 loc_5cc81 = vec3(loc_74cbe + ((vec2(float(loc_75999 - loc_ed3d9) + 0.5, float(loc_96ac8 - loc_ed3d9) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSize.x) * CascadeShadowResolutions.x), DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0);
                            if (ShadowQuantizationParameters.x != 0.0)
                            {
                                loc_91ddf = loc_6f800 + float(textureLod(s_ShadowCascades, loc_5cc81, 0.0).x >= loc_09c0a.z);
                            }
                            else
                            {
                                highp vec4 loc_ef698 = step(vec4(loc_09c0a.z), textureGather(s_ShadowCascades, loc_5cc81));
                                highp vec2 loc_fa89d = fract((loc_5cc81.xy * ShadowFilterOffsetAndRangeFarAndMapSize.z) + vec2(0.5));
                                loc_91ddf = loc_6f800 + mix(mix(loc_ef698.w, loc_ef698.z, loc_fa89d.x), mix(loc_ef698.x, loc_ef698.y, loc_fa89d.x), loc_fa89d.y);
                            }
                        }
                    }
                    highp float loc_e0cb0 = loc_ac935 / float(loc_b64c0 * loc_b64c0);
                    highp float loc_3715f;
                    if (loc_e0cb0 < 1.0)
                    {
                        loc_3715f = min(loc_ad256, max(loc_e0cb0, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                    }
                    else
                    {
                        loc_3715f = loc_ad256;
                    }
                    loc_e4c4c = loc_3715f;
                }
                else
                {
                    loc_e4c4c = loc_ad256;
                }
                loc_be413 = loc_079c0;
                loc_8766b = mix(loc_e4c4c, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSize.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSize.y, -arg_abe00.z));
            }
            else
            {
                loc_be413 = loc_7a912;
                loc_8766b = 1.0;
            }
            loc_f5dfb = loc_be413;
            loc_1a85e = loc_b250f;
            loc_27a4b = loc_be413;
            loc_75755 = loc_8766b;
        }
        else
        {
            loc_f5dfb = loc_7a912;
            loc_1a85e = loc_bd26f;
            loc_27a4b = 1.0;
            loc_75755 = 1.0;
        }
        highp vec3 loc_791d7;
        if (DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.x != 0.0)
        {
            int loc_1db61 = int(DirectionalLightSourceShadowCascadeNumber[loc_10f85].x);
            highp float loc_a3c1d;
            if (loc_1db61 >= 0)
            {
                highp vec4 loc_f60c5 = DirectionalLightSourceWaterSurfaceViewProj[loc_10f85] * vec4(arg_d9294.xyz, 1.0);
                highp vec4 loc_f5c51 = loc_f60c5;
                highp vec3 loc_03ed3 = loc_f60c5.xyz / vec3(loc_f5c51.w);
                highp vec3 loc_14f1d = loc_03ed3;
                highp vec4 loc_7bb35 = DirectionalLightSourceWaterSurfaceViewProj[loc_10f85] * vec4(arg_d9294.xyz, 1.0);
                highp vec4 loc_7aafc = loc_7bb35;
                highp vec3 loc_b2964 = loc_7bb35.xyz / vec3(loc_7aafc.w);
                loc_b2964.y *= (-1.0);
                highp vec2 loc_e2892 = (loc_b2964.xy + vec2(1.0)) * 0.5;
                highp float loc_c3fee = loc_e2892.x;
                highp float loc_f8aea = loc_e2892.y;
                highp float loc_f8be2 = 1.0 - loc_f8aea;
                loc_e2892 = vec2(loc_c3fee, loc_f8be2);
                highp vec4 loc_b2d02 = texture(s_ShadowCascades, vec3(loc_c3fee, loc_f8be2, float((loc_1db61 * int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w)) + int(DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.y))));
                highp float loc_ef64d = (loc_b2d02.x * 2.0) - 1.0;
                highp float loc_edd49;
                if (loc_14f1d.z > loc_ef64d)
                {
                    loc_edd49 = length((DirectionalLightSourceInvWaterSurfaceViewProj[loc_10f85] * vec4(loc_03ed3.xy, loc_ef64d, 1.0)).xyz - arg_a9d63);
                }
                else
                {
                    loc_edd49 = 0.0;
                }
                loc_a3c1d = loc_edd49;
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
        highp vec3 loc_8328b = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_10f85]).xyz);
        highp vec4 loc_5b55e = DirectionalLightSourceDiffuseColorAndIlluminance[loc_10f85];
        highp vec3 loc_03c38 = (((DirectionalLightSourceDiffuseColorAndIlluminance[loc_10f85].xyz * loc_5b55e.w) * loc_791d7) * arg_c288e[loc_10f85]) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
        highp float loc_a9584 = max(dot(arg_02c40, loc_8328b), 0.0);
        highp float loc_af6fd = max(dot(arg_02c40, arg_99739), 0.0);
        highp vec3 loc_c829d = normalize(loc_8328b + arg_99739);
        highp float loc_780d3 = arg_582d0.w * arg_582d0.w;
        highp float loc_e5081 = loc_780d3 * loc_780d3;
        highp float loc_87b4a = max(dot(arg_02c40, loc_c829d), 0.0);
        highp float loc_cd8b0 = max((((loc_e5081 - 1.0) * loc_87b4a) * loc_87b4a) + 1.0, 9.9999997473787516355514526367188e-05);
        highp float loc_ad7fb = loc_780d3 * 0.5;
        highp vec3 loc_27228 = arg_85276 + ((vec3(1.0) - arg_85276) * pow(clamp(1.0 - max(dot(arg_99739, loc_c829d), 0.0), 0.0, 1.0), 5.0));
        highp vec3 loc_946b7 = arg_cff01 * (1.0 - arg_5416d);
        loc_12766 = loc_122db + (((((((vec3(1.0) - loc_27228) * mix(loc_a9584, max((dot(arg_02c40, loc_8328b) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / ((1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) * (1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y)), 0.0), arg_24e02)) * (loc_946b7 * vec3(0.3183098733425140380859375))) * loc_75755) + (((loc_946b7 * vec3(0.3183098733425140380859375)) * (arg_24e02 * max((dot(-arg_02c40, loc_8328b) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / ((1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) * (1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y)), 0.0))) * loc_27a4b)) * loc_03c38) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_3ac48 = loc_0bf4d + (((((((loc_27228 * (loc_e5081 / ((loc_cd8b0 * loc_cd8b0) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_a9584 / (((loc_a9584 * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_a9584) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_a9584) * loc_75755) * loc_03c38) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_122db;
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
void func_cd404(inout highp vec3 arg_48e40, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp float loc_28341 = -arg_48e40.z;
    highp vec2 loc_1b48c = v_texcoord0;
    highp vec3 loc_fd394 = ClusterDimensions.xyz;
    highp vec2 loc_703d4 = ClusterNearFarWidthHeight.zw;
    highp vec2 loc_d7b5c = ClusterSize.xy;
    highp vec2 loc_909cb = ClusterNearFarWidthHeight.xy;
    highp float loc_5de3f;
    func_b9aa9(loc_28341, loc_909cb, loc_5de3f, arg_48e40, loc_fd394);
    highp vec3 loc_60667 = vec3(floor((loc_1b48c.x * loc_703d4.x) / loc_d7b5c.x), floor((loc_1b48c.y * loc_703d4.y) / loc_d7b5c.y), loc_5de3f);
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
void func_4fdfa(inout int arg_aec91, inout highp float arg_28e67, inout highp vec3 arg_0623c, inout highp vec3 arg_214f6) {
    if (var_fdac4.Lights[arg_aec91].shadowProbeIndex < 0)
    {
        arg_28e67 = 1.0;
        return;
    }
    highp vec3 loc_7f355 = arg_0623c - var_fdac4.Lights[arg_aec91].position.xyz;
    highp vec3 loc_27555 = loc_7f355;
    highp vec3 loc_f4d64 = abs(loc_7f355);
    highp vec3 loc_5836b = vec3(0.0);
    bool loc_ab77c = loc_f4d64.x >= loc_f4d64.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_f4d64.x >= loc_f4d64.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    if (loc_ca7f9)
    {
        loc_f4d64 = vec3(loc_f4d64.y, loc_f4d64.z, loc_f4d64.x);
        if (loc_27555.x > 0.0)
        {
            highp vec3 loc_c810d = ((loc_7f355 * (1.0 / loc_7f355.x)) * 0.5) + vec3(0.5);
            loc_5836b = vec3(1.0 - loc_c810d.z, loc_c810d.y, 0.0);
        }
        else
        {
            highp vec3 loc_3d32b = ((loc_7f355 * (1.0 / dot(loc_7f355, vec3(-1.0, 0.0, 0.0)))) * 0.5) + vec3(0.5);
            loc_5836b = vec3(loc_3d32b.z, loc_3d32b.y, 1.0);
        }
    }
    else
    {
        if (loc_f4d64.y >= loc_f4d64.z)
        {
            loc_f4d64 = vec3(loc_f4d64.x, loc_f4d64.z, loc_f4d64.y);
            if (loc_27555.y > 0.0)
            {
                highp vec3 loc_1939e = ((loc_7f355 * (1.0 / loc_7f355.y)) * 0.5) + vec3(0.5);
                loc_5836b = vec3(loc_1939e.x, 1.0 - loc_1939e.z, 2.0);
            }
            else
            {
                highp vec3 loc_9f7b3 = ((loc_7f355 * (1.0 / dot(loc_7f355, vec3(0.0, -1.0, 0.0)))) * 0.5) + vec3(0.5);
                loc_5836b = vec3(loc_9f7b3.x, loc_9f7b3.z, 3.0);
            }
        }
        else
        {
            if (loc_27555.z > 0.0)
            {
                highp vec3 loc_0db9f = ((loc_7f355 * (1.0 / loc_7f355.z)) * 0.5) + vec3(0.5);
                loc_5836b = vec3(loc_0db9f.x, loc_0db9f.y, 4.0);
            }
            else
            {
                highp vec3 loc_2f24d = ((loc_7f355 * (1.0 / dot(loc_7f355, vec3(0.0, 0.0, -1.0)))) * 0.5) + vec3(0.5);
                loc_5836b = vec3(1.0 - loc_2f24d.x, loc_2f24d.y, 5.0);
            }
        }
    }
    loc_f4d64.z *= (-1.0);
    highp vec4 loc_eae4d = PointLightProj * vec4(loc_f4d64, 1.0);
    loc_eae4d.z += (PointLightShadowParams1.x + (PointLightShadowParams1.y * clamp(tan(acos(dot(-normalize(loc_7f355), arg_214f6))), 0.0, 1.0)));
    loc_eae4d /= vec4(loc_eae4d.w);
    highp float loc_b74da;
    loc_b74da = 0.0;
    highp float loc_f6f3d;
    for (int loc_1139b = 0; loc_1139b < 4; loc_b74da = loc_f6f3d, loc_1139b++)
    {
        loc_f6f3d = loc_b74da;
        highp float loc_bbf51;
        for (int loc_79fcd = 0; loc_79fcd < 4; loc_f6f3d = loc_bbf51, loc_79fcd++)
        {
            highp vec2 loc_46de9 = vec2(float(loc_79fcd - 2) + 0.5, float(loc_1139b - 2) + 0.5) * PointLightShadowParams1.w;
            highp vec3 loc_f67d5 = vec3(loc_5836b.x + loc_46de9.x, (1.0 - loc_5836b.y) + loc_46de9.y, loc_5836b.z);
            highp vec3 loc_95a76 = loc_f67d5;
            highp vec3 loc_0f2c0 = loc_f67d5;
            if (loc_95a76.y > 1.0)
            {
                switch (int(loc_95a76.z))
                {
                    case 0:
                    {
                        loc_0f2c0.z = 3.0;
                        loc_0f2c0.x = 2.0 - loc_95a76.y;
                        loc_0f2c0.y = loc_95a76.x;
                        break;
                    }
                    case 1:
                    {
                        loc_0f2c0.z = 3.0;
                        loc_0f2c0.x = loc_95a76.y - 1.0;
                        loc_0f2c0.y = 1.0 - loc_95a76.x;
                        break;
                    }
                    case 2:
                    {
                        loc_0f2c0.z = 4.0;
                        loc_0f2c0.x = loc_95a76.x;
                        loc_0f2c0.y = loc_95a76.y - 1.0;
                        break;
                    }
                    case 3:
                    {
                        loc_0f2c0.z = 5.0;
                        loc_0f2c0.x = 1.0 - loc_95a76.x;
                        loc_0f2c0.y = 2.0 - loc_95a76.y;
                        break;
                    }
                    case 4:
                    {
                        loc_0f2c0.z = 3.0;
                        loc_0f2c0.x = loc_95a76.x;
                        loc_0f2c0.y = loc_95a76.y - 1.0;
                        break;
                    }
                    case 5:
                    {
                        loc_0f2c0.z = 3.0;
                        loc_0f2c0.x = 1.0 - loc_95a76.x;
                        loc_0f2c0.y = 2.0 - loc_95a76.y;
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
                if (loc_95a76.y < 0.0)
                {
                    switch (int(loc_95a76.z))
                    {
                        case 0:
                        {
                            loc_0f2c0.z = 2.0;
                            loc_0f2c0.x = 1.0 + loc_95a76.y;
                            loc_0f2c0.y = 1.0 - loc_95a76.x;
                            break;
                        }
                        case 1:
                        {
                            loc_0f2c0.z = 2.0;
                            loc_0f2c0.x = -loc_95a76.y;
                            loc_0f2c0.y = loc_95a76.x;
                            break;
                        }
                        case 2:
                        {
                            loc_0f2c0.z = 5.0;
                            loc_0f2c0.x = 1.0 - loc_95a76.x;
                            loc_0f2c0.y = -loc_95a76.y;
                            break;
                        }
                        case 3:
                        {
                            loc_0f2c0.z = 4.0;
                            loc_0f2c0.x = loc_95a76.x;
                            loc_0f2c0.y = 1.0 + loc_95a76.y;
                            break;
                        }
                        case 4:
                        {
                            loc_0f2c0.z = 2.0;
                            loc_0f2c0.x = loc_95a76.x;
                            loc_0f2c0.y = 1.0 + loc_95a76.y;
                            break;
                        }
                        case 5:
                        {
                            loc_0f2c0.z = 2.0;
                            loc_0f2c0.x = 1.0 - loc_95a76.x;
                            loc_0f2c0.y = -loc_95a76.y;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            highp vec2 loc_cbdd0 = loc_0f2c0.xy;
            if (loc_cbdd0.x > 1.0)
            {
                switch (int(loc_0f2c0.z))
                {
                    case 0:
                    {
                        loc_0f2c0.z = 5.0;
                        loc_0f2c0.x = loc_cbdd0.x - 1.0;
                        loc_0f2c0.y = loc_cbdd0.y;
                        break;
                    }
                    case 1:
                    {
                        loc_0f2c0.z = 4.0;
                        loc_0f2c0.x = loc_cbdd0.x - 1.0;
                        loc_0f2c0.y = loc_cbdd0.y;
                        break;
                    }
                    case 2:
                    {
                        loc_0f2c0.z = 0.0;
                        loc_0f2c0.x = 1.0 - loc_cbdd0.y;
                        loc_0f2c0.y = loc_cbdd0.x - 1.0;
                        break;
                    }
                    case 3:
                    {
                        loc_0f2c0.z = 0.0;
                        loc_0f2c0.x = loc_cbdd0.y;
                        loc_0f2c0.y = 2.0 - loc_cbdd0.x;
                        break;
                    }
                    case 4:
                    {
                        loc_0f2c0.z = 0.0;
                        loc_0f2c0.x = loc_cbdd0.x - 1.0;
                        loc_0f2c0.y = loc_cbdd0.y;
                        break;
                    }
                    case 5:
                    {
                        loc_0f2c0.z = 1.0;
                        loc_0f2c0.x = loc_cbdd0.x - 1.0;
                        loc_0f2c0.y = loc_cbdd0.y;
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
                if (loc_cbdd0.x < 0.0)
                {
                    switch (int(loc_0f2c0.z))
                    {
                        case 0:
                        {
                            loc_0f2c0.z = 4.0;
                            loc_0f2c0.x = 1.0 + loc_cbdd0.x;
                            loc_0f2c0.y = loc_cbdd0.y;
                            break;
                        }
                        case 1:
                        {
                            loc_0f2c0.z = 5.0;
                            loc_0f2c0.x = 1.0 + loc_cbdd0.x;
                            loc_0f2c0.y = loc_cbdd0.y;
                            break;
                        }
                        case 2:
                        {
                            loc_0f2c0.z = 1.0;
                            loc_0f2c0.x = loc_cbdd0.y;
                            loc_0f2c0.y = -loc_cbdd0.x;
                            break;
                        }
                        case 3:
                        {
                            loc_0f2c0.z = 1.0;
                            loc_0f2c0.x = 1.0 - loc_cbdd0.y;
                            loc_0f2c0.y = 1.0 + loc_cbdd0.x;
                            break;
                        }
                        case 4:
                        {
                            loc_0f2c0.z = 1.0;
                            loc_0f2c0.x = 1.0 + loc_cbdd0.x;
                            loc_0f2c0.y = loc_cbdd0.y;
                            break;
                        }
                        case 5:
                        {
                            loc_0f2c0.z = 0.0;
                            loc_0f2c0.x = 1.0 + loc_cbdd0.x;
                            loc_0f2c0.y = loc_cbdd0.y;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            highp vec3 loc_0a47c = loc_0f2c0;
            loc_0a47c.z = float(var_fdac4.Lights[arg_aec91].shadowProbeIndex * 6) + loc_0a47c.z;
            highp vec4 loc_185e5 = step(vec4(loc_eae4d.z), textureGather(s_PointLightShadowTextureArray, loc_0a47c));
            highp vec2 loc_b16bc = fract((loc_0a47c.xy * (1.0 / (PointLightShadowParams1.w + 9.9999997473787516355514526367188e-05))) + vec2(0.5));
            loc_bbf51 = loc_f6f3d + mix(mix(loc_185e5.w, loc_185e5.z, loc_b16bc.x), mix(loc_185e5.x, loc_185e5.y, loc_b16bc.x), loc_b16bc.y);
        }
    }
    arg_28e67 = loc_b74da * 0.0624996125698089599609375;
}
void func_8ae36(inout highp vec4 arg_83841, inout int arg_a5975, inout highp vec3 arg_62394, inout highp vec3 arg_427c1, inout highp vec3 arg_81f82) {
    arg_83841 = vec4(0.0);
    if (arg_a5975 < 0)
    {
        arg_62394 = vec3(0.0);
        return;
    }
    highp vec3 loc_4835c = var_fdac4.Lights[arg_a5975].position.xyz - arg_427c1;
    highp vec3 loc_8cb9b = loc_4835c;
    highp float loc_95cea;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_95cea = loc_1829d * loc_1829d;
    }
    else
    {
        loc_95cea = dot(loc_4835c, loc_4835c);
    }
    if (loc_95cea >= (var_fdac4.Lights[arg_a5975].position.w * var_fdac4.Lights[arg_a5975].position.w))
    {
        arg_62394 = vec3(0.0);
        return;
    }
    highp float loc_33ea0;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_1b78e;
        func_4fdfa(arg_a5975, loc_1b78e, arg_427c1, arg_81f82);
        loc_33ea0 = loc_1b78e;
    }
    else
    {
        loc_33ea0 = 1.0;
    }
    if (loc_33ea0 <= 0.0)
    {
        arg_62394 = vec3(0.0);
        return;
    }
    highp float loc_fd676 = loc_95cea / ((var_fdac4.Lights[arg_a5975].position.w * var_fdac4.Lights[arg_a5975].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_fcfce = clamp(1.0 - (loc_fd676 * loc_fd676), 0.0, 1.0);
    highp float loc_e1ff6 = (1.0 / max(loc_95cea, 9.9999997473787516355514526367188e-05)) * (loc_fcfce * loc_fcfce);
    highp float loc_3d192;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_3d192 = loc_e1ff6 * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_e1ff6) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_3d192 = loc_e1ff6;
    }
    highp vec3 loc_13960 = var_fdac4.Lights[arg_a5975].color.xyz * loc_3d192;
    arg_83841 = vec4(loc_13960.x, loc_13960.y, loc_13960.z, arg_83841.w);
    arg_83841.w = 1.0 - (loc_95cea / ((var_fdac4.Lights[arg_a5975].position.w * var_fdac4.Lights[arg_a5975].position.w) + 9.9999997473787516355514526367188e-05));
    arg_62394 = (((var_fdac4.Lights[arg_a5975].color.xyz * var_fdac4.Lights[arg_a5975].color.w) * loc_3d192) * loc_33ea0) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_55aa7(inout bool arg_9a2b4, inout bool arg_b6724, inout bool arg_33e52, inout highp vec3 arg_3289d, inout highp vec3 arg_98547, inout highp vec4 arg_82d08, inout highp vec3 arg_1418f, inout highp vec3 arg_89c41, inout highp vec3 arg_6ff9e, inout highp vec3 arg_901f6, inout highp vec4 arg_6578f, inout highp vec3 arg_20396, inout highp vec3 arg_dd9d3, inout highp float arg_f859b, inout highp float arg_fe933, inout highp vec3 arg_5e370, inout highp vec3 arg_78ca7) {
    highp vec4 loc_fa2ec = vec4(0.0);
    if (!(arg_9a2b4 || arg_b6724))
    {
        arg_33e52 = var_a33e3;
        arg_3289d = vec3(0.0);
        arg_98547 = vec3(0.0);
        arg_82d08 = loc_fa2ec;
        return;
    }
    bool loc_a0bb1;
    int loc_490eb;
    int loc_c476d;
    func_cd404(arg_1418f, loc_c476d, loc_490eb, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_33e52 = var_a33e3;
        arg_3289d = vec3(0.0);
        arg_98547 = vec3(0.0);
        arg_82d08 = loc_fa2ec;
        return;
    }
    int loc_23246;
    highp vec3 loc_68344;
    highp vec3 loc_118d9;
    loc_118d9 = vec3(0.0);
    loc_68344 = vec3(0.0);
    loc_23246 = 0;
    int loc_62c27;
    highp vec3 loc_49b5f;
    highp vec3 loc_7a7eb;
    highp vec4 loc_ddace;
    for (int loc_0ad25 = loc_490eb; loc_0ad25 < loc_c476d; loc_118d9 = loc_7a7eb, loc_68344 = loc_49b5f, loc_23246 = loc_62c27, loc_0ad25++)
    {
        int loc_2cc07 = int(var_5851a.LightLookupArray[loc_0ad25].lookup);
        if (loc_2cc07 < 0)
        {
            break;
        }
        highp vec3 loc_a3520 = normalize((u_view * vec4(var_fdac4.Lights[loc_2cc07].position.xyz, 1.0)).xyz - arg_89c41);
        highp vec3 loc_12949;
        highp vec3 loc_05c79;
        highp vec3 loc_b2ace;
        if (arg_b6724)
        {
            highp vec3 loc_e0df3;
            highp vec3 loc_31e9d;
            highp vec3 loc_0a326;
            if (arg_9a2b4)
            {
                highp float loc_a6fcb = max(dot(arg_6ff9e, loc_a3520), 0.0);
                highp float loc_237eb = max(dot(arg_6ff9e, arg_901f6), 0.0);
                highp vec3 loc_1b829 = normalize(loc_a3520 + arg_901f6);
                highp float loc_5c285 = arg_6578f.w * arg_6578f.w;
                highp float loc_3f332 = loc_5c285 * loc_5c285;
                highp float loc_5d7aa = max(dot(arg_6ff9e, loc_1b829), 0.0);
                highp float loc_89d01 = max((((loc_3f332 - 1.0) * loc_5d7aa) * loc_5d7aa) + 1.0, 9.9999997473787516355514526367188e-05);
                highp float loc_fabe5 = loc_5c285 * 0.5;
                highp vec3 loc_481af = arg_20396 + ((vec3(1.0) - arg_20396) * pow(clamp(1.0 - max(dot(arg_901f6, loc_1b829), 0.0), 0.0, 1.0), 5.0));
                highp vec3 loc_4ecdc = arg_dd9d3 * (1.0 - arg_f859b);
                loc_0a326 = (((loc_481af * (loc_3f332 / ((loc_89d01 * loc_89d01) * 3.1415927410125732421875))) * ((loc_237eb / (((loc_237eb * (1.0 - loc_fabe5)) + loc_fabe5) + 9.9999997473787516355514526367188e-05)) * (loc_a6fcb / (((loc_a6fcb * (1.0 - loc_fabe5)) + loc_fabe5) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_a6fcb) * loc_237eb) + 9.9999997473787516355514526367188e-05)) * loc_a6fcb;
                loc_31e9d = (loc_4ecdc * vec3(0.3183098733425140380859375)) * (arg_fe933 * max((dot(-arg_6ff9e, loc_a3520) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / ((1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) * (1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y)), 0.0));
                loc_e0df3 = ((vec3(1.0) - loc_481af) * mix(loc_a6fcb, max((dot(arg_6ff9e, loc_a3520) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / ((1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) * (1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y)), 0.0), arg_fe933)) * (loc_4ecdc * vec3(0.3183098733425140380859375));
            }
            else
            {
                highp vec3 loc_1e40c = arg_dd9d3 * (1.0 - arg_f859b);
                loc_0a326 = vec3(0.0);
                loc_31e9d = (loc_1e40c * vec3(0.3183098733425140380859375)) * (arg_fe933 * max((dot(-arg_6ff9e, loc_a3520) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / ((1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) * (1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y)), 0.0));
                loc_e0df3 = (loc_1e40c * vec3(0.3183098733425140380859375)) * mix(max(dot(arg_6ff9e, loc_a3520), 0.0), max((dot(arg_6ff9e, loc_a3520) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / ((1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) * (1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y)), 0.0), arg_fe933);
            }
            loc_b2ace = loc_0a326;
            loc_05c79 = loc_31e9d;
            loc_12949 = loc_e0df3;
        }
        else
        {
            highp vec3 loc_28315;
            if (arg_9a2b4)
            {
                highp float loc_ef62e = max(dot(arg_6ff9e, loc_a3520), 0.0);
                highp float loc_a1457 = max(dot(arg_6ff9e, arg_901f6), 0.0);
                highp vec3 loc_7eea9 = normalize(loc_a3520 + arg_901f6);
                highp float loc_59c0d = arg_6578f.w * arg_6578f.w;
                highp float loc_dc1e8 = loc_59c0d * loc_59c0d;
                highp float loc_d294e = max(dot(arg_6ff9e, loc_7eea9), 0.0);
                highp float loc_99746 = max((((loc_dc1e8 - 1.0) * loc_d294e) * loc_d294e) + 1.0, 9.9999997473787516355514526367188e-05);
                highp float loc_04f70 = loc_59c0d * 0.5;
                loc_28315 = ((((arg_20396 + ((vec3(1.0) - arg_20396) * pow(clamp(1.0 - max(dot(arg_901f6, loc_7eea9), 0.0), 0.0, 1.0), 5.0))) * (loc_dc1e8 / ((loc_99746 * loc_99746) * 3.1415927410125732421875))) * ((loc_a1457 / (((loc_a1457 * (1.0 - loc_04f70)) + loc_04f70) + 9.9999997473787516355514526367188e-05)) * (loc_ef62e / (((loc_ef62e * (1.0 - loc_04f70)) + loc_04f70) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_ef62e) * loc_a1457) + 9.9999997473787516355514526367188e-05)) * loc_ef62e;
            }
            else
            {
                loc_28315 = vec3(0.0);
            }
            loc_b2ace = loc_28315;
            loc_05c79 = vec3(0.0);
            loc_12949 = vec3(0.0);
        }
        loc_62c27 = loc_23246 + 1;
        highp vec3 loc_5cb7b;
        func_8ae36(loc_ddace, loc_2cc07, loc_5cb7b, arg_5e370, arg_78ca7);
        loc_fa2ec += loc_ddace;
        loc_49b5f = loc_68344 + (((loc_12949 + loc_05c79) * loc_5cb7b) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_7a7eb = loc_118d9 + ((loc_b2ace * loc_5cb7b) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    bool loc_1daa4;
    if (loc_23246 > 0)
    {
        highp vec3 loc_6dcb8 = loc_fa2ec.xyz / vec3(float(loc_23246));
        loc_fa2ec = vec4(loc_6dcb8.x, loc_6dcb8.y, loc_6dcb8.z, loc_fa2ec.w);
        loc_fa2ec.w /= float(loc_23246);
        loc_1daa4 = false;
    }
    else
    {
        loc_1daa4 = var_a33e3;
    }
    arg_33e52 = loc_1daa4;
    arg_3289d = loc_68344;
    arg_98547 = loc_118d9;
    arg_82d08 = loc_fa2ec;
}
void main() {
    highp vec4 var_d6549 = texture(s_SceneDepth, v_texcoord0);
    highp float var_971b7 = (var_d6549.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_971b7, 1.0);
    highp mat4 var_3460a = u_invProj;
    highp float var_eb413 = var_df846.x;
    highp float var_ac116 = var_df846.y;
    highp float var_f2b7c = var_df846.w;
    highp float var_0357c = var_df846.z;
    highp float var_2c821 = var_df846.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_3460a[0].x, var_ac116 * var_3460a[1].y, var_f2b7c * var_3460a[3].z, (var_0357c * var_3460a[2].w) + (var_2c821 * var_3460a[3].w));
    var_df846 = var_9666f;
    highp float var_d799e = var_df846.w;
    highp vec4 var_fe08a = var_9666f / vec4(var_d799e);
    var_df846 = var_fe08a;
    highp vec4 var_b2e90 = u_invView * vec4(var_fe08a.xyz, 1.0);
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
    highp vec3 var_12b45 = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_0ab5e = normalize((u_view * vec4(var_12b45, 0.0)).xyz);
    highp vec4 var_124e5 = texture(s_ColorMetalnessSubsurface, v_texcoord0);
    highp vec4 var_4ac0e = var_124e5;
    highp float var_b75f1 = clamp(2.007874011993408203125 * (var_4ac0e.w - 0.501960813999176025390625), 0.0, 1.0);
    highp vec4 var_b151c = texture(s_EmissiveAmbientLinearRoughness, v_texcoord0);
    highp vec3 var_6243b = var_b2e90.xyz;
    highp vec3 var_1fd84 = var_fe08a.xyz;
    highp vec3 var_ce54f = vec3(v_projPosition.xy, var_971b7);
    highp vec3 var_6be13 = pow(max(var_124e5.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
    highp vec3 var_b3cd6 = vec3(0.039999999105930328369140625 * (1.0 - var_b75f1)) + (var_6be13 * var_b75f1);
    highp float var_49182;
    if (CausticsParameters.x != 0.0)
    {
        int var_73b1b = int(DirectionalLightSourceShadowCascadeNumber[0].x);
        bool var_98743;
        if (var_73b1b >= 0)
        {
            highp vec4 var_f796a = DirectionalLightSourceWaterSurfaceViewProj[0] * vec4(var_b2e90.xyz, 1.0);
            highp vec4 var_412ca = var_f796a;
            highp vec3 var_d9d7f = var_f796a.xyz / vec3(var_412ca.w);
            highp vec4 var_adb58 = DirectionalLightSourceWaterSurfaceViewProj[0] * vec4(var_b2e90.xyz, 1.0);
            highp vec4 var_e4630 = var_adb58;
            highp vec3 var_f4c6b = var_adb58.xyz / vec3(var_e4630.w);
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
            highp vec4 var_e1a40 = DirectionalLightSourceCausticsViewProj[0] * vec4(var_6243b - WorldOrigin.xyz, 1.0);
            highp vec4 var_314a4 = var_e1a40;
            highp vec3 var_3e72a = var_e1a40.xyz / vec3(var_314a4.w);
            var_3e72a.y *= (-1.0);
            highp vec2 var_9b904 = (var_3e72a.xy + vec2(1.0)) * 0.5;
            highp float var_74cec = var_9b904.x;
            highp float var_83bc9 = var_9b904.y;
            highp vec2 var_7c780 = vec2(var_74cec, 1.0 - var_83bc9);
            var_9b904 = var_7c780;
            highp vec2 var_a6509 = var_7c780 * CausticsParameters.y;
            highp float var_71399;
            if (CausticsTextureParameters.x != 0.0)
            {
                var_a6509 = vec2(var_a6509.x - floor(var_a6509.x), var_a6509.y - floor(var_a6509.y));
                var_a6509.y = CausticsTextureParameters.y + (var_a6509.y * (CausticsTextureParameters.z - CausticsTextureParameters.y));
                var_71399 = texture(s_CausticsTexture, var_a6509).x * 2.0;
            }
            else
            {
                highp float var_25f77;
                highp float var_879d8;
                highp vec2 var_e71da;
                var_e71da = var_a6509;
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
                var_71399 = var_25f77 / var_879d8;
            }
            var_ac788 = pow(var_71399, float(int(CausticsParameters.z))) * float(int(CausticsParameters.z) + 1);
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
            highp vec4 var_54913 = DirectionalLightSourceWaterSurfaceViewProj[1] * vec4(var_b2e90.xyz, 1.0);
            highp vec4 var_3dcc5 = var_54913;
            highp vec3 var_e4a33 = var_54913.xyz / vec3(var_3dcc5.w);
            highp vec4 var_cb69f = DirectionalLightSourceWaterSurfaceViewProj[1] * vec4(var_b2e90.xyz, 1.0);
            highp vec4 var_307c8 = var_cb69f;
            highp vec3 var_e810f = var_cb69f.xyz / vec3(var_307c8.w);
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
            highp vec4 var_e17a8 = DirectionalLightSourceCausticsViewProj[1] * vec4(var_6243b - WorldOrigin.xyz, 1.0);
            highp vec4 var_f6ea6 = var_e17a8;
            highp vec3 var_a60c8 = var_e17a8.xyz / vec3(var_f6ea6.w);
            var_a60c8.y *= (-1.0);
            highp vec2 var_5f3df = (var_a60c8.xy + vec2(1.0)) * 0.5;
            highp float var_b4854 = var_5f3df.x;
            highp float var_f2637 = var_5f3df.y;
            highp vec2 var_f8276 = vec2(var_b4854, 1.0 - var_f2637);
            var_5f3df = var_f8276;
            highp vec2 var_ed595 = var_f8276 * CausticsParameters.y;
            highp float var_e7a0d;
            if (CausticsTextureParameters.x != 0.0)
            {
                var_ed595 = vec2(var_ed595.x - floor(var_ed595.x), var_ed595.y - floor(var_ed595.y));
                var_ed595.y = CausticsTextureParameters.y + (var_ed595.y * (CausticsTextureParameters.z - CausticsTextureParameters.y));
                var_e7a0d = texture(s_CausticsTexture, var_ed595).x * 2.0;
            }
            else
            {
                highp float var_1bd34;
                highp float var_3dcb9;
                highp vec2 var_0b7eb;
                var_0b7eb = var_ed595;
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
                var_e7a0d = var_1bd34 / var_3dcb9;
            }
            var_7e3b5 = pow(var_e7a0d, float(int(CausticsParameters.z))) * float(int(CausticsParameters.z) + 1);
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
    highp vec3 var_84dfb = var_1fd84;
    highp vec3 var_5bd0a = var_ce54f;
    highp vec3 var_811e1 = var_1fd84;
    highp float var_3707d;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        var_3707d = (abs(var_811e1.x) + abs(var_811e1.y)) + abs(var_811e1.z);
    }
    else
    {
        var_3707d = length(var_1fd84);
    }
    bool var_464cb = PointLightSpecularFadeOutParameters.x > 0.0;
    highp float var_5d160;
    if (var_464cb)
    {
        var_5d160 = smoothstep(PointLightSpecularFadeOutParameters.x, PointLightSpecularFadeOutParameters.y, var_3707d);
    }
    else
    {
        var_5d160 = 0.0;
    }
    bool var_49ba4 = !var_464cb;
    bool var_37230;
    if (!var_49ba4)
    {
        var_37230 = var_464cb && (var_3707d < PointLightSpecularFadeOutParameters.y);
    }
    else
    {
        var_37230 = var_49ba4;
    }
    bool var_686c7 = PointLightDiffuseFadeOutParameters.x > 0.0;
    highp float var_f3062;
    if (var_686c7)
    {
        var_f3062 = smoothstep(PointLightDiffuseFadeOutParameters.x, PointLightDiffuseFadeOutParameters.y, var_3707d);
    }
    else
    {
        var_f3062 = 0.0;
    }
    bool var_70859 = !var_686c7;
    bool var_8ba1b;
    if (!var_70859)
    {
        var_8ba1b = var_686c7 && (var_3707d < PointLightDiffuseFadeOutParameters.y);
    }
    else
    {
        var_8ba1b = var_70859;
    }
    highp vec3 var_aac15 = -(var_1fd84 / vec3(length(var_1fd84) + 9.9999997473787516355514526367188e-05));
    highp float var_c59b3 = clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_4ac0e.w), 0.0, 1.0) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
    bool var_5a6e4;
    highp vec4 var_9a0a9;
    highp vec3 var_7587d;
    highp vec3 var_baf98;
    if (var_5bd0a.z != 1.0)
    {
        highp vec2 var_b51ae = vec2(var_49182, var_280ef);
        highp vec3 var_9b421;
        highp vec3 var_4e5a9;
        func_5d237(var_6243b, var_b151c, var_4e5a9, var_9b421, var_0ab5e, var_84dfb, var_b2e90, var_b51ae, var_aac15, var_b3cd6, var_6be13, var_b75f1, var_c59b3);
        highp vec3 var_6bb48 = var_1fd84;
        highp vec4 var_1b4da;
        highp vec3 var_c1a13;
        highp vec3 var_da80f;
        bool var_716f8;
        func_55aa7(var_37230, var_8ba1b, var_716f8, var_da80f, var_c1a13, var_1b4da, var_6bb48, var_1fd84, var_0ab5e, var_aac15, var_b151c, var_b3cd6, var_6be13, var_b75f1, var_c59b3, var_6243b, var_12b45);
        var_baf98 = var_4e5a9 + (var_da80f * (1.0 - var_f3062));
        var_7587d = var_9b421 + (var_c1a13 * (1.0 - var_5d160));
        var_9a0a9 = var_1b4da;
        var_5a6e4 = var_716f8;
    }
    else
    {
        var_baf98 = vec3(0.0);
        var_7587d = vec3(0.0);
        var_9a0a9 = vec4(0.0, 0.0, 0.0, 1.0);
        var_5a6e4 = true;
    }
    highp float var_c73ed;
    if (var_5a6e4)
    {
        var_c73ed = PointLightDiffuseFadeOutParameters.w;
    }
    else
    {
        var_c73ed = PointLightDiffuseFadeOutParameters.z + ((PointLightDiffuseFadeOutParameters.w - PointLightDiffuseFadeOutParameters.z) * var_f3062);
    }
    highp vec4 var_b891d = var_9a0a9;
    highp vec4 var_95ec4 = SkyAmbientLightColorIntensity;
    highp float var_72fbb = var_b151c.y * var_b151c.y;
    highp vec3 var_1c774 = (((((var_6be13 * (1.0 - var_b75f1)) * max(((clamp(vec3(var_72fbb + (var_b891d.x * var_b891d.w), (var_72fbb * ((((var_72fbb * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_b891d.y * var_b891d.w), (var_72fbb * (((var_72fbb * var_72fbb) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_b891d.z * var_b891d.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * var_c73ed) + ((SkyAmbientLightColorIntensity.xyz * pow(var_b151c.z, mix(5.0, 3.0, CameraLightIntensity.y))) * var_95ec4.w), vec3(0.02999999932944774627685546875))) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_baf98) + var_7587d) + (((mix(var_6be13, vec3(dot(var_6be13, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_b151c.x)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x);
    highp float var_7d5ab = length(var_1fd84);
    highp vec3 var_db82c = normalize(var_6243b - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
    highp vec3 var_7e3dc;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_3de5f = clamp((((var_7d5ab / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_cb5ed;
        if (var_3de5f > 0.0)
        {
            highp vec3 var_a6488;
            if (!(AtmosphericScatteringToggles.y != 0.0))
            {
                var_a6488 = FogColor.xyz;
            }
            else
            {
                highp vec4 var_da187 = SunColor;
                highp vec4 var_9cde9 = MoonColor;
                highp vec3 var_e3755 = var_db82c;
                highp float var_7b136 = FogSkyBlend.x - FogSkyBlend.w;
                highp float var_d7734 = smoothstep(FogSkyBlend.y, var_7b136, var_e3755.y);
                highp float var_3c557 = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_7b136, var_e3755.y);
                highp float var_50871 = dot(var_db82c, SunDir.xyz);
                highp float var_ae018 = dot(var_db82c, MoonDir.xyz);
                highp float var_5301e = 0.5 * (var_50871 + 1.0);
                highp float var_9a714 = 0.5 * (var_ae018 + 1.0);
                highp float var_4e792 = clamp(pow(max(var_50871, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_72556 = clamp(pow(max(var_ae018, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                var_a6488 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_d7734 * var_d7734) * var_d7734, 0.0, 1.0))) * AtmosphericScattering.x) * 0.0596831031143665313720703125) * (((var_5301e * var_5301e) * var_da187.w) + ((var_9a714 * var_9a714) * var_9cde9.w))) + (((SkyHorizonColor.xyz * clamp((var_3c557 * var_3c557) * var_3c557, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_da187.w) * AtmosphericScattering.y) * var_4e792) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_4e792 * 1.7999999523162841796875), 1.5))) + ((((MoonColor.xyz * var_9cde9.w) * AtmosphericScattering.z) * var_72556) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_72556 * 1.7999999523162841796875), 1.5)))));
            }
            var_cb5ed = mix(var_1c774, var_a6488, vec3(var_3de5f));
        }
        else
        {
            var_cb5ed = var_1c774;
        }
        var_7e3dc = var_cb5ed;
    }
    else
    {
        var_7e3dc = mix(var_1c774, FogColor.xyz, vec3(clamp((((var_7d5ab / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0)));
    }
    highp vec3 var_b5c58;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_ce54f.xy + vec2(1.0)) * 0.5;
        highp vec4 var_cf4b5 = u_invProj * vec4(v_projPosition.xy, var_971b7, 1.0);
        highp float var_b4ccc = var_7d045.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_b4ccc, var_7d045.y, log((53.598148345947265625 * ((((-var_cf4b5.z) / var_cf4b5.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_eb2d5 = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_5363d = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        highp vec4 var_67b96 = var_5363d;
        var_b5c58 = var_5363d.xyz + (var_7e3dc * var_67b96.w);
    }
    else
    {
        var_b5c58 = var_7e3dc;
    }
    highp vec4 var_70b93 = vec4(var_b5c58, 1.0);
    highp vec4 var_38beb;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec3 var_02f69 = var_70b93.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_38beb = vec4(var_02f69.x, var_02f69.y, var_02f69.z, var_70b93.w);
    }
    else
    {
        var_38beb = var_70b93;
    }
    bgfx_FragColor = var_38beb;
}
