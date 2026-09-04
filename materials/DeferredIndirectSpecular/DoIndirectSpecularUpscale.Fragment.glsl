#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_INDIRECT_SPECULAR_SHADING_PASS (not used)
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
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp usampler2D s_EmissiveAmbientLinearRoughness;
* - layout(binding = 13, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_NormalsAndDepthLighting;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SSRTexture;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - uniform lowp sampler2D s_SpecularLighting;
* - layout(binding = 14, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
* - layout(binding = 15, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 16, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraAmbientContribution;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
* - uniform vec4 DownsampleResolutionAndRecipResolution;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightingUpscaleParams;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightPreCalcValues;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowAtlasResolution;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SSRParameters;
* - uniform vec4 SceneResolutionAndRecipResolution;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkySamplesConfig;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 UndergroundFogColor;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterSurfaceEnabledAndExtinctionDistShift;
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
layout(location = 0) out highp vec4 bgfx_FragData0;
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
    highp vec3 var_ecfd1 = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_66b50 = vec3(v_projPosition.xy, (var_fef01.x * 2.0) - 1.0);
    highp vec3 var_e0f0d = var_66b50;
#endif
    highp vec3 var_84f7f;
    if (var_e0f0d.z != 1.0)
    {
#ifdef UPSCALING__OFF
        var_84f7f = texture(s_SpecularLighting, v_texcoord0.xy).xyz;
#endif
#ifdef UPSCALING__ON
        highp vec3 var_84f2b = var_66b50;
        highp float var_dad33 = (var_84f2b.z * 0.5) + 0.5;
        highp vec2 var_c2ae4 = (floor((v_texcoord0.xy * DownsampleResolutionAndRecipResolution.xy) - vec2(0.5)) + vec2(0.5)) * DownsampleResolutionAndRecipResolution.zw;
        highp vec2 var_7fc08[4];
        var_7fc08[0] = var_c2ae4;
        var_7fc08[1] = var_c2ae4 + (vec2(1.0, 0.0) * DownsampleResolutionAndRecipResolution.zw);
        var_7fc08[2] = var_c2ae4 + (vec2(0.0, 1.0) * DownsampleResolutionAndRecipResolution.zw);
        var_7fc08[3] = var_c2ae4 + DownsampleResolutionAndRecipResolution.zw;
        highp vec2 var_5d6bf = fract((v_texcoord0.xy - var_c2ae4) * DownsampleResolutionAndRecipResolution.xy);
        highp vec4 var_cf9a1 = vec4(0.0);
        var_cf9a1.x = (1.0 - var_5d6bf.x) * (1.0 - var_5d6bf.y);
        var_cf9a1.y = var_5d6bf.x * (1.0 - var_5d6bf.y);
        var_cf9a1.z = (1.0 - var_5d6bf.x) * var_5d6bf.y;
        var_cf9a1.w = var_5d6bf.x * var_5d6bf.y;
        highp vec4 var_a5d57 = var_cf9a1;
        highp vec4 var_119a3 = vec4(0.0);
        for (int var_e1ef0 = 0; var_e1ef0 < 4; var_e1ef0++)
        {
            highp vec4 var_66319 = texture(s_NormalsAndDepthLighting, var_7fc08[var_e1ef0]);
            highp vec2 var_7bee0 = (var_66319.xy * 2.0) - vec2(1.0);
            highp vec2 var_5e4f9 = var_7bee0;
            highp vec3 var_2af73 = vec3(var_7bee0, (1.0 - abs(var_5e4f9.x)) - abs(var_5e4f9.y));
            highp vec2 var_be267;
            if (var_2af73.z < 0.0)
            {
                var_be267 = (vec2(1.0) - abs(var_2af73.yx)) * ((step(vec2(0.0), var_2af73.xy) * 2.0) - vec2(1.0));
            }
            else
            {
                var_be267 = var_2af73.xy;
            }
            highp vec3 var_c33fc = var_2af73;
            var_2af73 = vec3(var_be267.x, var_be267.y, var_c33fc.z);
            highp vec2 var_ce9e8 = var_66319.zw;
            var_119a3[var_e1ef0] = (clamp(exp2((dot(normalize(normalize(vec3(var_be267.x, var_be267.y, var_c33fc.z))), var_ecfd1) - 1.0) * LightingUpscaleParams.x), 0.0, 1.0) * (6.1999999161344021558761596679688e-05 / (6.1999999161344021558761596679688e-05 + abs(var_dad33 - (((var_ce9e8.x * 65535.0) + var_ce9e8.y) * 1.525902189314365386962890625e-05))))) * var_a5d57[var_e1ef0];
        }
        highp vec2 var_efdab = var_119a3.xy;
        highp vec2 var_d1a8a = var_119a3.zw;
        highp vec2 var_ab005 = vec2(var_efdab.x + var_efdab.y, var_d1a8a.x + var_d1a8a.y);
        highp vec4 var_76ccc = mix(vec4(var_7fc08[0], var_7fc08[2]), vec4(var_7fc08[1], var_7fc08[3]), mix(vec4(0.0), var_119a3.yyww / var_ab005.xxyy, greaterThan(var_ab005.xxyy, vec4(0.0))));
        highp vec2 var_a039c = var_ab005;
        highp vec2 var_c1b78 = var_ab005 / vec2((var_a039c.x + var_a039c.y) + 6.1999999161344021558761596679688e-05);
        var_84f7f = (texture(s_SpecularLighting, var_76ccc.xy).xyz * var_c1b78.x) + (texture(s_SpecularLighting, var_76ccc.zw).xyz * var_c1b78.y);
#endif
    }
    else
    {
        var_84f7f = vec3(0.0);
    }
    bgfx_FragData0 = vec4(var_84f7f, 1.0);
}
