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
* - uniform lowp sampler2D s_CausticsTexture;
* - layout(binding = 2, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 3, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform highp sampler2DArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
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
* - uniform vec4 CloudColor;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
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
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowQuantizationParameters;
* - uniform vec4 ShadowSlopeBias;
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

precision mediump float;
precision highp int;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyProbeUVFadeParameters;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
in highp vec4 v_color0;
in highp vec3 v_ndcPosition;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_14f24 = v_color0;
    highp float var_b67e8 = clamp(max((length(v_worldPos) / DistanceControl.x) - 0.89999997615814208984375, 0.0), 0.0, 1.0);
    highp vec3 var_d19b5 = (v_color0.xyz * ((BlockBaseAmbientLightColorIntensity.xyz * BlockBaseAmbientLightColorIntensity.w) + (SkyAmbientLightColorIntensity.xyz * SkyAmbientLightColorIntensity.w))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    highp vec3 var_3613e;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp vec3 var_ed1d8;
        if (var_b67e8 > 0.0)
        {
            highp vec3 var_74b04 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
            highp vec4 var_55369 = SunColor;
            highp vec4 var_812eb = MoonColor;
            highp vec3 var_c9671 = var_74b04;
            highp float var_187a1 = FogSkyBlend.x - FogSkyBlend.w;
            highp float var_68fa9 = smoothstep(FogSkyBlend.y, var_187a1, var_c9671.y);
            highp float var_ed300 = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_187a1, var_c9671.y);
            highp float var_8578e = dot(var_74b04, SunDir.xyz);
            highp float var_58627 = dot(var_74b04, MoonDir.xyz);
            highp float var_8a80c = 0.5 * (var_8578e + 1.0);
            highp float var_816a2 = 0.5 * (var_58627 + 1.0);
            highp float var_9fa03 = clamp(pow(max(var_8578e, 0.0), AtmosphericScattering.w), 0.0, 1.0);
            highp float var_c231c = clamp(pow(max(var_58627, 0.0), AtmosphericScattering.w), 0.0, 1.0);
            var_ed1d8 = mix(var_d19b5, (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_68fa9 * var_68fa9) * var_68fa9, 0.0, 1.0))) * AtmosphericScattering.x) * 0.0596831031143665313720703125) * (((var_8a80c * var_8a80c) * var_55369.w) + ((var_816a2 * var_816a2) * var_812eb.w))) + (((SkyHorizonColor.xyz * clamp((var_ed300 * var_ed300) * var_ed300, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_55369.w) * AtmosphericScattering.y) * var_9fa03) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_9fa03 * 1.7999999523162841796875), 1.5))) + ((((MoonColor.xyz * var_812eb.w) * AtmosphericScattering.z) * var_c231c) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_c231c * 1.7999999523162841796875), 1.5))))), vec3(var_b67e8));
        }
        else
        {
            var_ed1d8 = var_d19b5;
        }
        var_3613e = var_ed1d8;
    }
    else
    {
        var_3613e = mix(var_d19b5, FogColor.xyz, vec3(var_b67e8));
    }
    highp vec3 var_f79a5;
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
        var_f79a5 = var_5363d.xyz + (var_3613e * var_67b96.w);
    }
    else
    {
        var_f79a5 = var_3613e;
    }
    highp vec2 var_f4cf0 = (v_ndcPosition.xy + vec2(1.0)) * vec2(0.5);
    highp vec3 var_44902 = var_f79a5 * ((clamp(var_f4cf0.y, SkyProbeUVFadeParameters.y, SkyProbeUVFadeParameters.x) - SkyProbeUVFadeParameters.y) / ((SkyProbeUVFadeParameters.x - SkyProbeUVFadeParameters.y) + 9.9999997473787516355514526367188e-06));
    highp vec3 var_04dc0;
    if (PreExposureEnabled.x > 0.0)
    {
        var_04dc0 = var_44902 * 0.18010000884532928466796875;
    }
    else
    {
        var_04dc0 = var_44902;
    }
    bgfx_FragColor = vec4(var_04dc0, max(var_14f24.w, SkyProbeUVFadeParameters.z));
}
