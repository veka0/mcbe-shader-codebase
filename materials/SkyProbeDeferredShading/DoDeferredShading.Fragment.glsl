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
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SSRTexture;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
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
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowPrecisionRoundingParameters;
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

precision mediump float;
precision highp int;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_EmissiveAmbientLinearRoughness;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 CurrentFace;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyProbeUVFadeParameters;
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
    highp vec4 var_38911 = vec4(0.0);
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
    highp vec4 var_b54ab = var_9666f / vec4(var_d799e);
    var_df846 = var_b54ab;
    highp vec4 var_27860 = texture(s_ColorMetalnessSubsurface, v_texcoord0);
    highp vec4 var_7ca96 = texture(s_EmissiveAmbientLinearRoughness, v_texcoord0);
    highp vec3 var_900f6 = vec3(v_projPosition.xy, var_971b7);
    highp vec3 var_57395 = pow(max(var_27860.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
    highp vec3 var_867bd = ((mix(var_57395, vec3(dot(var_57395, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_7ca96.x)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x;
    highp float var_fc381 = length(var_b54ab.xyz);
    highp vec3 var_4323b = normalize((u_invView * vec4(var_b54ab.xyz, 1.0)).xyz - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
    if (var_4323b.y < 0.100000001490116119384765625)
    {
        var_4323b.y = 0.100000001490116119384765625;
        var_4323b = normalize(var_4323b);
    }
    highp vec3 var_7e3dc;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_3de5f = clamp((((var_fc381 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_cb5ed;
        if (var_3de5f > 0.0)
        {
            highp vec3 var_08c70;
            if (!(AtmosphericScatteringToggles.y != 0.0))
            {
                var_08c70 = FogColor.xyz;
            }
            else
            {
                highp vec4 var_86047 = SunColor;
                highp vec4 var_e0810 = MoonColor;
                highp vec3 var_e3755 = var_4323b;
                highp float var_7b136 = FogSkyBlend.x - FogSkyBlend.w;
                highp float var_7213f = smoothstep(FogSkyBlend.y, var_7b136, var_e3755.y);
                highp float var_7160a = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_7b136, var_e3755.y);
                highp float var_c861e = dot(var_4323b, SunDir.xyz);
                highp float var_78c21 = dot(var_4323b, MoonDir.xyz);
                highp float var_7a7df = clamp(pow(max(var_c861e, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_a2190 = clamp(pow(max(var_78c21, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                var_08c70 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_7213f * var_7213f) * var_7213f, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_86047.w * (0.75 * ((var_c861e * var_c861e) + 1.0))) + (var_e0810.w * (0.75 * ((var_78c21 * var_78c21) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_7160a * var_7160a) * var_7160a, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_86047.w) * AtmosphericScattering.y) * var_7a7df) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_7a7df * 1.7999999523162841796875), 1.5))) + ((((MoonColor.xyz * var_e0810.w) * AtmosphericScattering.z) * var_a2190) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_a2190 * 1.7999999523162841796875), 1.5)))));
            }
            var_cb5ed = mix(var_867bd, var_08c70, vec3(var_3de5f));
        }
        else
        {
            var_cb5ed = var_867bd;
        }
        var_7e3dc = var_cb5ed;
    }
    else
    {
        var_7e3dc = mix(var_867bd, FogColor.xyz, vec3(clamp((((var_fc381 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0)));
    }
    highp vec3 var_6ea28;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_900f6.xy + vec2(1.0)) * 0.5;
        highp vec4 var_cf4b5 = u_invProj * vec4(v_projPosition.xy, var_971b7, 1.0);
        highp float var_b4ccc = var_7d045.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_b4ccc, var_7d045.y, log((53.598148345947265625 * ((((-var_cf4b5.z) / var_cf4b5.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_eb2d5 = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_5363d = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        highp vec4 var_67b96 = var_5363d;
        var_6ea28 = var_5363d.xyz + (var_7e3dc * var_67b96.w);
    }
    else
    {
        var_6ea28 = var_7e3dc;
    }
    highp vec3 var_1177a;
    if (CurrentFace.x == 3.0)
    {
        var_1177a = var_6ea28 * SkyProbeUVFadeParameters.w;
    }
    else
    {
        highp vec3 var_4163f;
        if (CurrentFace.x != 2.0)
        {
            highp vec2 var_d8e87 = (var_900f6.xy + vec2(1.0)) * vec2(0.5);
            var_4163f = var_6ea28 * max((clamp(var_d8e87.y, SkyProbeUVFadeParameters.y, SkyProbeUVFadeParameters.x) - SkyProbeUVFadeParameters.y) / ((SkyProbeUVFadeParameters.x - SkyProbeUVFadeParameters.y) + 9.9999997473787516355514526367188e-06), SkyProbeUVFadeParameters.w);
        }
        else
        {
            var_4163f = var_6ea28;
        }
        var_1177a = var_4163f;
    }
    highp vec3 var_52fa8;
    if (PreExposureEnabled.x > 0.0)
    {
        var_52fa8 = var_1177a * 0.18010000884532928466796875;
    }
    else
    {
        var_52fa8 = var_1177a;
    }
    var_38911 = vec4(var_52fa8.x, var_52fa8.y, var_52fa8.z, var_38911.w);
    var_38911.w = 1.0;
    bgfx_FragColor = var_38911;
}
