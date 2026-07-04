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
* Change_Color:
* - CHANGE_COLOR__MULTI
* - CHANGE_COLOR__OFF
* - CHANGE_COLOR__ON
*
* Emissive:
* - EMISSIVE__EMISSIVE (not used)
* - EMISSIVE__EMISSIVE_ONLY (not used)
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF
* - MASKED_MULTITEXTURE__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2D s_CausticsTexture;
* - layout(binding = 2, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 3, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_MERSTexture;
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_MatTexture1;
* - uniform lowp sampler2D s_NormalTexture;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform mat4 Bones[8];
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
* - uniform vec4 EmissiveUniform;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 HudOpacity;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
* - uniform vec4 MetalnessUniform;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 PBRTextureFlags;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform mat4 PrevBones[8];
* - uniform mat4 PrevWorld;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 RoughnessUniform;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowQuantizationParameters;
* - uniform vec4 ShadowSlopeBias;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SubsurfaceUniform;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 Time;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UseAlphaRewrite;
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

layout(binding = 3, std430) buffer s_Lights { Light Lights[]; } var_a69d2;
layout(binding = 2, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_bd027;
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
uniform highp mat4 u_model[4];
uniform highp mat4 u_proj;
uniform highp mat4 u_view;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2D s_CausticsTexture;
uniform highp sampler2D s_MERSTexture;
#ifdef MASKED_MULTITEXTURE__ON
uniform highp sampler2D s_MatTexture1;
#endif
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_NormalTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadeShadowResolutions;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ClusterNearFarWidthHeight;
uniform highp vec4 ClusterSize;
uniform highp vec4 ColorBased;
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
uniform highp vec4 EmissiveUniform;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 LastSpecularIBLIdx;
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 MatColor;
uniform highp vec4 MetalnessUniform;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 PBRTextureFlags;
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightDiffuseFadeOutParameters;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 PointLightSpecularFadeOutParameters;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 RoughnessUniform;
uniform highp vec4 ShadowBias;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
uniform highp vec4 ShadowPCFWidth;
uniform highp vec4 ShadowQuantizationParameters;
uniform highp vec4 ShadowSlopeBias;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 SubsurfaceUniform;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 Time;
uniform highp vec4 UseAlphaRewrite;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WaterExtinctionCoefficients;
uniform highp vec4 WaterSurfaceOctaveParameters;
uniform highp vec4 WaterSurfaceParameters;
uniform highp vec4 WaterSurfaceWaveParameters;
uniform highp vec4 WorldOrigin;
in highp vec3 v_bitangent;
in highp vec4 v_color0;
in highp vec3 v_normal;
in highp vec3 v_tangent;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
mat4 var_62632;
float var_2ce5b;
int var_e7b23;
bool var_a33e3;
float var_aaae6;
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
void func_81441(inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec3 arg_02c40, inout highp vec3 arg_326a5, inout highp vec3 arg_abe00, inout highp vec2 arg_c288e, inout highp vec3 arg_99739, inout highp float arg_2bc6f, inout highp vec3 arg_85276, inout highp vec3 arg_cff01, inout highp float arg_5416d, inout highp float arg_24e02) {
    if (abs(TileLightIntensity.y) < 9.9999997473787516355514526367188e-05)
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
    for (int loc_a5f76 = 0; loc_a5f76 < loc_a14ca; loc_0bf4d = loc_3ac48, loc_122db = loc_12766, loc_7a912 = loc_f5dfb, loc_bd26f = loc_1a85e, loc_a5f76++)
    {
        highp float loc_75755;
        highp float loc_27a4b;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            highp float loc_955a9 = max(dot(arg_02c40, normalize((u_view * DirectionalLightSourceShadowDirection[loc_a5f76]).xyz)), 0.0);
            int loc_dc8b4;
            highp vec4 loc_d73c9;
            highp mat4 loc_b250f;
            func_9040f(loc_a5f76, arg_326a5, loc_b250f, loc_d73c9, loc_dc8b4, loc_bd26f);
            highp vec4 loc_08b3b = loc_d73c9;
            highp float loc_8766b;
            highp float loc_be413;
            if (loc_dc8b4 != (-1))
            {
                highp float loc_0877b = ShadowBias[loc_dc8b4] + (ShadowSlopeBias[loc_dc8b4] * clamp(tan(acos(loc_955a9)), 0.0, 1.0));
                highp float loc_9a3cf = SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z * length(loc_b250f * vec4(0.0, 0.0, 1.0, 0.0));
                int loc_82d7a = int(DirectionalLightSourceShadowCascadeNumber[loc_a5f76].x);
                highp float loc_47769;
                highp float loc_079c0;
                func_1aef6(loc_82d7a, loc_079c0, loc_47769, loc_dc8b4, loc_08b3b, loc_9a3cf, loc_0877b);
                highp float loc_ad256;
                if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
                {
                    highp float loc_93efa;
                    func_7a524(arg_326a5, loc_955a9, loc_93efa);
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
                highp float loc_e4c4c;
                if (loc_643a4)
                {
                    highp vec4 loc_1a6df = CloudShadowProj * vec4(arg_326a5, 1.0);
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
        highp vec3 loc_8328b = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_a5f76]).xyz);
        highp vec4 loc_5b55e = DirectionalLightSourceDiffuseColorAndIlluminance[loc_a5f76];
        highp vec3 loc_03c38 = (((DirectionalLightSourceDiffuseColorAndIlluminance[loc_a5f76].xyz * loc_5b55e.w) * loc_791d7) * arg_c288e[loc_a5f76]) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
        highp float loc_a9584 = max(dot(arg_02c40, loc_8328b), 0.0);
        highp float loc_af6fd = max(dot(arg_02c40, arg_99739), 0.0);
        highp vec3 loc_c829d = normalize(loc_8328b + arg_99739);
        highp float loc_a68f1 = arg_2bc6f * arg_2bc6f;
        highp float loc_e5081 = loc_a68f1 * loc_a68f1;
        highp float loc_87b4a = max(dot(arg_02c40, loc_c829d), 0.0);
        highp float loc_cd8b0 = max((((loc_e5081 - 1.0) * loc_87b4a) * loc_87b4a) + 1.0, 9.9999997473787516355514526367188e-05);
        highp float loc_ad7fb = loc_a68f1 * 0.5;
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
void func_1799c(inout int arg_47a77, inout highp float arg_9eee0, inout highp vec3 arg_0623c, inout highp vec3 arg_1bb2e) {
    if (var_a69d2.Lights[arg_47a77].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        return;
    }
    highp vec3 loc_2b15e = arg_0623c - var_a69d2.Lights[arg_47a77].position.xyz;
    highp vec3 loc_b2243 = abs(loc_2b15e);
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
    highp vec4 loc_f7c8d = PointLightProj * vec4(loc_b2243, 1.0);
    loc_f7c8d.z -= (PointLightShadowParams1.x + (PointLightShadowParams1.y * clamp(tan(acos(dot(normalize(-loc_2b15e), normalize(arg_1bb2e)))), 0.0, 1.0)));
    loc_f7c8d /= vec4(loc_f7c8d.w);
    highp vec3 loc_ad23e = loc_2b15e;
    bool loc_fe444 = abs(loc_ad23e.y) > abs(loc_ad23e.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_ad23e.y) > abs(loc_ad23e.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_ad23e.z *= (-1.0);
    }
    else
    {
        loc_ad23e.y *= (-1.0);
    }
    highp float loc_591c8;
    if (((textureLod(s_PointLightShadowTextureArray, vec4(loc_ad23e, float(var_a69d2.Lights[arg_47a77].shadowProbeIndex)), 0.0).x * 2.0) - 1.0) >= loc_f7c8d.z)
    {
        loc_591c8 = 1.0;
    }
    else
    {
        loc_591c8 = 0.0;
    }
    arg_9eee0 = loc_591c8;
}
void func_deced(inout highp vec4 arg_83841, inout int arg_50e58, inout highp vec3 arg_62394, inout highp vec3 arg_ab1f6, inout highp vec3 arg_81f82) {
    arg_83841 = vec4(0.0);
    if (arg_50e58 < 0)
    {
        arg_62394 = vec3(0.0);
        return;
    }
    highp vec3 loc_569de = var_a69d2.Lights[arg_50e58].position.xyz - v_worldPos;
    highp vec3 loc_8cb9b = loc_569de;
    highp float loc_95cea;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_95cea = loc_1829d * loc_1829d;
    }
    else
    {
        loc_95cea = dot(loc_569de, loc_569de);
    }
    if (loc_95cea >= (var_a69d2.Lights[arg_50e58].position.w * var_a69d2.Lights[arg_50e58].position.w))
    {
        arg_62394 = vec3(0.0);
        return;
    }
    highp float loc_33ea0;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_1b78e;
        func_1799c(arg_50e58, loc_1b78e, arg_ab1f6, arg_81f82);
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
    highp float loc_fd676 = loc_95cea / ((var_a69d2.Lights[arg_50e58].position.w * var_a69d2.Lights[arg_50e58].position.w) + 9.9999997473787516355514526367188e-05);
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
    highp vec3 loc_13960 = var_a69d2.Lights[arg_50e58].color.xyz * loc_3d192;
    arg_83841 = vec4(loc_13960.x, loc_13960.y, loc_13960.z, arg_83841.w);
    arg_83841.w = 1.0 - (loc_95cea / ((var_a69d2.Lights[arg_50e58].position.w * var_a69d2.Lights[arg_50e58].position.w) + 9.9999997473787516355514526367188e-05));
    arg_62394 = (((var_a69d2.Lights[arg_50e58].color.xyz * var_a69d2.Lights[arg_50e58].color.w) * loc_3d192) * loc_33ea0) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_d5e06(inout bool arg_9a2b4, inout bool arg_b6724, inout bool arg_33e52, inout highp vec3 arg_3289d, inout highp vec3 arg_98547, inout highp vec4 arg_82d08, inout highp vec3 arg_dc0ef, inout highp vec3 arg_96daa, inout highp vec3 arg_89c41, inout highp vec3 arg_6ff9e, inout highp vec3 arg_901f6, inout highp float arg_e730a, inout highp vec3 arg_20396, inout highp vec3 arg_dd9d3, inout highp float arg_f859b, inout highp float arg_fe933, inout highp vec3 arg_5e370, inout highp vec3 arg_78ca7) {
    highp vec4 loc_fa2ec = vec4(0.0);
    if (!(arg_9a2b4 || arg_b6724))
    {
        arg_33e52 = var_a33e3;
        arg_3289d = vec3(0.0);
        arg_98547 = vec3(0.0);
        arg_82d08 = loc_fa2ec;
        return;
    }
    bool loc_9f3ca;
    int loc_2aee5;
    int loc_9d2b5;
    func_36e28(arg_dc0ef, arg_96daa, loc_9d2b5, loc_2aee5, loc_9f3ca);
    if (!loc_9f3ca)
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
    for (int loc_0ad25 = loc_2aee5; loc_0ad25 < loc_9d2b5; loc_118d9 = loc_7a7eb, loc_68344 = loc_49b5f, loc_23246 = loc_62c27, loc_0ad25++)
    {
        int loc_2cc07 = int(var_bd027.LightLookupArray[loc_0ad25].lookup);
        if (loc_2cc07 < 0)
        {
            break;
        }
        highp vec3 loc_a3520 = normalize((u_view * vec4(var_a69d2.Lights[loc_2cc07].position.xyz, 1.0)).xyz - arg_89c41);
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
                highp float loc_59789 = arg_e730a * arg_e730a;
                highp float loc_3f332 = loc_59789 * loc_59789;
                highp float loc_5d7aa = max(dot(arg_6ff9e, loc_1b829), 0.0);
                highp float loc_89d01 = max((((loc_3f332 - 1.0) * loc_5d7aa) * loc_5d7aa) + 1.0, 9.9999997473787516355514526367188e-05);
                highp float loc_fabe5 = loc_59789 * 0.5;
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
                highp float loc_22daf = arg_e730a * arg_e730a;
                highp float loc_dc1e8 = loc_22daf * loc_22daf;
                highp float loc_d294e = max(dot(arg_6ff9e, loc_7eea9), 0.0);
                highp float loc_99746 = max((((loc_dc1e8 - 1.0) * loc_d294e) * loc_d294e) + 1.0, 9.9999997473787516355514526367188e-05);
                highp float loc_04f70 = loc_22daf * 0.5;
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
        func_deced(loc_ddace, loc_2cc07, loc_5cb7b, arg_5e370, arg_78ca7);
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
void func_fc162(inout highp float arg_dba2b, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec3 loc_87280 = (AmbientLightParams.xyz * arg_dba2b) * AmbientLightParams.w;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_87280, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_87280, 1.0);
}
void main() {
#ifdef MASKED_MULTITEXTURE__OFF
    highp vec4 var_2c432 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_ade26 = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(MASKED_MULTITEXTURE__OFF) && !defined(CHANGE_COLOR__MULTI)
    highp vec4 var_1d57a = var_2c432;
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_76534 = var_ade26;
    highp vec4 var_2c432 = mix(var_ade26, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_76534.x + var_76534.y) + var_76534.z) * (1.0 - var_76534.w)) > 0.0)));
#endif
#ifdef CHANGE_COLOR__MULTI
    highp vec2 var_459de = var_2c432.xy;
    highp vec3 var_1099e = mix((var_2c432.xxx * ChangeColor.xyz).xyz, var_2c432.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_459de.y)));
    highp vec4 var_1d57a = vec4(var_1099e.x, var_1099e.y, var_1099e.z, var_2c432.w);
