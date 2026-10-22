#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - FORWARD_PBR_ALPHA_TEST_PASS (not used)
* - FORWARD_PBR_OPAQUE_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
* - OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF (not used)
* - POINT_LIGHT_SHADING__ON (not used)
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF (not used)
* - RENDER_AS_BILLBOARDS__ON (not used)
*
* Seasons:
* - SEASONS__OFF
* - SEASONS__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 10, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_LightMapTexture;
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 11, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform lowp sampler2D s_PointLightShadowTextureAtlas;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SeasonsTexture;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 12, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
* - layout(binding = 13, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 14, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AlphaMaskedTint;
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
* - uniform vec4 GlobalRoughness;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
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
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 Time;
* - uniform vec4 UndergroundFogColor;
* - uniform vec4 ViewPositionAndTime;
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
struct PBRTextureData {
    highp float colourToMaterialUvScale0;
    highp float colourToMaterialUvScale1;
    highp float colourToMaterialUvBias0;
    highp float colourToMaterialUvBias1;
    highp float colourToNormalUvScale0;
    highp float colourToNormalUvScale1;
    highp float colourToNormalUvBias0;
    highp float colourToNormalUvBias1;
    int flags;
    highp float uniformRoughness;
    highp float uniformEmissive;
    highp float uniformMetalness;
    highp float uniformSubsurface;
    highp float maxMipColour;
    highp float maxMipMer;
    highp float maxMipNormal;
};

const int var_b7fc0[64] = int[](-1, 2, 3, -1, 0, 6, 7, -1, 1, 10, 11, -1, -1, -1, -1, -1, 4, 14, 16, -1, 8, 18, 20, -1, 12, 22, 24, -1, -1, -1, -1, -1, 5, 15, 17, -1, 9, 19, 21, -1, 13, 23, 25, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
struct VoxelNode {
    uint data;
};

const uint var_6262e[3] = uint[](4u, 2u, 1u);
const uint var_59b12[3] = uint[](240u, 204u, 170u);
struct GpuVolumeEntry {
    int packed_xy;
    int packed_zw;
    int hash;
    int user_data;
};

layout(binding = 11, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_0f0bf;
layout(binding = 12, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_e7102;
layout(binding = 10, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_6e28c;
uniform highp mat4 CascadesShadowInvProj[8];
uniform highp mat4 CascadesShadowProj[8];
uniform highp mat4 CloudShadowProj;
uniform highp mat4 PlayerShadowProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_proj;
uniform highp mat4 u_view;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
#ifdef SEASONS__ON
uniform highp sampler2D s_SeasonsTexture;
#endif
uniform highp sampler2DArray s_CausticsTexture;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_SpecularIBLRecords;
#ifdef SEASONS__OFF
uniform highp vec4 AlphaMaskedTint;
#endif
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
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 ConvolutionType;
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
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 NdLFloor;
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
in highp vec3 v_bitangent;
in highp vec4 v_color0;
in highp vec3 v_normal;
flat in int v_pbrTextureId;
in highp vec3 v_tangent;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
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
void func_38275(inout highp float arg_6a625, inout highp float arg_9eee0, inout highp float arg_a50e1, inout highp float arg_d2a5b, inout highp vec3 arg_51e76) {
    if (v_pbrTextureId == 65535)
    {
        arg_6a625 = 0.0;
        arg_9eee0 = 1.0;
        arg_a50e1 = 0.0;
        arg_d2a5b = 0.0;
        arg_51e76 = vec3(0.0, 1.0, 0.0);
        return;
    }
    highp vec2 loc_e8046 = vec2(var_0f0bf.PBRData[v_pbrTextureId].colourToNormalUvScale0, var_0f0bf.PBRData[v_pbrTextureId].colourToNormalUvScale1);
    highp vec2 loc_3128d = vec2(var_0f0bf.PBRData[v_pbrTextureId].colourToNormalUvBias0, var_0f0bf.PBRData[v_pbrTextureId].colourToNormalUvBias1);
    highp vec3 loc_b4ff6;
    if ((var_0f0bf.PBRData[v_pbrTextureId].flags & 4) == 4)
    {
        loc_b4ff6 = (texture(s_MatTexture, (v_texcoord0 * loc_e8046) + loc_3128d).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 loc_a4d0b;
        if ((var_0f0bf.PBRData[v_pbrTextureId].flags & 8) == 8)
        {
            highp vec2 loc_218fe = (v_texcoord0 * loc_e8046) + loc_3128d;
            highp vec3 loc_646d4 = vec3(0.0, 0.0, 1.0);
            highp float loc_b88fd = clamp((min(var_0f0bf.PBRData[v_pbrTextureId].maxMipNormal - var_0f0bf.PBRData[v_pbrTextureId].maxMipColour, var_0f0bf.PBRData[v_pbrTextureId].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
            if (loc_b88fd > 0.0)
            {
                highp vec2 loc_f388f = loc_218fe;
                highp vec2 loc_a836e = loc_f388f * vec2(textureSize(s_MatTexture, 0));
                highp vec2 loc_f7221 = fract(loc_a836e);
                if (abs(loc_f7221.x - 0.5) < 0.0625)
                {
                    loc_218fe.x += ((loc_f7221.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                }
                if (abs(loc_f7221.y - 0.5) < 0.0625)
                {
                    loc_218fe.y += ((loc_f7221.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                }
                highp vec4 loc_224f0 = textureGather(s_MatTexture, loc_218fe);
                highp vec2 loc_7487c = fract(loc_a836e + vec2(0.5));
                highp vec2 loc_ed03c;
                if (loc_7487c.y > 0.5)
                {
                    loc_ed03c = loc_224f0.xy;
                }
                else
                {
                    loc_ed03c = loc_224f0.wz;
                }
                highp vec2 loc_cf71a = loc_ed03c;
                ivec2 loc_31dc2 = ivec2(clamp(vec2(loc_7487c.x - 0.083333335816860198974609375, loc_7487c.x + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                loc_646d4.x = loc_cf71a[loc_31dc2.x] - loc_cf71a[loc_31dc2.y];
                highp vec2 loc_a6d82;
                if (loc_7487c.x > 0.5)
                {
                    loc_a6d82 = loc_224f0.zy;
                }
                else
                {
                    loc_a6d82 = loc_224f0.wx;
                }
                loc_cf71a = loc_a6d82;
                loc_31dc2 = ivec2(clamp(vec2(loc_7487c.y - 0.083333335816860198974609375, loc_7487c.y + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                loc_646d4.y = loc_cf71a[loc_31dc2.x] - loc_cf71a[loc_31dc2.y];
                loc_646d4.z = 0.25;
                highp vec3 loc_3f9e3 = loc_646d4;
                highp vec3 loc_d29bb = normalize(loc_3f9e3);
                loc_646d4 = loc_d29bb;
                highp vec2 loc_0d55c = loc_d29bb.xy * loc_b88fd;
                loc_646d4.x = loc_0d55c.x;
                loc_646d4.y = loc_0d55c.y;
            }
            loc_a4d0b = loc_646d4;
        }
        else
        {
            highp vec3 loc_8d6b3;
            if ((var_0f0bf.PBRData[v_pbrTextureId].flags & 16) == 16)
            {
                highp vec2 loc_268f9 = (v_texcoord0 * loc_e8046) + loc_3128d;
                highp float loc_d849b = min(var_0f0bf.PBRData[v_pbrTextureId].maxMipNormal - var_0f0bf.PBRData[v_pbrTextureId].maxMipColour, var_0f0bf.PBRData[v_pbrTextureId].maxMipNormal);
                highp vec4 loc_946d4 = textureLod(s_MatTexture, loc_268f9, 0.0);
                highp vec4 loc_97cb6 = loc_946d4;
                bool loc_b06a0 = loc_97cb6.x == loc_97cb6.y;
                bool loc_5d1d0;
                if (loc_b06a0)
                {
                    loc_5d1d0 = loc_97cb6.y == loc_97cb6.z;
                }
                else
                {
                    loc_5d1d0 = loc_b06a0;
                }
                highp vec3 loc_049a7;
                if (loc_5d1d0)
                {
                    highp vec2 loc_eaa59 = loc_268f9;
                    highp vec3 loc_b875d = vec3(0.0, 0.0, 1.0);
                    highp float loc_0725d = clamp((loc_d849b * (-1.0)) + 2.0, 0.0, 1.0);
                    if (loc_0725d > 0.0)
                    {
                        highp vec2 loc_7e76e = loc_eaa59;
                        highp vec2 loc_65dec = loc_7e76e * vec2(textureSize(s_MatTexture, 0));
                        highp vec2 loc_3af9d = fract(loc_65dec);
                        if (abs(loc_3af9d.x - 0.5) < 0.0625)
                        {
                            loc_eaa59.x += ((loc_3af9d.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                        }
                        if (abs(loc_3af9d.y - 0.5) < 0.0625)
                        {
                            loc_eaa59.y += ((loc_3af9d.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                        }
                        highp vec4 loc_e61ed = textureGather(s_MatTexture, loc_eaa59);
                        highp vec2 loc_99152 = fract(loc_65dec + vec2(0.5));
                        highp vec2 loc_9413e;
                        if (loc_99152.y > 0.5)
                        {
                            loc_9413e = loc_e61ed.xy;
                        }
                        else
                        {
                            loc_9413e = loc_e61ed.wz;
                        }
                        highp vec2 loc_1eb74 = loc_9413e;
                        ivec2 loc_653e7 = ivec2(clamp(vec2(loc_99152.x - 0.083333335816860198974609375, loc_99152.x + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                        loc_b875d.x = loc_1eb74[loc_653e7.x] - loc_1eb74[loc_653e7.y];
                        highp vec2 loc_11531;
                        if (loc_99152.x > 0.5)
                        {
                            loc_11531 = loc_e61ed.zy;
                        }
                        else
                        {
                            loc_11531 = loc_e61ed.wx;
                        }
                        loc_1eb74 = loc_11531;
                        loc_653e7 = ivec2(clamp(vec2(loc_99152.y - 0.083333335816860198974609375, loc_99152.y + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                        loc_b875d.y = loc_1eb74[loc_653e7.x] - loc_1eb74[loc_653e7.y];
                        loc_b875d.z = 0.25;
                        highp vec3 loc_b2631 = loc_b875d;
                        highp vec3 loc_8a8c2 = normalize(loc_b2631);
                        loc_b875d = loc_8a8c2;
                        highp vec2 loc_3f5e9 = loc_8a8c2.xy * loc_0725d;
                        loc_b875d.x = loc_3f5e9.x;
                        loc_b875d.y = loc_3f5e9.y;
                    }
                    loc_049a7 = loc_b875d;
                }
                else
                {
                    highp vec4 loc_807fe = loc_946d4;
                    highp vec3 loc_70cf3 = vec3(0.0, 0.0, 1.0);
                    highp float loc_3e159 = clamp((loc_d849b * (-1.0)) + 2.0, 0.0, 1.0);
                    if (loc_3e159 > 0.0)
                    {
                        highp vec2 loc_6c8bb = fract(loc_268f9 * vec2(textureSize(s_MatTexture, 0)));
                        loc_70cf3.x = (step(0.916666686534881591796875, loc_6c8bb.x) * ((loc_807fe.y * 2.0) - 1.0)) + (step(loc_6c8bb.x, 0.083333335816860198974609375) * (1.0 - (loc_807fe.w * 2.0)));
                        loc_70cf3.y = (step(0.916666686534881591796875, loc_6c8bb.y) * ((loc_807fe.z * 2.0) - 1.0)) + (step(loc_6c8bb.y, 0.083333335816860198974609375) * (1.0 - (loc_807fe.x * 2.0)));
                        loc_70cf3.x = step(0.004999999888241291046142578125, abs(loc_70cf3.x)) * loc_70cf3.x;
                        loc_70cf3.y = step(0.004999999888241291046142578125, abs(loc_70cf3.y)) * loc_70cf3.y;
                        loc_70cf3.z = 0.25;
                        highp vec3 loc_b8a95 = loc_70cf3;
                        highp vec3 loc_ee313 = normalize(loc_b8a95);
                        loc_70cf3 = loc_ee313;
                        highp vec2 loc_dc230 = loc_ee313.xy * loc_3e159;
                        loc_70cf3.x = loc_dc230.x;
                        loc_70cf3.y = loc_dc230.y;
                    }
                    loc_049a7 = loc_70cf3;
                }
                loc_8d6b3 = loc_049a7;
            }
            else
            {
                loc_8d6b3 = vec3(0.0, 0.0, 1.0);
            }
            loc_a4d0b = loc_8d6b3;
        }
        loc_b4ff6 = loc_a4d0b;
    }
    highp float loc_659d6;
    highp float loc_73c14;
    highp float loc_00c14;
    highp float loc_d7d8a;
    if ((var_0f0bf.PBRData[v_pbrTextureId].flags & 1) == 1)
    {
        highp vec4 loc_300fb = texture(s_MatTexture, (v_texcoord0 * vec2(var_0f0bf.PBRData[v_pbrTextureId].colourToMaterialUvScale0, var_0f0bf.PBRData[v_pbrTextureId].colourToMaterialUvScale1)) + vec2(var_0f0bf.PBRData[v_pbrTextureId].colourToMaterialUvBias0, var_0f0bf.PBRData[v_pbrTextureId].colourToMaterialUvBias1));
        highp float loc_c4db1;
        if ((var_0f0bf.PBRData[v_pbrTextureId].flags & 2) == 2)
        {
            loc_c4db1 = loc_300fb.w;
        }
        else
        {
            loc_c4db1 = var_0f0bf.PBRData[v_pbrTextureId].uniformSubsurface;
        }
        loc_d7d8a = loc_c4db1;
        loc_00c14 = loc_300fb.y;
        loc_73c14 = loc_300fb.x;
        loc_659d6 = loc_300fb.z;
    }
    else
    {
        loc_d7d8a = var_0f0bf.PBRData[v_pbrTextureId].uniformSubsurface;
        loc_00c14 = var_0f0bf.PBRData[v_pbrTextureId].uniformEmissive;
        loc_73c14 = var_0f0bf.PBRData[v_pbrTextureId].uniformMetalness;
        loc_659d6 = var_0f0bf.PBRData[v_pbrTextureId].uniformRoughness;
    }
    highp vec3 loc_93b23;
    if (int(gl_FrontFacing) != 0)
    {
        loc_93b23 = -v_normal;
    }
    else
    {
        loc_93b23 = v_normal;
    }
    arg_6a625 = loc_73c14;
    arg_9eee0 = loc_659d6;
    arg_a50e1 = loc_00c14;
    arg_d2a5b = loc_d7d8a;
    arg_51e76 = transpose(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(loc_93b23)))) * loc_b4ff6;
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
void func_aab62(inout highp vec3 arg_87514, inout highp vec3 arg_c03dc, inout highp vec3 arg_58fab, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_ae81a, inout highp float arg_bfb77, inout highp vec3 arg_c7286, inout highp float arg_e0484, inout highp vec3 arg_08b90, inout highp vec3 arg_bcfb6, inout highp float arg_b14d8, inout highp float arg_67b92) {
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
    arg_87514 = ((((((vec3(1.0) - loc_00b7f) * mix(loc_947b2, max((dot(arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_d8782 * loc_d8782), 0.0), arg_67b92)) * (loc_82e5e * vec3(0.3183098733425140380859375))) * loc_0f714) + (((loc_82e5e * vec3(0.3183098733425140380859375)) * (arg_67b92 * max((dot(-arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_65d74 * loc_65d74), 0.0))) * loc_f89fe)) * loc_f0a2f) * DiffuseSpecularEmissiveAmbientTermToggles.x;
    arg_c03dc = ((((((loc_00b7f * (loc_3da81 / ((loc_c16ab * loc_c16ab) * 3.1415927410125732421875))) * ((loc_fefd5 / (((loc_fefd5 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)) * (loc_947b2 / (((loc_947b2 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_947b2) * loc_fefd5) + 9.9999997473787516355514526367188e-05)) * loc_947b2) * loc_0f714) * loc_f0a2f) * DiffuseSpecularEmissiveAmbientTermToggles.y;
}
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
        uint loc_a385f = (var_e7102.VoxelBuffer[loc_a0cb4].data >> loc_b118b) & 3u;
        uint loc_95bf0 = ((var_e7102.VoxelBuffer[loc_a0cb4].data >> 16u) >> loc_b118b) & 3u;
        uint loc_6dacb = (var_e7102.VoxelBuffer[loc_50d99].data >> loc_b118b) & 3u;
        uint loc_f9969 = ((var_e7102.VoxelBuffer[loc_50d99].data >> 16u) >> loc_b118b) & 3u;
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
        uint loc_a4225 = var_e7102.VoxelBuffer[loc_9766b + loc_f2544].data >> loc_2dbd6;
        uint loc_63c72;
        if (loc_2dbd6 > 12u)
        {
            loc_63c72 = loc_a4225 | (var_e7102.VoxelBuffer[(loc_9766b + loc_f2544) + 1u].data << (32u - loc_2dbd6));
        }
        else
        {
            loc_63c72 = loc_a4225;
        }
        uint loc_680e3 = (loc_63c72 & 3u) | ((loc_63c72 >> 16u) & 12u);
        uint loc_9a4d6 = (((var_e7102.VoxelBuffer[loc_a0cb4].data & 1u) | (((var_e7102.VoxelBuffer[loc_a0cb4].data >> 16u) & 1u) << 1u)) | ((var_e7102.VoxelBuffer[loc_50d99].data & 1u) << 2u)) | (((var_e7102.VoxelBuffer[loc_50d99].data >> 16u) & 1u) << 3u);
        arg_a965a = ((loc_680e3 & 3u) | ((loc_680e3 & 12u) << 2u)) | (((loc_9a4d6 & 3u) | ((loc_9a4d6 & 12u) << 2u)) << 2u);
        return;
    }
    uint loc_3413e = ((((var_e7102.VoxelBuffer[loc_a0cb4].data >> 15u) & 1u) | (((var_e7102.VoxelBuffer[loc_a0cb4].data >> 31u) & 1u) << 1u)) | (((var_e7102.VoxelBuffer[loc_50d99].data >> 15u) & 1u) << 2u)) | (((var_e7102.VoxelBuffer[loc_50d99].data >> 31u) & 1u) << 3u);
    ivec3 loc_f0131 = arg_f7dc9;
    uint loc_3a44a = (uint(loc_f0131.x - (-1)) * 18u) + uint(loc_f0131.z - (-1));
    uint loc_1d03f = loc_3a44a / 32u;
    uint loc_dcf35 = loc_3a44a % 32u;
    uint loc_38235 = arg_45009 + 4440u;
    uint loc_c3396 = var_e7102.VoxelBuffer[loc_38235 + loc_1d03f].data >> loc_dcf35;
    uint loc_f671b;
    if (loc_dcf35 > 12u)
    {
        loc_f671b = loc_c3396 | (var_e7102.VoxelBuffer[(loc_38235 + loc_1d03f) + 1u].data << (32u - loc_dcf35));
    }
    else
    {
        loc_f671b = loc_c3396;
    }
    uint loc_88411 = (loc_f671b & 3u) | ((loc_f671b >> 16u) & 12u);
    arg_a965a = ((loc_3413e & 3u) | ((loc_3413e & 12u) << 2u)) | (((loc_88411 & 3u) | ((loc_88411 & 12u) << 2u)) << 2u);
}
void func_93a41(inout uint arg_d6211, inout int arg_401db, inout highp vec3 arg_aa7d7) {
    if (var_e7102.VoxelBuffer[arg_d6211[arg_401db]].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_17ab1 = vec4(uvec4(var_e7102.VoxelBuffer[arg_d6211[arg_401db]].data, var_e7102.VoxelBuffer[arg_d6211[arg_401db]].data >> 8u, var_e7102.VoxelBuffer[arg_d6211[arg_401db]].data >> 16u, var_e7102.VoxelBuffer[arg_d6211[arg_401db]].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_17ab1;
    arg_aa7d7 = (loc_17ab1.xyz * loc_3ff2a.w) * 6.0;
}
void func_33953(inout uint arg_a601e, inout highp vec3 arg_aa7d7) {
    if (var_e7102.VoxelBuffer[arg_a601e].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_11fc1 = vec4(uvec4(var_e7102.VoxelBuffer[arg_a601e].data, var_e7102.VoxelBuffer[arg_a601e].data >> 8u, var_e7102.VoxelBuffer[arg_a601e].data >> 16u, var_e7102.VoxelBuffer[arg_a601e].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_11fc1;
    arg_aa7d7 = (loc_11fc1.xyz * loc_3ff2a.w) * 6.0;
}
void func_e0a6a(inout int arg_528e6, inout uint arg_2d77f, inout highp vec3 arg_534d1, inout highp vec3 arg_13804, inout highp vec3 arg_18a62, inout uint arg_92f3d) {
    bool loc_c7009 = var_b7fc0[arg_528e6] >= 0;
    bool loc_40b62;
    if (loc_c7009)
    {
        loc_40b62 = !((var_e7102.VoxelBuffer[arg_2d77f].data & (1u << uint(var_b7fc0[arg_528e6]))) != 0u);
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
        loc_58bb3 = (var_e7102.VoxelBuffer[(arg_92f3d + 4097u) + uint(var_b7fc0[arg_528e6])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
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
        loc_58bb3 = (var_e7102.VoxelBuffer[(arg_92f3d + 4097u) + uint(var_b7fc0[arg_689f7])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
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
        loc_aa1a7 = !((var_e7102.VoxelBuffer[arg_ccc49 + 4096u].data & (1u << uint(var_b7fc0[arg_eae48]))) != 0u);
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
        loc_58bb3 = (var_e7102.VoxelBuffer[(arg_ccc49 + 4097u) + uint(var_b7fc0[arg_eae48])].data >> 2u) + ((loc_441ec.y + (loc_441ec.z * 16u)) + (loc_441ec.x * 256u));
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
void func_d903a(inout highp vec4 arg_d4081, inout highp float arg_19032, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec3 loc_94d26 = (arg_d4081.xyz * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x;
    highp vec3 loc_cfa08 = mix(AmbientLightParams.xyz * AmbientLightParams.w, loc_94d26, vec3(clamp(dot(loc_94d26, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), 0.0, 1.0))) * arg_19032;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_cfa08, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_cfa08, 1.0);
}
void main() {
#ifdef SEASONS__ON
    highp vec4 var_fb4fb = texture(s_MatTexture, v_texcoord0);
#endif
#ifdef SEASONS__OFF
    highp vec4 var_7a906 = texture(s_MatTexture, v_texcoord0);
    if (AlphaMaskedTint.x != 0.0)
    {
        highp vec4 var_ec353 = var_7a906;
        highp float var_7a181 = var_7a906.w;
        highp vec3 var_d8fa6 = mix(var_ec353.xyz, var_ec353.xyz * v_color0.xyz, vec3(var_7a181));
        var_7a906.x = var_d8fa6.x;
        var_7a906.y = var_d8fa6.y;
        var_7a906.z = var_d8fa6.z;
        highp vec4 var_8e56a = var_7a906;
        highp vec3 var_a3d7a = var_8e56a.xyz * v_color0.w;
        var_7a906.x = var_a3d7a.x;
        var_7a906.y = var_a3d7a.y;
        var_7a906.z = var_a3d7a.z;
        var_7a906.w = 1.0;
    }
    else
    {
        highp vec4 var_bc465 = var_7a906;
        highp vec3 var_30e20 = var_bc465.xyz * v_color0.xyz;
        var_7a906.x = var_30e20.x;
        var_7a906.y = var_30e20.y;
        var_7a906.z = var_30e20.z;
        var_7a906.w *= v_color0.w;
    }
#endif
#ifdef SEASONS__ON
    highp vec3 var_861c6 = v_color0.xyz;
    highp vec4 var_a4dc1 = var_fb4fb;
    highp vec3 var_32afa = var_fb4fb.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_861c6.z));
    var_a4dc1.x = var_32afa.x;
    var_a4dc1.y = var_32afa.y;
    var_a4dc1.z = var_32afa.z;
    highp vec4 var_0fcb9 = var_a4dc1;
    highp vec3 var_4e36a = var_0fcb9.xyz * vec3(v_color0.w);
    var_a4dc1.x = var_4e36a.x;
    var_a4dc1.y = var_4e36a.y;
    var_a4dc1.z = var_4e36a.z;
    var_a4dc1.w = 1.0;
    highp vec4 var_7a906 = var_a4dc1;
#endif
    highp vec3 var_7dedb;
#ifdef SEASONS__OFF
    func_66b9c(var_7dedb, var_7a906);
#endif
#ifdef SEASONS__ON
    func_66b9c(var_7dedb, var_a4dc1);
#endif
    highp vec3 var_d2ce2;
    highp float var_5e5e9;
    highp float var_b5039;
    highp float var_84dc0;
    highp float var_6f03b;
    func_38275(var_6f03b, var_84dc0, var_b5039, var_5e5e9, var_d2ce2);
    highp vec4 var_930c5 = u_view * vec4(v_worldPos, 1.0);
    highp vec4 var_e87e0 = u_proj * var_930c5;
    highp vec4 var_b8928 = var_e87e0;
    highp vec3 var_12830 = var_e87e0.xyz / vec3(var_b8928.w);
    highp vec3 var_b4b34 = normalize(var_d2ce2);
    highp vec4 var_e14aa = vec4(var_b4b34, 0.0);
    highp vec3 var_1b7cc = var_930c5.xyz;
    highp vec3 var_219ab = v_worldPos - WorldOrigin.xyz;
    highp vec3 var_eebcb = dFdx(var_1b7cc);
    highp vec3 var_211c8 = dFdy(var_1b7cc);
    highp vec3 var_322a5 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(var_eebcb), normalize(var_211c8))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_fddd0 = vec3(QuantizationParameters.z * 0.5) - mod(var_219ab, vec3(QuantizationParameters.z));
    highp vec3 var_a4be8 = (var_219ab + (var_fddd0 - (var_322a5 * dot(var_fddd0, var_322a5)))) + WorldOrigin.xyz;
    highp vec3 var_864e9 = var_e14aa.xyz;
    highp vec3 var_a4bd4 = (u_view * var_e14aa).xyz;
    highp vec3 var_d1d69 = normalize(v_normal);
    bvec3 var_8d14e = greaterThanEqual(abs(var_d1d69), vec3(0.9900000095367431640625));
    highp vec3 var_b9aeb = vec3(ivec3(any(lessThan(var_d1d69, vec3(-0.5))) ? (-1) : 1) * ivec3(int(var_8d14e.x), int(var_8d14e.y), int(var_8d14e.z)));
    highp vec3 var_f88c4 = BlockLightColor.xyz;
    highp vec3 var_5b4a8;
    if ((((var_f88c4.x + var_f88c4.y) + var_f88c4.z) < 9.9999997473787516355514526367188e-05) && (TileLightIntensity.x > 9.9999997473787516355514526367188e-05))
    {
        highp float var_c1e8f = TileLightIntensity.x * TileLightIntensity.x;
        var_5b4a8 = clamp(vec3(var_c1e8f, var_c1e8f * ((((var_c1e8f * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625), var_c1e8f * (((var_c1e8f * var_c1e8f) * 0.60000002384185791015625) + 0.4000000059604644775390625)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_5b4a8 = BlockLightColor.xyz;
    }
    highp vec4 var_8d364 = vec4(var_5b4a8, 0.0);
    highp vec3 var_dd12c = vec3(0.039999999105930328369140625 * (1.0 - var_6f03b)) + (var_7dedb * var_6f03b);
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
    highp float var_106e2 = length(var_1b7cc);
    highp vec3 var_5bd0a = var_12830;
    highp vec3 var_48867;
    highp vec3 var_1163d;
    highp vec3 var_eb774;
    highp vec3 var_9bf27;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_384dc = -(var_1b7cc / vec3(length(var_1b7cc) + 9.9999997473787516355514526367188e-05));
        highp float var_4162b = var_5e5e9 * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
        highp vec3 var_6cfc2 = var_1b7cc;
        highp vec3 var_b5d88;
        if (int(QuantizationParameters.y) > 0)
        {
            var_b5d88 = var_a4be8;
        }
        else
        {
            var_b5d88 = v_worldPos;
        }
        highp vec3 var_e520d;
        highp vec3 var_12f6e;
        func_aab62(var_12f6e, var_e520d, var_a4bd4, var_b5d88, var_864e9, var_6cfc2, var_b82c9, var_384dc, var_84dc0, var_dd12c, var_7dedb, var_6f03b, var_4162b);
        highp vec4 var_512e0 = var_8d364;
        bool var_f91fc = any(notEqual(var_b9aeb, vec3(0.0)));
        highp vec3 var_2111b;
        if (var_f91fc)
        {
            var_2111b = var_b9aeb;
        }
        else
        {
            var_2111b = var_864e9;
        }
        highp vec3 var_b9249;
        if ((DirectionalLightToggleAndMaxCascadesPerLightAndGPUBlockLightingEnabled.z != 0.0) && (!((uint(floor(var_512e0.w * 255.0)) & 1u) != 0u)))
        {
            highp vec3 var_bde2b = v_worldPos - WorldOrigin.xyz;
            bool var_2b694;
            if (var_f91fc)
            {
                highp float var_78b3d = dot(var_bde2b, abs(var_2111b));
                var_2b694 = abs(var_78b3d - round(var_78b3d)) > 0.001000000047497451305389404296875;
            }
            else
            {
                var_2b694 = var_f91fc;
            }
            highp vec3 var_f7ba1 = (var_bde2b - vec3(0.5)) + (var_2111b * 0.0199999995529651641845703125);
            highp vec3 var_8ac5d = var_2111b;
            highp vec3 var_5a5cb = floor(var_f7ba1 * 0.0625) * 16.0;
            highp vec3 var_be08f = var_f7ba1 - var_5a5cb;
            ivec4 var_7f823 = ivec4(ivec3(floor(vec3(ivec3(floor(var_f7ba1))) * vec3(0.0625))), 0);
            ivec4 var_a2c78 = var_7f823;
            int var_8282d = (var_a2c78.x & 65535) | (var_a2c78.y << 16);
            int var_db019 = (var_a2c78.z & 65535) | (var_a2c78.w << 16);
            ivec4 var_e83d2 = var_7f823;
            uint var_dbe8c = uint(var_e83d2.x) * 1540483477u;
            uint var_35207 = uint(var_e83d2.y) * 1540483477u;
            uint var_c7c69 = uint(var_e83d2.z) * 1540483477u;
            uint var_7c89d = uint(var_e83d2.w) * 1540483477u;
            uint var_ea647 = ((((((2293326976u ^ ((var_dbe8c ^ (var_dbe8c >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_35207 ^ (var_35207 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_c7c69 ^ (var_c7c69 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_7c89d ^ (var_7c89d >> uint(24))) * 1540483477u);
            uint var_66e52 = (var_ea647 ^ (var_ea647 >> uint(13))) * 1540483477u;
            uint var_02650 = var_66e52 ^ (var_66e52 >> uint(15));
            uint var_b516a = (var_02650 ^ (var_02650 >> uint(16))) & 65535u;
            uint var_0b021 = var_b516a | uint(var_b516a == 0u);
            uint var_0fd8c = uint(GpuEntryBufferCapacity.x);
            int var_4bfc3;
            uint var_1bd82;
            bool var_59b60;
            uint var_e4d40;
            var_e4d40 = 0u;
            var_59b60 = false;
            var_1bd82 = var_0b021 & (var_0fd8c - 1u);
            var_4bfc3 = 0;
            bool var_40c1a;
            uint var_d40b4;
            uint var_8d8f4;
            uint var_d9aef;
            bool var_4680b;
            for (;;)
            {
                if (var_4bfc3 < 8)
                {
                    uint var_b3275 = uint(var_6e28c.GpuEntryBuffer[var_1bd82].hash) & 65535u;
                    bool var_079e7 = var_b3275 == var_0b021;
                    bool var_88b02;
                    if (var_079e7)
                    {
                        var_88b02 = var_6e28c.GpuEntryBuffer[var_1bd82].packed_xy == var_8282d;
                    }
                    else
                    {
                        var_88b02 = var_079e7;
                    }
                    bool var_4f663;
                    if (var_88b02)
                    {
                        var_4f663 = var_6e28c.GpuEntryBuffer[var_1bd82].packed_zw == var_db019;
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
                            var_fbc90 = uint(var_6e28c.GpuEntryBuffer[var_1bd82].user_data);
                        }
                        else
                        {
                            var_fbc90 = var_e4d40;
                        }
                        var_8d8f4 = var_fbc90;
                    }
                    var_40c1a = var_59b60 || var_4f663;
                    var_d40b4 = (var_1bd82 + 1u) & (var_0fd8c - 1u);
                    if (var_40c1a || (var_b3275 == 0u))
                    {
                        var_4680b = var_40c1a;
                        var_d9aef = var_8d8f4;
                        break;
                    }
                    var_e4d40 = var_8d8f4;
                    var_59b60 = var_40c1a;
                    var_1bd82 = var_d40b4;
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
            uint var_860df = var_d9aef >> 2u;
            highp vec3 var_740c9;
            if (var_4680b)
            {
                highp vec3 var_d3ea7 = var_f7ba1 + vec3(0.5);
                highp vec3 var_83391 = var_d3ea7;
                highp float var_b37f4;
                if (var_8ac5d.x > 0.0)
                {
                    var_b37f4 = ceil(var_83391.x) - 1.0;
                }
                else
                {
                    var_b37f4 = floor(var_83391.x);
                }
                highp float var_b0d7b;
                if (var_8ac5d.y > 0.0)
                {
                    var_b0d7b = ceil(var_83391.y) - 1.0;
                }
                else
                {
                    var_b0d7b = floor(var_83391.y);
                }
                highp float var_7f87a;
                if (var_8ac5d.z > 0.0)
                {
                    var_7f87a = ceil(var_83391.z) - 1.0;
                }
                else
                {
                    var_7f87a = floor(var_83391.z);
                }
                ivec3 var_935ea = ivec3(int(var_b37f4), int(var_b0d7b), int(var_7f87a));
                ivec3 var_42fdb = clamp(ivec3(round(var_d3ea7)) - ivec3(1), var_935ea - ivec3(1), var_935ea);
                ivec3 var_b550b = var_42fdb - ivec3(var_5a5cb);
                ivec3 var_bfc97 = var_b550b;
                uint var_6fcab;
                func_fff8e(var_860df, var_bfc97, var_6fcab, var_b550b);
                uint var_9a093;
                uint var_a6fc9;
                if (dot(var_2111b, var_2111b) > 0.0)
                {
                    uvec3 var_c205b = uvec3(var_935ea - var_42fdb);
                    uint var_1848c = ((var_c205b.x * 4u) + (var_c205b.y * 2u)) + var_c205b.z;
                    uint var_bdca4;
                    if (var_2b694)
                    {
                        var_bdca4 = var_6fcab & (~(1u << var_1848c));
                    }
                    else
                    {
                        var_bdca4 = var_6fcab;
                    }
                    highp vec3 var_64cec = abs(var_2111b);
                    bool var_a9495 = var_64cec.x >= var_64cec.y;
                    bool var_73031;
                    if (var_a9495)
                    {
                        var_73031 = var_64cec.x >= var_64cec.z;
                    }
                    else
                    {
                        var_73031 = var_a9495;
                    }
                    uint var_837f7;
                    if (var_73031)
                    {
                        var_837f7 = 0u;
                    }
                    else
                    {
                        uint var_fdfd7;
                        if (var_64cec.y >= var_64cec.z)
                        {
                            var_fdfd7 = 1u;
                        }
                        else
                        {
                            var_fdfd7 = 2u;
                        }
                        var_837f7 = var_fdfd7;
                    }
                    uint var_173cc;
                    if ((var_bdca4 & (1u << var_1848c)) != 0u)
                    {
                        var_173cc = var_1848c ^ var_6262e[var_837f7];
                    }
                    else
                    {
                        var_173cc = var_1848c;
                    }
                    uint var_9e4ef;
                    if ((var_173cc & var_6262e[var_837f7]) != 0u)
                    {
                        var_9e4ef = var_59b12[var_837f7] ^ 255u;
                    }
                    else
                    {
                        var_9e4ef = var_59b12[var_837f7];
                    }
                    uint var_85a55 = (var_6262e[var_837f7] == 4u) ? 2u : 4u;
                    uint var_35622 = (var_6262e[var_837f7] == 1u) ? 2u : 1u;
                    uint var_233b3 = (1u << (var_173cc ^ var_85a55)) | (1u << (var_173cc ^ var_35622));
                    uint var_94d03;
                    if ((var_bdca4 & var_233b3) == var_233b3)
                    {
                        var_94d03 = var_9e4ef | (1u << ((var_173cc ^ var_85a55) ^ var_35622));
                    }
                    else
                    {
                        var_94d03 = var_9e4ef;
                    }
                    var_a6fc9 = var_173cc;
                    var_9a093 = var_94d03 | var_bdca4;
                }
                else
                {
                    var_a6fc9 = 0u;
                    var_9a093 = var_6fcab;
                }
                highp vec3 var_049a7;
                if (var_f91fc)
                {
                    highp vec3 var_b22a1 = abs(var_2111b);
                    highp vec3 var_bd5bf = var_b22a1.zxy;
                    highp vec3 var_0310e = var_b22a1.yzx;
                    highp float var_cbae7 = dot(var_be08f, var_bd5bf);
                    highp float var_743bb = dot(var_be08f, var_0310e);
                    highp float var_a9e19 = floor(var_cbae7);
                    highp float var_b5d82 = floor(var_743bb);
                    highp vec3 var_5da8a = ((var_b22a1 * dot(vec3(var_b550b + ivec3(uvec3(uint((var_a6fc9 & 4u) != 0u), uint((var_a6fc9 & 2u) != 0u), uint((var_a6fc9 & 1u) != 0u)))), var_b22a1)) + (var_bd5bf * var_a9e19)) + (var_0310e * var_b5d82);
                    ivec3 var_f96b9 = ivec3(var_5da8a);
                    ivec3 var_317c4 = ivec3(var_5da8a + var_bd5bf);
                    ivec3 var_32eae = ivec3(var_5da8a + var_0310e);
                    ivec3 var_f7395 = ivec3((var_5da8a + var_bd5bf) + var_0310e);
                    ivec3 var_84ab7[4] = ivec3[](var_f96b9, var_317c4, var_32eae, var_f7395);
                    highp vec2 var_becab = vec2(var_cbae7 - var_a9e19, var_743bb - var_b5d82);
                    highp vec3 var_c8a61;
                    func_fc671(var_317c4, var_f96b9, var_32eae, var_b550b, var_9a093, var_f7395, var_860df, var_84ab7, var_5a5cb, var_c8a61, var_becab);
                    var_049a7 = var_c8a61;
                }
                else
                {
                    highp vec3 var_20a52 = clamp(fract(var_f7ba1), vec3(0.0), vec3(1.0));
                    ivec3 var_f9cff = var_42fdb - ivec3(var_5a5cb);
                    bool var_f2e69 = all(greaterThanEqual(var_f9cff, ivec3(0)));
                    bool var_16c16;
                    if (var_f2e69)
                    {
                        var_16c16 = all(lessThan(var_f9cff, ivec3(15)));
                    }
                    else
                    {
                        var_16c16 = var_f2e69;
                    }
                    highp float var_77bd0 = float((var_9a093 & 1u) == 0u);
                    highp float var_21da3 = float((var_9a093 & 2u) == 0u);
                    highp float var_a9c16 = float((var_9a093 & 4u) == 0u);
                    highp float var_db288 = float((var_9a093 & 8u) == 0u);
                    highp float var_fa371 = float((var_9a093 & 16u) == 0u);
                    highp float var_518fa = float((var_9a093 & 32u) == 0u);
                    highp float var_91aef = float((var_9a093 & 64u) == 0u);
                    highp float var_c904c = float((var_9a093 & 128u) == 0u);
                    highp vec3 var_8bfd5;
                    func_269a6(var_77bd0, var_8bfd5, var_16c16, var_f9cff, var_860df, var_42fdb, var_5a5cb);
                    highp vec3 var_8e62c;
                    func_87677(var_21da3, var_8e62c, var_16c16, var_f9cff, var_860df, var_42fdb, var_5a5cb);
                    highp vec3 var_8eff3;
                    func_8e24a(var_a9c16, var_8eff3, var_16c16, var_f9cff, var_860df, var_42fdb, var_5a5cb);
                    highp vec3 var_b1891;
                    func_fd360(var_db288, var_b1891, var_16c16, var_f9cff, var_860df, var_42fdb, var_5a5cb);
                    highp vec3 var_d62e0;
                    func_0b7c2(var_fa371, var_d62e0, var_16c16, var_f9cff, var_860df, var_42fdb, var_5a5cb);
                    highp vec3 var_95dfe;
                    func_dcccf(var_518fa, var_95dfe, var_16c16, var_f9cff, var_860df, var_42fdb, var_5a5cb);
                    highp vec3 var_51773;
                    func_70277(var_91aef, var_51773, var_16c16, var_f9cff, var_860df, var_42fdb, var_5a5cb);
                    highp vec3 var_91047;
                    func_e43d6(var_c904c, var_91047, var_16c16, var_f9cff, var_860df, var_42fdb, var_5a5cb);
                    highp float var_c95e6 = 1.0 - var_20a52.x;
                    highp float var_68118 = 1.0 - var_20a52.y;
                    highp float var_1f745 = 1.0 - var_20a52.z;
                    highp float var_61c75 = ((var_c95e6 * var_68118) * var_1f745) * var_77bd0;
                    highp float var_a2a4d = ((var_c95e6 * var_68118) * var_20a52.z) * var_21da3;
                    highp float var_549e5 = ((var_c95e6 * var_20a52.y) * var_1f745) * var_a9c16;
                    highp float var_10130 = ((var_c95e6 * var_20a52.y) * var_20a52.z) * var_db288;
                    highp float var_4477f = ((var_20a52.x * var_68118) * var_1f745) * var_fa371;
                    highp float var_2fe70 = ((var_20a52.x * var_68118) * var_20a52.z) * var_518fa;
                    highp float var_75445 = ((var_20a52.x * var_20a52.y) * var_1f745) * var_91aef;
                    highp float var_c56f3 = ((var_20a52.x * var_20a52.y) * var_20a52.z) * var_c904c;
                    highp float var_53bc4 = ((((((var_61c75 + var_a2a4d) + var_549e5) + var_10130) + var_4477f) + var_2fe70) + var_75445) + var_c56f3;
                    highp vec3 var_419fa;
                    if (var_53bc4 > 0.0)
                    {
                        var_419fa = ((((((((var_8bfd5 * var_61c75) + (var_8e62c * var_a2a4d)) + (var_8eff3 * var_549e5)) + (var_b1891 * var_10130)) + (var_d62e0 * var_4477f)) + (var_95dfe * var_2fe70)) + (var_51773 * var_75445)) + (var_91047 * var_c56f3)) / vec3(var_53bc4);
                    }
                    else
                    {
                        var_419fa = vec3(0.0);
                    }
                    var_049a7 = var_419fa;
                }
                var_740c9 = var_049a7;
            }
            else
            {
                var_740c9 = vec3(0.0);
            }
            var_b9249 = var_740c9;
        }
        else
        {
            var_b9249 = var_8d364.xyz;
        }
        highp vec4 var_3df32 = SkyAmbientLightColorIntensity;
        highp float var_fc65f = TileLightIntensity.y * TileLightIntensity.y;
        var_9bf27 = var_12f6e;
        var_eb774 = var_e520d;
        var_1163d = ((var_7dedb * (1.0 - var_6f03b)) * max((var_b9249 * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_fc65f * var_fc65f) * TileLightIntensity.y, (TileLightIntensity.y * TileLightIntensity.y) * TileLightIntensity.y, CameraLightIntensity.y)) * var_3df32.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w;
        var_48867 = ((mix(var_7dedb, vec3(dot(var_7dedb, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_b5039)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x;
    }
    else
    {
        var_9bf27 = vec3(0.0);
        var_eb774 = vec3(0.0);
        var_1163d = vec3(0.0);
        var_48867 = vec3(0.0);
    }
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
    highp vec3 var_9e815;
    if (var_68aa1)
    {
        highp vec4 var_38d79 = SkyAmbientLightColorIntensity;
        var_9e815 = max((vec3(1.0) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_38d79.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_9e815 = vec3(0.0);
    }
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_79b3e = clamp((((length(var_1b7cc) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_79b3e > 0.0)
        {
            highp vec3 var_44083;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_44083 = FogColor.xyz * max(var_9e815, vec3(1.0));
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
            var_138a7 = var_44083;
        }
        else
        {
            var_138a7 = vec3(0.0);
        }
        var_bdb1d = var_79b3e;
        var_1bb57 = var_138a7;
    }
    else
    {
        var_bdb1d = 0.0;
        var_1bb57 = vec3(0.0);
    }
    highp vec4 var_164a6 = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_45187 = var_164a6;
    highp vec4 var_bde45;
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
        var_bde45 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_bde45 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_063c9 = var_bde45;
    highp vec3 var_86d4f;
    if (IBLParameters.x != 0.0)
    {
        highp vec3 var_a8715;
        highp vec3 var_dd3fd;
        if (QuantizationParameters.w > 0.0)
        {
            var_dd3fd = (u_view * vec4(var_a4be8, 1.0)).xyz;
            var_a8715 = var_a4be8;
        }
        else
        {
            var_dd3fd = var_1b7cc;
            var_a8715 = v_worldPos;
        }
        highp vec3 var_a56d9 = reflect(normalize(var_a8715 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_864e9);
        highp float var_0f441;
        if (int(ConvolutionType.x) == 1)
        {
            highp float var_9a0e5 = 1.0 - var_84dc0;
            var_0f441 = (1.0 - (var_9a0e5 * var_9a0e5)) * (IBLParameters.y - 1.0);
        }
        else
        {
            highp float var_c17b7 = 1.0 - var_84dc0;
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
            func_d903a(var_8d364, var_6f03b, var_713f8, var_26642);
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
        highp vec2 var_dea35 = vec2(clamp(dot(var_a4bd4, -normalize(var_dd3fd)), 0.0, 1.0), var_84dc0);
        var_dea35.y = 1.0 - var_dea35.y;
        highp vec2 var_7d2be = texture(s_BrdfLUT, var_dea35).xy;
        highp vec3 var_fe0f6 = var_da3af * ((var_dd12c * var_7d2be.x) + vec3(var_7d2be.y));
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
        var_86d4f = var_0ffc6;
    }
    else
    {
        var_86d4f = vec3(0.0);
    }
    highp vec3 var_42f1f = vec4(var_bde45.xyz + (mix(((var_1163d + var_9bf27) + var_eb774) + var_48867, var_164a6.xyz, vec3(var_45187.w)) * var_063c9.w), 1.0).xyz + var_86d4f;
    highp vec4 var_a4d45 = vec4(var_42f1f, var_7a906.w);
    highp vec3 var_005bf;
    if (PreExposureEnabled.x > 0.0)
    {
        var_005bf = var_42f1f * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_005bf = var_42f1f;
    }
    var_a4d45.x = var_005bf.x;
    var_a4d45.y = var_005bf.y;
    var_a4d45.z = var_005bf.z;
    bgfx_FragData0 = var_a4d45;
}
