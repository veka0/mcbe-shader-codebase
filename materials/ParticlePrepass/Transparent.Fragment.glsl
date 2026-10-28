#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 7, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_MERSTexture;
* - uniform lowp sampler2D s_NormalTexture;
* - uniform lowp sampler2D s_ParticleTexture;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - layout(binding = 8, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
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
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MERSUniforms;
* - uniform vec4 NdLFloor;
* - uniform vec4 PBRTextureFlags;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SubPixelOffset;
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
uniform highp sampler2D s_ParticleTexture;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec2 v_texcoord0;
layout(location = 0) out uvec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void main() {
    highp vec4 var_e966b = v_color0;
    highp vec4 var_6ca24 = v_fog;
    highp vec4 var_de643 = texture(s_ParticleTexture, v_texcoord0) * vec4(v_color0.xyz, var_e966b.w);
    highp vec3 var_89131 = mix(var_de643.xyz, v_fog.xyz, vec3(var_6ca24.w));
    highp vec4 var_16bf0 = vec4(var_89131.x, var_89131.y, var_89131.z, var_de643.w);
    highp vec4 var_7c6ad = v_fog;
    bgfx_FragData0 = uvec4(0u);
    bgfx_FragData1 = vec4(mix(vec4(var_89131, var_16bf0.w).xyz, v_fog.xyz, vec3(var_7c6ad.w)), var_16bf0.w);
    bgfx_FragData2 = vec4(0.0);
}
