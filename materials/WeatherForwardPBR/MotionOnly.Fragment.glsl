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
* - NO_OCCLUSION__ON (not used)
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
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
#ifdef NO_OCCLUSION__OFF
uniform highp sampler2D s_OcclusionTexture;
#endif
uniform highp sampler2D s_WeatherTexture;
#ifdef NO_OCCLUSION__OFF
uniform highp vec4 OcclusionHeightOffset;
#endif
uniform highp vec4 u_prevWorldPosOffset;
#ifdef NO_OCCLUSION__OFF
in highp float v_occlusionHeight;
in highp vec2 v_occlusionUV;
#endif
in highp vec3 v_prevWorldPos;
in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_b7c4a = texture(s_WeatherTexture, v_texcoord0);
    if (var_b7c4a.w < 0.5)
    {
        discard;
    }
#ifdef NO_OCCLUSION__OFF
    highp vec4 var_18fd7 = texture(s_OcclusionTexture, v_occlusionUV);
    bool var_47b39 = v_occlusionUV.x >= 0.0;
    bool var_77737;
    if (var_47b39)
    {
        var_77737 = v_occlusionUV.x <= 1.0;
    }
    else
    {
        var_77737 = var_47b39;
    }
    bool var_8f253;
    if (var_77737)
    {
        var_8f253 = v_occlusionUV.y >= 0.0;
    }
    else
    {
        var_8f253 = var_77737;
    }
    bool var_ac78e;
    if (var_8f253)
    {
        var_ac78e = v_occlusionUV.y <= 1.0;
    }
    else
    {
        var_ac78e = var_8f253;
    }
#endif
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
    if (var_ac78e && (v_occlusionHeight < ((var_18fd7.y + (var_18fd7.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125))))
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
    if (var_ac78e && (v_occlusionHeight > ((var_18fd7.y + (var_18fd7.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125))))
#endif
#ifdef NO_OCCLUSION__OFF
    {
        discard;
    }
#endif
    highp vec4 var_6343e;
    if (distance(v_worldPos, v_prevWorldPos - u_prevWorldPosOffset.xyz) > 27.0)
    {
        highp vec4 var_7293e = u_viewProj * vec4(v_worldPos, 1.0);
        highp vec4 var_c092d = var_7293e;
        highp float var_9025d = var_c092d.w;
        highp vec4 var_b74ea = ((var_7293e / vec4(var_9025d)) * 0.5) + vec4(0.5);
        var_c092d = var_b74ea;
        highp vec4 var_40af8 = u_prevViewProj * vec4(v_worldPos, 1.0);
        highp vec4 var_9f128 = var_40af8;
        highp float var_a08f7 = var_9f128.w;
        highp vec4 var_b3184 = ((var_40af8 / vec4(var_a08f7)) * 0.5) + vec4(0.5);
        var_9f128 = var_b3184;
        highp vec2 var_95189 = var_b74ea.xy - var_b3184.xy;
        var_6343e = vec4(vec4(1.0).x, vec4(1.0).y, var_95189.x, var_95189.y);
    }
    else
    {
        highp vec4 var_e3385 = u_viewProj * vec4(v_worldPos, 1.0);
        highp vec4 var_d1196 = var_e3385;
        highp float var_36ae1 = var_d1196.w;
        highp vec4 var_58273 = ((var_e3385 / vec4(var_36ae1)) * 0.5) + vec4(0.5);
        var_d1196 = var_58273;
        highp vec4 var_3d686 = u_prevViewProj * vec4(v_prevWorldPos - u_prevWorldPosOffset.xyz, 1.0);
        highp vec4 var_42184 = var_3d686;
        highp float var_5148a = var_42184.w;
        highp vec4 var_ff2a0 = ((var_3d686 / vec4(var_5148a)) * 0.5) + vec4(0.5);
        var_42184 = var_ff2a0;
        highp vec2 var_26dea = var_58273.xy - var_ff2a0.xy;
        var_6343e = vec4(vec4(1.0).x, vec4(1.0).y, var_26dea.x, var_26dea.y);
    }
    bgfx_FragData0 = var_6343e;
}
