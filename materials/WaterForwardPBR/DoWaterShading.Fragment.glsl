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
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_LightMapTexture;
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 5, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform lowp sampler2D s_SeasonsTexture;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 13, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 14, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 15, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 PointLightNdLFloor;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
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
* - uniform vec4 Time;
* - uniform vec4 ViewPositionAndTime;
* - uniform vec4 ViewportScale;
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

layout(binding = 5, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_0481b;
layout(binding = 15, std430) buffer s_zLights { Light zLights[]; } var_833a7;
layout(binding = 14, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_afaee;
uniform highp mat4 CascadesShadowProj[8];
uniform highp mat4 CloudShadowProj;
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
uniform highp vec4 CascadesParameters[8];
uniform highp vec4 CascadesPerSet;
uniform highp vec4 CloudShadowsVisible;
uniform highp vec4 ClusterDepthBounds;
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ClusterNearFarWidthHeight;
uniform highp vec4 ClusterSize;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightSourceShadowDirection;
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection;
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
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
uniform highp vec4 PointLightNdLFloor;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 PointLightSpecularFadeOutParameters;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SkyHorizonColor;
uniform highp vec4 SkyZenithColor;
uniform highp vec4 SunColor;
uniform highp vec4 SunDir;
uniform highp vec4 ViewPositionAndTime;
uniform highp vec4 ViewportScale;
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
    highp vec2 loc_59055 = vec2(var_0481b.PBRData[v_pbrTextureId].colourToNormalUvScale0, var_0481b.PBRData[v_pbrTextureId].colourToNormalUvScale1);
    highp vec2 loc_39ca3 = vec2(var_0481b.PBRData[v_pbrTextureId].colourToNormalUvBias0, var_0481b.PBRData[v_pbrTextureId].colourToNormalUvBias1);
    highp vec3 loc_b4ff6;
    if ((var_0481b.PBRData[v_pbrTextureId].flags & 4) == 4)
    {
        loc_b4ff6 = (texture(s_MatTexture, (v_texcoord0 * loc_59055) + loc_39ca3).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 loc_9252d;
        if ((var_0481b.PBRData[v_pbrTextureId].flags & 8) == 8)
        {
            highp vec2 loc_218fe = (v_texcoord0 * loc_59055) + loc_39ca3;
            highp vec3 loc_2ae5f = vec3(0.0, 0.0, 1.0);
            highp float loc_b88fd = clamp((min(var_0481b.PBRData[v_pbrTextureId].maxMipNormal - var_0481b.PBRData[v_pbrTextureId].maxMipColour, var_0481b.PBRData[v_pbrTextureId].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
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
    if ((var_0481b.PBRData[v_pbrTextureId].flags & 1) == 1)
    {
        highp vec4 loc_62c5e = texture(s_MatTexture, (v_texcoord0 * vec2(var_0481b.PBRData[v_pbrTextureId].colourToMaterialUvScale0, var_0481b.PBRData[v_pbrTextureId].colourToMaterialUvScale1)) + vec2(var_0481b.PBRData[v_pbrTextureId].colourToMaterialUvBias0, var_0481b.PBRData[v_pbrTextureId].colourToMaterialUvBias1));
        loc_00c14 = loc_62c5e.y;
        loc_659d6 = loc_62c5e.z;
    }
    else
    {
        loc_00c14 = var_0481b.PBRData[v_pbrTextureId].uniformEmissive;
        loc_659d6 = var_0481b.PBRData[v_pbrTextureId].uniformRoughness;
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
void func_59bf3(inout highp vec3 arg_3a8bb, inout highp float arg_13db0, inout highp vec4 arg_f7c69, inout highp float arg_7a26d) {
    highp vec4 loc_90e3d = PlayerShadowProj * vec4(arg_3a8bb, 1.0);
    highp float loc_fcb6d = clamp(arg_13db0, arg_f7c69.x, 1.0);
    loc_90e3d.z -= (CascadesParameters[0].y + (CascadesParameters[0].z * (sqrt(1.0 - (loc_fcb6d * loc_fcb6d)) / loc_fcb6d)));
    loc_90e3d.z = min(loc_90e3d.z, 1.0);
    highp vec2 loc_f9579 = ((vec2(loc_90e3d.x, loc_90e3d.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    int loc_ec55d = (QuantizationParameters.x != 0.0) ? 1 : 2;
    int loc_ed2e2 = loc_ec55d / 2;
    loc_90e3d.z = (loc_90e3d.z * 0.5) + 0.5;
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
            highp vec2 loc_6d158 = loc_f9579 + ((vec2(float(loc_02668 - loc_ed2e2) + 0.5, float(loc_467f0 - loc_ed2e2) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            highp vec3 loc_f4800 = vec3(loc_6d158.x, loc_6d158.y, loc_51c21);
            if (QuantizationParameters.x != 0.0)
            {
                loc_8daf8 = loc_72f9e + float(textureLod(s_ShadowCascades, loc_f4800, 0.0).x >= loc_90e3d.z);
            }
            else
            {
                highp vec4 loc_1f2f1 = step(vec4(loc_90e3d.z), textureGather(s_ShadowCascades, loc_f4800));
                highp vec2 loc_127fb = fract((loc_f4800.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_8daf8 = loc_72f9e + mix(mix(loc_1f2f1.w, loc_1f2f1.z, loc_127fb.x), mix(loc_1f2f1.x, loc_1f2f1.y, loc_127fb.x), loc_127fb.y);
            }
        }
    }
    arg_7a26d = loc_9af5f / float(loc_ec55d * loc_ec55d);
}
void func_35d0b(inout highp vec2 arg_ea738, inout highp vec3 arg_b6d8c, inout highp vec3 arg_488fe, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_3f549, inout highp vec3 arg_c7286, inout highp float arg_e0484) {
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
        arg_b6d8c = vec3(0.0);
        return;
    }
    highp float loc_66ad9;
    if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
    {
        highp float loc_93b5c = max(dot(arg_488fe, normalize((u_view * DirectionalLightSourceShadowDirection).xyz)), 0.0);
        highp vec3 loc_28854 = arg_adf73 + ((arg_c100b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_93b5c, 0.0, 1.0));
        highp float loc_c387c;
        loc_c387c = 1.0;
        int loc_babe7;
        highp float loc_4d56f;
        for (int loc_f43b4 = 0, loc_aaaad = 0; (loc_f43b4 < 4) && (loc_aaaad < 8); loc_c387c = loc_4d56f, loc_aaaad = loc_babe7, loc_f43b4++)
        {
            int loc_724f1 = int(CascadesPerSet[loc_f43b4]);
            for (int loc_c0375 = 0; loc_c0375 < loc_724f1; loc_c0375++)
            {
                int loc_3cede = loc_aaaad + loc_c0375;
                if (loc_3cede >= 8)
                {
                    loc_4d56f = loc_c387c;
                    break;
                }
                highp vec4 loc_d8b45 = CascadesShadowProj[loc_3cede] * vec4(loc_28854, 1.0);
                highp vec3 loc_f82b9 = abs(loc_d8b45.xyz);
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
                bool loc_da05c;
                if (loc_d55ba)
                {
                    loc_da05c = loc_f82b9.z <= 1.0;
                }
                else
                {
                    loc_da05c = loc_d55ba;
                }
                if (!loc_da05c)
                {
                    continue;
                }
                highp vec4 loc_e2716 = loc_d8b45;
                highp vec4 loc_ac786 = NdLFloor;
                highp float loc_e3626 = clamp(loc_93b5c, loc_ac786[loc_3cede], 1.0);
                highp float loc_0ebc3 = CascadesParameters[loc_3cede].y + (CascadesParameters[loc_3cede].z * (sqrt(1.0 - (loc_e3626 * loc_e3626)) / loc_e3626));
                int loc_73fe4;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_73fe4 = 1;
                }
                else
                {
                    loc_73fe4 = clamp(int(CascadesParameters[loc_3cede].w + 0.5), 1, 9);
                }
                int loc_2b064 = loc_73fe4 / 2;
                highp vec2 loc_c324a = ((vec2(loc_e2716.x, loc_e2716.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_3cede].x;
                highp float loc_3198a = (loc_e2716.z * 0.5) + 0.5;
                loc_c324a.y += (1.0 - CascadesParameters[loc_3cede].x);
                highp float loc_5ff83;
                loc_5ff83 = 0.0;
                highp float loc_793bd;
                for (int loc_6984d = 0; loc_6984d < loc_73fe4; loc_5ff83 = loc_793bd, loc_6984d++)
                {
                    loc_793bd = loc_5ff83;
                    highp float loc_cc5f7;
                    for (int loc_2f95f = 0; loc_2f95f < loc_73fe4; loc_793bd = loc_cc5f7, loc_2f95f++)
                    {
                        highp vec2 loc_49c29 = loc_c324a + ((vec2(float(loc_2f95f - loc_2b064) + 0.5, float(loc_6984d - loc_2b064) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_3cede].x);
                        highp vec4 loc_f4b0f = textureGather(s_ShadowCascades, vec3(loc_49c29, float(loc_3cede)));
                        highp vec4 loc_a366c = loc_f4b0f;
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_cc5f7 = loc_793bd + float(loc_a366c.w >= (loc_3198a - loc_0ebc3));
                        }
                        else
                        {
                            highp vec4 loc_f7572 = step(vec4(loc_3198a - loc_0ebc3), loc_f4b0f);
                            highp vec2 loc_87adc = fract((loc_49c29 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            loc_cc5f7 = loc_793bd + mix(mix(loc_f7572.w, loc_f7572.z, loc_87adc.x), mix(loc_f7572.x, loc_f7572.y, loc_87adc.x), loc_87adc.y);
                        }
                    }
                }
                loc_4d56f = min(loc_c387c, loc_5ff83 / float(loc_73fe4 * loc_73fe4));
                break;
            }
            loc_babe7 = loc_aaaad + loc_724f1;
        }
        highp float loc_ace78;
        if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
        {
            highp vec4 loc_a39dc = NdLFloor;
            highp float loc_80bb3;
            func_59bf3(loc_28854, loc_93b5c, loc_a39dc, loc_80bb3);
            loc_ace78 = loc_80bb3;
        }
        else
        {
            loc_ace78 = 1.0;
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
        highp float loc_e5d4d;
        if (loc_b7d63)
        {
            highp vec4 loc_c8015 = NdLFloor;
            highp vec4 loc_8ad63 = CloudShadowProj * vec4(loc_28854, 1.0);
            highp vec4 loc_ac654 = loc_8ad63;
            loc_ac654 = loc_8ad63 / vec4(loc_ac654.w);
            highp float loc_12cc8 = clamp(loc_93b5c, loc_c8015.x, 1.0);
            loc_ac654.z -= ((CascadesParameters[0].y + (CascadesParameters[0].z * (sqrt(1.0 - (loc_12cc8 * loc_12cc8)) / loc_12cc8))) / loc_ac654.w);
            highp vec2 loc_340fb = ((vec2(loc_ac654.x, loc_ac654.y) * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
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
            loc_ac654.z = (loc_ac654.z * 0.5) + 0.5;
            loc_340fb.y += (1.0 - CascadesParameters[0].x);
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
                    highp vec3 loc_53ff4 = vec3(loc_340fb + ((vec2(float(loc_e18e2 - loc_15bcb) + 0.5, float(loc_5837b - loc_15bcb) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_0e3bc);
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_003c8 = loc_894a5 + float(textureLod(s_ShadowCascades, loc_53ff4, 0.0).x >= loc_ac654.z);
                    }
                    else
                    {
                        highp vec4 loc_bf06a = step(vec4(loc_ac654.z), textureGather(s_ShadowCascades, loc_53ff4));
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
            loc_e5d4d = loc_1bbb8;
        }
        else
        {
            loc_e5d4d = 1.0;
        }
        loc_66ad9 = mix(min(loc_c387c, min(loc_ace78, loc_e5d4d)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_3f549.z));
    }
    else
    {
        loc_66ad9 = 1.0;
    }
    highp vec3 loc_d841a = normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz);
    highp vec4 loc_1d9d1 = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp float loc_f4016 = max(dot(arg_488fe, loc_d841a), 0.0);
    highp float loc_c3997 = max(dot(arg_488fe, arg_c7286), 0.0);
    highp vec3 loc_77b0a = normalize(loc_d841a + arg_c7286);
    highp float loc_b831c = max(arg_e0484, 0.0500000007450580596923828125);
    highp float loc_009bf = loc_b831c * loc_b831c;
    highp float loc_96073 = loc_009bf * loc_009bf;
    highp float loc_206e3 = max(dot(arg_488fe, loc_77b0a), 0.0);
    highp float loc_53226 = (((loc_96073 - 1.0) * loc_206e3) * loc_206e3) + 1.0;
    highp float loc_1c1ce = loc_009bf * 0.5;
    highp float loc_b6403 = clamp(1.0 - max(dot(arg_c7286, loc_77b0a), 0.0), 0.0, 1.0);
    highp float loc_afe8c = loc_b6403 * loc_b6403;
    arg_b6d8c = (((((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((loc_afe8c * loc_afe8c) * loc_b6403))) * (loc_96073 / ((loc_53226 * loc_53226) * 3.1415927410125732421875))) * ((loc_c3997 / (((loc_c3997 * (1.0 - loc_1c1ce)) + loc_1c1ce) + 9.9999997473787516355514526367188e-05)) * (loc_f4016 / (((loc_f4016 * (1.0 - loc_1c1ce)) + loc_1c1ce) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_f4016) * loc_c3997) + 9.9999997473787516355514526367188e-05)) * loc_f4016) * loc_66ad9) * (((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_1d9d1.w) * 1.0) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight.x)) * DiffuseSpecularEmissiveAmbientTermToggles.y;
}
void func_5d077(inout highp float arg_958de, inout highp vec2 arg_e6843, inout highp float arg_33edf, inout highp vec2 arg_410bb, inout highp vec3 arg_e0671) {
    if (arg_958de < arg_e6843.x)
    {
        arg_33edf = -1.0;
        return;
    }
    bool loc_4e95c = arg_958de >= arg_e6843.x;
    bool loc_6742e;
    if (loc_4e95c)
    {
        loc_6742e = arg_958de <= arg_410bb.x;
    }
    else
    {
        loc_6742e = loc_4e95c;
    }
    if (loc_6742e)
    {
        arg_33edf = 0.0;
        return;
    }
    bool loc_78834 = arg_958de > arg_410bb.x;
    bool loc_c9362;
    if (loc_78834)
    {
        loc_c9362 = arg_958de <= arg_410bb.y;
    }
    else
    {
        loc_c9362 = loc_78834;
    }
    if (loc_c9362)
    {
        arg_33edf = 1.0;
        return;
    }
    arg_33edf = floor((log2(arg_958de / arg_410bb.y) * ((arg_e0671.z - 2.0) / log2(arg_e6843.y / arg_410bb.y))) + 2.0);
}
void func_39684(inout highp vec3 arg_9f603, inout highp vec3 arg_6a18e, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp float loc_28341 = -arg_9f603.z;
    highp vec2 loc_6ed76 = ((arg_6a18e.xy + vec2(1.0)) * vec2(0.5)) * ViewportScale.xy;
    highp vec3 loc_fd394 = ClusterDimensions.xyz;
    highp vec2 loc_703d4 = ClusterNearFarWidthHeight.zw;
    highp vec2 loc_d7b5c = ClusterSize.xy;
    highp vec2 loc_909cb = ClusterNearFarWidthHeight.xy;
    highp vec2 loc_eee23 = ClusterDepthBounds.xy;
    highp float loc_5de3f;
    func_5d077(loc_28341, loc_909cb, loc_5de3f, loc_eee23, loc_fd394);
    highp vec3 loc_60667 = vec3(floor((loc_6ed76.x * loc_703d4.x) / loc_d7b5c.x), floor((loc_6ed76.y * loc_703d4.y) / loc_d7b5c.y), loc_5de3f);
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
void func_8fc55(inout int arg_0ec26, inout highp float arg_9eee0, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c) {
    if (var_833a7.zLights[arg_0ec26].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        return;
    }
    highp vec3 loc_44ea9 = arg_aee55 - var_833a7.zLights[arg_0ec26].position.xyz;
    highp vec3 loc_b2243 = abs(loc_44ea9);
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
    highp vec4 loc_02fd5 = PointLightProj * vec4(loc_b2243, 1.0);
    highp float loc_2f407 = clamp(dot(normalize(-loc_44ea9), normalize(arg_1111c)), PointLightNdLFloor.x, 1.0);
    loc_02fd5.z -= (PointLightShadowParams1.x + (PointLightShadowParams1.y * (sqrt(1.0 - (loc_2f407 * loc_2f407)) / loc_2f407)));
    loc_02fd5 /= vec4(loc_02fd5.w);
    highp vec3 loc_13db4 = loc_44ea9;
    bool loc_fe444 = abs(loc_13db4.y) > abs(loc_13db4.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_13db4.y) > abs(loc_13db4.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_13db4.z *= (-1.0);
    }
    else
    {
        loc_13db4.y *= (-1.0);
    }
    highp float loc_591c8;
    if (((textureLod(s_PointLightShadowTextureArray, vec4(loc_13db4, float(var_833a7.zLights[arg_0ec26].shadowProbeIndex)), 0.0).x * 2.0) - 1.0) >= loc_02fd5.z)
    {
        loc_591c8 = 1.0;
    }
    else
    {
        loc_591c8 = 0.0;
    }
    arg_9eee0 = loc_591c8;
}
void func_67875(inout int arg_d97ba, inout highp float arg_43b7a, inout highp vec3 arg_0a2b9, inout highp vec3 arg_ab1f6, inout highp vec3 arg_81f82) {
    if (arg_d97ba < 0)
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp vec3 loc_a4b3e = var_833a7.zLights[arg_d97ba].position.xyz - v_worldPos;
    highp vec3 loc_8cb9b = loc_a4b3e;
    highp float loc_c64bb;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_c64bb = loc_1829d * loc_1829d;
    }
    else
    {
        loc_c64bb = dot(loc_a4b3e, loc_a4b3e);
    }
    if (loc_c64bb >= (var_833a7.zLights[arg_d97ba].position.w * var_833a7.zLights[arg_d97ba].position.w))
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp float loc_a011d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_1b78e;
        func_8fc55(arg_d97ba, loc_1b78e, arg_ab1f6, arg_81f82);
        loc_a011d = loc_1b78e;
    }
    else
    {
        loc_a011d = 1.0;
    }
    highp float loc_4c5a5 = loc_c64bb / ((var_833a7.zLights[arg_d97ba].position.w * var_833a7.zLights[arg_d97ba].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_fcfce = clamp(1.0 - (loc_4c5a5 * loc_4c5a5), 0.0, 1.0);
    highp float loc_e1ff6 = (1.0 / max(loc_c64bb, 9.9999997473787516355514526367188e-05)) * (loc_fcfce * loc_fcfce);
    highp float loc_ae18a;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_ae18a = loc_e1ff6 * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_e1ff6) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_ae18a = loc_e1ff6;
    }
    arg_43b7a = loc_a011d;
    arg_0a2b9 = (var_833a7.zLights[arg_d97ba].color.xyz * var_833a7.zLights[arg_d97ba].color.w) * loc_ae18a;
}
void func_cd825(inout bool arg_9a2b4, inout bool arg_b6724, inout highp vec3 arg_3289d, inout highp vec3 arg_dc0ef, inout highp vec3 arg_96daa, inout highp vec3 arg_fea00, inout highp vec3 arg_c5372, inout highp vec3 arg_061f9, inout highp float arg_e8ed0, inout highp vec3 arg_5e370, inout highp vec3 arg_78ca7) {
    if (!(arg_9a2b4 || arg_b6724))
    {
        arg_3289d = vec3(0.0);
        return;
    }
    bool loc_9f3ca;
    int loc_9b40b;
    int loc_fbf40;
    func_39684(arg_dc0ef, arg_96daa, loc_fbf40, loc_9b40b, loc_9f3ca);
    if (!loc_9f3ca)
    {
        arg_3289d = vec3(0.0);
        return;
    }
    highp vec3 loc_79fad;
    loc_79fad = vec3(0.0);
    highp vec3 loc_d884d;
    for (int loc_97a60 = loc_9b40b; loc_97a60 < loc_fbf40; loc_79fad = loc_d884d, loc_97a60++)
    {
        int loc_a6f2a = int(var_afaee.zLightLookupArray[loc_97a60].lookup);
        if (loc_a6f2a < 0)
        {
            break;
        }
        highp vec3 loc_c1aab = normalize((u_view * vec4(var_833a7.zLights[loc_a6f2a].position.xyz, 1.0)).xyz - arg_fea00);
        highp vec3 loc_20211;
        if (arg_b6724)
        {
            highp vec3 loc_a5496;
            if (arg_9a2b4)
            {
                highp float loc_97c1f = max(dot(arg_c5372, loc_c1aab), 0.0);
                highp float loc_207e1 = max(dot(arg_c5372, arg_061f9), 0.0);
                highp vec3 loc_608b6 = normalize(loc_c1aab + arg_061f9);
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
                highp float loc_fb758 = max(dot(arg_c5372, loc_c1aab), 0.0);
                highp float loc_3c3a6 = max(dot(arg_c5372, arg_061f9), 0.0);
                highp vec3 loc_74f40 = normalize(loc_c1aab + arg_061f9);
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
        func_67875(loc_a6f2a, loc_ae2d0, loc_1e688, arg_5e370, arg_78ca7);
        loc_d884d = loc_79fad + (((loc_20211 * loc_ae2d0) * loc_1e688) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_3289d = loc_79fad;
}
void func_ac4fc(inout highp vec3 arg_4f139, inout highp vec3 arg_d5e4d, inout highp vec3 arg_540d6, inout highp vec3 arg_b40e7, inout highp vec3 arg_5004c, inout highp vec3 arg_a9ada, inout highp vec3 arg_cd082, inout highp float arg_a0fcd, inout highp vec3 arg_02667) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0))
    {
        arg_4f139 = arg_d5e4d;
        return;
    }
    highp vec3 loc_88b27 = arg_540d6;
    highp float loc_7639d;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        loc_7639d = (abs(loc_88b27.x) + abs(loc_88b27.y)) + abs(loc_88b27.z);
    }
    else
    {
        loc_7639d = length(arg_540d6);
    }
    bool loc_464cb = PointLightSpecularFadeOutParameters.x > 0.0;
    highp float loc_f4966;
    if (loc_464cb)
    {
        loc_f4966 = smoothstep(PointLightSpecularFadeOutParameters.x, PointLightSpecularFadeOutParameters.y, loc_7639d);
    }
    else
    {
        loc_f4966 = 0.0;
    }
    bool loc_49ba4 = !loc_464cb;
    bool loc_2b389;
    if (!loc_49ba4)
    {
        loc_2b389 = loc_464cb && (loc_7639d < PointLightSpecularFadeOutParameters.y);
    }
    else
    {
        loc_2b389 = loc_49ba4;
    }
    bool loc_6ebf5 = PointLightDiffuseFadeOutParameters.x > 0.0;
    bool loc_70859 = !loc_6ebf5;
    bool loc_a196a;
    if (!loc_70859)
    {
        loc_a196a = loc_6ebf5 && (loc_7639d < PointLightDiffuseFadeOutParameters.y);
    }
    else
    {
        loc_a196a = loc_70859;
    }
    highp vec3 loc_b6871;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_b6871 = arg_b40e7;
    }
    else
    {
        loc_b6871 = v_worldPos;
    }
    highp vec3 loc_2d8f4 = arg_540d6;
    highp vec3 loc_f3788;
    func_cd825(loc_2b389, loc_a196a, loc_f3788, loc_2d8f4, arg_5004c, arg_540d6, arg_a9ada, arg_cd082, arg_a0fcd, loc_b6871, arg_02667);
    arg_4f139 = arg_d5e4d + (loc_f3788 * (1.0 - loc_f4966));
}
void main() {
    int var_679de = int(gl_FrontFacing);
    highp vec2 var_3bbbe = v_lightmapUV;
    highp vec3 var_c1b4f = normalize(-normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz));
    highp vec3 var_b5f17;
    highp float var_780ff;
    highp float var_d68f9;
    func_afe0b(var_d68f9, var_780ff, var_b5f17, var_679de);
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
    highp vec3 var_df394 = normalize(var_cd05b);
    highp vec4 var_83731 = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_b8928 = var_83731;
    highp vec3 var_99267 = var_83731.xyz / vec3(var_b8928.w);
    highp vec3 var_ec482 = (u_view * vec4(v_worldPos, 1.0)).xyz;
    highp vec3 var_239fe = v_worldPos - WorldOrigin.xyz;
    highp vec3 var_eebcb = dFdx(var_ec482);
    highp vec3 var_211c8 = dFdy(var_ec482);
    highp vec3 var_5acf5 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(var_eebcb), normalize(var_211c8))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_7d782 = mod(var_239fe, vec3(QuantizationParameters.z));
    highp vec3 var_09fb1 = (var_239fe - (var_7d782 - (var_5acf5 * dot(var_7d782, var_5acf5)))) + WorldOrigin.xyz;
    highp vec3 var_60995 = (u_view * vec4(var_df394, 1.0)).xyz;
    highp vec3 var_5bd0a = var_99267;
    highp vec3 var_96d53;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_23159 = -(var_ec482 / vec3(length(var_ec482) + 9.9999997473787516355514526367188e-05));
        highp vec3 var_82bc2 = var_ec482;
        highp vec3 var_88c8f;
        if (int(QuantizationParameters.y) > 0)
        {
            var_88c8f = var_09fb1;
        }
        else
        {
            var_88c8f = v_worldPos;
        }
        highp vec3 var_532f1;
        func_35d0b(var_3bbbe, var_532f1, var_60995, var_88c8f, var_df394, var_82bc2, var_23159, var_d68f9);
        highp vec3 var_38611;
        func_ac4fc(var_38611, var_532f1, var_ec482, var_09fb1, var_99267, var_60995, var_23159, var_d68f9, var_df394);
        var_96d53 = var_38611;
    }
    else
    {
        var_96d53 = vec3(0.0);
    }
    highp float var_6981f = clamp(((var_3bbbe.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_f9a4c = clamp(1.0 - max(dot(var_c1b4f, var_df394), 0.0), 0.0, 1.0);
    highp float var_26112 = var_f9a4c * var_f9a4c;
    highp vec4 var_28e02 = vec4(0.0, 0.0, 0.0, 1.0);
    highp float var_72637 = var_3bbbe.x * var_3bbbe.x;
    highp vec4 var_996fe = SkyAmbientLightColorIntensity;
    highp float var_c5c83 = var_3bbbe.y * var_3bbbe.y;
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
    highp vec3 var_d9480;
    if (var_68aa1)
    {
        highp vec4 var_0e954 = vec4(1.0);
        highp vec4 var_4c0ec = SkyAmbientLightColorIntensity;
        var_d9480 = max((clamp(vec3(1.0 + (var_0e954.x * var_0e954.w), 1.0 + (var_0e954.y * var_0e954.w), 1.0 + (var_0e954.z * var_0e954.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_4c0ec.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_d9480 = vec3(0.0);
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
                var_fe67e = FogColor.xyz * max(var_d9480, vec3(1.0));
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
    highp vec4 var_887f3 = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_8d335 = var_887f3;
    highp vec4 var_cd5c5;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_115ba = (var_99267.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_99267, 1.0);
        highp float var_8cf8f = var_115ba.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_8cf8f, var_115ba.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_14f4f = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_0e80b = clamp(int(var_14f4f), 0, var_dbde4.z - 2);
        var_cd5c5 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_cd5c5 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_8cbd4 = var_cd5c5;
    highp vec3 var_f1d41 = var_cd5c5.xyz + (mix(((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((var_26112 * var_26112) * var_f9a4c))) * (1.0 - (((var_6981f * var_6981f) * var_6981f) * IBLParameters.x))) * max((clamp(vec3(var_72637 + (var_28e02.x * var_28e02.w), (var_72637 * ((((var_72637 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_28e02.y * var_28e02.w), (var_72637 * (((var_72637 * var_72637) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_28e02.z * var_28e02.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_c5c83 * var_c5c83) * var_3bbbe.y, (var_3bbbe.y * var_3bbbe.y) * var_3bbbe.y, CameraLightIntensity.y)) * var_996fe.w), AmbientLightParams.xyz * AmbientLightParams.w)) + var_96d53) + (((mix(vec3(0.0), vec3(0.0), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_780ff)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_887f3.xyz, vec3(var_8d335.w)) * var_8cbd4.w);
    highp float var_c6288;
    if (var_679de > 0)
    {
        highp float var_9af11;
        if (max(dot(var_df394, refract(normalize(normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)), -var_df394, 1.3329999446868896484375)), 0.0) > 0.0)
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
        var_5e1c8 = var_f1d41 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_5e1c8 = var_f1d41;
    }
    bgfx_FragData[0] = vec4(var_5e1c8.x, var_5e1c8.y, var_5e1c8.z, vec4(var_abd4d, var_abd4d, var_abd4d, var_c6288).w);
}
