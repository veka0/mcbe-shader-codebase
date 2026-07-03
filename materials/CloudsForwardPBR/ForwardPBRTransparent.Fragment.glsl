#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_SKY_PROBE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 8, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 9, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 10, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 CascadesParameters[8];
* - uniform vec4 CascadesPerSet;
* - uniform mat4 CascadesShadowInvProj[8];
* - uniform mat4 CascadesShadowProj[8];
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform vec4 CloudColor;
* - uniform vec4 CloudLightingToggles;
* - uniform vec4 CloudLightingUniforms;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 CloudShadowsVisible;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform mat4 DirectionalLightSourceCausticsViewProj[2];
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
* - uniform vec4 DirectionalLightSourceShadowDirection[2];
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
* - uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 DistanceControl;
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
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightNdLFloor;
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
* - uniform vec4 WorldOrigin;
*/

#extension GL_EXT_texture_cube_map_array : require
precision mediump float;
precision highp int;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CloudLightingToggles;
uniform highp vec4 CloudLightingUniforms;
uniform highp vec4 ConvolutionType;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform highp vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform highp vec4 DistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 IBLParameters;
uniform highp vec4 LastSpecularIBLIdx;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WorldOrigin;
flat in int v_adjacentClouds;
in highp vec4 v_color0;
in highp vec3 v_ndcPosition;
in highp vec3 v_normal;
in highp vec2 v_tilePosition;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragColor;
void func_1e7c4(inout highp vec3 arg_ee209, inout highp vec4 arg_78b9f) {
    if (dot(arg_ee209, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= 0.0)
    {
        arg_78b9f = vec4(0.0);
        return;
    }
    arg_78b9f = vec4(0.0, 0.0, 0.0, 1.0);
}
void main() {
    highp vec4 var_2b722 = v_color0;
    highp float var_7bc6e = clamp(max((length(v_worldPos) / DistanceControl.x) - 0.89999997615814208984375, 0.0), 0.0, 1.0);
    highp vec3 var_c0f63 = (v_color0.xyz * ((BlockBaseAmbientLightColorIntensity.xyz * BlockBaseAmbientLightColorIntensity.w) + (SkyAmbientLightColorIntensity.xyz * SkyAmbientLightColorIntensity.w))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    highp vec3 var_9a43c;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp vec3 var_0e72c;
        if (var_7bc6e > 0.0)
        {
            highp vec3 var_74b04 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
            highp vec4 var_8bb1f = SunColor;
            highp vec4 var_f7264 = MoonColor;
            highp vec3 var_c9671 = var_74b04;
            highp float var_187a1 = FogSkyBlend.x - FogSkyBlend.w;
            highp float var_4607e = smoothstep(FogSkyBlend.y, var_187a1, var_c9671.y);
            highp float var_1ee0a = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_187a1, var_c9671.y);
            highp float var_f3314 = dot(var_74b04, SunDir.xyz);
            highp float var_c31e2 = dot(var_74b04, MoonDir.xyz);
            highp float var_e665a = clamp(pow(max(var_f3314, 0.0), AtmosphericScattering.w), 0.0, 1.0);
            highp float var_ac1e2 = clamp(pow(max(var_c31e2, 0.0), AtmosphericScattering.w), 0.0, 1.0);
            highp float var_ef3f9 = 1.809999942779541015625 - (var_e665a * 1.7999999523162841796875);
            highp float var_b9d98 = 1.809999942779541015625 - (var_ac1e2 * 1.7999999523162841796875);
            var_0e72c = mix(var_c0f63, (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_4607e * var_4607e) * var_4607e, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_8bb1f.w * (0.75 * ((var_f3314 * var_f3314) + 1.0))) + (var_f7264.w * (0.75 * ((var_c31e2 * var_c31e2) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_1ee0a * var_1ee0a) * var_1ee0a, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_8bb1f.w) * AtmosphericScattering.y) * var_e665a) * (0.0361000001430511474609375 / (var_ef3f9 * sqrt(var_ef3f9)))) + ((((MoonColor.xyz * var_f7264.w) * AtmosphericScattering.z) * var_ac1e2) * (0.0361000001430511474609375 / (var_b9d98 * sqrt(var_b9d98)))))), vec3(var_7bc6e));
        }
        else
        {
            var_0e72c = var_c0f63;
        }
        var_9a43c = var_0e72c;
    }
    else
    {
        var_9a43c = mix(var_c0f63, FogColor.xyz, vec3(var_7bc6e));
    }
    highp vec3 var_4f849;
    if (CloudLightingToggles.z != 0.0)
    {
        highp vec4 var_9f216 = vec4(v_normal, 0.0);
        highp vec4 var_101e0 = u_view * var_9f216;
        highp vec4 var_9fd18 = u_view * vec4(v_worldPos, 1.0);
        highp vec3 var_2d0e6 = v_worldPos;
        int var_c08a4 = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
        highp vec3 var_5f5fc;
        var_5f5fc = var_9a43c;
        highp vec3 var_53c92;
        for (int var_4eab1 = 0; var_4eab1 < var_c08a4; var_5f5fc = var_53c92, var_4eab1++)
        {
            highp vec3 var_556fa = normalize(v_worldPos);
            highp vec3 var_b4998 = var_556fa;
            highp vec2 var_1a23c = v_tilePosition;
            highp vec3 var_135ed = normalize(v_worldPos);
            highp float var_58a68;
            if (var_135ed.y > 0.0)
            {
                var_58a68 = min(16.0, (196.3300018310546875 - (var_2d0e6.y - WorldOrigin.y)) / var_135ed.y);
            }
            else
            {
                highp float var_f6b58;
                if (var_135ed.y < 0.0)
                {
                    var_f6b58 = min(16.0, (192.3300018310546875 - (var_2d0e6.y - WorldOrigin.y)) / var_135ed.y);
                }
                else
                {
                    var_f6b58 = 16.0;
                }
                var_58a68 = var_f6b58;
            }
            highp float var_cedac;
            bool var_20358;
            if (var_135ed.z > 0.0)
            {
                var_20358 = (v_adjacentClouds & 64) != int(0u);
                var_cedac = (16.0 - var_1a23c.y) / var_135ed.z;
            }
            else
            {
                highp float var_07cbe;
                bool var_24c8a;
                if (var_135ed.z < 0.0)
                {
                    var_24c8a = (v_adjacentClouds & 2) != int(0u);
                    var_07cbe = (-var_1a23c.y) / var_135ed.z;
                }
                else
                {
                    var_24c8a = false;
                    var_07cbe = 16.0;
                }
                var_20358 = var_24c8a;
                var_cedac = var_07cbe;
            }
            highp float var_5a819;
            bool var_b720c;
            if (var_135ed.x > 0.0)
            {
                var_b720c = (v_adjacentClouds & 16) != int(0u);
                var_5a819 = (16.0 - var_1a23c.x) / var_135ed.x;
            }
            else
            {
                highp float var_34373;
                bool var_ec04d;
                if (var_135ed.x < 0.0)
                {
                    var_ec04d = (v_adjacentClouds & 8) != int(0u);
                    var_34373 = (-var_1a23c.x) / var_135ed.x;
                }
                else
                {
                    var_ec04d = false;
                    var_34373 = 16.0;
                }
                var_b720c = var_ec04d;
                var_5a819 = var_34373;
            }
            bool var_78fb0;
            highp float var_8d09c;
            if (var_5a819 > var_cedac)
            {
                bool var_3171c;
                highp float var_175e5;
                if (!var_20358)
                {
                    var_175e5 = min(var_58a68, var_cedac);
                    var_3171c = false;
                }
                else
                {
                    var_175e5 = var_58a68;
                    var_3171c = true;
                }
                var_8d09c = var_175e5;
                var_78fb0 = var_3171c;
            }
            else
            {
                bool var_2b703;
                highp float var_b521d;
                if (var_5a819 < var_cedac)
                {
                    bool var_0061a;
                    highp float var_ab896;
                    if (!var_b720c)
                    {
                        var_ab896 = min(var_58a68, var_5a819);
                        var_0061a = false;
                    }
                    else
                    {
                        var_ab896 = var_58a68;
                        var_0061a = true;
                    }
                    var_b521d = var_ab896;
                    var_2b703 = var_0061a;
                }
                else
                {
                    var_b521d = var_58a68;
                    var_2b703 = true;
                }
                var_8d09c = var_b521d;
                var_78fb0 = var_2b703;
            }
            highp float var_32ac6;
            if (var_78fb0)
            {
                bool var_a2fb0 = var_135ed.x > 0.0;
                bool var_003ec;
                if (var_a2fb0)
                {
                    var_003ec = var_135ed.z > 0.0;
                }
                else
                {
                    var_003ec = var_a2fb0;
                }
                highp float var_aa4b8;
                if (var_003ec)
                {
                    highp float var_a1d18;
                    if (!((v_adjacentClouds & 128) != int(0u)))
                    {
                        var_a1d18 = min(var_8d09c, max(var_5a819, var_cedac));
                    }
                    else
                    {
                        var_a1d18 = var_8d09c;
                    }
                    var_aa4b8 = var_a1d18;
                }
                else
                {
                    bool var_90ee1 = var_135ed.x > 0.0;
                    bool var_eecb5;
                    if (var_90ee1)
                    {
                        var_eecb5 = var_135ed.z < 0.0;
                    }
                    else
                    {
                        var_eecb5 = var_90ee1;
                    }
                    highp float var_2d2e7;
                    if (var_eecb5)
                    {
                        highp float var_3022e;
                        if (!((v_adjacentClouds & 4) != int(0u)))
                        {
                            var_3022e = min(var_8d09c, max(var_5a819, var_cedac));
                        }
                        else
                        {
                            var_3022e = var_8d09c;
                        }
                        var_2d2e7 = var_3022e;
                    }
                    else
                    {
                        bool var_4801e = var_135ed.x < 0.0;
                        bool var_501b8;
                        if (var_4801e)
                        {
                            var_501b8 = var_135ed.z > 0.0;
                        }
                        else
                        {
                            var_501b8 = var_4801e;
                        }
                        highp float var_e94ae;
                        if (var_501b8)
                        {
                            highp float var_23d85;
                            if (!((v_adjacentClouds & 32) != int(0u)))
                            {
                                var_23d85 = min(var_8d09c, max(var_5a819, var_cedac));
                            }
                            else
                            {
                                var_23d85 = var_8d09c;
                            }
                            var_e94ae = var_23d85;
                        }
                        else
                        {
                            bool var_e0787 = var_135ed.x < 0.0;
                            bool var_e9ab2;
                            if (var_e0787)
                            {
                                var_e9ab2 = var_135ed.z < 0.0;
                            }
                            else
                            {
                                var_e9ab2 = var_e0787;
                            }
                            highp float var_97871;
                            if (var_e9ab2)
                            {
                                highp float var_6db03;
                                if (!((v_adjacentClouds & 1) != int(0u)))
                                {
                                    var_6db03 = min(var_8d09c, max(var_5a819, var_cedac));
                                }
                                else
                                {
                                    var_6db03 = var_8d09c;
                                }
                                var_97871 = var_6db03;
                            }
                            else
                            {
                                var_97871 = var_8d09c;
                            }
                            var_e94ae = var_97871;
                        }
                        var_2d2e7 = var_e94ae;
                    }
                    var_aa4b8 = var_2d2e7;
                }
                var_32ac6 = var_aa4b8;
            }
            else
            {
                var_32ac6 = var_8d09c;
            }
            highp float var_9d1a0 = clamp(var_32ac6, 0.0, 16.0);
            highp vec3 var_ca516 = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[var_4eab1]).xyz);
            highp vec4 var_a1ef9 = DirectionalLightSourceDiffuseColorAndIlluminance[var_4eab1];
            highp vec3 var_dc3e5 = (DirectionalLightSourceDiffuseColorAndIlluminance[var_4eab1].xyz * var_a1ef9.w) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x;
            highp vec3 var_a7128;
            if (CloudLightingToggles.y != 0.0)
            {
                highp float var_27913 = var_2d0e6.y + ((var_b4998.y * var_9d1a0) * 0.5);
                highp vec2 var_c97d6 = v_tilePosition + ((var_556fa.xz * var_9d1a0) * 0.5);
                highp vec3 var_eec3e = normalize(DirectionalLightSourceWorldSpaceDirection[var_4eab1].xyz);
                highp float var_d8641;
                if (var_eec3e.y > 0.0)
                {
                    var_d8641 = min(16.0, (196.3300018310546875 - (var_27913 - WorldOrigin.y)) / var_eec3e.y);
                }
                else
                {
                    highp float var_b13a4;
                    if (var_eec3e.y < 0.0)
                    {
                        var_b13a4 = min(16.0, (192.3300018310546875 - (var_27913 - WorldOrigin.y)) / var_eec3e.y);
                    }
                    else
                    {
                        var_b13a4 = 16.0;
                    }
                    var_d8641 = var_b13a4;
                }
                highp float var_99e4e;
                bool var_d1934;
                if (var_eec3e.z > 0.0)
                {
                    var_d1934 = (v_adjacentClouds & 64) != int(0u);
                    var_99e4e = (16.0 - var_c97d6.y) / var_eec3e.z;
                }
                else
                {
                    highp float var_2c872;
                    bool var_8fcdf;
                    if (var_eec3e.z < 0.0)
                    {
                        var_8fcdf = (v_adjacentClouds & 2) != int(0u);
                        var_2c872 = (-var_c97d6.y) / var_eec3e.z;
                    }
                    else
                    {
                        var_8fcdf = false;
                        var_2c872 = 16.0;
                    }
                    var_d1934 = var_8fcdf;
                    var_99e4e = var_2c872;
                }
                highp float var_c95f5;
                bool var_ad9a4;
                if (var_eec3e.x > 0.0)
                {
                    var_ad9a4 = (v_adjacentClouds & 16) != int(0u);
                    var_c95f5 = (16.0 - var_c97d6.x) / var_eec3e.x;
                }
                else
                {
                    highp float var_50aa9;
                    bool var_81c07;
                    if (var_eec3e.x < 0.0)
                    {
                        var_81c07 = (v_adjacentClouds & 8) != int(0u);
                        var_50aa9 = (-var_c97d6.x) / var_eec3e.x;
                    }
                    else
                    {
                        var_81c07 = false;
                        var_50aa9 = 16.0;
                    }
                    var_ad9a4 = var_81c07;
                    var_c95f5 = var_50aa9;
                }
                bool var_bc843;
                highp float var_0a2a8;
                if (var_c95f5 > var_99e4e)
                {
                    bool var_1116c;
                    highp float var_db2f3;
                    if (!var_d1934)
                    {
                        var_db2f3 = min(var_d8641, var_99e4e);
                        var_1116c = false;
                    }
                    else
                    {
                        var_db2f3 = var_d8641;
                        var_1116c = true;
                    }
                    var_0a2a8 = var_db2f3;
                    var_bc843 = var_1116c;
                }
                else
                {
                    bool var_66f75;
                    highp float var_efc5d;
                    if (var_c95f5 < var_99e4e)
                    {
                        bool var_09879;
                        highp float var_95f6d;
                        if (!var_ad9a4)
                        {
                            var_95f6d = min(var_d8641, var_c95f5);
                            var_09879 = false;
                        }
                        else
                        {
                            var_95f6d = var_d8641;
                            var_09879 = true;
                        }
                        var_efc5d = var_95f6d;
                        var_66f75 = var_09879;
                    }
                    else
                    {
                        var_efc5d = var_d8641;
                        var_66f75 = true;
                    }
                    var_0a2a8 = var_efc5d;
                    var_bc843 = var_66f75;
                }
                highp float var_d2403;
                if (var_bc843)
                {
                    bool var_0ffab = var_eec3e.x > 0.0;
                    bool var_bd78b;
                    if (var_0ffab)
                    {
                        var_bd78b = var_eec3e.z > 0.0;
                    }
                    else
                    {
                        var_bd78b = var_0ffab;
                    }
                    highp float var_1376d;
                    if (var_bd78b)
                    {
                        highp float var_22b49;
                        if (!((v_adjacentClouds & 128) != int(0u)))
                        {
                            var_22b49 = min(var_0a2a8, max(var_c95f5, var_99e4e));
                        }
                        else
                        {
                            var_22b49 = var_0a2a8;
                        }
                        var_1376d = var_22b49;
                    }
                    else
                    {
                        bool var_85ad0 = var_eec3e.x > 0.0;
                        bool var_e9e76;
                        if (var_85ad0)
                        {
                            var_e9e76 = var_eec3e.z < 0.0;
                        }
                        else
                        {
                            var_e9e76 = var_85ad0;
                        }
                        highp float var_4a43d;
                        if (var_e9e76)
                        {
                            highp float var_27789;
                            if (!((v_adjacentClouds & 4) != int(0u)))
                            {
                                var_27789 = min(var_0a2a8, max(var_c95f5, var_99e4e));
                            }
                            else
                            {
                                var_27789 = var_0a2a8;
                            }
                            var_4a43d = var_27789;
                        }
                        else
                        {
                            bool var_00b48 = var_eec3e.x < 0.0;
                            bool var_16c3b;
                            if (var_00b48)
                            {
                                var_16c3b = var_eec3e.z > 0.0;
                            }
                            else
                            {
                                var_16c3b = var_00b48;
                            }
                            highp float var_0f4db;
                            if (var_16c3b)
                            {
                                highp float var_da5e9;
                                if (!((v_adjacentClouds & 32) != int(0u)))
                                {
                                    var_da5e9 = min(var_0a2a8, max(var_c95f5, var_99e4e));
                                }
                                else
                                {
                                    var_da5e9 = var_0a2a8;
                                }
                                var_0f4db = var_da5e9;
                            }
                            else
                            {
                                bool var_4da2a = var_eec3e.x < 0.0;
                                bool var_b7b36;
                                if (var_4da2a)
                                {
                                    var_b7b36 = var_eec3e.z < 0.0;
                                }
                                else
                                {
                                    var_b7b36 = var_4da2a;
                                }
                                highp float var_9f1e1;
                                if (var_b7b36)
                                {
                                    highp float var_9caf5;
                                    if (!((v_adjacentClouds & 1) != int(0u)))
                                    {
                                        var_9caf5 = min(var_0a2a8, max(var_c95f5, var_99e4e));
                                    }
                                    else
                                    {
                                        var_9caf5 = var_0a2a8;
                                    }
                                    var_9f1e1 = var_9caf5;
                                }
                                else
                                {
                                    var_9f1e1 = var_0a2a8;
                                }
                                var_0f4db = var_9f1e1;
                            }
                            var_4a43d = var_0f4db;
                        }
                        var_1376d = var_4a43d;
                    }
                    var_d2403 = var_1376d;
                }
                else
                {
                    var_d2403 = var_0a2a8;
                }
                highp float var_dd6af = (1.0 + (CloudLightingUniforms.y * CloudLightingUniforms.y)) + ((2.0 * CloudLightingUniforms.y) * dot(var_ca516, -normalize(var_9fd18.xyz)));
                var_a7128 = var_5f5fc + (((var_dc3e5 * ((0.079577468335628509521484375 * (1.0 - (CloudLightingUniforms.y * CloudLightingUniforms.y))) / (var_dd6af * sqrt(var_dd6af)))) * exp((-clamp(var_d2403, 0.0, 16.0)) * CloudLightingUniforms.w)) * (1.0 - smoothstep(0.0, CloudLightingUniforms.x, var_9d1a0 * 0.5)));
            }
            else
            {
                var_a7128 = var_5f5fc;
            }
            if (CloudLightingToggles.x != 0.0)
            {
                highp vec3 var_49a35 = var_101e0.xyz;
                highp float var_c6b55 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp float var_904fa = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp vec3 var_344a7 = v_color0.xyz * 1.0;
                var_53c92 = var_a7128 + (((((var_344a7 * vec3(0.3183098733425140380859375)) * max((dot(var_49a35, var_ca516) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (var_c6b55 * var_c6b55), 0.0)) + (((var_344a7 * vec3(0.3183098733425140380859375)) * max((dot(-var_49a35, var_ca516) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (var_904fa * var_904fa), 0.0)) * (1.0 - smoothstep(0.0, CloudLightingUniforms.x, var_9d1a0)))) * var_dc3e5) * DiffuseSpecularEmissiveAmbientTermToggles.x);
            }
            else
            {
                var_53c92 = var_a7128;
            }
        }
        highp vec3 var_0a3e8;
        if (QuantizationParameters.w > 0.0)
        {
            var_0a3e8 = (u_view * vec4(v_worldPos, 1.0)).xyz;
        }
        else
        {
            var_0a3e8 = var_9fd18.xyz;
        }
        highp vec3 var_285a7 = reflect(normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_9f216.xyz);
        highp float var_cd843;
        if (int(ConvolutionType.x) == 1)
        {
            var_cd843 = IBLParameters.y - 1.0;
        }
        else
        {
            var_cd843 = IBLParameters.y - 1.0;
        }
        int var_ae27f = int(LastSpecularIBLIdx.x);
        highp vec3 var_67eb4 = mix(textureLod(s_SpecularIBLRecords, vec4(var_285a7, float((var_ae27f + 2) % 3)), var_cd843).xyz, textureLod(s_SpecularIBLRecords, vec4(var_285a7, float(var_ae27f)), var_cd843).xyz, vec3(IBLParameters.w));
        highp vec3 var_f1564;
        if (PreExposureEnabled.x > 0.0)
        {
            var_f1564 = var_67eb4 * vec3(301.72412109375);
        }
        else
        {
            var_f1564 = var_67eb4;
        }
        highp vec3 var_f423f = (var_f1564 * 1.0) * IBLParameters.z;
        highp vec3 var_399f7;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec4 var_72b9c;
            func_1e7c4(var_f423f, var_72b9c);
            highp vec4 var_fb83f = var_72b9c;
            highp vec3 var_5279b;
            if (var_fb83f.w == 1.0)
            {
                var_5279b = var_72b9c.xyz;
            }
            else
            {
                var_5279b = var_f423f;
            }
            var_399f7 = var_5279b;
        }
        else
        {
            var_399f7 = var_f423f;
        }
        highp vec2 var_0aa09 = vec2(clamp(dot(var_101e0.xyz, -normalize(var_0a3e8)), 0.0, 1.0), 1.0);
        var_0aa09.y = 1.0 - var_0aa09.y;
        highp vec2 var_663e3 = texture(s_BrdfLUT, var_0aa09).xy;
        var_4f849 = var_5f5fc + ((var_399f7 * ((vec3(0.039999999105930328369140625) * var_663e3.x) + vec3(var_663e3.y))) * CloudLightingUniforms.z);
    }
    else
    {
        var_4f849 = var_9a43c;
    }
    highp vec3 var_94e72;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_ce114 = (v_ndcPosition.xy + vec2(1.0)) * 0.5;
        highp vec4 var_196b0 = u_invProj * vec4(v_ndcPosition, 1.0);
        highp float var_b4ccc = var_ce114.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_b4ccc, var_ce114.y, log((53.598148345947265625 * ((((-var_196b0.z) / var_196b0.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_eb2d5 = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_5363d = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_ce114.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_ce114.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        highp vec4 var_67b96 = var_5363d;
        var_94e72 = var_5363d.xyz + (var_4f849 * var_67b96.w);
    }
    else
    {
        var_94e72 = var_4f849;
    }
    highp vec3 var_3dd84;
    if (PreExposureEnabled.x > 0.0)
    {
        var_3dd84 = var_94e72 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_3dd84 = var_94e72;
    }
    bgfx_FragColor = vec4(var_3dd84, var_2b722.w);
}
