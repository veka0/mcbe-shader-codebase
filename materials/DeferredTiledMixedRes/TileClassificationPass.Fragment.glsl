#version 310 es

/*
* Available Macros:
*
* Passes:
* - CAUSTICS_MULTIPLIER_PASS (not used)
* - DIRECTIONAL_LIGHTING_PASS (not used)
* - DIRECTIONAL_LIGHTING_PASS0_PASS (not used)
* - DIRECTIONAL_LIGHTING_PASS1_PASS (not used)
* - DISCRETE_INDIRECT_COMBINED_LIGHTING_PASS (not used)
* - FALLBACK_PASS (not used)
* - SURFACE_RADIANCE_UPSCALE_PASS (not used)
* - TILE_CLASSIFICATION_PASS (not used)
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF (not used)
* - POINT_LIGHT_SHADING__ON (not used)
*
* Upscaling:
* - UPSCALING__OFF (not used)
* - UPSCALING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_CausticsMultiplier;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_DiffuseLighting;
* - uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_NormalsAndDepthLighting;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform lowp sampler2D s_SpecularLighting;
* - layout(binding = 14, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 15, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform mat4 CloudShadowProj;
* - uniform vec4 CloudShadowsVisible;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 DownsampleResolutionAndRecipResolution;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 GameplayWorldStatus;
* - uniform vec4 LightingUpscaleParams;
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
* - uniform vec4 SceneResolutionAndRecipResolution;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkySamplesConfig;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TilingParams;
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

precision mediump float;
precision highp int;
uniform highp mat4 CascadesShadowProj[8];
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp sampler2D s_NormalsAndDepthLighting;
uniform highp vec4 CascadesPerSet;
uniform highp vec4 SceneResolutionAndRecipResolution;
uniform highp vec4 TilingParams;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_76944 = ceil(SceneResolutionAndRecipResolution.xyxy * (1.0 / TilingParams.x));
    highp vec2 var_d1338 = vec2(1.0) / var_76944.zw;
    highp vec2 var_75ec0 = v_texcoord0.xy;
    var_75ec0.y = 1.0 - var_75ec0.y;
    highp vec2 var_72245 = var_75ec0;
    highp vec2 var_621e9 = (floor(var_72245 * var_76944.xy) + vec2(0.5)) * var_d1338.xy;
    var_75ec0 = var_621e9;
    highp vec4 var_9ee6b = texture(s_NormalsAndDepthLighting, var_621e9);
    highp vec4 var_75f56 = var_9ee6b;
    bool var_6ab7d = var_75f56.x < 0.99993801116943359375;
    bool var_e8ba3;
    if (var_6ab7d)
    {
        var_e8ba3 = var_75f56.w > 6.1999999161344021558761596679688e-05;
    }
    else
    {
        var_e8ba3 = var_6ab7d;
    }
    int var_725a3;
    if (var_e8ba3)
    {
        highp vec2 var_81347 = vec2(1.00050008296966552734375) - (vec2(0.5) / (var_9ee6b.xy * 999.75));
        var_75ec0 = v_texcoord0.xy;
        highp vec2 var_969ef = floor(v_texcoord0.xy * var_76944.xy) * var_d1338.xy;
        highp vec2 var_006f5 = var_969ef + (vec2(1.0, 0.0) * var_d1338.xy);
        highp vec2 var_5b7a9 = var_969ef + var_d1338.xy;
        highp vec2 var_416d9 = var_969ef + (vec2(0.0, 1.0) * var_d1338.xy);
        highp vec3 var_e33af = vec3(var_969ef, var_81347.x);
        highp vec2 var_0ee67 = (var_e33af.xy * 2.0) - vec2(1.0);
        highp vec3 var_5a97e = vec3(var_0ee67.x, var_0ee67.y, var_e33af.z);
        highp vec4 var_92af5 = vec4(var_0ee67, var_5a97e.z, 1.0);
        highp mat4 var_1356c = u_invProj;
        highp float var_a1967 = var_92af5.x;
        highp float var_ccc39 = var_92af5.y;
        highp float var_071ba = var_92af5.w;
        highp float var_55419 = var_92af5.z;
        highp float var_10bf4 = var_92af5.w;
        highp vec4 var_67b7b = vec4(var_a1967 * var_1356c[0].x, var_ccc39 * var_1356c[1].y, var_071ba * var_1356c[3].z, (var_55419 * var_1356c[2].w) + (var_10bf4 * var_1356c[3].w));
        var_92af5 = var_67b7b;
        highp float var_750bb = var_92af5.w;
        highp vec4 var_507ab = var_67b7b / vec4(var_750bb);
        var_92af5 = var_507ab;
        highp vec4 var_4f654 = u_invView * vec4(var_507ab.xyz, 1.0);
        highp vec3 var_eda7d = vec3(var_006f5, var_81347.x);
        highp vec2 var_44d86 = (var_eda7d.xy * 2.0) - vec2(1.0);
        highp vec3 var_7b7c3 = vec3(var_44d86.x, var_44d86.y, var_eda7d.z);
        highp vec4 var_1a05a = vec4(var_44d86, var_7b7c3.z, 1.0);
        highp mat4 var_daa09 = u_invProj;
        highp float var_0bf64 = var_1a05a.x;
        highp float var_a9f3a = var_1a05a.y;
        highp float var_3792e = var_1a05a.w;
        highp float var_8e4d8 = var_1a05a.z;
        highp float var_54205 = var_1a05a.w;
        highp vec4 var_e0c52 = vec4(var_0bf64 * var_daa09[0].x, var_a9f3a * var_daa09[1].y, var_3792e * var_daa09[3].z, (var_8e4d8 * var_daa09[2].w) + (var_54205 * var_daa09[3].w));
        var_1a05a = var_e0c52;
        highp float var_4c55f = var_1a05a.w;
        highp vec4 var_9ef2d = var_e0c52 / vec4(var_4c55f);
        var_1a05a = var_9ef2d;
        highp vec4 var_3fc70 = u_invView * vec4(var_9ef2d.xyz, 1.0);
        highp vec3 var_d9d6c = vec3(var_5b7a9, var_81347.x);
        highp vec2 var_502d2 = (var_d9d6c.xy * 2.0) - vec2(1.0);
        highp vec3 var_1ba9b = vec3(var_502d2.x, var_502d2.y, var_d9d6c.z);
        highp vec4 var_8e332 = vec4(var_502d2, var_1ba9b.z, 1.0);
        highp mat4 var_c340b = u_invProj;
        highp float var_f4f38 = var_8e332.x;
        highp float var_61554 = var_8e332.y;
        highp float var_e057a = var_8e332.w;
        highp float var_99cf2 = var_8e332.z;
        highp float var_daf72 = var_8e332.w;
        highp vec4 var_ad683 = vec4(var_f4f38 * var_c340b[0].x, var_61554 * var_c340b[1].y, var_e057a * var_c340b[3].z, (var_99cf2 * var_c340b[2].w) + (var_daf72 * var_c340b[3].w));
        var_8e332 = var_ad683;
        highp float var_88b0a = var_8e332.w;
        highp vec4 var_90614 = var_ad683 / vec4(var_88b0a);
        var_8e332 = var_90614;
        highp vec4 var_894b6 = u_invView * vec4(var_90614.xyz, 1.0);
        highp vec3 var_dfb64 = vec3(var_416d9, var_81347.x);
        highp vec2 var_ec3d2 = (var_dfb64.xy * 2.0) - vec2(1.0);
        highp vec3 var_94529 = vec3(var_ec3d2.x, var_ec3d2.y, var_dfb64.z);
        highp vec4 var_45215 = vec4(var_ec3d2, var_94529.z, 1.0);
        highp mat4 var_a48cb = u_invProj;
        highp float var_55870 = var_45215.x;
        highp float var_a94cd = var_45215.y;
        highp float var_37c9c = var_45215.w;
        highp float var_30eeb = var_45215.z;
        highp float var_acdec = var_45215.w;
        highp vec4 var_27587 = vec4(var_55870 * var_a48cb[0].x, var_a94cd * var_a48cb[1].y, var_37c9c * var_a48cb[3].z, (var_30eeb * var_a48cb[2].w) + (var_acdec * var_a48cb[3].w));
        var_45215 = var_27587;
        highp float var_9e7a6 = var_45215.w;
        highp vec4 var_ad3ec = var_27587 / vec4(var_9e7a6);
        var_45215 = var_ad3ec;
        highp vec4 var_73920 = u_invView * vec4(var_ad3ec.xyz, 1.0);
        highp vec3 var_d8750 = vec3(var_969ef, var_81347.y);
        highp vec2 var_5f88e = (var_d8750.xy * 2.0) - vec2(1.0);
        highp vec3 var_552c7 = vec3(var_5f88e.x, var_5f88e.y, var_d8750.z);
        highp vec4 var_e2763 = vec4(var_5f88e, var_552c7.z, 1.0);
        highp mat4 var_ca1eb = u_invProj;
        highp float var_3c555 = var_e2763.x;
        highp float var_b1506 = var_e2763.y;
        highp float var_0b766 = var_e2763.w;
        highp float var_05900 = var_e2763.z;
        highp float var_836c8 = var_e2763.w;
        highp vec4 var_0bbb1 = vec4(var_3c555 * var_ca1eb[0].x, var_b1506 * var_ca1eb[1].y, var_0b766 * var_ca1eb[3].z, (var_05900 * var_ca1eb[2].w) + (var_836c8 * var_ca1eb[3].w));
        var_e2763 = var_0bbb1;
        highp float var_00c29 = var_e2763.w;
        highp vec4 var_2cda2 = var_0bbb1 / vec4(var_00c29);
        var_e2763 = var_2cda2;
        highp vec4 var_a10ee = u_invView * vec4(var_2cda2.xyz, 1.0);
        highp vec3 var_e9a4f = vec3(var_006f5, var_81347.y);
        highp vec2 var_bb43b = (var_e9a4f.xy * 2.0) - vec2(1.0);
        highp vec3 var_9525e = vec3(var_bb43b.x, var_bb43b.y, var_e9a4f.z);
        highp vec4 var_3c4e7 = vec4(var_bb43b, var_9525e.z, 1.0);
        highp mat4 var_b68dc = u_invProj;
        highp float var_bbb61 = var_3c4e7.x;
        highp float var_28969 = var_3c4e7.y;
        highp float var_0fe2b = var_3c4e7.w;
        highp float var_89548 = var_3c4e7.z;
        highp float var_8cb2a = var_3c4e7.w;
        highp vec4 var_0e05f = vec4(var_bbb61 * var_b68dc[0].x, var_28969 * var_b68dc[1].y, var_0fe2b * var_b68dc[3].z, (var_89548 * var_b68dc[2].w) + (var_8cb2a * var_b68dc[3].w));
        var_3c4e7 = var_0e05f;
        highp float var_39475 = var_3c4e7.w;
        highp vec4 var_aa3cc = var_0e05f / vec4(var_39475);
        var_3c4e7 = var_aa3cc;
        highp vec4 var_4723c = u_invView * vec4(var_aa3cc.xyz, 1.0);
        highp vec3 var_92f5a = vec3(var_5b7a9, var_81347.y);
        highp vec2 var_979e2 = (var_92f5a.xy * 2.0) - vec2(1.0);
        highp vec3 var_67a54 = vec3(var_979e2.x, var_979e2.y, var_92f5a.z);
        highp vec4 var_5c4d0 = vec4(var_979e2, var_67a54.z, 1.0);
        highp mat4 var_a9a66 = u_invProj;
        highp float var_86b09 = var_5c4d0.x;
        highp float var_6a0c3 = var_5c4d0.y;
        highp float var_55fa3 = var_5c4d0.w;
        highp float var_bf2a0 = var_5c4d0.z;
        highp float var_eeb2c = var_5c4d0.w;
        highp vec4 var_45a0d = vec4(var_86b09 * var_a9a66[0].x, var_6a0c3 * var_a9a66[1].y, var_55fa3 * var_a9a66[3].z, (var_bf2a0 * var_a9a66[2].w) + (var_eeb2c * var_a9a66[3].w));
        var_5c4d0 = var_45a0d;
        highp float var_5f021 = var_5c4d0.w;
        highp vec4 var_97b79 = var_45a0d / vec4(var_5f021);
        var_5c4d0 = var_97b79;
        highp vec4 var_62a9b = u_invView * vec4(var_97b79.xyz, 1.0);
        highp vec3 var_89707 = vec3(var_416d9, var_81347.y);
        highp vec2 var_72203 = (var_89707.xy * 2.0) - vec2(1.0);
        highp vec3 var_def2f = vec3(var_72203.x, var_72203.y, var_89707.z);
        highp vec4 var_91df8 = vec4(var_72203, var_def2f.z, 1.0);
        highp mat4 var_3184b = u_invProj;
        highp float var_4a61c = var_91df8.x;
        highp float var_3b426 = var_91df8.y;
        highp float var_32bef = var_91df8.w;
        highp float var_265b7 = var_91df8.z;
        highp float var_e5afb = var_91df8.w;
        highp vec4 var_daad9 = vec4(var_4a61c * var_3184b[0].x, var_3b426 * var_3184b[1].y, var_32bef * var_3184b[3].z, (var_265b7 * var_3184b[2].w) + (var_e5afb * var_3184b[3].w));
        var_91df8 = var_daad9;
        highp float var_ed96d = var_91df8.w;
        highp vec4 var_e6864 = var_daad9 / vec4(var_ed96d);
        var_91df8 = var_e6864;
        highp vec4 var_9c14a = u_invView * vec4(var_e6864.xyz, 1.0);
        ivec4 var_f53fa;
        ivec4 var_19aa6;
        var_19aa6 = ivec4(8);
        var_f53fa = ivec4(8);
        int var_88f02;
        ivec4 var_991c5;
        ivec4 var_5a854;
        for (int var_b4b5c = 0, var_82652 = 0; (var_b4b5c < 4) && (var_82652 < 8); var_19aa6 = var_5a854, var_f53fa = var_991c5, var_82652 = var_88f02, var_b4b5c++)
        {
            int var_cde9b = int(CascadesPerSet[var_b4b5c]);
            var_5a854 = var_19aa6;
            var_991c5 = var_f53fa;
            ivec4 var_cd86a;
            ivec4 var_e86e4;
            for (int var_f3a5e = 0; var_f3a5e < var_cde9b; var_5a854 = var_e86e4, var_991c5 = var_cd86a, var_f3a5e++)
            {
                int var_bf1c5 = var_82652 + var_f3a5e;
                if (var_bf1c5 >= 8)
                {
                    break;
                }
                highp vec3 var_cce98 = abs((CascadesShadowProj[var_bf1c5] * vec4(var_4f654.xyz, 1.0)).xyz);
                bool var_54586 = var_cce98.x <= 1.0;
                bool var_d55ba;
                if (var_54586)
                {
                    var_d55ba = var_cce98.y <= 1.0;
                }
                else
                {
                    var_d55ba = var_54586;
                }
                bool var_fc927;
                if (var_d55ba)
                {
                    var_fc927 = var_cce98.z <= 1.0;
                }
                else
                {
                    var_fc927 = var_d55ba;
                }
                highp vec3 var_6cfd4 = abs((CascadesShadowProj[var_bf1c5] * vec4(var_3fc70.xyz, 1.0)).xyz);
                bool var_f7f3b = var_6cfd4.x <= 1.0;
                bool var_dca6c;
                if (var_f7f3b)
                {
                    var_dca6c = var_6cfd4.y <= 1.0;
                }
                else
                {
                    var_dca6c = var_f7f3b;
                }
                bool var_9da61;
                if (var_dca6c)
                {
                    var_9da61 = var_6cfd4.z <= 1.0;
                }
                else
                {
                    var_9da61 = var_dca6c;
                }
                highp vec3 var_f64b8 = abs((CascadesShadowProj[var_bf1c5] * vec4(var_894b6.xyz, 1.0)).xyz);
                bool var_46cd0 = var_f64b8.x <= 1.0;
                bool var_36b1d;
                if (var_46cd0)
                {
                    var_36b1d = var_f64b8.y <= 1.0;
                }
                else
                {
                    var_36b1d = var_46cd0;
                }
                bool var_0fd82;
                if (var_36b1d)
                {
                    var_0fd82 = var_f64b8.z <= 1.0;
                }
                else
                {
                    var_0fd82 = var_36b1d;
                }
                highp vec3 var_1993a = abs((CascadesShadowProj[var_bf1c5] * vec4(var_73920.xyz, 1.0)).xyz);
                bool var_84682 = var_1993a.x <= 1.0;
                bool var_5fdee;
                if (var_84682)
                {
                    var_5fdee = var_1993a.y <= 1.0;
                }
                else
                {
                    var_5fdee = var_84682;
                }
                bool var_97ec1;
                if (var_5fdee)
                {
                    var_97ec1 = var_1993a.z <= 1.0;
                }
                else
                {
                    var_97ec1 = var_5fdee;
                }
                ivec4 var_6c193 = ivec4(var_bf1c5);
                ivec4 var_ff622 = ivec4(var_bf1c5 + 8);
                bvec4 var_f6fb2 = not(bvec4(var_fc927, var_9da61, var_0fd82, var_97ec1));
                int var_38a68;
                if (var_f6fb2.x)
                {
                    var_38a68 = var_ff622.x;
                }
                else
                {
                    var_38a68 = var_6c193.x;
                }
                int var_e8583;
                if (var_f6fb2.y)
                {
                    var_e8583 = var_ff622.y;
                }
                else
                {
                    var_e8583 = var_6c193.y;
                }
                int var_c0301;
                if (var_f6fb2.z)
                {
                    var_c0301 = var_ff622.z;
                }
                else
                {
                    var_c0301 = var_6c193.z;
                }
                int var_06e20;
                if (var_f6fb2.w)
                {
                    var_06e20 = var_ff622.w;
                }
                else
                {
                    var_06e20 = var_6c193.w;
                }
                var_cd86a = min(var_991c5, ivec4(var_38a68, var_e8583, var_c0301, var_06e20));
                highp vec3 var_d25d2 = abs((CascadesShadowProj[var_bf1c5] * vec4(var_a10ee.xyz, 1.0)).xyz);
                bool var_8040b = var_d25d2.x <= 1.0;
                bool var_918db;
                if (var_8040b)
                {
                    var_918db = var_d25d2.y <= 1.0;
                }
                else
                {
                    var_918db = var_8040b;
                }
                bool var_293c4;
                if (var_918db)
                {
                    var_293c4 = var_d25d2.z <= 1.0;
                }
                else
                {
                    var_293c4 = var_918db;
                }
                highp vec3 var_8bfdc = abs((CascadesShadowProj[var_bf1c5] * vec4(var_4723c.xyz, 1.0)).xyz);
                bool var_607ac = var_8bfdc.x <= 1.0;
                bool var_a7d04;
                if (var_607ac)
                {
                    var_a7d04 = var_8bfdc.y <= 1.0;
                }
                else
                {
                    var_a7d04 = var_607ac;
                }
                bool var_39a80;
                if (var_a7d04)
                {
                    var_39a80 = var_8bfdc.z <= 1.0;
                }
                else
                {
                    var_39a80 = var_a7d04;
                }
                highp vec3 var_ae3b2 = abs((CascadesShadowProj[var_bf1c5] * vec4(var_62a9b.xyz, 1.0)).xyz);
                bool var_53dba = var_ae3b2.x <= 1.0;
                bool var_cf94e;
                if (var_53dba)
                {
                    var_cf94e = var_ae3b2.y <= 1.0;
                }
                else
                {
                    var_cf94e = var_53dba;
                }
                bool var_46171;
                if (var_cf94e)
                {
                    var_46171 = var_ae3b2.z <= 1.0;
                }
                else
                {
                    var_46171 = var_cf94e;
                }
                highp vec3 var_85618 = abs((CascadesShadowProj[var_bf1c5] * vec4(var_9c14a.xyz, 1.0)).xyz);
                bool var_0eb77 = var_85618.x <= 1.0;
                bool var_9273c;
                if (var_0eb77)
                {
                    var_9273c = var_85618.y <= 1.0;
                }
                else
                {
                    var_9273c = var_0eb77;
                }
                bool var_43351;
                if (var_9273c)
                {
                    var_43351 = var_85618.z <= 1.0;
                }
                else
                {
                    var_43351 = var_9273c;
                }
                ivec4 var_1f2e6 = ivec4(7 - var_bf1c5);
                ivec4 var_c27d9 = ivec4(15 - var_bf1c5);
                bvec4 var_ec465 = bvec4(var_293c4, var_39a80, var_46171, var_43351);
                int var_7eb9f;
                if (var_ec465.x)
                {
                    var_7eb9f = var_c27d9.x;
                }
                else
                {
                    var_7eb9f = var_1f2e6.x;
                }
                int var_7dae4;
                if (var_ec465.y)
                {
                    var_7dae4 = var_c27d9.y;
                }
                else
                {
                    var_7dae4 = var_1f2e6.y;
                }
                int var_0c04e;
                if (var_ec465.z)
                {
                    var_0c04e = var_c27d9.z;
                }
                else
                {
                    var_0c04e = var_1f2e6.z;
                }
                int var_c13fc;
                if (var_ec465.w)
                {
                    var_c13fc = var_c27d9.w;
                }
                else
                {
                    var_c13fc = var_1f2e6.w;
                }
                var_e86e4 = min(var_5a854, ivec4(var_7eb9f, var_7dae4, var_0c04e, var_c13fc));
            }
            var_88f02 = var_82652 + var_cde9b;
        }
        ivec4 var_0dcf6 = min(ivec4(var_f53fa.xy, var_19aa6.xy), ivec4(var_f53fa.zw, var_19aa6.zw));
        ivec2 var_2597c = min(var_0dcf6.xz, var_0dcf6.yw);
        ivec2 var_c05ca = ivec2(var_2597c.x, 8 - var_2597c.y);
        bool var_dc51e = var_c05ca.x == var_c05ca.y;
        bool var_c12d1;
        if (var_dc51e)
        {
            var_c12d1 = var_c05ca.x >= 0;
        }
        else
        {
            var_c12d1 = var_dc51e;
        }
        int var_1b6d4;
        if (var_c12d1)
        {
            var_1b6d4 = var_c05ca.x;
        }
        else
        {
            var_1b6d4 = 7;
        }
        var_725a3 = var_1b6d4;
    }
    else
    {
        var_725a3 = 8;
    }
    bgfx_FragColor = vec4(float(var_725a3) * 0.0039215688593685626983642578125, 0.0, 0.0, 1.0);
}
