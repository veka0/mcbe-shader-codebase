#version 310 es

/*
* Available Macros:
*
* Passes:
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
* - uniform lowp sampler2D s_CausticsTexture;
* - layout(binding = 1, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 2, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_MatTexture;
* - uniform highp sampler2DArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 CascadeShadowResolutions;
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform mat4 CubemapRotation;
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
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowQuantizationParameters;
* - uniform vec4 ShadowSlopeBias;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyProbeUVFadeParameters;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
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
uniform highp sampler2D s_MatTexture;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyProbeUVFadeParameters;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
in highp vec4 v_clipPosition;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_a3e18 = v_clipPosition;
    highp vec4 var_8e462 = v_clipPosition;
    highp vec4 var_1133e = texture(s_MatTexture, v_texcoord0);
    highp vec4 var_b6fe8 = var_1133e;
    highp vec4 var_80032 = vec4(pow(max(var_1133e.xyz, vec3(0.0)), vec3(2.2000000476837158203125)), var_b6fe8.w);
    highp vec4 var_2ee7a = var_80032;
    highp vec3 var_33407 = (var_80032.xyz * ((BlockBaseAmbientLightColorIntensity.xyz * BlockBaseAmbientLightColorIntensity.w) + (SkyAmbientLightColorIntensity.xyz * SkyAmbientLightColorIntensity.w))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    highp vec3 var_f79a5;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec3 var_8ed55 = v_clipPosition.xyz / vec3(var_8e462.w);
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_8ed55.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_8ed55, 1.0);
        highp float var_b4ccc = var_7d045.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_b4ccc, var_7d045.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_eb2d5 = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_5363d = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        highp vec4 var_67b96 = var_5363d;
        var_f79a5 = var_5363d.xyz + (var_33407 * var_67b96.w);
    }
    else
    {
        var_f79a5 = var_33407;
    }
    highp vec2 var_ae031 = ((v_clipPosition.xyz / vec3(var_a3e18.w)).xy + vec2(1.0)) * vec2(0.5);
    highp vec3 var_44902 = var_f79a5 * ((clamp(var_ae031.y, SkyProbeUVFadeParameters.y, SkyProbeUVFadeParameters.x) - SkyProbeUVFadeParameters.y) / ((SkyProbeUVFadeParameters.x - SkyProbeUVFadeParameters.y) + 9.9999997473787516355514526367188e-06));
    highp vec3 var_04dc0;
    if (PreExposureEnabled.x > 0.0)
    {
        var_04dc0 = var_44902 * 0.18010000884532928466796875;
    }
    else
    {
        var_04dc0 = var_44902;
    }
    bgfx_FragColor = vec4(var_04dc0, max(var_2ee7a.w, SkyProbeUVFadeParameters.z));
}
