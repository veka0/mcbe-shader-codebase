#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORWARD_PBR_ALPHA_TEST_PASS (not used)
* - FORWARD_PBR_OPAQUE_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS (not used)
* - RASTERIZED_OPAQUE_PASS (not used)
* - RASTERIZED_TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED (not used)
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Lit:
* - LIT__OFF (not used)
* - LIT__ON (not used)
*
* UseTextures:
* - USE_TEXTURES__OFF
* - USE_TEXTURES__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - layout(binding = 1, std430) buffer s_BiomeInfoBufferBuffer { BiomeInfo s_BiomeInfoBuffer[]; };
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 4, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 5, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_MatTexture;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
*
* Uniforms:
* - uniform vec4 Ambient;
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
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ConvolutionType;
* - uniform vec4 CurrentColor;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform mat4 DirectionalLightSourceCausticsViewProj[2];
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
* - uniform vec4 DirectionalLightSourceIsSun[2];
* - uniform vec4 DirectionalLightSourceShadowDirection[2];
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
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MERSUniforms;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
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
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
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

layout(binding = 5, std430) buffer s_Lights { Light Lights[]; } var_c9538;
layout(binding = 4, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_ec1e9;
uniform highp mat4 CascadesShadowInvProj[8];
uniform highp mat4 CascadesShadowProj[8];
uniform highp mat4 CloudShadowProj;
uniform highp mat4 DirectionalLightSourceCausticsViewProj[2];
uniform highp mat4 PlayerShadowProj;
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_model[4];
uniform highp mat4 u_proj;
uniform highp mat4 u_view;
uniform highp sampler2D s_BrdfLUT;
#ifdef USE_TEXTURES__ON
uniform highp sampler2D s_MatTexture;
#endif
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
uniform highp vec4 CascadesParameters[8];
uniform highp vec4 CascadesPerSet;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
uniform highp vec4 ClusterDepthBounds;
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ClusterNearFarWidthHeight;
uniform highp vec4 ClusterSize;
uniform highp vec4 ConvolutionType;
uniform highp vec4 CurrentColor;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform highp vec4 DirectionalLightSourceIsSun[2];
uniform highp vec4 DirectionalLightSourceShadowDirection[2];
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform highp vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
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
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightDiffuseFadeOutParameters;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 PointLightSpecularFadeOutParameters;
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
uniform highp vec4 TileLightIntensity;
uniform highp vec4 Time;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WaterSurfaceOctaveParameters;
uniform highp vec4 WaterSurfaceParameters;
uniform highp vec4 WaterSurfaceWaveParameters;
uniform highp vec4 WorldOrigin;
in highp vec4 v_color0;
#ifdef USE_TEXTURES__ON
in highp vec2 v_texcoord0;
#endif
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
mat4 var_9796c;
int var_e7b23;
float var_f570b;
void func_17084(inout highp vec4 arg_c59ed, inout int arg_a0aa6, inout highp vec3 arg_0d628, inout highp mat4 arg_d64be, inout bool arg_5e3ed, inout highp mat4 arg_4ee81) {
    arg_c59ed = CascadesShadowProj[arg_a0aa6] * vec4(arg_0d628, 1.0);
    highp vec4 loc_108af = arg_c59ed;
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
        arg_d64be = CascadesShadowInvProj[arg_a0aa6];
        arg_5e3ed = true;
        return;
    }
    arg_d64be = arg_4ee81;
    arg_5e3ed = false;
}
void func_d5e6c(inout highp vec3 arg_3a8bb, inout highp float arg_bd1d9, inout highp float arg_7a26d) {
    highp vec4 loc_4b675 = PlayerShadowProj * vec4(arg_3a8bb, 1.0);
    loc_4b675.z -= (CascadesParameters[0].y + (CascadesParameters[0].z * clamp(sqrt(1.0 - (arg_bd1d9 * arg_bd1d9)) / arg_bd1d9, 0.0, 1.0)));
    loc_4b675.z = min(loc_4b675.z, 1.0);
    highp vec2 loc_f9579 = ((vec2(loc_4b675.x, loc_4b675.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    int loc_ec55d = (QuantizationParameters.x != 0.0) ? 1 : 2;
    int loc_ed2e2 = loc_ec55d / 2;
    loc_4b675.z = (loc_4b675.z * 0.5) + 0.5;
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
                loc_8daf8 = loc_72f9e + float(textureLod(s_ShadowCascades, loc_f4800, 0.0).x >= loc_4b675.z);
            }
            else
            {
                highp vec4 loc_1f2f1 = step(vec4(loc_4b675.z), textureGather(s_ShadowCascades, loc_f4800));
                highp vec2 loc_127fb = fract((loc_f4800.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_8daf8 = loc_72f9e + mix(mix(loc_1f2f1.w, loc_1f2f1.z, loc_127fb.x), mix(loc_1f2f1.x, loc_1f2f1.y, loc_127fb.x), loc_127fb.y);
            }
        }
    }
    arg_7a26d = loc_9af5f / float(loc_ec55d * loc_ec55d);
}
void func_3712a(inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec3 arg_218ea, inout highp vec3 arg_016ce, inout highp vec3 arg_68e47, inout highp vec3 arg_a9fca, inout highp vec2 arg_f36e7, inout highp vec3 arg_81f79, inout highp vec3 arg_58ffc, inout highp vec3 arg_28cf7, inout highp float arg_cdb42) {
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
    int loc_29e34 = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    highp vec3 loc_7d7d3;
    highp vec3 loc_6ee08;
    highp mat4 loc_a7108;
    loc_6ee08 = vec3(0.0);
    loc_7d7d3 = vec3(0.0);
    loc_a7108 = var_9796c;
    highp vec3 loc_fde0c;
    highp vec3 loc_f20d9;
    highp mat4 loc_f3340;
    for (int loc_cc5d6 = 0; loc_cc5d6 < loc_29e34; loc_6ee08 = loc_f20d9, loc_7d7d3 = loc_fde0c, loc_cc5d6++, loc_a7108 = loc_f3340)
    {
        highp float loc_c6386;
        highp float loc_a416a;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            highp float loc_87fe9 = max(dot(arg_218ea, normalize((u_view * DirectionalLightSourceShadowDirection[loc_cc5d6]).xyz)), 0.0);
            highp vec3 loc_bb12f = arg_016ce + ((arg_68e47 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_87fe9, 0.0, 1.0));
            highp float loc_68750;
            highp float loc_cb15a;
            highp mat4 loc_6ca81;
            loc_6ca81 = loc_a7108;
            loc_cb15a = 1.0;
            loc_68750 = 1.0;
            int loc_e55e8;
            highp float loc_5ebc8;
            highp float loc_6f625;
            highp mat4 loc_fdd84;
            for (int loc_7a536 = 0, loc_6ddca = 0; loc_7a536 < 4; loc_6ca81 = loc_fdd84, loc_6ddca = loc_e55e8, loc_cb15a = loc_6f625, loc_68750 = loc_5ebc8, loc_7a536++)
            {
                int loc_39b80 = int(CascadesPerSet[loc_7a536]);
                highp mat4 loc_7f87f;
                loc_7f87f = loc_6ca81;
                highp mat4 loc_e1f5c;
                for (int loc_cca25 = 0; loc_cca25 < loc_39b80; loc_7f87f = loc_e1f5c, loc_cca25++)
                {
                    int loc_38769 = loc_6ddca + loc_cca25;
                    if (loc_38769 >= 8)
                    {
                        loc_fdd84 = loc_7f87f;
                        loc_6f625 = loc_cb15a;
                        loc_5ebc8 = loc_68750;
                        break;
                    }
                    highp vec4 loc_0a9a7;
                    bool loc_3ffa4;
                    func_17084(loc_0a9a7, loc_38769, loc_bb12f, loc_e1f5c, loc_3ffa4, loc_7f87f);
                    highp vec4 loc_569e5 = loc_0a9a7;
                    if (!loc_3ffa4)
                    {
                        continue;
                    }
                    highp float loc_c0c1e = CascadesParameters[loc_38769].y + (CascadesParameters[loc_38769].z * clamp(sqrt(1.0 - (loc_87fe9 * loc_87fe9)) / loc_87fe9, 0.0, 1.0));
                    highp float loc_1699c = SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z * length(loc_e1f5c * vec4(0.0, 0.0, 1.0, 0.0));
                    int loc_98038;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_98038 = 1;
                    }
                    else
                    {
                        loc_98038 = clamp(int(CascadesParameters[loc_38769].w + 0.5), 1, 9);
                    }
                    int loc_960ef = loc_98038 / 2;
                    highp vec2 loc_63e61 = ((vec2(loc_569e5.x, loc_569e5.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_38769].x;
                    highp float loc_7263a = (loc_569e5.z * 0.5) + 0.5;
                    loc_63e61.y += (1.0 - CascadesParameters[loc_38769].x);
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
                            highp vec2 loc_3cc8b = loc_63e61 + ((vec2(float(loc_6a5e1 - loc_960ef) + 0.5, float(loc_8ad4e - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_38769].x);
                            highp vec4 loc_0c1b5 = textureGather(s_ShadowCascades, vec3(loc_3cc8b, float(loc_38769)));
                            highp vec4 loc_1e988 = loc_0c1b5;
                            highp vec2 loc_89c3c = fract((loc_3cc8b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            highp vec4 loc_0edfa = vec4(1.0) - smoothstep(vec4(0.0), vec4(1.0), (vec4(loc_7263a) - loc_0c1b5) * loc_1699c);
                            highp vec2 loc_df6bc = loc_89c3c;
                            loc_8794a = loc_bb531 + mix(mix(loc_0edfa.w, loc_0edfa.z, loc_df6bc.x), mix(loc_0edfa.x, loc_0edfa.y, loc_df6bc.x), loc_df6bc.y);
                            if (QuantizationParameters.x != 0.0)
                            {
                                loc_befb6 = loc_c824b + float(loc_1e988.w >= (loc_7263a - loc_c0c1e));
                            }
                            else
                            {
                                highp vec4 loc_6da26 = step(vec4(loc_7263a - loc_c0c1e), loc_0c1b5);
                                highp vec2 loc_4ce21 = loc_89c3c;
                                loc_befb6 = loc_c824b + mix(mix(loc_6da26.w, loc_6da26.z, loc_4ce21.x), mix(loc_6da26.x, loc_6da26.y, loc_4ce21.x), loc_4ce21.y);
                            }
                        }
                    }
                    loc_fdd84 = loc_e1f5c;
                    loc_6f625 = min(loc_cb15a, loc_94392 / float(loc_98038 * loc_98038));
                    loc_5ebc8 = min(loc_68750, loc_89b67 / float(loc_98038 * loc_98038));
                    break;
                }
                loc_e55e8 = loc_6ddca + loc_39b80;
            }
            highp float loc_2c1f0;
            if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
            {
                highp float loc_2400a;
                func_d5e6c(loc_bb12f, loc_87fe9, loc_2400a);
                loc_2c1f0 = min(loc_68750, loc_2400a);
            }
            else
            {
                loc_2c1f0 = loc_68750;
            }
            bool loc_54d04 = int(DirectionalLightSourceIsSun[loc_cc5d6].x) > 0;
            bool loc_b7807;
            if (loc_54d04)
            {
                loc_b7807 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
            }
            else
            {
                loc_b7807 = loc_54d04;
            }
            highp float loc_70c88;
            if (loc_b7807)
            {
                highp vec4 loc_d4de6 = CloudShadowProj * vec4(loc_bb12f, 1.0);
                highp vec4 loc_de425 = loc_d4de6;
                loc_de425 = loc_d4de6 / vec4(loc_de425.w);
                loc_de425.z -= ((CascadesParameters[0].y + (CascadesParameters[0].z * clamp(sqrt(1.0 - (loc_87fe9 * loc_87fe9)) / loc_87fe9, 0.0, 1.0))) / loc_de425.w);
                highp vec2 loc_54a33 = ((vec2(loc_de425.x, loc_de425.y) * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
                int loc_4504c;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_4504c = 1;
                }
                else
                {
                    loc_4504c = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z + 0.5), 1, 9);
                }
                int loc_64293 = loc_4504c / 2;
                loc_de425.z = (loc_de425.z * 0.5) + 0.5;
                loc_54a33.y += (1.0 - CascadesParameters[0].x);
                highp float loc_f538a = dot(CascadesPerSet, vec4(1.0));
                highp float loc_39767;
                loc_39767 = 0.0;
                highp float loc_90c45;
                for (int loc_9c272 = 0; loc_9c272 < loc_4504c; loc_39767 = loc_90c45, loc_9c272++)
                {
                    loc_90c45 = loc_39767;
                    highp float loc_88f9d;
                    for (int loc_a8e1a = 0; loc_a8e1a < loc_4504c; loc_90c45 = loc_88f9d, loc_a8e1a++)
                    {
                        highp vec3 loc_8bcb2 = vec3(loc_54a33 + ((vec2(float(loc_a8e1a - loc_64293) + 0.5, float(loc_9c272 - loc_64293) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_f538a);
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_88f9d = loc_90c45 + float(textureLod(s_ShadowCascades, loc_8bcb2, 0.0).x >= loc_de425.z);
                        }
                        else
                        {
                            highp vec4 loc_6717d = step(vec4(loc_de425.z), textureGather(s_ShadowCascades, loc_8bcb2));
                            highp vec2 loc_d9651 = fract((loc_8bcb2.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            loc_88f9d = loc_90c45 + mix(mix(loc_6717d.w, loc_6717d.z, loc_d9651.x), mix(loc_6717d.x, loc_6717d.y, loc_d9651.x), loc_d9651.y);
                        }
                    }
                }
                highp float loc_b85fb = loc_39767 / float(loc_4504c * loc_4504c);
                highp float loc_5d6fc;
                if (loc_b85fb < 1.0)
                {
                    loc_5d6fc = min(loc_2c1f0, max(loc_b85fb, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                }
                else
                {
                    loc_5d6fc = loc_2c1f0;
                }
                loc_70c88 = loc_5d6fc;
            }
            else
            {
                loc_70c88 = loc_2c1f0;
            }
            loc_f3340 = loc_6ca81;
            loc_a416a = loc_cb15a;
            loc_c6386 = mix(loc_70c88, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_a9fca.z));
        }
        else
        {
            loc_f3340 = loc_a7108;
            loc_a416a = 1.0;
            loc_c6386 = 1.0;
        }
        highp vec3 loc_921fd = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_cc5d6]).xyz);
        highp vec4 loc_fe4ce = DirectionalLightSourceDiffuseColorAndIlluminance[loc_cc5d6];
        highp vec3 loc_49071 = ((DirectionalLightSourceDiffuseColorAndIlluminance[loc_cc5d6].xyz * loc_fe4ce.w) * arg_f36e7[loc_cc5d6]) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
        highp float loc_1e1bf = max(dot(arg_218ea, loc_921fd), 0.0);
        highp float loc_af6fd = max(dot(arg_218ea, arg_81f79), 0.0);
        highp float loc_2d61b = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp float loc_c20a0 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp vec3 loc_a125f = normalize(loc_921fd + arg_81f79);
        highp float loc_b8d72 = max(MERSUniforms.z, 0.0500000007450580596923828125);
        highp float loc_a68f1 = loc_b8d72 * loc_b8d72;
        highp float loc_ad517 = loc_a68f1 * loc_a68f1;
        highp float loc_cd10e = max(dot(arg_218ea, loc_a125f), 0.0);
        highp float loc_6be3a = (((loc_ad517 - 1.0) * loc_cd10e) * loc_cd10e) + 1.0;
        highp float loc_ad7fb = loc_a68f1 * 0.5;
        highp float loc_00ee9 = clamp(1.0 - max(dot(arg_81f79, loc_a125f), 0.0), 0.0, 1.0);
        highp float loc_a177b = loc_00ee9 * loc_00ee9;
        highp vec3 loc_d5257 = arg_58ffc + ((vec3(1.0) - arg_58ffc) * ((loc_a177b * loc_a177b) * loc_00ee9));
        highp vec3 loc_97c67 = arg_28cf7 * (1.0 - MERSUniforms.x);
        loc_fde0c = loc_7d7d3 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_218ea, loc_921fd) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_cdb42)) * (loc_97c67 * vec3(0.3183098733425140380859375))) * loc_c6386) + (((loc_97c67 * vec3(0.3183098733425140380859375)) * (arg_cdb42 * max((dot(-arg_218ea, loc_921fd) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_a416a)) * loc_49071) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_f20d9 = loc_6ee08 + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_c6386) * loc_49071) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_7d7d3;
    arg_90b60 = loc_6ee08;
}
void func_5d077(inout highp float arg_958de, inout highp vec2 arg_e6843, inout highp float arg_33edf, inout highp vec2 arg_410bb, inout highp vec3 arg_e0671) {
    if (arg_958de < arg_e6843.x)
    {
        arg_33edf = -1.0;
        return;
    }
    bool loc_4e95c = arg_958de >= arg_e6843.x;
    bool loc_6742e;
    if (loc_4e95c)
    {
        loc_6742e = arg_958de <= arg_410bb.x;
    }
    else
    {
        loc_6742e = loc_4e95c;
    }
    if (loc_6742e)
    {
        arg_33edf = 0.0;
        return;
    }
    bool loc_78834 = arg_958de > arg_410bb.x;
    bool loc_c9362;
    if (loc_78834)
    {
        loc_c9362 = arg_958de <= arg_410bb.y;
    }
    else
    {
        loc_c9362 = loc_78834;
    }
    if (loc_c9362)
    {
        arg_33edf = 1.0;
        return;
    }
    arg_33edf = floor((log2(arg_958de / arg_410bb.y) * ((arg_e0671.z - 2.0) / log2(arg_e6843.y / arg_410bb.y))) + 2.0);
}
void func_258b6(inout highp vec3 arg_9f603, inout highp vec3 arg_1a26b, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp float loc_28341 = -arg_9f603.z;
    highp vec2 loc_25da3 = (arg_1a26b.xy + vec2(1.0)) * vec2(0.5);
    highp vec3 loc_fd394 = ClusterDimensions.xyz;
    highp vec2 loc_703d4 = ClusterNearFarWidthHeight.zw;
    highp vec2 loc_d7b5c = ClusterSize.xy;
    highp vec2 loc_909cb = ClusterNearFarWidthHeight.xy;
    highp vec2 loc_eee23 = ClusterDepthBounds.xy;
    highp float loc_5de3f;
    func_5d077(loc_28341, loc_909cb, loc_5de3f, loc_eee23, loc_fd394);
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
    if (var_c9538.Lights[arg_60bb3].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        arg_6b488 = 1.0;
        return;
    }
    highp vec3 loc_8d02b = arg_0623c - var_c9538.Lights[arg_60bb3].position.xyz;
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
    highp float loc_4c50b = (textureLod(s_PointLightShadowTextureArray, vec4(loc_778fd, float(var_c9538.Lights[arg_60bb3].shadowProbeIndex)), 0.0).x * 2.0) - 1.0;
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
    highp vec3 loc_569de = var_c9538.Lights[arg_3df6f].position.xyz - v_worldPos;
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
    if (loc_4343f >= (var_c9538.Lights[arg_3df6f].position.w * var_c9538.Lights[arg_3df6f].position.w))
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
    highp float loc_fd676 = loc_4343f / ((var_c9538.Lights[arg_3df6f].position.w * var_c9538.Lights[arg_3df6f].position.w) + 9.9999997473787516355514526367188e-05);
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
        highp vec3 loc_e1408 = var_c9538.Lights[arg_3df6f].color.xyz * loc_a0a0b;
        arg_86e96 = vec4(loc_e1408.x, loc_e1408.y, loc_e1408.z, arg_86e96.w);
        arg_86e96.w = 1.0 - (loc_4343f / ((var_c9538.Lights[arg_3df6f].position.w * var_c9538.Lights[arg_3df6f].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_24936 = ((var_c9538.Lights[arg_3df6f].color.xyz * var_c9538.Lights[arg_3df6f].color.w) * loc_a0a0b) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_3a820(inout bool arg_9a2b4, inout bool arg_b6724, inout highp vec3 arg_3289d, inout highp vec3 arg_98547, inout highp vec4 arg_33e52, inout highp vec3 arg_dc0ef, inout highp vec3 arg_96daa, inout highp vec3 arg_89c41, inout highp vec3 arg_e4e64, inout highp vec3 arg_061f9, inout highp vec3 arg_04538, inout highp vec3 arg_676e4, inout highp float arg_105b9, inout highp vec3 arg_5a8cd, inout highp vec3 arg_4fa31) {
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
    func_258b6(arg_dc0ef, arg_96daa, loc_9d2b5, loc_2aee5, loc_9f3ca);
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
        int loc_fb87b = int(var_ec1e9.LightLookupArray[loc_0ad25].lookup);
        if (loc_fb87b < 0)
        {
            break;
        }
        highp vec3 loc_8c356 = normalize((u_view * vec4(var_c9538.Lights[loc_fb87b].position.xyz, 1.0)).xyz - arg_89c41);
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
                highp float loc_d0d2b = max(MERSUniforms.z, 0.0500000007450580596923828125);
                highp float loc_59789 = loc_d0d2b * loc_d0d2b;
                highp float loc_30f4c = loc_59789 * loc_59789;
                highp float loc_7f729 = max(dot(arg_e4e64, loc_608b6), 0.0);
                highp float loc_15617 = (((loc_30f4c - 1.0) * loc_7f729) * loc_7f729) + 1.0;
                highp float loc_fabe5 = loc_59789 * 0.5;
                highp float loc_c2dc6 = clamp(1.0 - max(dot(arg_061f9, loc_608b6), 0.0), 0.0, 1.0);
                highp float loc_66601 = loc_c2dc6 * loc_c2dc6;
                highp vec3 loc_1800c = arg_04538 + ((vec3(1.0) - arg_04538) * ((loc_66601 * loc_66601) * loc_c2dc6));
                highp vec3 loc_7c706 = arg_676e4 * (1.0 - MERSUniforms.x);
                loc_0a326 = (((loc_1800c * (loc_30f4c / ((loc_15617 * loc_15617) * 3.1415927410125732421875))) * ((loc_237eb / (((loc_237eb * (1.0 - loc_fabe5)) + loc_fabe5) + 9.9999997473787516355514526367188e-05)) * (loc_dad67 / (((loc_dad67 * (1.0 - loc_fabe5)) + loc_fabe5) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_dad67) * loc_237eb) + 9.9999997473787516355514526367188e-05)) * loc_dad67;
                loc_577c9 = (loc_7c706 * vec3(0.3183098733425140380859375)) * (arg_105b9 * max((dot(-arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2e0cd * loc_2e0cd), 0.0));
                loc_6cd2d = ((vec3(1.0) - loc_1800c) * mix(loc_dad67, max((dot(arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_57238 * loc_57238), 0.0), arg_105b9)) * (loc_7c706 * vec3(0.3183098733425140380859375));
            }
            else
            {
                highp float loc_36134 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp float loc_0a512 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp vec3 loc_5597c = arg_676e4 * (1.0 - MERSUniforms.x);
                loc_0a326 = vec3(0.0);
                loc_577c9 = (loc_5597c * vec3(0.3183098733425140380859375)) * (arg_105b9 * max((dot(-arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_0a512 * loc_0a512), 0.0));
                loc_6cd2d = (loc_5597c * vec3(0.3183098733425140380859375)) * mix(max(dot(arg_e4e64, loc_8c356), 0.0), max((dot(arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_36134 * loc_36134), 0.0), arg_105b9);
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
                highp float loc_14c5b = max(MERSUniforms.z, 0.0500000007450580596923828125);
                highp float loc_22daf = loc_14c5b * loc_14c5b;
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
void func_74d48(inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec4 loc_949e7 = vec4(0.0, 0.0, 0.0, 1.0);
    highp float loc_f0165 = TileLightIntensity.x * TileLightIntensity.x;
    highp vec3 loc_b0c7c = (((AmbientLightParams.xyz * AmbientLightParams.w) * (1.0 - TileLightIntensity.x)) + (((clamp(vec3(loc_f0165 + (loc_949e7.x * loc_949e7.w), (loc_f0165 * ((((loc_f0165 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_949e7.y * loc_949e7.w), (loc_f0165 * (((loc_f0165 * loc_f0165) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_949e7.z * loc_949e7.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x) * TileLightIntensity.x)) * MERSUniforms.x;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_b0c7c, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_b0c7c, 1.0);
}
void func_ee3b3(inout highp vec4 arg_85834) {
    highp vec4 loc_949e7 = vec4(0.0, 0.0, 0.0, 1.0);
    highp float loc_f0165 = TileLightIntensity.x * TileLightIntensity.x;
    highp vec3 loc_73d46 = (((AmbientLightParams.xyz * AmbientLightParams.w) * (1.0 - TileLightIntensity.x)) + (((clamp(vec3(loc_f0165 + (loc_949e7.x * loc_949e7.w), (loc_f0165 * ((((loc_f0165 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_949e7.y * loc_949e7.w), (loc_f0165 * (((loc_f0165 * loc_f0165) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_949e7.z * loc_949e7.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x) * TileLightIntensity.x)) * MERSUniforms.x;
    if (0.0 >= dot(loc_73d46, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_73d46, 1.0);
}
void main() {
    highp vec4 var_23597 = v_color0;
#ifdef USE_TEXTURES__OFF
    highp vec4 var_011ae = vec4(1.0);
    highp vec4 var_1766e = vec4(1.0, 1.0, 1.0, var_011ae.w);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_1133e = texture(s_MatTexture, v_texcoord0);
    highp vec4 var_b6fe8 = var_1133e;
    highp vec4 var_1766e = vec4(pow(max(var_1133e.xyz, vec3(0.0)), vec3(2.2000000476837158203125)), var_b6fe8.w);
#endif
    if (var_1766e.w < 0.5)
    {
        discard;
    }
    highp vec4 var_a2360 = var_1766e;
    highp vec4 var_705a1 = var_a2360 * CurrentColor;
    var_1766e = var_705a1;
    highp vec3 var_f7158 = var_705a1.xyz * v_color0.xyz;
    highp vec4 var_9f386 = u_view * (u_model[0] * vec4(v_worldPos, 1.0));
    highp vec4 var_e87e0 = u_proj * var_9f386;
    highp vec4 var_b8928 = var_e87e0;
    highp vec3 var_49c5c = var_e87e0.xyz / vec3(var_b8928.w);
    highp vec4 var_e3944 = vec4(normalize(vec3(0.0, 1.0, 0.0)), 1.0);
    highp vec3 var_146aa = var_9f386.xyz;
    highp vec3 var_239fe = v_worldPos - WorldOrigin.xyz;
    highp vec3 var_eebcb = dFdx(var_146aa);
    highp vec3 var_211c8 = dFdy(var_146aa);
    highp vec3 var_5acf5 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(var_eebcb), normalize(var_211c8))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_7d782 = mod(var_239fe, vec3(QuantizationParameters.z));
    highp vec3 var_1d25a = (var_239fe - (var_7d782 - (var_5acf5 * dot(var_7d782, var_5acf5)))) + WorldOrigin.xyz;
    highp vec3 var_7c768 = var_e3944.xyz;
    highp vec3 var_56916 = (u_view * var_e3944).xyz;
    highp vec3 var_51c68 = vec3(0.039999999105930328369140625 * (1.0 - MERSUniforms.x)) + (var_f7158 * MERSUniforms.x);
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
        highp vec4 var_f2760 = DirectionalLightSourceCausticsViewProj[0] * vec4(v_worldPos - WorldOrigin.xyz, 1.0);
        highp vec4 var_3ab6f = var_f2760;
        highp vec3 var_08d24 = var_f2760.xyz / vec3(var_3ab6f.w);
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
        highp vec4 var_1d02c = DirectionalLightSourceCausticsViewProj[1] * vec4(v_worldPos - WorldOrigin.xyz, 1.0);
        highp vec4 var_a7f50 = var_1d02c;
        highp vec3 var_255ec = var_1d02c.xyz / vec3(var_a7f50.w);
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
    highp float var_995a5 = clamp(((TileLightIntensity.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_106e2 = length(var_146aa);
    highp vec3 var_5bd0a = var_49c5c;
    highp float var_2a1b2;
    highp vec4 var_9a0a9;
    highp vec3 var_22ef2;
    highp vec3 var_6673e;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_aded7 = -(var_146aa / vec3(length(var_146aa) + 9.9999997473787516355514526367188e-05));
        highp float var_76cac = MERSUniforms.w * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
        highp vec3 var_d5595 = var_146aa;
        highp vec3 var_fbd89;
        if (int(QuantizationParameters.y) > 0)
        {
            var_fbd89 = var_1d25a;
        }
        else
        {
            var_fbd89 = v_worldPos;
        }
        highp vec2 var_24506 = vec2(var_30c68, var_ba9ef);
        highp vec3 var_2a503;
        highp vec3 var_8efb6;
        func_3712a(var_8efb6, var_2a503, var_56916, var_fbd89, var_7c768, var_d5595, var_24506, var_aded7, var_51c68, var_f7158, var_76cac);
        highp vec3 var_850d6 = var_146aa;
        highp float var_a89c0;
        if (ManhattanDistAttenuationEnabled.x > 0.0)
        {
            var_a89c0 = (abs(var_850d6.x) + abs(var_850d6.y)) + abs(var_850d6.z);
        }
        else
        {
            var_a89c0 = length(var_146aa);
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
        bool var_a54cc;
        if (!var_d0403)
        {
            var_a54cc = var_3ca7e && (var_a89c0 < PointLightSpecularFadeOutParameters.y);
        }
        else
        {
            var_a54cc = var_d0403;
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
        bool var_36c8d;
        if (!var_fc9d4)
        {
            var_36c8d = var_fe0c8 && (var_a89c0 < PointLightDiffuseFadeOutParameters.y);
        }
        else
        {
            var_36c8d = var_fc9d4;
        }
        highp vec3 var_7924e;
        if (int(QuantizationParameters.y) > 0)
        {
            var_7924e = var_1d25a;
        }
        else
        {
            var_7924e = v_worldPos;
        }
        highp vec3 var_a69d6 = var_146aa;
        highp vec4 var_05431;
        highp vec3 var_dab42;
        highp vec3 var_9bfc3;
        func_3a820(var_a54cc, var_36c8d, var_9bfc3, var_dab42, var_05431, var_a69d6, var_49c5c, var_146aa, var_56916, var_aded7, var_51c68, var_f7158, var_76cac, var_7924e, var_7c768);
        var_6673e = var_8efb6 + (var_9bfc3 * (1.0 - var_8de40));
        var_22ef2 = var_2a503 + (var_dab42 * (1.0 - var_f999d));
        var_9a0a9 = var_05431;
        var_2a1b2 = var_8de40;
    }
    else
    {
        var_6673e = vec3(0.0);
        var_22ef2 = vec3(0.0);
        var_9a0a9 = vec4(0.0, 0.0, 0.0, 1.0);
        var_2a1b2 = 0.0;
    }
    highp float var_f417c;
    if (true)
    {
        var_f417c = PointLightDiffuseFadeOutParameters.w;
    }
    else
    {
        var_f417c = PointLightDiffuseFadeOutParameters.z + ((PointLightDiffuseFadeOutParameters.w - PointLightDiffuseFadeOutParameters.z) * var_2a1b2);
    }
    highp vec4 var_0f443 = var_9a0a9;
    highp float var_44766 = TileLightIntensity.x * TileLightIntensity.x;
    highp vec4 var_805e6 = SkyAmbientLightColorIntensity;
    highp float var_f12fa = TileLightIntensity.y * TileLightIntensity.y;
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
        highp float var_79b3e = clamp((((length(var_146aa) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
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
    highp vec4 var_dce8f = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_7034a = var_dce8f;
    highp vec4 var_5d744;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_115ba = (var_49c5c.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_49c5c, 1.0);
        highp float var_8cf8f = var_115ba.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_115ba.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_5d744 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_5d744 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_d1c78 = var_5d744;
    highp vec3 var_d7e6d;
    if (IBLParameters.x != 0.0)
    {
        highp vec3 var_a8715;
        highp vec3 var_d11db;
        if (QuantizationParameters.w > 0.0)
        {
            var_d11db = (u_view * vec4(var_1d25a, 1.0)).xyz;
            var_a8715 = var_1d25a;
        }
        else
        {
            var_d11db = var_146aa;
            var_a8715 = v_worldPos;
        }
        highp vec3 var_a56d9 = reflect(normalize(var_a8715 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_7c768);
        highp float var_0f441;
        if (int(ConvolutionType.x) == 1)
        {
            highp float var_1ce49 = 1.0 - MERSUniforms.z;
            var_0f441 = (1.0 - (var_1ce49 * var_1ce49)) * (IBLParameters.y - 1.0);
        }
        else
        {
            highp float var_41ef8 = 1.0 - MERSUniforms.z;
            highp float var_e5afa = var_41ef8 * var_41ef8;
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
        highp vec3 var_87e12 = (var_99477 * (((var_995a5 * var_995a5) * var_995a5) * IBLParameters.x)) * IBLParameters.z;
        highp vec3 var_da3af;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec4 var_72b9c;
            func_74d48(var_87e12, var_72b9c);
            highp vec4 var_fb83f = var_72b9c;
            highp vec3 var_5279b;
            if (var_fb83f.w == 1.0)
            {
                var_5279b = var_72b9c.xyz;
            }
            else
            {
                var_5279b = var_87e12;
            }
            var_da3af = var_5279b;
        }
        else
        {
            var_da3af = var_87e12;
        }
        highp vec2 var_bfbb7 = vec2(clamp(dot(var_56916, -normalize(var_d11db)), 0.0, 1.0), MERSUniforms.z);
        var_bfbb7.y = 1.0 - var_bfbb7.y;
        highp vec2 var_7d2be = texture(s_BrdfLUT, var_bfbb7).xy;
        highp vec3 var_fe0f6 = var_da3af * ((var_51c68 * var_7d2be.x) + vec3(var_7d2be.y));
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
            highp vec2 var_9ec98 = (var_49c5c.xy + vec2(1.0)) * 0.5;
            highp vec4 var_197cc = u_invProj * vec4(var_49c5c, 1.0);
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
        var_d7e6d = var_0ffc6;
    }
    else
    {
        highp vec3 var_e2657;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec3 var_481f7;
            if (QuantizationParameters.w > 0.0)
            {
                var_481f7 = (u_view * vec4(var_1d25a, 1.0)).xyz;
            }
            else
            {
                var_481f7 = var_146aa;
            }
            highp vec4 var_059ac;
            func_ee3b3(var_059ac);
            highp vec2 var_c1068 = vec2(clamp(dot(var_56916, -normalize(var_481f7)), 0.0, 1.0), MERSUniforms.z);
            var_c1068.y = 1.0 - var_c1068.y;
            highp vec2 var_864a0 = texture(s_BrdfLUT, var_c1068).xy;
            var_e2657 = var_059ac.xyz * ((var_51c68 * var_864a0.x) + vec3(var_864a0.y));
        }
        else
        {
            var_e2657 = vec3(0.0);
        }
        var_d7e6d = var_e2657;
    }
    highp vec3 var_97403 = vec4(var_5d744.xyz + (mix((((((var_f7158 * (1.0 - MERSUniforms.x)) * max(((clamp(vec3(var_44766 + (var_0f443.x * var_0f443.w), (var_44766 * ((((var_44766 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0f443.y * var_0f443.w), (var_44766 * (((var_44766 * var_44766) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0f443.z * var_0f443.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * var_f417c) + ((SkyAmbientLightColorIntensity.xyz * mix((var_f12fa * var_f12fa) * TileLightIntensity.y, (TileLightIntensity.y * TileLightIntensity.y) * TileLightIntensity.y, CameraLightIntensity.y)) * var_805e6.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_6673e) + var_22ef2) + (((mix(var_f7158, vec3(dot(var_f7158, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(MERSUniforms.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_dce8f.xyz, vec3(var_7034a.w)) * var_d1c78.w), 1.0).xyz + var_d7e6d;
    highp vec3 var_09481;
    if (PreExposureEnabled.x > 0.0)
    {
        var_09481 = var_97403 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_09481 = var_97403;
    }
    bgfx_FragData[0] = vec4(var_09481.x, var_09481.y, var_09481.z, vec4(var_f570b, var_f570b, var_f570b, var_1766e.w * var_23597.w).w);
    bgfx_FragData[1] = vec4(0.0);
    bgfx_FragData[2] = vec4(0.0);
}
