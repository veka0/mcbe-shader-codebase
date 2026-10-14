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
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 5, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - layout(binding = 6, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
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
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyProbeUVFadeParameters;
* - uniform vec4 SkySamplesConfig;
* - uniform vec4 StarsColor;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 Time;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterAlbedoExtinction;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WorldOrigin;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_invProj;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler3D s_SkyAmbientSamples;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 SkyProbeUVFadeParameters;
uniform highp vec4 SkySamplesConfig;
uniform highp vec4 StarsColor;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
in highp vec4 v_color0;
in highp vec3 v_ndcPosition;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_2be34(inout highp vec3 arg_9f7bb, inout bool arg_13a99) {
    if (SkySamplesConfig.x > 0.5)
    {
        arg_9f7bb.y = 1.0 - arg_9f7bb.y;
        arg_9f7bb.z -= SkySamplesConfig.z;
        arg_9f7bb.z = (exp(4.0 * arg_9f7bb.z) - 1.0) * 0.0186573602259159088134765625;
        highp vec2 loc_d121e = textureLod(s_SkyAmbientSamples, arg_9f7bb, 0.0).xy;
        if (loc_d121e.y < SkySamplesConfig.w)
        {
            arg_13a99 = false;
            return;
        }
    }
    arg_13a99 = true;
}
void main() {
    highp vec3 var_5f8a1 = v_color0.xyz * (StarsColor.xyz * v_color0.w);
    highp vec3 var_625a3;
    highp vec3 var_e7e0a;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_ce114 = (v_ndcPosition.xy + vec2(1.0)) * 0.5;
        highp vec4 var_196b0 = u_invProj * vec4(v_ndcPosition, 1.0);
        highp float var_b4ccc = var_ce114.x;
        highp vec3 var_2d7e6 = vec3(var_b4ccc, var_ce114.y, log((53.598148345947265625 * ((((-var_196b0.z) / var_196b0.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_203f7 = var_2d7e6;
        highp float var_eb2d5 = (var_203f7.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_36b18 = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_ce114.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_ce114.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        var_e7e0a = var_2d7e6;
        var_625a3 = var_5f8a1 * var_36b18.w;
    }
    else
    {
        var_e7e0a = vec3(0.0);
        var_625a3 = var_5f8a1;
    }
    highp vec4 var_ea877 = vec4(var_625a3, v_color0.w);
    highp vec3 var_a871a = var_e7e0a;
    bool var_0db97;
    func_2be34(var_a871a, var_0db97);
    highp vec4 var_11f30 = var_ea877;
    highp vec2 var_23dcb = (v_ndcPosition.xy + vec2(1.0)) * vec2(0.5);
    highp vec3 var_4c4dd = var_ea877.xyz * ((clamp(var_23dcb.y, SkyProbeUVFadeParameters.y, SkyProbeUVFadeParameters.x) - SkyProbeUVFadeParameters.y) / ((SkyProbeUVFadeParameters.x - SkyProbeUVFadeParameters.y) + 9.9999997473787516355514526367188e-06));
    var_11f30.x = var_4c4dd.x;
    var_11f30.y = var_4c4dd.y;
    var_11f30.z = var_4c4dd.z;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec4 var_245a0 = var_11f30;
        highp vec3 var_6899b = var_245a0.xyz * 0.0033142860047519207000732421875;
        var_11f30.x = var_6899b.x;
        var_11f30.y = var_6899b.y;
        var_11f30.z = var_6899b.z;
    }
    highp float var_2737a;
    highp vec3 var_6ae7d;
    if (!var_0db97)
    {
        var_6ae7d = vec3(0.0);
        var_2737a = 0.0;
    }
    else
    {
        var_6ae7d = var_11f30.xyz;
        var_2737a = var_11f30.w;
    }
    bgfx_FragData0 = vec4(var_6ae7d, var_2737a);
}
