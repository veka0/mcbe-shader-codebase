#version 310 es

/*
* Available Macros:
*
* Passes:
* - CAUSTICS_MULTIPLIER_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_CausticsMultiplier;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp usampler2D s_EmissiveAmbientLinearRoughness;
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - layout(binding = 9, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 10, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 DownsampleResolutionAndRecipResolution;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
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
* - uniform vec4 SceneResolutionAndRecipResolution;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkySamplesConfig;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 Time;
* - uniform vec4 UndergroundFogColor;
* - uniform vec4 ViewportScale;
* - uniform vec4 WaterAlbedoExtinction;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WaterSurfaceEnabledAndExtinctionDistShift;
* - uniform vec4 WaterSurfaceOctaveParameters;
* - uniform vec4 WaterSurfaceParameters;
* - uniform vec4 WaterSurfaceWaveParameters;
* - uniform vec4 WorldOrigin;
*/

precision mediump float;
precision highp int;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = vec4(0.0);
}
