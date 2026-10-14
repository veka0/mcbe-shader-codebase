#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_INDIRECT_SPECULAR_SHADING_PASS (not used)
* - DO_INDIRECT_SPECULAR_UPSCALE_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Mode:
* - MODE__DEFAULT (not used)
* - MODE__MIXED_RES (not used)
*
* Upscaling:
* - UPSCALING__OFF (not used)
* - UPSCALING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp usampler2D s_EmissiveAmbientLinearRoughness;
* - layout(binding = 13, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_NormalsAndDepthLighting;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SSRTexture;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - uniform lowp sampler2D s_SpecularLighting;
* - layout(binding = 14, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
* - layout(binding = 15, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 16, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraAmbientContribution;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
* - uniform vec4 DownsampleResolutionAndRecipResolution;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightingUpscaleParams;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightPreCalcValues;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowAtlasResolution;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SSRParameters;
* - uniform vec4 SceneResolutionAndRecipResolution;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkySamplesConfig;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TransitioningAmbientScalar;
* - uniform vec4 UndergroundFogColor;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterSurfaceEnabledAndExtinctionDistShift;
* - uniform vec4 WaterSurfaceOctaveParameters;
* - uniform vec4 WaterSurfaceParameters;
* - uniform vec4 WaterSurfaceWaveParameters;
* - uniform vec4 WorldOrigin;
*/

uniform vec4 ViewportScale;
in vec3 a_position;
in vec2 a_texcoord0;
out vec3 v_projPosition;
out vec4 v_texcoord0;
void main() {
    vec4 var_c1461 = vec4(0.0);
    vec4 var_91d41 = vec4(a_position, 1.0);
    vec4 var_273da = var_91d41;
    vec2 var_5ee7b = (var_91d41.xy * 2.0) - vec2(1.0);
    var_273da.x = var_5ee7b.x;
    var_273da.y = var_5ee7b.y;
    vec3 var_3269b = a_position;
    vec2 var_db333 = (a_position.xy * 2.0) - vec2(1.0);
    var_3269b.x = var_db333.x;
    var_3269b.y = var_db333.y;
    vec2 var_f32e0 = a_texcoord0 * ViewportScale.xy;
    var_c1461.x = var_f32e0.x;
    var_c1461.y = var_f32e0.y;
    var_c1461.z = a_texcoord0.x;
    var_c1461.w = a_texcoord0.y;
    v_projPosition = var_3269b;
    v_texcoord0 = var_c1461;
    gl_Position = var_273da;
}
