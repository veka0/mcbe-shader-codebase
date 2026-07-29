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
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
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
* - uniform vec4 PointLightPreCalcValues;
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

const uvec3 var_4f73b[8] = uvec3[](uvec3(0u, 0u, 1u), uvec3(0u, 0u, 1u), uvec3(0u, 1u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u), uvec3(1u, 0u, 0u), uvec3(0u, 1u, 0u), uvec3(1u, 0u, 0u));
const uvec3 var_90b85[8] = uvec3[](uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(0u, 1u, 1u), uvec3(0u, 1u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 0u, 1u), uvec3(1u, 1u, 0u), uvec3(1u, 1u, 0u));
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
layout(binding = 9, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_fe9ce;
layout(binding = 8, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_a42db;
#ifdef POINT_LIGHT_SHADING__ON
layout(binding = 11, std430) buffer s_zLights { Light zLights[]; } var_adffb;
layout(binding = 10, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_e6940;
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
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
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
uniform highp vec4 PointLightPreCalcValues;
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
#ifdef USE_TEXTURES__ON
in highp vec2 v_texcoord0;
#endif
in highp vec3 v_viewSpaceNormal;
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
void func_c65e4(inout highp vec3 arg_87514, inout highp vec3 arg_c03dc, inout highp vec3 arg_58fab, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_ae81a, inout highp float arg_fb1ed, inout highp vec3 arg_c7286, inout highp vec3 arg_08b90, inout highp vec3 arg_624d1, inout highp float arg_67b92) {
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
    arg_87514 = ((((((vec3(1.0) - loc_00b7f) * mix(loc_947b2, max((dot(arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_d8782 * loc_d8782), 0.0), arg_67b92)) * (loc_cf738 * vec3(0.3183098733425140380859375))) * loc_0f714) + (((loc_cf738 * vec3(0.3183098733425140380859375)) * (arg_67b92 * max((dot(-arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_65d74 * loc_65d74), 0.0))) * loc_f89fe)) * loc_2c251) * DiffuseSpecularEmissiveAmbientTermToggles.x;
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
    highp vec3 loc_8868e = arg_aee55 - var_adffb.zLights[arg_7070b].position.xyz;
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
    highp vec4 loc_87a38 = var_adffb.zLights[arg_7070b].shadowFaceUV0;
    highp vec3 loc_baa89;
    if (loc_f3fad == 1)
    {
        loc_87a38 = var_adffb.zLights[arg_7070b].shadowFaceUV1;
        loc_baa89 = vec3(-loc_8a9f7.z, loc_8a9f7.y, loc_8a9f7.x);
    }
    else
    {
        highp vec3 loc_a4212;
        if (loc_f3fad == 2)
        {
            loc_87a38 = var_adffb.zLights[arg_7070b].shadowFaceUV2;
            loc_a4212 = vec3(-loc_8a9f7.x, -loc_8a9f7.z, -loc_8a9f7.y);
        }
        else
        {
            highp vec3 loc_38505;
            if (loc_f3fad == 3)
            {
                loc_87a38 = var_adffb.zLights[arg_7070b].shadowFaceUV3;
                loc_38505 = vec3(-loc_8a9f7.x, loc_8a9f7.z, loc_8a9f7.y);
            }
            else
            {
                highp vec3 loc_fd3cf;
                if (loc_f3fad == 4)
                {
                    loc_87a38 = var_adffb.zLights[arg_7070b].shadowFaceUV4;
                    loc_fd3cf = vec3(-loc_8a9f7.x, loc_8a9f7.y, -loc_8a9f7.z);
                }
                else
                {
                    highp vec3 loc_0c356;
                    if (loc_f3fad == 5)
                    {
                        loc_87a38 = var_adffb.zLights[arg_7070b].shadowFaceUV5;
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
    highp vec3 loc_a4b3e = var_adffb.zLights[arg_9327a].position.xyz - v_worldPos;
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
    if (loc_9eb1a >= (var_adffb.zLights[arg_9327a].position.w * var_adffb.zLights[arg_9327a].position.w))
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
    highp float loc_4c5a5 = loc_9eb1a / ((var_adffb.zLights[arg_9327a].position.w * var_adffb.zLights[arg_9327a].position.w) + 9.9999997473787516355514526367188e-05);
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
        highp vec3 loc_8226d = var_adffb.zLights[arg_9327a].color.xyz * loc_219c5;
        arg_e84ec = vec4(loc_8226d.x, loc_8226d.y, loc_8226d.z, arg_e84ec.w);
        arg_e84ec.w = 1.0 - (loc_9eb1a / ((var_adffb.zLights[arg_9327a].position.w * var_adffb.zLights[arg_9327a].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_0a2b9 = (var_adffb.zLights[arg_9327a].color.xyz * var_adffb.zLights[arg_9327a].color.w) * loc_219c5;
}
void func_b95a2(inout highp vec3 arg_33c3b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec4 arg_fadf1, inout highp vec3 arg_efe4b, inout highp vec3 arg_81f79, inout highp vec3 arg_58ffc, inout highp vec3 arg_28cf7, inout highp vec3 arg_5a8cd, inout highp vec3 arg_4fa31, inout highp float arg_9502a) {
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
        int loc_4d5d9 = int(var_e6940.zLightLookupArray[loc_86630].lookup);
        if (loc_4d5d9 < 0)
        {
            break;
        }
        highp vec3 loc_ed90f = normalize((u_view * vec4(var_adffb.zLights[loc_4d5d9].position.xyz, 1.0)).xyz - arg_33c3b);
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
        highp vec4 loc_55c3a = vec4(0.0);
        highp vec3 loc_d62e4;
        highp float loc_39386;
        highp float loc_4feae;
        func_dbe43(loc_25712, loc_4d5d9, loc_4feae, loc_39386, loc_d62e4, arg_5a8cd, arg_4fa31, arg_9502a);
        loc_55c3a = loc_25712;
        highp vec3 loc_ef49b = loc_a468d.xyz + loc_25712.xyz;
        loc_a468d = vec4(loc_ef49b.x, loc_ef49b.y, loc_ef49b.z, loc_a468d.w);
        loc_96e3a = loc_a55d6 + loc_55c3a.w;
        loc_50935 = loc_45a05 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_9502a)) * (loc_97c67 * vec3(0.3183098733425140380859375))) * loc_39386) + (((loc_97c67 * vec3(0.3183098733425140380859375)) * (arg_9502a * max((dot(-arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_4feae)) * loc_d62e4) * DiffuseSpecularEmissiveAmbientTermToggles.x);
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
void func_4e1d6(inout highp vec3 arg_326b5, inout highp vec3 arg_179c6, inout highp vec3 arg_a0b83, inout highp vec3 arg_757dc, inout highp vec4 arg_d4ca2, inout highp vec3 arg_b40e7, inout highp vec3 arg_b5f39, inout highp vec3 arg_5004c, inout highp vec3 arg_1ede1, inout highp vec3 arg_a9ada, inout highp vec3 arg_cd082, inout highp vec3 arg_19f2f, inout highp float arg_02667) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0))
    {
        arg_326b5 = arg_179c6;
        arg_a0b83 = arg_757dc;
        arg_d4ca2 = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    highp vec3 loc_9585e;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_9585e = arg_b40e7;
    }
    else
    {
        loc_9585e = v_worldPos;
    }
    highp vec4 loc_33eed;
    highp vec3 loc_28a7a;
    highp vec3 loc_d4a82;
    func_b95a2(arg_b5f39, loc_d4a82, loc_28a7a, loc_33eed, arg_5004c, arg_1ede1, arg_a9ada, arg_cd082, loc_9585e, arg_19f2f, arg_02667);
    arg_326b5 = arg_179c6 + loc_d4a82;
    arg_a0b83 = arg_757dc + loc_28a7a;
    arg_d4ca2 = loc_33eed;
}
#endif
void func_33953(inout uint arg_a601e, inout highp vec3 arg_aa7d7) {
    if (var_fe9ce.VoxelBuffer[arg_a601e].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_11fc1 = vec4(uvec4(var_fe9ce.VoxelBuffer[arg_a601e].data, var_fe9ce.VoxelBuffer[arg_a601e].data >> 8u, var_fe9ce.VoxelBuffer[arg_a601e].data >> 16u, var_fe9ce.VoxelBuffer[arg_a601e].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
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
        if (!((var_fe9ce.VoxelBuffer[arg_2632b + 4096u].data & (1u << uint(var_7138c[loc_fa0d5]))) != 0u))
        {
            arg_e5233 = vec3(0.0);
            return;
        }
        uvec3 loc_441ec = uvec3(arg_ca7c6 - (floor(arg_ca7c6 * 0.0625) * 16.0)) & uvec3(15u);
        loc_58bb3 = (var_fe9ce.VoxelBuffer[(arg_2632b + 4097u) + uint(var_7138c[loc_fa0d5])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
    }
    highp vec3 loc_5d636;
    func_33953(loc_58bb3, loc_5d636);
    arg_e5233 = loc_5d636;
}
void func_f1070(inout highp vec3 arg_1c74c, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec3 loc_a5507 = (arg_1c74c * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x;
    highp vec3 loc_d5030 = mix(AmbientLightParams.xyz * AmbientLightParams.w, loc_a5507, vec3(clamp(dot(loc_a5507, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), 0.0, 1.0))) * MERSUniforms.x;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_d5030, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_d5030, 1.0);
}
void func_7bae0(inout highp vec3 arg_1c74c, inout highp vec4 arg_85834) {
    highp vec3 loc_a5507 = (arg_1c74c * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x;
    highp vec3 loc_09a3f = mix(AmbientLightParams.xyz * AmbientLightParams.w, loc_a5507, vec3(clamp(dot(loc_a5507, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), 0.0, 1.0))) * MERSUniforms.x;
    if (0.0 >= dot(loc_09a3f, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_09a3f, 1.0);
}
void main() {
    highp vec4 var_645ac = v_color0;
#ifdef USE_TEXTURES__OFF
    highp vec4 var_63d20 = vec4(1.0);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_63d20 = texture(s_MatTexture, v_texcoord0);
#endif
    if (var_63d20.w < 0.5)
    {
        discard;
    }
    highp vec4 var_a2360 = var_63d20;
    highp vec4 var_705a1 = var_a2360 * CurrentColor;
    var_63d20 = var_705a1;
    highp vec3 var_48376 = var_705a1.xyz * v_color0.xyz;
    highp vec3 var_ccb57;
    func_9b87e(var_ccb57, var_48376);
    highp vec3 var_b8e62;
    if (LightingEnabledAndAdaptiveEmissive.x > 0.0)
    {
        highp vec4 var_69dd9 = u_view * (u_model[0] * vec4(v_worldPos, 1.0));
        highp vec4 var_72c59 = u_proj * var_69dd9;
        highp vec4 var_3ab6f = var_72c59;
        highp vec3 var_06188 = var_72c59.xyz / vec3(var_3ab6f.w);
        highp vec3 var_2baa1 = normalize(v_viewSpaceNormal);
        highp vec4 var_12f51 = vec4(var_2baa1, 0.0);
        highp vec3 var_15370 = var_69dd9.xyz;
        highp vec3 var_3da14 = v_worldPos - WorldOrigin.xyz;
        highp vec3 var_f32a5 = dFdx(var_15370);
        highp vec3 var_a4ce1 = dFdy(var_15370);
        highp vec3 var_a2136 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(var_f32a5), normalize(var_a4ce1))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
        highp vec3 var_4a875 = vec3(QuantizationParameters.z * 0.5) - mod(var_3da14, vec3(QuantizationParameters.z));
        highp vec3 var_6f1d9 = (var_3da14 + (var_4a875 - (var_a2136 * dot(var_4a875, var_a2136)))) + WorldOrigin.xyz;
        highp vec3 var_05cd5 = var_12f51.xyz;
        highp vec3 var_a2697 = (u_view * var_12f51).xyz;
        highp vec3 var_207c9 = vec3(0.039999999105930328369140625 * (1.0 - MERSUniforms.x)) + (var_ccb57 * MERSUniforms.x);
        highp vec3 var_e7427 = BlockLightColor.xyz;
        highp vec3 var_645f0;
        if ((((var_e7427.x + var_e7427.y) + var_e7427.z) < 9.9999997473787516355514526367188e-05) && (TileLightIntensity.x > 9.9999997473787516355514526367188e-05))
        {
            highp vec4 var_adfac = vec4(0.0);
            highp float var_ce589 = TileLightIntensity.x * TileLightIntensity.x;
            var_645f0 = clamp(vec3(var_ce589 + (var_adfac.x * var_adfac.w), (var_ce589 * ((((var_ce589 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_adfac.y * var_adfac.w), (var_ce589 * (((var_ce589 * var_ce589) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_adfac.z * var_adfac.w)), vec3(0.0), vec3(1.0));
        }
        else
        {
            var_645f0 = BlockLightColor.xyz;
        }
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
            var_172d4 = pow((texture(s_CausticsTexture, vec3((v_worldPos - WorldOrigin.xyz).xz * CausticsParameters.y, CausticsTextureParameters.y)).x * 2.0) * clamp(var_2baa1.y, 0.0, 1.0), CausticsParameters.z) * (CausticsParameters.z + 1.0);
        }
        else
        {
            var_172d4 = 1.0;
        }
        highp float var_edfe1 = clamp(((TileLightIntensity.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
        highp float var_901e6 = length(var_15370);
        highp vec3 var_363db = var_06188;
#ifdef POINT_LIGHT_SHADING__ON
        highp vec4 var_df80d;
#endif
        highp vec3 var_f2843;
        highp vec3 var_bac38;
        if (var_363db.z != 1.0)
        {
            highp vec3 var_15909 = -(var_15370 / vec3(length(var_15370) + 9.9999997473787516355514526367188e-05));
            highp float var_cf580 = MERSUniforms.w * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
            highp vec3 var_eb58e = var_15370;
            highp vec3 var_5596b;
            if (int(QuantizationParameters.y) > 0)
            {
                var_5596b = var_6f1d9;
            }
            else
            {
                var_5596b = v_worldPos;
            }
            highp vec3 var_e3c22;
            highp vec3 var_ff72f;
            func_c65e4(var_ff72f, var_e3c22, var_a2697, var_5596b, var_05cd5, var_eb58e, var_172d4, var_15909, var_207c9, var_ccb57, var_cf580);
#ifdef POINT_LIGHT_SHADING__ON
            highp vec4 var_eedbf;
            highp vec3 var_987a9;
            highp vec3 var_25302;
            func_4e1d6(var_25302, var_ff72f, var_987a9, var_e3c22, var_eedbf, var_6f1d9, var_15370, var_a2697, var_15909, var_207c9, var_ccb57, var_05cd5, var_cf580);
            var_bac38 = var_25302;
#endif
#ifdef POINT_LIGHT_SHADING__OFF
            var_bac38 = var_ff72f;
            var_f2843 = var_e3c22;
#endif
#ifdef POINT_LIGHT_SHADING__ON
            var_f2843 = var_987a9;
            var_df80d = var_eedbf;
#endif
        }
        else
        {
            var_bac38 = vec3(0.0);
            var_f2843 = vec3(0.0);
#ifdef POINT_LIGHT_SHADING__ON
            var_df80d = vec4(0.0, 0.0, 0.0, 1.0);
#endif
        }
        highp vec3 var_04dbb;
        if (DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled.w != 0.0)
        {
            highp vec3 var_99f43 = ((v_worldPos - WorldOrigin.xyz) - vec3(0.5)) + (var_05cd5 * 0.20000000298023223876953125);
            ivec3 var_a2fbf = ivec3(floor(var_99f43));
            highp vec3 var_e55a8 = floor(var_99f43 * 0.0625) * 16.0;
            highp vec3 var_65d52 = var_99f43 - var_e55a8;
            ivec4 var_fb622 = ivec4((var_a2fbf - (ivec3(15) & (var_a2fbf >> ivec3(31)))) / ivec3(16), 0);
            ivec4 var_a2c78 = var_fb622;
            int var_8282d = (var_a2c78.x & 65535) | (var_a2c78.y << 16);
            int var_db019 = (var_a2c78.z & 65535) | (var_a2c78.w << 16);
            ivec4 var_e83d2 = var_fb622;
            uint var_dbe8c = uint(var_e83d2.x) * 1540483477u;
            uint var_35207 = uint(var_e83d2.y) * 1540483477u;
            uint var_c7c69 = uint(var_e83d2.z) * 1540483477u;
            uint var_7c89d = uint(var_e83d2.w) * 1540483477u;
            uint var_ea647 = ((((((2293326976u ^ ((var_dbe8c ^ (var_dbe8c >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_35207 ^ (var_35207 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_c7c69 ^ (var_c7c69 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_7c89d ^ (var_7c89d >> uint(24))) * 1540483477u);
            uint var_66e52 = (var_ea647 ^ (var_ea647 >> uint(13))) * 1540483477u;
            uint var_02650 = var_66e52 ^ (var_66e52 >> uint(15));
            uint var_b516a = (var_02650 ^ (var_02650 >> uint(16))) & 65535u;
            uint var_e9be1 = var_b516a | uint(var_b516a == 0u);
            int var_4bfc3;
            uint var_dc4a0;
            bool var_59b60;
            uint var_e4d40;
            var_e4d40 = 0u;
            var_59b60 = false;
            var_dc4a0 = var_e9be1 & uint(GpuEntryBufferCapacity.x - 1.0);
            var_4bfc3 = 0;
            bool var_40c1a;
            uint var_9cba6;
            uint var_8d8f4;
            uint var_d9aef;
            bool var_4680b;
            for (;;)
            {
                if (var_4bfc3 < 8)
                {
                    uint var_b3275 = uint(var_a42db.GpuEntryBuffer[var_dc4a0].hash) & 65535u;
                    bool var_079e7 = var_b3275 == var_e9be1;
                    bool var_88b02;
                    if (var_079e7)
                    {
                        var_88b02 = var_a42db.GpuEntryBuffer[var_dc4a0].packed_xy == var_8282d;
                    }
                    else
                    {
                        var_88b02 = var_079e7;
                    }
                    bool var_4f663;
                    if (var_88b02)
                    {
                        var_4f663 = var_a42db.GpuEntryBuffer[var_dc4a0].packed_zw == var_db019;
                    }
                    else
                    {
                        var_4f663 = var_88b02;
                    }
                    if (var_59b60)
                    {
                        var_8d8f4 = var_e4d40;
                    }
                    else
                    {
                        uint var_fbc90;
                        if (var_4f663)
                        {
                            var_fbc90 = uint(var_a42db.GpuEntryBuffer[var_dc4a0].user_data);
                        }
                        else
                        {
                            var_fbc90 = var_e4d40;
                        }
                        var_8d8f4 = var_fbc90;
                    }
                    var_40c1a = var_59b60 || var_4f663;
                    var_9cba6 = (var_dc4a0 + 1u) & uint(GpuEntryBufferCapacity.x - 1.0);
                    if (var_40c1a || (var_b3275 == 0u))
                    {
                        var_4680b = var_40c1a;
                        var_d9aef = var_8d8f4;
                        break;
                    }
                    var_e4d40 = var_8d8f4;
                    var_59b60 = var_40c1a;
                    var_dc4a0 = var_9cba6;
                    var_4bfc3++;
                    continue;
                }
                else
                {
                    var_4680b = var_59b60;
                    var_d9aef = var_e4d40;
                    break;
                }
            }
            uint var_ba630 = var_d9aef >> 2u;
            highp vec3 var_740c9;
            if (var_4680b)
            {
                highp vec3 var_840de;
                if (any(greaterThanEqual(abs(var_05cd5), vec3(1.0))))
                {
                    highp vec3 var_523e6 = var_05cd5;
                    highp vec3 var_34a44 = abs(var_05cd5);
                    highp vec3 var_fabd5 = var_34a44.zxy;
                    highp vec3 var_5fd6a = var_34a44.yzx;
                    highp float var_bd489 = dot(var_65d52, var_34a44);
                    highp float var_a19ee = dot(var_65d52, var_fabd5);
                    highp float var_5b12c = dot(var_65d52, var_5fd6a);
                    highp float var_ba2c5;
                    if (((var_523e6.x + var_523e6.y) + var_523e6.z) > 0.0)
                    {
                        var_ba2c5 = ceil(var_bd489);
                    }
                    else
                    {
                        var_ba2c5 = floor(var_bd489);
                    }
                    highp float var_ab7b5 = floor(var_a19ee);
                    highp float var_cf4ab = floor(var_5b12c);
                    highp vec3 var_eebfd = ((var_34a44 * var_ba2c5) + (var_fabd5 * var_ab7b5)) + (var_5fd6a * var_cf4ab);
                    highp vec3 var_9d45f = var_eebfd + var_fabd5;
                    highp vec3 var_8ec6c = var_eebfd + var_5fd6a;
                    highp vec3 var_a2de2 = (var_eebfd + var_fabd5) + var_5fd6a;
                    highp float var_05440 = var_a19ee - var_ab7b5;
                    highp float var_a1ddc = var_5b12c - var_cf4ab;
                    highp float var_7d81d = 1.0 - var_05440;
                    highp float var_da39e = 1.0 - var_a1ddc;
                    highp vec4 var_f4a80 = vec4(var_7d81d * var_da39e, var_05440 * var_da39e, var_7d81d * var_a1ddc, var_05440 * var_a1ddc);
                    bool var_206b4 = all(greaterThanEqual(var_eebfd, vec3(0.0)));
                    bool var_e6d47;
                    if (var_206b4)
                    {
                        var_e6d47 = all(lessThan(var_a2de2, vec3(16.0)));
                    }
                    else
                    {
                        var_e6d47 = var_206b4;
                    }
                    highp vec3 var_cadfa;
                    highp vec3 var_aaf20;
                    highp vec3 var_9a4ca;
                    highp vec3 var_e4837;
                    if (var_e6d47)
                    {
                        uvec3 var_e709c = uvec3(var_eebfd);
                        uint var_119be = var_ba630 + ((var_e709c.y + (var_e709c.z * 16u)) + (var_e709c.x * 256u));
                        highp vec3 var_c5049;
                        func_33953(var_119be, var_c5049);
                        uvec3 var_99699 = uvec3(var_9d45f);
                        uint var_97a25 = var_ba630 + ((var_99699.y + (var_99699.z * 16u)) + (var_99699.x * 256u));
                        highp vec3 var_80d01;
                        func_33953(var_97a25, var_80d01);
                        uvec3 var_1a74d = uvec3(var_8ec6c);
                        uint var_c1a23 = var_ba630 + ((var_1a74d.y + (var_1a74d.z * 16u)) + (var_1a74d.x * 256u));
                        highp vec3 var_19337;
                        func_33953(var_c1a23, var_19337);
                        uvec3 var_8ca8c = uvec3(var_a2de2);
                        uint var_aea52 = var_ba630 + ((var_8ca8c.y + (var_8ca8c.z * 16u)) + (var_8ca8c.x * 256u));
                        highp vec3 var_12233;
                        func_33953(var_aea52, var_12233);
                        var_e4837 = var_12233;
                        var_9a4ca = var_19337;
                        var_aaf20 = var_80d01;
                        var_cadfa = var_c5049;
                    }
                    else
                    {
                        highp vec3 var_5f102 = var_e55a8 + var_eebfd;
                        highp vec3 var_946ba;
                        func_593c8(var_5f102, var_e55a8, var_ba630, var_946ba);
                        highp vec3 var_51e8a = var_e55a8 + var_9d45f;
                        highp vec3 var_da287;
                        func_593c8(var_51e8a, var_e55a8, var_ba630, var_da287);
                        highp vec3 var_89718 = var_e55a8 + var_8ec6c;
                        highp vec3 var_bde57;
                        func_593c8(var_89718, var_e55a8, var_ba630, var_bde57);
                        highp vec3 var_31e74 = var_e55a8 + var_a2de2;
                        highp vec3 var_4e7d6;
                        func_593c8(var_31e74, var_e55a8, var_ba630, var_4e7d6);
                        var_e4837 = var_4e7d6;
                        var_9a4ca = var_bde57;
                        var_aaf20 = var_da287;
                        var_cadfa = var_946ba;
                    }
                    var_840de = (((var_cadfa * var_f4a80.x) + (var_aaf20 * var_f4a80.y)) + (var_9a4ca * var_f4a80.z)) + (var_e4837 * var_f4a80.w);
                }
                else
                {
                    highp vec3 var_ca98c = floor(var_65d52);
                    highp vec3 var_fec25 = var_65d52 - var_ca98c;
                    int var_1a22c = (int(var_fec25.x >= var_fec25.y) | (int(var_fec25.y >= var_fec25.z) << 1)) | (int(var_fec25.x >= var_fec25.z) << 2);
                    uvec3 var_562c9 = uvec3(var_ca98c);
                    highp float var_660d6 = min(var_fec25.x, var_fec25.y);
                    highp float var_7e10f = max(var_fec25.x, var_fec25.y);
                    highp float var_e2241 = min(var_660d6, var_fec25.z);
                    highp float var_57cd4 = max(var_7e10f, var_fec25.z);
                    highp float var_9bcc6 = max(min(var_7e10f, var_fec25.z), var_660d6);
                    bool var_e0b29 = all(greaterThanEqual(var_ca98c, vec3(0.0)));
                    bool var_c2b6d;
                    if (var_e0b29)
                    {
                        var_c2b6d = all(lessThan(var_ca98c + vec3(1.0), vec3(16.0)));
                    }
                    else
                    {
                        var_c2b6d = var_e0b29;
                    }
                    highp vec3 var_d71a8;
                    highp vec3 var_b0855;
                    highp vec3 var_51916;
                    highp vec3 var_77ab5;
                    if (var_c2b6d)
                    {
                        uvec3 var_ac914 = var_562c9;
                        uint var_e79d2 = var_ba630 + ((var_ac914.y + (var_ac914.z * 16u)) + (var_ac914.x * 256u));
                        highp vec3 var_5ec12;
                        func_33953(var_e79d2, var_5ec12);
                        uvec3 var_a2325 = var_562c9 + var_4f73b[var_1a22c];
                        uint var_1659c = var_ba630 + ((var_a2325.y + (var_a2325.z * 16u)) + (var_a2325.x * 256u));
                        highp vec3 var_d1b22;
                        func_33953(var_1659c, var_d1b22);
                        uvec3 var_c4f29 = var_562c9 + var_90b85[var_1a22c];
                        uint var_ead17 = var_ba630 + ((var_c4f29.y + (var_c4f29.z * 16u)) + (var_c4f29.x * 256u));
                        highp vec3 var_edee1;
                        func_33953(var_ead17, var_edee1);
                        uvec3 var_632a4 = var_562c9 + uvec3(1u);
                        uint var_a75a5 = var_ba630 + ((var_632a4.y + (var_632a4.z * 16u)) + (var_632a4.x * 256u));
                        highp vec3 var_446c0;
                        func_33953(var_a75a5, var_446c0);
                        var_77ab5 = var_446c0;
                        var_51916 = var_edee1;
                        var_b0855 = var_d1b22;
                        var_d71a8 = var_5ec12;
                    }
                    else
                    {
                        highp vec3 var_df1d5 = var_e55a8 + var_ca98c;
                        highp vec3 var_99a9d;
                        func_593c8(var_df1d5, var_e55a8, var_ba630, var_99a9d);
                        highp vec3 var_3c711 = var_e55a8 + (var_ca98c + vec3(var_4f73b[var_1a22c]));
                        highp vec3 var_de0a1;
                        func_593c8(var_3c711, var_e55a8, var_ba630, var_de0a1);
                        highp vec3 var_fda56 = var_e55a8 + (var_ca98c + vec3(var_90b85[var_1a22c]));
                        highp vec3 var_db77f;
                        func_593c8(var_fda56, var_e55a8, var_ba630, var_db77f);
                        highp vec3 var_cff91 = var_e55a8 + (var_ca98c + vec3(1.0));
                        highp vec3 var_a94b1;
                        func_593c8(var_cff91, var_e55a8, var_ba630, var_a94b1);
                        var_77ab5 = var_a94b1;
                        var_51916 = var_db77f;
                        var_b0855 = var_de0a1;
                        var_d71a8 = var_99a9d;
                    }
                    var_840de = (((var_d71a8 * (1.0 - var_57cd4)) + (var_b0855 * (var_57cd4 - var_9bcc6))) + (var_51916 * (var_9bcc6 - var_e2241))) + (var_77ab5 * var_e2241);
                }
                var_740c9 = var_840de;
            }
            else
            {
                var_740c9 = vec3(0.0);
            }
            var_04dbb = var_740c9;
        }
        else
        {
            var_04dbb = var_645f0;
        }
#ifdef POINT_LIGHT_SHADING__ON
        highp vec4 var_7b503 = var_df80d;
#endif
        highp vec4 var_14063 = SkyAmbientLightColorIntensity;
        highp float var_d41d3 = TileLightIntensity.y * TileLightIntensity.y;
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
        highp vec3 var_a2db8;
        if (var_79009)
        {
            highp vec4 var_7e330 = vec4(1.0);
            highp vec4 var_c04fb = SkyAmbientLightColorIntensity;
            var_a2db8 = max(((vec3(1.0) + (vec3(1.0) * var_7e330.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_c04fb.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
        }
        else
        {
            var_a2db8 = vec3(0.0);
        }
        highp vec3 var_e18ab;
        highp float var_38dc3;
        if (AtmosphericScatteringToggles.x != 0.0)
        {
            highp float var_ae598 = clamp((((length(var_15370) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
            highp vec3 var_a631f;
            if (var_ae598 > 0.0)
            {
                highp vec3 var_8c014;
                if (AtmosphericScatteringToggles.y != 0.0)
                {
                    var_8c014 = FogColor.xyz * max(var_a2db8, vec3(1.0));
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
                var_a631f = var_8c014;
            }
            else
            {
                var_a631f = vec3(0.0);
            }
            var_38dc3 = var_ae598;
            var_e18ab = var_a631f;
        }
        else
        {
            var_38dc3 = 0.0;
            var_e18ab = vec3(0.0);
        }
        highp vec4 var_dccb7 = vec4(var_e18ab, var_38dc3);
        highp vec4 var_53c4b = var_dccb7;
        highp vec4 var_9a637;
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
            var_9a637 = mix(textureLod(s_ScatteringBuffer, vec3(var_2ef05, var_3da09.y, float(var_41fd4)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_2ef05, var_3da09.y, float(var_41fd4 + 1)), 0.0), vec4(clamp(var_f8318 - float(var_41fd4), 0.0, 1.0)));
        }
        else
        {
            var_9a637 = vec4(0.0, 0.0, 0.0, 1.0);
        }
        highp vec4 var_12ded = var_9a637;
#ifdef POINT_LIGHT_SHADING__OFF
        highp vec4 var_31783 = vec4(var_9a637.xyz + (mix((((((var_ccb57 * (1.0 - MERSUniforms.x)) * max((var_04dbb * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_d41d3 * var_d41d3) * TileLightIntensity.y, (TileLightIntensity.y * TileLightIntensity.y) * TileLightIntensity.y, CameraLightIntensity.y)) * var_14063.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_bac38) + var_f2843) + (((mix(var_ccb57, vec3(dot(var_ccb57, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(MERSUniforms.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_dccb7.xyz, vec3(var_53c4b.w)) * var_12ded.w), 1.0);
#endif
#ifdef POINT_LIGHT_SHADING__ON
        highp vec3 var_e68f2 = var_9a637.xyz + (mix((((((var_ccb57 * (1.0 - MERSUniforms.x)) * max(((var_04dbb + (var_df80d.xyz * var_7b503.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_d41d3 * var_d41d3) * TileLightIntensity.y, (TileLightIntensity.y * TileLightIntensity.y) * TileLightIntensity.y, CameraLightIntensity.y)) * var_14063.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_bac38) + var_f2843) + (((mix(var_ccb57, vec3(dot(var_ccb57, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(MERSUniforms.y)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_dccb7.xyz, vec3(var_53c4b.w)) * var_12ded.w);
#endif
        highp vec3 var_055a0;
        if (IBLParameters.x != 0.0)
        {
            highp vec3 var_43a1d;
            highp vec3 var_481f7;
            if (QuantizationParameters.w > 0.0)
            {
                var_481f7 = (u_view * vec4(var_6f1d9, 1.0)).xyz;
                var_43a1d = var_6f1d9;
            }
            else
            {
                var_481f7 = var_15370;
                var_43a1d = v_worldPos;
            }
            highp vec3 var_44ff1 = reflect(normalize(var_43a1d - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_05cd5);
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
                func_f1070(var_645f0, var_3dfec, var_58dff);
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
            highp vec2 var_c1068 = vec2(clamp(dot(var_a2697, -normalize(var_481f7)), 0.0, 1.0), MERSUniforms.z);
            var_c1068.y = 1.0 - var_c1068.y;
            highp vec2 var_25980 = texture(s_BrdfLUT, var_c1068).xy;
            highp vec3 var_aeb8e = var_4fd79 * ((var_207c9 * var_25980.x) + vec3(var_25980.y));
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
            var_055a0 = var_bed08;
        }
        else
        {
            highp vec3 var_0fc0f;
            if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
            {
                highp vec3 var_ff157;
                if (QuantizationParameters.w > 0.0)
                {
                    var_ff157 = (u_view * vec4(var_6f1d9, 1.0)).xyz;
                }
                else
                {
                    var_ff157 = var_15370;
                }
                highp vec4 var_afa9d;
                func_7bae0(var_645f0, var_afa9d);
                highp vec2 var_3e724 = vec2(clamp(dot(var_a2697, -normalize(var_ff157)), 0.0, 1.0), MERSUniforms.z);
                var_3e724.y = 1.0 - var_3e724.y;
                highp vec2 var_f7ae0 = texture(s_BrdfLUT, var_3e724).xy;
                var_0fc0f = var_afa9d.xyz * ((var_207c9 * var_f7ae0.x) + vec3(var_f7ae0.y));
            }
            else
            {
                var_0fc0f = vec3(0.0);
            }
            var_055a0 = var_0fc0f;
        }
#ifdef POINT_LIGHT_SHADING__OFF
        var_b8e62 = var_31783.xyz + var_055a0;
#endif
#ifdef POINT_LIGHT_SHADING__ON
        var_b8e62 = vec4(var_e68f2, 1.0).xyz + var_055a0;
#endif
    }
    else
    {
        var_b8e62 = var_ccb57;
    }
    highp vec4 var_ba5d1 = texture(s_PreviousFrameAverageLuminance, vec2(0.5));
    highp float var_44167 = var_ba5d1.x;
    highp vec3 var_2771c = var_b8e62 + (var_b8e62 * (vec3(LightingEnabledAndAdaptiveEmissive.y, LightingEnabledAndAdaptiveEmissive.y, LightingEnabledAndAdaptiveEmissive.y) / vec3((0.180000007152557373046875 / var_44167) + 9.9999997473787516355514526367188e-05)));
    highp vec3 var_80dc5;
    if (PreExposureEnabled.x > 0.0)
    {
        var_80dc5 = var_2771c * ((0.180000007152557373046875 / var_44167) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_80dc5 = var_2771c;
    }
    bgfx_FragData0 = vec4(var_80dc5, var_63d20.w * var_645ac.w);
}
