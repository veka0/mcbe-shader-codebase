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
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - uniform lowp sampler2D s_WaterDepth;
* - layout(binding = 9, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 3, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 4, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 BiomeBlendingLastUpdatePosition;
* - uniform vec4 BiomeBlendingParameters;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
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
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
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
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 NdLFloor;
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
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 Time;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterAlbedoExtinction;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WaterSurfaceEnabled;
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

layout(binding = 9, std430) buffer s_zBiomeInfoBuffer { BiomeInfo zBiomeInfoBuffer[]; } var_48860;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp sampler2D s_BiomeBlendingMap;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2D s_WaterDepth;
uniform highp vec4 BiomeBlendingLastUpdatePosition;
uniform highp vec4 BiomeBlendingParameters;
uniform highp vec4 WaterExtinctionCoefficients;
uniform highp vec4 WorldOrigin;
in highp vec3 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void func_8ab59(inout bool arg_5e3ed) {
    if (BiomeBlendingParameters.x > 0.0)
    {
        arg_5e3ed = true;
        return;
    }
    arg_5e3ed = false;
}
void func_6a0d0(inout highp vec4 arg_5dc29, inout highp vec4 arg_073df) {
    bool loc_a9f27;
    func_8ab59(loc_a9f27);
    if (loc_a9f27)
    {
        highp vec3 loc_5d5b9 = arg_5dc29.xyz;
        int loc_b9c0c = int(BiomeBlendingParameters.z * 0.5);
        highp vec3 loc_4aab1 = BiomeBlendingLastUpdatePosition.xyz + WorldOrigin.xyz;
        highp float loc_ab857 = (loc_5d5b9.x - loc_4aab1.x) / BiomeBlendingLastUpdatePosition.w;
        highp float loc_ddaf2 = (loc_5d5b9.z - loc_4aab1.z) / BiomeBlendingLastUpdatePosition.w;
        ivec2 loc_827d0 = ivec2(loc_b9c0c + int(floor(loc_ab857)), loc_b9c0c + int(floor(loc_ddaf2)));
        loc_827d0.x = clamp(loc_827d0.x, 0, int(BiomeBlendingParameters.z) - 1);
        loc_827d0.y = clamp(loc_827d0.y, 0, int(BiomeBlendingParameters.z) - 1);
        highp float loc_01a09 = fract(loc_ab857);
        highp float loc_9e036 = fract(loc_ddaf2);
        highp vec4 loc_2717d = vec4((1.0 - loc_01a09) * (1.0 - loc_9e036), loc_01a09 * (1.0 - loc_9e036), (1.0 - loc_01a09) * loc_9e036, loc_01a09 * loc_9e036);
        arg_073df = (((var_48860.zBiomeInfoBuffer[int(round(texelFetch(s_BiomeBlendingMap, loc_827d0, 0).x * 255.0))].waterExtinctionCoefficients * loc_2717d.x) + (var_48860.zBiomeInfoBuffer[int(round(texelFetch(s_BiomeBlendingMap, loc_827d0 + ivec2(1, 0), 0).x * 255.0))].waterExtinctionCoefficients * loc_2717d.y)) + (var_48860.zBiomeInfoBuffer[int(round(texelFetch(s_BiomeBlendingMap, loc_827d0 + ivec2(0, 1), 0).x * 255.0))].waterExtinctionCoefficients * loc_2717d.z)) + (var_48860.zBiomeInfoBuffer[int(round(texelFetch(s_BiomeBlendingMap, loc_827d0 + ivec2(1), 0).x * 255.0))].waterExtinctionCoefficients * loc_2717d.w);
        return;
    }
    arg_073df = WaterExtinctionCoefficients;
}
void main() {
    highp vec4 var_365e3 = vec4(v_projPosition.xy, (texture(s_SceneDepth, v_texcoord0.xy).x * 2.0) - 1.0, 1.0);
    highp mat4 var_3460a = u_invProj;
    highp float var_eb413 = var_365e3.x;
    highp float var_ac116 = var_365e3.y;
    highp float var_f2b7c = var_365e3.w;
    highp float var_0357c = var_365e3.z;
    highp float var_2c821 = var_365e3.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_3460a[0].x, var_ac116 * var_3460a[1].y, var_f2b7c * var_3460a[3].z, (var_0357c * var_3460a[2].w) + (var_2c821 * var_3460a[3].w));
    var_365e3 = var_9666f;
    highp float var_d799e = var_365e3.w;
    highp vec4 var_bae5b = var_9666f / vec4(var_d799e);
    var_365e3 = var_bae5b;
    highp vec4 var_7101d = vec4(v_projPosition.xy, (texture(s_WaterDepth, v_texcoord0.xy).x * 2.0) - 1.0, 1.0);
    highp mat4 var_3ebcc = u_invProj;
    highp float var_a6256 = var_7101d.x;
    highp float var_05401 = var_7101d.y;
    highp float var_b8669 = var_7101d.w;
    highp float var_259fc = var_7101d.z;
    highp float var_f8db3 = var_7101d.w;
    highp vec4 var_fa2eb = vec4(var_a6256 * var_3ebcc[0].x, var_05401 * var_3ebcc[1].y, var_b8669 * var_3ebcc[3].z, (var_259fc * var_3ebcc[2].w) + (var_f8db3 * var_3ebcc[3].w));
    var_7101d = var_fa2eb;
    highp float var_f7138 = var_7101d.w;
    highp vec4 var_4f566 = var_fa2eb / vec4(var_f7138);
    var_7101d = var_4f566;
    highp vec4 var_a803b = u_invView * vec4(var_4f566.xyz, 1.0);
    highp vec4 var_05771;
    func_6a0d0(var_a803b, var_05771);
    bgfx_FragColor = vec4(exp((-var_05771.xyz) * length((u_invView * vec4(var_bae5b.xyz, 1.0)) - var_a803b)), 1.0);
}
