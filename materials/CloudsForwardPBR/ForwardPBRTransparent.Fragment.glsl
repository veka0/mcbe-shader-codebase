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
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 7, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 8, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
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
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
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
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterAlbedoExtinction;
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
uniform highp vec4 CloudLightingToggles;
uniform highp vec4 CloudLightingUniforms;
uniform highp vec4 ConvolutionType;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection;
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
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
    highp vec3 var_0c7de = (v_color0.xyz * (SkyAmbientLightColorIntensity.xyz * SkyAmbientLightColorIntensity.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    highp vec3 var_49eaf;
    if (CloudLightingToggles.z != 0.0)
    {
        highp vec4 var_9f216 = vec4(v_normal, 0.0);
        highp vec4 var_17732 = u_view * var_9f216;
        highp vec4 var_9248a = u_view * vec4(v_worldPos, 1.0);
        highp vec3 var_4ce2e = v_worldPos;
        highp vec3 var_425d9 = normalize(v_worldPos);
        highp vec3 var_62a97 = var_425d9;
        highp vec2 var_6b2bc = v_tilePosition;
        highp vec3 var_c6126 = normalize(v_worldPos);
        highp float var_eed6f;
        if (var_c6126.y > 0.0)
        {
            var_eed6f = min(16.0, (196.3300018310546875 - (var_4ce2e.y - WorldOrigin.y)) / var_c6126.y);
        }
        else
        {
            highp float var_e8e33;
            if (var_c6126.y < 0.0)
            {
                var_e8e33 = min(16.0, (192.3300018310546875 - (var_4ce2e.y - WorldOrigin.y)) / var_c6126.y);
            }
            else
            {
                var_e8e33 = 16.0;
            }
            var_eed6f = var_e8e33;
        }
        highp float var_06cad;
        bool var_00a51;
        if (var_c6126.z > 0.0)
        {
            var_00a51 = (v_adjacentClouds & 64) != int(0u);
            var_06cad = (16.0 - var_6b2bc.y) / var_c6126.z;
        }
        else
        {
            highp float var_f0568;
            bool var_10f17;
            if (var_c6126.z < 0.0)
            {
                var_10f17 = (v_adjacentClouds & 2) != int(0u);
                var_f0568 = (-var_6b2bc.y) / var_c6126.z;
            }
            else
            {
                var_10f17 = false;
                var_f0568 = 16.0;
            }
            var_00a51 = var_10f17;
            var_06cad = var_f0568;
        }
        highp float var_743c0;
        bool var_08006;
        if (var_c6126.x > 0.0)
        {
            var_08006 = (v_adjacentClouds & 16) != int(0u);
            var_743c0 = (16.0 - var_6b2bc.x) / var_c6126.x;
        }
        else
        {
            highp float var_2c6e4;
            bool var_ede0c;
            if (var_c6126.x < 0.0)
            {
                var_ede0c = (v_adjacentClouds & 8) != int(0u);
                var_2c6e4 = (-var_6b2bc.x) / var_c6126.x;
            }
            else
            {
                var_ede0c = false;
                var_2c6e4 = 16.0;
            }
            var_08006 = var_ede0c;
            var_743c0 = var_2c6e4;
        }
        bool var_887fe;
        highp float var_05227;
        if (var_743c0 > var_06cad)
        {
            bool var_6e598;
            highp float var_2ad09;
            if (!var_00a51)
            {
                var_2ad09 = min(var_eed6f, var_06cad);
                var_6e598 = false;
            }
            else
            {
                var_2ad09 = var_eed6f;
                var_6e598 = true;
            }
            var_05227 = var_2ad09;
            var_887fe = var_6e598;
        }
        else
        {
            bool var_51cf3;
            highp float var_a4b3a;
            if (var_743c0 < var_06cad)
            {
                bool var_3171c;
                highp float var_175e5;
                if (!var_08006)
                {
                    var_175e5 = min(var_eed6f, var_743c0);
                    var_3171c = false;
                }
                else
                {
                    var_175e5 = var_eed6f;
                    var_3171c = true;
                }
                var_a4b3a = var_175e5;
                var_51cf3 = var_3171c;
            }
            else
            {
                var_a4b3a = var_eed6f;
                var_51cf3 = true;
            }
            var_05227 = var_a4b3a;
            var_887fe = var_51cf3;
        }
        highp float var_a6829;
        if (var_887fe)
        {
            bool var_65a08 = var_c6126.x > 0.0;
            bool var_bc5cb;
            if (var_65a08)
            {
                var_bc5cb = var_c6126.z > 0.0;
            }
            else
            {
                var_bc5cb = var_65a08;
            }
            highp float var_bb445;
            if (var_bc5cb)
            {
                highp float var_83e75;
                if (!((v_adjacentClouds & 128) != int(0u)))
                {
                    var_83e75 = min(var_05227, max(var_743c0, var_06cad));
                }
                else
                {
                    var_83e75 = var_05227;
                }
                var_bb445 = var_83e75;
            }
            else
            {
                bool var_a2fb0 = var_c6126.x > 0.0;
                bool var_70c51;
                if (var_a2fb0)
                {
                    var_70c51 = var_c6126.z < 0.0;
                }
                else
                {
                    var_70c51 = var_a2fb0;
                }
                highp float var_b521d;
                if (var_70c51)
                {
                    highp float var_a1d18;
                    if (!((v_adjacentClouds & 4) != int(0u)))
                    {
                        var_a1d18 = min(var_05227, max(var_743c0, var_06cad));
                    }
                    else
                    {
                        var_a1d18 = var_05227;
                    }
                    var_b521d = var_a1d18;
                }
                else
                {
                    bool var_fee36 = var_c6126.x < 0.0;
                    bool var_bd78b;
                    if (var_fee36)
                    {
                        var_bd78b = var_c6126.z > 0.0;
                    }
                    else
                    {
                        var_bd78b = var_fee36;
                    }
                    highp float var_2d2e7;
                    if (var_bd78b)
                    {
                        highp float var_3022e;
                        if (!((v_adjacentClouds & 32) != int(0u)))
                        {
                            var_3022e = min(var_05227, max(var_743c0, var_06cad));
                        }
                        else
                        {
                            var_3022e = var_05227;
                        }
                        var_2d2e7 = var_3022e;
                    }
                    else
                    {
                        bool var_4801e = var_c6126.x < 0.0;
                        bool var_e9e76;
                        if (var_4801e)
                        {
                            var_e9e76 = var_c6126.z < 0.0;
                        }
                        else
                        {
                            var_e9e76 = var_4801e;
                        }
                        highp float var_e94ae;
                        if (var_e9e76)
                        {
                            highp float var_23d85;
                            if (!((v_adjacentClouds & 1) != int(0u)))
                            {
                                var_23d85 = min(var_05227, max(var_743c0, var_06cad));
                            }
                            else
                            {
                                var_23d85 = var_05227;
                            }
                            var_e94ae = var_23d85;
                        }
                        else
                        {
                            var_e94ae = var_05227;
                        }
                        var_2d2e7 = var_e94ae;
                    }
                    var_b521d = var_2d2e7;
                }
                var_bb445 = var_b521d;
            }
            var_a6829 = var_bb445;
        }
        else
        {
            var_a6829 = var_05227;
        }
        highp float var_b7db1 = clamp(var_a6829, 0.0, 16.0);
        highp vec3 var_1b8d5 = normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz);
        highp vec4 var_83dd0 = DirectionalLightSourceDiffuseColorAndIlluminance;
        highp vec3 var_e6692 = (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * var_83dd0.w) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight.x;
        highp vec3 var_33a04;
        if (CloudLightingToggles.y != 0.0)
        {
            highp float var_a27f2 = var_4ce2e.y + ((var_62a97.y * var_b7db1) * 0.5);
            highp vec2 var_f07ec = v_tilePosition + ((var_425d9.xz * var_b7db1) * 0.5);
            highp vec3 var_41fbc = normalize(DirectionalLightSourceWorldSpaceDirection.xyz);
            highp float var_955fa;
            if (var_41fbc.y > 0.0)
            {
                var_955fa = min(16.0, (196.3300018310546875 - (var_a27f2 - WorldOrigin.y)) / var_41fbc.y);
            }
            else
            {
                highp float var_72997;
                if (var_41fbc.y < 0.0)
                {
                    var_72997 = min(16.0, (192.3300018310546875 - (var_a27f2 - WorldOrigin.y)) / var_41fbc.y);
                }
                else
                {
                    var_72997 = 16.0;
                }
                var_955fa = var_72997;
            }
            highp float var_cedac;
            bool var_20358;
            if (var_41fbc.z > 0.0)
            {
                var_20358 = (v_adjacentClouds & 64) != int(0u);
                var_cedac = (16.0 - var_f07ec.y) / var_41fbc.z;
            }
            else
            {
                highp float var_07cbe;
                bool var_24c8a;
                if (var_41fbc.z < 0.0)
                {
                    var_24c8a = (v_adjacentClouds & 2) != int(0u);
                    var_07cbe = (-var_f07ec.y) / var_41fbc.z;
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
            if (var_41fbc.x > 0.0)
            {
                var_b720c = (v_adjacentClouds & 16) != int(0u);
                var_5a819 = (16.0 - var_f07ec.x) / var_41fbc.x;
            }
            else
            {
                highp float var_34373;
                bool var_ec04d;
                if (var_41fbc.x < 0.0)
                {
                    var_ec04d = (v_adjacentClouds & 8) != int(0u);
                    var_34373 = (-var_f07ec.x) / var_41fbc.x;
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
                bool var_e5c2f;
                highp float var_9564b;
                if (!var_20358)
                {
                    var_9564b = min(var_955fa, var_cedac);
                    var_e5c2f = false;
                }
                else
                {
                    var_9564b = var_955fa;
                    var_e5c2f = true;
                }
                var_8d09c = var_9564b;
                var_78fb0 = var_e5c2f;
            }
            else
            {
                bool var_2b703;
                highp float var_aa4b8;
                if (var_5a819 < var_cedac)
                {
                    bool var_0061a;
                    highp float var_ab896;
                    if (!var_b720c)
                    {
                        var_ab896 = min(var_955fa, var_5a819);
                        var_0061a = false;
                    }
                    else
                    {
                        var_ab896 = var_955fa;
                        var_0061a = true;
                    }
                    var_aa4b8 = var_ab896;
                    var_2b703 = var_0061a;
                }
                else
                {
                    var_aa4b8 = var_955fa;
                    var_2b703 = true;
                }
                var_8d09c = var_aa4b8;
                var_78fb0 = var_2b703;
            }
            highp float var_70b43;
            if (var_78fb0)
            {
                bool var_3a872 = var_41fbc.x > 0.0;
                bool var_003ec;
                if (var_3a872)
                {
                    var_003ec = var_41fbc.z > 0.0;
                }
                else
                {
                    var_003ec = var_3a872;
                }
                highp float var_91110;
                if (var_003ec)
                {
                    highp float var_b101b;
                    if (!((v_adjacentClouds & 128) != int(0u)))
                    {
                        var_b101b = min(var_8d09c, max(var_5a819, var_cedac));
                    }
                    else
                    {
                        var_b101b = var_8d09c;
                    }
                    var_91110 = var_b101b;
                }
                else
                {
                    bool var_90ee1 = var_41fbc.x > 0.0;
                    bool var_eecb5;
                    if (var_90ee1)
                    {
                        var_eecb5 = var_41fbc.z < 0.0;
                    }
                    else
                    {
                        var_eecb5 = var_90ee1;
                    }
                    highp float var_efc5d;
                    if (var_eecb5)
                    {
                        highp float var_22b49;
                        if (!((v_adjacentClouds & 4) != int(0u)))
                        {
                            var_22b49 = min(var_8d09c, max(var_5a819, var_cedac));
                        }
                        else
                        {
                            var_22b49 = var_8d09c;
                        }
                        var_efc5d = var_22b49;
                    }
                    else
                    {
                        bool var_8f61e = var_41fbc.x < 0.0;
                        bool var_501b8;
                        if (var_8f61e)
                        {
                            var_501b8 = var_41fbc.z > 0.0;
                        }
                        else
                        {
                            var_501b8 = var_8f61e;
                        }
                        highp float var_4a43d;
                        if (var_501b8)
                        {
                            highp float var_27789;
                            if (!((v_adjacentClouds & 32) != int(0u)))
                            {
                                var_27789 = min(var_8d09c, max(var_5a819, var_cedac));
                            }
                            else
                            {
                                var_27789 = var_8d09c;
                            }
                            var_4a43d = var_27789;
                        }
                        else
                        {
                            bool var_e0787 = var_41fbc.x < 0.0;
                            bool var_e9ab2;
                            if (var_e0787)
                            {
                                var_e9ab2 = var_41fbc.z < 0.0;
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
                            var_4a43d = var_97871;
                        }
                        var_efc5d = var_4a43d;
                    }
                    var_91110 = var_efc5d;
                }
                var_70b43 = var_91110;
            }
            else
            {
                var_70b43 = var_8d09c;
            }
            highp float var_6d8a6 = (1.0 + (CloudLightingUniforms.y * CloudLightingUniforms.y)) + ((2.0 * CloudLightingUniforms.y) * dot(var_1b8d5, -normalize(var_9248a.xyz)));
            var_33a04 = var_0c7de + (((var_e6692 * ((0.079577468335628509521484375 * (1.0 - (CloudLightingUniforms.y * CloudLightingUniforms.y))) / (var_6d8a6 * sqrt(var_6d8a6)))) * exp((-clamp(var_70b43, 0.0, 16.0)) * CloudLightingUniforms.w)) * (1.0 - smoothstep(0.0, CloudLightingUniforms.x, var_b7db1 * 0.5)));
        }
        else
        {
            var_33a04 = var_0c7de;
        }
        highp vec3 var_87f5a;
        if (CloudLightingToggles.x != 0.0)
        {
            highp vec3 var_5b0e8 = var_17732.xyz;
            highp float var_627ce = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
            highp float var_2c7aa = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
            highp vec3 var_08896 = v_color0.xyz * 1.0;
            var_87f5a = var_33a04 + (((((var_08896 * vec3(0.3183098733425140380859375)) * max((dot(var_5b0e8, var_1b8d5) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (var_627ce * var_627ce), 0.0)) + (((var_08896 * vec3(0.3183098733425140380859375)) * max((dot(-var_5b0e8, var_1b8d5) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (var_2c7aa * var_2c7aa), 0.0)) * (1.0 - smoothstep(0.0, CloudLightingUniforms.x, var_b7db1)))) * var_e6692) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        }
        else
        {
            var_87f5a = var_33a04;
        }
        highp vec3 var_0a3e8;
        if (QuantizationParameters.w > 0.0)
        {
            var_0a3e8 = (u_view * vec4(v_worldPos, 1.0)).xyz;
        }
        else
        {
            var_0a3e8 = var_9248a.xyz;
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
        highp vec2 var_0aa09 = vec2(clamp(dot(var_17732.xyz, -normalize(var_0a3e8)), 0.0, 1.0), 1.0);
        var_0aa09.y = 1.0 - var_0aa09.y;
        highp vec2 var_663e3 = texture(s_BrdfLUT, var_0aa09).xy;
        var_49eaf = var_87f5a + ((var_399f7 * ((vec3(0.039999999105930328369140625) * var_663e3.x) + vec3(var_663e3.y))) * CloudLightingUniforms.z);
    }
    else
    {
        var_49eaf = var_0c7de;
    }
    highp vec3 var_3613e;
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
            var_0e72c = mix(var_49eaf, (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_4607e * var_4607e) * var_4607e, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_8bb1f.w * (0.75 * ((var_f3314 * var_f3314) + 1.0))) + (var_f7264.w * (0.75 * ((var_c31e2 * var_c31e2) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_1ee0a * var_1ee0a) * var_1ee0a, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_8bb1f.w) * AtmosphericScattering.y) * var_e665a) * (0.0361000001430511474609375 / (var_ef3f9 * sqrt(var_ef3f9)))) + ((((MoonColor.xyz * var_f7264.w) * AtmosphericScattering.z) * var_ac1e2) * (0.0361000001430511474609375 / (var_b9d98 * sqrt(var_b9d98)))))), vec3(var_7bc6e));
        }
        else
        {
            var_0e72c = var_49eaf;
        }
        var_3613e = var_0e72c;
    }
    else
    {
        var_3613e = mix(var_49eaf, FogColor.xyz, vec3(var_7bc6e));
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
        var_94e72 = var_5363d.xyz + (var_3613e * var_67b96.w);
    }
    else
    {
        var_94e72 = var_3613e;
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
