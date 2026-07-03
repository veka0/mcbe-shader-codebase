#version 310 es

/*
* Available Macros:
*
* Passes:
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
* - uniform lowp sampler2D s_CausticsTexture;
* - layout(binding = 2, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 3, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_MatTexture;
* - uniform highp sampler2DArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
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
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform mat4 PrevWorld;
* - uniform vec4 RenderChunkFogAlpha;
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
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
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

layout(binding = 3, std430) buffer s_Lights { Light Lights[]; } var_9dd7d;
layout(binding = 2, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_57c0f;
uniform highp mat4 CloudShadowProj;
uniform highp mat4 DirectionalLightSourceCausticsViewProj[2];
uniform highp mat4 DirectionalLightSourceInvWaterSurfaceViewProj[2];
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
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_proj;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2D s_CausticsTexture;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_PointLightShadowTextureArray;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadeShadowResolutions;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
uniform highp vec4 ChangeColor;
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
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 LastSpecularIBLIdx;
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 MatColor;
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
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
uniform highp vec4 ShadowPCFWidth;
uniform highp vec4 ShadowQuantizationParameters;
uniform highp vec4 ShadowSlopeBias;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
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
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
int var_e7b23;
bool var_a33e3;
float var_f570b;
void func_cb3cb(inout int arg_4fc1c, inout highp vec3 arg_f8577, inout highp vec4 arg_a2d38, inout int arg_ee338) {
    highp vec4 loc_06bbb = DirectionalLightSourceShadowProj0[arg_4fc1c] * vec4(arg_f8577, 1.0);
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
        arg_a2d38 = loc_06bbb;
        arg_ee338 = 0;
        return;
    }
    highp vec4 loc_857da = DirectionalLightSourceShadowProj1[arg_4fc1c] * vec4(arg_f8577, 1.0);
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
        arg_a2d38 = loc_857da;
        arg_ee338 = 1;
        return;
    }
    highp vec4 loc_7216b = DirectionalLightSourceShadowProj2[arg_4fc1c] * vec4(arg_f8577, 1.0);
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
        arg_a2d38 = loc_7216b;
        arg_ee338 = 2;
        return;
    }
    highp vec4 loc_0e1bf = DirectionalLightSourceShadowProj3[arg_4fc1c] * vec4(arg_f8577, 1.0);
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
        arg_a2d38 = loc_0e1bf;
        arg_ee338 = 3;
        return;
    }
    arg_a2d38 = loc_0e1bf;
    arg_ee338 = -1;
}
void func_e68ea(inout int arg_a1e9d, inout highp float arg_7a26d, inout int arg_24aec, inout highp vec4 arg_5b51a, inout highp float arg_e6df6) {
    if (arg_a1e9d < 0)
    {
        arg_7a26d = 1.0;
        return;
    }
    int loc_8118e = clamp(int(ShadowPCFWidth[arg_24aec] + 0.5), 1, 9);
    int loc_d6315 = loc_8118e / 2;
    highp vec2 loc_de8d2 = ((vec2(arg_5b51a.x, arg_5b51a.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions[arg_24aec];
    highp float loc_aa6c4 = (arg_5b51a.z * 0.5) + 0.5;
    loc_de8d2.y += (1.0 - CascadeShadowResolutions[arg_24aec]);
    highp float loc_9af5f;
    loc_9af5f = 0.0;
    highp float loc_1a54a;
    for (int loc_04d9d = 0; loc_04d9d < loc_8118e; loc_9af5f = loc_1a54a, loc_04d9d++)
    {
        loc_1a54a = loc_9af5f;
        highp float loc_8e08a;
        for (int loc_96608 = 0; loc_96608 < loc_8118e; loc_1a54a = loc_8e08a, loc_96608++)
        {
            highp vec3 loc_4515f = vec3(loc_de8d2 + ((vec2(float(loc_96608 - loc_d6315) + 0.5, float(loc_04d9d - loc_d6315) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSize.x) * CascadeShadowResolutions[arg_24aec]), (float(arg_a1e9d) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(arg_24aec));
            highp vec4 loc_28934 = textureGather(s_ShadowCascades, loc_4515f);
            highp vec4 loc_bbed9 = loc_28934;
            if (ShadowQuantizationParameters.x != 0.0)
            {
                loc_8e08a = loc_1a54a + float(loc_bbed9.w >= (loc_aa6c4 - arg_e6df6));
            }
            else
            {
                highp vec4 loc_27ff4 = step(vec4(loc_aa6c4 - arg_e6df6), loc_28934);
                highp vec2 loc_b1a62 = fract((loc_4515f.xy * ShadowFilterOffsetAndRangeFarAndMapSize.z) + vec2(0.5));
                loc_8e08a = loc_1a54a + mix(mix(loc_27ff4.w, loc_27ff4.z, loc_b1a62.x), mix(loc_27ff4.x, loc_27ff4.y, loc_b1a62.x), loc_b1a62.y);
            }
        }
    }
    arg_7a26d = loc_9af5f / float(loc_8118e * loc_8118e);
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
void func_e3c4e(inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec3 arg_69e1b, inout highp vec3 arg_abe00, inout highp vec2 arg_c288e, inout highp vec3 arg_a3604, inout highp vec3 arg_78faf) {
    highp vec3 loc_4b287;
    if (ShadowQuantizationParameters.y > 0.0)
    {
        highp vec3 loc_23ca2 = v_worldPos - WorldOrigin.xyz;
        highp vec3 loc_da281 = normalize(cross(normalize(dFdx(loc_23ca2)), normalize(dFdy(loc_23ca2))));
        highp vec3 loc_754df = mod(loc_23ca2, vec3(ShadowQuantizationParameters.z));
        loc_4b287 = v_worldPos - (loc_754df - (loc_da281 * dot(loc_754df, loc_da281)));
    }
    else
    {
        loc_4b287 = v_worldPos;
    }
    if (abs(TileLightIntensity.y) < 9.9999997473787516355514526367188e-05)
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        return;
    }
    int loc_a58f1 = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    highp vec3 loc_9ff3b;
    highp vec3 loc_81561;
    loc_81561 = vec3(0.0);
    loc_9ff3b = vec3(0.0);
    highp vec3 loc_2b3c7;
    highp vec3 loc_4f500;
    for (int loc_fd135 = 0; loc_fd135 < loc_a58f1; loc_81561 = loc_4f500, loc_9ff3b = loc_2b3c7, loc_fd135++)
    {
        highp float loc_54b62;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            highp float loc_955a9 = max(dot(arg_69e1b, normalize((u_view * DirectionalLightSourceShadowDirection[loc_fd135]).xyz)), 0.0);
            int loc_66a53;
            highp vec4 loc_b57a6;
            func_cb3cb(loc_fd135, loc_4b287, loc_b57a6, loc_66a53);
            highp vec4 loc_b19db = loc_b57a6;
            highp float loc_8766b;
            if (loc_66a53 != (-1))
            {
                highp float loc_0ed3d = ShadowBias[loc_66a53] + (ShadowSlopeBias[loc_66a53] * clamp(tan(acos(loc_955a9)), 0.0, 1.0));
                int loc_be19b = int(DirectionalLightSourceShadowCascadeNumber[loc_fd135].x);
                highp float loc_222e2;
                func_e68ea(loc_be19b, loc_222e2, loc_66a53, loc_b19db, loc_0ed3d);
                highp float loc_ad256;
                if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
                {
                    highp float loc_93efa;
                    func_7a524(loc_4b287, loc_955a9, loc_93efa);
                    loc_ad256 = min(loc_222e2, loc_93efa);
                }
                else
                {
                    loc_ad256 = loc_222e2;
                }
                bool loc_5d7ab = int(DirectionalLightSourceIsSun[loc_fd135].x) > 0;
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
                    highp vec4 loc_1a6df = CloudShadowProj * vec4(loc_4b287, 1.0);
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
                loc_8766b = mix(loc_e4c4c, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSize.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSize.y, -arg_abe00.z));
            }
            else
            {
                loc_8766b = 1.0;
            }
            loc_54b62 = loc_8766b;
        }
        else
        {
            loc_54b62 = 1.0;
        }
        highp vec3 loc_791d7;
        if (DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.x != 0.0)
        {
            int loc_1db61 = int(DirectionalLightSourceShadowCascadeNumber[loc_fd135].x);
            highp float loc_a3c1d;
            if (loc_1db61 >= 0)
            {
                highp vec4 loc_4a6c4 = DirectionalLightSourceWaterSurfaceViewProj[loc_fd135] * vec4(v_worldPos, 1.0);
                highp vec4 loc_f5c51 = loc_4a6c4;
                highp vec3 loc_18955 = loc_4a6c4.xyz / vec3(loc_f5c51.w);
                highp vec3 loc_14f1d = loc_18955;
                highp vec4 loc_fed43 = DirectionalLightSourceWaterSurfaceViewProj[loc_fd135] * vec4(v_worldPos, 1.0);
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
                    loc_08f0c = length((DirectionalLightSourceInvWaterSurfaceViewProj[loc_fd135] * vec4(loc_18955.xy, loc_838c1, 1.0)).xyz - v_worldPos);
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
        highp vec3 loc_af162 = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_fd135]).xyz);
        highp vec4 loc_5b55e = DirectionalLightSourceDiffuseColorAndIlluminance[loc_fd135];
        highp vec3 loc_37e9f = (((DirectionalLightSourceDiffuseColorAndIlluminance[loc_fd135].xyz * loc_5b55e.w) * loc_791d7) * arg_c288e[loc_fd135]) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
        highp float loc_a2de4 = max(dot(arg_69e1b, loc_af162), 0.0);
        highp float loc_f17ab = max(dot(arg_69e1b, arg_a3604), 0.0);
        highp vec3 loc_8c143 = normalize(loc_af162 + arg_a3604);
        highp float loc_ebb5d = max(dot(arg_69e1b, loc_8c143), 0.0);
        highp float loc_fc12f = max((((-0.9375) * loc_ebb5d) * loc_ebb5d) + 1.0, 9.9999997473787516355514526367188e-05);
        highp vec3 loc_d5859 = vec3(0.959999978542327880859375) * pow(clamp(1.0 - max(dot(arg_a3604, loc_8c143), 0.0), 0.0, 1.0), 5.0);
        loc_2b3c7 = loc_9ff3b + ((((((vec3(0.959999978542327880859375) - loc_d5859) * loc_a2de4) * ((arg_78faf * 1.0) * vec3(0.3183098733425140380859375))) * loc_54b62) * loc_37e9f) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_4f500 = loc_81561 + ((((((((vec3(0.039999999105930328369140625) + loc_d5859) * (0.01989436708390712738037109375 / (loc_fc12f * loc_fc12f))) * ((loc_f17ab / ((loc_f17ab * 0.875) + 0.12510000169277191162109375)) * (loc_a2de4 / ((loc_a2de4 * 0.875) + 0.12510000169277191162109375)))) / vec3(((4.0 * loc_a2de4) * loc_f17ab) + 9.9999997473787516355514526367188e-05)) * loc_a2de4) * loc_54b62) * loc_37e9f) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_9ff3b;
    arg_90b60 = loc_81561;
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
void func_aed09(inout int arg_3cd09, inout highp float arg_28e67, inout highp vec3 arg_214f6) {
    if (var_9dd7d.Lights[arg_3cd09].shadowProbeIndex < 0)
    {
        arg_28e67 = 1.0;
        return;
    }
    highp vec3 loc_3566a = v_worldPos - var_9dd7d.Lights[arg_3cd09].position.xyz;
    highp vec3 loc_27555 = loc_3566a;
    highp vec3 loc_f4d64 = abs(loc_3566a);
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
            highp vec3 loc_c810d = ((loc_3566a * (1.0 / loc_3566a.x)) * 0.5) + vec3(0.5);
            loc_5836b = vec3(1.0 - loc_c810d.z, loc_c810d.y, 0.0);
        }
        else
        {
            highp vec3 loc_3d32b = ((loc_3566a * (1.0 / dot(loc_3566a, vec3(-1.0, 0.0, 0.0)))) * 0.5) + vec3(0.5);
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
                highp vec3 loc_1939e = ((loc_3566a * (1.0 / loc_3566a.y)) * 0.5) + vec3(0.5);
                loc_5836b = vec3(loc_1939e.x, 1.0 - loc_1939e.z, 2.0);
            }
            else
            {
                highp vec3 loc_9f7b3 = ((loc_3566a * (1.0 / dot(loc_3566a, vec3(0.0, -1.0, 0.0)))) * 0.5) + vec3(0.5);
                loc_5836b = vec3(loc_9f7b3.x, loc_9f7b3.z, 3.0);
            }
        }
        else
        {
            if (loc_27555.z > 0.0)
            {
                highp vec3 loc_0db9f = ((loc_3566a * (1.0 / loc_3566a.z)) * 0.5) + vec3(0.5);
                loc_5836b = vec3(loc_0db9f.x, loc_0db9f.y, 4.0);
            }
            else
            {
                highp vec3 loc_2f24d = ((loc_3566a * (1.0 / dot(loc_3566a, vec3(0.0, 0.0, -1.0)))) * 0.5) + vec3(0.5);
                loc_5836b = vec3(1.0 - loc_2f24d.x, loc_2f24d.y, 5.0);
            }
        }
    }
    loc_f4d64.z *= (-1.0);
    highp vec4 loc_eae4d = PointLightProj * vec4(loc_f4d64, 1.0);
    loc_eae4d.z += (PointLightShadowParams1.x + (PointLightShadowParams1.y * clamp(tan(acos(dot(-normalize(loc_3566a), arg_214f6))), 0.0, 1.0)));
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
            loc_0a47c.z = float(var_9dd7d.Lights[arg_3cd09].shadowProbeIndex * 6) + loc_0a47c.z;
            highp vec4 loc_185e5 = step(vec4(loc_eae4d.z), textureGather(s_PointLightShadowTextureArray, loc_0a47c));
            highp vec2 loc_b16bc = fract((loc_0a47c.xy * (1.0 / (PointLightShadowParams1.w + 9.9999997473787516355514526367188e-05))) + vec2(0.5));
            loc_bbf51 = loc_f6f3d + mix(mix(loc_185e5.w, loc_185e5.z, loc_b16bc.x), mix(loc_185e5.x, loc_185e5.y, loc_b16bc.x), loc_b16bc.y);
        }
    }
    arg_28e67 = loc_b74da * 0.0624996125698089599609375;
}
void func_e7535(inout highp vec4 arg_83841, inout int arg_a1b0b, inout highp vec3 arg_62394, inout highp vec3 arg_154f5) {
    arg_83841 = vec4(0.0);
    if (arg_a1b0b < 0)
    {
        arg_62394 = vec3(0.0);
        return;
    }
    highp vec3 loc_569de = var_9dd7d.Lights[arg_a1b0b].position.xyz - v_worldPos;
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
    if (loc_95cea >= (var_9dd7d.Lights[arg_a1b0b].position.w * var_9dd7d.Lights[arg_a1b0b].position.w))
    {
        arg_62394 = vec3(0.0);
        return;
    }
    highp float loc_33ea0;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_144ad;
        func_aed09(arg_a1b0b, loc_144ad, arg_154f5);
        loc_33ea0 = loc_144ad;
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
    highp float loc_fd676 = loc_95cea / ((var_9dd7d.Lights[arg_a1b0b].position.w * var_9dd7d.Lights[arg_a1b0b].position.w) + 9.9999997473787516355514526367188e-05);
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
    highp vec3 loc_13960 = var_9dd7d.Lights[arg_a1b0b].color.xyz * loc_3d192;
    arg_83841 = vec4(loc_13960.x, loc_13960.y, loc_13960.z, arg_83841.w);
    arg_83841.w = 1.0 - (loc_95cea / ((var_9dd7d.Lights[arg_a1b0b].position.w * var_9dd7d.Lights[arg_a1b0b].position.w) + 9.9999997473787516355514526367188e-05));
    arg_62394 = (((var_9dd7d.Lights[arg_a1b0b].color.xyz * var_9dd7d.Lights[arg_a1b0b].color.w) * loc_3d192) * loc_33ea0) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_b7bbd(inout bool arg_9a2b4, inout bool arg_b6724, inout bool arg_33e52, inout highp vec3 arg_3289d, inout highp vec3 arg_98547, inout highp vec4 arg_82d08, inout highp vec3 arg_dc0ef, inout highp vec3 arg_96daa, inout highp vec3 arg_89c41, inout highp vec3 arg_01a6b, inout highp vec3 arg_21ff0, inout highp vec3 arg_c8c10, inout highp vec3 arg_81f82) {
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
    highp vec4 loc_31787;
    for (int loc_0ad25 = loc_2aee5; loc_0ad25 < loc_9d2b5; loc_118d9 = loc_7a7eb, loc_68344 = loc_49b5f, loc_23246 = loc_62c27, loc_0ad25++)
    {
        int loc_ee051 = int(var_57c0f.LightLookupArray[loc_0ad25].lookup);
        if (loc_ee051 < 0)
        {
            break;
        }
        highp vec3 loc_c98e5 = normalize((u_view * vec4(var_9dd7d.Lights[loc_ee051].position.xyz, 1.0)).xyz - arg_89c41);
        highp vec3 loc_12949;
        highp vec3 loc_a2281;
        highp vec3 loc_b2ace;
        if (arg_b6724)
        {
            highp vec3 loc_97e77;
            highp vec3 loc_8d121;
            if (arg_9a2b4)
            {
                highp float loc_94490 = max(dot(arg_01a6b, loc_c98e5), 0.0);
                highp float loc_33e5f = max(dot(arg_01a6b, arg_21ff0), 0.0);
                highp vec3 loc_2e051 = normalize(loc_c98e5 + arg_21ff0);
                highp float loc_3806d = max(dot(arg_01a6b, loc_2e051), 0.0);
                highp float loc_e5162 = max((((-0.9375) * loc_3806d) * loc_3806d) + 1.0, 9.9999997473787516355514526367188e-05);
                highp vec3 loc_5e45b = vec3(0.959999978542327880859375) * pow(clamp(1.0 - max(dot(arg_21ff0, loc_2e051), 0.0), 0.0, 1.0), 5.0);
                loc_8d121 = ((((vec3(0.039999999105930328369140625) + loc_5e45b) * (0.01989436708390712738037109375 / (loc_e5162 * loc_e5162))) * ((loc_33e5f / ((loc_33e5f * 0.875) + 0.12510000169277191162109375)) * (loc_94490 / ((loc_94490 * 0.875) + 0.12510000169277191162109375)))) / vec3(((4.0 * loc_94490) * loc_33e5f) + 9.9999997473787516355514526367188e-05)) * loc_94490;
                loc_97e77 = ((vec3(0.959999978542327880859375) - loc_5e45b) * loc_94490) * ((arg_c8c10 * 1.0) * vec3(0.3183098733425140380859375));
            }
            else
            {
                loc_8d121 = vec3(0.0);
                loc_97e77 = ((arg_c8c10 * 1.0) * vec3(0.3183098733425140380859375)) * max(dot(arg_01a6b, loc_c98e5), 0.0);
            }
            loc_b2ace = loc_8d121;
            loc_a2281 = vec3(0.0);
            loc_12949 = loc_97e77;
        }
        else
        {
            highp vec3 loc_8413f;
            if (arg_9a2b4)
            {
                highp float loc_e5d13 = max(dot(arg_01a6b, loc_c98e5), 0.0);
                highp float loc_76109 = max(dot(arg_01a6b, arg_21ff0), 0.0);
                highp vec3 loc_94084 = normalize(loc_c98e5 + arg_21ff0);
                highp float loc_1a38a = max(dot(arg_01a6b, loc_94084), 0.0);
                highp float loc_43d1f = max((((-0.9375) * loc_1a38a) * loc_1a38a) + 1.0, 9.9999997473787516355514526367188e-05);
                loc_8413f = ((((vec3(0.039999999105930328369140625) + (vec3(0.959999978542327880859375) * pow(clamp(1.0 - max(dot(arg_21ff0, loc_94084), 0.0), 0.0, 1.0), 5.0))) * (0.01989436708390712738037109375 / (loc_43d1f * loc_43d1f))) * ((loc_76109 / ((loc_76109 * 0.875) + 0.12510000169277191162109375)) * (loc_e5d13 / ((loc_e5d13 * 0.875) + 0.12510000169277191162109375)))) / vec3(((4.0 * loc_e5d13) * loc_76109) + 9.9999997473787516355514526367188e-05)) * loc_e5d13;
            }
            else
            {
                loc_8413f = vec3(0.0);
            }
            loc_b2ace = loc_8413f;
            loc_a2281 = vec3(0.0);
            loc_12949 = vec3(0.0);
        }
        loc_62c27 = loc_23246 + 1;
        highp vec3 loc_83843;
        func_e7535(loc_31787, loc_ee051, loc_83843, arg_81f82);
        loc_fa2ec += loc_31787;
        loc_49b5f = loc_68344 + (((loc_12949 + loc_a2281) * loc_83843) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_7a7eb = loc_118d9 + ((loc_b2ace * loc_83843) * DiffuseSpecularEmissiveAmbientTermToggles.y);
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
    highp vec4 var_04b6d = v_color0;
    highp vec4 var_7dda5 = texture(s_MatTexture, v_texcoord0);
    highp vec4 var_d9c64 = MatColor * var_7dda5;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_2ce32 = var_d9c64.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec3 var_0bba1 = var_d9c64.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    highp vec2 var_35473 = var_0bba1.xy;
    highp vec3 var_0f504 = mix(mix((var_0bba1.xxx * ChangeColor.xyz).xyz, var_0bba1.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_35473.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_a6e92 = vec4(var_0f504.x, var_0f504.y, var_0f504.z, var_d9c64.w);
#endif
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_24ae4 = vec4(var_2ce32.x, var_2ce32.y, var_2ce32.z, var_d9c64.w);
    highp vec3 var_abd27 = mix(mix(var_24ae4, var_24ae4 * ChangeColor, vec4(var_04b6d.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_a6e92 = vec4(var_abd27.x, var_abd27.y, var_abd27.z, var_d9c64.w);
    highp vec3 var_6e12b = pow(max(var_abd27.xyz * v_color0.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec3 var_6e12b = pow(max(var_0f504.xyz * v_color0.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
#endif
    highp vec4 var_9f386 = u_view * (u_model[0] * vec4(v_worldPos, 1.0));
    highp vec4 var_e87e0 = u_proj * var_9f386;
    highp vec4 var_b8928 = var_e87e0;
    highp vec3 var_1f150 = var_e87e0.xyz / vec3(var_b8928.w);
    highp vec4 var_89669 = vec4(normalize(v_normal), 1.0);
    highp vec3 var_b4fbd = var_9f386.xyz;
    highp vec3 var_e1b04 = var_89669.xyz;
    highp vec3 var_f1c2e = (u_view * var_89669).xyz;
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
    highp vec3 var_edfc0 = var_b4fbd;
    highp vec3 var_5bd0a = var_1f150;
    highp vec3 var_811e1 = var_b4fbd;
    highp float var_3707d;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        var_3707d = (abs(var_811e1.x) + abs(var_811e1.y)) + abs(var_811e1.z);
    }
    else
    {
        var_3707d = length(var_b4fbd);
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
    bool var_bbdbf;
    if (!var_49ba4)
    {
        var_bbdbf = var_464cb && (var_3707d < PointLightSpecularFadeOutParameters.y);
    }
    else
    {
        var_bbdbf = var_49ba4;
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
    bool var_b65dc;
    if (!var_70859)
    {
        var_b65dc = var_686c7 && (var_3707d < PointLightDiffuseFadeOutParameters.y);
    }
    else
    {
        var_b65dc = var_70859;
    }
    highp vec3 var_f1053 = -(var_b4fbd / vec3(length(var_b4fbd) + 9.9999997473787516355514526367188e-05));
    bool var_5a6e4;
    highp vec4 var_9a0a9;
    highp vec3 var_99d4d;
    highp vec3 var_fc9c0;
    if (var_5bd0a.z != 1.0)
    {
        highp vec2 var_c8039 = vec2(var_49182, var_280ef);
        highp vec3 var_de9aa;
        highp vec3 var_c282b;
        func_e3c4e(var_c282b, var_de9aa, var_f1c2e, var_edfc0, var_c8039, var_f1053, var_6e12b);
        highp vec3 var_92517 = var_b4fbd;
        highp vec4 var_3d9d9;
        highp vec3 var_b3e4d;
        highp vec3 var_ef9ba;
        bool var_64e2a;
        func_b7bbd(var_bbdbf, var_b65dc, var_64e2a, var_ef9ba, var_b3e4d, var_3d9d9, var_92517, var_1f150, var_b4fbd, var_f1c2e, var_f1053, var_6e12b, var_e1b04);
        var_fc9c0 = var_c282b + (var_ef9ba * (1.0 - var_f3062));
        var_99d4d = var_de9aa + (var_b3e4d * (1.0 - var_5d160));
        var_9a0a9 = var_3d9d9;
        var_5a6e4 = var_64e2a;
    }
    else
    {
        var_fc9c0 = vec3(0.0);
        var_99d4d = vec3(0.0);
        var_9a0a9 = vec4(0.0, 0.0, 0.0, 1.0);
        var_5a6e4 = true;
    }
    highp float var_4fe53;
    if (var_5a6e4)
    {
        var_4fe53 = PointLightDiffuseFadeOutParameters.w;
    }
    else
    {
        var_4fe53 = PointLightDiffuseFadeOutParameters.z + ((PointLightDiffuseFadeOutParameters.w - PointLightDiffuseFadeOutParameters.z) * var_f3062);
    }
    highp vec4 var_62333 = var_9a0a9;
    highp vec4 var_e6033 = SkyAmbientLightColorIntensity;
    highp float var_d9b88 = TileLightIntensity.x * TileLightIntensity.x;
    highp vec3 var_b1d21 = ((((var_6e12b * 1.0) * max(((clamp(vec3(var_d9b88 + (var_62333.x * var_62333.w), (var_d9b88 * ((((var_d9b88 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_62333.y * var_62333.w), (var_d9b88 * (((var_d9b88 * var_d9b88) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_62333.z * var_62333.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * var_4fe53) + ((SkyAmbientLightColorIntensity.xyz * pow(TileLightIntensity.y, mix(5.0, 3.0, CameraLightIntensity.y))) * var_e6033.w), vec3(0.02999999932944774627685546875))) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_fc9c0) + var_99d4d;
    highp float var_7d5ab = length(var_b4fbd);
    highp vec3 var_95db2 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
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
                highp vec3 var_e3755 = var_95db2;
                highp float var_7b136 = FogSkyBlend.x - FogSkyBlend.w;
                highp float var_d7734 = smoothstep(FogSkyBlend.y, var_7b136, var_e3755.y);
                highp float var_3c557 = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_7b136, var_e3755.y);
                highp float var_50871 = dot(var_95db2, SunDir.xyz);
                highp float var_ae018 = dot(var_95db2, MoonDir.xyz);
                highp float var_5301e = 0.5 * (var_50871 + 1.0);
                highp float var_9a714 = 0.5 * (var_ae018 + 1.0);
                highp float var_4e792 = clamp(pow(max(var_50871, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_72556 = clamp(pow(max(var_ae018, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                var_a6488 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_d7734 * var_d7734) * var_d7734, 0.0, 1.0))) * AtmosphericScattering.x) * 0.0596831031143665313720703125) * (((var_5301e * var_5301e) * var_da187.w) + ((var_9a714 * var_9a714) * var_9cde9.w))) + (((SkyHorizonColor.xyz * clamp((var_3c557 * var_3c557) * var_3c557, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_da187.w) * AtmosphericScattering.y) * var_4e792) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_4e792 * 1.7999999523162841796875), 1.5))) + ((((MoonColor.xyz * var_9cde9.w) * AtmosphericScattering.z) * var_72556) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_72556 * 1.7999999523162841796875), 1.5)))));
            }
            var_cb5ed = mix(var_b1d21, var_a6488, vec3(var_3de5f));
        }
        else
        {
            var_cb5ed = var_b1d21;
        }
        var_7e3dc = var_cb5ed;
    }
    else
    {
        var_7e3dc = mix(var_b1d21, FogColor.xyz, vec3(clamp((((var_7d5ab / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0)));
    }
    highp vec3 var_28cb8;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_1f150.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_1f150, 1.0);
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
    highp vec3 var_a19f0;
    if (IBLParameters.x != 0.0)
    {
        highp vec3 var_7914f = reflect(normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_e1b04);
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
        highp float var_cd8a3 = 0.75 * (IBLParameters.y - 1.0);
        int var_ae27f = int(LastSpecularIBLIdx.x);
        highp vec3 var_96496 = mix(textureLod(s_SpecularIBLRecords, vec4(var_7914f, float((var_ae27f + 2) % 3)), var_cd8a3).xyz, textureLod(s_SpecularIBLRecords, vec4(var_7914f, float(var_ae27f)), var_cd8a3).xyz, vec3(IBLParameters.w));
        highp vec3 var_7d314;
        if (PreExposureEnabled.x > 0.0)
        {
            var_7d314 = var_96496 * vec3(5.552470684051513671875);
        }
        else
        {
            var_7d314 = var_96496;
        }
        highp vec2 var_51e86 = texture(s_BrdfLUT, vec2(clamp(dot(var_f1c2e, -(var_b4fbd / vec3(length(var_b4fbd)))), 0.0, 1.0), 0.5)).xy;
        highp vec3 var_77178 = ((var_7d314 * (pow(clamp(((TileLightIntensity.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0), 3.0) * IBLParameters.x)) * IBLParameters.z) * ((vec3(0.039999999105930328369140625) * var_51e86.x) + vec3(var_51e86.y));
        highp float var_96068 = length(var_b4fbd);
        highp vec3 var_67472;
        if (AtmosphericScatteringToggles.x != 0.0)
        {
            var_67472 = var_77178 * (1.0 - clamp((((var_96068 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0));
        }
        else
        {
            var_67472 = var_77178 * (1.0 - clamp((((var_96068 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
        }
        highp vec3 var_0ffc6;
        if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
        {
            highp vec2 var_0a57b = VolumeNearFar.xy;
            highp vec2 var_9ec98 = (var_1f150.xy + vec2(1.0)) * 0.5;
            highp vec4 var_197cc = u_invProj * vec4(var_1f150, 1.0);
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
        var_a19f0 = var_0ffc6;
    }
    else
    {
        var_a19f0 = vec3(0.0);
    }
    highp vec3 var_cdd60 = vec4(var_28cb8, 1.0).xyz + var_a19f0;
    highp vec3 var_09481;
    if (PreExposureEnabled.x > 0.0)
    {
        var_09481 = var_cdd60 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_09481 = var_cdd60;
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
    bgfx_FragData[0] = vec4(var_09481.x, var_09481.y, var_09481.z, vec4(var_f570b, var_f570b, var_f570b, var_a6e92.w * var_04b6d.w).w);
    bgfx_FragData[1] = vec4(vec4(0.0).x, vec4(0.0).y, var_e953a.x, var_e953a.y);
}
