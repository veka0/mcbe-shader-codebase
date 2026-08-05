#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - FORWARD_PBR_ALPHA_TEST_PASS (not used)
* - FORWARD_PBR_OPAQUE_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
*
* Change_Color:
* - CHANGE_COLOR__MULTI
* - CHANGE_COLOR__OFF
* - CHANGE_COLOR__ON
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF
* - MASKED_MULTITEXTURE__ON
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF
* - POINT_LIGHT_SHADING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 11, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_MERSTexture;
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_MatTexture1;
* - uniform lowp sampler2D s_NormalTexture;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 12, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
* - layout(binding = 13, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 14, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightColor;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform mat4 Bones[8];
* - uniform vec4 CameraAmbientContribution;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 CascadesParameters[8];
* - uniform vec4 CascadesPerSet;
* - uniform mat4 CascadesShadowInvProj[8];
* - uniform mat4 CascadesShadowProj[8];
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform vec4 ChangeColor;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 CloudShadowsVisible;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ColorBased;
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 EmissiveUniform;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 GlintColor;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 HudOpacity;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MatColor;
* - uniform vec4 MetalnessUniform;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 NdLFloor;
* - uniform vec4 OverlayColor;
* - uniform vec4 PBRTextureFlags;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform vec4 PointLightPreCalcValues;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowAtlasResolution;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PreExposureEnabled;
* - uniform mat4 PrevBones[8];
* - uniform mat4 PrevWorld;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 RoughnessUniform;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SubsurfaceUniform;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 Time;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
* - uniform vec4 UndergroundFogColor;
* - uniform vec4 UseAlphaRewrite;
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

#extension GL_EXT_texture_cube_map_array : require
precision mediump float;
precision highp int;
struct VoxelNode {
    uint data;
};

const int var_7138c[64] = int[](-1, 2, 3, -1, 0, 6, 7, -1, 1, 10, 11, -1, -1, -1, -1, -1, 4, 14, 16, -1, 8, 18, 20, -1, 12, 22, 24, -1, -1, -1, -1, -1, 5, 15, 17, -1, 9, 19, 21, -1, 13, 23, 25, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
struct GpuVolumeEntry {
    int packed_xy;
    int packed_zw;
    int hash;
    int user_data;
};

const uvec3 var_d3b3e[8] = uvec3[](uvec3(0u, 0u, 1u), uvec3(0u, 0u, 1u), uvec3(0u, 1u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u), uvec3(1u, 0u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u));
const uvec3 var_4bf31[8] = uvec3[](uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(0u, 1u, 1u), uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 1u, 0u), uvec3(1u, 1u, 0u));
#ifdef POINT_LIGHT_SHADING__ON
struct Light {
    highp vec4 position;
    highp vec4 color;
    highp vec4 shadowFaceUV0;
    highp vec4 shadowFaceUV1;
    highp vec4 shadowFaceUV2;
    highp vec4 shadowFaceUV3;
    highp vec4 shadowFaceUV4;
    highp vec4 shadowFaceUV5;
};

struct LightData {
    highp float lookup;
};

int var_e7b23;
#endif
layout(binding = 12, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_8430b;
layout(binding = 11, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_e8ad9;
#ifdef POINT_LIGHT_SHADING__ON
layout(binding = 14, std430) buffer s_zLights { Light zLights[]; } var_5b96b;
layout(binding = 13, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_df38e;
#endif
uniform highp mat4 CascadesShadowInvProj[8];
uniform highp mat4 CascadesShadowProj[8];
uniform highp mat4 CloudShadowProj;
uniform highp mat4 PlayerShadowProj;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
#endif
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_model[4];
uniform highp mat4 u_proj;
uniform highp mat4 u_view;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2D s_MERSTexture;
uniform highp sampler2D s_MatTexture1;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_NormalTexture;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp sampler2D s_PointLightShadowTextureAtlas;
#endif
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_CausticsTexture;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 BlockLightColor;
uniform highp vec4 BlockLightIndirectSpecularIntensity;
uniform highp vec4 CameraAmbientContribution;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadesParameters[8];
uniform highp vec4 CascadesPerSet;
uniform highp vec4 CausticsParameters;
uniform highp vec4 CausticsTextureParameters;
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 CloudShadowsVisible;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ClusterDepthBounds;
uniform highp vec4 ClusterDimensions;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 ConvolutionType;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightSourceShadowDirection;
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection;
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 EmissiveUniform;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 GlintColor;
uniform highp vec4 GpuEntryBufferCapacity;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 LastSpecularIBLIdx;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ManhattanDistAttenuationEnabled;
#endif
uniform highp vec4 MatColor;
uniform highp vec4 MetalnessUniform;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 NdLFloor;
uniform highp vec4 OverlayColor;
uniform highp vec4 PBRTextureFlags;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightNdLFloor;
uniform highp vec4 PointLightPreCalcValues;
uniform highp vec4 PointLightShadowAtlasResolution;
uniform highp vec4 PointLightShadowParams1;
#endif
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 RoughnessUniform;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 SubsurfaceUniform;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 TileLightColor;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 UndergroundFogColor;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WorldOrigin;
in highp vec3 v_bitangent;
in highp vec4 v_color0;
in highp vec4 v_layerUv;
in highp vec3 v_normal;
in highp vec3 v_tangent;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_d29d7(inout highp vec3 arg_214af) {
    highp vec4 loc_df982 = textureLod(s_NormalTexture, v_texcoord0, 0.0);
    highp vec3 loc_c0132 = vec3(0.0, 0.0, 1.0);
    highp vec2 loc_17df5 = fract(v_texcoord0 * vec2(textureSize(s_NormalTexture, 0)));
    loc_c0132.x = (step(0.916666686534881591796875, loc_17df5.x) * ((loc_df982.y * 2.0) - 1.0)) + (step(loc_17df5.x, 0.083333335816860198974609375) * (1.0 - (loc_df982.w * 2.0)));
    loc_c0132.y = (step(0.916666686534881591796875, loc_17df5.y) * ((loc_df982.z * 2.0) - 1.0)) + (step(loc_17df5.y, 0.083333335816860198974609375) * (1.0 - (loc_df982.x * 2.0)));
    loc_c0132.x = step(0.004999999888241291046142578125, abs(loc_c0132.x)) * loc_c0132.x;
    loc_c0132.y = step(0.004999999888241291046142578125, abs(loc_c0132.y)) * loc_c0132.y;
    loc_c0132.z = 0.25;
    highp vec3 loc_da05a = normalize(loc_c0132);
    highp vec2 loc_34ed3 = loc_da05a.xy * 1.0;
    loc_c0132 = vec3(loc_34ed3.x, loc_34ed3.y, loc_da05a.z);
    arg_214af = loc_c0132;
}
void func_77c6e(inout int arg_f1e9d, inout highp vec3 arg_ef24f) {
    if ((arg_f1e9d & 4) == 4)
    {
        arg_ef24f = (texture(s_NormalTexture, v_texcoord0).xyz * 2.0) - vec3(1.0);
        return;
    }
    else
    {
        if ((arg_f1e9d & 8) == 8)
        {
            highp vec2 loc_ac6af = v_texcoord0;
            highp vec3 loc_e9363 = vec3(0.0, 0.0, 1.0);
            highp vec2 loc_2b303 = loc_ac6af;
            highp vec2 loc_4dc97 = loc_2b303 * vec2(textureSize(s_NormalTexture, 0));
            highp vec2 loc_700bf = fract(loc_4dc97);
            if (abs(loc_700bf.x - 0.5) < 0.0625)
            {
                loc_ac6af.x += ((loc_700bf.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
            }
            if (abs(loc_700bf.y - 0.5) < 0.0625)
            {
                loc_ac6af.y += ((loc_700bf.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
            }
            highp vec4 loc_fbe6c = textureGather(s_NormalTexture, loc_ac6af);
            highp vec2 loc_72024 = fract(loc_4dc97 + vec2(0.5));
            highp vec2 loc_2054b;
            if (loc_72024.y > 0.5)
            {
                loc_2054b = loc_fbe6c.xy;
            }
            else
            {
                loc_2054b = loc_fbe6c.wz;
            }
            highp vec2 loc_9b72d = loc_2054b;
            ivec2 loc_bde1e = ivec2(clamp(vec2(loc_72024.x - 0.083333335816860198974609375, loc_72024.x + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
            loc_e9363.x = loc_9b72d[loc_bde1e.x] - loc_9b72d[loc_bde1e.y];
            highp vec2 loc_d2f6f;
            if (loc_72024.x > 0.5)
            {
                loc_d2f6f = loc_fbe6c.zy;
            }
            else
            {
                loc_d2f6f = loc_fbe6c.wx;
            }
            loc_9b72d = loc_d2f6f;
            loc_bde1e = ivec2(clamp(vec2(loc_72024.y - 0.083333335816860198974609375, loc_72024.y + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
            loc_e9363.y = loc_9b72d[loc_bde1e.x] - loc_9b72d[loc_bde1e.y];
            loc_e9363.z = 0.25;
            highp vec3 loc_822b4 = normalize(loc_e9363);
            highp vec2 loc_63f25 = loc_822b4.xy * 1.0;
            loc_e9363 = vec3(loc_63f25.x, loc_63f25.y, loc_822b4.z);
            arg_ef24f = loc_e9363;
            return;
        }
        else
        {
            if ((arg_f1e9d & 16) == 16)
            {
                highp vec3 loc_f77cb;
                func_d29d7(loc_f77cb);
                arg_ef24f = loc_f77cb;
                return;
            }
        }
    }
    arg_ef24f = vec3(0.0, 0.0, 1.0);
}
void func_66b9c(inout highp vec3 arg_5a7d1, inout highp vec4 arg_37ddf) {
    if (ColorGrading_OptimizeGammaCorrection.x != 0.0)
    {
        arg_5a7d1 = pow(max(arg_37ddf.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
        return;
    }
    else
    {
        highp vec3 loc_be4c0 = arg_37ddf.xyz;
        highp vec3 loc_d634f = arg_37ddf.xyz * vec3(0.077399380505084991455078125);
        highp vec3 loc_1f157 = pow((arg_37ddf.xyz + vec3(0.054999999701976776123046875)) * vec3(0.947867333889007568359375), vec3(2.400000095367431640625));
        highp float loc_e81ff;
        if (loc_be4c0.x <= 0.040449999272823333740234375)
        {
            loc_e81ff = loc_d634f.x;
        }
        else
        {
            loc_e81ff = loc_1f157.x;
        }
        loc_be4c0.x = loc_e81ff;
        highp float loc_007b0;
        if (loc_be4c0.y <= 0.040449999272823333740234375)
        {
            loc_007b0 = loc_d634f.y;
        }
        else
        {
            loc_007b0 = loc_1f157.y;
        }
        loc_be4c0.y = loc_007b0;
        highp float loc_fa4a6;
        if (loc_be4c0.z <= 0.040449999272823333740234375)
        {
            loc_fa4a6 = loc_d634f.z;
        }
        else
        {
            loc_fa4a6 = loc_1f157.z;
        }
        loc_be4c0.z = loc_fa4a6;
        arg_5a7d1 = loc_be4c0;
        return;
    }
}
void func_0b88d(inout highp vec3 arg_3a8bb, inout highp float arg_13db0, inout highp vec4 arg_f7c69, inout highp float arg_7a26d) {
    highp vec4 loc_0024a = PlayerShadowProj * vec4(arg_3a8bb, 1.0);
    highp float loc_fcb6d = clamp(arg_13db0, arg_f7c69.x, 1.0);
    loc_0024a.z -= (CascadesParameters[0].y + (CascadesParameters[0].z * (sqrt(1.0 - (loc_fcb6d * loc_fcb6d)) / loc_fcb6d)));
    loc_0024a.z = min(loc_0024a.z, 1.0);
    int loc_ec55d = (QuantizationParameters.x != 0.0) ? 1 : 2;
    int loc_ed2e2 = loc_ec55d / 2;
    highp vec2 loc_a2590 = ((loc_0024a.xy * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    loc_a2590.y += (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    loc_0024a.z = (loc_0024a.z * 0.5) + 0.5;
    highp vec2 loc_8a24c = loc_a2590;
    highp vec2 loc_76046 = vec2(loc_8a24c.x, 1.0 - loc_8a24c.y);
    bool loc_2c837 = loc_76046.x >= 0.0;
    bool loc_d06e3;
    if (loc_2c837)
    {
        loc_d06e3 = loc_76046.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_d06e3 = loc_2c837;
    }
    bool loc_da85e;
    if (loc_d06e3)
    {
        loc_da85e = loc_76046.y >= 0.0;
    }
    else
    {
        loc_da85e = loc_d06e3;
    }
    bool loc_e80f2;
    if (loc_da85e)
    {
        loc_e80f2 = loc_76046.y < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_e80f2 = loc_da85e;
    }
    if (!loc_e80f2)
    {
        arg_7a26d = 1.0;
        return;
    }
    highp float loc_51c21 = dot(CascadesPerSet, vec4(1.0)) + 1.0;
    highp float loc_9af5f;
    loc_9af5f = 0.0;
    highp float loc_72f9e;
    for (int loc_467f0 = 0; loc_467f0 < loc_ec55d; loc_9af5f = loc_72f9e, loc_467f0++)
    {
        loc_72f9e = loc_9af5f;
        highp float loc_8daf8;
        for (int loc_02668 = 0; loc_02668 < loc_ec55d; loc_72f9e = loc_8daf8, loc_02668++)
        {
            highp vec2 loc_6d158 = loc_a2590 + ((vec2(float(loc_02668 - loc_ed2e2) + 0.5, float(loc_467f0 - loc_ed2e2) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            highp vec3 loc_f4800 = vec3(loc_6d158.x, loc_6d158.y, loc_51c21);
            if (QuantizationParameters.x != 0.0)
            {
                loc_8daf8 = loc_72f9e + float(textureLod(s_ShadowCascades, loc_f4800, 0.0).x >= loc_0024a.z);
            }
            else
            {
                highp vec4 loc_1f2f1 = step(vec4(loc_0024a.z), textureGather(s_ShadowCascades, loc_f4800));
                highp vec2 loc_127fb = fract((loc_f4800.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_8daf8 = loc_72f9e + mix(mix(loc_1f2f1.w, loc_1f2f1.z, loc_127fb.x), mix(loc_1f2f1.x, loc_1f2f1.y, loc_127fb.x), loc_127fb.y);
            }
        }
    }
    arg_7a26d = loc_9af5f / float(loc_ec55d * loc_ec55d);
}
void func_2c95e(inout highp vec3 arg_87514, inout highp vec3 arg_c03dc, inout highp vec3 arg_58fab, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_ae81a, inout highp float arg_fb1ed, inout highp vec3 arg_c7286, inout highp float arg_e0484, inout highp vec3 arg_08b90, inout highp vec3 arg_bcfb6, inout highp float arg_b14d8, inout highp float arg_67b92) {
    bool loc_10906 = DirectionalLightSkyLightHeuristicToggles.x != 0.0;
    bool loc_050e1;
    if (loc_10906)
    {
        loc_050e1 = abs(TileLightIntensity.y) < 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_050e1 = loc_10906;
    }
    if (loc_050e1)
    {
        arg_87514 = vec3(0.0);
        arg_c03dc = vec3(0.0);
        return;
    }
    highp float loc_0f714;
    highp float loc_f89fe;
    if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
    {
        highp float loc_05e4d = max(dot(arg_58fab, normalize((u_view * DirectionalLightSourceShadowDirection).xyz)), 0.0);
        highp vec3 loc_28854 = arg_adf73 + ((arg_c100b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_05e4d, 0.0, 1.0));
        int loc_933da = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
        highp float loc_b1e8b;
        highp float loc_84203;
        loc_84203 = 1.0;
        loc_b1e8b = 1.0;
        int loc_9517d;
        highp float loc_a77da;
        highp float loc_288b6;
        for (int loc_840b5 = 0, loc_8c11c = 0; loc_840b5 < loc_933da; loc_8c11c = loc_9517d, loc_84203 = loc_288b6, loc_b1e8b = loc_a77da, loc_840b5++)
        {
            int loc_3ddd0 = min((loc_8c11c + int(CascadesPerSet[loc_840b5])), 8);
            loc_288b6 = loc_84203;
            loc_a77da = loc_b1e8b;
            loc_9517d = loc_8c11c;
            int loc_620dd;
            highp float loc_ac3e2;
            highp float loc_6ac75;
            for (; loc_9517d < loc_3ddd0; loc_288b6 = loc_6ac75, loc_a77da = loc_ac3e2, loc_9517d = loc_620dd)
            {
                highp vec4 loc_03329 = CascadesShadowProj[loc_9517d] * vec4(loc_28854, 1.0);
                highp vec3 loc_f82b9 = abs(loc_03329.xyz);
                bool loc_54586 = loc_f82b9.x <= 1.0;
                bool loc_d55ba;
                if (loc_54586)
                {
                    loc_d55ba = loc_f82b9.y <= 1.0;
                }
                else
                {
                    loc_d55ba = loc_54586;
                }
                bool loc_18633;
                if (loc_d55ba)
                {
                    loc_18633 = loc_f82b9.z <= 1.0;
                }
                else
                {
                    loc_18633 = loc_d55ba;
                }
                if (loc_18633)
                {
                    highp vec4 loc_9a7eb = loc_03329;
                    highp vec4 loc_49c0e = NdLFloor;
                    highp float loc_34935 = clamp(loc_05e4d, loc_49c0e[loc_9517d], 1.0);
                    highp float loc_bac6a = CascadesParameters[loc_9517d].y + (CascadesParameters[loc_9517d].z * (sqrt(1.0 - (loc_34935 * loc_34935)) / loc_34935));
                    highp float loc_d3a5b = SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z * length(CascadesShadowInvProj[loc_9517d] * vec4(0.0, 0.0, 1.0, 0.0));
                    int loc_98038;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_98038 = 1;
                    }
                    else
                    {
                        loc_98038 = clamp(int(CascadesParameters[loc_9517d].w + 0.5), 1, 9);
                    }
                    int loc_960ef = loc_98038 / 2;
                    highp vec2 loc_81ff2 = ((loc_03329.xy * 0.5) + vec2(0.5)) * CascadesParameters[loc_9517d].x;
                    highp float loc_7263a = (loc_9a7eb.z * 0.5) + 0.5;
                    loc_81ff2.y += (1.0 - CascadesParameters[loc_9517d].x);
                    highp float loc_94392;
                    highp float loc_89b67;
                    loc_89b67 = 0.0;
                    loc_94392 = 0.0;
                    highp float loc_bb531;
                    highp float loc_c824b;
                    for (int loc_8ad4e = 0; loc_8ad4e < loc_98038; loc_89b67 = loc_c824b, loc_94392 = loc_bb531, loc_8ad4e++)
                    {
                        loc_c824b = loc_89b67;
                        loc_bb531 = loc_94392;
                        highp float loc_8794a;
                        highp float loc_befb6;
                        for (int loc_6a5e1 = 0; loc_6a5e1 < loc_98038; loc_c824b = loc_befb6, loc_bb531 = loc_8794a, loc_6a5e1++)
                        {
                            highp vec2 loc_3cc8b = loc_81ff2 + ((vec2(float(loc_6a5e1 - loc_960ef) + 0.5, float(loc_8ad4e - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_9517d].x);
                            highp vec4 loc_0c1b5 = textureGather(s_ShadowCascades, vec3(loc_3cc8b, float(loc_9517d)));
                            highp vec4 loc_1e988 = loc_0c1b5;
                            highp vec2 loc_89c3c = fract((loc_3cc8b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            highp vec4 loc_0edfa = vec4(1.0) - smoothstep(vec4(0.0), vec4(1.0), (vec4(loc_7263a) - loc_0c1b5) * loc_d3a5b);
                            highp vec2 loc_df6bc = loc_89c3c;
                            loc_8794a = loc_bb531 + mix(mix(loc_0edfa.w, loc_0edfa.z, loc_df6bc.x), mix(loc_0edfa.x, loc_0edfa.y, loc_df6bc.x), loc_df6bc.y);
                            if (QuantizationParameters.x != 0.0)
                            {
                                loc_befb6 = loc_c824b + float(loc_1e988.w >= (loc_7263a - loc_bac6a));
                            }
                            else
                            {
                                highp vec4 loc_6da26 = step(vec4(loc_7263a - loc_bac6a), loc_0c1b5);
                                highp vec2 loc_4ce21 = loc_89c3c;
                                loc_befb6 = loc_c824b + mix(mix(loc_6da26.w, loc_6da26.z, loc_4ce21.x), mix(loc_6da26.x, loc_6da26.y, loc_4ce21.x), loc_4ce21.y);
                            }
                        }
                    }
                    loc_6ac75 = min(loc_288b6, loc_94392 / float(loc_98038 * loc_98038));
                    loc_ac3e2 = min(loc_a77da, loc_89b67 / float(loc_98038 * loc_98038));
                    loc_620dd = loc_3ddd0;
                }
                else
                {
                    loc_6ac75 = loc_288b6;
                    loc_ac3e2 = loc_a77da;
                    loc_620dd = loc_9517d + 1;
                }
            }
        }
        highp float loc_55d77;
        if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
        {
            highp vec4 loc_a39dc = NdLFloor;
            highp float loc_80bb3;
            func_0b88d(loc_28854, loc_05e4d, loc_a39dc, loc_80bb3);
            loc_55d77 = loc_80bb3;
        }
        else
        {
            loc_55d77 = 1.0;
        }
        bool loc_77735 = int(CloudShadowsVisible.x) > 0;
        bool loc_b7d63;
        if (loc_77735)
        {
            loc_b7d63 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
        }
        else
        {
            loc_b7d63 = loc_77735;
        }
        highp float loc_80289;
        if (loc_b7d63)
        {
            highp vec4 loc_c8015 = NdLFloor;
            highp vec4 loc_8ad63 = CloudShadowProj * vec4(loc_28854, 1.0);
            highp vec4 loc_d3526 = loc_8ad63;
            loc_d3526 = loc_8ad63 / vec4(loc_d3526.w);
            highp float loc_12cc8 = clamp(loc_05e4d, loc_c8015.x, 1.0);
            loc_d3526.z -= ((CascadesParameters[0].y + (CascadesParameters[0].z * (sqrt(1.0 - (loc_12cc8 * loc_12cc8)) / loc_12cc8))) / loc_d3526.w);
            int loc_44da4;
            if (QuantizationParameters.x != 0.0)
            {
                loc_44da4 = 1;
            }
            else
            {
                loc_44da4 = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z + 0.5), 1, 9);
            }
            int loc_15bcb = loc_44da4 / 2;
            highp vec2 loc_38f48 = ((loc_d3526.xy * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
            loc_38f48.y += (1.0 - CascadesParameters[0].x);
            loc_d3526.z = (loc_d3526.z * 0.5) + 0.5;
            highp float loc_0e3bc = dot(CascadesPerSet, vec4(1.0));
            highp float loc_99071;
            loc_99071 = 0.0;
            highp float loc_894a5;
            for (int loc_5837b = 0; loc_5837b < loc_44da4; loc_99071 = loc_894a5, loc_5837b++)
            {
                loc_894a5 = loc_99071;
                highp float loc_003c8;
                for (int loc_e18e2 = 0; loc_e18e2 < loc_44da4; loc_894a5 = loc_003c8, loc_e18e2++)
                {
                    highp vec3 loc_53ff4 = vec3(loc_38f48 + ((vec2(float(loc_e18e2 - loc_15bcb) + 0.5, float(loc_5837b - loc_15bcb) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_0e3bc);
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_003c8 = loc_894a5 + float(textureLod(s_ShadowCascades, loc_53ff4, 0.0).x >= loc_d3526.z);
                    }
                    else
                    {
                        highp vec4 loc_bf06a = step(vec4(loc_d3526.z), textureGather(s_ShadowCascades, loc_53ff4));
                        highp vec2 loc_8d41d = fract((loc_53ff4.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                        loc_003c8 = loc_894a5 + mix(mix(loc_bf06a.w, loc_bf06a.z, loc_8d41d.x), mix(loc_bf06a.x, loc_bf06a.y, loc_8d41d.x), loc_8d41d.y);
                    }
                }
            }
            highp float loc_a9287 = loc_99071 / float(loc_44da4 * loc_44da4);
            highp float loc_1bbb8;
            if (loc_a9287 < 1.0)
            {
                loc_1bbb8 = min(1.0, max(loc_a9287, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
            }
            else
            {
                loc_1bbb8 = 1.0;
            }
            loc_80289 = loc_1bbb8;
        }
        else
        {
            loc_80289 = 1.0;
        }
        loc_f89fe = loc_84203;
        loc_0f714 = mix(min(loc_b1e8b, min(loc_55d77, loc_80289)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_ae81a.z));
    }
    else
    {
        loc_f89fe = 1.0;
        loc_0f714 = 1.0;
    }
    highp vec3 loc_52f44 = normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz);
    highp vec4 loc_32fad = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp vec3 loc_2c251 = ((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_32fad.w) * arg_fb1ed) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled.x;
    highp float loc_947b2 = max(dot(arg_58fab, loc_52f44), 0.0);
    highp float loc_fefd5 = max(dot(arg_58fab, arg_c7286), 0.0);
    highp float loc_d8782 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
    highp float loc_65d74 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
    highp vec3 loc_77b0a = normalize(loc_52f44 + arg_c7286);
    highp float loc_b831c = max(arg_e0484, 0.0500000007450580596923828125);
    highp float loc_009bf = loc_b831c * loc_b831c;
    highp float loc_3da81 = loc_009bf * loc_009bf;
    highp float loc_206e3 = max(dot(arg_58fab, loc_77b0a), 0.0);
    highp float loc_c16ab = (((loc_3da81 - 1.0) * loc_206e3) * loc_206e3) + 1.0;
    highp float loc_4fd72 = loc_009bf * 0.5;
    highp float loc_e86cf = clamp(1.0 - max(dot(arg_c7286, loc_77b0a), 0.0), 0.0, 1.0);
    highp float loc_9b2bc = loc_e86cf * loc_e86cf;
    highp vec3 loc_00b7f = arg_08b90 + ((vec3(1.0) - arg_08b90) * ((loc_9b2bc * loc_9b2bc) * loc_e86cf));
    highp vec3 loc_82e5e = arg_bcfb6 * (1.0 - arg_b14d8);
    arg_87514 = ((((((vec3(1.0) - loc_00b7f) * mix(loc_947b2, max((dot(arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_d8782 * loc_d8782), 0.0), arg_67b92)) * (loc_82e5e * vec3(0.3183098733425140380859375))) * loc_0f714) + (((loc_82e5e * vec3(0.3183098733425140380859375)) * (arg_67b92 * max((dot(-arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_65d74 * loc_65d74), 0.0))) * loc_f89fe)) * loc_2c251) * DiffuseSpecularEmissiveAmbientTermToggles.x;
    arg_c03dc = ((((((loc_00b7f * (loc_3da81 / ((loc_c16ab * loc_c16ab) * 3.1415927410125732421875))) * ((loc_fefd5 / (((loc_fefd5 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)) * (loc_947b2 / (((loc_947b2 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_947b2) * loc_fefd5) + 9.9999997473787516355514526367188e-05)) * loc_947b2) * loc_0f714) * loc_2c251) * DiffuseSpecularEmissiveAmbientTermToggles.y;
}
#ifdef POINT_LIGHT_SHADING__ON
void func_06412(inout highp vec3 arg_8d32a, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp vec3 loc_f1110 = arg_8d32a;
    highp vec3 loc_75f4e = ClusterDimensions.xyz;
    highp vec2 loc_7c1c9 = ClusterDepthBounds.xy;
    highp vec4 loc_c5992 = PointLightPreCalcValues;
    highp float loc_ac0eb = -loc_f1110.z;
    highp float loc_9e40d = loc_ac0eb * ClusterDepthBounds.z;
    highp float loc_fbce7 = loc_9e40d * ClusterDepthBounds.w;
    highp float loc_bee80;
    if (loc_ac0eb < loc_7c1c9.x)
    {
        loc_bee80 = 0.0;
    }
    else
    {
        highp float loc_a71e8;
        if (loc_ac0eb < loc_7c1c9.y)
        {
            loc_a71e8 = 1.0;
        }
        else
        {
            loc_a71e8 = min(floor(clamp((log2(loc_ac0eb) - loc_c5992.z) * loc_c5992.x, 0.0, 1.0) * (loc_75f4e.z - 2.0)) + 2.0, loc_75f4e.z - 1.0);
        }
        loc_bee80 = loc_a71e8;
    }
    highp vec3 loc_05e3f = vec3(min(floor(clamp((loc_f1110.x + loc_fbce7) / (2.0 * loc_fbce7), 0.0, 1.0) * loc_75f4e.x), loc_75f4e.x - 1.0), min(floor(clamp((loc_f1110.y + loc_9e40d) / (2.0 * loc_9e40d), 0.0, 1.0) * loc_75f4e.y), loc_75f4e.y - 1.0), loc_bee80);
    bool loc_ce27d = loc_05e3f.x < 0.0;
    bool loc_f15a5;
    if (!loc_ce27d)
    {
        loc_f15a5 = loc_05e3f.y < 0.0;
    }
    else
    {
        loc_f15a5 = loc_ce27d;
    }
    bool loc_7bab6;
    if (!loc_f15a5)
    {
        loc_7bab6 = loc_05e3f.z < 0.0;
    }
    else
    {
        loc_7bab6 = loc_f15a5;
    }
    bool loc_a526b;
    if (!loc_7bab6)
    {
        loc_a526b = loc_05e3f.x >= ClusterDimensions.x;
    }
    else
    {
        loc_a526b = loc_7bab6;
    }
    bool loc_6d7c9;
    if (!loc_a526b)
    {
        loc_6d7c9 = loc_05e3f.y >= ClusterDimensions.y;
    }
    else
    {
        loc_6d7c9 = loc_a526b;
    }
    bool loc_fc058;
    if (!loc_6d7c9)
    {
        loc_fc058 = loc_05e3f.z >= ClusterDimensions.z;
    }
    else
    {
        loc_fc058 = loc_6d7c9;
    }
    if (loc_fc058)
    {
        arg_e45b8 = var_e7b23;
        arg_fadf1 = var_e7b23;
        arg_d7f4c = false;
        return;
    }
    int loc_14533 = int((loc_05e3f.x + (loc_05e3f.y * ClusterDimensions.x)) + ((loc_05e3f.z * ClusterDimensions.x) * ClusterDimensions.y)) * int(ClusterDimensions.w);
    arg_e45b8 = loc_14533 + int(ClusterDimensions.w);
    arg_fadf1 = loc_14533;
    arg_d7f4c = true;
}
void func_daa30(inout int arg_7070b, inout highp float arg_43b7a, inout highp float arg_9499a, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c, inout highp float arg_77c90) {
    if (arg_7070b < 0)
    {
        arg_43b7a = 1.0;
        arg_9499a = 0.0;
        return;
    }
    highp vec3 loc_8868e = arg_aee55 - var_5b96b.zLights[arg_7070b].position.xyz;
    highp vec3 loc_8a9f7 = loc_8868e;
    highp vec3 loc_7c88a = abs(loc_8868e);
    bool loc_ab77c = loc_7c88a.x >= loc_7c88a.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_7c88a.x >= loc_7c88a.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    int loc_f3fad;
    if (loc_ca7f9)
    {
        loc_f3fad = (loc_8a9f7.x >= 0.0) ? 0 : 1;
    }
    else
    {
        int loc_1358b;
        if (loc_7c88a.y >= loc_7c88a.z)
        {
            loc_1358b = (loc_8a9f7.y >= 0.0) ? 2 : 3;
        }
        else
        {
            loc_1358b = (loc_8a9f7.z >= 0.0) ? 4 : 5;
        }
        loc_f3fad = loc_1358b;
    }
    highp vec4 loc_87a38 = var_5b96b.zLights[arg_7070b].shadowFaceUV0;
    highp vec3 loc_baa89;
    if (loc_f3fad == 1)
    {
        loc_87a38 = var_5b96b.zLights[arg_7070b].shadowFaceUV1;
        loc_baa89 = vec3(-loc_8a9f7.z, loc_8a9f7.y, loc_8a9f7.x);
    }
    else
    {
        highp vec3 loc_a4212;
        if (loc_f3fad == 2)
        {
            loc_87a38 = var_5b96b.zLights[arg_7070b].shadowFaceUV2;
            loc_a4212 = vec3(-loc_8a9f7.x, -loc_8a9f7.z, -loc_8a9f7.y);
        }
        else
        {
            highp vec3 loc_38505;
            if (loc_f3fad == 3)
            {
                loc_87a38 = var_5b96b.zLights[arg_7070b].shadowFaceUV3;
                loc_38505 = vec3(-loc_8a9f7.x, loc_8a9f7.z, loc_8a9f7.y);
            }
            else
            {
                highp vec3 loc_fd3cf;
                if (loc_f3fad == 4)
                {
                    loc_87a38 = var_5b96b.zLights[arg_7070b].shadowFaceUV4;
                    loc_fd3cf = vec3(-loc_8a9f7.x, loc_8a9f7.y, -loc_8a9f7.z);
                }
                else
                {
                    highp vec3 loc_0c356;
                    if (loc_f3fad == 5)
                    {
                        loc_87a38 = var_5b96b.zLights[arg_7070b].shadowFaceUV5;
                        loc_0c356 = vec3(loc_8a9f7.x, loc_8a9f7.y, loc_8a9f7.z);
                    }
                    else
                    {
                        loc_0c356 = vec3(loc_8a9f7.z, loc_8a9f7.y, -loc_8a9f7.x);
                    }
                    loc_fd3cf = loc_0c356;
                }
                loc_38505 = loc_fd3cf;
            }
            loc_a4212 = loc_38505;
        }
        loc_baa89 = loc_a4212;
    }
    bool loc_da9b7 = loc_87a38.z == 0.0;
    bool loc_20dc6;
    if (loc_da9b7)
    {
        loc_20dc6 = loc_87a38.w == 0.0;
    }
    else
    {
        loc_20dc6 = loc_da9b7;
    }
    if (loc_20dc6)
    {
        arg_43b7a = 1.0;
        arg_9499a = 0.0;
        return;
    }
    highp vec4 loc_6a946 = PointLightProj * vec4(loc_baa89, 1.0);
    highp float loc_ee959 = clamp(dot(normalize(-loc_8868e), normalize(arg_1111c)), PointLightNdLFloor.x, 1.0);
    loc_6a946.z -= ((PointLightShadowParams1.x + (PointLightShadowParams1.y * (sqrt(1.0 - (loc_ee959 * loc_ee959)) / loc_ee959))) * (PointLightShadowAtlasResolution.z / max((loc_87a38.z - loc_87a38.x) * PointLightShadowAtlasResolution.x, 1.0)));
    highp float loc_d799e = loc_6a946.w;
    highp vec4 loc_9858b = loc_6a946;
    highp vec4 loc_87f4b = loc_9858b / vec4(loc_d799e);
    loc_6a946 = loc_87f4b;
    highp vec2 loc_329bf = vec2(0.5) / PointLightShadowAtlasResolution.xy;
    highp vec2 loc_dbd7f = loc_87a38.zw - loc_87a38.xy;
    highp vec2 loc_4a8b9 = loc_dbd7f * PointLightShadowAtlasResolution.xy;
    highp float loc_ad7d9 = (textureLod(s_PointLightShadowTextureAtlas, clamp(loc_87a38.xy + (((floor(((loc_87f4b.xy * 0.5) + vec2(0.5)) * loc_4a8b9) + vec2(0.5)) / loc_4a8b9) * loc_dbd7f), loc_87a38.xy + loc_329bf, loc_87a38.zw - loc_329bf), 0.0).x * 2.0) - 1.0;
    highp float loc_591c8;
    if (loc_ad7d9 >= loc_6a946.z)
    {
        loc_591c8 = 1.0;
    }
    else
    {
        loc_591c8 = 0.0;
    }
    highp float loc_d7fd8;
    if (arg_77c90 > 0.0)
    {
        highp vec4 loc_932a9 = PointLightInvProj * vec4(loc_6a946.xy, loc_ad7d9, 1.0);
        highp vec4 loc_85f94 = loc_932a9;
        highp float loc_0585d = loc_85f94.w;
        highp vec3 loc_6d5dc = loc_932a9.xyz / vec3(loc_0585d);
        loc_85f94 = vec4(loc_6d5dc.x, loc_6d5dc.y, loc_6d5dc.z, loc_932a9.w);
        loc_d7fd8 = 1.0 - smoothstep(0.0, 1.0, (length(loc_baa89) - length(loc_6d5dc.xyz)) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z);
    }
    else
    {
        loc_d7fd8 = 1.0;
    }
    arg_43b7a = loc_d7fd8;
    arg_9499a = loc_591c8;
}
void func_dbe43(inout highp vec4 arg_e84ec, inout int arg_9327a, inout highp float arg_43b7a, inout highp float arg_7f337, inout highp vec3 arg_0a2b9, inout highp vec3 arg_f6a53, inout highp vec3 arg_4f9dc, inout highp float arg_8bccf) {
    arg_e84ec = vec4(0.0);
    if (arg_9327a < 0)
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp vec3 loc_a4b3e = var_5b96b.zLights[arg_9327a].position.xyz - v_worldPos;
    highp vec3 loc_8cb9b = loc_a4b3e;
    highp float loc_9eb1a;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_9eb1a = loc_1829d * loc_1829d;
    }
    else
    {
        loc_9eb1a = dot(loc_a4b3e, loc_a4b3e);
    }
    if (loc_9eb1a >= (var_5b96b.zLights[arg_9327a].position.w * var_5b96b.zLights[arg_9327a].position.w))
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp float loc_cddfe;
    highp float loc_a011d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_412fd;
        highp float loc_b2a04;
        func_daa30(arg_9327a, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_a011d = loc_b2a04;
        loc_cddfe = loc_412fd;
    }
    else
    {
        loc_a011d = 1.0;
        loc_cddfe = 1.0;
    }
    highp float loc_4c5a5 = loc_9eb1a / ((var_5b96b.zLights[arg_9327a].position.w * var_5b96b.zLights[arg_9327a].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_ef515 = clamp(1.0 - (loc_4c5a5 * loc_4c5a5), 0.0, 1.0);
    highp float loc_5f09f = (1.0 / max(loc_9eb1a, 0.100000001490116119384765625)) * (loc_ef515 * loc_ef515);
    highp float loc_219c5;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_219c5 = loc_5f09f * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_5f09f) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_219c5 = loc_5f09f;
    }
    if (loc_cddfe > 0.0)
    {
        highp vec3 loc_8226d = var_5b96b.zLights[arg_9327a].color.xyz * loc_219c5;
        arg_e84ec = vec4(loc_8226d.x, loc_8226d.y, loc_8226d.z, arg_e84ec.w);
        arg_e84ec.w = 1.0 - (loc_9eb1a / ((var_5b96b.zLights[arg_9327a].position.w * var_5b96b.zLights[arg_9327a].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_0a2b9 = (var_5b96b.zLights[arg_9327a].color.xyz * var_5b96b.zLights[arg_9327a].color.w) * loc_219c5;
}
void func_8c92a(inout highp vec3 arg_33c3b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec4 arg_fadf1, inout highp vec3 arg_efe4b, inout highp vec3 arg_81f79, inout highp float arg_d565c, inout highp vec3 arg_58ffc, inout highp vec3 arg_cff01, inout highp float arg_5416d, inout highp vec3 arg_5a8cd, inout highp vec3 arg_4fa31, inout highp float arg_9502a) {
    highp vec4 loc_a468d = vec4(0.0);
    bool loc_a0bb1;
    int loc_490eb;
    int loc_c476d;
    func_06412(arg_33c3b, loc_c476d, loc_490eb, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        arg_fadf1 = loc_a468d;
        return;
    }
    highp float loc_a55d6;
    highp vec3 loc_45a05;
    highp vec3 loc_b9311;
    loc_b9311 = vec3(0.0);
    loc_45a05 = vec3(0.0);
    loc_a55d6 = 0.0;
    highp float loc_96e3a;
    highp vec3 loc_50935;
    highp vec3 loc_bfd6d;
    highp vec4 loc_25712;
    for (int loc_86630 = loc_490eb; loc_86630 < loc_c476d; loc_b9311 = loc_bfd6d, loc_45a05 = loc_50935, loc_a55d6 = loc_96e3a, loc_86630++)
    {
        int loc_4d5d9 = int(var_df38e.zLightLookupArray[loc_86630].lookup);
        if (loc_4d5d9 < 0)
        {
            break;
        }
        highp vec3 loc_ed90f = normalize((u_view * vec4(var_5b96b.zLights[loc_4d5d9].position.xyz, 1.0)).xyz - arg_33c3b);
        highp float loc_1e1bf = max(dot(arg_efe4b, loc_ed90f), 0.0);
        highp float loc_af6fd = max(dot(arg_efe4b, arg_81f79), 0.0);
        highp float loc_2d61b = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp float loc_c20a0 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp vec3 loc_a125f = normalize(loc_ed90f + arg_81f79);
        highp float loc_a4858 = max(arg_d565c, 0.0500000007450580596923828125);
        highp float loc_a68f1 = loc_a4858 * loc_a4858;
        highp float loc_ad517 = loc_a68f1 * loc_a68f1;
        highp float loc_cd10e = max(dot(arg_efe4b, loc_a125f), 0.0);
        highp float loc_6be3a = (((loc_ad517 - 1.0) * loc_cd10e) * loc_cd10e) + 1.0;
        highp float loc_ad7fb = loc_a68f1 * 0.5;
        highp float loc_00ee9 = clamp(1.0 - max(dot(arg_81f79, loc_a125f), 0.0), 0.0, 1.0);
        highp float loc_a177b = loc_00ee9 * loc_00ee9;
        highp vec3 loc_d5257 = arg_58ffc + ((vec3(1.0) - arg_58ffc) * ((loc_a177b * loc_a177b) * loc_00ee9));
        highp vec3 loc_b92e1 = arg_cff01 * (1.0 - arg_5416d);
        highp vec4 loc_55c3a = vec4(0.0);
        highp vec3 loc_d62e4;
        highp float loc_39386;
        highp float loc_4feae;
        func_dbe43(loc_25712, loc_4d5d9, loc_4feae, loc_39386, loc_d62e4, arg_5a8cd, arg_4fa31, arg_9502a);
        loc_55c3a = loc_25712;
        highp vec3 loc_ef49b = loc_a468d.xyz + loc_25712.xyz;
        loc_a468d = vec4(loc_ef49b.x, loc_ef49b.y, loc_ef49b.z, loc_a468d.w);
        loc_96e3a = loc_a55d6 + loc_55c3a.w;
        loc_50935 = loc_45a05 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_9502a)) * (loc_b92e1 * vec3(0.3183098733425140380859375))) * loc_39386) + (((loc_b92e1 * vec3(0.3183098733425140380859375)) * (arg_9502a * max((dot(-arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_4feae)) * loc_d62e4) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_bfd6d = loc_b9311 + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_39386) * loc_d62e4) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    if (loc_a55d6 > 9.9999997473787516355514526367188e-05)
    {
        highp vec3 loc_70b77 = loc_a468d.xyz / vec3(loc_a55d6);
        loc_a468d = vec4(loc_70b77.x, loc_70b77.y, loc_70b77.z, loc_a468d.w);
        loc_a468d.w = clamp(loc_a55d6, 0.0, 1.0);
    }
    arg_534d1 = loc_45a05;
    arg_90b60 = loc_b9311;
    arg_fadf1 = loc_a468d;
}
void func_d7f93(inout highp vec3 arg_326b5, inout highp vec3 arg_179c6, inout highp vec3 arg_a0b83, inout highp vec3 arg_757dc, inout highp vec4 arg_d4ca2, inout highp vec3 arg_b40e7, inout highp vec3 arg_6f73b, inout highp vec3 arg_56f56, inout highp vec3 arg_9c753, inout highp float arg_a995c, inout highp vec3 arg_7e9dc, inout highp vec3 arg_4e72a, inout highp float arg_e9876, inout highp vec3 arg_602b8, inout highp float arg_15153) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0))
    {
        arg_326b5 = arg_179c6;
        arg_a0b83 = arg_757dc;
        arg_d4ca2 = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    highp vec3 loc_bd0c6;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_bd0c6 = arg_b40e7;
    }
    else
    {
        loc_bd0c6 = v_worldPos;
    }
    highp vec4 loc_750c4;
    highp vec3 loc_65e40;
    highp vec3 loc_bfc29;
    func_8c92a(arg_6f73b, loc_bfc29, loc_65e40, loc_750c4, arg_56f56, arg_9c753, arg_a995c, arg_7e9dc, arg_4e72a, arg_e9876, loc_bd0c6, arg_602b8, arg_15153);
    arg_326b5 = arg_179c6 + loc_bfc29;
    arg_a0b83 = arg_757dc + loc_65e40;
    arg_d4ca2 = loc_750c4;
}
#endif
void func_33953(inout uint arg_a601e, inout highp vec3 arg_aa7d7) {
    if (var_8430b.VoxelBuffer[arg_a601e].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_11fc1 = vec4(uvec4(var_8430b.VoxelBuffer[arg_a601e].data, var_8430b.VoxelBuffer[arg_a601e].data >> 8u, var_8430b.VoxelBuffer[arg_a601e].data >> 16u, var_8430b.VoxelBuffer[arg_a601e].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_11fc1;
    arg_aa7d7 = (loc_11fc1.xyz * loc_3ff2a.w) * 6.0;
}
void func_593c8(inout highp vec3 arg_ca7c6, inout highp vec3 arg_951a8, inout uint arg_2632b, inout highp vec3 arg_e5233) {
    highp vec3 loc_1815d = arg_ca7c6 - arg_951a8;
    int loc_fa0d5 = ((((int(loc_1815d.x < 0.0) | (int(loc_1815d.x >= 16.0) << 1)) | (int(loc_1815d.y < 0.0) << 2)) | (int(loc_1815d.y >= 16.0) << 3)) | (int(loc_1815d.z < 0.0) << 4)) | (int(loc_1815d.z >= 16.0) << 5);
    uint loc_58bb3;
    if (var_7138c[loc_fa0d5] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_ca7c6 - arg_951a8) & uvec3(15u);
        loc_58bb3 = arg_2632b + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        if (!((var_8430b.VoxelBuffer[arg_2632b + 4096u].data & (1u << uint(var_7138c[loc_fa0d5]))) != 0u))
        {
            arg_e5233 = vec3(0.0);
            return;
        }
        uvec3 loc_441ec = uvec3(arg_ca7c6 - (floor(arg_ca7c6 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_8430b.VoxelBuffer[(arg_2632b + 4097u) + uint(var_7138c[loc_fa0d5])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    highp vec3 loc_5d636;
    func_33953(loc_58bb3, loc_5d636);
    arg_e5233 = loc_5d636;
}
void func_f1037(inout highp vec3 arg_1c74c, inout highp float arg_19032, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec3 loc_31e57 = (arg_1c74c * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x;
    highp vec3 loc_cfa08 = mix(AmbientLightParams.xyz * AmbientLightParams.w, loc_31e57, vec3(clamp(dot(loc_31e57, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), 0.0, 1.0))) * arg_19032;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_cfa08, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_cfa08, 1.0);
}
void func_8d80e(inout highp vec3 arg_1c74c, inout highp float arg_19032, inout highp vec4 arg_85834) {
    highp vec3 loc_31e57 = (arg_1c74c * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x;
    highp vec3 loc_4c5f3 = mix(AmbientLightParams.xyz * AmbientLightParams.w, loc_31e57, vec3(clamp(dot(loc_31e57, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), 0.0, 1.0))) * arg_19032;
    if (0.0 >= dot(loc_4c5f3, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_4c5f3, 1.0);
}
void main() {
#ifdef MASKED_MULTITEXTURE__OFF
    highp vec4 var_2c432 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_ade26 = texture(s_MatTexture1, v_texcoord0);
#endif
#if defined(MASKED_MULTITEXTURE__OFF) && !defined(CHANGE_COLOR__MULTI)
    highp vec4 var_881ec = var_2c432;
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_76534 = var_ade26;
    highp vec4 var_2c432 = mix(var_ade26, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_76534.x + var_76534.y) + var_76534.z) * (1.0 - var_76534.w)) > 0.0)));
#endif
#ifdef CHANGE_COLOR__MULTI
    highp vec2 var_459de = var_2c432.xy;
    highp vec3 var_1099e = mix((var_2c432.xxx * ChangeColor.xyz).xyz, var_2c432.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_459de.y)));
    highp vec4 var_881ec = vec4(var_1099e.x, var_1099e.y, var_1099e.z, var_2c432.w);
#endif
#if defined(MASKED_MULTITEXTURE__ON) && !defined(CHANGE_COLOR__MULTI)
    highp vec4 var_881ec = var_2c432;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp vec3 var_fba6e = mix(var_2c432.xyz, var_2c432.xyz * ChangeColor.xyz, vec3(var_881ec.w));
    var_881ec = vec4(var_fba6e.x, var_fba6e.y, var_fba6e.z, var_2c432.w);
    var_881ec.w *= var_8a135.w;
#endif
    var_881ec.w = max(0.0, var_881ec.w);
    var_2c432 = var_881ec;
    highp vec4 var_2b5c5 = (GlintColor * (texture(s_MatTexture1, fract(v_layerUv.xy)).xyzx + texture(s_MatTexture1, fract(v_layerUv.zw)).xyzx)) * TileLightColor;
    highp vec4 var_44508 = vec4(var_2b5c5.xyz * var_2b5c5.xyz, abs(var_2b5c5.w)) + vec4(mix((var_881ec.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)), 0.0);
    var_44508.w = var_881ec.w;
    int var_cd3a0 = int(PBRTextureFlags.x);
    highp vec4 var_d5ac7 = var_44508;
    highp float var_55f80;
    highp float var_34635;
    highp float var_d0296;
    highp float var_6757b;
    if ((var_cd3a0 & 1) == 1)
    {
        highp vec4 var_4035b = texture(s_MERSTexture, v_texcoord0);
        highp float var_ae1fa;
        if ((var_cd3a0 & 2) == 2)
        {
            var_ae1fa = var_4035b.w;
        }
        else
        {
            var_ae1fa = SubsurfaceUniform.x;
        }
        var_6757b = var_ae1fa;
        var_d0296 = var_4035b.z;
        var_34635 = var_4035b.y;
        var_55f80 = var_4035b.x;
    }
    else
    {
        var_6757b = SubsurfaceUniform.x;
        var_d0296 = RoughnessUniform.x;
        var_34635 = EmissiveUniform.x;
        var_55f80 = MetalnessUniform.x;
    }
    bool var_dcea4 = (var_cd3a0 & 4) == 4;
    bool var_8642c;
    if (!var_dcea4)
    {
        var_8642c = (var_cd3a0 & 8) == 8;
    }
    else
    {
        var_8642c = var_dcea4;
    }
    bool var_088a3;
    if (!var_8642c)
    {
        var_088a3 = (var_cd3a0 & 16) == 16;
    }
    else
    {
        var_088a3 = var_8642c;
    }
    highp vec3 var_e89aa;
    if (var_088a3)
    {
        highp vec3 var_66208;
        func_77c6e(var_cd3a0, var_66208);
        var_e89aa = normalize(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(v_normal)) * var_66208);
    }
    else
    {
        var_e89aa = v_normal;
    }
    highp vec3 var_b8af5;
    func_66b9c(var_b8af5, var_44508);
    highp vec4 var_9f386 = u_view * (u_model[0] * vec4(v_worldPos, 1.0));
    highp vec4 var_e87e0 = u_proj * var_9f386;
    highp vec4 var_b8928 = var_e87e0;
    highp vec3 var_12830 = var_e87e0.xyz / vec3(var_b8928.w);
    highp vec3 var_b4b34 = normalize(var_e89aa);
    highp vec4 var_e14aa = vec4(var_b4b34, 0.0);
    highp vec3 var_0daae = var_9f386.xyz;
    highp vec3 var_219ab = v_worldPos - WorldOrigin.xyz;
    highp vec3 var_eebcb = dFdx(var_0daae);
    highp vec3 var_211c8 = dFdy(var_0daae);
    highp vec3 var_322a5 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(var_eebcb), normalize(var_211c8))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_fddd0 = vec3(QuantizationParameters.z * 0.5) - mod(var_219ab, vec3(QuantizationParameters.z));
    highp vec3 var_6aed3 = (var_219ab + (var_fddd0 - (var_322a5 * dot(var_fddd0, var_322a5)))) + WorldOrigin.xyz;
    highp vec3 var_62f02 = var_e14aa.xyz;
    highp vec3 var_cde66 = (u_view * var_e14aa).xyz;
    highp vec3 var_c1070 = vec3(0.039999999105930328369140625 * (1.0 - var_55f80)) + (var_b8af5 * var_55f80);
    highp vec3 var_f88c4 = BlockLightColor.xyz;
    highp vec3 var_691b9;
    if ((((var_f88c4.x + var_f88c4.y) + var_f88c4.z) < 9.9999997473787516355514526367188e-05) && (TileLightIntensity.x > 9.9999997473787516355514526367188e-05))
    {
        highp vec4 var_0bc6f = vec4(0.0);
        highp float var_88ce0 = TileLightIntensity.x * TileLightIntensity.x;
        var_691b9 = clamp(vec3(var_88ce0 + (var_0bc6f.x * var_0bc6f.w), (var_88ce0 * ((((var_88ce0 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.y * var_0bc6f.w), (var_88ce0 * (((var_88ce0 * var_88ce0) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.z * var_0bc6f.w)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_691b9 = BlockLightColor.xyz;
    }
    bool var_ff669 = CausticsParameters.x != 0.0;
    bool var_94c07;
    if (var_ff669)
    {
        var_94c07 = CausticsParameters.w != 0.0;
    }
    else
    {
        var_94c07 = var_ff669;
    }
    highp float var_b82c9;
    if (var_94c07)
    {
        var_b82c9 = pow((texture(s_CausticsTexture, vec3((v_worldPos - WorldOrigin.xyz).xz * CausticsParameters.y, CausticsTextureParameters.y)).x * 2.0) * clamp(var_b4b34.y, 0.0, 1.0), CausticsParameters.z) * (CausticsParameters.z + 1.0);
    }
    else
    {
        var_b82c9 = 1.0;
    }
    highp float var_995a5 = clamp(((TileLightIntensity.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_106e2 = length(var_0daae);
    highp vec3 var_5bd0a = var_12830;
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_02fd0;
#endif
    highp vec3 var_f5e5a;
    highp vec3 var_98bf2;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_9823f = -(var_0daae / vec3(length(var_0daae) + 9.9999997473787516355514526367188e-05));
        highp float var_11a4a = var_6757b * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
        highp vec3 var_6cfc2 = var_0daae;
        highp vec3 var_b5d88;
        if (int(QuantizationParameters.y) > 0)
        {
            var_b5d88 = var_6aed3;
        }
        else
        {
            var_b5d88 = v_worldPos;
        }
        highp vec3 var_357df;
        highp vec3 var_f6f76;
        func_2c95e(var_f6f76, var_357df, var_cde66, var_b5d88, var_62f02, var_6cfc2, var_b82c9, var_9823f, var_d0296, var_c1070, var_b8af5, var_55f80, var_11a4a);
#ifdef POINT_LIGHT_SHADING__ON
        highp vec4 var_05431;
        highp vec3 var_aae12;
        highp vec3 var_e318f;
        func_d7f93(var_e318f, var_f6f76, var_aae12, var_357df, var_05431, var_6aed3, var_0daae, var_cde66, var_9823f, var_d0296, var_c1070, var_b8af5, var_55f80, var_62f02, var_11a4a);
        var_98bf2 = var_e318f;
#endif
#ifdef POINT_LIGHT_SHADING__OFF
        var_98bf2 = var_f6f76;
        var_f5e5a = var_357df;
#endif
#ifdef POINT_LIGHT_SHADING__ON
        var_f5e5a = var_aae12;
        var_02fd0 = var_05431;
#endif
    }
    else
    {
        var_98bf2 = vec3(0.0);
        var_f5e5a = vec3(0.0);
#ifdef POINT_LIGHT_SHADING__ON
        var_02fd0 = vec4(0.0, 0.0, 0.0, 1.0);
#endif
    }
    highp vec3 var_a961d;
    if (DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled.w != 0.0)
    {
        highp vec3 var_6db9a = ((v_worldPos - WorldOrigin.xyz) - vec3(0.5)) + (var_62f02 * 0.20000000298023223876953125);
        ivec3 var_42d37 = ivec3(floor(var_6db9a));
        highp vec3 var_a4eaf = floor(var_6db9a * 0.0625) * 16.0;
        highp vec3 var_482e8 = var_6db9a - var_a4eaf;
        ivec4 var_984ab = ivec4((var_42d37 - (ivec3(15) & (var_42d37 >> ivec3(31)))) / ivec3(16), 0);
        ivec4 var_cff55 = var_984ab;
        int var_ab334 = (var_cff55.x & 65535) | (var_cff55.y << 16);
        int var_76717 = (var_cff55.z & 65535) | (var_cff55.w << 16);
        ivec4 var_4e614 = var_984ab;
        uint var_8af53 = uint(var_4e614.x) * 1540483477u;
        uint var_330d0 = uint(var_4e614.y) * 1540483477u;
        uint var_3870b = uint(var_4e614.z) * 1540483477u;
        uint var_30f73 = uint(var_4e614.w) * 1540483477u;
        uint var_5376d = ((((((2293326976u ^ ((var_8af53 ^ (var_8af53 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_330d0 ^ (var_330d0 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_3870b ^ (var_3870b >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_30f73 ^ (var_30f73 >> uint(24))) * 1540483477u);
        uint var_d02c9 = (var_5376d ^ (var_5376d >> uint(13))) * 1540483477u;
        uint var_15a6d = var_d02c9 ^ (var_d02c9 >> uint(15));
        uint var_c6bd0 = (var_15a6d ^ (var_15a6d >> uint(16))) & 65535u;
        uint var_19109 = var_c6bd0 | uint(var_c6bd0 == 0u);
        int var_d6224;
        uint var_3af73;
        bool var_87a71;
        uint var_8e0b6;
        var_8e0b6 = 0u;
        var_87a71 = false;
        var_3af73 = var_19109 & uint(GpuEntryBufferCapacity.x - 1.0);
        var_d6224 = 0;
        bool var_4f504;
        uint var_85325;
        uint var_e1ab1;
        uint var_79d95;
        bool var_a0c0a;
        for (;;)
        {
            if (var_d6224 < 8)
            {
                uint var_a70f2 = uint(var_e8ad9.GpuEntryBuffer[var_3af73].hash) & 65535u;
                bool var_734de = var_a70f2 == var_19109;
                bool var_e4213;
                if (var_734de)
                {
                    var_e4213 = var_e8ad9.GpuEntryBuffer[var_3af73].packed_xy == var_ab334;
                }
                else
                {
                    var_e4213 = var_734de;
                }
                bool var_ec5a7;
                if (var_e4213)
                {
                    var_ec5a7 = var_e8ad9.GpuEntryBuffer[var_3af73].packed_zw == var_76717;
                }
                else
                {
                    var_ec5a7 = var_e4213;
                }
                if (var_87a71)
                {
                    var_e1ab1 = var_8e0b6;
                }
                else
                {
                    uint var_5ebd4;
                    if (var_ec5a7)
                    {
                        var_5ebd4 = uint(var_e8ad9.GpuEntryBuffer[var_3af73].user_data);
                    }
                    else
                    {
                        var_5ebd4 = var_8e0b6;
                    }
                    var_e1ab1 = var_5ebd4;
                }
                var_4f504 = var_87a71 || var_ec5a7;
                var_85325 = (var_3af73 + 1u) & uint(GpuEntryBufferCapacity.x - 1.0);
                if (var_4f504 || (var_a70f2 == 0u))
                {
                    var_a0c0a = var_4f504;
                    var_79d95 = var_e1ab1;
                    break;
                }
                var_8e0b6 = var_e1ab1;
                var_87a71 = var_4f504;
                var_3af73 = var_85325;
                var_d6224++;
                continue;
            }
            else
            {
                var_a0c0a = var_87a71;
                var_79d95 = var_8e0b6;
                break;
            }
        }
        uint var_48fb0 = var_79d95 >> 2u;
        highp vec3 var_138a7;
        if (var_a0c0a)
        {
            highp vec3 var_2712f;
            if (any(greaterThanEqual(abs(var_62f02), vec3(1.0))))
            {
                highp vec3 var_c2195 = var_62f02;
                highp vec3 var_3e9f3 = abs(var_62f02);
                highp vec3 var_6de19 = var_3e9f3.zxy;
                highp vec3 var_7f629 = var_3e9f3.yzx;
                highp float var_c5cae = dot(var_482e8, var_3e9f3);
                highp float var_d19db = dot(var_482e8, var_6de19);
                highp float var_b9d4a = dot(var_482e8, var_7f629);
                highp float var_40c36;
                if (((var_c2195.x + var_c2195.y) + var_c2195.z) > 0.0)
                {
                    var_40c36 = ceil(var_c5cae);
                }
                else
                {
                    var_40c36 = floor(var_c5cae);
                }
                highp float var_2761e = floor(var_d19db);
                highp float var_3bdc3 = floor(var_b9d4a);
                highp vec3 var_d90d3 = ((var_3e9f3 * var_40c36) + (var_6de19 * var_2761e)) + (var_7f629 * var_3bdc3);
                highp vec3 var_1ab36 = var_d90d3 + var_6de19;
                highp vec3 var_6781d = var_d90d3 + var_7f629;
                highp vec3 var_72463 = (var_d90d3 + var_6de19) + var_7f629;
                highp float var_131e3 = var_d19db - var_2761e;
                highp float var_44acd = var_b9d4a - var_3bdc3;
                highp float var_84650 = 1.0 - var_131e3;
                highp float var_58c47 = 1.0 - var_44acd;
                highp vec4 var_5a263 = vec4(var_84650 * var_58c47, var_131e3 * var_58c47, var_84650 * var_44acd, var_131e3 * var_44acd);
                bool var_66a92 = all(greaterThanEqual(var_d90d3, vec3(0.0)));
                bool var_3aded;
                if (var_66a92)
                {
                    var_3aded = all(lessThan(var_72463, vec3(16.0)));
                }
                else
                {
                    var_3aded = var_66a92;
                }
                highp vec3 var_d70c9;
                highp vec3 var_40454;
                highp vec3 var_854dc;
                highp vec3 var_aa437;
                if (var_3aded)
                {
                    uvec3 var_35df1 = uvec3(var_d90d3);
                    uint var_ec371 = var_48fb0 + ((var_35df1.y + (var_35df1.z * 16u)) + (var_35df1.x * 256u));
                    highp vec3 var_02f5f;
                    func_33953(var_ec371, var_02f5f);
                    uvec3 var_7a0fb = uvec3(var_1ab36);
                    uint var_b0fec = var_48fb0 + ((var_7a0fb.y + (var_7a0fb.z * 16u)) + (var_7a0fb.x * 256u));
                    highp vec3 var_074d3;
                    func_33953(var_b0fec, var_074d3);
                    uvec3 var_0c6ec = uvec3(var_6781d);
                    uint var_9884e = var_48fb0 + ((var_0c6ec.y + (var_0c6ec.z * 16u)) + (var_0c6ec.x * 256u));
                    highp vec3 var_64c84;
                    func_33953(var_9884e, var_64c84);
                    uvec3 var_fa1c3 = uvec3(var_72463);
                    uint var_0ad06 = var_48fb0 + ((var_fa1c3.y + (var_fa1c3.z * 16u)) + (var_fa1c3.x * 256u));
                    highp vec3 var_6c0ad;
                    func_33953(var_0ad06, var_6c0ad);
                    var_aa437 = var_6c0ad;
                    var_854dc = var_64c84;
                    var_40454 = var_074d3;
                    var_d70c9 = var_02f5f;
                }
                else
                {
                    highp vec3 var_3e0cb = var_a4eaf + var_d90d3;
                    highp vec3 var_1f366;
                    func_593c8(var_3e0cb, var_a4eaf, var_48fb0, var_1f366);
                    highp vec3 var_99e8d = var_a4eaf + var_1ab36;
                    highp vec3 var_62cbe;
                    func_593c8(var_99e8d, var_a4eaf, var_48fb0, var_62cbe);
                    highp vec3 var_fe2fa = var_a4eaf + var_6781d;
                    highp vec3 var_f4cc9;
                    func_593c8(var_fe2fa, var_a4eaf, var_48fb0, var_f4cc9);
                    highp vec3 var_b8703 = var_a4eaf + var_72463;
                    highp vec3 var_c53e0;
                    func_593c8(var_b8703, var_a4eaf, var_48fb0, var_c53e0);
                    var_aa437 = var_c53e0;
                    var_854dc = var_f4cc9;
                    var_40454 = var_62cbe;
                    var_d70c9 = var_1f366;
                }
                var_2712f = (((var_d70c9 * var_5a263.x) + (var_40454 * var_5a263.y)) + (var_854dc * var_5a263.z)) + (var_aa437 * var_5a263.w);
            }
            else
            {
                highp vec3 var_81a55 = floor(var_482e8);
                highp vec3 var_8b514 = var_482e8 - var_81a55;
                int var_9a8fd = (int(var_8b514.x >= var_8b514.y) | (int(var_8b514.y >= var_8b514.z) << 1)) | (int(var_8b514.x >= var_8b514.z) << 2);
                uvec3 var_2256d = uvec3(var_81a55);
                highp float var_c8154 = min(var_8b514.x, var_8b514.y);
                highp float var_ed6ba = max(var_8b514.x, var_8b514.y);
                highp float var_6d122 = min(var_c8154, var_8b514.z);
                highp float var_f4126 = max(var_ed6ba, var_8b514.z);
                highp float var_46f74 = max(min(var_ed6ba, var_8b514.z), var_c8154);
                bool var_59db7 = all(greaterThanEqual(var_81a55, vec3(0.0)));
                bool var_64535;
                if (var_59db7)
                {
                    var_64535 = all(lessThan(var_81a55 + vec3(1.0), vec3(16.0)));
                }
                else
                {
                    var_64535 = var_59db7;
                }
                highp vec3 var_6d82c;
                highp vec3 var_5c15a;
                highp vec3 var_95cfd;
                highp vec3 var_e6f25;
                if (var_64535)
                {
                    uvec3 var_ac072 = var_2256d;
                    uint var_7c5b8 = var_48fb0 + ((var_ac072.y + (var_ac072.z * 16u)) + (var_ac072.x * 256u));
                    highp vec3 var_a7c87;
                    func_33953(var_7c5b8, var_a7c87);
                    uvec3 var_94f35 = var_2256d + var_d3b3e[var_9a8fd];
                    uint var_5a2ce = var_48fb0 + ((var_94f35.y + (var_94f35.z * 16u)) + (var_94f35.x * 256u));
                    highp vec3 var_26297;
                    func_33953(var_5a2ce, var_26297);
                    uvec3 var_12b35 = var_2256d + var_4bf31[var_9a8fd];
                    uint var_fc69d = var_48fb0 + ((var_12b35.y + (var_12b35.z * 16u)) + (var_12b35.x * 256u));
                    highp vec3 var_afebe;
                    func_33953(var_fc69d, var_afebe);
                    uvec3 var_7f762 = var_2256d + uvec3(1u);
                    uint var_9db6e = var_48fb0 + ((var_7f762.y + (var_7f762.z * 16u)) + (var_7f762.x * 256u));
                    highp vec3 var_b805f;
                    func_33953(var_9db6e, var_b805f);
                    var_e6f25 = var_b805f;
                    var_95cfd = var_afebe;
                    var_5c15a = var_26297;
                    var_6d82c = var_a7c87;
                }
                else
                {
                    highp vec3 var_32402 = var_a4eaf + var_81a55;
                    highp vec3 var_63155;
                    func_593c8(var_32402, var_a4eaf, var_48fb0, var_63155);
                    highp vec3 var_c6cf0 = var_a4eaf + (var_81a55 + vec3(var_d3b3e[var_9a8fd]));
                    highp vec3 var_e4550;
                    func_593c8(var_c6cf0, var_a4eaf, var_48fb0, var_e4550);
                    highp vec3 var_7a359 = var_a4eaf + (var_81a55 + vec3(var_4bf31[var_9a8fd]));
                    highp vec3 var_4add5;
                    func_593c8(var_7a359, var_a4eaf, var_48fb0, var_4add5);
                    highp vec3 var_3178f = var_a4eaf + (var_81a55 + vec3(1.0));
                    highp vec3 var_22f84;
                    func_593c8(var_3178f, var_a4eaf, var_48fb0, var_22f84);
                    var_e6f25 = var_22f84;
                    var_95cfd = var_4add5;
                    var_5c15a = var_e4550;
                    var_6d82c = var_63155;
                }
                var_2712f = (((var_6d82c * (1.0 - var_f4126)) + (var_5c15a * (var_f4126 - var_46f74))) + (var_95cfd * (var_46f74 - var_6d122))) + (var_e6f25 * var_6d122);
            }
            var_138a7 = var_2712f;
        }
        else
        {
            var_138a7 = vec3(0.0);
        }
        var_a961d = var_138a7;
    }
    else
    {
        var_a961d = var_691b9;
    }
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_b63c1 = var_02fd0;
#endif
    highp vec4 var_21a19 = SkyAmbientLightColorIntensity;
    highp float var_123aa = TileLightIntensity.y * TileLightIntensity.y;
    highp vec3 var_d4470 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
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
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_79b3e = clamp((((length(var_0daae) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_f6eb3;
        if (var_79b3e > 0.0)
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
                highp vec3 var_ddcf5 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3((var_070ce * var_070ce) * var_070ce)) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_a0aa2.w * (0.75 * ((var_99d92 * var_99d92) + 1.0))) + (var_ea036.w * (0.75 * ((var_b6eed * var_b6eed) + 1.0))))) + (((SkyHorizonColor.xyz * ((var_9281d * var_9281d) * var_9281d)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_a0aa2.w) * AtmosphericScattering.y) * var_824a6) * (0.0361000001430511474609375 / (var_3d1af * sqrt(var_3d1af)))) + ((((MoonColor.xyz * var_ea036.w) * AtmosphericScattering.z) * var_3b3ff) * (0.0361000001430511474609375 / (var_db5e0 * sqrt(var_db5e0))))));
                highp vec3 var_8b238;
                if (AtmosphericScatteringToggles.w != 0.0)
                {
                    var_8b238 = mix(UndergroundFogColor.xyz, var_ddcf5, vec3(max(CameraAmbientContribution.y, TileLightIntensity.y)));
                }
                else
                {
                    var_8b238 = var_ddcf5;
                }
                var_44083 = var_8b238;
            }
            var_f6eb3 = var_44083;
        }
        else
        {
            var_f6eb3 = vec3(0.0);
        }
        var_bdb1d = var_79b3e;
        var_1bb57 = var_f6eb3;
    }
    else
    {
        var_bdb1d = 0.0;
        var_1bb57 = vec3(0.0);
    }
    highp vec4 var_025c1 = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_0343d = var_025c1;
    highp vec4 var_a3223;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_115ba = (var_12830.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_12830, 1.0);
        highp float var_8cf8f = var_115ba.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_115ba.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_a3223 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_a3223 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_c88f4 = var_a3223;
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_12456 = var_a3223.xyz + (mix((((((var_b8af5 * (1.0 - var_55f80)) * max(((var_a961d + (var_02fd0.xyz * var_b63c1.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_123aa * var_123aa) * TileLightIntensity.y, (TileLightIntensity.y * TileLightIntensity.y) * TileLightIntensity.y, CameraLightIntensity.y)) * var_21a19.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_98bf2) + var_f5e5a) + (((mix(var_b8af5, vec3(dot(var_b8af5, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_34635)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_025c1.xyz, vec3(var_0343d.w)) * var_c88f4.w);
#endif
    highp vec3 var_082f4;
    if (IBLParameters.x != 0.0)
    {
        highp vec3 var_a8715;
        highp vec3 var_dd3fd;
        if (QuantizationParameters.w > 0.0)
        {
            var_dd3fd = (u_view * vec4(var_6aed3, 1.0)).xyz;
            var_a8715 = var_6aed3;
        }
        else
        {
            var_dd3fd = var_0daae;
            var_a8715 = v_worldPos;
        }
        highp vec3 var_a56d9 = reflect(normalize(var_a8715 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_62f02);
        highp float var_0f441;
        if (int(ConvolutionType.x) == 1)
        {
            highp float var_9a0e5 = 1.0 - var_d0296;
            var_0f441 = (1.0 - (var_9a0e5 * var_9a0e5)) * (IBLParameters.y - 1.0);
        }
        else
        {
            highp float var_c17b7 = 1.0 - var_d0296;
            highp float var_e5afa = var_c17b7 * var_c17b7;
            highp float var_d59d7 = var_e5afa * var_e5afa;
            var_0f441 = (1.0 - (var_d59d7 * var_d59d7)) * (IBLParameters.y - 1.0);
        }
        int var_ae27f = int(LastSpecularIBLIdx.x);
        highp vec3 var_67eb4 = mix(textureLod(s_SpecularIBLRecords, vec4(var_a56d9, float((var_ae27f + 2) % 3)), var_0f441).xyz, textureLod(s_SpecularIBLRecords, vec4(var_a56d9, float(var_ae27f)), var_0f441).xyz, vec3(IBLParameters.w));
        highp vec3 var_99477;
        if (PreExposureEnabled.x > 0.0)
        {
            var_99477 = var_67eb4 * vec3(301.72412109375);
        }
        else
        {
            var_99477 = var_67eb4;
        }
        highp vec3 var_713f8 = (var_99477 * (((var_995a5 * var_995a5) * var_995a5) * IBLParameters.x)) * IBLParameters.z;
        highp vec3 var_da3af;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec4 var_26642;
            func_f1037(var_691b9, var_55f80, var_713f8, var_26642);
            highp vec4 var_fb83f = var_26642;
            highp vec3 var_5279b;
            if (var_fb83f.w == 1.0)
            {
                var_5279b = var_26642.xyz;
            }
            else
            {
                var_5279b = var_713f8;
            }
            var_da3af = var_5279b;
        }
        else
        {
            var_da3af = var_713f8;
        }
        highp vec2 var_dea35 = vec2(clamp(dot(var_cde66, -normalize(var_dd3fd)), 0.0, 1.0), var_d0296);
        var_dea35.y = 1.0 - var_dea35.y;
        highp vec2 var_7d2be = texture(s_BrdfLUT, var_dea35).xy;
        highp vec3 var_fe0f6 = var_da3af * ((var_c1070 * var_7d2be.x) + vec3(var_7d2be.y));
        highp vec3 var_67472;
        if (AtmosphericScatteringToggles.x != 0.0)
        {
            var_67472 = var_fe0f6 * (1.0 - clamp((((var_106e2 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0));
        }
        else
        {
            var_67472 = var_fe0f6 * (1.0 - clamp((((var_106e2 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
        }
        highp vec3 var_0ffc6;
        if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
        {
            highp vec2 var_0a57b = VolumeNearFar.xy;
            highp vec2 var_9ec98 = (var_12830.xy + vec2(1.0)) * 0.5;
            highp vec4 var_197cc = u_invProj * vec4(var_12830, 1.0);
            highp float var_80ecf = var_9ec98.x;
            ivec3 var_1d618 = ivec3(VolumeDimensions.xyz);
            highp vec3 var_1dd8d = vec3(var_80ecf, var_9ec98.y, log((53.598148345947265625 * ((((-var_197cc.z) / var_197cc.w) - var_0a57b.x) / (var_0a57b.y - var_0a57b.x))) + 1.0) * 0.25);
            highp float var_372cd = (var_1dd8d.z * float(var_1d618.z)) - 0.5;
            int var_a3560 = clamp(int(var_372cd), 0, var_1d618.z - 2);
            highp vec4 var_af436 = mix(textureLod(s_ScatteringBuffer, vec3(var_80ecf, var_9ec98.y, float(var_a3560)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_80ecf, var_9ec98.y, float(var_a3560 + 1)), 0.0), vec4(clamp(var_372cd - float(var_a3560), 0.0, 1.0)));
            var_0ffc6 = var_67472 * var_af436.w;
        }
        else
        {
            var_0ffc6 = var_67472;
        }
        var_082f4 = var_0ffc6;
    }
    else
    {
        highp vec3 var_e2657;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec3 var_21df9;
            if (QuantizationParameters.w > 0.0)
            {
                var_21df9 = (u_view * vec4(var_6aed3, 1.0)).xyz;
            }
            else
            {
                var_21df9 = var_0daae;
            }
            highp vec4 var_da70a;
            func_8d80e(var_691b9, var_55f80, var_da70a);
            highp vec2 var_c297e = vec2(clamp(dot(var_cde66, -normalize(var_21df9)), 0.0, 1.0), var_d0296);
            var_c297e.y = 1.0 - var_c297e.y;
            highp vec2 var_864a0 = texture(s_BrdfLUT, var_c297e).xy;
            var_e2657 = var_da70a.xyz * ((var_c1070 * var_864a0.x) + vec3(var_864a0.y));
        }
        else
        {
            var_e2657 = vec3(0.0);
        }
        var_082f4 = var_e2657;
    }
#ifdef POINT_LIGHT_SHADING__OFF
    highp vec3 var_54609 = vec4(var_a3223.xyz + (mix((((((var_b8af5 * (1.0 - var_55f80)) * max((var_a961d * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_123aa * var_123aa) * TileLightIntensity.y, (TileLightIntensity.y * TileLightIntensity.y) * TileLightIntensity.y, CameraLightIntensity.y)) * var_21a19.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_98bf2) + var_f5e5a) + (((mix(var_b8af5, vec3(dot(var_b8af5, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_34635)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_025c1.xyz, vec3(var_0343d.w)) * var_c88f4.w), 1.0).xyz + var_082f4;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_54609 = vec4(var_12456, 1.0).xyz + var_082f4;
#endif
    highp vec3 var_d523d;
    if (PreExposureEnabled.x > 0.0)
    {
        var_d523d = var_54609 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_d523d = var_54609;
    }
    bgfx_FragData0 = vec4(var_d523d, var_d5ac7.w);
}
