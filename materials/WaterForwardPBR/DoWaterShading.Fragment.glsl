#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_AND_NORMAL_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - DO_WATER_SHADING_PASS (not used)
* - DO_WATER_SURFACE_BUFFER_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF (not used)
* - RENDER_AS_BILLBOARDS__ON (not used)
*
* Seasons:
* - SEASONS__OFF (not used)
* - SEASONS__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - layout(binding = 1, std430) buffer s_BiomeInfoBufferBuffer { BiomeInfo s_BiomeInfoBuffer[]; };
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 4, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - uniform lowp sampler2D s_LightMapTexture;
* - layout(binding = 6, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 8, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform lowp sampler2D s_SeasonsTexture;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BiomeBlendingLastUpdatePosition;
* - uniform vec4 BiomeBlendingParameters;
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
* - uniform vec4 ConvolutionType;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightExplicitCascadedShadowMapEnabled[2];
* - uniform vec4 DirectionalLightExplicitCascadedShadowMapIndices[2];
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform mat4 DirectionalLightSourceCausticsViewProj[2];
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
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
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
* - uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 GlobalRoughness;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightInvProj;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowSlopeBias;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 Time;
* - uniform vec4 ViewPositionAndTime;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WaterSurfaceEnabled;
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

struct Light {
    highp vec4 position;
    highp vec4 color;
    int shadowProbeIndex;
    int pad0;
    int pad1;
    int pad2;
};

struct LightData {
    highp float lookup;
};

layout(binding = 8, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_a02eb;
layout(binding = 6, std430) buffer s_Lights { Light Lights[]; } var_ff43f;
layout(binding = 4, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_96516;
uniform highp mat4 CloudShadowProj;
uniform highp mat4 DirectionalLightSourceShadowProj0[2];
uniform highp mat4 DirectionalLightSourceShadowProj1[2];
uniform highp mat4 DirectionalLightSourceShadowProj2[2];
uniform highp mat4 DirectionalLightSourceShadowProj3[2];
uniform highp mat4 PlayerShadowProj;
uniform highp mat4 PointLightProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadeShadowResolutions;
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ClusterNearFarWidthHeight;
uniform highp vec4 ClusterSize;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightExplicitCascadedShadowMapEnabled[2];
uniform highp vec4 DirectionalLightExplicitCascadedShadowMapIndices[2];
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform highp vec4 DirectionalLightSourceIsSun[2];
uniform highp vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform highp vec4 DirectionalLightSourceShadowDirection[2];
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform highp vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 MoonColor;
uniform highp vec4 MoonDir;
uniform highp vec4 NdLFloor;
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightDiffuseFadeOutParameters;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 PointLightSpecularFadeOutParameters;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 ShadowBias;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform highp vec4 ShadowPCFWidth;
uniform highp vec4 ShadowSlopeBias;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 ViewPositionAndTime;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WaterSurfaceEnabled;
uniform highp vec4 WaterSurfaceOctaveParameters;
uniform highp vec4 WaterSurfaceParameters;
uniform highp vec4 WaterSurfaceWaveParameters;
uniform highp vec4 WorldOrigin;
in highp vec3 v_bitangent;
in highp vec2 v_lightmapUV;
in highp vec3 v_normal;
flat in int v_pbrTextureId;
in highp vec3 v_tangent;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
int var_e7b23;
float var_abd4d;
void func_afe0b(inout highp float arg_9eee0, inout highp float arg_6a625, inout highp vec3 arg_51e76, inout int arg_bdefb) {
    if (v_pbrTextureId == 65535)
    {
        arg_9eee0 = 1.0;
        arg_6a625 = 0.0;
        arg_51e76 = vec3(0.0, 1.0, 0.0);
        return;
    }
    highp vec2 loc_59055 = vec2(var_a02eb.PBRData[v_pbrTextureId].colourToNormalUvScale0, var_a02eb.PBRData[v_pbrTextureId].colourToNormalUvScale1);
    highp vec2 loc_39ca3 = vec2(var_a02eb.PBRData[v_pbrTextureId].colourToNormalUvBias0, var_a02eb.PBRData[v_pbrTextureId].colourToNormalUvBias1);
    highp vec3 loc_b4ff6;
    if ((var_a02eb.PBRData[v_pbrTextureId].flags & 4) == 4)
    {
        loc_b4ff6 = (texture(s_MatTexture, (v_texcoord0 * loc_59055) + loc_39ca3).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 loc_9252d;
        if ((var_a02eb.PBRData[v_pbrTextureId].flags & 8) == 8)
        {
            highp vec2 loc_218fe = (v_texcoord0 * loc_59055) + loc_39ca3;
            highp vec3 loc_2ae5f = vec3(0.0, 0.0, 1.0);
            highp float loc_b88fd = clamp((min(var_a02eb.PBRData[v_pbrTextureId].maxMipNormal - var_a02eb.PBRData[v_pbrTextureId].maxMipColour, var_a02eb.PBRData[v_pbrTextureId].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
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
                loc_2ae5f.x = loc_cf71a[loc_31dc2.x] - loc_cf71a[loc_31dc2.y];
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
                loc_2ae5f.y = loc_cf71a[loc_31dc2.x] - loc_cf71a[loc_31dc2.y];
                loc_2ae5f.z = 0.25;
                highp vec3 loc_1cc05 = normalize(loc_2ae5f);
                highp vec2 loc_8557e = loc_1cc05.xy * loc_b88fd;
                loc_2ae5f = vec3(loc_8557e.x, loc_8557e.y, loc_1cc05.z);
            }
            loc_9252d = loc_2ae5f;
        }
        else
        {
            loc_9252d = vec3(0.0, 0.0, 1.0);
        }
        loc_b4ff6 = loc_9252d;
    }
    highp float loc_659d6;
    highp float loc_00c14;
    if ((var_a02eb.PBRData[v_pbrTextureId].flags & 1) == 1)
    {
        highp vec4 loc_62c5e = texture(s_MatTexture, (v_texcoord0 * vec2(var_a02eb.PBRData[v_pbrTextureId].colourToMaterialUvScale0, var_a02eb.PBRData[v_pbrTextureId].colourToMaterialUvScale1)) + vec2(var_a02eb.PBRData[v_pbrTextureId].colourToMaterialUvBias0, var_a02eb.PBRData[v_pbrTextureId].colourToMaterialUvBias1));
        loc_00c14 = loc_62c5e.y;
        loc_659d6 = loc_62c5e.z;
    }
    else
    {
        loc_00c14 = var_a02eb.PBRData[v_pbrTextureId].uniformEmissive;
        loc_659d6 = var_a02eb.PBRData[v_pbrTextureId].uniformRoughness;
    }
    highp vec3 loc_93b23;
    if (arg_bdefb != 0)
    {
        loc_93b23 = -v_normal;
    }
    else
    {
        loc_93b23 = v_normal;
    }
    arg_9eee0 = loc_659d6;
    arg_6a625 = loc_00c14;
    arg_51e76 = transpose(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(loc_93b23)))) * loc_b4ff6;
}
void func_cb3cb(inout int arg_4fc1c, inout highp vec3 arg_f8577, inout highp vec4 arg_a2d38, inout int arg_ee338) {
    highp vec4 loc_06bbb = DirectionalLightSourceShadowProj0[arg_4fc1c] * vec4(arg_f8577, 1.0);
    highp vec4 loc_108af = loc_06bbb;
    bool loc_3c9c6 = loc_108af.x >= (-1.0);
    bool loc_b786b;
    if (loc_3c9c6)
    {
        loc_b786b = loc_108af.x <= 1.0;
    }
    else
    {
        loc_b786b = loc_3c9c6;
    }
    bool loc_537c4;
    if (loc_b786b)
    {
        loc_537c4 = loc_108af.y >= (-1.0);
    }
    else
    {
        loc_537c4 = loc_b786b;
    }
    bool loc_32c46;
    if (loc_537c4)
    {
        loc_32c46 = loc_108af.y <= 1.0;
    }
    else
    {
        loc_32c46 = loc_537c4;
    }
    bool loc_88a47;
    if (loc_32c46)
    {
        loc_88a47 = loc_108af.z >= (-1.0);
    }
    else
    {
        loc_88a47 = loc_32c46;
    }
    bool loc_7078d;
    if (loc_88a47)
    {
        loc_7078d = loc_108af.z <= 1.0;
    }
    else
    {
        loc_7078d = loc_88a47;
    }
    if (loc_7078d)
    {
        arg_a2d38 = loc_06bbb;
        arg_ee338 = 0;
        return;
    }
    highp vec4 loc_857da = DirectionalLightSourceShadowProj1[arg_4fc1c] * vec4(arg_f8577, 1.0);
    highp vec4 loc_6ed2f = loc_857da;
    bool loc_79540 = loc_6ed2f.x >= (-1.0);
    bool loc_60d02;
    if (loc_79540)
    {
        loc_60d02 = loc_6ed2f.x <= 1.0;
    }
    else
    {
        loc_60d02 = loc_79540;
    }
    bool loc_db52c;
    if (loc_60d02)
    {
        loc_db52c = loc_6ed2f.y >= (-1.0);
    }
    else
    {
        loc_db52c = loc_60d02;
    }
    bool loc_0bf1e;
    if (loc_db52c)
    {
        loc_0bf1e = loc_6ed2f.y <= 1.0;
    }
    else
    {
        loc_0bf1e = loc_db52c;
    }
    bool loc_cd494;
    if (loc_0bf1e)
    {
        loc_cd494 = loc_6ed2f.z >= (-1.0);
    }
    else
    {
        loc_cd494 = loc_0bf1e;
    }
    bool loc_3b7d6;
    if (loc_cd494)
    {
        loc_3b7d6 = loc_6ed2f.z <= 1.0;
    }
    else
    {
        loc_3b7d6 = loc_cd494;
    }
    if (loc_3b7d6)
    {
        arg_a2d38 = loc_857da;
        arg_ee338 = 1;
        return;
    }
    highp vec4 loc_7216b = DirectionalLightSourceShadowProj2[arg_4fc1c] * vec4(arg_f8577, 1.0);
    highp vec4 loc_5934a = loc_7216b;
    bool loc_540c6 = loc_5934a.x >= (-1.0);
    bool loc_b8a11;
    if (loc_540c6)
    {
        loc_b8a11 = loc_5934a.x <= 1.0;
    }
    else
    {
        loc_b8a11 = loc_540c6;
    }
    bool loc_c0490;
    if (loc_b8a11)
    {
        loc_c0490 = loc_5934a.y >= (-1.0);
    }
    else
    {
        loc_c0490 = loc_b8a11;
    }
    bool loc_ab099;
    if (loc_c0490)
    {
        loc_ab099 = loc_5934a.y <= 1.0;
    }
    else
    {
        loc_ab099 = loc_c0490;
    }
    bool loc_6a75a;
    if (loc_ab099)
    {
        loc_6a75a = loc_5934a.z >= (-1.0);
    }
    else
    {
        loc_6a75a = loc_ab099;
    }
    bool loc_6a3da;
    if (loc_6a75a)
    {
        loc_6a3da = loc_5934a.z <= 1.0;
    }
    else
    {
        loc_6a3da = loc_6a75a;
    }
    if (loc_6a3da)
    {
        arg_a2d38 = loc_7216b;
        arg_ee338 = 2;
        return;
    }
    highp vec4 loc_0e1bf = DirectionalLightSourceShadowProj3[arg_4fc1c] * vec4(arg_f8577, 1.0);
    highp vec4 loc_39bd3 = loc_0e1bf;
    bool loc_319eb = loc_39bd3.x >= (-1.0);
    bool loc_516c3;
    if (loc_319eb)
    {
        loc_516c3 = loc_39bd3.x <= 1.0;
    }
    else
    {
        loc_516c3 = loc_319eb;
    }
    bool loc_8ba34;
    if (loc_516c3)
    {
        loc_8ba34 = loc_39bd3.y >= (-1.0);
    }
    else
    {
        loc_8ba34 = loc_516c3;
    }
    bool loc_ff47d;
    if (loc_8ba34)
    {
        loc_ff47d = loc_39bd3.y <= 1.0;
    }
    else
    {
        loc_ff47d = loc_8ba34;
    }
    bool loc_0b734;
    if (loc_ff47d)
    {
        loc_0b734 = loc_39bd3.z >= (-1.0);
    }
    else
    {
        loc_0b734 = loc_ff47d;
    }
    bool loc_0e0bb;
    if (loc_0b734)
    {
        loc_0e0bb = loc_39bd3.z <= 1.0;
    }
    else
    {
        loc_0e0bb = loc_0b734;
    }
    if (loc_0e0bb)
    {
        arg_a2d38 = loc_0e1bf;
        arg_ee338 = 3;
        return;
    }
    arg_a2d38 = loc_0e1bf;
    arg_ee338 = -1;
}
void func_103b2(inout highp float arg_5b759, inout int arg_11220, inout highp float arg_ce9c6) {
    bool loc_7827b = arg_5b759 == 0.0;
    bool loc_1d12d;
    if (loc_7827b)
    {
        loc_1d12d = DirectionalLightExplicitCascadedShadowMapEnabled[arg_11220].x != 0.0;
    }
    else
    {
        loc_1d12d = loc_7827b;
    }
    if (loc_1d12d)
    {
        arg_ce9c6 = DirectionalLightExplicitCascadedShadowMapIndices[arg_11220].x;
        return;
    }
    else
    {
        bool loc_b84d7 = arg_5b759 == 1.0;
        bool loc_41739;
        if (loc_b84d7)
        {
            loc_41739 = DirectionalLightExplicitCascadedShadowMapEnabled[arg_11220].y != 0.0;
        }
        else
        {
            loc_41739 = loc_b84d7;
        }
        if (loc_41739)
        {
            arg_ce9c6 = DirectionalLightExplicitCascadedShadowMapIndices[arg_11220].y;
            return;
        }
        else
        {
            bool loc_2ff3a = arg_5b759 == 2.0;
            bool loc_7eef5;
            if (loc_2ff3a)
            {
                loc_7eef5 = DirectionalLightExplicitCascadedShadowMapEnabled[arg_11220].z != 0.0;
            }
            else
            {
                loc_7eef5 = loc_2ff3a;
            }
            if (loc_7eef5)
            {
                arg_ce9c6 = DirectionalLightExplicitCascadedShadowMapIndices[arg_11220].z;
                return;
            }
            else
            {
                bool loc_6013b = arg_5b759 == 3.0;
                bool loc_035f1;
                if (loc_6013b)
                {
                    loc_035f1 = DirectionalLightExplicitCascadedShadowMapEnabled[arg_11220].w != 0.0;
                }
                else
                {
                    loc_035f1 = loc_6013b;
                }
                if (loc_035f1)
                {
                    arg_ce9c6 = DirectionalLightExplicitCascadedShadowMapIndices[arg_11220].w;
                    return;
                }
            }
        }
    }
    arg_ce9c6 = -1.0;
}
void func_5a3f4(inout int arg_a398d, inout highp float arg_7a26d, inout int arg_da0e3, inout highp vec4 arg_5b51a, inout highp float arg_e6df6) {
    if (arg_a398d < 0)
    {
        arg_7a26d = 1.0;
        return;
    }
    int loc_6760f;
    if (QuantizationParameters.x != 0.0)
    {
        loc_6760f = 1;
    }
    else
    {
        loc_6760f = clamp(int(ShadowPCFWidth[arg_da0e3] + 0.5), 1, 9);
    }
    int loc_7cc8c = loc_6760f / 2;
    highp vec2 loc_124e3 = ((vec2(arg_5b51a.x, arg_5b51a.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions[arg_da0e3];
    highp float loc_aa6c4 = (arg_5b51a.z * 0.5) + 0.5;
    loc_124e3.y += (1.0 - CascadeShadowResolutions[arg_da0e3]);
    highp float loc_9af5f;
    loc_9af5f = 0.0;
    highp float loc_1a54a;
    for (int loc_a2bca = 0; loc_a2bca < loc_6760f; loc_9af5f = loc_1a54a, loc_a2bca++)
    {
        loc_1a54a = loc_9af5f;
        highp float loc_8e08a;
        for (int loc_95e89 = 0; loc_95e89 < loc_6760f; loc_1a54a = loc_8e08a, loc_95e89++)
        {
            highp float loc_18f34 = float(arg_da0e3);
            highp float loc_1e85b;
            func_103b2(loc_18f34, arg_a398d, loc_1e85b);
            highp vec2 loc_8598d = loc_124e3 + ((vec2(float(loc_95e89 - loc_7cc8c) + 0.5, float(loc_a2bca - loc_7cc8c) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadeShadowResolutions[arg_da0e3]);
            highp vec4 loc_ffd8e = textureGather(s_ShadowCascades, vec3(loc_8598d, (float(arg_a398d) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(arg_da0e3)));
            if (loc_1e85b >= 0.0)
            {
                highp vec4 loc_e8b1b = textureGather(s_ShadowCascades, vec3(loc_8598d, (float(arg_a398d) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + loc_1e85b));
                highp vec4 loc_6187c = loc_e8b1b;
                if (loc_ffd8e.x < loc_6187c.x)
                {
                    loc_ffd8e = loc_e8b1b;
                }
            }
            if (QuantizationParameters.x != 0.0)
            {
                loc_8e08a = loc_1a54a + float(loc_ffd8e.w >= (loc_aa6c4 - arg_e6df6));
            }
            else
            {
                highp vec4 loc_27ff4 = step(vec4(loc_aa6c4 - arg_e6df6), loc_ffd8e);
                highp vec2 loc_5c3e1 = fract((loc_8598d * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_8e08a = loc_1a54a + mix(mix(loc_27ff4.w, loc_27ff4.z, loc_5c3e1.x), mix(loc_27ff4.x, loc_27ff4.y, loc_5c3e1.x), loc_5c3e1.y);
            }
        }
    }
    arg_7a26d = loc_9af5f / float(loc_6760f * loc_6760f);
}
void func_36c14(inout highp vec3 arg_3a8bb, inout highp float arg_13db0, inout highp vec4 arg_f7c69, inout highp float arg_7a26d) {
    highp vec4 loc_9b962 = PlayerShadowProj * vec4(arg_3a8bb, 1.0);
    highp float loc_27e01 = clamp(arg_13db0, arg_f7c69.x, 1.0);
    loc_9b962.z -= (ShadowBias.x + (ShadowSlopeBias.x * (sqrt(1.0 - (loc_27e01 * loc_27e01)) / loc_27e01)));
    loc_9b962.z = min(loc_9b962.z, 1.0);
    highp vec2 loc_f9579 = ((vec2(loc_9b962.x, loc_9b962.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    int loc_ec55d = (QuantizationParameters.x != 0.0) ? 1 : 2;
    int loc_ed2e2 = loc_ec55d / 2;
    loc_9b962.z = (loc_9b962.z * 0.5) + 0.5;
    loc_f9579.y += (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    bool loc_2c837 = loc_f9579.x >= 0.0;
    bool loc_d06e3;
    if (loc_2c837)
    {
        loc_d06e3 = loc_f9579.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_d06e3 = loc_2c837;
    }
    bool loc_c7ec9;
    if (loc_d06e3)
    {
        loc_c7ec9 = loc_f9579.y >= (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    }
    else
    {
        loc_c7ec9 = loc_d06e3;
    }
    bool loc_8e2b9;
    if (loc_c7ec9)
    {
        loc_8e2b9 = loc_f9579.y < 1.0;
    }
    else
    {
        loc_8e2b9 = loc_c7ec9;
    }
    if (!loc_8e2b9)
    {
        arg_7a26d = 1.0;
        return;
    }
    highp float loc_9af5f;
    loc_9af5f = 0.0;
    highp float loc_72f9e;
    for (int loc_467f0 = 0; loc_467f0 < loc_ec55d; loc_9af5f = loc_72f9e, loc_467f0++)
    {
        loc_72f9e = loc_9af5f;
        highp float loc_8daf8;
        for (int loc_02668 = 0; loc_02668 < loc_ec55d; loc_72f9e = loc_8daf8, loc_02668++)
        {
            highp vec2 loc_fae00 = loc_f9579 + ((vec2(float(loc_02668 - loc_ed2e2) + 0.5, float(loc_467f0 - loc_ed2e2) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            highp vec3 loc_e5a12 = vec3(loc_fae00.x, loc_fae00.y, (DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0) + 1.0);
            if (QuantizationParameters.x != 0.0)
            {
                loc_8daf8 = loc_72f9e + float(textureLod(s_ShadowCascades, loc_e5a12, 0.0).x >= loc_9b962.z);
            }
            else
            {
                highp vec4 loc_1f2f1 = step(vec4(loc_9b962.z), textureGather(s_ShadowCascades, loc_e5a12));
                highp vec2 loc_127fb = fract((loc_e5a12.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_8daf8 = loc_72f9e + mix(mix(loc_1f2f1.w, loc_1f2f1.z, loc_127fb.x), mix(loc_1f2f1.x, loc_1f2f1.y, loc_127fb.x), loc_127fb.y);
            }
        }
    }
    arg_7a26d = loc_9af5f / float(loc_ec55d * loc_ec55d);
}
void func_99fc5(inout highp vec2 arg_ea738, inout highp vec3 arg_534d1, inout highp vec3 arg_69e1b, inout highp vec3 arg_016ce, inout highp vec3 arg_68e47, inout highp vec3 arg_470f5, inout highp vec3 arg_81f79, inout highp float arg_d565c, inout highp vec2 arg_90d04) {
    bool loc_10906 = DirectionalLightSkyLightHeuristicToggles.x != 0.0;
    bool loc_f429e;
    if (loc_10906)
    {
        loc_f429e = abs(arg_ea738.y) < 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_f429e = loc_10906;
    }
    if (loc_f429e)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    int loc_bf766 = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    highp vec3 loc_5c80c;
    loc_5c80c = vec3(0.0);
    highp vec3 loc_81b2f;
    for (int loc_913fa = 0; loc_913fa < loc_bf766; loc_5c80c = loc_81b2f, loc_913fa++)
    {
        highp float loc_656e6;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            highp float loc_0b0a1 = max(dot(arg_69e1b, normalize((u_view * DirectionalLightSourceShadowDirection[loc_913fa]).xyz)), 0.0);
            highp vec4 loc_bbaca = NdLFloor;
            highp vec3 loc_677df = arg_016ce + ((arg_68e47 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_0b0a1, 0.0, 1.0));
            int loc_8fdf7;
            highp vec4 loc_b57a6;
            func_cb3cb(loc_913fa, loc_677df, loc_b57a6, loc_8fdf7);
            highp vec4 loc_b19db = loc_b57a6;
            highp float loc_2f871;
            if (loc_8fdf7 != (-1))
            {
                highp float loc_aaff4 = clamp(loc_0b0a1, loc_bbaca[loc_8fdf7], 1.0);
                highp float loc_c37f4 = ShadowBias[loc_8fdf7] + (ShadowSlopeBias[loc_8fdf7] * (sqrt(1.0 - (loc_aaff4 * loc_aaff4)) / loc_aaff4));
                int loc_be19b = int(DirectionalLightSourceShadowCascadeNumber[loc_913fa].x);
                highp float loc_222e2;
                func_5a3f4(loc_be19b, loc_222e2, loc_8fdf7, loc_b19db, loc_c37f4);
                highp float loc_ad256;
                if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
                {
                    highp vec4 loc_52fa6 = NdLFloor;
                    highp float loc_92468;
                    func_36c14(loc_677df, loc_0b0a1, loc_52fa6, loc_92468);
                    loc_ad256 = min(loc_222e2, loc_92468);
                }
                else
                {
                    loc_ad256 = loc_222e2;
                }
                bool loc_5d7ab = int(DirectionalLightSourceIsSun[loc_913fa].x) > 0;
                bool loc_643a4;
                if (loc_5d7ab)
                {
                    loc_643a4 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
                }
                else
                {
                    loc_643a4 = loc_5d7ab;
                }
                highp float loc_7f9a6;
                if (loc_643a4)
                {
                    highp vec4 loc_ef3e7 = NdLFloor;
                    highp vec4 loc_1a6df = CloudShadowProj * vec4(loc_677df, 1.0);
                    highp vec4 loc_6076f = loc_1a6df;
                    loc_6076f = loc_1a6df / vec4(loc_6076f.w);
                    highp float loc_8a611 = clamp(loc_0b0a1, loc_ef3e7.x, 1.0);
                    loc_6076f.z -= ((ShadowBias.x + (ShadowSlopeBias.x * (sqrt(1.0 - (loc_8a611 * loc_8a611)) / loc_8a611))) / loc_6076f.w);
                    highp vec2 loc_aec59 = ((vec2(loc_6076f.x, loc_6076f.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions.x;
                    int loc_a1fd4;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_a1fd4 = 1;
                    }
                    else
                    {
                        loc_a1fd4 = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z + 0.5), 1, 9);
                    }
                    int loc_52b94 = loc_a1fd4 / 2;
                    loc_6076f.z = (loc_6076f.z * 0.5) + 0.5;
                    loc_aec59.y += (1.0 - CascadeShadowResolutions.x);
                    highp float loc_ac935;
                    loc_ac935 = 0.0;
                    highp float loc_6f800;
                    for (int loc_2a37e = 0; loc_2a37e < loc_a1fd4; loc_ac935 = loc_6f800, loc_2a37e++)
                    {
                        loc_6f800 = loc_ac935;
                        highp float loc_91ddf;
                        for (int loc_09ee8 = 0; loc_09ee8 < loc_a1fd4; loc_6f800 = loc_91ddf, loc_09ee8++)
                        {
                            highp vec3 loc_d895e = vec3(loc_aec59 + ((vec2(float(loc_09ee8 - loc_52b94) + 0.5, float(loc_2a37e - loc_52b94) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadeShadowResolutions.x), DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0);
                            if (QuantizationParameters.x != 0.0)
                            {
                                loc_91ddf = loc_6f800 + float(textureLod(s_ShadowCascades, loc_d895e, 0.0).x >= loc_6076f.z);
                            }
                            else
                            {
                                highp vec4 loc_ef698 = step(vec4(loc_6076f.z), textureGather(s_ShadowCascades, loc_d895e));
                                highp vec2 loc_31e95 = fract((loc_d895e.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                loc_91ddf = loc_6f800 + mix(mix(loc_ef698.w, loc_ef698.z, loc_31e95.x), mix(loc_ef698.x, loc_ef698.y, loc_31e95.x), loc_31e95.y);
                            }
                        }
                    }
                    highp float loc_e0cb0 = loc_ac935 / float(loc_a1fd4 * loc_a1fd4);
                    highp float loc_3715f;
                    if (loc_e0cb0 < 1.0)
                    {
                        loc_3715f = min(loc_ad256, max(loc_e0cb0, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                    }
                    else
                    {
                        loc_3715f = loc_ad256;
                    }
                    loc_7f9a6 = loc_3715f;
                }
                else
                {
                    loc_7f9a6 = loc_ad256;
                }
                loc_2f871 = mix(loc_7f9a6, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_470f5.z));
            }
            else
            {
                loc_2f871 = 1.0;
            }
            loc_656e6 = loc_2f871;
        }
        else
        {
            loc_656e6 = 1.0;
        }
        highp vec3 loc_af162 = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_913fa]).xyz);
        highp vec4 loc_832de = DirectionalLightSourceDiffuseColorAndIlluminance[loc_913fa];
        highp float loc_8895c = max(dot(arg_69e1b, loc_af162), 0.0);
        highp float loc_91671 = max(dot(arg_69e1b, arg_81f79), 0.0);
        highp vec3 loc_a125f = normalize(loc_af162 + arg_81f79);
        highp float loc_a4858 = max(arg_d565c, 0.0500000007450580596923828125);
        highp float loc_a68f1 = loc_a4858 * loc_a4858;
        highp float loc_2743b = loc_a68f1 * loc_a68f1;
        highp float loc_cd10e = max(dot(arg_69e1b, loc_a125f), 0.0);
        highp float loc_c3bcc = (((loc_2743b - 1.0) * loc_cd10e) * loc_cd10e) + 1.0;
        highp float loc_bf36c = loc_a68f1 * 0.5;
        highp float loc_eefcb = clamp(1.0 - max(dot(arg_81f79, loc_a125f), 0.0), 0.0, 1.0);
        highp float loc_6d407 = loc_eefcb * loc_eefcb;
        loc_81b2f = loc_5c80c + ((((((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((loc_6d407 * loc_6d407) * loc_eefcb))) * (loc_2743b / ((loc_c3bcc * loc_c3bcc) * 3.1415927410125732421875))) * ((loc_91671 / (((loc_91671 * (1.0 - loc_bf36c)) + loc_bf36c) + 9.9999997473787516355514526367188e-05)) * (loc_8895c / (((loc_8895c * (1.0 - loc_bf36c)) + loc_bf36c) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_8895c) * loc_91671) + 9.9999997473787516355514526367188e-05)) * loc_8895c) * loc_656e6) * (((DirectionalLightSourceDiffuseColorAndIlluminance[loc_913fa].xyz * loc_832de.w) * arg_90d04[loc_913fa]) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x)) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_5c80c;
}
void func_b9aa9(inout highp float arg_6def2, inout highp vec2 arg_3fa1b, inout highp float arg_d7c97, inout highp vec3 arg_36c0c, inout highp vec3 arg_1915d) {
    if (arg_6def2 < arg_3fa1b.x)
    {
        arg_d7c97 = -1.0;
        return;
    }
    if ((arg_6def2 >= arg_3fa1b.x) && (arg_6def2 <= 1.0))
    {
        arg_d7c97 = 0.0;
        return;
    }
    if ((arg_6def2 > 1.0) && (arg_6def2 <= 1.5))
    {
        arg_d7c97 = 1.0;
        return;
    }
    arg_d7c97 = floor((log2(arg_36c0c.z * (-0.666666686534881591796875)) * ((arg_1915d.z - 2.0) / log2(arg_3fa1b.y * 0.666666686534881591796875))) + 2.0);
}
void func_36e28(inout highp vec3 arg_48e40, inout highp vec3 arg_1a26b, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp float loc_28341 = -arg_48e40.z;
    highp vec2 loc_25da3 = (arg_1a26b.xy + vec2(1.0)) * vec2(0.5);
    highp vec3 loc_fd394 = ClusterDimensions.xyz;
    highp vec2 loc_703d4 = ClusterNearFarWidthHeight.zw;
    highp vec2 loc_d7b5c = ClusterSize.xy;
    highp vec2 loc_909cb = ClusterNearFarWidthHeight.xy;
    highp float loc_5de3f;
    func_b9aa9(loc_28341, loc_909cb, loc_5de3f, arg_48e40, loc_fd394);
    highp vec3 loc_60667 = vec3(floor((loc_25da3.x * loc_703d4.x) / loc_d7b5c.x), floor((loc_25da3.y * loc_703d4.y) / loc_d7b5c.y), loc_5de3f);
    bool loc_ce27d = loc_60667.x < 0.0;
    bool loc_f15a5;
    if (!loc_ce27d)
    {
        loc_f15a5 = loc_60667.y < 0.0;
    }
    else
    {
        loc_f15a5 = loc_ce27d;
    }
    bool loc_7bab6;
    if (!loc_f15a5)
    {
        loc_7bab6 = loc_60667.z < 0.0;
    }
    else
    {
        loc_7bab6 = loc_f15a5;
    }
    bool loc_a526b;
    if (!loc_7bab6)
    {
        loc_a526b = loc_60667.x >= ClusterDimensions.x;
    }
    else
    {
        loc_a526b = loc_7bab6;
    }
    bool loc_6d7c9;
    if (!loc_a526b)
    {
        loc_6d7c9 = loc_60667.y >= ClusterDimensions.y;
    }
    else
    {
        loc_6d7c9 = loc_a526b;
    }
    bool loc_fc058;
    if (!loc_6d7c9)
    {
        loc_fc058 = loc_60667.z >= ClusterDimensions.z;
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
    int loc_14533 = int((loc_60667.x + (loc_60667.y * ClusterDimensions.x)) + ((loc_60667.z * ClusterDimensions.x) * ClusterDimensions.y)) * int(ClusterDimensions.w);
    arg_e45b8 = loc_14533 + int(ClusterDimensions.w);
    arg_fadf1 = loc_14533;
    arg_d7f4c = true;
}
void func_2e901(inout int arg_4fc1c, inout highp vec3 arg_f8577, inout int arg_ee338) {
    highp vec4 loc_e4678 = DirectionalLightSourceShadowProj0[arg_4fc1c] * vec4(arg_f8577, 1.0);
    bool loc_3c9c6 = loc_e4678.x >= (-1.0);
    bool loc_b786b;
    if (loc_3c9c6)
    {
        loc_b786b = loc_e4678.x <= 1.0;
    }
    else
    {
        loc_b786b = loc_3c9c6;
    }
    bool loc_537c4;
    if (loc_b786b)
    {
        loc_537c4 = loc_e4678.y >= (-1.0);
    }
    else
    {
        loc_537c4 = loc_b786b;
    }
    bool loc_32c46;
    if (loc_537c4)
    {
        loc_32c46 = loc_e4678.y <= 1.0;
    }
    else
    {
        loc_32c46 = loc_537c4;
    }
    bool loc_88a47;
    if (loc_32c46)
    {
        loc_88a47 = loc_e4678.z >= (-1.0);
    }
    else
    {
        loc_88a47 = loc_32c46;
    }
    bool loc_7078d;
    if (loc_88a47)
    {
        loc_7078d = loc_e4678.z <= 1.0;
    }
    else
    {
        loc_7078d = loc_88a47;
    }
    if (loc_7078d)
    {
        arg_ee338 = 0;
        return;
    }
    highp vec4 loc_26e70 = DirectionalLightSourceShadowProj1[arg_4fc1c] * vec4(arg_f8577, 1.0);
    bool loc_79540 = loc_26e70.x >= (-1.0);
    bool loc_60d02;
    if (loc_79540)
    {
        loc_60d02 = loc_26e70.x <= 1.0;
    }
    else
    {
        loc_60d02 = loc_79540;
    }
    bool loc_db52c;
    if (loc_60d02)
    {
        loc_db52c = loc_26e70.y >= (-1.0);
    }
    else
    {
        loc_db52c = loc_60d02;
    }
    bool loc_0bf1e;
    if (loc_db52c)
    {
        loc_0bf1e = loc_26e70.y <= 1.0;
    }
    else
    {
        loc_0bf1e = loc_db52c;
    }
    bool loc_cd494;
    if (loc_0bf1e)
    {
        loc_cd494 = loc_26e70.z >= (-1.0);
    }
    else
    {
        loc_cd494 = loc_0bf1e;
    }
    bool loc_3b7d6;
    if (loc_cd494)
    {
        loc_3b7d6 = loc_26e70.z <= 1.0;
    }
    else
    {
        loc_3b7d6 = loc_cd494;
    }
    if (loc_3b7d6)
    {
        arg_ee338 = 1;
        return;
    }
    highp vec4 loc_98319 = DirectionalLightSourceShadowProj2[arg_4fc1c] * vec4(arg_f8577, 1.0);
    bool loc_540c6 = loc_98319.x >= (-1.0);
    bool loc_b8a11;
    if (loc_540c6)
    {
        loc_b8a11 = loc_98319.x <= 1.0;
    }
    else
    {
        loc_b8a11 = loc_540c6;
    }
    bool loc_c0490;
    if (loc_b8a11)
    {
        loc_c0490 = loc_98319.y >= (-1.0);
    }
    else
    {
        loc_c0490 = loc_b8a11;
    }
    bool loc_ab099;
    if (loc_c0490)
    {
        loc_ab099 = loc_98319.y <= 1.0;
    }
    else
    {
        loc_ab099 = loc_c0490;
    }
    bool loc_6a75a;
    if (loc_ab099)
    {
        loc_6a75a = loc_98319.z >= (-1.0);
    }
    else
    {
        loc_6a75a = loc_ab099;
    }
    bool loc_6a3da;
    if (loc_6a75a)
    {
        loc_6a3da = loc_98319.z <= 1.0;
    }
    else
    {
        loc_6a3da = loc_6a75a;
    }
    if (loc_6a3da)
    {
        arg_ee338 = 2;
        return;
    }
    highp vec4 loc_6312d = DirectionalLightSourceShadowProj3[arg_4fc1c] * vec4(arg_f8577, 1.0);
    bool loc_319eb = loc_6312d.x >= (-1.0);
    bool loc_516c3;
    if (loc_319eb)
    {
        loc_516c3 = loc_6312d.x <= 1.0;
    }
    else
    {
        loc_516c3 = loc_319eb;
    }
    bool loc_8ba34;
    if (loc_516c3)
    {
        loc_8ba34 = loc_6312d.y >= (-1.0);
    }
    else
    {
        loc_8ba34 = loc_516c3;
    }
    bool loc_ff47d;
    if (loc_8ba34)
    {
        loc_ff47d = loc_6312d.y <= 1.0;
    }
    else
    {
        loc_ff47d = loc_8ba34;
    }
    bool loc_0b734;
    if (loc_ff47d)
    {
        loc_0b734 = loc_6312d.z >= (-1.0);
    }
    else
    {
        loc_0b734 = loc_ff47d;
    }
    bool loc_0e0bb;
    if (loc_0b734)
    {
        loc_0e0bb = loc_6312d.z <= 1.0;
    }
    else
    {
        loc_0e0bb = loc_0b734;
    }
    if (loc_0e0bb)
    {
        arg_ee338 = 3;
        return;
    }
    arg_ee338 = -1;
}
void func_6e976(inout int arg_3a793, inout highp float arg_9eee0, inout highp vec3 arg_c4b3d, inout highp vec3 arg_3efda) {
    if (var_ff43f.Lights[arg_3a793].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        return;
    }
    highp vec3 loc_8d02b = arg_c4b3d - var_ff43f.Lights[arg_3a793].position.xyz;
    highp vec3 loc_b2243 = abs(loc_8d02b);
    bool loc_ab77c = loc_b2243.x >= loc_b2243.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_b2243.x >= loc_b2243.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    if (loc_ca7f9)
    {
        loc_b2243 = vec3(loc_b2243.y, loc_b2243.z, loc_b2243.x);
    }
    else
    {
        if (loc_b2243.y >= loc_b2243.z)
        {
            loc_b2243 = vec3(loc_b2243.x, loc_b2243.z, loc_b2243.y);
        }
    }
    highp vec4 loc_3ce0f = PointLightProj * vec4(loc_b2243, 1.0);
    highp float loc_61a98 = dot(normalize(-loc_8d02b), normalize(arg_3efda));
    highp vec3 loc_c9568 = arg_c4b3d + ((arg_3efda * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_61a98, 0.0, 1.0));
    int loc_40c8f;
    func_2e901(arg_3a793, loc_c9568, loc_40c8f);
    highp float loc_869f5 = clamp(loc_61a98, NdLFloor[loc_40c8f], 1.0);
    loc_3ce0f.z -= (PointLightShadowParams1.x + (PointLightShadowParams1.y * (sqrt(1.0 - (loc_869f5 * loc_869f5)) / loc_869f5)));
    loc_3ce0f /= vec4(loc_3ce0f.w);
    highp vec3 loc_ad23e = loc_8d02b;
    bool loc_fe444 = abs(loc_ad23e.y) > abs(loc_ad23e.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_ad23e.y) > abs(loc_ad23e.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_ad23e.z *= (-1.0);
    }
    else
    {
        loc_ad23e.y *= (-1.0);
    }
    highp float loc_591c8;
    if (((textureLod(s_PointLightShadowTextureArray, vec4(loc_ad23e, float(var_ff43f.Lights[arg_3a793].shadowProbeIndex)), 0.0).x * 2.0) - 1.0) >= loc_3ce0f.z)
    {
        loc_591c8 = 1.0;
    }
    else
    {
        loc_591c8 = 0.0;
    }
    arg_9eee0 = loc_591c8;
}
void func_a538c(inout int arg_750bd, inout highp float arg_43b7a, inout highp vec3 arg_24936, inout highp vec3 arg_ab1f6, inout highp vec3 arg_81f82) {
    if (arg_750bd < 0)
    {
        arg_43b7a = 1.0;
        arg_24936 = vec3(0.0);
        return;
    }
    highp vec3 loc_569de = var_ff43f.Lights[arg_750bd].position.xyz - v_worldPos;
    highp vec3 loc_8cb9b = loc_569de;
    highp float loc_7ba4c;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_7ba4c = loc_1829d * loc_1829d;
    }
    else
    {
        loc_7ba4c = dot(loc_569de, loc_569de);
    }
    if (loc_7ba4c >= (var_ff43f.Lights[arg_750bd].position.w * var_ff43f.Lights[arg_750bd].position.w))
    {
        arg_43b7a = 1.0;
        arg_24936 = vec3(0.0);
        return;
    }
    highp float loc_a011d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_1b78e;
        func_6e976(arg_750bd, loc_1b78e, arg_ab1f6, arg_81f82);
        loc_a011d = loc_1b78e;
    }
    else
    {
        loc_a011d = 1.0;
    }
    highp float loc_fd676 = loc_7ba4c / ((var_ff43f.Lights[arg_750bd].position.w * var_ff43f.Lights[arg_750bd].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_fcfce = clamp(1.0 - (loc_fd676 * loc_fd676), 0.0, 1.0);
    highp float loc_e1ff6 = (1.0 / max(loc_7ba4c, 9.9999997473787516355514526367188e-05)) * (loc_fcfce * loc_fcfce);
    highp float loc_9160d;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_9160d = loc_e1ff6 * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_e1ff6) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_9160d = loc_e1ff6;
    }
    arg_43b7a = loc_a011d;
    arg_24936 = ((var_ff43f.Lights[arg_750bd].color.xyz * var_ff43f.Lights[arg_750bd].color.w) * loc_9160d) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_d0074(inout bool arg_9a2b4, inout bool arg_b6724, inout highp vec3 arg_3289d, inout highp vec3 arg_dc0ef, inout highp vec3 arg_96daa, inout highp vec3 arg_89c41, inout highp vec3 arg_c5372, inout highp vec3 arg_061f9, inout highp float arg_e8ed0, inout highp vec3 arg_5e370, inout highp vec3 arg_78ca7) {
    if (!(arg_9a2b4 || arg_b6724))
    {
        arg_3289d = vec3(0.0);
        return;
    }
    bool loc_9f3ca;
    int loc_9b40b;
    int loc_fbf40;
    func_36e28(arg_dc0ef, arg_96daa, loc_fbf40, loc_9b40b, loc_9f3ca);
    if (!loc_9f3ca)
    {
        arg_3289d = vec3(0.0);
        return;
    }
    highp vec3 loc_79fad;
    loc_79fad = vec3(0.0);
    highp vec3 loc_d884d;
    for (int loc_bee0c = loc_9b40b; loc_bee0c < loc_fbf40; loc_79fad = loc_d884d, loc_bee0c++)
    {
        int loc_e8148 = int(var_96516.LightLookupArray[loc_bee0c].lookup);
        if (loc_e8148 < 0)
        {
            break;
        }
        highp vec3 loc_b6fc4 = normalize((u_view * vec4(var_ff43f.Lights[loc_e8148].position.xyz, 1.0)).xyz - arg_89c41);
        highp vec3 loc_20211;
        if (arg_b6724)
        {
            highp vec3 loc_a5496;
            if (arg_9a2b4)
            {
                highp float loc_97c1f = max(dot(arg_c5372, loc_b6fc4), 0.0);
                highp float loc_207e1 = max(dot(arg_c5372, arg_061f9), 0.0);
                highp vec3 loc_608b6 = normalize(loc_b6fc4 + arg_061f9);
                highp float loc_6bc95 = max(arg_e8ed0, 0.0500000007450580596923828125);
                highp float loc_59789 = loc_6bc95 * loc_6bc95;
                highp float loc_9f4ec = loc_59789 * loc_59789;
                highp float loc_7f729 = max(dot(arg_c5372, loc_608b6), 0.0);
                highp float loc_7a105 = (((loc_9f4ec - 1.0) * loc_7f729) * loc_7f729) + 1.0;
                highp float loc_0e094 = loc_59789 * 0.5;
                highp float loc_caa23 = clamp(1.0 - max(dot(arg_061f9, loc_608b6), 0.0), 0.0, 1.0);
                highp float loc_a19b2 = loc_caa23 * loc_caa23;
                loc_a5496 = ((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((loc_a19b2 * loc_a19b2) * loc_caa23))) * (loc_9f4ec / ((loc_7a105 * loc_7a105) * 3.1415927410125732421875))) * ((loc_207e1 / (((loc_207e1 * (1.0 - loc_0e094)) + loc_0e094) + 9.9999997473787516355514526367188e-05)) * (loc_97c1f / (((loc_97c1f * (1.0 - loc_0e094)) + loc_0e094) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_97c1f) * loc_207e1) + 9.9999997473787516355514526367188e-05)) * loc_97c1f;
            }
            else
            {
                loc_a5496 = vec3(0.0);
            }
            loc_20211 = loc_a5496;
        }
        else
        {
            highp vec3 loc_cd248;
            if (arg_9a2b4)
            {
                highp float loc_fb758 = max(dot(arg_c5372, loc_b6fc4), 0.0);
                highp float loc_3c3a6 = max(dot(arg_c5372, arg_061f9), 0.0);
                highp vec3 loc_74f40 = normalize(loc_b6fc4 + arg_061f9);
                highp float loc_e728e = max(arg_e8ed0, 0.0500000007450580596923828125);
                highp float loc_22daf = loc_e728e * loc_e728e;
                highp float loc_abdef = loc_22daf * loc_22daf;
                highp float loc_92683 = max(dot(arg_c5372, loc_74f40), 0.0);
                highp float loc_ac620 = (((loc_abdef - 1.0) * loc_92683) * loc_92683) + 1.0;
                highp float loc_8cf9d = loc_22daf * 0.5;
                highp float loc_785f4 = clamp(1.0 - max(dot(arg_061f9, loc_74f40), 0.0), 0.0, 1.0);
                highp float loc_09b3c = loc_785f4 * loc_785f4;
                loc_cd248 = ((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((loc_09b3c * loc_09b3c) * loc_785f4))) * (loc_abdef / ((loc_ac620 * loc_ac620) * 3.1415927410125732421875))) * ((loc_3c3a6 / (((loc_3c3a6 * (1.0 - loc_8cf9d)) + loc_8cf9d) + 9.9999997473787516355514526367188e-05)) * (loc_fb758 / (((loc_fb758 * (1.0 - loc_8cf9d)) + loc_8cf9d) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_fb758) * loc_3c3a6) + 9.9999997473787516355514526367188e-05)) * loc_fb758;
            }
            else
            {
                loc_cd248 = vec3(0.0);
            }
            loc_20211 = loc_cd248;
        }
        highp vec3 loc_1e688;
        highp float loc_ae2d0;
        func_a538c(loc_e8148, loc_ae2d0, loc_1e688, arg_5e370, arg_78ca7);
        loc_d884d = loc_79fad + (((loc_20211 * loc_ae2d0) * loc_1e688) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_3289d = loc_79fad;
}
void main() {
    int var_679de = int(gl_FrontFacing);
    highp vec2 var_df530 = v_lightmapUV;
    highp vec3 var_c1b4f = normalize(-normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz));
    highp vec3 var_b5f17;
    highp float var_2a2e9;
    highp float var_75a5d;
    func_afe0b(var_75a5d, var_2a2e9, var_b5f17, var_679de);
    highp vec3 var_51929;
    if (var_679de > 0)
    {
        var_51929 = -var_b5f17;
    }
    else
    {
        var_51929 = var_b5f17;
    }
    highp vec3 var_2ab3a;
    if (WaterSurfaceEnabled.x > 0.0)
    {
        highp vec3 var_d3973;
        if (var_679de > 0)
        {
            var_d3973 = -v_normal;
        }
        else
        {
            var_d3973 = v_normal;
        }
        highp float var_3037b = ViewPositionAndTime.w * 0.5;
        highp vec2 var_e9692 = (v_worldPos - WorldOrigin.xyz).xz;
        highp vec2 var_15b62 = var_e9692;
        highp float var_62111;
        highp float var_1a358;
        highp vec2 var_83bc9;
        var_83bc9 = var_e9692;
        var_1a358 = 0.0;
        var_62111 = 0.0;
        highp float var_1e6d3;
        highp float var_5b855;
        highp vec2 var_78332;
        highp float var_c6efd;
        highp float var_e00d5;
        highp float var_04897;
        highp float var_81cca;
        uint var_9e692 = 0u;
        highp float var_b4da0 = 0.0;
        highp float var_eef05 = WaterSurfaceWaveParameters.x;
        highp float var_2e5ba = WaterSurfaceParameters.x;
        highp float var_59076 = 1.0;
        for (; var_9e692 < uint(WaterSurfaceParameters.y); var_59076 = var_c6efd, var_2e5ba = var_e00d5, var_83bc9 = var_78332, var_eef05 = var_04897, var_b4da0 = var_81cca, var_1a358 = var_5b855, var_62111 = var_1e6d3, var_9e692++)
        {
            highp vec2 var_ac536 = vec2(sin(var_b4da0), cos(var_b4da0));
            highp float var_885b5 = (dot(var_ac536, var_83bc9) * var_2e5ba) + (var_3037b * var_eef05);
            highp float var_1c0fd = pow((sin(var_885b5) + 1.0) * 0.5, WaterSurfaceWaveParameters.y);
            highp vec2 var_11048 = vec2(var_1c0fd, (var_1c0fd * cos(var_885b5)) * (-1.0));
            var_1e6d3 = var_62111 + (var_11048.x * var_59076);
            var_5b855 = var_1a358 + var_59076;
            var_78332 = var_83bc9 + (((var_ac536 * var_11048.y) * var_59076) * WaterSurfaceOctaveParameters.x);
            var_c6efd = mix(var_59076, 0.0, WaterSurfaceOctaveParameters.y);
            var_e00d5 = var_2e5ba * WaterSurfaceOctaveParameters.z;
            var_04897 = var_eef05 * WaterSurfaceOctaveParameters.w;
            var_81cca = var_b4da0 + 1.39900004863739013671875;
        }
        highp vec3 var_1c063 = vec3(var_15b62.x, (var_62111 / var_1a358) * WaterSurfaceParameters.z, var_15b62.y);
        highp float var_94ba0;
        highp float var_52750;
        highp vec2 var_c2935;
        var_c2935 = var_e9692 - vec2(WaterSurfaceParameters.w, 0.0);
        var_52750 = 0.0;
        var_94ba0 = 0.0;
        highp float var_0303e;
        highp float var_a3722;
        highp vec2 var_1b55e;
        highp float var_9ca59;
        highp float var_6df95;
        highp float var_15226;
        highp float var_633fd;
        uint var_2ca1d = 0u;
        highp float var_01a31 = 0.0;
        highp float var_3441d = WaterSurfaceWaveParameters.x;
        highp float var_b4368 = WaterSurfaceParameters.x;
        highp float var_563a6 = 1.0;
        for (; var_2ca1d < uint(WaterSurfaceParameters.y); var_563a6 = var_9ca59, var_b4368 = var_6df95, var_c2935 = var_1b55e, var_3441d = var_15226, var_01a31 = var_633fd, var_52750 = var_a3722, var_94ba0 = var_0303e, var_2ca1d++)
        {
            highp vec2 var_1c18a = vec2(sin(var_01a31), cos(var_01a31));
            highp float var_99be2 = (dot(var_1c18a, var_c2935) * var_b4368) + (var_3037b * var_3441d);
            highp float var_056e0 = pow((sin(var_99be2) + 1.0) * 0.5, WaterSurfaceWaveParameters.y);
            highp vec2 var_03816 = vec2(var_056e0, (var_056e0 * cos(var_99be2)) * (-1.0));
            var_0303e = var_94ba0 + (var_03816.x * var_563a6);
            var_a3722 = var_52750 + var_563a6;
            var_1b55e = var_c2935 + (((var_1c18a * var_03816.y) * var_563a6) * WaterSurfaceOctaveParameters.x);
            var_9ca59 = mix(var_563a6, 0.0, WaterSurfaceOctaveParameters.y);
            var_6df95 = var_b4368 * WaterSurfaceOctaveParameters.z;
            var_15226 = var_3441d * WaterSurfaceOctaveParameters.w;
            var_633fd = var_01a31 + 1.39900004863739013671875;
        }
        highp float var_4cb03;
        highp float var_97fff;
        highp vec2 var_e6e11;
        var_e6e11 = var_e9692 + vec2(0.0, WaterSurfaceParameters.w);
        var_97fff = 0.0;
        var_4cb03 = 0.0;
        highp float var_c5940;
        highp float var_fb35b;
        highp vec2 var_f4997;
        highp float var_c3808;
        highp float var_203ec;
        highp float var_40c87;
        highp float var_9d271;
        uint var_392e0 = 0u;
        highp float var_b733c = 0.0;
        highp float var_e2c14 = WaterSurfaceWaveParameters.x;
        highp float var_9e727 = WaterSurfaceParameters.x;
        highp float var_47b45 = 1.0;
        for (; var_392e0 < uint(WaterSurfaceParameters.y); var_47b45 = var_c3808, var_9e727 = var_203ec, var_e6e11 = var_f4997, var_e2c14 = var_40c87, var_b733c = var_9d271, var_97fff = var_fb35b, var_4cb03 = var_c5940, var_392e0++)
        {
            highp vec2 var_4a483 = vec2(sin(var_b733c), cos(var_b733c));
            highp float var_1996d = (dot(var_4a483, var_e6e11) * var_9e727) + (var_3037b * var_e2c14);
            highp float var_2db20 = pow((sin(var_1996d) + 1.0) * 0.5, WaterSurfaceWaveParameters.y);
            highp vec2 var_d4af9 = vec2(var_2db20, (var_2db20 * cos(var_1996d)) * (-1.0));
            var_c5940 = var_4cb03 + (var_d4af9.x * var_47b45);
            var_fb35b = var_97fff + var_47b45;
            var_f4997 = var_e6e11 + (((var_4a483 * var_d4af9.y) * var_47b45) * WaterSurfaceOctaveParameters.x);
            var_c3808 = mix(var_47b45, 0.0, WaterSurfaceOctaveParameters.y);
            var_203ec = var_9e727 * WaterSurfaceOctaveParameters.z;
            var_40c87 = var_e2c14 * WaterSurfaceOctaveParameters.w;
            var_9d271 = var_b733c + 1.39900004863739013671875;
        }
        var_2ab3a = normalize(mix(var_d3973, normalize(cross(var_1c063 - vec3(var_15b62.x - WaterSurfaceParameters.w, (var_94ba0 / var_52750) * WaterSurfaceParameters.z, var_15b62.y), var_1c063 - vec3(var_15b62.x, (var_4cb03 / var_97fff) * WaterSurfaceParameters.z, var_15b62.y + WaterSurfaceParameters.w))), vec3(var_d3973.y)));
    }
    else
    {
        var_2ab3a = var_51929;
    }
    highp vec3 var_cd05b;
    if (var_679de > 0)
    {
        var_cd05b = -var_2ab3a;
    }
    else
    {
        var_cd05b = var_2ab3a;
    }
    highp vec3 var_75d1d = normalize(var_cd05b);
    highp vec4 var_83731 = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_b8928 = var_83731;
    highp vec3 var_4169c = var_83731.xyz / vec3(var_b8928.w);
    highp vec3 var_0fab8 = (u_view * vec4(v_worldPos, 1.0)).xyz;
    highp vec3 var_239fe = v_worldPos - WorldOrigin.xyz;
    highp vec3 var_eebcb = dFdx(var_0fab8);
    highp vec3 var_211c8 = dFdy(var_0fab8);
    highp vec3 var_5acf5 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(var_eebcb), normalize(var_211c8))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_7d782 = mod(var_239fe, vec3(QuantizationParameters.z));
    highp vec3 var_bfb9a = (var_239fe - (var_7d782 - (var_5acf5 * dot(var_7d782, var_5acf5)))) + WorldOrigin.xyz;
    highp vec3 var_7e29b = (u_view * vec4(var_75d1d, 1.0)).xyz;
    highp vec3 var_5bd0a = var_4169c;
    highp vec3 var_083c2;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_352c1 = -(var_0fab8 / vec3(length(var_0fab8) + 9.9999997473787516355514526367188e-05));
        highp vec3 var_163cf = var_0fab8;
        highp vec3 var_0ae9b;
        if (int(QuantizationParameters.y) > 0)
        {
            var_0ae9b = var_bfb9a;
        }
        else
        {
            var_0ae9b = v_worldPos;
        }
        highp vec2 var_a7574 = vec2(1.0);
        highp vec3 var_9aeed;
        func_99fc5(var_df530, var_9aeed, var_7e29b, var_0ae9b, var_75d1d, var_163cf, var_352c1, var_75a5d, var_a7574);
        highp vec3 var_850d6 = var_0fab8;
        highp float var_ae4c3;
        if (ManhattanDistAttenuationEnabled.x > 0.0)
        {
            var_ae4c3 = (abs(var_850d6.x) + abs(var_850d6.y)) + abs(var_850d6.z);
        }
        else
        {
            var_ae4c3 = length(var_0fab8);
        }
        bool var_3ca7e = PointLightSpecularFadeOutParameters.x > 0.0;
        highp float var_f999d;
        if (var_3ca7e)
        {
            var_f999d = smoothstep(PointLightSpecularFadeOutParameters.x, PointLightSpecularFadeOutParameters.y, var_ae4c3);
        }
        else
        {
            var_f999d = 0.0;
        }
        bool var_d0403 = !var_3ca7e;
        bool var_32b7d;
        if (!var_d0403)
        {
            var_32b7d = var_3ca7e && (var_ae4c3 < PointLightSpecularFadeOutParameters.y);
        }
        else
        {
            var_32b7d = var_d0403;
        }
        bool var_0207f = PointLightDiffuseFadeOutParameters.x > 0.0;
        bool var_fc9d4 = !var_0207f;
        bool var_ff142;
        if (!var_fc9d4)
        {
            var_ff142 = var_0207f && (var_ae4c3 < PointLightDiffuseFadeOutParameters.y);
        }
        else
        {
            var_ff142 = var_fc9d4;
        }
        highp vec3 var_d0c27;
        if (int(QuantizationParameters.y) > 0)
        {
            var_d0c27 = var_bfb9a;
        }
        else
        {
            var_d0c27 = v_worldPos;
        }
        highp vec3 var_35ff2 = var_0fab8;
        highp vec3 var_3589b;
        func_d0074(var_32b7d, var_ff142, var_3589b, var_35ff2, var_4169c, var_0fab8, var_7e29b, var_352c1, var_75a5d, var_d0c27, var_75d1d);
        var_083c2 = var_9aeed + (var_3589b * (1.0 - var_f999d));
    }
    else
    {
        var_083c2 = vec3(0.0);
    }
    highp float var_0f69a = clamp(((var_df530.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_11376 = clamp(1.0 - max(dot(var_c1b4f, var_75d1d), 0.0), 0.0, 1.0);
    highp float var_d573f = var_11376 * var_11376;
    highp vec4 var_234cf = vec4(0.0, 0.0, 0.0, 1.0);
    highp float var_79a06 = var_df530.x * var_df530.x;
    highp vec4 var_5b3d6 = SkyAmbientLightColorIntensity;
    highp float var_0eef2 = var_df530.y * var_df530.y;
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
    highp vec3 var_aacc4;
    if (var_68aa1)
    {
        highp vec4 var_2fd23 = vec4(1.0);
        highp vec4 var_8490a = SkyAmbientLightColorIntensity;
        var_aacc4 = max(((clamp(vec3(1.0 + (var_2fd23.x * var_2fd23.w), 1.0 + (var_2fd23.y * var_2fd23.w), 1.0 + (var_2fd23.z * var_2fd23.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * 1.0) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_8490a.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_aacc4 = vec3(0.0);
    }
    highp vec3 var_77240 = -var_c1b4f;
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_7e7a4 = clamp((((length(v_worldPos) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_7e7a4 > 0.0)
        {
            highp vec3 var_fe67e;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_fe67e = FogColor.xyz * max(var_aacc4, vec3(1.0));
            }
            else
            {
                highp vec4 var_52ab1 = SunColor;
                highp vec4 var_c9ec4 = MoonColor;
                highp vec3 var_e3755 = var_77240;
                highp float var_7b136 = FogSkyBlend.x - FogSkyBlend.w;
                highp float var_e285c = smoothstep(FogSkyBlend.y, var_7b136, var_e3755.y);
                highp float var_2ea2e = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_7b136, var_e3755.y);
                highp float var_ec0d7 = dot(var_77240, SunDir.xyz);
                highp float var_f7518 = dot(var_77240, MoonDir.xyz);
                highp float var_ae688 = clamp(pow(max(var_ec0d7, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_a74b4 = clamp(pow(max(var_f7518, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_6773c = 1.809999942779541015625 - (var_ae688 * 1.7999999523162841796875);
                highp float var_fed1e = 1.809999942779541015625 - (var_a74b4 * 1.7999999523162841796875);
                var_fe67e = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_e285c * var_e285c) * var_e285c, 0.0, 1.0))) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_52ab1.w * (0.75 * ((var_ec0d7 * var_ec0d7) + 1.0))) + (var_c9ec4.w * (0.75 * ((var_f7518 * var_f7518) + 1.0))))) + (((SkyHorizonColor.xyz * clamp((var_2ea2e * var_2ea2e) * var_2ea2e, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_52ab1.w) * AtmosphericScattering.y) * var_ae688) * (0.0361000001430511474609375 / (var_6773c * sqrt(var_6773c)))) + ((((MoonColor.xyz * var_c9ec4.w) * AtmosphericScattering.z) * var_a74b4) * (0.0361000001430511474609375 / (var_fed1e * sqrt(var_fed1e))))));
            }
            var_138a7 = var_fe67e;
        }
        else
        {
            var_138a7 = vec3(0.0);
        }
        var_bdb1d = var_7e7a4;
        var_1bb57 = var_138a7;
    }
    else
    {
        var_bdb1d = 0.0;
        var_1bb57 = vec3(0.0);
    }
    highp vec4 var_f4cc5 = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_1f0f0 = var_f4cc5;
    highp vec4 var_59bc8;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_115ba = (var_4169c.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_4169c, 1.0);
        highp float var_8cf8f = var_115ba.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_115ba.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_59bc8 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_59bc8 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_f979d = var_59bc8;
    highp vec3 var_24b16 = var_59bc8.xyz + (mix(((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((var_d573f * var_d573f) * var_11376))) * (1.0 - (((var_0f69a * var_0f69a) * var_0f69a) * IBLParameters.x))) * max(((clamp(vec3(var_79a06 + (var_234cf.x * var_234cf.w), (var_79a06 * ((((var_79a06 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_234cf.y * var_234cf.w), (var_79a06 * (((var_79a06 * var_79a06) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_234cf.z * var_234cf.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * 1.0) + ((SkyAmbientLightColorIntensity.xyz * mix((var_0eef2 * var_0eef2) * var_df530.y, (var_df530.y * var_df530.y) * var_df530.y, CameraLightIntensity.y)) * var_5b3d6.w), AmbientLightParams.xyz * AmbientLightParams.w)) + var_083c2) + (((mix(vec3(0.0), vec3(0.0), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_2a2e9)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_f4cc5.xyz, vec3(var_1f0f0.w)) * var_f979d.w);
    highp float var_c6288;
    if (var_679de > 0)
    {
        highp float var_9af11;
        if (max(dot(var_75d1d, refract(normalize(normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)), -var_75d1d, 1.3329999446868896484375)), 0.0) > 0.0)
        {
            var_9af11 = 0.0;
        }
        else
        {
            var_9af11 = 1.0;
        }
        var_c6288 = var_9af11;
    }
    else
    {
        var_c6288 = 1.0;
    }
    highp vec3 var_5e1c8;
    if (PreExposureEnabled.x > 0.0)
    {
        var_5e1c8 = var_24b16 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_5e1c8 = var_24b16;
    }
    bgfx_FragData[0] = vec4(var_5e1c8.x, var_5e1c8.y, var_5e1c8.z, vec4(var_abd4d, var_abd4d, var_abd4d, var_c6288).w);
}
