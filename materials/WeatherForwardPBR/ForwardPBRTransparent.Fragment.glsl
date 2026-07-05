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
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_LightingTexture;
* - uniform lowp sampler2D s_OcclusionTexture;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - uniform lowp sampler2D s_WeatherTexture;
* - layout(binding = 10, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 11, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
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
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 Dimensions;
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
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform vec4 OcclusionHeightOffset;
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
* - uniform vec4 PositionBaseOffset;
* - uniform vec4 PositionForwardOffset;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
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
float var_69f75;
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
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
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
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
void func_73dd7(inout highp vec2 arg_0a9f5) {
    highp vec4 loc_175e8 = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_fd51f = loc_175e8.x;
    highp float loc_5dbf2 = (loc_175e8.y + (loc_175e8.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125);
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
    if (loc_1a0b7 && (v_occlusionHeight < loc_5dbf2))
    {
        arg_0a9f5 = vec2(0.0);
        return;
    }
    else
    {
        arg_0a9f5 = vec2(clamp(loc_fd51f - (((v_occlusionHeight - loc_5dbf2) * 25.0) * loc_fd51f), 0.0, 1.0), 1.0);
        return;
    }
}
#endif
#ifdef NO_OCCLUSION__ON
void func_b79af(inout highp vec2 arg_c6309) {
    highp vec4 loc_afabb = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_97536 = loc_afabb.x;
    arg_c6309 = vec2(clamp(loc_97536 - (((v_occlusionHeight - ((loc_afabb.y + (loc_afabb.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125))) * 25.0) * loc_97536), 0.0, 1.0), 1.0);
}
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
void func_f0c66(inout highp vec2 arg_0a9f5) {
    highp vec4 loc_175e8 = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_fd51f = loc_175e8.x;
    highp float loc_15941 = (loc_175e8.y + (loc_175e8.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125);
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
    if (loc_65342 && (v_occlusionHeight > loc_15941))
    {
        arg_0a9f5 = vec2(0.0);
        return;
    }
    else
    {
        arg_0a9f5 = vec2(clamp(loc_fd51f - (((v_occlusionHeight - loc_15941) * 25.0) * loc_fd51f), 0.0, 1.0), 1.0);
        return;
    }
}
#endif
void main() {
#ifdef NO_OCCLUSION__OFF
    highp vec4 var_3b155 = texture(s_WeatherTexture, v_texcoord0);
#endif
    highp vec2 var_3c0b9;
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
    func_73dd7(var_3c0b9);
#endif
#ifdef NO_OCCLUSION__ON
    highp vec4 var_3b155 = texture(s_WeatherTexture, v_texcoord0);
    func_b79af(var_3c0b9);
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
    func_f0c66(var_3c0b9);
#endif
    highp vec2 var_5d463 = var_3c0b9;
    highp vec4 var_9a675 = var_3b155;
    highp vec4 var_31b5c = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp vec2 var_409bf = var_3c0b9;
    highp vec4 var_afbf5 = vec4(0.0);
    highp float var_89ff2 = var_409bf.x * var_409bf.x;
    highp vec4 var_699b7 = SkyAmbientLightColorIntensity;
    highp float var_a366d = var_409bf.y * var_409bf.y;
    highp vec3 var_3f109 = (((((var_9a675.xyz * vec3(0.3183098733425140380859375)) * DiffuseSpecularEmissiveAmbientTermToggles.x) * ((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * var_31b5c.w) * 1.0)) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight.x) * var_9a675.xyz) + (max((clamp(vec3(var_89ff2 + (var_afbf5.x * var_afbf5.w), (var_89ff2 * ((((var_89ff2 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_afbf5.y * var_afbf5.w), (var_89ff2 * (((var_89ff2 * var_89ff2) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_afbf5.z * var_afbf5.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_a366d * var_a366d) * var_409bf.y, (var_409bf.y * var_409bf.y) * var_409bf.y, CameraLightIntensity.y)) * var_699b7.w), AmbientLightParams.xyz * AmbientLightParams.w) * var_9a675.xyz);
    var_3b155 = vec4(var_3f109.x, var_3f109.y, var_3f109.z, var_9a675.w);
    bool var_9b186 = AtmosphericScatteringToggles.y != 0.0;
    bool var_2b2d2;
    if (var_9b186)
    {
        var_2b2d2 = AtmosphericScatteringToggles.z != 0.0;
    }
    else
    {
        var_2b2d2 = var_9b186;
    }
    bool var_68aa1;
    if (var_2b2d2)
    {
        var_68aa1 = DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0;
    }
    else
    {
        var_68aa1 = var_2b2d2;
    }
    highp vec3 var_d9480;
    if (var_68aa1)
    {
        highp vec4 var_0e954 = vec4(1.0);
        highp vec4 var_4c0ec = SkyAmbientLightColorIntensity;
        var_d9480 = max((clamp(vec3(1.0 + (var_0e954.x * var_0e954.w), 1.0 + (var_0e954.y * var_0e954.w), 1.0 + (var_0e954.z * var_0e954.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_4c0ec.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_d9480 = vec3(0.0);
    }
    highp vec3 var_d4470 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_f56f7 = clamp((((length(u_view * (u_model[0] * vec4(v_worldPos, 1.0))) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_f56f7 > 0.0)
        {
            highp vec3 var_fe67e;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_fe67e = FogColor.xyz * max(var_d9480, vec3(1.0));
            }
            else
            {
                highp vec4 var_52ab1 = SunColor;
                highp vec4 var_c9ec4 = MoonColor;
                highp vec3 var_89f5b = var_d4470;
                highp float var_470cd = smoothstep(FogSkyBlend.z - FogSkyBlend.w, FogSkyBlend.x - FogSkyBlend.w, var_89f5b.y);
                highp float var_ec0d7 = dot(var_d4470, SunDir.xyz);
                highp float var_f7518 = dot(var_d4470, MoonDir.xyz);
                highp vec3 var_061a3 = var_d4470;
                highp float var_e298a = smoothstep(FogSkyBlend.y, FogSkyBlend.x - FogSkyBlend.w, var_061a3.y);
                highp float var_ae688 = clamp(pow(max(var_ec0d7, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_a74b4 = clamp(pow(max(var_f7518, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_6773c = 1.809999942779541015625 - (var_ae688 * 1.7999999523162841796875);
                highp float var_fed1e = 1.809999942779541015625 - (var_a74b4 * 1.7999999523162841796875);
                var_fe67e = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_e298a * var_e298a) * var_e298a, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_52ab1.w * (0.75 * ((var_ec0d7 * var_ec0d7) + 1.0))) + (var_c9ec4.w * (0.75 * ((var_f7518 * var_f7518) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_470cd * var_470cd) * var_470cd, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_52ab1.w) * AtmosphericScattering.y) * var_ae688) * (0.0361000001430511474609375 / (var_6773c * sqrt(var_6773c)))) + ((((MoonColor.xyz * var_c9ec4.w) * AtmosphericScattering.z) * var_a74b4) * (0.0361000001430511474609375 / (var_fed1e * sqrt(var_fed1e))))));
            }
            var_138a7 = var_fe67e;
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
    highp vec3 var_6e838 = var_806d9.xyz + (mix(var_3f109.xyz, var_81ddf.xyz, vec3(var_ba616.w)) * var_eb669.w);
    highp vec3 var_3dc3f;
    if (PreExposureEnabled.x > 0.0)
    {
        var_3dc3f = var_6e838 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_3dc3f = var_6e838;
    }
    bgfx_FragColor = vec4(var_3dc3f.x, var_3dc3f.y, var_3dc3f.z, vec4(var_69f75, var_69f75, var_69f75, var_3b155.w * var_5d463.y).w);
}
