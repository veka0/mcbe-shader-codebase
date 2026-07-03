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
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler2D s_SunMoonTexture;
* - layout(binding = 7, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 8, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 9, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
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
* - uniform mat4 DirectionalLightSourceCausticsViewProj;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
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
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyProbeUVFadeParameters;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunMoonColor;
* - uniform vec4 SunMoonEmissiveMultiplier;
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
uniform highp sampler2D s_SunMoonTexture;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 SkyProbeUVFadeParameters;
uniform highp vec4 SunMoonColor;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
in highp vec3 v_ndcPosition;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_86892 = texture(s_SunMoonTexture, v_texcoord0);
    highp vec3 var_f733f = (SunMoonColor.xyz * var_86892.xyz) * SunMoonColor.w;
    highp vec3 var_d5208;
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
        highp vec4 var_36b18 = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_ce114.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_ce114.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        var_d5208 = var_f733f * var_36b18.w;
    }
    else
    {
        var_d5208 = var_f733f;
    }
    highp vec2 var_2d4a7 = (v_ndcPosition.xy + vec2(1.0)) * vec2(0.5);
    highp vec3 var_c41e6;
    if (PreExposureEnabled.x > 0.0)
    {
        var_c41e6 = var_d5208 * 0.0033142860047519207000732421875;
    }
    else
    {
        var_c41e6 = var_d5208;
    }
    bgfx_FragColor = vec4(var_c41e6, (clamp(var_2d4a7.y, SkyProbeUVFadeParameters.y, SkyProbeUVFadeParameters.x) - SkyProbeUVFadeParameters.y) / ((SkyProbeUVFadeParameters.x - SkyProbeUVFadeParameters.y) + 9.9999997473787516355514526367188e-06));
}
