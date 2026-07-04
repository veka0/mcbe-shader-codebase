#version 310 es

/*
* Available Macros:
*
* Passes:
* - WATER_EXTINCTION_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - uniform lowp sampler2D s_WaterDepth;
* - layout(binding = 9, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BiomeBlendingLastUpdatePosition;
* - uniform vec4 BiomeBlendingParameters;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraAmbientContribution;
* - uniform vec4 CameraIsUnderwater;
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
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
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
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightNdLFloor;
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
* - uniform vec4 UndergroundFogColor;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
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
struct BiomeInfo {
    highp vec4 waterExtinctionCoefficients;
    highp vec4 waterAlbedoExtinction;
    highp vec4 waterSurfaceParameters;
    highp vec4 waterSurfaceWaveParameters;
    highp vec4 waterSurfaceOctaveParameters;
};

layout(binding = 9, std430) buffer s_zBiomeInfoBuffer { BiomeInfo zBiomeInfoBuffer[]; } var_3cc78;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp sampler2D s_BiomeBlendingMap;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2D s_WaterDepth;
uniform highp vec4 BiomeBlendingLastUpdatePosition;
uniform highp vec4 BiomeBlendingParameters;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 WaterExtinctionCoefficients;
uniform highp vec4 WaterSurfaceEnabledAndExtinctionDistShift;
in highp vec3 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_8ab59(inout bool arg_5e3ed) {
    if (BiomeBlendingParameters.x > 0.0)
    {
        arg_5e3ed = true;
        return;
    }
    arg_5e3ed = false;
}
void func_a4cbd(inout highp vec3 arg_c6525, inout highp vec4 arg_a01ef) {
    int loc_738fb = int(BiomeBlendingParameters.z * 0.5);
    highp float loc_6b94b = (arg_c6525.x - BiomeBlendingLastUpdatePosition.x) / BiomeBlendingLastUpdatePosition.w;
    highp float loc_c8c2e = (arg_c6525.z - BiomeBlendingLastUpdatePosition.z) / BiomeBlendingLastUpdatePosition.w;
    ivec2 loc_f487d = ivec2(loc_738fb + int(floor(loc_6b94b)), loc_738fb + int(floor(loc_c8c2e)));
    loc_f487d.x = clamp(loc_f487d.x, 0, int(BiomeBlendingParameters.z) - 1);
    loc_f487d.y = clamp(loc_f487d.y, 0, int(BiomeBlendingParameters.z) - 1);
    int loc_35590 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d, 0).x * 255.0));
    int loc_d7d5b = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(1, 0), 0).x * 255.0));
    int loc_80f2f = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(0, 1), 0).x * 255.0));
    int loc_86c64 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(1), 0).x * 255.0));
    if (((loc_35590 == loc_d7d5b) && (loc_d7d5b == loc_80f2f)) && (loc_80f2f == loc_86c64))
    {
        arg_a01ef = var_3cc78.zBiomeInfoBuffer[loc_35590].waterExtinctionCoefficients;
        return;
    }
    highp float loc_77c49 = fract(loc_6b94b);
    highp float loc_33836 = fract(loc_c8c2e);
    highp vec4 loc_47197 = vec4((1.0 - loc_77c49) * (1.0 - loc_33836), loc_77c49 * (1.0 - loc_33836), (1.0 - loc_77c49) * loc_33836, loc_77c49 * loc_33836);
    arg_a01ef = (((var_3cc78.zBiomeInfoBuffer[loc_35590].waterExtinctionCoefficients * loc_47197.x) + (var_3cc78.zBiomeInfoBuffer[loc_d7d5b].waterExtinctionCoefficients * loc_47197.y)) + (var_3cc78.zBiomeInfoBuffer[loc_80f2f].waterExtinctionCoefficients * loc_47197.z)) + (var_3cc78.zBiomeInfoBuffer[loc_86c64].waterExtinctionCoefficients * loc_47197.w);
}
void func_40f6a(inout highp vec4 arg_8331b, inout highp vec4 arg_a6615) {
    bool loc_a9f27;
    func_8ab59(loc_a9f27);
    if (loc_a9f27)
    {
        highp vec3 loc_e7b22 = (u_invView * vec4(arg_8331b.xyz, 1.0)).xyz;
        highp vec4 loc_baef6;
        func_a4cbd(loc_e7b22, loc_baef6);
        arg_a6615 = loc_baef6;
        return;
    }
    arg_a6615 = WaterExtinctionCoefficients;
}
void main() {
    highp vec4 var_365e3 = vec4(v_projPosition.xy, (texture(s_SceneDepth, v_texcoord0.xy).x * 2.0) - 1.0, 1.0);
    highp mat4 var_4fa47 = u_invProj;
    highp mat4 var_498b7 = u_invProj;
    highp mat4 var_4882d = u_invProj;
    highp mat4 var_78c1b = u_invProj;
    highp mat4 var_40575 = u_invProj;
    highp float var_eb413 = var_365e3.x;
    highp float var_ac116 = var_365e3.y;
    highp float var_f2b7c = var_365e3.w;
    highp float var_0357c = var_365e3.z;
    highp float var_2c821 = var_365e3.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_4fa47[0].x, var_ac116 * var_498b7[1].y, var_f2b7c * var_4882d[3].z, (var_0357c * var_78c1b[2].w) + (var_2c821 * var_40575[3].w));
    var_365e3 = var_9666f;
    highp float var_d799e = var_365e3.w;
    highp vec4 var_f84ab = var_9666f / vec4(var_d799e);
    var_365e3 = var_f84ab;
    highp vec4 var_7101d = vec4(v_projPosition.xy, (texture(s_WaterDepth, v_texcoord0.xy).x * 2.0) - 1.0, 1.0);
    highp mat4 var_2949d = u_invProj;
    highp mat4 var_e6914 = u_invProj;
    highp mat4 var_164c7 = u_invProj;
    highp mat4 var_b5866 = u_invProj;
    highp mat4 var_bb46a = u_invProj;
    highp float var_a6256 = var_7101d.x;
    highp float var_05401 = var_7101d.y;
    highp float var_b8669 = var_7101d.w;
    highp float var_259fc = var_7101d.z;
    highp float var_f8db3 = var_7101d.w;
    highp vec4 var_fa2eb = vec4(var_a6256 * var_2949d[0].x, var_05401 * var_e6914[1].y, var_b8669 * var_164c7[3].z, (var_259fc * var_b5866[2].w) + (var_f8db3 * var_bb46a[3].w));
    var_7101d = var_fa2eb;
    highp float var_f7138 = var_7101d.w;
    highp vec4 var_d62a6 = var_fa2eb / vec4(var_f7138);
    var_7101d = var_d62a6;
    highp vec4 var_736e7;
    func_40f6a(var_d62a6, var_736e7);
    bgfx_FragData0 = vec4(exp((-var_736e7.xyz) * ((min(length(var_f84ab), FogAndDistanceControl.z) - min(length(var_d62a6), FogAndDistanceControl.z)) + WaterSurfaceEnabledAndExtinctionDistShift.y)), 1.0);
}
