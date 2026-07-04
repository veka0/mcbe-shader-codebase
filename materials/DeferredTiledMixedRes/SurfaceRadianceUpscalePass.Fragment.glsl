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
* - UPSCALING__OFF
* - UPSCALING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_CausticsMultiplier;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_DiffuseLighting;
* - uniform lowp usampler2D s_EmissiveAmbientLinearRoughness;
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_NormalsAndDepthLighting;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
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
* - uniform vec4 CameraAmbientContribution;
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
* - uniform vec4 LightingUpscaleParams;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform vec4 PointLightPreCalcValues;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowAtlasResolution;
* - uniform vec4 PointLightShadowParams1;
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
* - uniform vec4 WaterSurfaceEnabledAndExtinctionDistShift;
* - uniform vec4 WaterSurfaceOctaveParameters;
* - uniform vec4 WaterSurfaceParameters;
* - uniform vec4 WaterSurfaceWaveParameters;
* - uniform vec4 WorldOrigin;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_DiffuseLighting;
#ifdef UPSCALING__ON
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_NormalsAndDepthLighting;
#endif
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2D s_SpecularLighting;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler3D s_SkyAmbientSamples;
uniform highp usampler2D s_EmissiveAmbientLinearRoughness;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraAmbientContribution;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
#ifdef UPSCALING__ON
uniform highp vec4 DownsampleResolutionAndRecipResolution;
#endif
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
#ifdef UPSCALING__ON
uniform highp vec4 LightingUpscaleParams;
#endif
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkySamplesConfig;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 UndergroundFogColor;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
in highp vec3 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_dc62c(inout highp float arg_e6305) {
    if (SkySamplesConfig.x > 0.5)
    {
        arg_e6305 = textureLod(s_SkyAmbientSamples, vec3(v_texcoord0.xy, 1.0), 0.0).y;
        return;
    }
    else
    {
        arg_e6305 = 1.0;
        return;
    }
}
void func_9b87e(inout highp vec3 arg_3007f, inout highp vec3 arg_87bd1) {
    if (ColorGrading_OptimizeGammaCorrection.x != 0.0)
    {
        arg_3007f = pow(max(arg_87bd1, vec3(0.0)), vec3(2.2000000476837158203125));
        return;
    }
    else
    {
        highp vec3 loc_407b7 = arg_87bd1;
        highp vec3 loc_67ff9 = arg_87bd1 * vec3(0.077399380505084991455078125);
        highp vec3 loc_b63b1 = pow((arg_87bd1 + vec3(0.054999999701976776123046875)) * vec3(0.947867333889007568359375), vec3(2.400000095367431640625));
        highp float loc_e81ff;
        if (loc_407b7.x <= 0.040449999272823333740234375)
        {
            loc_e81ff = loc_67ff9.x;
        }
        else
        {
            loc_e81ff = loc_b63b1.x;
        }
        loc_407b7.x = loc_e81ff;
        highp float loc_007b0;
        if (loc_407b7.y <= 0.040449999272823333740234375)
        {
            loc_007b0 = loc_67ff9.y;
        }
        else
        {
            loc_007b0 = loc_b63b1.y;
        }
        loc_407b7.y = loc_007b0;
        highp float loc_fa4a6;
        if (loc_407b7.z <= 0.040449999272823333740234375)
        {
            loc_fa4a6 = loc_67ff9.z;
        }
        else
        {
            loc_fa4a6 = loc_b63b1.z;
        }
        loc_407b7.z = loc_fa4a6;
        arg_3007f = loc_407b7;
        return;
    }
}
void main() {
#ifdef UPSCALING__ON
    highp vec4 var_99c96 = texture(s_Normal, v_texcoord0.xy);
#endif
    highp vec4 var_11add = texture(s_SceneDepth, v_texcoord0.xy);
    highp float var_3533f = (var_11add.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_3533f, 1.0);
    highp mat4 var_4fa47 = u_invProj;
    highp mat4 var_498b7 = u_invProj;
    highp mat4 var_4882d = u_invProj;
    highp mat4 var_78c1b = u_invProj;
    highp mat4 var_40575 = u_invProj;
    highp float var_eb413 = var_df846.x;
    highp float var_ac116 = var_df846.y;
    highp float var_f2b7c = var_df846.w;
    highp float var_0357c = var_df846.z;
    highp float var_2c821 = var_df846.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_4fa47[0].x, var_ac116 * var_498b7[1].y, var_f2b7c * var_4882d[3].z, (var_0357c * var_78c1b[2].w) + (var_2c821 * var_40575[3].w));
    var_df846 = var_9666f;
    highp float var_d799e = var_df846.w;
    highp vec4 var_98bb3 = var_9666f / vec4(var_d799e);
    var_df846 = var_98bb3;
