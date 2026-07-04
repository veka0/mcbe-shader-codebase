#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* FlipOcclusion:
* - FLIP_OCCLUSION__OFF (not used)
* - FLIP_OCCLUSION__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* NoOcclusion:
* - NO_OCCLUSION__OFF (not used)
* - NO_OCCLUSION__ON (not used)
*
* NoVariety:
* - NO_VARIETY__OFF
* - NO_VARIETY__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
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
* - layout(binding = 11, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 12, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 13, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
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
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 Dimensions;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform mat4 DirectionalLightSourceCausticsViewProj;
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
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WorldOrigin;
*/

uniform mat4 u_modelViewProj;
uniform vec4 Dimensions;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
uniform vec4 PositionBaseOffset;
uniform vec4 PositionForwardOffset;
uniform vec4 UVOffsetAndScale;
uniform vec4 Velocity;
uniform vec4 ViewPosition;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color0;
out vec4 v_fog;
out vec3 v_ndcPosition;
out float v_occlusionHeight;
out vec2 v_occlusionUV;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#ifdef NO_VARIETY__OFF
    vec4 var_6c969 = a_color0;
#endif
    vec2 var_49187 = a_texcoord0;
#ifdef NO_VARIETY__OFF
    vec2 var_181bc = UVOffsetAndScale.xy + (a_texcoord0 * UVOffsetAndScale.zw);
    var_181bc.x += ((var_6c969.x * 255.0) * UVOffsetAndScale.z);
#endif
    vec3 var_5bfc0 = a_position + PositionBaseOffset.xyz;
    vec3 var_4108f = vec3(30.0);
    vec3 var_596e7 = (vec3(var_5bfc0.x - (var_4108f.x * trunc(var_5bfc0.x / var_4108f.x)), var_5bfc0.y - (var_4108f.y * trunc(var_5bfc0.y / var_4108f.y)), var_5bfc0.z - (var_4108f.z * trunc(var_5bfc0.z / var_4108f.z))) - vec3(15.0)) + PositionForwardOffset.xyz;
    vec3 var_91624 = var_596e7;
    vec4 var_12b3c = u_modelViewProj * vec4(var_596e7, 1.0);
    vec4 var_8dd4e = var_12b3c;
    vec4 var_6e0e6 = u_modelViewProj * vec4(var_596e7 + (Velocity.xyz * Dimensions.y), 1.0);
    vec4 var_fe173 = var_6e0e6;
    vec2 var_67f44 = (var_6e0e6.xy / vec2(var_fe173.w)) - (var_12b3c.xy / vec2(var_8dd4e.w));
    vec4 var_8c8da = mix(var_6e0e6, var_12b3c, vec4(var_49187.y));
    vec2 var_32261 = var_8c8da.xy + ((normalize(vec2(-var_67f44.y, var_67f44.x)) * (0.5 - var_49187.x)) * Dimensions.x);
    vec4 var_353f8 = vec4(var_32261.x, var_32261.y, var_8c8da.z, var_8c8da.w);
    vec4 var_b4024 = var_353f8;
    vec4 var_52536 = var_353f8;
    vec3 var_694a1 = a_position + PositionBaseOffset.xyz;
    vec3 var_cbc55 = vec3(30.0);
    v_color0 = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_b4024.z / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_ndcPosition = var_353f8.xyz / vec3(var_52536.w);
    v_occlusionHeight = (var_91624.y + (ViewPosition.y - 0.5)) * 0.0039215688593685626983642578125;
    v_occlusionUV = ((var_596e7.xz + ViewPosition.xz) * 0.015625) + vec2(0.5);
#ifdef NO_VARIETY__OFF
    v_texcoord0 = var_181bc;
#endif
#ifdef NO_VARIETY__ON
    v_texcoord0 = UVOffsetAndScale.xy + (a_texcoord0 * UVOffsetAndScale.zw);
#endif
    v_worldPos = (vec3(var_694a1.x - (var_cbc55.x * trunc(var_694a1.x / var_cbc55.x)), var_694a1.y - (var_cbc55.y * trunc(var_694a1.y / var_cbc55.y)), var_694a1.z - (var_cbc55.z * trunc(var_694a1.z / var_cbc55.z))) - vec3(15.0)) + PositionForwardOffset.xyz;
    gl_Position = var_353f8;
}
