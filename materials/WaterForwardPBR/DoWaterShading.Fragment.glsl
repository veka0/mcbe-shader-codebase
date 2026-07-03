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
* - uniform mat4 DirectionalLightSourceCausticsViewProj[2];
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
* - uniform vec4 DirectionalLightSourceShadowDirection[2];
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
layout(binding = 15, std430) buffer s_zLights { Light zLights[]; } var_3e6ec;
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
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
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
void func_f0809(inout highp vec4 arg_c59ed, inout int arg_6e576, inout highp vec3 arg_0d628, inout bool arg_5e3ed) {
    arg_c59ed = CascadesShadowProj[arg_6e576] * vec4(arg_0d628, 1.0);
    highp vec4 loc_108af = arg_c59ed;
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
        arg_5e3ed = true;
        return;
    }
    arg_5e3ed = false;
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
void func_9d40a(inout highp vec2 arg_ea738, inout highp vec3 arg_534d1, inout highp vec3 arg_69e1b, inout highp vec3 arg_016ce, inout highp vec3 arg_68e47, inout highp vec3 arg_a9fca, inout highp vec3 arg_81f79, inout highp float arg_d565c, inout highp vec2 arg_90d04) {
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
    for (int loc_7d000 = 0; loc_7d000 < loc_bf766; loc_5c80c = loc_81b2f, loc_7d000++)
    {
        highp float loc_e7fb8;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            highp float loc_29bbf = max(dot(arg_69e1b, normalize((u_view * DirectionalLightSourceShadowDirection[loc_7d000]).xyz)), 0.0);
            highp vec4 loc_25c1d = NdLFloor;
            highp vec3 loc_90678 = arg_016ce + ((arg_68e47 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_29bbf, 0.0, 1.0));
            highp float loc_92ac2;
            loc_92ac2 = 1.0;
            int loc_14db9;
            highp float loc_3e8e6;
            for (int loc_94040 = 0, loc_163a5 = 0; loc_94040 < 4; loc_163a5 = loc_14db9, loc_92ac2 = loc_3e8e6, loc_94040++)
            {
                int loc_a48fd = int(CascadesPerSet[loc_94040]);
                for (int loc_bc103 = 0; loc_bc103 < loc_a48fd; loc_bc103++)
                {
                    int loc_83d12 = loc_163a5 + loc_bc103;
                    if (loc_83d12 >= 8)
                    {
                        loc_3e8e6 = loc_92ac2;
                        break;
                    }
                    highp vec4 loc_1fd95;
                    bool loc_717f9;
                    func_f0809(loc_1fd95, loc_83d12, loc_90678, loc_717f9);
                    highp vec4 loc_569e5 = loc_1fd95;
                    if (!loc_717f9)
                    {
                        continue;
                    }
                    highp float loc_34935 = clamp(loc_29bbf, loc_25c1d[loc_83d12], 1.0);
                    highp float loc_bac6a = CascadesParameters[loc_83d12].y + (CascadesParameters[loc_83d12].z * (sqrt(1.0 - (loc_34935 * loc_34935)) / loc_34935));
                    int loc_70c69;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_70c69 = 1;
                    }
                    else
                    {
                        loc_70c69 = clamp(int(CascadesParameters[loc_83d12].w + 0.5), 1, 9);
                    }
                    int loc_960ef = loc_70c69 / 2;
                    highp vec2 loc_63e61 = ((vec2(loc_569e5.x, loc_569e5.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_83d12].x;
                    highp float loc_6c9d9 = (loc_569e5.z * 0.5) + 0.5;
                    loc_63e61.y += (1.0 - CascadesParameters[loc_83d12].x);
                    highp float loc_60326;
                    loc_60326 = 0.0;
                    highp float loc_641ba;
                    for (int loc_d663a = 0; loc_d663a < loc_70c69; loc_60326 = loc_641ba, loc_d663a++)
                    {
                        loc_641ba = loc_60326;
                        highp float loc_106c7;
                        for (int loc_07ee5 = 0; loc_07ee5 < loc_70c69; loc_641ba = loc_106c7, loc_07ee5++)
                        {
                            highp vec2 loc_53530 = loc_63e61 + ((vec2(float(loc_07ee5 - loc_960ef) + 0.5, float(loc_d663a - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_83d12].x);
                            highp vec4 loc_b5d2e = textureGather(s_ShadowCascades, vec3(loc_53530, float(loc_83d12)));
                            highp vec4 loc_1e988 = loc_b5d2e;
                            if (QuantizationParameters.x != 0.0)
                            {
                                loc_106c7 = loc_641ba + float(loc_1e988.w >= (loc_6c9d9 - loc_bac6a));
                            }
                            else
                            {
                                highp vec4 loc_6da26 = step(vec4(loc_6c9d9 - loc_bac6a), loc_b5d2e);
                                highp vec2 loc_70d8a = fract((loc_53530 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                loc_106c7 = loc_641ba + mix(mix(loc_6da26.w, loc_6da26.z, loc_70d8a.x), mix(loc_6da26.x, loc_6da26.y, loc_70d8a.x), loc_70d8a.y);
                            }
                        }
                    }
                    loc_3e8e6 = min(loc_92ac2, loc_60326 / float(loc_70c69 * loc_70c69));
                    break;
                }
                loc_14db9 = loc_163a5 + loc_a48fd;
            }
            highp float loc_2c1f0;
            if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
            {
                highp vec4 loc_ebb95 = NdLFloor;
                highp float loc_a7053;
                func_59bf3(loc_90678, loc_29bbf, loc_ebb95, loc_a7053);
                loc_2c1f0 = min(loc_92ac2, loc_a7053);
            }
            else
            {
                loc_2c1f0 = loc_92ac2;
            }
            bool loc_8174b = int(CloudShadowsVisible.x) > 0;
            bool loc_b7807;
            if (loc_8174b)
            {
                loc_b7807 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
            }
            else
            {
                loc_b7807 = loc_8174b;
            }
            highp float loc_70c88;
            if (loc_b7807)
            {
                highp vec4 loc_87693 = NdLFloor;
                highp vec4 loc_d4de6 = CloudShadowProj * vec4(loc_90678, 1.0);
                highp vec4 loc_dec83 = loc_d4de6;
                loc_dec83 = loc_d4de6 / vec4(loc_dec83.w);
                highp float loc_94797 = clamp(loc_29bbf, loc_87693.x, 1.0);
                loc_dec83.z -= ((CascadesParameters[0].y + (CascadesParameters[0].z * (sqrt(1.0 - (loc_94797 * loc_94797)) / loc_94797))) / loc_dec83.w);
                highp vec2 loc_54a33 = ((vec2(loc_dec83.x, loc_dec83.y) * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
                int loc_4504c;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_4504c = 1;
                }
                else
                {
                    loc_4504c = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z + 0.5), 1, 9);
                }
                int loc_64293 = loc_4504c / 2;
                loc_dec83.z = (loc_dec83.z * 0.5) + 0.5;
                loc_54a33.y += (1.0 - CascadesParameters[0].x);
                highp float loc_f538a = dot(CascadesPerSet, vec4(1.0));
                highp float loc_39767;
                loc_39767 = 0.0;
                highp float loc_90c45;
                for (int loc_9c272 = 0; loc_9c272 < loc_4504c; loc_39767 = loc_90c45, loc_9c272++)
                {
                    loc_90c45 = loc_39767;
                    highp float loc_88f9d;
                    for (int loc_a8e1a = 0; loc_a8e1a < loc_4504c; loc_90c45 = loc_88f9d, loc_a8e1a++)
                    {
                        highp vec3 loc_8bcb2 = vec3(loc_54a33 + ((vec2(float(loc_a8e1a - loc_64293) + 0.5, float(loc_9c272 - loc_64293) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_f538a);
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_88f9d = loc_90c45 + float(textureLod(s_ShadowCascades, loc_8bcb2, 0.0).x >= loc_dec83.z);
                        }
                        else
                        {
                            highp vec4 loc_6717d = step(vec4(loc_dec83.z), textureGather(s_ShadowCascades, loc_8bcb2));
                            highp vec2 loc_d9651 = fract((loc_8bcb2.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            loc_88f9d = loc_90c45 + mix(mix(loc_6717d.w, loc_6717d.z, loc_d9651.x), mix(loc_6717d.x, loc_6717d.y, loc_d9651.x), loc_d9651.y);
                        }
                    }
                }
                highp float loc_b85fb = loc_39767 / float(loc_4504c * loc_4504c);
                highp float loc_5d6fc;
                if (loc_b85fb < 1.0)
                {
                    loc_5d6fc = min(loc_2c1f0, max(loc_b85fb, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                }
                else
                {
                    loc_5d6fc = loc_2c1f0;
                }
                loc_70c88 = loc_5d6fc;
            }
            else
            {
                loc_70c88 = loc_2c1f0;
            }
            loc_e7fb8 = mix(loc_70c88, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_a9fca.z));
        }
        else
        {
            loc_e7fb8 = 1.0;
        }
        highp vec3 loc_af162 = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_7d000]).xyz);
        highp vec4 loc_832de = DirectionalLightSourceDiffuseColorAndIlluminance[loc_7d000];
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
        loc_81b2f = loc_5c80c + ((((((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * ((loc_6d407 * loc_6d407) * loc_eefcb))) * (loc_2743b / ((loc_c3bcc * loc_c3bcc) * 3.1415927410125732421875))) * ((loc_91671 / (((loc_91671 * (1.0 - loc_bf36c)) + loc_bf36c) + 9.9999997473787516355514526367188e-05)) * (loc_8895c / (((loc_8895c * (1.0 - loc_bf36c)) + loc_bf36c) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_8895c) * loc_91671) + 9.9999997473787516355514526367188e-05)) * loc_8895c) * loc_e7fb8) * (((DirectionalLightSourceDiffuseColorAndIlluminance[loc_7d000].xyz * loc_832de.w) * arg_90d04[loc_7d000]) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x)) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_5c80c;
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
void func_258b6(inout highp vec3 arg_9f603, inout highp vec3 arg_1a26b, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp float loc_28341 = -arg_9f603.z;
    highp vec2 loc_25da3 = (arg_1a26b.xy + vec2(1.0)) * vec2(0.5);
    highp vec3 loc_fd394 = ClusterDimensions.xyz;
    highp vec2 loc_703d4 = ClusterNearFarWidthHeight.zw;
    highp vec2 loc_d7b5c = ClusterSize.xy;
    highp vec2 loc_909cb = ClusterNearFarWidthHeight.xy;
    highp vec2 loc_eee23 = ClusterDepthBounds.xy;
    highp float loc_5de3f;
    func_5d077(loc_28341, loc_909cb, loc_5de3f, loc_eee23, loc_fd394);
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
void func_8fc55(inout int arg_0ec26, inout highp float arg_9eee0, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c) {
    if (var_3e6ec.zLights[arg_0ec26].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        return;
    }
    highp vec3 loc_44ea9 = arg_aee55 - var_3e6ec.zLights[arg_0ec26].position.xyz;
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
    if (((textureLod(s_PointLightShadowTextureArray, vec4(loc_13db4, float(var_3e6ec.zLights[arg_0ec26].shadowProbeIndex)), 0.0).x * 2.0) - 1.0) >= loc_02fd5.z)
    {
        loc_591c8 = 1.0;
    }
    else
    {
        loc_591c8 = 0.0;
    }
    arg_9eee0 = loc_591c8;
}
void func_4a650(inout int arg_5cebe, inout highp float arg_43b7a, inout highp vec3 arg_ec226, inout highp vec3 arg_ab1f6, inout highp vec3 arg_81f82) {
    if (arg_5cebe < 0)
    {
        arg_43b7a = 1.0;
        arg_ec226 = vec3(0.0);
        return;
    }
    highp vec3 loc_a4b3e = var_3e6ec.zLights[arg_5cebe].position.xyz - v_worldPos;
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
    if (loc_c64bb >= (var_3e6ec.zLights[arg_5cebe].position.w * var_3e6ec.zLights[arg_5cebe].position.w))
    {
        arg_43b7a = 1.0;
        arg_ec226 = vec3(0.0);
        return;
    }
    highp float loc_a011d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_1b78e;
        func_8fc55(arg_5cebe, loc_1b78e, arg_ab1f6, arg_81f82);
        loc_a011d = loc_1b78e;
    }
    else
    {
        loc_a011d = 1.0;
    }
    highp float loc_4c5a5 = loc_c64bb / ((var_3e6ec.zLights[arg_5cebe].position.w * var_3e6ec.zLights[arg_5cebe].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_fcfce = clamp(1.0 - (loc_4c5a5 * loc_4c5a5), 0.0, 1.0);
    highp float loc_e1ff6 = (1.0 / max(loc_c64bb, 9.9999997473787516355514526367188e-05)) * (loc_fcfce * loc_fcfce);
    highp float loc_f4d7b;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_f4d7b = loc_e1ff6 * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_e1ff6) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_f4d7b = loc_e1ff6;
    }
    arg_43b7a = loc_a011d;
    arg_ec226 = ((var_3e6ec.zLights[arg_5cebe].color.xyz * var_3e6ec.zLights[arg_5cebe].color.w) * loc_f4d7b) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
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
    func_258b6(arg_dc0ef, arg_96daa, loc_fbf40, loc_9b40b, loc_9f3ca);
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
        highp vec3 loc_c1aab = normalize((u_view * vec4(var_3e6ec.zLights[loc_a6f2a].position.xyz, 1.0)).xyz - arg_fea00);
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
        func_4a650(loc_a6f2a, loc_ae2d0, loc_1e688, arg_5e370, arg_78ca7);
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
        func_9d40a(var_df530, var_9aeed, var_7e29b, var_0ae9b, var_75d1d, var_163cf, var_352c1, var_75a5d, var_a7574);
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
        func_cd825(var_32b7d, var_ff142, var_3589b, var_35ff2, var_4169c, var_0fab8, var_7e29b, var_352c1, var_75a5d, var_d0c27, var_75d1d);
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
