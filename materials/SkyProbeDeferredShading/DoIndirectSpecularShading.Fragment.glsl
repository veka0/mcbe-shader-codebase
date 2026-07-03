#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_DEFERRED_SHADING_PASS (not used)
* - DO_INDIRECT_SPECULAR_SHADING_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2D s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
* - layout(binding = 4, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 5, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform highp sampler2DArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SSRTexture;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
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
* - uniform mat4 CloudShadowProj;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 CurrentFace;
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
* - uniform vec4 FogSkyBlend;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SSRParameters;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowQuantizationParameters;
* - uniform vec4 ShadowSlopeBias;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyProbeUVFadeParameters;
* - uniform vec4 SkyZenithColor;
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

#extension GL_EXT_texture_cube_map_array : require
precision mediump float;
precision highp int;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_EmissiveAmbientLinearRoughness;
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SSRTexture;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 LastSpecularIBLIdx;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 SSRParameters;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
in highp vec3 v_projPosition;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
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
    highp vec4 var_20845 = var_9666f / vec4(var_d799e);
    var_df846 = var_20845;
    highp vec4 var_158bd = texture(s_Normal, v_texcoord0);
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
    highp vec3 var_d5028 = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_7c5f0 = normalize((u_view * vec4(var_d5028, 0.0)).xyz);
    highp vec4 var_124e5 = texture(s_ColorMetalnessSubsurface, v_texcoord0);
    highp vec4 var_ee5ba = var_124e5;
    highp float var_abeca = clamp(2.007874011993408203125 * (var_ee5ba.w - 0.501960813999176025390625), 0.0, 1.0);
    highp vec4 var_02c37 = texture(s_EmissiveAmbientLinearRoughness, v_texcoord0);
    highp vec3 var_799e1 = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_47a9e = var_20845.xyz;
    highp vec3 var_9c3d8 = vec3(v_projPosition.xy, var_971b7);
    highp vec3 var_0cc6d = pow(max(var_124e5.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
    highp float var_98f9c;
    if (PreExposureEnabled.x > 0.0)
    {
        var_98f9c = texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x;
    }
    else
    {
        var_98f9c = 0.0;
    }
    highp float var_26841 = pow(clamp(((var_02c37.z * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0), 3.0) * IBLParameters.x;
    highp vec3 var_3770a;
    if (SSRParameters.x != 0.0)
    {
        bool var_46a60 = PreExposureEnabled.x > 0.0;
        highp vec4 var_7426a = texture(s_SSRTexture, (var_9c3d8.xy + vec2(1.0)) * 0.5);
        if (var_46a60)
        {
            highp vec3 var_16a11 = var_7426a.xyz / vec3(0.180000007152557373046875 / var_98f9c);
            var_7426a = vec4(var_16a11.x, var_16a11.y, var_16a11.z, var_7426a.w);
        }
        highp vec3 var_a5d2d = reflect(normalize(var_799e1 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_d5028);
        bool var_fb1b0 = abs(var_a5d2d.y) > abs(var_a5d2d.x);
        bool var_50203;
        if (var_fb1b0)
        {
            var_50203 = abs(var_a5d2d.y) > abs(var_a5d2d.z);
        }
        else
        {
            var_50203 = var_fb1b0;
        }
        if (var_50203)
        {
            var_a5d2d.z *= (-1.0);
        }
        else
        {
            var_a5d2d.y *= (-1.0);
        }
        highp float var_f6d0e = 1.0 - var_02c37.w;
        highp float var_59d83 = (1.0 - (var_f6d0e * var_f6d0e)) * (IBLParameters.y - 1.0);
        int var_ae27f = int(LastSpecularIBLIdx.x);
        highp vec3 var_77c01 = mix(textureLod(s_SpecularIBLRecords, vec4(var_a5d2d, float((var_ae27f + 2) % 3)), var_59d83).xyz, textureLod(s_SpecularIBLRecords, vec4(var_a5d2d, float(var_ae27f)), var_59d83).xyz, vec3(IBLParameters.w));
        highp vec3 var_64a68;
        if (var_46a60)
        {
            var_64a68 = var_77c01 * vec3(5.5555553436279296875);
        }
        else
        {
            var_64a68 = var_77c01;
        }
        highp vec2 var_f1b8d = texture(s_BrdfLUT, vec2(clamp(dot(var_7c5f0, -(var_47a9e / vec3(length(var_47a9e)))), 0.0, 1.0), var_02c37.w)).xy;
        var_3770a = mix((var_64a68 * var_26841) * IBLParameters.z, var_7426a.xyz, vec3(var_7426a.w * SSRParameters.y)) * (((vec3(0.039999999105930328369140625 * (1.0 - var_abeca)) + (var_0cc6d * var_abeca)) * var_f1b8d.x) + vec3(var_f1b8d.y));
    }
    else
    {
        highp vec3 var_ac39a = reflect(normalize(var_799e1 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_d5028);
        bool var_57456 = abs(var_ac39a.y) > abs(var_ac39a.x);
        bool var_beb3c;
        if (var_57456)
        {
            var_beb3c = abs(var_ac39a.y) > abs(var_ac39a.z);
        }
        else
        {
            var_beb3c = var_57456;
        }
        if (var_beb3c)
        {
            var_ac39a.z *= (-1.0);
        }
        else
        {
            var_ac39a.y *= (-1.0);
        }
        highp float var_8de02 = 1.0 - var_02c37.w;
        highp float var_094f2 = (1.0 - (var_8de02 * var_8de02)) * (IBLParameters.y - 1.0);
        int var_d35cf = int(LastSpecularIBLIdx.x);
        highp vec3 var_593b6 = mix(textureLod(s_SpecularIBLRecords, vec4(var_ac39a, float((var_d35cf + 2) % 3)), var_094f2).xyz, textureLod(s_SpecularIBLRecords, vec4(var_ac39a, float(var_d35cf)), var_094f2).xyz, vec3(IBLParameters.w));
        highp vec3 var_c0a13;
        if (PreExposureEnabled.x > 0.0)
        {
            var_c0a13 = var_593b6 * vec3(5.5555553436279296875);
        }
        else
        {
            var_c0a13 = var_593b6;
        }
        highp vec2 var_c35ed = texture(s_BrdfLUT, vec2(clamp(dot(var_7c5f0, -(var_47a9e / vec3(length(var_47a9e)))), 0.0, 1.0), var_02c37.w)).xy;
        var_3770a = ((var_c0a13 * var_26841) * IBLParameters.z) * (((vec3(0.039999999105930328369140625 * (1.0 - var_abeca)) + (var_0cc6d * var_abeca)) * var_c35ed.x) + vec3(var_c35ed.y));
    }
    highp float var_e6705 = length(var_47a9e);
    highp vec3 var_51636;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        var_51636 = var_3770a * (1.0 - clamp((((var_e6705 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0));
    }
    else
    {
        var_51636 = var_3770a * (1.0 - clamp((((var_e6705 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    }
    highp vec3 var_aebff;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_9c3d8.xy + vec2(1.0)) * 0.5;
        highp vec4 var_cf4b5 = u_invProj * vec4(v_projPosition.xy, var_971b7, 1.0);
        highp float var_b4ccc = var_7d045.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_b4ccc, var_7d045.y, log((53.598148345947265625 * ((((-var_cf4b5.z) / var_cf4b5.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_eb2d5 = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_36b18 = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        var_aebff = var_51636 * var_36b18.w;
    }
    else
    {
        var_aebff = var_51636;
    }
    highp vec3 var_bff62;
    if (PreExposureEnabled.x > 0.0)
    {
        var_bff62 = var_aebff * (0.180000007152557373046875 / var_98f9c);
    }
    else
    {
        var_bff62 = var_aebff;
    }
    bgfx_FragColor = vec4(var_bff62, 1.0);
}
