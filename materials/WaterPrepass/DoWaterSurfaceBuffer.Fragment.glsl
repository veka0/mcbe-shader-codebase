#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_AND_NORMAL_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
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
* - layout(binding = 12, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
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
* - uniform vec4 PointLightPreCalcValues;
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

layout(binding = 12, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_79193;
layout(binding = 13, std430) buffer s_zBiomeInfoBuffer { BiomeInfo zBiomeInfoBuffer[]; } var_e1398;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_BiomeBlendingMap;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 BiomeBlendingLastUpdatePosition;
uniform highp vec4 BiomeBlendingParameters;
uniform highp vec4 ViewPositionAndTime;
uniform highp vec4 WaterSurfaceEnabledAndExtinctionDistShift;
uniform highp vec4 WaterSurfaceOctaveParameters;
uniform highp vec4 WaterSurfaceParameters;
uniform highp vec4 WaterSurfaceWaveParameters;
uniform highp vec4 WorldOrigin;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec3 v_bitangent;
in highp vec2 v_lightmapUV;
in highp vec3 v_normal;
flat in int v_pbrTextureId;
in highp vec3 v_tangent;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void func_9052b(inout highp float arg_6a625, inout highp float arg_9eee0, inout highp float arg_a50e1, inout highp float arg_d2a5b, inout highp vec3 arg_51e76) {
    if (v_pbrTextureId == 65535)
    {
        arg_6a625 = 0.0;
        arg_9eee0 = 1.0;
        arg_a50e1 = 0.0;
        arg_d2a5b = 0.0;
        arg_51e76 = vec3(0.0, 1.0, 0.0);
        return;
    }
    highp vec2 loc_5c197 = vec2(var_79193.PBRData[v_pbrTextureId].colourToNormalUvScale0, var_79193.PBRData[v_pbrTextureId].colourToNormalUvScale1);
    highp vec2 loc_3ee66 = vec2(var_79193.PBRData[v_pbrTextureId].colourToNormalUvBias0, var_79193.PBRData[v_pbrTextureId].colourToNormalUvBias1);
    highp vec3 loc_c8345;
    if ((var_79193.PBRData[v_pbrTextureId].flags & 4) == 4)
    {
        highp vec2 loc_01aa0 = (v_texcoord0 * loc_5c197) + loc_3ee66;
        highp vec3 loc_f7401 = vec3(0.0, 0.0, 1.0);
        highp vec2 loc_e5c3f = loc_01aa0 * vec2(textureSize(s_MatTexture, 0));
        highp vec2 loc_bb3fa = dFdx(loc_e5c3f);
        highp vec2 loc_23f8b = dFdy(loc_e5c3f);
        highp float loc_cbf73 = max(0.0, 0.5 * log2(max(dot(loc_bb3fa, loc_bb3fa), dot(loc_23f8b, loc_23f8b))));
        if (loc_cbf73 <= 1.0)
        {
            highp vec3 loc_644cc = (textureLod(s_MatTexture, loc_01aa0, loc_cbf73).xyz * 2.0) - vec3(1.0);
            loc_f7401 = loc_644cc;
            loc_f7401 = normalize(vec3((loc_644cc.xy * (1.0 / loc_f7401.z)) * (1.0 - clamp(loc_cbf73 * loc_cbf73, 0.0, 1.0)), 1.0));
        }
        loc_c8345 = loc_f7401;
    }
    else
    {
        highp vec3 loc_9252d;
        if ((var_79193.PBRData[v_pbrTextureId].flags & 8) == 8)
        {
            highp vec2 loc_218fe = (v_texcoord0 * loc_5c197) + loc_3ee66;
            highp vec3 loc_2ae5f = vec3(0.0, 0.0, 1.0);
            highp float loc_b88fd = clamp((min(var_79193.PBRData[v_pbrTextureId].maxMipNormal - var_79193.PBRData[v_pbrTextureId].maxMipColour, var_79193.PBRData[v_pbrTextureId].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
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
        loc_c8345 = loc_9252d;
    }
    highp float loc_659d6;
    highp float loc_73c14;
    highp float loc_00c14;
    highp float loc_d7d8a;
    if ((var_79193.PBRData[v_pbrTextureId].flags & 1) == 1)
    {
        highp vec4 loc_300fb = texture(s_MatTexture, (v_texcoord0 * vec2(var_79193.PBRData[v_pbrTextureId].colourToMaterialUvScale0, var_79193.PBRData[v_pbrTextureId].colourToMaterialUvScale1)) + vec2(var_79193.PBRData[v_pbrTextureId].colourToMaterialUvBias0, var_79193.PBRData[v_pbrTextureId].colourToMaterialUvBias1));
        highp float loc_c4db1;
        if ((var_79193.PBRData[v_pbrTextureId].flags & 2) == 2)
        {
            loc_c4db1 = loc_300fb.w;
        }
        else
        {
            loc_c4db1 = var_79193.PBRData[v_pbrTextureId].uniformSubsurface;
        }
        loc_d7d8a = loc_c4db1;
        loc_00c14 = loc_300fb.y;
        loc_73c14 = loc_300fb.x;
        loc_659d6 = loc_300fb.z;
    }
    else
    {
        loc_d7d8a = var_79193.PBRData[v_pbrTextureId].uniformSubsurface;
        loc_00c14 = var_79193.PBRData[v_pbrTextureId].uniformEmissive;
        loc_73c14 = var_79193.PBRData[v_pbrTextureId].uniformMetalness;
        loc_659d6 = var_79193.PBRData[v_pbrTextureId].uniformRoughness;
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
    arg_51e76 = transpose(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(loc_93b23)))) * loc_c8345;
}
void func_8ab59(inout bool arg_5e3ed) {
    if (BiomeBlendingParameters.x > 0.0)
    {
        arg_5e3ed = true;
        return;
    }
    arg_5e3ed = false;
}
void func_15a8f(inout highp vec3 arg_c6525, inout highp vec4 arg_3fac7, inout highp vec4 arg_2f7bf, inout highp vec4 arg_451b0) {
    int loc_738fb = int(BiomeBlendingParameters.z * 0.5);
    highp float loc_6b94b = (arg_c6525.x - BiomeBlendingLastUpdatePosition.x) / BiomeBlendingLastUpdatePosition.w;
    highp float loc_c8c2e = (arg_c6525.z - BiomeBlendingLastUpdatePosition.z) / BiomeBlendingLastUpdatePosition.w;
    ivec2 loc_f487d = ivec2(loc_738fb + int(floor(loc_6b94b)), loc_738fb + int(floor(loc_c8c2e)));
    loc_f487d.x = clamp(loc_f487d.x, 0, int(BiomeBlendingParameters.z) - 1);
    loc_f487d.y = clamp(loc_f487d.y, 0, int(BiomeBlendingParameters.z) - 1);
    int loc_05a8c = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d, 0).x * 255.0));
    int loc_7c209 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(1, 0), 0).x * 255.0));
    int loc_16b81 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(0, 1), 0).x * 255.0));
    int loc_970b0 = int(round(texelFetch(s_BiomeBlendingMap, loc_f487d + ivec2(1), 0).x * 255.0));
    if (((loc_05a8c == loc_7c209) && (loc_7c209 == loc_16b81)) && (loc_16b81 == loc_970b0))
    {
        arg_3fac7 = var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceParameters;
        arg_2f7bf = var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceWaveParameters;
        arg_451b0 = var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceOctaveParameters;
        return;
    }
    highp float loc_77c49 = fract(loc_6b94b);
    highp float loc_33836 = fract(loc_c8c2e);
    highp vec4 loc_2f2a8 = vec4((1.0 - loc_77c49) * (1.0 - loc_33836), loc_77c49 * (1.0 - loc_33836), (1.0 - loc_77c49) * loc_33836, loc_77c49 * loc_33836);
    highp vec4 loc_329f6 = var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceParameters;
    highp vec4 loc_085ea = var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceWaveParameters;
    highp vec4 loc_889f2 = var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceOctaveParameters;
    highp vec4 loc_a8d02 = var_e1398.zBiomeInfoBuffer[loc_7c209].waterSurfaceParameters;
    highp vec4 loc_853ce = var_e1398.zBiomeInfoBuffer[loc_7c209].waterSurfaceWaveParameters;
    highp vec4 loc_bc30c = var_e1398.zBiomeInfoBuffer[loc_7c209].waterSurfaceOctaveParameters;
    bool loc_733bf = loc_329f6.x == loc_a8d02.x;
    bool loc_3293c;
    if (loc_733bf)
    {
        loc_3293c = loc_329f6.y == loc_a8d02.y;
    }
    else
    {
        loc_3293c = loc_733bf;
    }
    bool loc_57ff0;
    if (loc_3293c)
    {
        loc_57ff0 = loc_329f6.z == loc_a8d02.z;
    }
    else
    {
        loc_57ff0 = loc_3293c;
    }
    bool loc_6c960;
    if (loc_57ff0)
    {
        loc_6c960 = loc_085ea.x == loc_853ce.x;
    }
    else
    {
        loc_6c960 = loc_57ff0;
    }
    bool loc_8353a;
    if (loc_6c960)
    {
        loc_8353a = loc_085ea.y == loc_853ce.y;
    }
    else
    {
        loc_8353a = loc_6c960;
    }
    bool loc_780d7;
    if (loc_8353a)
    {
        loc_780d7 = loc_889f2.x == loc_bc30c.x;
    }
    else
    {
        loc_780d7 = loc_8353a;
    }
    bool loc_c6748;
    if (loc_780d7)
    {
        loc_c6748 = loc_889f2.y == loc_bc30c.y;
    }
    else
    {
        loc_c6748 = loc_780d7;
    }
    bool loc_62033;
    if (loc_c6748)
    {
        loc_62033 = loc_889f2.z == loc_bc30c.z;
    }
    else
    {
        loc_62033 = loc_c6748;
    }
    bool loc_3002e;
    if (loc_62033)
    {
        loc_3002e = loc_889f2.w == loc_bc30c.w;
    }
    else
    {
        loc_3002e = loc_62033;
    }
    bool loc_56442;
    if (loc_3002e)
    {
        highp vec4 loc_ce828 = var_e1398.zBiomeInfoBuffer[loc_7c209].waterSurfaceParameters;
        highp vec4 loc_a645a = var_e1398.zBiomeInfoBuffer[loc_7c209].waterSurfaceWaveParameters;
        highp vec4 loc_d0726 = var_e1398.zBiomeInfoBuffer[loc_7c209].waterSurfaceOctaveParameters;
        highp vec4 loc_af7f0 = var_e1398.zBiomeInfoBuffer[loc_16b81].waterSurfaceParameters;
        highp vec4 loc_4e4b3 = var_e1398.zBiomeInfoBuffer[loc_16b81].waterSurfaceWaveParameters;
        highp vec4 loc_e43d7 = var_e1398.zBiomeInfoBuffer[loc_16b81].waterSurfaceOctaveParameters;
        bool loc_5bdec = loc_ce828.x == loc_af7f0.x;
        bool loc_a63e8;
        if (loc_5bdec)
        {
            loc_a63e8 = loc_ce828.y == loc_af7f0.y;
        }
        else
        {
            loc_a63e8 = loc_5bdec;
        }
        bool loc_e610a;
        if (loc_a63e8)
        {
            loc_e610a = loc_ce828.z == loc_af7f0.z;
        }
        else
        {
            loc_e610a = loc_a63e8;
        }
        bool loc_b5305;
        if (loc_e610a)
        {
            loc_b5305 = loc_a645a.x == loc_4e4b3.x;
        }
        else
        {
            loc_b5305 = loc_e610a;
        }
        bool loc_9de97;
        if (loc_b5305)
        {
            loc_9de97 = loc_a645a.y == loc_4e4b3.y;
        }
        else
        {
            loc_9de97 = loc_b5305;
        }
        bool loc_5e6c7;
        if (loc_9de97)
        {
            loc_5e6c7 = loc_d0726.x == loc_e43d7.x;
        }
        else
        {
            loc_5e6c7 = loc_9de97;
        }
        bool loc_f5e38;
        if (loc_5e6c7)
        {
            loc_f5e38 = loc_d0726.y == loc_e43d7.y;
        }
        else
        {
            loc_f5e38 = loc_5e6c7;
        }
        bool loc_3d07c;
        if (loc_f5e38)
        {
            loc_3d07c = loc_d0726.z == loc_e43d7.z;
        }
        else
        {
            loc_3d07c = loc_f5e38;
        }
        bool loc_ec124;
        if (loc_3d07c)
        {
            loc_ec124 = loc_d0726.w == loc_e43d7.w;
        }
        else
        {
            loc_ec124 = loc_3d07c;
        }
        loc_56442 = loc_ec124;
    }
    else
    {
        loc_56442 = loc_3002e;
    }
    bool loc_7df86;
    if (loc_56442)
    {
        highp vec4 loc_ce025 = var_e1398.zBiomeInfoBuffer[loc_16b81].waterSurfaceParameters;
        highp vec4 loc_0ec9a = var_e1398.zBiomeInfoBuffer[loc_16b81].waterSurfaceWaveParameters;
        highp vec4 loc_5db96 = var_e1398.zBiomeInfoBuffer[loc_16b81].waterSurfaceOctaveParameters;
        highp vec4 loc_0847f = var_e1398.zBiomeInfoBuffer[loc_970b0].waterSurfaceParameters;
        highp vec4 loc_09e9a = var_e1398.zBiomeInfoBuffer[loc_970b0].waterSurfaceWaveParameters;
        highp vec4 loc_fba83 = var_e1398.zBiomeInfoBuffer[loc_970b0].waterSurfaceOctaveParameters;
        bool loc_0a03f = loc_ce025.x == loc_0847f.x;
        bool loc_b5adf;
        if (loc_0a03f)
        {
            loc_b5adf = loc_ce025.y == loc_0847f.y;
        }
        else
        {
            loc_b5adf = loc_0a03f;
        }
        bool loc_6a5f4;
        if (loc_b5adf)
        {
            loc_6a5f4 = loc_ce025.z == loc_0847f.z;
        }
        else
        {
            loc_6a5f4 = loc_b5adf;
        }
        bool loc_6b57e;
        if (loc_6a5f4)
        {
            loc_6b57e = loc_0ec9a.x == loc_09e9a.x;
        }
        else
        {
            loc_6b57e = loc_6a5f4;
        }
        bool loc_424f8;
        if (loc_6b57e)
        {
            loc_424f8 = loc_0ec9a.y == loc_09e9a.y;
        }
        else
        {
            loc_424f8 = loc_6b57e;
        }
        bool loc_b3038;
        if (loc_424f8)
        {
            loc_b3038 = loc_5db96.x == loc_fba83.x;
        }
        else
        {
            loc_b3038 = loc_424f8;
        }
        bool loc_c98d1;
        if (loc_b3038)
        {
            loc_c98d1 = loc_5db96.y == loc_fba83.y;
        }
        else
        {
            loc_c98d1 = loc_b3038;
        }
        bool loc_685df;
        if (loc_c98d1)
        {
            loc_685df = loc_5db96.z == loc_fba83.z;
        }
        else
        {
            loc_685df = loc_c98d1;
        }
        bool loc_9bef1;
        if (loc_685df)
        {
            loc_9bef1 = loc_5db96.w == loc_fba83.w;
        }
        else
        {
            loc_9bef1 = loc_685df;
        }
        loc_7df86 = loc_9bef1;
    }
    else
    {
        loc_7df86 = loc_56442;
    }
    highp vec4 loc_855f6;
    highp vec4 loc_5e290;
    highp vec4 loc_2ffee;
    if (loc_7df86)
    {
        loc_2ffee = var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceParameters;
        loc_5e290 = var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceWaveParameters;
        loc_855f6 = var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceOctaveParameters;
    }
    else
    {
        highp vec4 loc_1ebe3 = loc_2f2a8;
        highp vec4 loc_e512d = loc_2f2a8;
        highp vec4 loc_f426e = loc_2f2a8;
        loc_2ffee = (((var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceParameters * loc_1ebe3.x) + (var_e1398.zBiomeInfoBuffer[loc_7c209].waterSurfaceParameters * loc_1ebe3.y)) + (var_e1398.zBiomeInfoBuffer[loc_16b81].waterSurfaceParameters * loc_1ebe3.z)) + (var_e1398.zBiomeInfoBuffer[loc_970b0].waterSurfaceParameters * loc_1ebe3.w);
        loc_5e290 = (((var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceWaveParameters * loc_e512d.x) + (var_e1398.zBiomeInfoBuffer[loc_7c209].waterSurfaceWaveParameters * loc_e512d.y)) + (var_e1398.zBiomeInfoBuffer[loc_16b81].waterSurfaceWaveParameters * loc_e512d.z)) + (var_e1398.zBiomeInfoBuffer[loc_970b0].waterSurfaceWaveParameters * loc_e512d.w);
        loc_855f6 = (((var_e1398.zBiomeInfoBuffer[loc_05a8c].waterSurfaceOctaveParameters * loc_f426e.x) + (var_e1398.zBiomeInfoBuffer[loc_7c209].waterSurfaceOctaveParameters * loc_f426e.y)) + (var_e1398.zBiomeInfoBuffer[loc_16b81].waterSurfaceOctaveParameters * loc_f426e.z)) + (var_e1398.zBiomeInfoBuffer[loc_970b0].waterSurfaceOctaveParameters * loc_f426e.w);
    }
    arg_3fac7 = loc_2ffee;
    arg_2f7bf = loc_5e290;
    arg_451b0 = loc_855f6;
}
void func_94180(inout highp float arg_27e9a, inout highp float arg_a66d0, inout highp float arg_5b991, inout highp float arg_85f79, inout highp float arg_62dbf, inout highp float arg_6c048, inout highp float arg_12931, inout highp float arg_89c42, inout highp float arg_5d066) {
    bool loc_a9f27;
    func_8ab59(loc_a9f27);
    if (loc_a9f27)
    {
        highp vec3 loc_418df = v_worldPos;
        highp vec4 loc_24013;
        highp vec4 loc_71f1d;
        highp vec4 loc_b5465;
        func_15a8f(loc_418df, loc_b5465, loc_71f1d, loc_24013);
        highp vec4 loc_b96be = loc_b5465;
        highp vec4 loc_2949f = loc_71f1d;
        highp vec4 loc_be428 = loc_24013;
        arg_27e9a = loc_b96be.x;
        arg_a66d0 = loc_b96be.y;
        arg_5b991 = loc_b96be.z;
        arg_85f79 = loc_2949f.x;
        arg_62dbf = loc_2949f.y;
        arg_6c048 = loc_be428.x;
        arg_12931 = loc_be428.y;
        arg_89c42 = loc_be428.z;
        arg_5d066 = loc_be428.w;
        return;
    }
    arg_27e9a = WaterSurfaceParameters.x;
    arg_a66d0 = WaterSurfaceParameters.y;
    arg_5b991 = WaterSurfaceParameters.z;
    arg_85f79 = WaterSurfaceWaveParameters.x;
    arg_62dbf = WaterSurfaceWaveParameters.y;
    arg_6c048 = WaterSurfaceOctaveParameters.x;
    arg_12931 = WaterSurfaceOctaveParameters.y;
    arg_89c42 = WaterSurfaceOctaveParameters.z;
    arg_5d066 = WaterSurfaceOctaveParameters.w;
}
void func_fb7ab(inout highp float arg_0840d, inout highp float arg_f7959, inout highp float arg_95241) {
    if (arg_0840d > arg_f7959)
    {
        arg_95241 = 0.501960813999176025390625 + (0.4980392158031463623046875 * arg_0840d);
        return;
    }
    else
    {
        arg_95241 = 0.4980392158031463623046875 - (0.4980392158031463623046875 * arg_f7959);
        return;
    }
}
void main() {
    highp vec3 var_b3851;
    highp float var_bd3b6;
    highp float var_bcdaf;
    highp float var_9b8bb;
    highp float var_5431f;
    func_9052b(var_5431f, var_9b8bb, var_bcdaf, var_bd3b6, var_b3851);
    highp float var_074a9;
    highp float var_0222e;
    highp float var_e7eec;
    highp float var_6c1ae;
    highp float var_7b985;
    highp float var_a6a44;
    highp float var_35d96;
    highp float var_a1ab3;
    highp float var_30ff1;
    func_94180(var_30ff1, var_a1ab3, var_35d96, var_a6a44, var_7b985, var_6c1ae, var_e7eec, var_0222e, var_074a9);
    highp vec3 var_ce339;
    if (WaterSurfaceEnabledAndExtinctionDistShift.x > 0.0)
    {
        highp float var_93df6 = ViewPositionAndTime.w * 0.5;
        highp vec2 var_dea28 = vec2(0.0);
        highp float var_1ba4d;
        highp vec2 var_16625;
        var_16625 = (v_worldPos - WorldOrigin.xyz).xz;
        var_1ba4d = 0.0;
        highp float var_ad209;
        highp vec2 var_5e840;
        highp float var_1f165;
        highp float var_308b8;
        highp float var_76a0b;
        highp float var_f2008;
        uint var_f415d = 0u;
        highp float var_726f4 = 0.0;
        highp float var_43afb = var_a6a44;
        highp float var_5b08b = var_30ff1;
        highp float var_2006b = 1.0;
        for (; var_f415d < uint(var_a1ab3); var_2006b = var_1f165, var_5b08b = var_308b8, var_16625 = var_5e840, var_43afb = var_76a0b, var_726f4 = var_f2008, var_1ba4d = var_ad209, var_f415d++)
        {
            highp vec2 var_f2d63 = vec2(sin(var_726f4), cos(var_726f4));
            highp float var_9fbcc = (dot(var_f2d63, var_16625) * var_5b08b) + (var_93df6 * var_43afb);
            highp float var_932f5 = cos(var_9fbcc);
            highp float var_e853a = sin(var_9fbcc);
            var_dea28 += ((((((((var_f2d63 * (-1.0)) * var_35d96) * var_2006b) * var_5b08b) * var_7b985) * var_932f5) * pow(0.5 * (var_e853a + 1.0), var_7b985)) * (1.0 / (var_e853a + 1.00010001659393310546875)));
            var_ad209 = var_1ba4d + var_2006b;
            var_5e840 = var_16625 + ((var_f2d63 * (((var_2006b * pow((var_e853a + 1.0) * 0.5, var_7b985)) * var_932f5) * (-1.0))) * var_6c1ae);
            var_1f165 = mix(var_2006b, 0.0, var_e7eec);
            var_308b8 = var_5b08b * var_0222e;
            var_76a0b = var_43afb * var_074a9;
            var_f2008 = var_726f4 + 1.39900004863739013671875;
        }
        var_dea28 /= vec2(var_1ba4d);
        var_ce339 = normalize(mix(v_normal, normalize(vec3(var_dea28.x, 1.0, var_dea28.y)), vec3(v_normal.y)));
    }
    else
    {
        var_ce339 = var_b3851;
    }
    highp vec4 var_e30b2 = vec4(texture(s_MatTexture, v_texcoord0).xyz, 1.0);
    highp vec2 var_f1ecf = v_lightmapUV;
    highp vec4 var_e74f1 = vec4(var_e30b2.x, var_e30b2.y, var_e30b2.z, var_e30b2.w);
    highp float var_7aa46;
    func_fb7ab(var_5431f, var_bd3b6, var_7aa46);
    var_e74f1.w = var_7aa46;
    highp vec3 var_089df = normalize(var_ce339);
    highp vec3 var_cd914 = var_089df;
    highp vec2 var_645ff = var_089df.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_72494;
    if (var_cd914.z < 0.0)
    {
        var_72494 = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_72494 = var_645ff;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_efb33 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_efb33;
    highp vec4 var_eaa92 = u_prevViewProj * vec4(v_worldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_eaa92;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_c94a9 = ((var_eaa92 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_c94a9;
    bgfx_FragData0 = var_e74f1;
    bgfx_FragData1 = vec4(var_72494, var_efb33.xy - var_c94a9.xy);
    bgfx_FragData2 = vec4(var_bcdaf, var_f1ecf.x, var_f1ecf.y, var_9b8bb);
}
