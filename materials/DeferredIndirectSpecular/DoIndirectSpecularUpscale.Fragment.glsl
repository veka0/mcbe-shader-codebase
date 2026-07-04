#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_INDIRECT_SPECULAR_SHADING_DUAL_TARGET_PASS (not used)
* - DO_INDIRECT_SPECULAR_SHADING_SINGLE_TARGET_PASS (not used)
* - DO_INDIRECT_SPECULAR_UPSCALE_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Mode:
* - MODE__DEFAULT (not used)
* - MODE__MIXED_RES (not used)
*
* Upscaling:
* - UPSCALING__OFF
* - UPSCALING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_NormalsAndDepthLighting;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SSRTexture;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - uniform lowp sampler2D s_SpecularLighting;
* - layout(binding = 15, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 16, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 17, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 ConvolutionType;
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
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
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
* - uniform vec4 SSRParameters;
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
* - uniform vec4 ViewportScale;
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
#ifdef UPSCALING__ON
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_NormalsAndDepthLighting;
#endif
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2D s_SpecularLighting;
#ifdef UPSCALING__ON
uniform highp vec4 DownsampleResolutionAndRecipResolution;
uniform highp vec4 LightingUpscaleParams;
#endif
in highp vec3 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifdef UPSCALING__OFF
    highp vec3 var_e0f0d = vec3(v_projPosition.xy, (texture(s_SceneDepth, v_texcoord0.xy).x * 2.0) - 1.0);
#endif
#ifdef UPSCALING__ON
    highp vec4 var_99c96 = texture(s_Normal, v_texcoord0.xy);
    highp vec4 var_fef01 = texture(s_SceneDepth, v_texcoord0.xy);
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
    highp vec3 var_57949 = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_66b50 = vec3(v_projPosition.xy, (var_fef01.x * 2.0) - 1.0);
    highp vec3 var_e0f0d = var_66b50;
#endif
    highp vec3 var_50157;
    if (var_e0f0d.z != 1.0)
    {
#ifdef UPSCALING__OFF
        var_50157 = texture(s_SpecularLighting, v_texcoord0.xy).xyz;
#endif
#ifdef UPSCALING__ON
        highp vec3 var_84f2b = var_66b50;
        highp float var_7dd1a = (var_84f2b.z * 0.5) + 0.5;
        highp vec2 var_3fd73 = (floor((v_texcoord0.xy * DownsampleResolutionAndRecipResolution.xy) - vec2(0.5)) + vec2(0.5)) * DownsampleResolutionAndRecipResolution.zw;
        highp vec2 var_76592[4] = vec2[](var_3fd73, var_3fd73 + (vec2(1.0, 0.0) * DownsampleResolutionAndRecipResolution.zw), var_3fd73 + (vec2(0.0, 1.0) * DownsampleResolutionAndRecipResolution.zw), var_3fd73 + DownsampleResolutionAndRecipResolution.zw);
        highp vec2 var_5d6bf = fract((v_texcoord0.xy - var_3fd73) * DownsampleResolutionAndRecipResolution.xy);
        highp vec4 var_cf9a1 = vec4(0.0);
        var_cf9a1.x = (1.0 - var_5d6bf.x) * (1.0 - var_5d6bf.y);
        var_cf9a1.y = var_5d6bf.x * (1.0 - var_5d6bf.y);
        var_cf9a1.z = (1.0 - var_5d6bf.x) * var_5d6bf.y;
        var_cf9a1.w = var_5d6bf.x * var_5d6bf.y;
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
        highp vec4 var_6f1ec = mix(vec4(var_76592[0], var_76592[2]), vec4(var_76592[1], var_76592[3]), var_eacb9.yyww / var_4df2b.xxyy);
        highp vec2 var_b1bec = var_4df2b;
        highp vec2 var_8a5ed = var_4df2b / vec2(var_b1bec.x + var_b1bec.y);
        var_50157 = (texture(s_SpecularLighting, var_6f1ec.xy).xyz * var_8a5ed.x) + (texture(s_SpecularLighting, var_6f1ec.zw).xyz * var_8a5ed.y);
#endif
    }
    else
    {
        var_50157 = vec3(0.0);
    }
    bgfx_FragColor = vec4(var_50157, 1.0);
}
