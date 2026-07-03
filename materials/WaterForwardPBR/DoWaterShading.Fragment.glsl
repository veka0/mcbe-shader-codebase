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
* - uniform vec4 WaterAlbedoExtinction;
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

struct BiomeInfo {
    highp vec4 waterExtinctionCoefficients;
    highp vec4 waterAlbedoExtinction;
    highp vec4 waterSurfaceParameters;
    highp vec4 waterSurfaceWaveParameters;
    highp vec4 waterSurfaceOctaveParameters;
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
layout(binding = 13, std430) buffer s_zBiomeInfoBuffer { BiomeInfo zBiomeInfoBuffer[]; } var_06448;
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
uniform highp sampler2D s_BiomeBlendingMap;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BiomeBlendingLastUpdatePosition;
uniform highp vec4 BiomeBlendingParameters;
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
void func_8ab59(inout bool arg_5e3ed) {
    if (BiomeBlendingParameters.x > 0.0)
    {
        arg_5e3ed = true;
        return;
    }
    arg_5e3ed = false;
}
void func_20c38(inout highp float arg_27e9a, inout highp float arg_a66d0, inout highp float arg_5b991, inout highp float arg_11702, inout highp float arg_85f79, inout highp float arg_62dbf, inout highp float arg_6c048, inout highp float arg_12931, inout highp float arg_89c42, inout highp float arg_5d066) {
    bool loc_a9f27;
    func_8ab59(loc_a9f27);
    if (loc_a9f27)
    {
        highp vec3 loc_f0fba = v_worldPos;
        int loc_b9c0c = int(BiomeBlendingParameters.z * 0.5);
        highp vec3 loc_4aab1 = BiomeBlendingLastUpdatePosition.xyz + WorldOrigin.xyz;
        highp float loc_ab857 = (loc_f0fba.x - loc_4aab1.x) / BiomeBlendingLastUpdatePosition.w;
        highp float loc_ddaf2 = (loc_f0fba.z - loc_4aab1.z) / BiomeBlendingLastUpdatePosition.w;
        ivec2 loc_542fb = ivec2(loc_b9c0c + int(floor(loc_ab857)), loc_b9c0c + int(floor(loc_ddaf2)));
        loc_542fb.x = clamp(loc_542fb.x, 0, int(BiomeBlendingParameters.z) - 1);
        loc_542fb.y = clamp(loc_542fb.y, 0, int(BiomeBlendingParameters.z) - 1);
        int loc_f1489 = int(round(texelFetch(s_BiomeBlendingMap, loc_542fb, 0).x * 255.0));
        int loc_73e2a = int(round(texelFetch(s_BiomeBlendingMap, loc_542fb + ivec2(1, 0), 0).x * 255.0));
        int loc_eaf0b = int(round(texelFetch(s_BiomeBlendingMap, loc_542fb + ivec2(0, 1), 0).x * 255.0));
        int loc_b7a42 = int(round(texelFetch(s_BiomeBlendingMap, loc_542fb + ivec2(1), 0).x * 255.0));
        highp float loc_01a09 = fract(loc_ab857);
        highp float loc_9e036 = fract(loc_ddaf2);
        highp vec4 loc_7acdf = vec4((1.0 - loc_01a09) * (1.0 - loc_9e036), loc_01a09 * (1.0 - loc_9e036), (1.0 - loc_01a09) * loc_9e036, loc_01a09 * loc_9e036);
        highp vec4 loc_c6eaa = loc_7acdf;
        highp vec4 loc_1b4b8 = loc_7acdf;
        highp vec4 loc_afb1c = loc_7acdf;
        highp vec4 loc_a08d9 = (((var_06448.zBiomeInfoBuffer[loc_f1489].waterSurfaceParameters * loc_c6eaa.x) + (var_06448.zBiomeInfoBuffer[loc_73e2a].waterSurfaceParameters * loc_c6eaa.y)) + (var_06448.zBiomeInfoBuffer[loc_eaf0b].waterSurfaceParameters * loc_c6eaa.z)) + (var_06448.zBiomeInfoBuffer[loc_b7a42].waterSurfaceParameters * loc_c6eaa.w);
        highp vec4 loc_0770f = (((var_06448.zBiomeInfoBuffer[loc_f1489].waterSurfaceWaveParameters * loc_1b4b8.x) + (var_06448.zBiomeInfoBuffer[loc_73e2a].waterSurfaceWaveParameters * loc_1b4b8.y)) + (var_06448.zBiomeInfoBuffer[loc_eaf0b].waterSurfaceWaveParameters * loc_1b4b8.z)) + (var_06448.zBiomeInfoBuffer[loc_b7a42].waterSurfaceWaveParameters * loc_1b4b8.w);
        highp vec4 loc_cd64d = (((var_06448.zBiomeInfoBuffer[loc_f1489].waterSurfaceOctaveParameters * loc_afb1c.x) + (var_06448.zBiomeInfoBuffer[loc_73e2a].waterSurfaceOctaveParameters * loc_afb1c.y)) + (var_06448.zBiomeInfoBuffer[loc_eaf0b].waterSurfaceOctaveParameters * loc_afb1c.z)) + (var_06448.zBiomeInfoBuffer[loc_b7a42].waterSurfaceOctaveParameters * loc_afb1c.w);
        arg_27e9a = loc_a08d9.x;
        arg_a66d0 = loc_a08d9.y;
        arg_5b991 = loc_a08d9.z;
        arg_11702 = loc_a08d9.w;
        arg_85f79 = loc_0770f.x;
        arg_62dbf = loc_0770f.y;
        arg_6c048 = loc_cd64d.x;
        arg_12931 = loc_cd64d.y;
        arg_89c42 = loc_cd64d.z;
        arg_5d066 = loc_cd64d.w;
        return;
    }
    arg_27e9a = WaterSurfaceParameters.x;
    arg_a66d0 = WaterSurfaceParameters.y;
    arg_5b991 = WaterSurfaceParameters.z;
    arg_11702 = WaterSurfaceParameters.w;
    arg_85f79 = WaterSurfaceWaveParameters.x;
    arg_62dbf = WaterSurfaceWaveParameters.y;
    arg_6c048 = WaterSurfaceOctaveParameters.x;
    arg_12931 = WaterSurfaceOctaveParameters.y;
    arg_89c42 = WaterSurfaceOctaveParameters.z;
    arg_5d066 = WaterSurfaceOctaveParameters.w;
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
void func_aed63(inout highp vec2 arg_ea738, inout highp vec3 arg_b6d8c, inout highp vec3 arg_488fe, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_3f549, inout highp vec3 arg_c7286, inout highp float arg_e0484) {
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
        highp float loc_05e4d = max(dot(arg_488fe, normalize((u_view * DirectionalLightSourceShadowDirection).xyz)), 0.0);
        highp vec3 loc_28854 = arg_adf73 + ((arg_c100b * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.w) * clamp(1.0 - loc_05e4d, 0.0, 1.0));
        int loc_40b65 = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
        highp float loc_9f779;
        loc_9f779 = 1.0;
        int loc_fdb66;
        highp float loc_077b9;
        for (int loc_018d5 = 0, loc_591f5 = 0; loc_018d5 < loc_40b65; loc_591f5 = loc_fdb66, loc_9f779 = loc_077b9, loc_018d5++)
        {
            int loc_8c1cb = min((loc_591f5 + int(CascadesPerSet[loc_018d5])), 8);
            loc_077b9 = loc_9f779;
            loc_fdb66 = loc_591f5;
            int loc_0249d;
            highp float loc_849eb;
            for (; loc_fdb66 < loc_8c1cb; loc_077b9 = loc_849eb, loc_fdb66 = loc_0249d)
            {
                highp vec4 loc_0391e = CascadesShadowProj[loc_fdb66] * vec4(loc_28854, 1.0);
                highp vec3 loc_f82b9 = abs(loc_0391e.xyz);
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
                    highp vec4 loc_569e5 = loc_0391e;
                    highp vec4 loc_49c0e = NdLFloor;
                    highp float loc_34935 = clamp(loc_05e4d, loc_49c0e[loc_fdb66], 1.0);
                    highp float loc_bac6a = CascadesParameters[loc_fdb66].y + (CascadesParameters[loc_fdb66].z * (sqrt(1.0 - (loc_34935 * loc_34935)) / loc_34935));
                    int loc_70c69;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_70c69 = 1;
                    }
                    else
                    {
                        loc_70c69 = clamp(int(CascadesParameters[loc_fdb66].w + 0.5), 1, 9);
                    }
                    int loc_960ef = loc_70c69 / 2;
                    highp vec2 loc_63e61 = ((vec2(loc_569e5.x, loc_569e5.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_fdb66].x;
                    highp float loc_6c9d9 = (loc_569e5.z * 0.5) + 0.5;
                    loc_63e61.y += (1.0 - CascadesParameters[loc_fdb66].x);
                    highp float loc_60326;
                    loc_60326 = 0.0;
                    highp float loc_641ba;
                    for (int loc_d663a = 0; loc_d663a < loc_70c69; loc_60326 = loc_641ba, loc_d663a++)
                    {
                        loc_641ba = loc_60326;
                        highp float loc_106c7;
                        for (int loc_07ee5 = 0; loc_07ee5 < loc_70c69; loc_641ba = loc_106c7, loc_07ee5++)
                        {
                            highp vec2 loc_53530 = loc_63e61 + ((vec2(float(loc_07ee5 - loc_960ef) + 0.5, float(loc_d663a - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_fdb66].x);
                            highp vec4 loc_b5d2e = textureGather(s_ShadowCascades, vec3(loc_53530, float(loc_fdb66)));
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
                    loc_849eb = min(loc_077b9, loc_60326 / float(loc_70c69 * loc_70c69));
                    loc_0249d = loc_8c1cb;
                }
                else
                {
                    loc_849eb = loc_077b9;
                    loc_0249d = loc_fdb66 + 1;
                }
            }
        }
        highp float loc_ace78;
        if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
        {
            highp vec4 loc_a39dc = NdLFloor;
            highp float loc_80bb3;
            func_59bf3(loc_28854, loc_05e4d, loc_a39dc, loc_80bb3);
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
            highp float loc_12cc8 = clamp(loc_05e4d, loc_c8015.x, 1.0);
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
        loc_66ad9 = mix(min(loc_9f779, min(loc_ace78, loc_e5d4d)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -arg_3f549.z));
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
    highp float var_84772;
    highp float var_afa04;
    highp float var_32de0;
    highp float var_50295;
    highp float var_13f6b;
    highp float var_e5452;
    highp float var_9217e;
    highp float var_3e578;
    highp float var_28912;
    highp float var_7fae3;
    func_20c38(var_7fae3, var_28912, var_3e578, var_9217e, var_e5452, var_13f6b, var_50295, var_32de0, var_afa04, var_84772);
    highp vec3 var_51929;
    if (var_679de > 0)
    {
        var_51929 = -var_b5f17;
    }
    else
    {
        var_51929 = var_b5f17;
    }
    highp vec3 var_5cad2;
    if (WaterSurfaceEnabled.x > 0.0)
    {
        highp vec3 var_ff527;
        if (var_679de > 0)
        {
            var_ff527 = -v_normal;
        }
        else
        {
            var_ff527 = v_normal;
        }
        highp float var_3037b = ViewPositionAndTime.w * 0.5;
        highp vec2 var_db8aa = (v_worldPos - WorldOrigin.xyz).xz;
        highp vec2 var_715c2 = var_db8aa;
        highp float var_82f84;
        highp float var_af08e;
        highp vec2 var_2ef0e;
        var_2ef0e = var_db8aa;
        var_af08e = 0.0;
        var_82f84 = 0.0;
        highp float var_d9f2a;
        highp float var_38665;
        highp vec2 var_e296e;
        highp float var_1721e;
        highp float var_c2e94;
        highp float var_feadc;
        highp float var_deb76;
        uint var_0ff26 = 0u;
        highp float var_71294 = 0.0;
        highp float var_b8c75 = var_e5452;
        highp float var_c3b5f = var_7fae3;
        highp float var_4422c = 1.0;
        for (; var_0ff26 < uint(var_28912); var_4422c = var_1721e, var_c3b5f = var_c2e94, var_2ef0e = var_e296e, var_b8c75 = var_feadc, var_71294 = var_deb76, var_af08e = var_38665, var_82f84 = var_d9f2a, var_0ff26++)
        {
            highp vec2 var_3ac84 = vec2(sin(var_71294), cos(var_71294));
            highp float var_93224 = (dot(var_3ac84, var_2ef0e) * var_c3b5f) + (var_3037b * var_b8c75);
            highp float var_29a12 = pow((sin(var_93224) + 1.0) * 0.5, var_13f6b);
            highp vec2 var_221b8 = vec2(var_29a12, (var_29a12 * cos(var_93224)) * (-1.0));
            var_d9f2a = var_82f84 + (var_221b8.x * var_4422c);
            var_38665 = var_af08e + var_4422c;
            var_e296e = var_2ef0e + (((var_3ac84 * var_221b8.y) * var_4422c) * var_50295);
            var_1721e = mix(var_4422c, 0.0, var_32de0);
            var_c2e94 = var_c3b5f * var_afa04;
            var_feadc = var_b8c75 * var_84772;
            var_deb76 = var_71294 + 1.39900004863739013671875;
        }
        highp vec3 var_f019c = vec3(var_715c2.x, (var_82f84 / var_af08e) * var_3e578, var_715c2.y);
        highp float var_86d84;
        highp float var_d3610;
        highp vec2 var_cbc38;
        var_cbc38 = var_db8aa - vec2(var_9217e, 0.0);
        var_d3610 = 0.0;
        var_86d84 = 0.0;
        highp float var_6090e;
        highp float var_c3e6b;
        highp vec2 var_c361b;
        highp float var_acbf1;
        highp float var_5712c;
        highp float var_c8f66;
        highp float var_e0c56;
        uint var_a50de = 0u;
        highp float var_07f85 = 0.0;
        highp float var_d7ca3 = var_e5452;
        highp float var_671a8 = var_7fae3;
        highp float var_f78b2 = 1.0;
        for (; var_a50de < uint(var_28912); var_f78b2 = var_acbf1, var_671a8 = var_5712c, var_cbc38 = var_c361b, var_d7ca3 = var_c8f66, var_07f85 = var_e0c56, var_d3610 = var_c3e6b, var_86d84 = var_6090e, var_a50de++)
        {
            highp vec2 var_547d9 = vec2(sin(var_07f85), cos(var_07f85));
            highp float var_0051f = (dot(var_547d9, var_cbc38) * var_671a8) + (var_3037b * var_d7ca3);
            highp float var_83598 = pow((sin(var_0051f) + 1.0) * 0.5, var_13f6b);
            highp vec2 var_3ef36 = vec2(var_83598, (var_83598 * cos(var_0051f)) * (-1.0));
            var_6090e = var_86d84 + (var_3ef36.x * var_f78b2);
            var_c3e6b = var_d3610 + var_f78b2;
            var_c361b = var_cbc38 + (((var_547d9 * var_3ef36.y) * var_f78b2) * var_50295);
            var_acbf1 = mix(var_f78b2, 0.0, var_32de0);
            var_5712c = var_671a8 * var_afa04;
            var_c8f66 = var_d7ca3 * var_84772;
            var_e0c56 = var_07f85 + 1.39900004863739013671875;
        }
        highp float var_4c1f6;
        highp float var_7d802;
        highp vec2 var_0cccf;
        var_0cccf = var_db8aa + vec2(0.0, var_9217e);
        var_7d802 = 0.0;
        var_4c1f6 = 0.0;
        highp float var_19150;
        highp float var_d5aed;
        highp vec2 var_a6b58;
        highp float var_8f034;
        highp float var_6e9d6;
        highp float var_94331;
        highp float var_f1ae6;
        uint var_afc8f = 0u;
        highp float var_4a2b4 = 0.0;
        highp float var_6a7fe = var_e5452;
        highp float var_21493 = var_7fae3;
        highp float var_3e15d = 1.0;
        for (; var_afc8f < uint(var_28912); var_3e15d = var_8f034, var_21493 = var_6e9d6, var_0cccf = var_a6b58, var_6a7fe = var_94331, var_4a2b4 = var_f1ae6, var_7d802 = var_d5aed, var_4c1f6 = var_19150, var_afc8f++)
        {
            highp vec2 var_beff8 = vec2(sin(var_4a2b4), cos(var_4a2b4));
            highp float var_ae2ba = (dot(var_beff8, var_0cccf) * var_21493) + (var_3037b * var_6a7fe);
            highp float var_74e08 = pow((sin(var_ae2ba) + 1.0) * 0.5, var_13f6b);
            highp vec2 var_f90b3 = vec2(var_74e08, (var_74e08 * cos(var_ae2ba)) * (-1.0));
            var_19150 = var_4c1f6 + (var_f90b3.x * var_3e15d);
            var_d5aed = var_7d802 + var_3e15d;
            var_a6b58 = var_0cccf + (((var_beff8 * var_f90b3.y) * var_3e15d) * var_50295);
            var_8f034 = mix(var_3e15d, 0.0, var_32de0);
            var_6e9d6 = var_21493 * var_afa04;
            var_94331 = var_6a7fe * var_84772;
            var_f1ae6 = var_4a2b4 + 1.39900004863739013671875;
        }
        var_5cad2 = normalize(mix(var_ff527, normalize(cross(var_f019c - vec3(var_715c2.x - var_9217e, (var_86d84 / var_d3610) * var_3e578, var_715c2.y), var_f019c - vec3(var_715c2.x, (var_4c1f6 / var_7d802) * var_3e578, var_715c2.y + var_9217e))), vec3(var_ff527.y)));
    }
    else
    {
        var_5cad2 = var_51929;
    }
    highp vec3 var_cd05b;
    if (var_679de > 0)
    {
        var_cd05b = -var_5cad2;
    }
    else
    {
        var_cd05b = var_5cad2;
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
        func_aed63(var_3bbbe, var_532f1, var_60995, var_88c8f, var_df394, var_82bc2, var_23159, var_d68f9);
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
