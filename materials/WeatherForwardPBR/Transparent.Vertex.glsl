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
* - INSTANCING__OFF
* - INSTANCING__ON
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

uniform mat4 u_modelViewProj;
#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
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
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec4 v_color0;
out vec4 v_fog;
out float v_occlusionHeight;
out vec2 v_occlusionUV;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_59d11;
    var_59d11[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_59d11[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_59d11[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_59d11[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
#endif
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
    vec4 var_e0c3e = vec4(var_32261.x, var_32261.y, var_8c8da.z, var_8c8da.w);
    vec4 var_b4024 = var_e0c3e;
    v_color0 = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_b4024.z / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_occlusionHeight = (var_91624.y + (ViewPosition.y - 0.5)) * 0.0039215688593685626983642578125;
    v_occlusionUV = ((var_596e7.xz + ViewPosition.xz) * 0.015625) + vec2(0.5);
#ifdef NO_VARIETY__OFF
    v_texcoord0 = var_181bc;
#endif
#ifdef NO_VARIETY__ON
    v_texcoord0 = UVOffsetAndScale.xy + (a_texcoord0 * UVOffsetAndScale.zw);
#endif
#ifdef INSTANCING__OFF
    v_worldPos = (u_model[0] * vec4(a_position, 1.0)).xyz;
#endif
#ifdef INSTANCING__ON
    v_worldPos = (var_59d11 * vec4(a_position, 1.0)).xyz;
#endif
    gl_Position = var_e0c3e;
}