#endif
#if defined(MASKED_MULTITEXTURE__ON) && !defined(CHANGE_COLOR__MULTI)
    highp vec4 var_1d57a = var_2c432;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp vec3 var_fba6e = mix(var_2c432.xyz, var_2c432.xyz * ChangeColor.xyz, vec3(var_1d57a.w));
    var_1d57a = vec4(var_fba6e.x, var_fba6e.y, var_fba6e.z, var_2c432.w);
    var_1d57a.w *= var_8a135.w;
#endif
    var_1d57a.w = max(UseAlphaRewrite.x, var_1d57a.w);
    var_2c432 = var_1d57a;
    highp vec3 var_491ab = mix((var_1d57a.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_f039a = vec4(var_491ab.x, var_491ab.y, var_491ab.z, var_1d57a.w);
    highp vec3 var_d0f91 = var_491ab.xyz;
    int var_f71fc = int(PBRTextureFlags.x);
    highp float var_c34bb;
    highp float var_2c6d0;
    highp float var_1e735;
    highp float var_76cb9;
    if ((var_f71fc & 1) == 1)
    {
        highp vec4 var_4035b = texture(s_MERSTexture, v_texcoord0);
        highp float var_ae1fa;
        if ((var_f71fc & 2) == 2)
        {
            var_ae1fa = var_4035b.w;
        }
        else
        {
            var_ae1fa = SubsurfaceUniform.x;
        }
        var_76cb9 = var_ae1fa;
        var_1e735 = var_4035b.z;
        var_2c6d0 = var_4035b.y;
        var_c34bb = var_4035b.x;
    }
    else
    {
        var_76cb9 = SubsurfaceUniform.x;
        var_1e735 = RoughnessUniform.x;
        var_2c6d0 = EmissiveUniform.x;
        var_c34bb = MetalnessUniform.x;
    }
    highp vec3 var_d39c8;
    if ((var_f71fc & 4) == 4)
    {
        var_d39c8 = normalize(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(v_normal))) * ((texture(s_NormalTexture, v_texcoord0).xyz * 2.0) - vec3(1.0)));
    }
    else
    {
        highp vec3 var_aef9e;
        if ((var_f71fc & 8) == 8)
        {
            highp vec2 var_ac6af = v_texcoord0;
            highp vec3 var_cf411 = vec3(0.0, 0.0, 1.0);
            highp vec2 var_2b303 = var_ac6af;
            highp vec2 var_4dc97 = var_2b303 * vec2(textureSize(s_NormalTexture, 0));
            highp vec2 var_700bf = fract(var_4dc97);
            if (abs(var_700bf.x - 0.5) < 0.0625)
            {
                var_ac6af.x += ((var_700bf.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
            }
            if (abs(var_700bf.y - 0.5) < 0.0625)
            {
                var_ac6af.y += ((var_700bf.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
            }
            highp vec4 var_fbe6c = textureGather(s_NormalTexture, var_ac6af);
            highp vec2 var_6748a = fract(var_4dc97 + vec2(0.5));
            highp vec2 var_2054b;
            if (var_6748a.y > 0.5)
            {
                var_2054b = var_fbe6c.xy;
            }
            else
            {
                var_2054b = var_fbe6c.wz;
            }
            highp vec2 var_97412 = var_2054b;
            ivec2 var_85f5c = ivec2(clamp(vec2(var_6748a.x - 0.083333335816860198974609375, var_6748a.x + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
            var_cf411.x = var_97412[var_85f5c.x] - var_97412[var_85f5c.y];
            highp vec2 var_d2f6f;
            if (var_6748a.x > 0.5)
            {
                var_d2f6f = var_fbe6c.zy;
            }
            else
            {
                var_d2f6f = var_fbe6c.wx;
            }
            var_97412 = var_d2f6f;
            var_85f5c = ivec2(clamp(vec2(var_6748a.y - 0.083333335816860198974609375, var_6748a.y + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
            var_cf411.y = var_97412[var_85f5c.x] - var_97412[var_85f5c.y];
            var_cf411.z = 0.25;
            highp vec3 var_822b4 = normalize(var_cf411);
            highp vec2 var_2df8f = var_822b4.xy * 1.0;
            var_cf411 = vec3(var_2df8f.x, var_2df8f.y, var_822b4.z);
            var_aef9e = normalize(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(v_normal))) * var_cf411);
        }
        else
        {
            var_aef9e = v_normal;
        }
        var_d39c8 = var_aef9e;
    }
    highp vec4 var_9f386 = u_view * (u_model[0] * vec4(v_worldPos, 1.0));
    highp vec4 var_e87e0 = u_proj * var_9f386;
    highp vec4 var_b8928 = var_e87e0;
    highp vec3 var_d70da = var_e87e0.xyz / vec3(var_b8928.w);
    highp vec4 var_7c164 = vec4(normalize(var_d39c8), 1.0);
    highp vec3 var_1312d = var_9f386.xyz;
    highp vec3 var_c71ce = var_7c164.xyz;
    highp vec3 var_02454 = (u_view * var_7c164).xyz;
    highp vec3 var_3ede4 = vec3(0.039999999105930328369140625 * (1.0 - var_c34bb)) + (var_d0f91 * var_c34bb);
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
    highp float var_d893e = length(var_1312d);
    highp vec3 var_0d894 = var_1312d;
    highp vec3 var_5bd0a = var_d70da;
    highp vec3 var_811e1 = var_1312d;
    highp float var_3707d;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        var_3707d = (abs(var_811e1.x) + abs(var_811e1.y)) + abs(var_811e1.z);
    }
    else
    {
        var_3707d = length(var_1312d);
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
    bool var_512b6;
    if (!var_49ba4)
    {
        var_512b6 = var_464cb && (var_3707d < PointLightSpecularFadeOutParameters.y);
    }
    else
    {
        var_512b6 = var_49ba4;
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
    bool var_c0bfd;
    if (!var_70859)
    {
        var_c0bfd = var_686c7 && (var_3707d < PointLightDiffuseFadeOutParameters.y);
    }
    else
    {
        var_c0bfd = var_70859;
    }
    highp vec3 var_4eacb = -(var_1312d / vec3(length(var_1312d) + 9.9999997473787516355514526367188e-05));
    highp float var_9024c = var_76cb9 * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
    highp vec3 var_9e07f;
    if (ShadowQuantizationParameters.y > 0.0)
    {
        highp vec3 var_8ae03 = v_worldPos - WorldOrigin.xyz;
        highp vec3 var_ce28e = normalize(cross(normalize(dFdx(var_8ae03)), normalize(dFdy(var_8ae03))));
        highp vec3 var_24b50 = mod(var_8ae03, vec3(ShadowQuantizationParameters.z));
        var_9e07f = (var_8ae03 - (var_24b50 - (var_ce28e * dot(var_24b50, var_ce28e)))) + WorldOrigin.xyz;
    }
    else
    {
        var_9e07f = v_worldPos;
    }
    bool var_5a6e4;
    highp vec4 var_9a0a9;
    highp vec3 var_14bcd;
    highp vec3 var_669aa;
    if (var_5bd0a.z != 1.0)
    {
        highp vec2 var_537c2 = vec2(var_49182, var_280ef);
        highp vec3 var_1d975;
        highp vec3 var_3d209;
        func_81441(var_3d209, var_1d975, var_02454, var_9e07f, var_0d894, var_537c2, var_4eacb, var_1e735, var_3ede4, var_d0f91, var_c34bb, var_9024c);
        highp vec3 var_23d9a = var_1312d;
        highp vec4 var_8fd40;
        highp vec3 var_fa062;
        highp vec3 var_38603;
        bool var_902e5;
        func_d5e06(var_512b6, var_c0bfd, var_902e5, var_38603, var_fa062, var_8fd40, var_23d9a, var_d70da, var_1312d, var_02454, var_4eacb, var_1e735, var_3ede4, var_d0f91, var_c34bb, var_9024c, var_9e07f, var_c71ce);
        var_669aa = var_3d209 + (var_38603 * (1.0 - var_f3062));
        var_14bcd = var_1d975 + (var_fa062 * (1.0 - var_5d160));
        var_9a0a9 = var_8fd40;
        var_5a6e4 = var_902e5;
    }
    else
    {
        var_669aa = vec3(0.0);
        var_14bcd = vec3(0.0);
        var_9a0a9 = vec4(0.0, 0.0, 0.0, 1.0);
        var_5a6e4 = true;
    }
    highp float var_46c45;
    if (var_5a6e4)
    {
        var_46c45 = PointLightDiffuseFadeOutParameters.w;
    }
    else
    {
        var_46c45 = PointLightDiffuseFadeOutParameters.z + ((PointLightDiffuseFadeOutParameters.w - PointLightDiffuseFadeOutParameters.z) * var_f3062);
    }
    highp vec4 var_a3397 = var_9a0a9;
    highp vec4 var_b1243 = SkyAmbientLightColorIntensity;
    highp float var_f4f9d = TileLightIntensity.x * TileLightIntensity.x;
    highp vec3 var_03e87 = (((((var_d0f91 * (1.0 - var_c34bb)) * max(((clamp(vec3(var_f4f9d + (var_a3397.x * var_a3397.w), (var_f4f9d * ((((var_f4f9d * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_a3397.y * var_a3397.w), (var_f4f9d * (((var_f4f9d * var_f4f9d) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_a3397.z * var_a3397.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * var_46c45) + ((SkyAmbientLightColorIntensity.xyz * pow(TileLightIntensity.y, mix(5.0, 3.0, CameraLightIntensity.y))) * var_b1243.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_669aa) + var_14bcd) + (((mix(var_d0f91, vec3(dot(var_d0f91, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_2c6d0)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x);
    highp float var_7d5ab = length(var_1312d);
    highp vec3 var_95db2 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
    highp vec3 var_7e3dc;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_3de5f = clamp((((var_7d5ab / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_cb5ed;
        if (var_3de5f > 0.0)
        {
            highp vec3 var_08c70;
            if (!(AtmosphericScatteringToggles.y != 0.0))
            {
                var_08c70 = FogColor.xyz;
            }
            else
            {
                highp vec4 var_86047 = SunColor;
                highp vec4 var_e0810 = MoonColor;
                highp vec3 var_e3755 = var_95db2;
                highp float var_7b136 = FogSkyBlend.x - FogSkyBlend.w;
                highp float var_7213f = smoothstep(FogSkyBlend.y, var_7b136, var_e3755.y);
                highp float var_7160a = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_7b136, var_e3755.y);
                highp float var_c861e = dot(var_95db2, SunDir.xyz);
                highp float var_78c21 = dot(var_95db2, MoonDir.xyz);
                highp float var_7a7df = clamp(pow(max(var_c861e, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_a2190 = clamp(pow(max(var_78c21, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                var_08c70 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_7213f * var_7213f) * var_7213f, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_86047.w * (0.75 * ((var_c861e * var_c861e) + 1.0))) + (var_e0810.w * (0.75 * ((var_78c21 * var_78c21) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_7160a * var_7160a) * var_7160a, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_86047.w) * AtmosphericScattering.y) * var_7a7df) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_7a7df * 1.7999999523162841796875), 1.5))) + ((((MoonColor.xyz * var_e0810.w) * AtmosphericScattering.z) * var_a2190) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_a2190 * 1.7999999523162841796875), 1.5)))));
            }
            var_cb5ed = mix(var_03e87, var_08c70, vec3(var_3de5f));
        }
        else
        {
            var_cb5ed = var_03e87;
        }
        var_7e3dc = var_cb5ed;
    }
    else
    {
        var_7e3dc = mix(var_03e87, FogColor.xyz, vec3(clamp((((var_7d5ab / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0)));
    }
    highp vec3 var_28cb8;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_d70da.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_d70da, 1.0);
        highp float var_b4ccc = var_7d045.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_b4ccc, var_7d045.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_eb2d5 = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_5363d = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        highp vec4 var_67b96 = var_5363d;
        var_28cb8 = var_5363d.xyz + (var_7e3dc * var_67b96.w);
    }
    else
    {
        var_28cb8 = var_7e3dc;
    }
    highp vec3 var_64293;
    if (IBLParameters.x != 0.0)
    {
        highp vec3 var_7914f = reflect(normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_c71ce);
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
        highp float var_12c15 = 1.0 - var_1e735;
        highp float var_59d83 = (1.0 - (var_12c15 * var_12c15)) * (IBLParameters.y - 1.0);
        int var_ae27f = int(LastSpecularIBLIdx.x);
        highp vec3 var_96496 = mix(textureLod(s_SpecularIBLRecords, vec4(var_7914f, float((var_ae27f + 2) % 3)), var_59d83).xyz, textureLod(s_SpecularIBLRecords, vec4(var_7914f, float(var_ae27f)), var_59d83).xyz, vec3(IBLParameters.w));
        highp vec3 var_6f3bc;
        if (PreExposureEnabled.x > 0.0)
        {
            var_6f3bc = var_96496 * vec3(5.552470684051513671875);
        }
        else
        {
            var_6f3bc = var_96496;
        }
        highp vec3 var_76060 = (var_6f3bc * (pow(clamp(((TileLightIntensity.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0), 3.0) * IBLParameters.x)) * IBLParameters.z;
        highp vec4 var_20f77;
        func_fc162(var_c34bb, var_76060, var_20f77);
        highp vec4 var_beeb8 = var_20f77;
        highp vec3 var_d97f1;
        if (var_beeb8.w == 1.0)
        {
            var_d97f1 = var_20f77.xyz;
        }
        else
        {
            var_d97f1 = var_76060;
        }
        highp vec2 var_280ac = vec2(clamp(dot(var_02454, -(var_1312d / vec3(var_d893e))), 0.0, 1.0), var_1e735);
        var_280ac.y = 1.0 - var_280ac.y;
        highp vec2 var_7d2be = texture(s_BrdfLUT, var_280ac).xy;
        highp vec3 var_fe0f6 = var_d97f1 * ((var_3ede4 * var_7d2be.x) + vec3(var_7d2be.y));
        highp vec3 var_67472;
        if (AtmosphericScatteringToggles.x != 0.0)
        {
            var_67472 = var_fe0f6 * (1.0 - clamp((((var_d893e / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0));
        }
        else
        {
            var_67472 = var_fe0f6 * (1.0 - clamp((((var_d893e / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
        }
        highp vec3 var_0ffc6;
        if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
        {
            highp vec2 var_0a57b = VolumeNearFar.xy;
            highp vec2 var_9ec98 = (var_d70da.xy + vec2(1.0)) * 0.5;
            highp vec4 var_197cc = u_invProj * vec4(var_d70da, 1.0);
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
        var_64293 = var_0ffc6;
    }
    else
    {
        highp vec2 var_95cd0 = vec2(clamp(dot(var_02454, -(var_1312d / vec3(var_d893e))), 0.0, 1.0), var_1e735);
        var_95cd0.y = 1.0 - var_95cd0.y;
        highp vec2 var_c7eca = texture(s_BrdfLUT, var_95cd0).xy;
        var_64293 = ((AmbientLightParams.xyz * var_c34bb) * AmbientLightParams.w) * ((var_3ede4 * var_c7eca.x) + vec3(var_c7eca.y));
    }
    highp vec3 var_cdd60 = vec4(var_28cb8, 1.0).xyz + var_64293;
    highp vec3 var_cb832;
    if (PreExposureEnabled.x > 0.0)
    {
        var_cb832 = var_cdd60 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_cb832 = var_cdd60;
    }
    bgfx_FragData[0] = vec4(var_cb832.x, var_cb832.y, var_cb832.z, vec4(var_aaae6, var_aaae6, var_aaae6, var_f039a.w).w);
}
