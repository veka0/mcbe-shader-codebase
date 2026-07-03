#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* FlipOcclusion:
* - FLIP_OCCLUSION__OFF
* - FLIP_OCCLUSION__ON
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* NoOcclusion:
* - NO_OCCLUSION__OFF
* - NO_OCCLUSION__ON
*
* NoVariety:
* - NO_VARIETY__OFF (not used)
* - NO_VARIETY__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2D s_CausticsTexture;
* - layout(binding = 2, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - uniform lowp sampler2D s_LightingTexture;
* - layout(binding = 4, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_OcclusionTexture;
* - uniform highp sampler2DArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - uniform lowp sampler2D s_WeatherTexture;
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
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 Dimensions;
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
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 OcclusionHeightOffset;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PositionBaseOffset;
* - uniform vec4 PositionForwardOffset;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowQuantizationParameters;
* - uniform vec4 ShadowSlopeBias;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 Time;
* - uniform vec4 UVOffsetAndScale;
* - uniform vec4 Velocity;
* - uniform vec4 ViewPosition;
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
uniform highp mat4 u_model[4];
uniform highp mat4 u_view;
uniform highp sampler2D s_OcclusionTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_WeatherTexture;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform highp vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 OcclusionHeightOffset;
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
in highp vec3 v_ndcPosition;
in highp float v_occlusionHeight;
in highp vec2 v_occlusionUV;
in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragColor;
float var_69f75;
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
void func_7355d(inout highp vec2 arg_f694b) {
    highp vec4 loc_175e8 = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_7116a = loc_175e8.x;
    highp float loc_2c54e = (loc_175e8.y + (loc_175e8.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125);
    bool loc_47b39 = v_occlusionUV.x >= 0.0;
    bool loc_77737;
    if (loc_47b39)
    {
        loc_77737 = v_occlusionUV.x <= 1.0;
    }
    else
    {
        loc_77737 = loc_47b39;
    }
    bool loc_8f253;
    if (loc_77737)
    {
        loc_8f253 = v_occlusionUV.y >= 0.0;
    }
    else
    {
        loc_8f253 = loc_77737;
    }
    bool loc_1a0b7;
    if (loc_8f253)
    {
        loc_1a0b7 = v_occlusionUV.y <= 1.0;
    }
    else
    {
        loc_1a0b7 = loc_8f253;
    }
    if (loc_1a0b7 && (v_occlusionHeight < loc_2c54e))
    {
        arg_f694b = vec2(0.0);
        return;
    }
    else
    {
        arg_f694b = vec2(loc_7116a - (((v_occlusionHeight - loc_2c54e) * 25.0) * loc_7116a), 1.0);
        return;
    }
}
#endif
#ifdef NO_OCCLUSION__ON
void func_2e092(inout highp vec2 arg_003d1) {
    highp vec4 loc_6e6a0 = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_a92e4 = loc_6e6a0.x;
    arg_003d1 = vec2(loc_a92e4 - (((v_occlusionHeight - ((loc_6e6a0.y + (loc_6e6a0.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125))) * 25.0) * loc_a92e4), 1.0);
}
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
void func_195f6(inout highp vec2 arg_f694b) {
    highp vec4 loc_175e8 = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_7116a = loc_175e8.x;
    highp float loc_c2c30 = (loc_175e8.y + (loc_175e8.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125);
    bool loc_47b39 = v_occlusionUV.x >= 0.0;
    bool loc_77737;
    if (loc_47b39)
    {
        loc_77737 = v_occlusionUV.x <= 1.0;
    }
    else
    {
        loc_77737 = loc_47b39;
    }
    bool loc_8f253;
    if (loc_77737)
    {
        loc_8f253 = v_occlusionUV.y >= 0.0;
    }
    else
    {
        loc_8f253 = loc_77737;
    }
    bool loc_65342;
    if (loc_8f253)
    {
        loc_65342 = v_occlusionUV.y <= 1.0;
    }
    else
    {
        loc_65342 = loc_8f253;
    }
    if (loc_65342 && (v_occlusionHeight > loc_c2c30))
    {
        arg_f694b = vec2(0.0);
        return;
    }
    else
    {
        arg_f694b = vec2(loc_7116a - (((v_occlusionHeight - loc_c2c30) * 25.0) * loc_7116a), 1.0);
        return;
    }
}
#endif
void main() {
#ifdef NO_OCCLUSION__OFF
    highp vec4 var_4d4a7 = texture(s_WeatherTexture, v_texcoord0);
#endif
    highp vec2 var_3c0b9;
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
    func_7355d(var_3c0b9);
#endif
#ifdef NO_OCCLUSION__ON
    highp vec4 var_4d4a7 = texture(s_WeatherTexture, v_texcoord0);
    func_2e092(var_3c0b9);
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
    func_195f6(var_3c0b9);
#endif
    highp vec2 var_5d463 = var_3c0b9;
    highp vec4 var_39efd = var_4d4a7;
    int var_bf766 = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    highp vec3 var_00836;
    var_00836 = vec3(0.0);
    highp vec3 var_f4eea;
    for (int var_66b3c = 0; var_66b3c < var_bf766; var_00836 = var_f4eea, var_66b3c++)
    {
        highp vec4 var_634ee = DirectionalLightSourceDiffuseColorAndIlluminance[var_66b3c];
        var_f4eea = var_00836 + ((((var_39efd.xyz * vec3(0.3183098733425140380859375)) * DiffuseSpecularEmissiveAmbientTermToggles.x) * ((DirectionalLightSourceDiffuseColorAndIlluminance[var_66b3c].xyz * var_634ee.w) * 1.0)) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x);
    }
    highp vec2 var_d56f2 = var_3c0b9;
    highp vec4 var_a7841 = var_4d4a7;
    highp vec4 var_50ba0 = vec4(1.0);
    highp vec4 var_94a19 = SkyAmbientLightColorIntensity;
    highp float var_b3135 = var_d56f2.x * var_d56f2.x;
    highp vec3 var_c296e = (var_00836 * var_39efd.xyz) + (max(((clamp(vec3(var_b3135 + (var_50ba0.x * var_50ba0.w), (var_b3135 * ((((var_b3135 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_50ba0.y * var_50ba0.w), (var_b3135 * (((var_b3135 * var_b3135) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_50ba0.z * var_50ba0.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * 1.0) + ((SkyAmbientLightColorIntensity.xyz * pow(var_d56f2.y, mix(5.0, 3.0, CameraLightIntensity.y))) * var_94a19.w), vec3(0.02999999932944774627685546875)) * var_a7841.xyz);
    var_4d4a7 = vec4(var_c296e.x, var_c296e.y, var_c296e.z, var_a7841.w);
    highp vec3 var_6873b = var_c296e.xyz;
    highp float var_d9c9d = length(u_view * (u_model[0] * vec4(v_worldPos, 1.0)));
    highp vec3 var_95db2 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
    highp vec3 var_7e3dc;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_3de5f = clamp((((var_d9c9d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_cb5ed;
        if (var_3de5f > 0.0)
        {
            highp vec3 var_a6488;
            if (!(AtmosphericScatteringToggles.y != 0.0))
            {
                var_a6488 = FogColor.xyz;
            }
            else
            {
                highp vec4 var_da187 = SunColor;
                highp vec4 var_9cde9 = MoonColor;
                highp vec3 var_e3755 = var_95db2;
                highp float var_7b136 = FogSkyBlend.x - FogSkyBlend.w;
                highp float var_d7734 = smoothstep(FogSkyBlend.y, var_7b136, var_e3755.y);
                highp float var_3c557 = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_7b136, var_e3755.y);
                highp float var_50871 = dot(var_95db2, SunDir.xyz);
                highp float var_ae018 = dot(var_95db2, MoonDir.xyz);
                highp float var_5301e = 0.5 * (var_50871 + 1.0);
                highp float var_9a714 = 0.5 * (var_ae018 + 1.0);
                highp float var_4e792 = clamp(pow(max(var_50871, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_72556 = clamp(pow(max(var_ae018, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                var_a6488 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_d7734 * var_d7734) * var_d7734, 0.0, 1.0))) * AtmosphericScattering.x) * 0.0596831031143665313720703125) * (((var_5301e * var_5301e) * var_da187.w) + ((var_9a714 * var_9a714) * var_9cde9.w))) + (((SkyHorizonColor.xyz * clamp((var_3c557 * var_3c557) * var_3c557, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_da187.w) * AtmosphericScattering.y) * var_4e792) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_4e792 * 1.7999999523162841796875), 1.5))) + ((((MoonColor.xyz * var_9cde9.w) * AtmosphericScattering.z) * var_72556) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_72556 * 1.7999999523162841796875), 1.5)))));
            }
            var_cb5ed = mix(var_6873b, var_a6488, vec3(var_3de5f));
        }
        else
        {
            var_cb5ed = var_6873b;
        }
        var_7e3dc = var_cb5ed;
    }
    else
    {
        var_7e3dc = mix(var_6873b, FogColor.xyz, vec3(clamp((((var_d9c9d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0)));
    }
    highp vec3 var_15d6e;
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
        var_15d6e = var_5363d.xyz + (var_7e3dc * var_67b96.w);
    }
    else
    {
        var_15d6e = var_7e3dc;
    }
    highp vec3 var_907b1;
    if (PreExposureEnabled.x > 0.0)
    {
        var_907b1 = var_15d6e * (0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x);
    }
    else
    {
        var_907b1 = var_15d6e;
    }
    bgfx_FragColor = vec4(var_907b1.x, var_907b1.y, var_907b1.z, vec4(var_69f75, var_69f75, var_69f75, var_4d4a7.w * var_5d463.y).w);
}