#ifdef UPSCALING__ON
    highp vec2 var_745cb = var_99c96.xy;
    highp vec3 var_b0cb0 = vec3(var_99c96.xy, (1.0 - abs(var_745cb.x)) - abs(var_745cb.y));
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
    highp vec3 var_6807c = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
#endif
    highp vec4 var_bde9b = texture(s_ColorMetalnessSubsurface, v_texcoord0.xy);
    uvec4 var_e9495 = texelFetch(s_EmissiveAmbientLinearRoughness, ivec2(vec2(textureSize(s_EmissiveAmbientLinearRoughness, 0)) * v_texcoord0.xy), 0);
    uint var_4b676 = var_e9495.x & 65535u;
    uvec2 var_49e6b = uvec2(var_4b676 >> 8u, var_4b676 & 255u);
    highp vec2 var_c1cfe = vec2(float(var_49e6b.x), float(var_49e6b.y)) * vec2(0.0039215688593685626983642578125);
    highp float var_f8f82;
    if (var_3533f == 1.0)
    {
        highp float var_92116;
        func_dc62c(var_92116);
        var_f8f82 = var_92116;
    }
    else
    {
        var_f8f82 = float(var_e9495.w) * 0.0039215688593685626983642578125;
    }
    highp vec3 var_b1215 = vec3(v_projPosition.xy, var_3533f);
    highp vec3 var_9e11a = var_bde9b.xyz;
    highp vec3 var_b4d3f;
    func_9b87e(var_b4d3f, var_9e11a);
    highp vec3 var_5bd0a = var_b1215;
    highp vec3 var_0e02e;
    highp vec3 var_cd655;
    if (var_5bd0a.z != 1.0)
    {
#ifdef UPSCALING__OFF
        var_cd655 = var_b4d3f * texture(s_DiffuseLighting, v_texcoord0.xy).xyz;
        var_0e02e = texture(s_SpecularLighting, v_texcoord0.xy).xyz;
#endif
#ifdef UPSCALING__ON
        highp vec3 var_84f2b = var_b1215;
        highp float var_b0dde = (var_84f2b.z * 0.5) + 0.5;
        highp vec2 var_3fd73 = (floor((v_texcoord0.xy * DownsampleResolutionAndRecipResolution.xy) - vec2(0.5)) + vec2(0.5)) * DownsampleResolutionAndRecipResolution.zw;
        highp vec2 var_9819f[4] = vec2[](var_3fd73, var_3fd73 + (vec2(1.0, 0.0) * DownsampleResolutionAndRecipResolution.zw), var_3fd73 + (vec2(0.0, 1.0) * DownsampleResolutionAndRecipResolution.zw), var_3fd73 + DownsampleResolutionAndRecipResolution.zw);
        highp vec2 var_5d6bf = fract((v_texcoord0.xy - var_3fd73) * DownsampleResolutionAndRecipResolution.xy);
        highp vec4 var_cf9a1 = vec4(0.0);
        var_cf9a1.x = (1.0 - var_5d6bf.x) * (1.0 - var_5d6bf.y);
        var_cf9a1.y = var_5d6bf.x * (1.0 - var_5d6bf.y);
        var_cf9a1.z = (1.0 - var_5d6bf.x) * var_5d6bf.y;
        var_cf9a1.w = var_5d6bf.x * var_5d6bf.y;
        highp vec4 var_c8041 = var_cf9a1;
        highp vec4 var_e4269 = vec4(0.0);
        for (int var_40384 = 0; var_40384 < 4; var_40384++)
        {
            highp vec4 var_66319 = texture(s_NormalsAndDepthLighting, var_9819f[var_40384]);
            highp vec2 var_7bee0 = (var_66319.xy * 2.0) - vec2(1.0);
            highp vec2 var_5e4f9 = var_7bee0;
            highp vec3 var_2af73 = vec3(var_7bee0, (1.0 - abs(var_5e4f9.x)) - abs(var_5e4f9.y));
            highp vec2 var_6e823;
            if (var_2af73.z < 0.0)
            {
                var_6e823 = (vec2(1.0) - abs(var_2af73.yx)) * ((step(vec2(0.0), var_2af73.xy) * 2.0) - vec2(1.0));
            }
            else
            {
                var_6e823 = var_2af73.xy;
            }
            highp vec3 var_65edd = var_2af73;
            var_2af73 = vec3(var_6e823.x, var_6e823.y, var_65edd.z);
            highp vec2 var_e5a13 = var_66319.zw;
            highp float var_5f5e6 = ((var_e5a13.x * 65535.0) + var_e5a13.y) * 1.525902189314365386962890625e-05;
            highp float var_d076c = max(clamp(exp2((dot(normalize(normalize(vec3(var_6e823.x, var_6e823.y, var_65edd.z))), var_6807c) - 1.0) * LightingUpscaleParams.x), 0.0, 1.0), 6.1999999161344021558761596679688e-05);
            var_e4269[var_40384] = (var_d076c * mix(1.0 / (6.1999999161344021558761596679688e-05 + abs(var_b0dde - var_5f5e6)), mix(0.00012399999832268804311752319335938, 0.0, 1.0 - step(var_d076c, 6.1999999161344021558761596679688e-05)), max(step(1.0, var_b0dde), step(1.0, var_5f5e6)))) * var_c8041[var_40384];
        }
        highp vec2 var_efdab = var_e4269.xy;
        highp vec2 var_d1a8a = var_e4269.zw;
        highp vec2 var_ab005 = vec2(var_efdab.x + var_efdab.y, var_d1a8a.x + var_d1a8a.y);
        highp vec4 var_a3568 = mix(vec4(var_9819f[0], var_9819f[2]), vec4(var_9819f[1], var_9819f[3]), mix(vec4(0.0), var_e4269.yyww / var_ab005.xxyy, greaterThan(var_ab005.xxyy, vec4(0.0))));
        highp vec2 var_a039c = var_ab005;
        highp vec2 var_6c09d = var_ab005 / vec2((var_a039c.x + var_a039c.y) + 6.1999999161344021558761596679688e-05);
        highp vec2 var_02a54 = var_6c09d;
        highp vec2 var_f2139 = var_6c09d;
        var_cd655 = var_b4d3f * ((texture(s_DiffuseLighting, var_a3568.xy).xyz * var_02a54.x) + (texture(s_DiffuseLighting, var_a3568.zw).xyz * var_02a54.y));
        var_0e02e = (texture(s_SpecularLighting, var_a3568.xy).xyz * var_f2139.x) + (texture(s_SpecularLighting, var_a3568.zw).xyz * var_f2139.y);
#endif
    }
    else
    {
        var_cd655 = vec3(0.0);
        var_0e02e = vec3(0.0);
    }
    highp vec3 var_cdd00 = normalize((u_invView * vec4(var_98bb3.xyz, 1.0)).xyz - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
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
    highp vec3 var_936b4;
    if (var_68aa1)
    {
        highp vec4 var_1a32d = vec4(1.0);
        highp vec4 var_ee7a5 = SkyAmbientLightColorIntensity;
        var_936b4 = max(((vec3(1.0) + (vec3(1.0) * var_1a32d.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_ee7a5.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_936b4 = vec3(0.0);
    }
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_a0f15 = clamp((((length(var_98bb3.xyz) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_a0f15 > 0.0)
        {
            highp vec3 var_44083;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_44083 = FogColor.xyz * max(var_936b4, vec3(1.0));
            }
            else
            {
                highp vec4 var_a0aa2 = SunColor;
                highp vec4 var_ea036 = MoonColor;
                highp vec3 var_bacde = var_cdd00;
                highp float var_9281d = 1.0 - smoothstep(FogSkyBlend.x - FogSkyBlend.w, FogSkyBlend.z - FogSkyBlend.w, var_bacde.y);
                highp float var_99d92 = dot(var_cdd00, SunDir.xyz);
                highp float var_b6eed = dot(var_cdd00, MoonDir.xyz);
                highp vec3 var_5d345 = var_cdd00;
                highp float var_070ce = 1.0 - smoothstep(FogSkyBlend.x - FogSkyBlend.w, FogSkyBlend.y, var_5d345.y);
                highp float var_824a6 = clamp(pow(max(var_99d92, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_3b3ff = clamp(pow(max(var_b6eed, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_3d1af = 1.809999942779541015625 - (var_824a6 * 1.7999999523162841796875);
                highp float var_db5e0 = 1.809999942779541015625 - (var_3b3ff * 1.7999999523162841796875);
                highp vec3 var_5ec80 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3((var_070ce * var_070ce) * var_070ce)) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_a0aa2.w * (0.75 * ((var_99d92 * var_99d92) + 1.0))) + (var_ea036.w * (0.75 * ((var_b6eed * var_b6eed) + 1.0))))) + (((SkyHorizonColor.xyz * ((var_9281d * var_9281d) * var_9281d)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_a0aa2.w) * AtmosphericScattering.y) * var_824a6) * (0.0361000001430511474609375 / (var_3d1af * sqrt(var_3d1af)))) + ((((MoonColor.xyz * var_ea036.w) * AtmosphericScattering.z) * var_3b3ff) * (0.0361000001430511474609375 / (var_db5e0 * sqrt(var_db5e0))))));
                highp vec3 var_9d0d4;
                if (AtmosphericScatteringToggles.w != 0.0)
                {
                    var_9d0d4 = mix(UndergroundFogColor.xyz, var_5ec80, vec3(max(CameraAmbientContribution.y, var_f8f82)));
                }
                else
                {
                    var_9d0d4 = var_5ec80;
                }
                var_44083 = var_9d0d4;
            }
            var_138a7 = var_44083;
        }
        else
        {
            var_138a7 = vec3(0.0);
        }
        var_bdb1d = var_a0f15;
        var_1bb57 = var_138a7;
    }
    else
    {
        var_bdb1d = 0.0;
        var_1bb57 = vec3(0.0);
    }
    highp vec4 var_5353f = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_8e056 = var_5353f;
    highp vec4 var_c8bd4;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_115ba = (var_b1215.xy + vec2(1.0)) * 0.5;
        highp vec4 var_cf4b5 = u_invProj * vec4(v_projPosition.xy, var_3533f, 1.0);
        highp float var_8cf8f = var_115ba.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_115ba.y, log((53.598148345947265625 * ((((-var_cf4b5.z) / var_cf4b5.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_c8bd4 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_c8bd4 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_e68c0 = var_c8bd4;
    highp vec4 var_42ec2 = vec4(var_c8bd4.xyz + (mix((var_cd655 + var_0e02e) + (((mix(var_b4d3f, vec3(dot(var_b4d3f, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_c1cfe.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_5353f.xyz, vec3(var_8e056.w)) * var_e68c0.w), 1.0);
    highp vec4 var_d912f;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec3 var_02f69 = var_42ec2.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_d912f = vec4(var_02f69.x, var_02f69.y, var_02f69.z, var_42ec2.w);
    }
    else
    {
        var_d912f = var_42ec2;
    }
    bgfx_FragData0 = var_d912f;
}
