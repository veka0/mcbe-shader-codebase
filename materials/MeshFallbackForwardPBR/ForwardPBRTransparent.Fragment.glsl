#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORWARD_PBR_ALPHA_TEST_PASS (not used)
* - FORWARD_PBR_OPAQUE_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED (not used)
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Lit:
* - LIT__OFF (not used)
* - LIT__ON (not used)
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF
* - POINT_LIGHT_SHADING__ON
*
* UseTextures:
* - USE_TEXTURES__OFF
* - USE_TEXTURES__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 8, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 9, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
* - layout(binding = 10, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 11, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightColor;
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
* - uniform vec4 CurrentColor;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 LightingEnabledAndAdaptiveEmissive;
* - uniform vec4 MERSUniforms;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform vec4 PointLightPreCalcValuesAndAmbientScalar;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowAtlasResolution;
* - uniform vec4 PointLightShadowParams1;
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
* - uniform vec4 TileLightIntensity;
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

#extension GL_EXT_texture_cube_map_array : require
precision mediump float;
precision highp int;
const int var_b7fc0[64] = int[](-1, 2, 3, -1, 0, 6, 7, -1, 1, 10, 11, -1, -1, -1, -1, -1, 4, 14, 16, -1, 8, 18, 20, -1, 12, 22, 24, -1, -1, -1, -1, -1, 5, 15, 17, -1, 9, 19, 21, -1, 13, 23, 25, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
struct VoxelNode {
    uint data;
};

const uint var_6af84[3] = uint[](4u, 2u, 1u);
const uint var_314ef[3] = uint[](240u, 204u, 170u);
struct GpuVolumeEntry {
    int packed_xy;
    int packed_zw;
    int hash;
    int user_data;
};

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
layout(binding = 9, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_25c07;
layout(binding = 8, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_e9065;
#ifdef POINT_LIGHT_SHADING__ON
layout(binding = 11, std430) buffer s_zLights { Light zLights[]; } var_b7e49;
layout(binding = 10, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_bbb90;
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
#ifdef USE_TEXTURES__ON
uniform highp sampler2D s_MatTexture;
#endif
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
uniform highp vec4 CloudShadowsVisible;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ClusterDepthBounds;
uniform highp vec4 ClusterDimensions;
#endif
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 ConvolutionType;
uniform highp vec4 CurrentColor;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightSourceShadowDirection;
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection;
uniform highp vec4 DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 GpuEntryBufferCapacity;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 LastSpecularIBLIdx;
uniform highp vec4 LightingEnabledAndAdaptiveEmissive;
uniform highp vec4 MERSUniforms;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ManhattanDistAttenuationEnabled;
#endif
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 NdLFloor;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightNdLFloor;
uniform highp vec4 PointLightPreCalcValuesAndAmbientScalar;
uniform highp vec4 PointLightShadowAtlasResolution;
uniform highp vec4 PointLightShadowParams1;
#endif
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 UndergroundFogColor;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WorldOrigin;
in highp vec4 v_color0;
in highp vec3 v_normal;
#ifdef USE_TEXTURES__ON
in highp vec2 v_texcoord0;
#endif
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
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
void func_64575(inout highp vec3 arg_87514, inout highp vec3 arg_c03dc, inout highp vec3 arg_58fab, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_ae81a, inout highp float arg_bfb77, inout highp vec3 arg_c7286, inout highp vec3 arg_08b90, inout highp vec3 arg_624d1, inout highp float arg_67b92) {
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
    if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.x) == 1)
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
        bool loc_34091;
        if (loc_77735)
        {
            loc_34091 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.y) > 0;
        }
        else
        {
            loc_34091 = loc_77735;
        }
        highp float loc_80289;
        if (loc_34091)
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
    highp vec4 loc_77e5a = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp vec3 loc_f0a2f = ((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_77e5a.w) * arg_bfb77) * DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled.x;
    highp float loc_947b2 = max(dot(arg_58fab, loc_52f44), 0.0);
    highp float loc_fefd5 = max(dot(arg_58fab, arg_c7286), 0.0);
    highp float loc_d8782 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
    highp float loc_65d74 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
    highp vec3 loc_77b0a = normalize(loc_52f44 + arg_c7286);
    highp float loc_da629 = max(MERSUniforms.z, 0.0500000007450580596923828125);
    highp float loc_009bf = loc_da629 * loc_da629;
    highp float loc_3da81 = loc_009bf * loc_009bf;
    highp float loc_206e3 = max(dot(arg_58fab, loc_77b0a), 0.0);
    highp float loc_c16ab = (((loc_3da81 - 1.0) * loc_206e3) * loc_206e3) + 1.0;
    highp float loc_4fd72 = loc_009bf * 0.5;
    highp float loc_e86cf = clamp(1.0 - max(dot(arg_c7286, loc_77b0a), 0.0), 0.0, 1.0);
    highp float loc_9b2bc = loc_e86cf * loc_e86cf;
    highp vec3 loc_00b7f = arg_08b90 + ((vec3(1.0) - arg_08b90) * ((loc_9b2bc * loc_9b2bc) * loc_e86cf));
    highp vec3 loc_cf738 = arg_624d1 * (1.0 - MERSUniforms.x);
    arg_87514 = ((((((vec3(1.0) - loc_00b7f) * mix(loc_947b2, max((dot(arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_d8782 * loc_d8782), 0.0), arg_67b92)) * (loc_cf738 * vec3(0.3183098733425140380859375))) * loc_0f714) + (((loc_cf738 * vec3(0.3183098733425140380859375)) * (arg_67b92 * max((dot(-arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_65d74 * loc_65d74), 0.0))) * loc_f89fe)) * loc_f0a2f) * DiffuseSpecularEmissiveAmbientTermToggles.x;
    arg_c03dc = ((((((loc_00b7f * (loc_3da81 / ((loc_c16ab * loc_c16ab) * 3.1415927410125732421875))) * ((loc_fefd5 / (((loc_fefd5 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)) * (loc_947b2 / (((loc_947b2 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_947b2) * loc_fefd5) + 9.9999997473787516355514526367188e-05)) * loc_947b2) * loc_0f714) * loc_f0a2f) * DiffuseSpecularEmissiveAmbientTermToggles.y;
}
#ifdef POINT_LIGHT_SHADING__ON
void func_e3b7a(inout highp vec3 arg_8d32a, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp vec3 loc_f1110 = arg_8d32a;
    highp vec3 loc_75f4e = ClusterDimensions.xyz;
    highp vec2 loc_7c1c9 = ClusterDepthBounds.xy;
    highp vec4 loc_21c5a = PointLightPreCalcValuesAndAmbientScalar;
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
            loc_a71e8 = min(floor(clamp((log2(loc_ac0eb) - loc_21c5a.z) * loc_21c5a.x, 0.0, 1.0) * (loc_75f4e.z - 2.0)) + 2.0, loc_75f4e.z - 1.0);
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
void func_e37a7(inout int arg_7070b, inout highp float arg_43b7a, inout highp float arg_9499a, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c, inout highp float arg_77c90) {
    if (arg_7070b < 0)
    {
        arg_43b7a = 1.0;
        arg_9499a = 0.0;
        return;
    }
    highp vec3 loc_8868e = arg_aee55 - var_b7e49.zLights[arg_7070b].position.xyz;
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
    highp vec4 loc_87a38 = var_b7e49.zLights[arg_7070b].shadowFaceUV0;
    highp vec3 loc_baa89;
    if (loc_f3fad == 1)
    {
        loc_87a38 = var_b7e49.zLights[arg_7070b].shadowFaceUV1;
        loc_baa89 = vec3(-loc_8a9f7.z, loc_8a9f7.y, loc_8a9f7.x);
    }
    else
    {
        highp vec3 loc_a4212;
        if (loc_f3fad == 2)
        {
            loc_87a38 = var_b7e49.zLights[arg_7070b].shadowFaceUV2;
            loc_a4212 = vec3(-loc_8a9f7.x, -loc_8a9f7.z, -loc_8a9f7.y);
        }
        else
        {
            highp vec3 loc_38505;
            if (loc_f3fad == 3)
            {
                loc_87a38 = var_b7e49.zLights[arg_7070b].shadowFaceUV3;
                loc_38505 = vec3(-loc_8a9f7.x, loc_8a9f7.z, loc_8a9f7.y);
            }
            else
            {
                highp vec3 loc_fd3cf;
                if (loc_f3fad == 4)
                {
                    loc_87a38 = var_b7e49.zLights[arg_7070b].shadowFaceUV4;
                    loc_fd3cf = vec3(-loc_8a9f7.x, loc_8a9f7.y, -loc_8a9f7.z);
                }
                else
                {
                    highp vec3 loc_0c356;
                    if (loc_f3fad == 5)
                    {
                        loc_87a38 = var_b7e49.zLights[arg_7070b].shadowFaceUV5;
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
        highp vec4 loc_cb0be = PointLightInvProj * vec4(loc_6a946.xy, loc_ad7d9, 1.0);
        highp vec4 loc_05114 = loc_cb0be;
        highp float loc_0585d = loc_05114.w;
        highp vec3 loc_af870 = loc_cb0be.xyz / vec3(loc_0585d);
        loc_05114.x = loc_af870.x;
        loc_05114.y = loc_af870.y;
        loc_05114.z = loc_af870.z;
        loc_d7fd8 = 1.0 - smoothstep(0.0, 1.0, (length(loc_baa89) - length(loc_05114.xyz)) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z);
    }
    else
    {
        loc_d7fd8 = 1.0;
    }
    arg_43b7a = loc_d7fd8;
    arg_9499a = loc_591c8;
}
void func_8e599(inout int arg_2f7cd, inout highp float arg_43b7a, inout highp float arg_7f337, inout highp vec3 arg_0a2b9, inout highp vec3 arg_f6a53, inout highp vec3 arg_4f9dc, inout highp float arg_8bccf) {
    if (arg_2f7cd < 0)
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp vec3 loc_a4b3e = var_b7e49.zLights[arg_2f7cd].position.xyz - v_worldPos;
    highp vec3 loc_8cb9b = loc_a4b3e;
    highp float loc_16a27;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_16a27 = loc_1829d * loc_1829d;
    }
    else
    {
        loc_16a27 = dot(loc_a4b3e, loc_a4b3e);
    }
    if (loc_16a27 >= (var_b7e49.zLights[arg_2f7cd].position.w * var_b7e49.zLights[arg_2f7cd].position.w))
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp float loc_a011d;
    highp float loc_22c1c;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0)
    {
        highp float loc_412fd;
        highp float loc_b2a04;
        func_e37a7(arg_2f7cd, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_22c1c = loc_b2a04;
        loc_a011d = loc_412fd;
    }
    else
    {
        loc_22c1c = 1.0;
        loc_a011d = 1.0;
    }
    highp float loc_4c5a5 = loc_16a27 / ((var_b7e49.zLights[arg_2f7cd].position.w * var_b7e49.zLights[arg_2f7cd].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_ef515 = clamp(1.0 - (loc_4c5a5 * loc_4c5a5), 0.0, 1.0);
    highp float loc_5f09f = (1.0 / max(loc_16a27, 0.100000001490116119384765625)) * (loc_ef515 * loc_ef515);
    highp float loc_ae18a;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_ae18a = loc_5f09f * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_5f09f) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_ae18a = loc_5f09f;
    }
    arg_43b7a = loc_22c1c;
    arg_7f337 = loc_a011d;
    arg_0a2b9 = (var_b7e49.zLights[arg_2f7cd].color.xyz * var_b7e49.zLights[arg_2f7cd].color.w) * loc_ae18a;
}
void func_47991(inout highp vec3 arg_33c3b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec3 arg_efe4b, inout highp vec3 arg_81f79, inout highp vec3 arg_58ffc, inout highp vec3 arg_28cf7, inout highp vec3 arg_3ec33, inout highp vec3 arg_8f7d6, inout highp float arg_a6fcb) {
    bool loc_a0bb1;
    int loc_5afa9;
    int loc_3379d;
    func_e3b7a(arg_33c3b, loc_3379d, loc_5afa9, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        return;
    }
    highp vec3 loc_15ce8;
    highp vec3 loc_728b6;
    loc_728b6 = vec3(0.0);
    loc_15ce8 = vec3(0.0);
    highp vec3 loc_334a8;
    highp vec3 loc_5937c;
    for (int loc_6165e = loc_5afa9; loc_6165e < loc_3379d; loc_728b6 = loc_5937c, loc_15ce8 = loc_334a8, loc_6165e++)
    {
        int loc_95ec7 = int(var_bbb90.zLightLookupArray[loc_6165e].lookup);
        if (loc_95ec7 < 0)
        {
            break;
        }
        highp vec3 loc_ed90f = normalize((u_view * vec4(var_b7e49.zLights[loc_95ec7].position.xyz, 1.0)).xyz - arg_33c3b);
        highp float loc_1e1bf = max(dot(arg_efe4b, loc_ed90f), 0.0);
        highp float loc_af6fd = max(dot(arg_efe4b, arg_81f79), 0.0);
        highp float loc_2d61b = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp float loc_c20a0 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp vec3 loc_a125f = normalize(loc_ed90f + arg_81f79);
        highp float loc_b8d72 = max(MERSUniforms.z, 0.0500000007450580596923828125);
        highp float loc_a68f1 = loc_b8d72 * loc_b8d72;
        highp float loc_ad517 = loc_a68f1 * loc_a68f1;
        highp float loc_cd10e = max(dot(arg_efe4b, loc_a125f), 0.0);
        highp float loc_6be3a = (((loc_ad517 - 1.0) * loc_cd10e) * loc_cd10e) + 1.0;
        highp float loc_ad7fb = loc_a68f1 * 0.5;
        highp float loc_00ee9 = clamp(1.0 - max(dot(arg_81f79, loc_a125f), 0.0), 0.0, 1.0);
        highp float loc_a177b = loc_00ee9 * loc_00ee9;
        highp vec3 loc_d5257 = arg_58ffc + ((vec3(1.0) - arg_58ffc) * ((loc_a177b * loc_a177b) * loc_00ee9));
        highp vec3 loc_97c67 = arg_28cf7 * (1.0 - MERSUniforms.x);
        highp vec3 loc_94598;
        highp float loc_f5fea;
        highp float loc_458ab;
        func_8e599(loc_95ec7, loc_458ab, loc_f5fea, loc_94598, arg_3ec33, arg_8f7d6, arg_a6fcb);
        loc_334a8 = loc_15ce8 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_a6fcb)) * (loc_97c67 * vec3(0.3183098733425140380859375))) * loc_f5fea) + (((loc_97c67 * vec3(0.3183098733425140380859375)) * (arg_a6fcb * max((dot(-arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_458ab)) * loc_94598) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_5937c = loc_728b6 + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_f5fea) * loc_94598) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_15ce8;
    arg_90b60 = loc_728b6;
}
void func_2c6bc(inout highp vec3 arg_4b291, inout highp vec3 arg_f72e9, inout highp vec3 arg_2f4d1, inout highp vec3 arg_cfcc4, inout highp vec3 arg_b40e7, inout highp vec3 arg_ae7d2, inout highp vec3 arg_5b5d0, inout highp vec3 arg_9b157, inout highp vec3 arg_e0647, inout highp vec3 arg_143ce, inout highp vec3 arg_f0682, inout highp float arg_83a2c) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0))
    {
        arg_4b291 = arg_f72e9;
        arg_2f4d1 = arg_cfcc4;
        return;
    }
    highp vec3 loc_46e35;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_46e35 = arg_b40e7;
    }
    else
    {
        loc_46e35 = v_worldPos;
    }
    highp vec3 loc_6c439;
    highp vec3 loc_a1ecc;
    func_47991(arg_ae7d2, loc_a1ecc, loc_6c439, arg_5b5d0, arg_9b157, arg_e0647, arg_143ce, loc_46e35, arg_f0682, arg_83a2c);
    arg_4b291 = arg_f72e9 + (loc_a1ecc * (1.0 - PointLightPreCalcValuesAndAmbientScalar.w));
    arg_2f4d1 = arg_cfcc4 + (loc_6c439 * (1.0 - PointLightPreCalcValuesAndAmbientScalar.w));
}
#endif
void func_fff8e(inout uint arg_45009, inout ivec3 arg_25482, inout uint arg_a965a, inout ivec3 arg_f7dc9) {
    uint loc_a0cb4 = (arg_45009 + 4123u) + ((uint(arg_25482.z - (-1)) * 18u) + uint(arg_25482.x - (-1)));
    uint loc_50d99 = loc_a0cb4 + 1u;
    bool loc_11974 = arg_25482.y >= 0;
    bool loc_6fa15;
    if (loc_11974)
    {
        loc_6fa15 = arg_25482.y < 15;
    }
    else
    {
        loc_6fa15 = loc_11974;
    }
    if (loc_6fa15)
    {
        uint loc_b118b = uint(arg_25482.y);
        uint loc_a385f = (var_25c07.VoxelBuffer[loc_a0cb4].data >> loc_b118b) & 3u;
        uint loc_95bf0 = ((var_25c07.VoxelBuffer[loc_a0cb4].data >> 16u) >> loc_b118b) & 3u;
        uint loc_6dacb = (var_25c07.VoxelBuffer[loc_50d99].data >> loc_b118b) & 3u;
        uint loc_f9969 = ((var_25c07.VoxelBuffer[loc_50d99].data >> 16u) >> loc_b118b) & 3u;
        arg_a965a = ((((loc_a385f & 1u) | ((loc_a385f & 2u) << 1u)) | (((loc_95bf0 & 1u) | ((loc_95bf0 & 2u) << 1u)) << 1u)) | (((loc_6dacb & 1u) | ((loc_6dacb & 2u) << 1u)) << 4u)) | (((loc_f9969 & 1u) | ((loc_f9969 & 2u) << 1u)) << 5u);
        return;
    }
    if (arg_25482.y < 0)
    {
        ivec3 loc_9596e = arg_f7dc9;
        uint loc_9e3a2 = (uint(loc_9596e.x - (-1)) * 18u) + uint(loc_9596e.z - (-1));
        uint loc_f2544 = loc_9e3a2 / 32u;
        uint loc_2dbd6 = loc_9e3a2 % 32u;
        uint loc_9766b = arg_45009 + 4429u;
        uint loc_a4225 = var_25c07.VoxelBuffer[loc_9766b + loc_f2544].data >> loc_2dbd6;
        uint loc_63c72;
        if (loc_2dbd6 > 12u)
        {
            loc_63c72 = loc_a4225 | (var_25c07.VoxelBuffer[(loc_9766b + loc_f2544) + 1u].data << (32u - loc_2dbd6));
        }
        else
        {
            loc_63c72 = loc_a4225;
        }
        uint loc_680e3 = (loc_63c72 & 3u) | ((loc_63c72 >> 16u) & 12u);
        uint loc_9a4d6 = (((var_25c07.VoxelBuffer[loc_a0cb4].data & 1u) | (((var_25c07.VoxelBuffer[loc_a0cb4].data >> 16u) & 1u) << 1u)) | ((var_25c07.VoxelBuffer[loc_50d99].data & 1u) << 2u)) | (((var_25c07.VoxelBuffer[loc_50d99].data >> 16u) & 1u) << 3u);
        arg_a965a = ((loc_680e3 & 3u) | ((loc_680e3 & 12u) << 2u)) | (((loc_9a4d6 & 3u) | ((loc_9a4d6 & 12u) << 2u)) << 2u);
        return;
    }
    uint loc_3413e = ((((var_25c07.VoxelBuffer[loc_a0cb4].data >> 15u) & 1u) | (((var_25c07.VoxelBuffer[loc_a0cb4].data >> 31u) & 1u) << 1u)) | (((var_25c07.VoxelBuffer[loc_50d99].data >> 15u) & 1u) << 2u)) | (((var_25c07.VoxelBuffer[loc_50d99].data >> 31u) & 1u) << 3u);
    ivec3 loc_f0131 = arg_f7dc9;
    uint loc_3a44a = (uint(loc_f0131.x - (-1)) * 18u) + uint(loc_f0131.z - (-1));
    uint loc_1d03f = loc_3a44a / 32u;
    uint loc_dcf35 = loc_3a44a % 32u;
    uint loc_38235 = arg_45009 + 4440u;
    uint loc_c3396 = var_25c07.VoxelBuffer[loc_38235 + loc_1d03f].data >> loc_dcf35;
    uint loc_f671b;
    if (loc_dcf35 > 12u)
    {
        loc_f671b = loc_c3396 | (var_25c07.VoxelBuffer[(loc_38235 + loc_1d03f) + 1u].data << (32u - loc_dcf35));
    }
    else
    {
        loc_f671b = loc_c3396;
    }
    uint loc_88411 = (loc_f671b & 3u) | ((loc_f671b >> 16u) & 12u);
    arg_a965a = ((loc_3413e & 3u) | ((loc_3413e & 12u) << 2u)) | (((loc_88411 & 3u) | ((loc_88411 & 12u) << 2u)) << 2u);
}
void func_93a41(inout uint arg_d6211, inout int arg_401db, inout highp vec3 arg_aa7d7) {
    if (var_25c07.VoxelBuffer[arg_d6211[arg_401db]].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_17ab1 = vec4(uvec4(var_25c07.VoxelBuffer[arg_d6211[arg_401db]].data, var_25c07.VoxelBuffer[arg_d6211[arg_401db]].data >> 8u, var_25c07.VoxelBuffer[arg_d6211[arg_401db]].data >> 16u, var_25c07.VoxelBuffer[arg_d6211[arg_401db]].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_17ab1;
    arg_aa7d7 = (loc_17ab1.xyz * loc_3ff2a.w) * 6.0;
}
void func_33953(inout uint arg_a601e, inout highp vec3 arg_aa7d7) {
    if (var_25c07.VoxelBuffer[arg_a601e].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_11fc1 = vec4(uvec4(var_25c07.VoxelBuffer[arg_a601e].data, var_25c07.VoxelBuffer[arg_a601e].data >> 8u, var_25c07.VoxelBuffer[arg_a601e].data >> 16u, var_25c07.VoxelBuffer[arg_a601e].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_11fc1;
    arg_aa7d7 = (loc_11fc1.xyz * loc_3ff2a.w) * 6.0;
}
void func_e0a6a(inout int arg_528e6, inout uint arg_2d77f, inout highp vec3 arg_534d1, inout highp vec3 arg_13804, inout highp vec3 arg_18a62, inout uint arg_92f3d) {
    bool loc_c7009 = var_b7fc0[arg_528e6] >= 0;
    bool loc_40b62;
    if (loc_c7009)
    {
        loc_40b62 = !((var_25c07.VoxelBuffer[arg_2d77f].data & (1u << uint(var_b7fc0[arg_528e6]))) != 0u);
    }
    else
    {
        loc_40b62 = loc_c7009;
    }
    if (loc_40b62)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    uint loc_58bb3;
    if (var_b7fc0[arg_528e6] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_13804 - arg_18a62) & uvec3(15u);
        loc_58bb3 = arg_92f3d + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        uvec3 loc_441ec = uvec3(arg_13804 - (floor(arg_13804 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_25c07.VoxelBuffer[(arg_92f3d + 4097u) + uint(var_b7fc0[arg_528e6])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    highp vec3 loc_5d636;
    func_33953(loc_58bb3, loc_5d636);
    arg_534d1 = loc_5d636;
}
void func_fc671(inout ivec3 arg_0f663, inout ivec3 arg_f5018, inout ivec3 arg_8bf68, inout ivec3 arg_9cf5c, inout uint arg_8b393, inout ivec3 arg_77cac, inout uint arg_e0e36, inout ivec3 arg_293d7, inout highp vec3 arg_69bef, inout highp vec3 arg_2f737, inout highp vec2 arg_53d93) {
    uvec3 loc_d3438 = uvec3(arg_0f663 - arg_f5018);
    uvec3 loc_a3b5a = loc_d3438;
    uvec3 loc_b95f1 = uvec3(arg_8bf68 - arg_f5018);
    uvec3 loc_f77e2 = loc_b95f1;
    uvec3 loc_459f4 = loc_d3438;
    uint loc_dfe3c = ((loc_459f4.x * 4u) + (loc_459f4.y * 2u)) + loc_459f4.z;
    uvec3 loc_de201 = loc_b95f1;
    uint loc_55d14 = ((loc_de201.x * 4u) + (loc_de201.y * 2u)) + loc_de201.z;
    uvec3 loc_94dfc = uvec3(abs(arg_f5018 - arg_9cf5c));
    uint loc_a7f5e = ((loc_94dfc.x * 4u) + (loc_94dfc.y * 2u)) + loc_94dfc.z;
    highp float loc_3cb02[4];
    loc_3cb02[0] = float((arg_8b393 & (1u << loc_a7f5e)) == 0u);
    loc_3cb02[1] = float((arg_8b393 & (1u << (loc_a7f5e ^ loc_dfe3c))) == 0u);
    loc_3cb02[2] = float((arg_8b393 & (1u << (loc_a7f5e ^ loc_55d14))) == 0u);
    loc_3cb02[3] = float((arg_8b393 & (1u << ((loc_a7f5e ^ loc_dfe3c) ^ loc_55d14))) == 0u);
    bool loc_eafd0 = all(greaterThanEqual(arg_f5018, ivec3(0)));
    bool loc_34d11;
    if (loc_eafd0)
    {
        loc_34d11 = all(lessThan(arg_77cac, ivec3(16)));
    }
    else
    {
        loc_34d11 = loc_eafd0;
    }
    highp vec3 loc_d5877[4];
    if (loc_34d11)
    {
        uint loc_c0464[4];
        loc_c0464[0] = arg_e0e36 + ((uint(arg_f5018.y) + (uint(arg_f5018.z) * 16u)) + (uint(arg_f5018.x) * 256u));
        loc_c0464[1] = loc_c0464[0] + ((loc_a3b5a.y + (loc_a3b5a.z * 16u)) + (loc_a3b5a.x * 256u));
        loc_c0464[2] = loc_c0464[0] + ((loc_f77e2.y + (loc_f77e2.z * 16u)) + (loc_f77e2.x * 256u));
        loc_c0464[3] = loc_c0464[1] + ((loc_f77e2.y + (loc_f77e2.z * 16u)) + (loc_f77e2.x * 256u));
        for (int loc_b61ea = 0; loc_b61ea < 4; loc_b61ea++)
        {
            highp vec3 loc_8d5d6;
            if (loc_3cb02[loc_b61ea] != 0.0)
            {
                highp vec3 loc_21cfc;
                func_93a41(loc_c0464, loc_b61ea, loc_21cfc);
                loc_8d5d6 = loc_21cfc;
            }
            else
            {
                loc_8d5d6 = vec3(0.0);
            }
            loc_d5877[loc_b61ea] = loc_8d5d6;
        }
    }
    else
    {
        uint loc_ac42f = arg_e0e36 + 4096u;
        for (int loc_3ddd4 = 0; loc_3ddd4 < 4; loc_3ddd4++)
        {
            loc_d5877[loc_3ddd4] = vec3(0.0);
            if (loc_3cb02[loc_3ddd4] != 0.0)
            {
                ivec3 loc_fe1d1[4] = arg_293d7;
                highp vec3 loc_13d2e = arg_69bef + vec3(loc_fe1d1[loc_3ddd4]);
                highp vec3 loc_d657b = loc_13d2e - arg_69bef;
                int loc_00371 = ((((int(loc_d657b.x < 0.0) | (int(loc_d657b.x >= 16.0) << 1)) | (int(loc_d657b.y < 0.0) << 2)) | (int(loc_d657b.y >= 16.0) << 3)) | (int(loc_d657b.z < 0.0) << 4)) | (int(loc_d657b.z >= 16.0) << 5);
                highp vec3 loc_83d45;
                func_e0a6a(loc_00371, loc_ac42f, loc_83d45, loc_13d2e, arg_69bef, arg_e0e36);
                loc_d5877[loc_3ddd4] = loc_83d45;
            }
        }
    }
    if ((((loc_3cb02[0] + loc_3cb02[1]) + loc_3cb02[2]) + loc_3cb02[3]) >= 4.0)
    {
        arg_2f737 = mix(mix(loc_d5877[0], loc_d5877[1], vec3(arg_53d93.x)), mix(loc_d5877[2], loc_d5877[3], vec3(arg_53d93.x)), vec3(arg_53d93.y));
        return;
    }
    highp float loc_5b627 = ((1.0 - arg_53d93.x) * (1.0 - arg_53d93.y)) * loc_3cb02[0];
    highp float loc_7da39 = (arg_53d93.x * (1.0 - arg_53d93.y)) * loc_3cb02[1];
    highp float loc_cb7e2 = ((1.0 - arg_53d93.x) * arg_53d93.y) * loc_3cb02[2];
    highp float loc_345a0 = (arg_53d93.x * arg_53d93.y) * loc_3cb02[3];
    highp float loc_5bc00 = ((loc_5b627 + loc_7da39) + loc_cb7e2) + loc_345a0;
    highp vec3 loc_925af;
    if (loc_5bc00 > 0.0)
    {
        loc_925af = ((((loc_d5877[0] * loc_5b627) + (loc_d5877[1] * loc_7da39)) + (loc_d5877[2] * loc_cb7e2)) + (loc_d5877[3] * loc_345a0)) / vec3(loc_5bc00);
    }
    else
    {
        loc_925af = vec3(0.0);
    }
    arg_2f737 = loc_925af;
}
void func_2ab53(inout int arg_689f7, inout highp vec3 arg_534d1, inout highp vec3 arg_13804, inout highp vec3 arg_18a62, inout uint arg_92f3d) {
    bool loc_c7009 = var_b7fc0[arg_689f7] >= 0;
    bool loc_e4976;
    if (loc_c7009)
    {
        loc_e4976 = true;
    }
    else
    {
        loc_e4976 = loc_c7009;
    }
    if (loc_e4976)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    uint loc_58bb3;
    if (var_b7fc0[arg_689f7] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_13804 - arg_18a62) & uvec3(15u);
        loc_58bb3 = arg_92f3d + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        uvec3 loc_441ec = uvec3(arg_13804 - (floor(arg_13804 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_25c07.VoxelBuffer[(arg_92f3d + 4097u) + uint(var_b7fc0[arg_689f7])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    highp vec3 loc_5d636;
    func_33953(loc_58bb3, loc_5d636);
    arg_534d1 = loc_5d636;
}
void func_ec180(inout int arg_eae48, inout uint arg_ccc49, inout highp vec3 arg_534d1, inout highp vec3 arg_13804, inout highp vec3 arg_18a62) {
    bool loc_c7009 = var_b7fc0[arg_eae48] >= 0;
    bool loc_aa1a7;
    if (loc_c7009)
    {
        loc_aa1a7 = !((var_25c07.VoxelBuffer[arg_ccc49 + 4096u].data & (1u << uint(var_b7fc0[arg_eae48]))) != 0u);
    }
    else
    {
        loc_aa1a7 = loc_c7009;
    }
    if (loc_aa1a7)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    uint loc_58bb3;
    if (var_b7fc0[arg_eae48] < 0)
    {
        uvec3 loc_1af67 = uvec3(arg_13804 - arg_18a62) & uvec3(15u);
        loc_58bb3 = arg_ccc49 + ((loc_1af67.y + (loc_1af67.z * 16u)) + (loc_1af67.x * 256u));
    }
    else
    {
        uvec3 loc_441ec = uvec3(arg_13804 - (floor(arg_13804 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_25c07.VoxelBuffer[(arg_ccc49 + 4097u) + uint(var_b7fc0[arg_eae48])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    highp vec3 loc_5d636;
    func_33953(loc_58bb3, loc_5d636);
    arg_534d1 = loc_5d636;
}
void func_a3588(inout highp vec3 arg_a5dcd, inout highp vec3 arg_6139f, inout uint arg_75c69, inout highp vec3 arg_fadf1) {
    highp vec3 loc_1815d = arg_a5dcd - arg_6139f;
    int loc_dfc70 = ((((int(loc_1815d.x < 0.0) | (int(loc_1815d.x >= 16.0) << 1)) | (int(loc_1815d.y < 0.0) << 2)) | (int(loc_1815d.y >= 16.0) << 3)) | (int(loc_1815d.z < 0.0) << 4)) | (int(loc_1815d.z >= 16.0) << 5);
    if (var_b7fc0[loc_dfc70] < 0)
    {
        highp vec3 loc_27904;
        func_2ab53(loc_dfc70, loc_27904, arg_a5dcd, arg_6139f, arg_75c69);
        arg_fadf1 = loc_27904;
        return;
    }
    highp vec3 loc_08e85;
    func_ec180(loc_dfc70, arg_75c69, loc_08e85, arg_a5dcd, arg_6139f);
    arg_fadf1 = loc_08e85;
}
void func_269a6(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_924f2, inout uint arg_85962, inout ivec3 arg_5357c, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_02a32 = uvec3(arg_924f2);
        uint loc_e0607 = arg_85962 + ((loc_02a32.y + (loc_02a32.z * 16u)) + (loc_02a32.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_19b2e = vec3(arg_5357c);
    highp vec3 loc_45361;
    func_a3588(loc_19b2e, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_87677(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_283b9, inout uint arg_85962, inout ivec3 arg_438a8, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_ed900 = uvec3(arg_283b9 + ivec3(0, 0, 1));
        uint loc_e0607 = arg_85962 + ((loc_ed900.y + (loc_ed900.z * 16u)) + (loc_ed900.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_492df = vec3(arg_438a8 + ivec3(0, 0, 1));
    highp vec3 loc_45361;
    func_a3588(loc_492df, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_8e24a(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_5cd5c, inout uint arg_85962, inout ivec3 arg_6dd6f, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_9117a = uvec3(arg_5cd5c + ivec3(0, 1, 0));
        uint loc_e0607 = arg_85962 + ((loc_9117a.y + (loc_9117a.z * 16u)) + (loc_9117a.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_bcb98 = vec3(arg_6dd6f + ivec3(0, 1, 0));
    highp vec3 loc_45361;
    func_a3588(loc_bcb98, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_fd360(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_6740d, inout uint arg_85962, inout ivec3 arg_b3829, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_e4e26 = uvec3(arg_6740d + ivec3(0, 1, 1));
        uint loc_e0607 = arg_85962 + ((loc_e4e26.y + (loc_e4e26.z * 16u)) + (loc_e4e26.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_d9067 = vec3(arg_b3829 + ivec3(0, 1, 1));
    highp vec3 loc_45361;
    func_a3588(loc_d9067, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_0b7c2(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_ce1e5, inout uint arg_85962, inout ivec3 arg_a834e, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_388a8 = uvec3(arg_ce1e5 + ivec3(1, 0, 0));
        uint loc_e0607 = arg_85962 + ((loc_388a8.y + (loc_388a8.z * 16u)) + (loc_388a8.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_79192 = vec3(arg_a834e + ivec3(1, 0, 0));
    highp vec3 loc_45361;
    func_a3588(loc_79192, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_dcccf(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_90312, inout uint arg_85962, inout ivec3 arg_ab946, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_c1e8b = uvec3(arg_90312 + ivec3(1, 0, 1));
        uint loc_e0607 = arg_85962 + ((loc_c1e8b.y + (loc_c1e8b.z * 16u)) + (loc_c1e8b.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_e60d2 = vec3(arg_ab946 + ivec3(1, 0, 1));
    highp vec3 loc_45361;
    func_a3588(loc_e60d2, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_70277(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_5d8a7, inout uint arg_85962, inout ivec3 arg_a0082, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_5483e = uvec3(arg_5d8a7 + ivec3(1, 1, 0));
        uint loc_e0607 = arg_85962 + ((loc_5483e.y + (loc_5483e.z * 16u)) + (loc_5483e.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_f1e40 = vec3(arg_a0082 + ivec3(1, 1, 0));
    highp vec3 loc_45361;
    func_a3588(loc_f1e40, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_e43d6(inout highp float arg_40206, inout highp vec3 arg_e2a96, inout bool arg_f01ae, inout ivec3 arg_eefc1, inout uint arg_85962, inout ivec3 arg_3528f, inout highp vec3 arg_8532d) {
    if (arg_40206 == 0.0)
    {
        arg_e2a96 = vec3(0.0);
        return;
    }
    if (arg_f01ae)
    {
        uvec3 loc_8b407 = uvec3(arg_eefc1 + ivec3(1));
        uint loc_e0607 = arg_85962 + ((loc_8b407.y + (loc_8b407.z * 16u)) + (loc_8b407.x * 256u));
        highp vec3 loc_bf963;
        func_33953(loc_e0607, loc_bf963);
        arg_e2a96 = loc_bf963;
        return;
    }
    highp vec3 loc_8f72a = vec3(arg_3528f + ivec3(1));
    highp vec3 loc_45361;
    func_a3588(loc_8f72a, arg_8532d, arg_85962, loc_45361);
    arg_e2a96 = loc_45361;
}
void func_045b4(inout highp vec4 arg_d4081, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec3 loc_10831 = (arg_d4081.xyz * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x;
    highp vec3 loc_d5030 = mix(AmbientLightParams.xyz * AmbientLightParams.w, loc_10831, vec3(clamp(dot(loc_10831, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), 0.0, 1.0))) * MERSUniforms.x;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_d5030, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_d5030, 1.0);
}
void func_8822c(inout highp vec4 arg_d4081, inout highp vec4 arg_85834) {
    highp vec3 loc_10831 = (arg_d4081.xyz * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x;
    highp vec3 loc_09a3f = mix(AmbientLightParams.xyz * AmbientLightParams.w, loc_10831, vec3(clamp(dot(loc_10831, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), 0.0, 1.0))) * MERSUniforms.x;
    if (0.0 >= dot(loc_09a3f, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_09a3f, 1.0);
}
void main() {
#ifdef USE_TEXTURES__OFF
    highp vec4 var_a97d3 = vec4(1.0);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_a97d3 = texture(s_MatTexture, v_texcoord0);
#endif
    if (var_a97d3.w < 0.5)
    {
        discard;
    }
    highp vec4 var_a2360 = var_a97d3;
    highp vec4 var_705a1 = var_a2360 * CurrentColor;
    var_a97d3 = var_705a1;
    highp vec3 var_48376 = var_705a1.xyz * v_color0.xyz;
    highp vec3 var_c082c;
    func_9b87e(var_c082c, var_48376);
    highp vec3 var_3152e;
    if (LightingEnabledAndAdaptiveEmissive.x > 0.0)
    {
        highp vec4 var_69dd9 = u_view * (u_model[0] * vec4(v_worldPos, 1.0));
        highp vec4 var_72c59 = u_proj * var_69dd9;
        highp vec4 var_3ab6f = var_72c59;
        highp vec3 var_06188 = var_72c59.xyz / vec3(var_3ab6f.w);
        highp vec3 var_553af = normalize(v_normal);
        highp vec4 var_12f51 = vec4(var_553af, 0.0);
        highp vec3 var_c33e7 = var_69dd9.xyz;
        highp vec3 var_3da14 = v_worldPos - WorldOrigin.xyz;
        highp vec3 var_f32a5 = dFdx(var_c33e7);
        highp vec3 var_a4ce1 = dFdy(var_c33e7);
        highp vec3 var_a2136 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(var_f32a5), normalize(var_a4ce1))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
        highp vec3 var_4a875 = vec3(QuantizationParameters.z * 0.5) - mod(var_3da14, vec3(QuantizationParameters.z));
        highp vec3 var_9d060 = (var_3da14 + (var_4a875 - (var_a2136 * dot(var_4a875, var_a2136)))) + WorldOrigin.xyz;
        highp vec3 var_63d4c = var_12f51.xyz;
        highp vec3 var_7a301 = (u_view * var_12f51).xyz;
        highp vec3 var_927c7 = normalize(v_normal);
        bvec3 var_3ddac = greaterThanEqual(abs(var_927c7), vec3(0.9900000095367431640625));
        highp vec3 var_619e6 = vec3(ivec3(any(lessThan(var_927c7, vec3(-0.5))) ? (-1) : 1) * ivec3(int(var_3ddac.x), int(var_3ddac.y), int(var_3ddac.z)));
        highp vec3 var_3cefc = vec3(0.039999999105930328369140625 * (1.0 - MERSUniforms.x)) + (var_c082c * MERSUniforms.x);
        highp vec3 var_e7427 = BlockLightColor.xyz;
        highp vec3 var_afb0f;
        if ((((var_e7427.x + var_e7427.y) + var_e7427.z) < 9.9999997473787516355514526367188e-05) && (TileLightIntensity.x > 9.9999997473787516355514526367188e-05))
        {
            highp float var_4b9df = TileLightIntensity.x * TileLightIntensity.x;
            var_afb0f = clamp(vec3(var_4b9df, var_4b9df * ((((var_4b9df * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625), var_4b9df * (((var_4b9df * var_4b9df) * 0.60000002384185791015625) + 0.4000000059604644775390625)), vec3(0.0), vec3(1.0));
        }
        else
        {
            var_afb0f = BlockLightColor.xyz;
        }
        highp vec4 var_6f08e = vec4(var_afb0f, 0.0);
        bool var_f53c2 = CausticsParameters.x != 0.0;
        bool var_081dd;
        if (var_f53c2)
        {
            var_081dd = CausticsParameters.w != 0.0;
        }
        else
        {
            var_081dd = var_f53c2;
        }
        highp float var_172d4;
        if (var_081dd)
        {
            var_172d4 = pow((texture(s_CausticsTexture, vec3((v_worldPos - WorldOrigin.xyz).xz * CausticsParameters.y, CausticsTextureParameters.y)).x * 2.0) * clamp(var_553af.y, 0.0, 1.0), CausticsParameters.z) * (CausticsParameters.z + 1.0);
        }
        else
        {
            var_172d4 = 1.0;
        }
        highp float var_edfe1 = clamp(((TileLightIntensity.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
        highp float var_901e6 = length(var_c33e7);
        highp vec3 var_363db = var_06188;
        highp vec3 var_36a1f;
        highp vec3 var_6ab76;
        highp vec3 var_fa106;
        highp vec3 var_a8be4;
        if (var_363db.z != 1.0)
        {
            highp vec3 var_0a6f2 = -(var_c33e7 / vec3(length(var_c33e7) + 9.9999997473787516355514526367188e-05));
            highp float var_1cd76 = MERSUniforms.w * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
            highp vec3 var_eb58e = var_c33e7;
            highp vec3 var_5596b;
            if (int(QuantizationParameters.y) > 0)
            {
                var_5596b = var_9d060;
            }
            else
            {
                var_5596b = v_worldPos;
            }
            highp vec3 var_2b97a;
            highp vec3 var_dcfba;
            func_64575(var_dcfba, var_2b97a, var_7a301, var_5596b, var_63d4c, var_eb58e, var_172d4, var_0a6f2, var_3cefc, var_c082c, var_1cd76);
#ifdef POINT_LIGHT_SHADING__ON
            highp vec3 var_d3b45;
            highp vec3 var_e418b;
            func_2c6bc(var_e418b, var_dcfba, var_d3b45, var_2b97a, var_9d060, var_c33e7, var_7a301, var_0a6f2, var_3cefc, var_c082c, var_63d4c, var_1cd76);
#endif
            highp vec4 var_c63c4 = var_6f08e;
            bool var_de64c = any(notEqual(var_619e6, vec3(0.0)));
            highp vec3 var_0d020;
            if (var_de64c)
            {
                var_0d020 = var_619e6;
            }
            else
            {
                var_0d020 = var_63d4c;
            }
#ifdef POINT_LIGHT_SHADING__ON
            bool var_d0b55 = DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle.z != 0.0;
            bool var_9ef33;
            if (var_d0b55)
            {
                var_9ef33 = DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled.z != 0.0;
            }
            else
            {
                var_9ef33 = var_d0b55;
            }
#endif
            highp vec3 var_41bb7;
#ifdef POINT_LIGHT_SHADING__OFF
            if ((DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled.z != 0.0) && (!((uint(floor(var_c63c4.w * 255.0)) & 1u) != 0u)))
#endif
#ifdef POINT_LIGHT_SHADING__ON
            if (var_9ef33 && (!((uint(floor(var_c63c4.w * 255.0)) & 1u) != 0u)))
#endif
            {
                highp vec3 var_c896c = v_worldPos - WorldOrigin.xyz;
                bool var_306cb;
                if (var_de64c)
                {
                    highp float var_02ae6 = dot(var_c896c, abs(var_0d020));
                    var_306cb = abs(var_02ae6 - round(var_02ae6)) > 0.001000000047497451305389404296875;
                }
                else
                {
                    var_306cb = var_de64c;
                }
                highp vec3 var_6728f = (var_c896c - vec3(0.5)) + (var_0d020 * 0.0199999995529651641845703125);
                highp vec3 var_0e09b = var_0d020;
                highp vec3 var_63e44 = floor(var_6728f * 0.0625) * 16.0;
                highp vec3 var_19662 = var_6728f - var_63e44;
#ifdef POINT_LIGHT_SHADING__OFF
                ivec4 var_1ba6d = ivec4(ivec3(floor(vec3(ivec3(floor(var_6728f))) * vec3(0.0625))), 0);
#endif
#ifdef POINT_LIGHT_SHADING__ON
                ivec4 var_1ba6d = ivec4(ivec3(floor(vec3(ivec3(floor(var_6728f))) * vec3(0.0625))), 2);
#endif
                ivec4 var_791c2 = var_1ba6d;
                int var_0fbe7 = (var_791c2.x & 65535) | (var_791c2.y << 16);
                int var_e2fbf = (var_791c2.z & 65535) | (var_791c2.w << 16);
                ivec4 var_ee5fa = var_1ba6d;
                uint var_f4dcb = uint(var_ee5fa.x) * 1540483477u;
                uint var_4b2e0 = uint(var_ee5fa.y) * 1540483477u;
                uint var_9e2d3 = uint(var_ee5fa.z) * 1540483477u;
                uint var_8f927 = uint(var_ee5fa.w) * 1540483477u;
                uint var_d6253 = ((((((2293326976u ^ ((var_f4dcb ^ (var_f4dcb >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_4b2e0 ^ (var_4b2e0 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_9e2d3 ^ (var_9e2d3 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_8f927 ^ (var_8f927 >> uint(24))) * 1540483477u);
                uint var_2de6a = (var_d6253 ^ (var_d6253 >> uint(13))) * 1540483477u;
                uint var_6bb3d = var_2de6a ^ (var_2de6a >> uint(15));
                uint var_50f36 = (var_6bb3d ^ (var_6bb3d >> uint(16))) & 65535u;
                uint var_3162e = var_50f36 | uint(var_50f36 == 0u);
                uint var_8db04 = uint(GpuEntryBufferCapacity.x);
                int var_409cb;
                uint var_53ec5;
                bool var_cbe86;
                uint var_a5b7a;
                var_a5b7a = 0u;
                var_cbe86 = false;
                var_53ec5 = var_3162e & (var_8db04 - 1u);
                var_409cb = 0;
                bool var_da0be;
                uint var_aff35;
                uint var_4831e;
                uint var_3e87b;
                bool var_ab4b8;
                for (;;)
                {
                    if (var_409cb < 8)
                    {
                        uint var_71992 = uint(var_e9065.GpuEntryBuffer[var_53ec5].hash) & 65535u;
                        bool var_59572 = var_71992 == var_3162e;
                        bool var_1b0d1;
                        if (var_59572)
                        {
                            var_1b0d1 = var_e9065.GpuEntryBuffer[var_53ec5].packed_xy == var_0fbe7;
                        }
                        else
                        {
                            var_1b0d1 = var_59572;
                        }
                        bool var_03b7c;
                        if (var_1b0d1)
                        {
                            var_03b7c = var_e9065.GpuEntryBuffer[var_53ec5].packed_zw == var_e2fbf;
                        }
                        else
                        {
                            var_03b7c = var_1b0d1;
                        }
                        if (var_cbe86)
                        {
                            var_4831e = var_a5b7a;
                        }
                        else
                        {
                            uint var_ab12c;
                            if (var_03b7c)
                            {
                                var_ab12c = uint(var_e9065.GpuEntryBuffer[var_53ec5].user_data);
                            }
                            else
                            {
                                var_ab12c = var_a5b7a;
                            }
                            var_4831e = var_ab12c;
                        }
                        var_da0be = var_cbe86 || var_03b7c;
                        var_aff35 = (var_53ec5 + 1u) & (var_8db04 - 1u);
                        if (var_da0be || (var_71992 == 0u))
                        {
                            var_ab4b8 = var_da0be;
                            var_3e87b = var_4831e;
                            break;
                        }
                        var_a5b7a = var_4831e;
                        var_cbe86 = var_da0be;
                        var_53ec5 = var_aff35;
                        var_409cb++;
                        continue;
                    }
                    else
                    {
                        var_ab4b8 = var_cbe86;
                        var_3e87b = var_a5b7a;
                        break;
                    }
                }
                uint var_544bf = var_3e87b >> 2u;
                highp vec3 var_4a8d3;
                if (var_ab4b8)
                {
                    highp vec3 var_f57e1 = var_6728f + vec3(0.5);
                    highp vec3 var_cc818 = var_f57e1;
                    highp float var_7438a;
                    if (var_0e09b.x > 0.0)
                    {
                        var_7438a = ceil(var_cc818.x) - 1.0;
                    }
                    else
                    {
                        var_7438a = floor(var_cc818.x);
                    }
                    highp float var_8cff8;
                    if (var_0e09b.y > 0.0)
                    {
                        var_8cff8 = ceil(var_cc818.y) - 1.0;
                    }
                    else
                    {
                        var_8cff8 = floor(var_cc818.y);
                    }
                    highp float var_e2de1;
                    if (var_0e09b.z > 0.0)
                    {
                        var_e2de1 = ceil(var_cc818.z) - 1.0;
                    }
                    else
                    {
                        var_e2de1 = floor(var_cc818.z);
                    }
                    ivec3 var_40ded = ivec3(int(var_7438a), int(var_8cff8), int(var_e2de1));
                    ivec3 var_5d281 = clamp(ivec3(round(var_f57e1)) - ivec3(1), var_40ded - ivec3(1), var_40ded);
                    ivec3 var_4bd22 = var_5d281 - ivec3(var_63e44);
                    ivec3 var_90066 = var_4bd22;
                    uint var_de634;
                    func_fff8e(var_544bf, var_90066, var_de634, var_4bd22);
                    uint var_f8684;
                    uint var_8ac3e;
                    if (dot(var_0d020, var_0d020) > 0.0)
                    {
                        uvec3 var_e8c72 = uvec3(var_40ded - var_5d281);
                        uint var_e9387 = ((var_e8c72.x * 4u) + (var_e8c72.y * 2u)) + var_e8c72.z;
                        uint var_9d5ef;
                        if (var_306cb)
                        {
                            var_9d5ef = var_de634 & (~(1u << var_e9387));
                        }
                        else
                        {
                            var_9d5ef = var_de634;
                        }
                        highp vec3 var_cf3ff = abs(var_0d020);
                        bool var_228af = var_cf3ff.x >= var_cf3ff.y;
                        bool var_c3733;
                        if (var_228af)
                        {
                            var_c3733 = var_cf3ff.x >= var_cf3ff.z;
                        }
                        else
                        {
                            var_c3733 = var_228af;
                        }
                        uint var_4b4c6;
                        if (var_c3733)
                        {
                            var_4b4c6 = 0u;
                        }
                        else
                        {
                            uint var_a6fe9;
                            if (var_cf3ff.y >= var_cf3ff.z)
                            {
                                var_a6fe9 = 1u;
                            }
                            else
                            {
                                var_a6fe9 = 2u;
                            }
                            var_4b4c6 = var_a6fe9;
                        }
                        uint var_b078f;
                        if ((var_9d5ef & (1u << var_e9387)) != 0u)
                        {
                            var_b078f = var_e9387 ^ var_6af84[var_4b4c6];
                        }
                        else
                        {
                            var_b078f = var_e9387;
                        }
                        uint var_d47a3;
                        if ((var_b078f & var_6af84[var_4b4c6]) != 0u)
                        {
                            var_d47a3 = var_314ef[var_4b4c6] ^ 255u;
                        }
                        else
                        {
                            var_d47a3 = var_314ef[var_4b4c6];
                        }
                        uint var_5a45a = (var_6af84[var_4b4c6] == 4u) ? 2u : 4u;
                        uint var_70416 = (var_6af84[var_4b4c6] == 1u) ? 2u : 1u;
                        uint var_dc111 = (1u << (var_b078f ^ var_5a45a)) | (1u << (var_b078f ^ var_70416));
                        uint var_34151;
                        if ((var_9d5ef & var_dc111) == var_dc111)
                        {
                            var_34151 = var_d47a3 | (1u << ((var_b078f ^ var_5a45a) ^ var_70416));
                        }
                        else
                        {
                            var_34151 = var_d47a3;
                        }
                        var_8ac3e = var_b078f;
                        var_f8684 = var_34151 | var_9d5ef;
                    }
                    else
                    {
                        var_8ac3e = 0u;
                        var_f8684 = var_de634;
                    }
                    highp vec3 var_e36a8;
                    if (var_de64c)
                    {
                        highp vec3 var_ad1c1 = abs(var_0d020);
                        highp vec3 var_299cb = var_ad1c1.zxy;
                        highp vec3 var_d0eec = var_ad1c1.yzx;
                        highp float var_01a11 = dot(var_19662, var_299cb);
                        highp float var_53632 = dot(var_19662, var_d0eec);
                        highp float var_07e19 = floor(var_01a11);
                        highp float var_42d87 = floor(var_53632);
                        highp vec3 var_ce0ad = ((var_ad1c1 * dot(vec3(var_4bd22 + ivec3(uvec3(uint((var_8ac3e & 4u) != 0u), uint((var_8ac3e & 2u) != 0u), uint((var_8ac3e & 1u) != 0u)))), var_ad1c1)) + (var_299cb * var_07e19)) + (var_d0eec * var_42d87);
                        ivec3 var_9cd56 = ivec3(var_ce0ad);
                        ivec3 var_e0c8d = ivec3(var_ce0ad + var_299cb);
                        ivec3 var_de65f = ivec3(var_ce0ad + var_d0eec);
                        ivec3 var_985eb = ivec3((var_ce0ad + var_299cb) + var_d0eec);
                        ivec3 var_eb2bb[4] = ivec3[](var_9cd56, var_e0c8d, var_de65f, var_985eb);
                        highp vec2 var_a324b = vec2(var_01a11 - var_07e19, var_53632 - var_42d87);
                        highp vec3 var_a760f;
                        func_fc671(var_e0c8d, var_9cd56, var_de65f, var_4bd22, var_f8684, var_985eb, var_544bf, var_eb2bb, var_63e44, var_a760f, var_a324b);
                        var_e36a8 = var_a760f;
                    }
                    else
                    {
                        highp vec3 var_4eec4 = clamp(fract(var_6728f), vec3(0.0), vec3(1.0));
                        ivec3 var_44518 = var_5d281 - ivec3(var_63e44);
                        bool var_8ce86 = all(greaterThanEqual(var_44518, ivec3(0)));
                        bool var_23699;
                        if (var_8ce86)
                        {
                            var_23699 = all(lessThan(var_44518, ivec3(15)));
                        }
                        else
                        {
                            var_23699 = var_8ce86;
                        }
                        highp float var_9a72e = float((var_f8684 & 1u) == 0u);
                        highp float var_0683f = float((var_f8684 & 2u) == 0u);
                        highp float var_8da3a = float((var_f8684 & 4u) == 0u);
                        highp float var_4fb1a = float((var_f8684 & 8u) == 0u);
                        highp float var_d8e50 = float((var_f8684 & 16u) == 0u);
                        highp float var_6821c = float((var_f8684 & 32u) == 0u);
                        highp float var_939f1 = float((var_f8684 & 64u) == 0u);
                        highp float var_ffcc0 = float((var_f8684 & 128u) == 0u);
                        highp vec3 var_41772;
                        func_269a6(var_9a72e, var_41772, var_23699, var_44518, var_544bf, var_5d281, var_63e44);
                        highp vec3 var_494df;
                        func_87677(var_0683f, var_494df, var_23699, var_44518, var_544bf, var_5d281, var_63e44);
                        highp vec3 var_8072c;
                        func_8e24a(var_8da3a, var_8072c, var_23699, var_44518, var_544bf, var_5d281, var_63e44);
                        highp vec3 var_3db92;
                        func_fd360(var_4fb1a, var_3db92, var_23699, var_44518, var_544bf, var_5d281, var_63e44);
                        highp vec3 var_fdb95;
                        func_0b7c2(var_d8e50, var_fdb95, var_23699, var_44518, var_544bf, var_5d281, var_63e44);
                        highp vec3 var_38771;
                        func_dcccf(var_6821c, var_38771, var_23699, var_44518, var_544bf, var_5d281, var_63e44);
                        highp vec3 var_f034e;
                        func_70277(var_939f1, var_f034e, var_23699, var_44518, var_544bf, var_5d281, var_63e44);
                        highp vec3 var_dbd83;
                        func_e43d6(var_ffcc0, var_dbd83, var_23699, var_44518, var_544bf, var_5d281, var_63e44);
                        highp float var_509de = 1.0 - var_4eec4.x;
                        highp float var_e567c = 1.0 - var_4eec4.y;
                        highp float var_2571d = 1.0 - var_4eec4.z;
                        highp float var_6cd84 = ((var_509de * var_e567c) * var_2571d) * var_9a72e;
                        highp float var_1e3ab = ((var_509de * var_e567c) * var_4eec4.z) * var_0683f;
                        highp float var_1d9f3 = ((var_509de * var_4eec4.y) * var_2571d) * var_8da3a;
                        highp float var_9807b = ((var_509de * var_4eec4.y) * var_4eec4.z) * var_4fb1a;
                        highp float var_2f677 = ((var_4eec4.x * var_e567c) * var_2571d) * var_d8e50;
                        highp float var_1e52b = ((var_4eec4.x * var_e567c) * var_4eec4.z) * var_6821c;
                        highp float var_f74ab = ((var_4eec4.x * var_4eec4.y) * var_2571d) * var_939f1;
                        highp float var_4ae51 = ((var_4eec4.x * var_4eec4.y) * var_4eec4.z) * var_ffcc0;
                        highp float var_1985a = ((((((var_6cd84 + var_1e3ab) + var_1d9f3) + var_9807b) + var_2f677) + var_1e52b) + var_f74ab) + var_4ae51;
                        highp vec3 var_03544;
                        if (var_1985a > 0.0)
                        {
                            var_03544 = ((((((((var_41772 * var_6cd84) + (var_494df * var_1e3ab)) + (var_8072c * var_1d9f3)) + (var_3db92 * var_9807b)) + (var_fdb95 * var_2f677)) + (var_38771 * var_1e52b)) + (var_f034e * var_f74ab)) + (var_dbd83 * var_4ae51)) / vec3(var_1985a);
                        }
                        else
                        {
                            var_03544 = vec3(0.0);
                        }
                        var_e36a8 = var_03544;
                    }
                    var_4a8d3 = var_e36a8;
                }
                else
                {
                    var_4a8d3 = vec3(0.0);
                }
                var_41bb7 = var_4a8d3;
            }
            else
            {
                var_41bb7 = var_6f08e.xyz;
            }
            highp vec4 var_65752 = SkyAmbientLightColorIntensity;
            highp float var_c9957 = TileLightIntensity.y * TileLightIntensity.y;
#ifdef POINT_LIGHT_SHADING__ON
            var_a8be4 = var_e418b;
#endif
#ifdef POINT_LIGHT_SHADING__OFF
            var_a8be4 = var_dcfba;
#endif
#ifdef POINT_LIGHT_SHADING__ON
            var_fa106 = var_d3b45;
#endif
#ifdef POINT_LIGHT_SHADING__OFF
            var_fa106 = var_2b97a;
#endif
            var_6ab76 = ((var_c082c * (1.0 - MERSUniforms.x)) * max((var_41bb7 * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_c9957 * var_c9957) * TileLightIntensity.y, (TileLightIntensity.y * TileLightIntensity.y) * TileLightIntensity.y, CameraLightIntensity.y)) * var_65752.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w;
            var_36a1f = ((mix(var_c082c, vec3(dot(var_c082c, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(MERSUniforms.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x;
        }
        else
        {
            var_a8be4 = vec3(0.0);
            var_fa106 = vec3(0.0);
            var_6ab76 = vec3(0.0);
            var_36a1f = vec3(0.0);
        }
        highp vec3 var_c2692 = normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz);
        bool var_2ae1e = AtmosphericScatteringToggles.y != 0.0;
        bool var_f92a8;
        if (var_2ae1e)
        {
            var_f92a8 = AtmosphericScatteringToggles.z != 0.0;
        }
        else
        {
            var_f92a8 = var_2ae1e;
        }
        bool var_79009;
        if (var_f92a8)
        {
            var_79009 = DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0;
        }
        else
        {
            var_79009 = var_f92a8;
        }
        highp vec3 var_0e256;
        if (var_79009)
        {
            highp vec4 var_a5c9d = SkyAmbientLightColorIntensity;
            var_0e256 = max((vec3(1.0) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_a5c9d.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
        }
        else
        {
            var_0e256 = vec3(0.0);
        }
        highp vec3 var_e18ab;
        highp float var_38dc3;
        if (AtmosphericScatteringToggles.x != 0.0)
        {
            highp float var_ae598 = clamp((((length(var_c33e7) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
            highp vec3 var_740c9;
            if (var_ae598 > 0.0)
            {
                highp vec3 var_8c014;
                if (AtmosphericScatteringToggles.y != 0.0)
                {
                    var_8c014 = FogColor.xyz * max(var_0e256, vec3(1.0));
                }
                else
                {
                    highp vec4 var_e8883 = SunColor;
                    highp vec4 var_545f4 = MoonColor;
                    highp vec3 var_30caf = var_c2692;
                    highp float var_8ebae = 1.0 - smoothstep(FogSkyBlend.x - FogSkyBlend.w, FogSkyBlend.z - FogSkyBlend.w, var_30caf.y);
                    highp float var_909be = dot(var_c2692, SunDir.xyz);
                    highp float var_fdfa0 = dot(var_c2692, MoonDir.xyz);
                    highp vec3 var_c5192 = var_c2692;
                    highp float var_fcbe4 = 1.0 - smoothstep(FogSkyBlend.x - FogSkyBlend.w, FogSkyBlend.y, var_c5192.y);
                    highp float var_52209 = clamp(pow(max(var_909be, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                    highp float var_23ad0 = clamp(pow(max(var_fdfa0, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                    highp float var_4cadf = 1.809999942779541015625 - (var_52209 * 1.7999999523162841796875);
                    highp float var_36f51 = 1.809999942779541015625 - (var_23ad0 * 1.7999999523162841796875);
                    highp vec3 var_c9b17 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3((var_fcbe4 * var_fcbe4) * var_fcbe4)) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_e8883.w * (0.75 * ((var_909be * var_909be) + 1.0))) + (var_545f4.w * (0.75 * ((var_fdfa0 * var_fdfa0) + 1.0))))) + (((SkyHorizonColor.xyz * ((var_8ebae * var_8ebae) * var_8ebae)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_e8883.w) * AtmosphericScattering.y) * var_52209) * (0.0361000001430511474609375 / (var_4cadf * sqrt(var_4cadf)))) + ((((MoonColor.xyz * var_545f4.w) * AtmosphericScattering.z) * var_23ad0) * (0.0361000001430511474609375 / (var_36f51 * sqrt(var_36f51))))));
                    highp vec3 var_52a1b;
                    if (AtmosphericScatteringToggles.w != 0.0)
                    {
                        var_52a1b = mix(UndergroundFogColor.xyz, var_c9b17, vec3(max(CameraAmbientContribution.y, TileLightIntensity.y)));
                    }
                    else
                    {
                        var_52a1b = var_c9b17;
                    }
                    var_8c014 = var_52a1b;
                }
                var_740c9 = var_8c014;
            }
            else
            {
                var_740c9 = vec3(0.0);
            }
            var_38dc3 = var_ae598;
            var_e18ab = var_740c9;
        }
        else
        {
            var_38dc3 = 0.0;
            var_e18ab = vec3(0.0);
        }
        highp vec4 var_ef91e = vec4(var_e18ab, var_38dc3);
        highp vec4 var_7ad2a = var_ef91e;
        highp vec4 var_73cf9;
        if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
        {
            highp vec2 var_0a57b = VolumeNearFar.xy;
            highp vec2 var_3da09 = (var_06188.xy + vec2(1.0)) * 0.5;
            highp vec4 var_197cc = u_invProj * vec4(var_06188, 1.0);
            highp float var_2ef05 = var_3da09.x;
            ivec3 var_1d618 = ivec3(VolumeDimensions.xyz);
            highp vec3 var_1dd8d = vec3(var_2ef05, var_3da09.y, log((53.598148345947265625 * ((((-var_197cc.z) / var_197cc.w) - var_0a57b.x) / (var_0a57b.y - var_0a57b.x))) + 1.0) * 0.25);
            highp float var_f8318 = (var_1dd8d.z * float(var_1d618.z)) - 0.5;
            int var_41fd4 = clamp(int(var_f8318), 0, var_1d618.z - 2);
            var_73cf9 = mix(textureLod(s_ScatteringBuffer, vec3(var_2ef05, var_3da09.y, float(var_41fd4)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_2ef05, var_3da09.y, float(var_41fd4 + 1)), 0.0), vec4(clamp(var_f8318 - float(var_41fd4), 0.0, 1.0)));
        }
        else
        {
            var_73cf9 = vec4(0.0, 0.0, 0.0, 1.0);
        }
        highp vec4 var_8b05b = var_73cf9;
        highp vec3 var_17291;
        if (IBLParameters.x != 0.0)
        {
            highp vec3 var_43a1d;
            highp vec3 var_481f7;
            if (QuantizationParameters.w > 0.0)
            {
                var_481f7 = (u_view * vec4(var_9d060, 1.0)).xyz;
                var_43a1d = var_9d060;
            }
            else
            {
                var_481f7 = var_c33e7;
                var_43a1d = v_worldPos;
            }
            highp vec3 var_44ff1 = reflect(normalize(var_43a1d - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_63d4c);
            highp float var_622ee;
            if (int(ConvolutionType.x) == 1)
            {
                highp float var_9d1c7 = 1.0 - MERSUniforms.z;
                var_622ee = (1.0 - (var_9d1c7 * var_9d1c7)) * (IBLParameters.y - 1.0);
            }
            else
            {
                highp float var_1e32c = 1.0 - MERSUniforms.z;
                highp float var_464ee = var_1e32c * var_1e32c;
                highp float var_c3581 = var_464ee * var_464ee;
                var_622ee = (1.0 - (var_c3581 * var_c3581)) * (IBLParameters.y - 1.0);
            }
            int var_0a0b1 = int(LastSpecularIBLIdx.x);
            highp vec3 var_63ae8 = mix(textureLod(s_SpecularIBLRecords, vec4(var_44ff1, float((var_0a0b1 + 2) % 3)), var_622ee).xyz, textureLod(s_SpecularIBLRecords, vec4(var_44ff1, float(var_0a0b1)), var_622ee).xyz, vec3(IBLParameters.w));
            highp vec3 var_f31a8;
            if (PreExposureEnabled.x > 0.0)
            {
                var_f31a8 = var_63ae8 * vec3(301.72412109375);
            }
            else
            {
                var_f31a8 = var_63ae8;
            }
            highp vec3 var_3dfec = (var_f31a8 * (((var_edfe1 * var_edfe1) * var_edfe1) * IBLParameters.x)) * IBLParameters.z;
            highp vec3 var_4fd79;
            if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
            {
                highp vec4 var_58dff;
                func_045b4(var_6f08e, var_3dfec, var_58dff);
                highp vec4 var_a4557 = var_58dff;
                highp vec3 var_63a76;
                if (var_a4557.w == 1.0)
                {
                    var_63a76 = var_58dff.xyz;
                }
                else
                {
                    var_63a76 = var_3dfec;
                }
                var_4fd79 = var_63a76;
            }
            else
            {
                var_4fd79 = var_3dfec;
            }
            highp vec2 var_c1068 = vec2(clamp(dot(var_7a301, -normalize(var_481f7)), 0.0, 1.0), MERSUniforms.z);
            var_c1068.y = 1.0 - var_c1068.y;
            highp vec2 var_25980 = texture(s_BrdfLUT, var_c1068).xy;
            highp vec3 var_aeb8e = var_4fd79 * ((var_3cefc * var_25980.x) + vec3(var_25980.y));
            highp vec3 var_b9c5d;
            if (AtmosphericScatteringToggles.x != 0.0)
            {
                var_b9c5d = var_aeb8e * (1.0 - clamp((((var_901e6 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0));
            }
            else
            {
                var_b9c5d = var_aeb8e * (1.0 - clamp((((var_901e6 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
            }
            highp vec3 var_bed08;
            if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
            {
                highp vec2 var_de31f = VolumeNearFar.xy;
                highp vec2 var_0d73a = (var_06188.xy + vec2(1.0)) * 0.5;
                highp vec4 var_dbeca = u_invProj * vec4(var_06188, 1.0);
                highp float var_d9b3f = var_0d73a.x;
                ivec3 var_c2995 = ivec3(VolumeDimensions.xyz);
                highp vec3 var_5de9a = vec3(var_d9b3f, var_0d73a.y, log((53.598148345947265625 * ((((-var_dbeca.z) / var_dbeca.w) - var_de31f.x) / (var_de31f.y - var_de31f.x))) + 1.0) * 0.25);
                highp float var_ca2bf = (var_5de9a.z * float(var_c2995.z)) - 0.5;
                int var_d3d23 = clamp(int(var_ca2bf), 0, var_c2995.z - 2);
                highp vec4 var_18255 = mix(textureLod(s_ScatteringBuffer, vec3(var_d9b3f, var_0d73a.y, float(var_d3d23)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_d9b3f, var_0d73a.y, float(var_d3d23 + 1)), 0.0), vec4(clamp(var_ca2bf - float(var_d3d23), 0.0, 1.0)));
                var_bed08 = var_b9c5d * var_18255.w;
            }
            else
            {
                var_bed08 = var_b9c5d;
            }
            var_17291 = var_bed08;
        }
        else
        {
            highp vec3 var_0fc0f;
            if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
            {
                highp vec3 var_ff157;
                if (QuantizationParameters.w > 0.0)
                {
                    var_ff157 = (u_view * vec4(var_9d060, 1.0)).xyz;
                }
                else
                {
                    var_ff157 = var_c33e7;
                }
                highp vec4 var_afa9d;
                func_8822c(var_6f08e, var_afa9d);
                highp vec2 var_3e724 = vec2(clamp(dot(var_7a301, -normalize(var_ff157)), 0.0, 1.0), MERSUniforms.z);
                var_3e724.y = 1.0 - var_3e724.y;
                highp vec2 var_f7ae0 = texture(s_BrdfLUT, var_3e724).xy;
                var_0fc0f = var_afa9d.xyz * ((var_3cefc * var_f7ae0.x) + vec3(var_f7ae0.y));
            }
            else
            {
                var_0fc0f = vec3(0.0);
            }
            var_17291 = var_0fc0f;
        }
        var_3152e = vec4(var_73cf9.xyz + (mix(((var_6ab76 + var_a8be4) + var_fa106) + var_36a1f, var_ef91e.xyz, vec3(var_7ad2a.w)) * var_8b05b.w), 1.0).xyz + var_17291;
    }
    else
    {
        var_3152e = var_c082c;
    }
    highp vec4 var_5907e = vec4(var_3152e, var_a97d3.w * v_color0.w);
    highp vec4 var_ba5d1 = texture(s_PreviousFrameAverageLuminance, vec2(0.5));
    highp float var_44167 = var_ba5d1.x;
    highp vec3 var_2771c = var_3152e + (var_3152e * (vec3(LightingEnabledAndAdaptiveEmissive.y, LightingEnabledAndAdaptiveEmissive.y, LightingEnabledAndAdaptiveEmissive.y) / vec3((0.180000007152557373046875 / var_44167) + 9.9999997473787516355514526367188e-05)));
    highp vec3 var_600ad;
    if (PreExposureEnabled.x > 0.0)
    {
        var_600ad = var_2771c * ((0.180000007152557373046875 / var_44167) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_600ad = var_2771c;
    }
    var_5907e.x = var_600ad.x;
    var_5907e.y = var_600ad.y;
    var_5907e.z = var_600ad.z;
    bgfx_FragData0 = var_5907e;
}
