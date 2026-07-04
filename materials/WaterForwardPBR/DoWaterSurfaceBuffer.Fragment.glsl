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

layout(binding = 5, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_19767;
layout(binding = 13, std430) buffer s_zBiomeInfoBuffer { BiomeInfo zBiomeInfoBuffer[]; } var_06448;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_BiomeBlendingMap;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 BiomeBlendingLastUpdatePosition;
uniform highp vec4 BiomeBlendingParameters;
uniform highp vec4 ViewPositionAndTime;
uniform highp vec4 WaterSurfaceEnabled;
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
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
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
    highp vec2 loc_5c197 = vec2(var_19767.PBRData[v_pbrTextureId].colourToNormalUvScale0, var_19767.PBRData[v_pbrTextureId].colourToNormalUvScale1);
    highp vec2 loc_3ee66 = vec2(var_19767.PBRData[v_pbrTextureId].colourToNormalUvBias0, var_19767.PBRData[v_pbrTextureId].colourToNormalUvBias1);
    highp vec3 loc_c8345;
    if ((var_19767.PBRData[v_pbrTextureId].flags & 4) == 4)
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
        if ((var_19767.PBRData[v_pbrTextureId].flags & 8) == 8)
        {
            highp vec2 loc_218fe = (v_texcoord0 * loc_5c197) + loc_3ee66;
            highp vec3 loc_2ae5f = vec3(0.0, 0.0, 1.0);
            highp float loc_b88fd = clamp((min(var_19767.PBRData[v_pbrTextureId].maxMipNormal - var_19767.PBRData[v_pbrTextureId].maxMipColour, var_19767.PBRData[v_pbrTextureId].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
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
    if ((var_19767.PBRData[v_pbrTextureId].flags & 1) == 1)
    {
        highp vec4 loc_300fb = texture(s_MatTexture, (v_texcoord0 * vec2(var_19767.PBRData[v_pbrTextureId].colourToMaterialUvScale0, var_19767.PBRData[v_pbrTextureId].colourToMaterialUvScale1)) + vec2(var_19767.PBRData[v_pbrTextureId].colourToMaterialUvBias0, var_19767.PBRData[v_pbrTextureId].colourToMaterialUvBias1));
        highp float loc_c4db1;
        if ((var_19767.PBRData[v_pbrTextureId].flags & 2) == 2)
        {
            loc_c4db1 = loc_300fb.w;
        }
        else
        {
            loc_c4db1 = var_19767.PBRData[v_pbrTextureId].uniformSubsurface;
        }
        loc_d7d8a = loc_c4db1;
        loc_00c14 = loc_300fb.y;
        loc_73c14 = loc_300fb.x;
        loc_659d6 = loc_300fb.z;
    }
    else
    {
        loc_d7d8a = var_19767.PBRData[v_pbrTextureId].uniformSubsurface;
        loc_00c14 = var_19767.PBRData[v_pbrTextureId].uniformEmissive;
        loc_73c14 = var_19767.PBRData[v_pbrTextureId].uniformMetalness;
        loc_659d6 = var_19767.PBRData[v_pbrTextureId].uniformRoughness;
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
    highp float var_8ed44;
    highp float var_0e0cd;
    highp float var_5431f;
    func_9052b(var_5431f, var_0e0cd, var_8ed44, var_bd3b6, var_b3851);
    highp float var_84772;
    highp float var_afa04;
    highp float var_32de0;
    highp float var_50295;
    highp float var_13f6b;
    highp float var_e5452;
    highp float var_c9298;
    highp float var_63531;
    highp float var_28912;
    highp float var_7fae3;
    func_20c38(var_7fae3, var_28912, var_63531, var_c9298, var_e5452, var_13f6b, var_50295, var_32de0, var_afa04, var_84772);
    highp vec3 var_1343e;
    if (WaterSurfaceEnabled.x > 0.0)
    {
        highp float var_3037b = ViewPositionAndTime.w * 0.5;
        highp vec2 var_db8aa = (v_worldPos - WorldOrigin.xyz).xz;
        highp vec2 var_17fa3 = var_db8aa;
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
        highp vec3 var_47405 = vec3(var_17fa3.x, (var_82f84 / var_af08e) * var_63531, var_17fa3.y);
        highp float var_2b4ee;
        highp float var_38c87;
        highp vec2 var_cbc38;
        var_cbc38 = var_db8aa - vec2(var_c9298, 0.0);
        var_38c87 = 0.0;
        var_2b4ee = 0.0;
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
        for (; var_a50de < uint(var_28912); var_f78b2 = var_acbf1, var_671a8 = var_5712c, var_cbc38 = var_c361b, var_d7ca3 = var_c8f66, var_07f85 = var_e0c56, var_38c87 = var_c3e6b, var_2b4ee = var_6090e, var_a50de++)
        {
            highp vec2 var_547d9 = vec2(sin(var_07f85), cos(var_07f85));
            highp float var_0051f = (dot(var_547d9, var_cbc38) * var_671a8) + (var_3037b * var_d7ca3);
            highp float var_83598 = pow((sin(var_0051f) + 1.0) * 0.5, var_13f6b);
            highp vec2 var_3ef36 = vec2(var_83598, (var_83598 * cos(var_0051f)) * (-1.0));
            var_6090e = var_2b4ee + (var_3ef36.x * var_f78b2);
            var_c3e6b = var_38c87 + var_f78b2;
            var_c361b = var_cbc38 + (((var_547d9 * var_3ef36.y) * var_f78b2) * var_50295);
            var_acbf1 = mix(var_f78b2, 0.0, var_32de0);
            var_5712c = var_671a8 * var_afa04;
            var_c8f66 = var_d7ca3 * var_84772;
            var_e0c56 = var_07f85 + 1.39900004863739013671875;
        }
        highp float var_9f652;
        highp float var_1f9c0;
        highp vec2 var_0cccf;
        var_0cccf = var_db8aa + vec2(0.0, var_c9298);
        var_1f9c0 = 0.0;
        var_9f652 = 0.0;
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
        for (; var_afc8f < uint(var_28912); var_3e15d = var_8f034, var_21493 = var_6e9d6, var_0cccf = var_a6b58, var_6a7fe = var_94331, var_4a2b4 = var_f1ae6, var_1f9c0 = var_d5aed, var_9f652 = var_19150, var_afc8f++)
        {
            highp vec2 var_beff8 = vec2(sin(var_4a2b4), cos(var_4a2b4));
            highp float var_ae2ba = (dot(var_beff8, var_0cccf) * var_21493) + (var_3037b * var_6a7fe);
            highp float var_74e08 = pow((sin(var_ae2ba) + 1.0) * 0.5, var_13f6b);
            highp vec2 var_f90b3 = vec2(var_74e08, (var_74e08 * cos(var_ae2ba)) * (-1.0));
            var_19150 = var_9f652 + (var_f90b3.x * var_3e15d);
            var_d5aed = var_1f9c0 + var_3e15d;
            var_a6b58 = var_0cccf + (((var_beff8 * var_f90b3.y) * var_3e15d) * var_50295);
            var_8f034 = mix(var_3e15d, 0.0, var_32de0);
            var_6e9d6 = var_21493 * var_afa04;
            var_94331 = var_6a7fe * var_84772;
            var_f1ae6 = var_4a2b4 + 1.39900004863739013671875;
        }
        var_1343e = normalize(mix(v_normal, normalize(cross(var_47405 - vec3(var_17fa3.x - var_c9298, (var_2b4ee / var_38c87) * var_63531, var_17fa3.y), var_47405 - vec3(var_17fa3.x, (var_9f652 / var_1f9c0) * var_63531, var_17fa3.y + var_c9298))), vec3(v_normal.y)));
    }
    else
    {
        var_1343e = var_b3851;
    }
    highp vec4 var_e30b2 = vec4(texture(s_MatTexture, v_texcoord0).xyz, 1.0);
    highp vec2 var_ea830 = v_lightmapUV;
    highp vec4 var_6de71 = vec4(var_e30b2.x, var_e30b2.y, var_e30b2.z, var_e30b2.w);
    highp float var_7aa46;
    func_fb7ab(var_5431f, var_bd3b6, var_7aa46);
    var_6de71.w = var_7aa46;
    highp vec3 var_089df = normalize(var_1343e);
    highp vec3 var_cd914 = var_089df;
    highp vec2 var_645ff = var_089df.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_5a694;
    if (var_cd914.z < 0.0)
    {
        var_5a694 = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_5a694 = var_645ff;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_7ed87 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_7ed87;
    highp vec4 var_eaa92 = u_prevViewProj * vec4(v_worldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_eaa92;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_82203 = ((var_eaa92 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_82203;
    highp vec2 var_ec5a5 = var_7ed87.xy - var_82203.xy;
    bgfx_FragData[0] = var_6de71;
    bgfx_FragData[1] = vec4(var_5a694.x, var_5a694.y, var_ec5a5.x, var_ec5a5.y);
    bgfx_FragData[2] = vec4(var_8ed44, var_ea830.x, var_ea830.y, var_0e0cd);
}
