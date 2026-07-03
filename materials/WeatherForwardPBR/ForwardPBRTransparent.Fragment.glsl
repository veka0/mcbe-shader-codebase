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
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - uniform lowp sampler2D s_WeatherTexture;
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
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 Dimensions;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
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
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowPrecisionRoundingParameters;
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
uniform highp vec4 AmbientLightParams;
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
    highp vec4 var_fbc8d = var_4d4a7;
    int var_bf766 = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    highp vec3 var_5ea60;
    var_5ea60 = vec3(0.0);
    highp vec3 var_f4eea;
    for (int var_66b3c = 0; var_66b3c < var_bf766; var_5ea60 = var_f4eea, var_66b3c++)
    {
        highp vec4 var_634ee = DirectionalLightSourceDiffuseColorAndIlluminance[var_66b3c];
        var_f4eea = var_5ea60 + ((((var_fbc8d.xyz * vec3(0.3183098733425140380859375)) * DiffuseSpecularEmissiveAmbientTermToggles.x) * ((DirectionalLightSourceDiffuseColorAndIlluminance[var_66b3c].xyz * var_634ee.w) * 1.0)) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x);
    }
    highp vec2 var_34b44 = var_3c0b9;
    highp vec4 var_72ee5 = var_4d4a7;
    highp vec4 var_d6689 = vec4(1.0);
    highp float var_8c94b = var_34b44.x * var_34b44.x;
    highp vec4 var_44bfc = SkyAmbientLightColorIntensity;
    highp float var_55200 = var_34b44.y * var_34b44.y;
    highp vec3 var_22085 = (var_5ea60 * var_fbc8d.xyz) + (max(((clamp(vec3(var_8c94b + (var_d6689.x * var_d6689.w), (var_8c94b * ((((var_8c94b * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_d6689.y * var_d6689.w), (var_8c94b * (((var_8c94b * var_8c94b) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_d6689.z * var_d6689.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * 1.0) + ((SkyAmbientLightColorIntensity.xyz * mix((var_55200 * var_55200) * var_34b44.y, (var_34b44.y * var_34b44.y) * var_34b44.y, CameraLightIntensity.y)) * var_44bfc.w), AmbientLightParams.xyz * AmbientLightParams.w) * var_72ee5.xyz);
    var_4d4a7 = vec4(var_22085.x, var_22085.y, var_22085.z, var_72ee5.w);
    highp vec3 var_95db2 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_f56f7 = clamp((((length(u_view * (u_model[0] * vec4(v_worldPos, 1.0))) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_f56f7 > 0.0)
        {
            highp vec3 var_35c65;
            if (!(AtmosphericScatteringToggles.y != 0.0))
            {
                var_35c65 = FogColor.xyz;
            }
            else
            {
                highp vec4 var_52ab1 = SunColor;
                highp vec4 var_c9ec4 = MoonColor;
                highp vec3 var_e3755 = var_95db2;
                highp float var_7b136 = FogSkyBlend.x - FogSkyBlend.w;
                highp float var_e285c = smoothstep(FogSkyBlend.y, var_7b136, var_e3755.y);
                highp float var_2ea2e = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_7b136, var_e3755.y);
                highp float var_ec0d7 = dot(var_95db2, SunDir.xyz);
                highp float var_f7518 = dot(var_95db2, MoonDir.xyz);
                highp float var_ae688 = clamp(pow(max(var_ec0d7, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_a74b4 = clamp(pow(max(var_f7518, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_6773c = 1.809999942779541015625 - (var_ae688 * 1.7999999523162841796875);
                highp float var_fed1e = 1.809999942779541015625 - (var_a74b4 * 1.7999999523162841796875);
                var_35c65 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_e285c * var_e285c) * var_e285c, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_52ab1.w * (0.75 * ((var_ec0d7 * var_ec0d7) + 1.0))) + (var_c9ec4.w * (0.75 * ((var_f7518 * var_f7518) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_2ea2e * var_2ea2e) * var_2ea2e, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_52ab1.w) * AtmosphericScattering.y) * var_ae688) * (0.0361000001430511474609375 / (var_6773c * sqrt(var_6773c)))) + ((((MoonColor.xyz * var_c9ec4.w) * AtmosphericScattering.z) * var_a74b4) * (0.0361000001430511474609375 / (var_fed1e * sqrt(var_fed1e))))));
            }
            var_138a7 = var_35c65;
        }
        else
        {
            var_138a7 = vec3(0.0);
        }
        var_bdb1d = var_f56f7;
        var_1bb57 = var_138a7;
    }
    else
    {
        var_bdb1d = 0.0;
        var_1bb57 = vec3(0.0);
    }
    highp vec4 var_81ddf = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_ba616 = var_81ddf;
    highp vec4 var_806d9;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_68aa6 = (v_ndcPosition.xy + vec2(1.0)) * 0.5;
        highp vec4 var_196b0 = u_invProj * vec4(v_ndcPosition, 1.0);
        highp float var_8cf8f = var_68aa6.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_68aa6.y, log((53.598148345947265625 * ((((-var_196b0.z) / var_196b0.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_806d9 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_68aa6.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_68aa6.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_806d9 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_eb669 = var_806d9;
    highp vec3 var_6e838 = var_806d9.xyz + (mix(var_22085.xyz, var_81ddf.xyz, vec3(var_ba616.w)) * var_eb669.w);
    highp vec3 var_3dc3f;
    if (PreExposureEnabled.x > 0.0)
    {
        var_3dc3f = var_6e838 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_3dc3f = var_6e838;
    }
    bgfx_FragColor = vec4(var_3dc3f.x, var_3dc3f.y, var_3dc3f.z, vec4(var_69f75, var_69f75, var_69f75, var_4d4a7.w * var_5d463.y).w);
}
