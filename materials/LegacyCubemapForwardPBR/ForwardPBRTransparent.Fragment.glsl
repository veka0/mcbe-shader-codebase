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
* - uniform lowp sampler2D s_MatTexture;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - layout(binding = 7, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 8, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 CloudRenderDistanceAndCloudHeight;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 CloudShadowsVisible;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform mat4 CubemapRotation;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform vec4 PointLightPreCalcValues;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyProbeUVFadeParameters;
* - uniform vec4 SkySamplesConfig;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SkyboxAmbientIlluminance;
* - uniform vec4 SkyboxParameters;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 Time;
* - uniform vec4 UndergroundFogColor;
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
uniform highp mat4 u_invView;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler3D s_SkyAmbientSamples;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 CloudRenderDistanceAndCloudHeight;
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkySamplesConfig;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SkyboxAmbientIlluminance;
uniform highp vec4 SkyboxParameters;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WorldOrigin;
in highp vec4 v_clipPosition;
in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragColor;
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
    highp vec4 var_8e462 = v_clipPosition;
    highp vec3 var_49620 = v_worldPos;
    highp vec4 var_fe390 = texture(s_MatTexture, v_texcoord0);
    highp vec4 var_ab9d7 = var_fe390;
    highp vec3 var_9e11a = var_fe390.xyz;
    highp vec3 var_a32a9;
    func_9b87e(var_a32a9, var_9e11a);
    highp vec4 var_53298 = vec4(var_a32a9, var_ab9d7.w);
    highp vec4 var_da3c1 = var_53298;
    highp vec4 var_f096f = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp vec3 var_057de = (((var_53298.xyz * AmbientLightParams.xyz) * SkyboxAmbientIlluminance.x) + (((var_53298.xyz * (SkyAmbientLightColorIntensity.xyz * SkyAmbientLightColorIntensity.w)) * SkyboxParameters.x) * DiffuseSpecularEmissiveAmbientTermToggles.w)) + ((var_53298.xyz * ((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * var_f096f.w) * SkyboxParameters.y)) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight.x);
    bool var_78d96 = SkyboxParameters.z != 0.0;
    bool var_0abf2;
    if (var_78d96)
    {
        var_0abf2 = AtmosphericScatteringToggles.x != 0.0;
    }
    else
    {
        var_0abf2 = var_78d96;
    }
    highp vec3 var_663b7;
    if (var_0abf2)
    {
        highp vec3 var_240fa = v_worldPos * ((CloudRenderDistanceAndCloudHeight.y + WorldOrigin.y) / (var_49620.y + 9.9999997473787516355514526367188e-05));
        highp float var_4ae8a = clamp(max((length(var_240fa) / CloudRenderDistanceAndCloudHeight.x) - 0.89999997615814208984375, 0.0), 0.0, 1.0);
        highp vec3 var_a4d0b;
        if (var_4ae8a > 0.0)
        {
            highp vec3 var_b4e6e = normalize(var_240fa - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
            highp vec4 var_74a4d = SunColor;
            highp vec4 var_7394f = MoonColor;
            highp vec3 var_da3ac = var_b4e6e;
            highp float var_e4090 = smoothstep(FogSkyBlend.z - FogSkyBlend.w, FogSkyBlend.x - FogSkyBlend.w, var_da3ac.y);
            highp float var_26eb8 = dot(var_b4e6e, SunDir.xyz);
            highp float var_20cb8 = dot(var_b4e6e, MoonDir.xyz);
            highp vec3 var_4b789 = var_b4e6e;
            highp float var_03e2a = smoothstep(FogSkyBlend.y, FogSkyBlend.x - FogSkyBlend.w, var_4b789.y);
            highp float var_792bc = clamp(pow(max(var_26eb8, 0.0), AtmosphericScattering.w), 0.0, 1.0);
            highp float var_467d6 = clamp(pow(max(var_20cb8, 0.0), AtmosphericScattering.w), 0.0, 1.0);
            highp float var_0ec04 = 1.809999942779541015625 - (var_792bc * 1.7999999523162841796875);
            highp float var_dd032 = 1.809999942779541015625 - (var_467d6 * 1.7999999523162841796875);
            highp vec3 var_493ac = mix(var_057de, (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_03e2a * var_03e2a) * var_03e2a, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_74a4d.w * (0.75 * ((var_26eb8 * var_26eb8) + 1.0))) + (var_7394f.w * (0.75 * ((var_20cb8 * var_20cb8) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_e4090 * var_e4090) * var_e4090, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_74a4d.w) * AtmosphericScattering.y) * var_792bc) * (0.0361000001430511474609375 / (var_0ec04 * sqrt(var_0ec04)))) + ((((MoonColor.xyz * var_7394f.w) * AtmosphericScattering.z) * var_467d6) * (0.0361000001430511474609375 / (var_dd032 * sqrt(var_dd032)))))), vec3(var_4ae8a));
            var_a4d0b = var_493ac;
        }
        else
        {
            var_a4d0b = var_057de;
        }
        var_663b7 = var_a4d0b;
    }
    else
    {
        var_663b7 = var_057de;
    }
    bool var_08c3b = SkyboxParameters.w != 0.0;
    bool var_ebbe3;
    if (var_08c3b)
    {
        var_ebbe3 = VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0;
    }
    else
    {
        var_ebbe3 = var_08c3b;
    }
    highp vec3 var_e7e0a;
    highp vec3 var_2c946;
    if (var_ebbe3)
    {
        highp vec3 var_8ed55 = v_clipPosition.xyz / vec3(var_8e462.w);
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_8ed55.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_8ed55, 1.0);
        highp float var_b4ccc = var_7d045.x;
        highp vec3 var_2d7e6 = vec3(var_b4ccc, var_7d045.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_203f7 = var_2d7e6;
        highp float var_eb2d5 = (var_203f7.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_5363d = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        highp vec4 var_67b96 = var_5363d;
        var_2c946 = var_5363d.xyz + (var_663b7 * var_67b96.w);
        var_e7e0a = var_2d7e6;
    }
    else
    {
        var_2c946 = var_663b7;
        var_e7e0a = vec3(0.0);
    }
    highp vec3 var_a871a = var_e7e0a;
    bool var_0db97;
    func_2be34(var_a871a, var_0db97);
    highp float var_39bcb;
    highp vec3 var_8d985;
    if (!var_0db97)
    {
        var_8d985 = vec3(0.0);
        var_39bcb = 0.0;
    }
    else
    {
        var_8d985 = var_2c946;
        var_39bcb = var_da3c1.w;
    }
    highp vec3 var_ac41d;
    if (PreExposureEnabled.x > 0.0)
    {
        var_ac41d = var_8d985 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_ac41d = var_8d985;
    }
    bgfx_FragColor = vec4(var_ac41d, var_39bcb);
}
