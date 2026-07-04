#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
* - MOTION_ONLY_PASS (not used)
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
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF (not used)
* - POINT_LIGHT_SHADING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_LightingTexture;
* - uniform lowp sampler2D s_OcclusionTexture;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
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
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
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
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform vec4 PointLightPreCalcValues;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowAtlasResolution;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PositionBaseOffset;
* - uniform vec4 PositionForwardOffset;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 PrevPositionBaseOffset;
* - uniform vec4 PrevPositionForwardOffset;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 Time;
* - uniform vec4 UVOffsetAndScale;
* - uniform vec4 UndergroundFogColor;
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
uniform highp vec4 CameraAmbientContribution;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
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
uniform highp vec4 UndergroundFogColor;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
in highp vec3 v_ndcPosition;
in highp float v_occlusionHeight;
in highp vec2 v_occlusionUV;
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
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
void func_17d86(inout uvec4 arg_07724, inout highp vec4 arg_a1e78) {
    highp float loc_40466 = (float((arg_07724.x | (arg_07724.y << 8u)) & 1023u) + OcclusionHeightOffset.x) * 0.0039215688593685626983642578125;
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
    if (loc_1a0b7 && (v_occlusionHeight < loc_40466))
    {
        arg_a1e78 = vec4(0.0);
        return;
    }
    else
    {
        uvec4 loc_8c0cb = arg_07724;
        highp vec3 loc_6355c = ((vec3(uvec3(loc_8c0cb.z >> 4u, loc_8c0cb.w & 15u, loc_8c0cb.w >> 4u)) * vec3(0.066666670143604278564453125)) * (float(loc_8c0cb.y >> 2u) * 0.01587301678955554962158203125)) * 6.0;
        arg_a1e78 = vec4(loc_6355c - (loc_6355c * clamp((v_occlusionHeight - loc_40466) * 25.0, 0.0, 1.0)), 1.0);
        return;
    }
}
#endif
#ifdef NO_OCCLUSION__ON
void func_5638b(inout uvec4 arg_29e18, inout highp vec4 arg_a3d03) {
    uvec4 loc_3551c = arg_29e18;
    highp vec3 loc_0cb23 = ((vec3(uvec3(loc_3551c.z >> 4u, loc_3551c.w & 15u, loc_3551c.w >> 4u)) * vec3(0.066666670143604278564453125)) * (float(loc_3551c.y >> 2u) * 0.01587301678955554962158203125)) * 6.0;
    arg_a3d03 = vec4(loc_0cb23 - (loc_0cb23 * clamp((v_occlusionHeight - ((float((arg_29e18.x | (arg_29e18.y << 8u)) & 1023u) + OcclusionHeightOffset.x) * 0.0039215688593685626983642578125)) * 25.0, 0.0, 1.0)), 1.0);
}
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
void func_7ddb9(inout uvec4 arg_07724, inout highp vec4 arg_a1e78) {
    highp float loc_eca94 = (float((arg_07724.x | (arg_07724.y << 8u)) & 1023u) + OcclusionHeightOffset.x) * 0.0039215688593685626983642578125;
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
    if (loc_65342 && (v_occlusionHeight > loc_eca94))
    {
        arg_a1e78 = vec4(0.0);
        return;
    }
    else
    {
        uvec4 loc_8c0cb = arg_07724;
        highp vec3 loc_6355c = ((vec3(uvec3(loc_8c0cb.z >> 4u, loc_8c0cb.w & 15u, loc_8c0cb.w >> 4u)) * vec3(0.066666670143604278564453125)) * (float(loc_8c0cb.y >> 2u) * 0.01587301678955554962158203125)) * 6.0;
        arg_a1e78 = vec4(loc_6355c - (loc_6355c * clamp((v_occlusionHeight - loc_eca94) * 25.0, 0.0, 1.0)), 1.0);
        return;
    }
}
#endif
void main() {
    highp vec4 var_3d4c4 = texture(s_WeatherTexture, v_texcoord0);
    highp vec4 var_ab9d7 = var_3d4c4;
    highp vec3 var_9e11a = var_3d4c4.xyz;
    highp vec3 var_a32a9;
    func_9b87e(var_a32a9, var_9e11a);
#ifdef NO_OCCLUSION__ON
    highp vec4 var_8261b;
#endif
    highp vec4 var_8808e = vec4(var_a32a9, var_ab9d7.w);
    highp vec4 var_e5cb6 = texture(s_OcclusionTexture, v_occlusionUV);
    uvec4 var_14d49 = uvec4(round(var_e5cb6 * 255.0));
#ifdef NO_OCCLUSION__OFF
    highp vec4 var_8261b;
#endif
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
    func_17d86(var_14d49, var_8261b);
#endif
#ifdef NO_OCCLUSION__ON
    func_5638b(var_14d49, var_8261b);
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
    func_7ddb9(var_14d49, var_8261b);
#endif
    highp vec4 var_a7999 = var_8261b;
    highp vec2 var_acc98 = vec2(0.0, var_a7999.w);
    highp vec2 var_a7ea5 = var_acc98;
    highp vec4 var_ef32e = var_8808e;
    highp vec4 var_678e5 = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp vec2 var_1754f = var_acc98;
    highp vec3 var_55c6a = var_8261b.xyz;
    highp vec3 var_a3328;
    if ((((var_55c6a.x + var_55c6a.y) + var_55c6a.z) < 9.9999997473787516355514526367188e-05) && (var_1754f.x > 9.9999997473787516355514526367188e-05))
    {
        highp vec4 var_0bc6f = vec4(0.0);
        highp float var_9a19a = var_1754f.x * var_1754f.x;
        var_a3328 = clamp(vec3(var_9a19a + (var_0bc6f.x * var_0bc6f.w), (var_9a19a * ((((var_9a19a * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.y * var_0bc6f.w), (var_9a19a * (((var_9a19a * var_9a19a) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.z * var_0bc6f.w)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_a3328 = var_8261b.xyz;
    }
    highp vec4 var_4635d = SkyAmbientLightColorIntensity;
    highp float var_2d5a2 = var_1754f.y * var_1754f.y;
    highp vec3 var_f3f90 = (((((var_ef32e.xyz * vec3(0.3183098733425140380859375)) * DiffuseSpecularEmissiveAmbientTermToggles.x) * ((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * var_678e5.w) * 1.0)) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight.x) * var_ef32e.xyz) + (max((var_a3328 * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_2d5a2 * var_2d5a2) * var_1754f.y, (var_1754f.y * var_1754f.y) * var_1754f.y, CameraLightIntensity.y)) * var_4635d.w), AmbientLightParams.xyz * AmbientLightParams.w) * var_ef32e.xyz);
    var_8808e = vec4(var_f3f90.x, var_f3f90.y, var_f3f90.z, var_8808e.w);
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
    highp vec3 var_936b4;
    if (var_68aa1)
    {
        highp vec4 var_1a32d = vec4(1.0);
        highp vec4 var_ee7a5 = SkyAmbientLightColorIntensity;
        var_936b4 = max(((vec3(1.0) + (vec3(1.0) * var_1a32d.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_ee7a5.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_936b4 = vec3(0.0);
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
            highp vec3 var_44083;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_44083 = FogColor.xyz * max(var_936b4, vec3(1.0));
            }
            else
            {
                highp vec4 var_a0aa2 = SunColor;
                highp vec4 var_ea036 = MoonColor;
                highp vec3 var_bacde = var_d4470;
                highp float var_9281d = 1.0 - smoothstep(FogSkyBlend.x - FogSkyBlend.w, FogSkyBlend.z - FogSkyBlend.w, var_bacde.y);
                highp float var_99d92 = dot(var_d4470, SunDir.xyz);
                highp float var_b6eed = dot(var_d4470, MoonDir.xyz);
                highp vec3 var_5d345 = var_d4470;
                highp float var_070ce = 1.0 - smoothstep(FogSkyBlend.x - FogSkyBlend.w, FogSkyBlend.y, var_5d345.y);
                highp float var_824a6 = clamp(pow(max(var_99d92, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_3b3ff = clamp(pow(max(var_b6eed, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_3d1af = 1.809999942779541015625 - (var_824a6 * 1.7999999523162841796875);
                highp float var_db5e0 = 1.809999942779541015625 - (var_3b3ff * 1.7999999523162841796875);
                highp vec3 var_d534c = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3((var_070ce * var_070ce) * var_070ce)) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_a0aa2.w * (0.75 * ((var_99d92 * var_99d92) + 1.0))) + (var_ea036.w * (0.75 * ((var_b6eed * var_b6eed) + 1.0))))) + (((SkyHorizonColor.xyz * ((var_9281d * var_9281d) * var_9281d)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_a0aa2.w) * AtmosphericScattering.y) * var_824a6) * (0.0361000001430511474609375 / (var_3d1af * sqrt(var_3d1af)))) + ((((MoonColor.xyz * var_ea036.w) * AtmosphericScattering.z) * var_3b3ff) * (0.0361000001430511474609375 / (var_db5e0 * sqrt(var_db5e0))))));
                highp vec3 var_ef160;
                if (AtmosphericScatteringToggles.w != 0.0)
                {
                    var_ef160 = mix(UndergroundFogColor.xyz, var_d534c, vec3(max(CameraAmbientContribution.y, 1.0)));
                }
                else
                {
                    var_ef160 = var_d534c;
                }
                var_44083 = var_ef160;
            }
            var_138a7 = var_44083;
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
    highp vec3 var_6e838 = var_806d9.xyz + (mix(var_f3f90.xyz, var_81ddf.xyz, vec3(var_ba616.w)) * var_eb669.w);
    highp vec3 var_3013f;
    if (PreExposureEnabled.x > 0.0)
    {
        var_3013f = var_6e838 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_3013f = var_6e838;
    }
    bgfx_FragColor = vec4(var_3013f, var_8808e.w * var_a7ea5.y);
}
