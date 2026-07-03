#version 310 es

/*
* Available Macros:
*
* Passes:
* - DIRECTIONAL_LIGHTING_PASS (not used)
* - DISCRETE_INDIRECT_COMBINED_LIGHTING_PASS (not used)
* - FALLBACK_PASS (not used)
* - SURFACE_RADIANCE_UPSCALE_PASS (not used)
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
* - uniform lowp sampler2D s_BiomeBlendingMap;
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
* - uniform lowp sampler2D s_SpecularLighting;
* - layout(binding = 13, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 14, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 15, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform mat4 CloudShadowProj;
* - uniform vec4 CloudShadowsVisible;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
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
* - uniform vec4 SceneNearFar;
* - uniform vec4 SceneResolutionAndRecipResolution;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
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
* - uniform vec4 WaterSurfaceEnabled;
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
uniform highp sampler2D s_EmissiveAmbientLinearRoughness;
#ifdef UPSCALING__ON
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_NormalsAndDepthLighting;
#endif
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2D s_SpecularLighting;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
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
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
in highp vec3 v_projPosition;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifdef UPSCALING__ON
    highp vec4 var_158bd = texture(s_Normal, v_texcoord0);
#endif
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
    highp vec4 var_98bb3 = var_9666f / vec4(var_d799e);
    var_df846 = var_98bb3;
#ifdef UPSCALING__ON
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
    highp vec3 var_57949 = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
#endif
    highp vec4 var_27860 = texture(s_ColorMetalnessSubsurface, v_texcoord0);
    highp vec4 var_19ebc = texture(s_EmissiveAmbientLinearRoughness, v_texcoord0);
    highp vec3 var_b1215 = vec3(v_projPosition.xy, var_971b7);
    highp vec3 var_be88f = pow(max(var_27860.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
    highp vec3 var_5bd0a = var_b1215;
    highp vec3 var_5da19;
    highp vec3 var_b2e85;
    if (var_5bd0a.z != 1.0)
    {
#ifdef UPSCALING__OFF
        var_b2e85 = var_be88f * texture(s_DiffuseLighting, v_texcoord0).xyz;
        var_5da19 = texture(s_SpecularLighting, v_texcoord0).xyz;
#endif
#ifdef UPSCALING__ON
        highp vec3 var_84f2b = var_b1215;
        highp float var_7dd1a = (var_84f2b.z * 0.5) + 0.5;
        highp vec2 var_70c43 = (floor((v_texcoord0 * DownsampleResolutionAndRecipResolution.xy) - vec2(0.5)) + vec2(0.5)) * DownsampleResolutionAndRecipResolution.zw;
        highp vec2 var_76592[4] = vec2[](var_70c43, var_70c43 + (vec2(1.0, 0.0) * DownsampleResolutionAndRecipResolution.zw), var_70c43 + (vec2(0.0, 1.0) * DownsampleResolutionAndRecipResolution.zw), var_70c43 + DownsampleResolutionAndRecipResolution.zw);
        highp vec2 var_db58b = fract((v_texcoord0 - var_70c43) * DownsampleResolutionAndRecipResolution.xy);
        highp vec4 var_cf9a1 = vec4(0.0);
        var_cf9a1.x = (1.0 - var_db58b.x) * (1.0 - var_db58b.y);
        var_cf9a1.y = var_db58b.x * (1.0 - var_db58b.y);
        var_cf9a1.z = (1.0 - var_db58b.x) * var_db58b.y;
        var_cf9a1.w = var_db58b.x * var_db58b.y;
        highp vec4 var_5b2be = var_cf9a1;
        highp vec4 var_eacb9 = vec4(0.0);
        for (int var_a8556 = 0; var_a8556 < 4; var_a8556++)
        {
            highp vec4 var_66319 = texture(s_NormalsAndDepthLighting, var_76592[var_a8556]);
            highp vec2 var_7bee0 = (var_66319.xy * 2.0) - vec2(1.0);
            highp vec2 var_5e4f9 = var_7bee0;
            highp vec3 var_2af73 = vec3(var_7bee0, (1.0 - abs(var_5e4f9.x)) - abs(var_5e4f9.y));
            highp vec2 var_c7154;
            if (var_2af73.z < 0.0)
            {
                var_c7154 = (vec2(1.0) - abs(var_2af73.yx)) * ((step(vec2(0.0), var_2af73.xy) * 2.0) - vec2(1.0));
            }
            else
            {
                var_c7154 = var_2af73.xy;
            }
            highp vec3 var_67715 = var_2af73;
            var_2af73 = vec3(var_c7154.x, var_c7154.y, var_67715.z);
            highp vec2 var_915b8 = var_66319.zw;
            var_eacb9[var_a8556] = ((clamp(exp2((dot(normalize(normalize(vec3(var_c7154.x, var_c7154.y, var_67715.z))), var_57949) - 1.0) * LightingUpscaleParams.x), 0.0, 1.0) + 6.1999999161344021558761596679688e-05) * (6.1999999161344021558761596679688e-05 / (6.1999999161344021558761596679688e-05 + abs(var_7dd1a - (((var_915b8.x * 65535.0) + var_915b8.y) * 1.525902189314365386962890625e-05))))) * var_5b2be[var_a8556];
        }
        highp vec2 var_efdab = var_eacb9.xy;
        highp vec2 var_d1a8a = var_eacb9.zw;
        highp vec2 var_4df2b = vec2(var_efdab.x + var_efdab.y, var_d1a8a.x + var_d1a8a.y);
        highp vec4 var_50cc0 = mix(vec4(var_76592[0], var_76592[2]), vec4(var_76592[1], var_76592[3]), var_eacb9.yyww / var_4df2b.xxyy);
        highp vec2 var_b1bec = var_4df2b;
        highp vec2 var_c8c77 = var_4df2b / vec2(var_b1bec.x + var_b1bec.y);
        highp vec2 var_02a54 = var_c8c77;
        highp vec2 var_f2139 = var_c8c77;
        var_b2e85 = var_be88f * ((texture(s_DiffuseLighting, var_50cc0.xy).xyz * var_02a54.x) + (texture(s_DiffuseLighting, var_50cc0.zw).xyz * var_02a54.y));
        var_5da19 = (texture(s_SpecularLighting, var_50cc0.xy).xyz * var_f2139.x) + (texture(s_SpecularLighting, var_50cc0.zw).xyz * var_f2139.y);
#endif
    }
    else
    {
        var_b2e85 = vec3(0.0);
        var_5da19 = vec3(0.0);
    }
    highp vec3 var_135ba = normalize((u_invView * vec4(var_98bb3.xyz, 1.0)).xyz - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
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
    highp vec3 var_d9480;
    if (var_68aa1)
    {
        highp vec4 var_0e954 = vec4(1.0);
        highp vec4 var_4c0ec = SkyAmbientLightColorIntensity;
        var_d9480 = max((clamp(vec3(1.0 + (var_0e954.x * var_0e954.w), 1.0 + (var_0e954.y * var_0e954.w), 1.0 + (var_0e954.z * var_0e954.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_4c0ec.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_d9480 = vec3(0.0);
    }
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_a0f15 = clamp((((length(var_98bb3.xyz) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_a0f15 > 0.0)
        {
            highp vec3 var_fe67e;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_fe67e = FogColor.xyz * max(var_d9480, vec3(1.0));
            }
            else
            {
                highp vec4 var_52ab1 = SunColor;
                highp vec4 var_c9ec4 = MoonColor;
                highp vec3 var_e3755 = var_135ba;
                highp float var_7b136 = FogSkyBlend.x - FogSkyBlend.w;
                highp float var_e285c = smoothstep(FogSkyBlend.y, var_7b136, var_e3755.y);
                highp float var_2ea2e = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_7b136, var_e3755.y);
                highp float var_ec0d7 = dot(var_135ba, SunDir.xyz);
                highp float var_f7518 = dot(var_135ba, MoonDir.xyz);
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
        var_bdb1d = var_a0f15;
        var_1bb57 = var_138a7;
    }
    else
    {
        var_bdb1d = 0.0;
        var_1bb57 = vec3(0.0);
    }
    highp vec4 var_e90ab = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_6105a = var_e90ab;
    highp vec4 var_9a73a;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_115ba = (var_b1215.xy + vec2(1.0)) * 0.5;
        highp vec4 var_cf4b5 = u_invProj * vec4(v_projPosition.xy, var_971b7, 1.0);
        highp float var_8cf8f = var_115ba.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_115ba.y, log((53.598148345947265625 * ((((-var_cf4b5.z) / var_cf4b5.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_9a73a = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_9a73a = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_a74b2 = var_9a73a;
    highp vec4 var_55b1c = vec4(var_9a73a.xyz + (mix((var_b2e85 + var_5da19) + (((mix(var_be88f, vec3(dot(var_be88f, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_19ebc.x)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_e90ab.xyz, vec3(var_6105a.w)) * var_a74b2.w), 1.0);
    highp vec4 var_38beb;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec3 var_02f69 = var_55b1c.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_38beb = vec4(var_02f69.x, var_02f69.y, var_02f69.z, var_55b1c.w);
    }
    else
    {
        var_38beb = var_55b1c;
    }
    bgfx_FragColor = var_38beb;
}
