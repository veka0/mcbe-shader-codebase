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
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 8, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 9, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraAmbientSamples;
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
* - uniform vec4 CloudViewport;
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
* - uniform vec4 DistanceControl;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 GameplayWorldStatus;
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
* - uniform vec4 SkyProbeUVFadeParameters;
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
* - uniform vec4 WorldOrigin;
*/

#extension GL_EXT_texture_cube_map_array : require
precision mediump float;
precision highp int;
vec3 var_efc27;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_proj;
uniform highp mat4 u_view;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler3D s_SkyAmbientSamples;
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
uniform highp vec4 SkyProbeUVFadeParameters;
uniform highp vec4 SkySamplesConfig;
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
void func_275f9(inout highp vec4 arg_78b9f) {
    if (true)
    {
        arg_78b9f = vec4(0.0);
        return;
    }
    arg_78b9f = vec4(0.0, 0.0, 0.0, 1.0);
}
void main() {
    highp vec4 var_c0b17 = v_color0;
    highp float var_3e947 = clamp(max((length(v_worldPos) / DistanceControl.x) - 0.89999997615814208984375, 0.0), 0.0, 1.0);
    highp vec3 var_0c7de = (v_color0.xyz * (SkyAmbientLightColorIntensity.xyz * SkyAmbientLightColorIntensity.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    highp vec4 var_c4f09 = u_view * vec4(v_worldPos, 1.0);
    highp vec4 var_e87e0 = u_proj * var_c4f09;
    highp vec4 var_b8928 = var_e87e0;
    highp vec3 var_454e5 = var_e87e0.xyz / vec3(var_b8928.w);
    highp vec3 var_08ca9;
    if (CloudLightingToggles.z != 0.0)
    {
        highp vec4 var_3b008 = vec4(v_normal, 0.0);
        highp vec4 var_07312 = u_view * var_3b008;
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
            highp float var_6d8a6 = (1.0 + (CloudLightingUniforms.y * CloudLightingUniforms.y)) + ((2.0 * CloudLightingUniforms.y) * dot(var_1b8d5, -normalize(var_c4f09.xyz)));
            var_33a04 = var_0c7de + (((var_e6692 * ((0.079577468335628509521484375 * (1.0 - (CloudLightingUniforms.y * CloudLightingUniforms.y))) / (var_6d8a6 * sqrt(var_6d8a6)))) * exp((-clamp(var_70b43, 0.0, 16.0)) * CloudLightingUniforms.w)) * (1.0 - smoothstep(0.0, CloudLightingUniforms.x, var_b7db1 * 0.5)));
        }
        else
        {
            var_33a04 = var_0c7de;
        }
        highp vec3 var_da355;
        if (CloudLightingToggles.x != 0.0)
        {
            highp vec3 var_5b0e8 = var_07312.xyz;
            highp float var_627ce = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
            highp float var_2c7aa = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
            highp vec3 var_08896 = v_color0.xyz * 1.0;
            var_da355 = var_33a04 + (((((var_08896 * vec3(0.3183098733425140380859375)) * max((dot(var_5b0e8, var_1b8d5) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (var_627ce * var_627ce), 0.0)) + (((var_08896 * vec3(0.3183098733425140380859375)) * max((dot(-var_5b0e8, var_1b8d5) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (var_2c7aa * var_2c7aa), 0.0)) * (1.0 - smoothstep(0.0, CloudLightingUniforms.x, var_b7db1)))) * var_e6692) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        }
        else
        {
            var_da355 = var_33a04;
        }
        highp vec3 var_75b34 = var_c4f09.xyz;
        highp vec3 var_05132 = var_07312.xyz;
        highp vec3 var_ccb42;
        if (IBLParameters.x != 0.0)
        {
            highp vec3 var_4d856;
            if (QuantizationParameters.w > 0.0)
            {
                var_4d856 = (u_view * vec4(v_worldPos, 1.0)).xyz;
            }
            else
            {
                var_4d856 = var_75b34;
            }
            highp vec3 var_b57c3 = reflect(normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_3b008.xyz);
            highp float var_fecfb;
            if (int(ConvolutionType.x) == 1)
            {
                var_fecfb = IBLParameters.y - 1.0;
            }
            else
            {
                var_fecfb = IBLParameters.y - 1.0;
            }
            int var_0a0b1 = int(LastSpecularIBLIdx.x);
            highp vec3 var_63ae8 = mix(textureLod(s_SpecularIBLRecords, vec4(var_b57c3, float((var_0a0b1 + 2) % 3)), var_fecfb).xyz, textureLod(s_SpecularIBLRecords, vec4(var_b57c3, float(var_0a0b1)), var_fecfb).xyz, vec3(IBLParameters.w));
            highp vec3 var_40fa6;
            if (PreExposureEnabled.x > 0.0)
            {
                var_40fa6 = var_63ae8 * vec3(301.72412109375);
            }
            else
            {
                var_40fa6 = var_63ae8;
            }
            highp vec3 var_d4ec7 = (var_40fa6 * 1.0) * IBLParameters.z;
            highp vec3 var_221c1;
            if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
            {
                highp vec4 var_00310;
                func_1e7c4(var_d4ec7, var_00310);
                highp vec4 var_a4557 = var_00310;
                highp vec3 var_63a76;
                if (var_a4557.w == 1.0)
                {
                    var_63a76 = var_00310.xyz;
                }
                else
                {
                    var_63a76 = var_d4ec7;
                }
                var_221c1 = var_63a76;
            }
            else
            {
                var_221c1 = var_d4ec7;
            }
            highp vec2 var_2b431 = vec2(clamp(dot(var_05132, -normalize(var_4d856)), 0.0, 1.0), 1.0);
            var_2b431.y = 1.0 - var_2b431.y;
            highp vec2 var_02c1b = texture(s_BrdfLUT, var_2b431).xy;
            var_ccb42 = var_221c1 * ((vec3(0.039999999105930328369140625) * var_02c1b.x) + vec3(var_02c1b.y));
        }
        else
        {
            highp vec3 var_7f130;
            if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
            {
                highp vec3 var_31b32;
                if (QuantizationParameters.w > 0.0)
                {
                    var_31b32 = (u_view * vec4(v_worldPos, 1.0)).xyz;
                }
                else
                {
                    var_31b32 = var_75b34;
                }
                highp vec4 var_d6ca6;
                func_275f9(var_d6ca6);
                highp vec2 var_9a8e6 = vec2(clamp(dot(var_05132, -normalize(var_31b32)), 0.0, 1.0), 1.0);
                var_9a8e6.y = 1.0 - var_9a8e6.y;
                highp vec2 var_89816 = texture(s_BrdfLUT, var_9a8e6).xy;
                var_7f130 = var_d6ca6.xyz * ((vec3(0.039999999105930328369140625) * var_89816.x) + vec3(var_89816.y));
            }
            else
            {
                var_7f130 = vec3(0.0);
            }
            var_ccb42 = var_7f130;
        }
        var_08ca9 = var_da355 + (var_ccb42 * CloudLightingUniforms.z);
    }
    else
    {
        var_08ca9 = var_0c7de;
    }
    highp vec3 var_3613e;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp vec3 var_a4d0b;
        if (var_3e947 > 0.0)
        {
            highp vec3 var_01183 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
            highp vec4 var_74a4d = SunColor;
            highp vec4 var_7394f = MoonColor;
            highp vec3 var_da3ac = var_01183;
            highp float var_e4090 = smoothstep(FogSkyBlend.z - FogSkyBlend.w, FogSkyBlend.x - FogSkyBlend.w, var_da3ac.y);
            highp float var_26eb8 = dot(var_01183, SunDir.xyz);
            highp float var_20cb8 = dot(var_01183, MoonDir.xyz);
            highp vec3 var_4b789 = var_01183;
            highp float var_03e2a = smoothstep(FogSkyBlend.y, FogSkyBlend.x - FogSkyBlend.w, var_4b789.y);
            highp float var_792bc = clamp(pow(max(var_26eb8, 0.0), AtmosphericScattering.w), 0.0, 1.0);
            highp float var_467d6 = clamp(pow(max(var_20cb8, 0.0), AtmosphericScattering.w), 0.0, 1.0);
            highp float var_0ec04 = 1.809999942779541015625 - (var_792bc * 1.7999999523162841796875);
            highp float var_dd032 = 1.809999942779541015625 - (var_467d6 * 1.7999999523162841796875);
            highp vec3 var_493ac = mix(var_08ca9, (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_03e2a * var_03e2a) * var_03e2a, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_74a4d.w * (0.75 * ((var_26eb8 * var_26eb8) + 1.0))) + (var_7394f.w * (0.75 * ((var_20cb8 * var_20cb8) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_e4090 * var_e4090) * var_e4090, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_74a4d.w) * AtmosphericScattering.y) * var_792bc) * (0.0361000001430511474609375 / (var_0ec04 * sqrt(var_0ec04)))) + ((((MoonColor.xyz * var_7394f.w) * AtmosphericScattering.z) * var_467d6) * (0.0361000001430511474609375 / (var_dd032 * sqrt(var_dd032)))))), vec3(var_3e947));
            var_a4d0b = var_493ac;
        }
        else
        {
            var_a4d0b = var_08ca9;
        }
        var_3613e = var_a4d0b;
    }
    else
    {
        var_3613e = mix(var_08ca9, FogColor.xyz, vec3(var_3e947));
    }
    highp vec3 var_777da;
    highp vec3 var_a7cf1;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_454e5.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_454e5, 1.0);
        highp float var_b4ccc = var_7d045.x;
        highp vec3 var_2d7e6 = vec3(var_b4ccc, var_7d045.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_203f7 = var_2d7e6;
        highp float var_eb2d5 = (var_203f7.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_5363d = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        highp vec4 var_67b96 = var_5363d;
        var_a7cf1 = var_2d7e6;
        var_777da = var_5363d.xyz + (var_3613e * var_67b96.w);
    }
    else
    {
        var_a7cf1 = var_efc27;
        var_777da = var_3613e;
    }
    highp float var_e556d;
    highp vec3 var_83a44;
    if (SkySamplesConfig.x > 0.5)
    {
        highp vec3 var_52dd3 = var_a7cf1;
        var_52dd3.y = 1.0 - var_52dd3.y;
        var_52dd3.z -= SkySamplesConfig.z;
        var_52dd3.z = (exp(4.0 * var_52dd3.z) - 1.0) * 0.0186573602259159088134765625;
        highp vec2 var_d121e = textureLod(s_SkyAmbientSamples, var_52dd3, 0.0).xy;
        highp float var_85613;
        highp vec3 var_bea53;
        if (var_d121e.y < SkySamplesConfig.w)
        {
            var_bea53 = vec3(0.0);
            var_85613 = 0.0;
        }
        else
        {
            var_bea53 = var_777da;
            var_85613 = var_c0b17.w;
        }
        var_83a44 = var_bea53;
        var_e556d = var_85613;
    }
    else
    {
        var_83a44 = var_777da;
        var_e556d = var_c0b17.w;
    }
    highp vec4 var_a7a58 = u_proj * (u_view * vec4(v_worldPos, 1.0));
    highp vec4 var_f3cab = var_a7a58;
    highp vec2 var_7b30f = ((var_a7a58.xyz / vec3(var_f3cab.w)).xy + vec2(1.0)) * vec2(0.5);
    highp vec3 var_c20f0;
    if (PreExposureEnabled.x > 0.0)
    {
        var_c20f0 = var_83a44 * 0.0033142860047519207000732421875;
    }
    else
    {
        var_c20f0 = var_83a44;
    }
    bgfx_FragColor = vec4(var_c20f0, ((clamp(var_7b30f.y, SkyProbeUVFadeParameters.y, SkyProbeUVFadeParameters.x) - SkyProbeUVFadeParameters.y) / ((SkyProbeUVFadeParameters.x - SkyProbeUVFadeParameters.y) + 9.9999997473787516355514526367188e-06)) * var_e556d);
}
