#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_AND_NORMAL_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - DO_WATER_EXTINCTION_PASS (not used)
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
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2D s_CausticsTexture;
* - layout(binding = 2, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - uniform lowp sampler2D s_LightMapTexture;
* - layout(binding = 4, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 6, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform highp sampler2DArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform lowp sampler2D s_SeasonsTexture;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
*
* Uniforms:
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 CascadeShadowResolutions;
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform mat4 DirectionalLightSourceCausticsViewProj[2];
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
* - uniform mat4 DirectionalLightSourceInvWaterSurfaceViewProj[2];
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
* - uniform mat4 DirectionalLightSourceWaterSurfaceViewProj[2];
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
* - uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex;
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
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowQuantizationParameters;
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

layout(binding = 6, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_0f32c;
layout(binding = 4, std430) buffer s_Lights { Light Lights[]; } var_5e4e9;
layout(binding = 2, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_a6966;
uniform highp mat4 CloudShadowProj;
uniform highp mat4 DirectionalLightSourceInvWaterSurfaceViewProj[2];
uniform highp mat4 DirectionalLightSourceShadowProj0[2];
uniform highp mat4 DirectionalLightSourceShadowProj1[2];
uniform highp mat4 DirectionalLightSourceShadowProj2[2];
uniform highp mat4 DirectionalLightSourceShadowProj3[2];
uniform highp mat4 DirectionalLightSourceWaterSurfaceViewProj[2];
uniform highp mat4 PlayerShadowProj;
uniform highp mat4 PointLightProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2DArray s_PointLightShadowTextureArray;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 CascadeShadowResolutions;
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ClusterNearFarWidthHeight;
uniform highp vec4 ClusterSize;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
uniform highp vec4 DirectionalLightSourceIsSun[2];
uniform highp vec4 DirectionalLightSourceShadowCascadeNumber[2];
uniform highp vec4 DirectionalLightSourceShadowDirection[2];
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection[2];
uniform highp vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
uniform highp vec4 DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex;
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
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightDiffuseFadeOutParameters;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 PointLightSpecularFadeOutParameters;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 ShadowBias;
uniform highp vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
uniform highp vec4 ShadowPCFWidth;
uniform highp vec4 ShadowQuantizationParameters;
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
uniform highp vec4 WaterExtinctionCoefficients;
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
    highp vec2 loc_59055 = vec2(var_0f32c.PBRData[v_pbrTextureId].colourToNormalUvScale0, var_0f32c.PBRData[v_pbrTextureId].colourToNormalUvScale1);
    highp vec2 loc_39ca3 = vec2(var_0f32c.PBRData[v_pbrTextureId].colourToNormalUvBias0, var_0f32c.PBRData[v_pbrTextureId].colourToNormalUvBias1);
    highp vec3 loc_b4ff6;
    if ((var_0f32c.PBRData[v_pbrTextureId].flags & 4) == 4)
    {
        loc_b4ff6 = (texture(s_MatTexture, (v_texcoord0 * loc_59055) + loc_39ca3).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 loc_9252d;
        if ((var_0f32c.PBRData[v_pbrTextureId].flags & 8) == 8)
        {
            highp vec2 loc_218fe = (v_texcoord0 * loc_59055) + loc_39ca3;
            highp vec3 loc_2ae5f = vec3(0.0, 0.0, 1.0);
            highp float loc_b88fd = clamp((min(var_0f32c.PBRData[v_pbrTextureId].maxMipNormal - var_0f32c.PBRData[v_pbrTextureId].maxMipColour, var_0f32c.PBRData[v_pbrTextureId].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
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
    if ((var_0f32c.PBRData[v_pbrTextureId].flags & 1) == 1)
    {
        highp vec4 loc_62c5e = texture(s_MatTexture, (v_texcoord0 * vec2(var_0f32c.PBRData[v_pbrTextureId].colourToMaterialUvScale0, var_0f32c.PBRData[v_pbrTextureId].colourToMaterialUvScale1)) + vec2(var_0f32c.PBRData[v_pbrTextureId].colourToMaterialUvBias0, var_0f32c.PBRData[v_pbrTextureId].colourToMaterialUvBias1));
        loc_00c14 = loc_62c5e.y;
        loc_659d6 = loc_62c5e.z;
    }
    else
    {
        loc_00c14 = var_0f32c.PBRData[v_pbrTextureId].uniformEmissive;
        loc_659d6 = var_0f32c.PBRData[v_pbrTextureId].uniformRoughness;
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
void func_e68ea(inout int arg_a1e9d, inout highp float arg_7a26d, inout int arg_24aec, inout highp vec4 arg_5b51a, inout highp float arg_e6df6) {
    if (arg_a1e9d < 0)
    {
        arg_7a26d = 1.0;
        return;
    }
    int loc_8118e = clamp(int(ShadowPCFWidth[arg_24aec] + 0.5), 1, 9);
    int loc_d6315 = loc_8118e / 2;
    highp vec2 loc_de8d2 = ((vec2(arg_5b51a.x, arg_5b51a.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions[arg_24aec];
    highp float loc_aa6c4 = (arg_5b51a.z * 0.5) + 0.5;
    loc_de8d2.y += (1.0 - CascadeShadowResolutions[arg_24aec]);
    highp float loc_9af5f;
    loc_9af5f = 0.0;
    highp float loc_1a54a;
    for (int loc_04d9d = 0; loc_04d9d < loc_8118e; loc_9af5f = loc_1a54a, loc_04d9d++)
    {
        loc_1a54a = loc_9af5f;
        highp float loc_8e08a;
        for (int loc_96608 = 0; loc_96608 < loc_8118e; loc_1a54a = loc_8e08a, loc_96608++)
        {
            highp vec3 loc_4515f = vec3(loc_de8d2 + ((vec2(float(loc_96608 - loc_d6315) + 0.5, float(loc_04d9d - loc_d6315) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSize.x) * CascadeShadowResolutions[arg_24aec]), (float(arg_a1e9d) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w) + float(arg_24aec));
            highp vec4 loc_28934 = textureGather(s_ShadowCascades, loc_4515f);
            highp vec4 loc_bbed9 = loc_28934;
            if (ShadowQuantizationParameters.x != 0.0)
            {
                loc_8e08a = loc_1a54a + float(loc_bbed9.w >= (loc_aa6c4 - arg_e6df6));
            }
            else
            {
                highp vec4 loc_27ff4 = step(vec4(loc_aa6c4 - arg_e6df6), loc_28934);
                highp vec2 loc_b1a62 = fract((loc_4515f.xy * ShadowFilterOffsetAndRangeFarAndMapSize.z) + vec2(0.5));
                loc_8e08a = loc_1a54a + mix(mix(loc_27ff4.w, loc_27ff4.z, loc_b1a62.x), mix(loc_27ff4.x, loc_27ff4.y, loc_b1a62.x), loc_b1a62.y);
            }
        }
    }
    arg_7a26d = loc_9af5f / float(loc_8118e * loc_8118e);
}
void func_7a524(inout highp vec3 arg_3a8bb, inout highp float arg_e038b, inout highp float arg_5a4a1) {
    highp vec4 loc_57cee = PlayerShadowProj * vec4(arg_3a8bb, 1.0);
    loc_57cee.z -= (ShadowBias.x + (ShadowSlopeBias.x * clamp(tan(acos(arg_e038b)), 0.0, 1.0)));
    loc_57cee.z = min(loc_57cee.z, 1.0);
    highp vec2 loc_f5a38 = ((vec2(loc_57cee.x, loc_57cee.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    loc_57cee.z = (loc_57cee.z * 0.5) + 0.5;
    loc_f5a38.y += (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    bool loc_2c837 = loc_f5a38.x >= 0.0;
    bool loc_d06e3;
    if (loc_2c837)
    {
        loc_d06e3 = loc_f5a38.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_d06e3 = loc_2c837;
    }
    bool loc_c7ec9;
    if (loc_d06e3)
    {
        loc_c7ec9 = loc_f5a38.y >= (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    }
    else
    {
        loc_c7ec9 = loc_d06e3;
    }
    bool loc_8e2b9;
    if (loc_c7ec9)
    {
        loc_8e2b9 = loc_f5a38.y < 1.0;
    }
    else
    {
        loc_8e2b9 = loc_c7ec9;
    }
    if (!loc_8e2b9)
    {
        arg_5a4a1 = 1.0;
        return;
    }
    highp float loc_fb589;
    loc_fb589 = 0.0;
    highp float loc_d6abd;
    for (int loc_92f2a = 0; loc_92f2a < 2; loc_fb589 = loc_d6abd, loc_92f2a++)
    {
        loc_d6abd = loc_fb589;
        highp float loc_78ad8;
        for (int loc_cca52 = 0; loc_cca52 < 2; loc_d6abd = loc_78ad8, loc_cca52++)
        {
            highp vec2 loc_3bfb1 = loc_f5a38 + ((vec2(float(loc_cca52 - 1) + 0.5, float(loc_92f2a - 1) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            highp vec3 loc_82357 = vec3(loc_3bfb1.x, loc_3bfb1.y, (DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0) + 1.0);
            if (ShadowQuantizationParameters.x != 0.0)
            {
                loc_78ad8 = loc_d6abd + float(textureLod(s_ShadowCascades, loc_82357, 0.0).x >= loc_57cee.z);
            }
            else
            {
                highp vec4 loc_1f2f1 = step(vec4(loc_57cee.z), textureGather(s_ShadowCascades, loc_82357));
                highp vec2 loc_b1a62 = fract((loc_82357.xy * ShadowFilterOffsetAndRangeFarAndMapSize.z) + vec2(0.5));
                loc_78ad8 = loc_d6abd + mix(mix(loc_1f2f1.w, loc_1f2f1.z, loc_b1a62.x), mix(loc_1f2f1.x, loc_1f2f1.y, loc_b1a62.x), loc_b1a62.y);
            }
        }
    }
    arg_5a4a1 = loc_fb589 * 0.25;
}
void func_d8106(inout highp vec2 arg_0a99f, inout highp vec3 arg_534d1, inout highp vec3 arg_69e1b, inout highp vec3 arg_abe00, inout highp vec3 arg_444d3, inout highp float arg_2bc6f, inout highp vec2 arg_b27b9) {
    highp vec3 loc_4b287;
    if (ShadowQuantizationParameters.y > 0.0)
    {
        highp vec3 loc_23ca2 = v_worldPos - WorldOrigin.xyz;
        highp vec3 loc_da281 = normalize(cross(normalize(dFdx(loc_23ca2)), normalize(dFdy(loc_23ca2))));
        highp vec3 loc_754df = mod(loc_23ca2, vec3(ShadowQuantizationParameters.z));
        loc_4b287 = v_worldPos - (loc_754df - (loc_da281 * dot(loc_754df, loc_da281)));
    }
    else
    {
        loc_4b287 = v_worldPos;
    }
    if (abs(arg_0a99f.y) < 9.9999997473787516355514526367188e-05)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    int loc_bf766 = int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.y);
    highp vec3 loc_47ab9;
    loc_47ab9 = vec3(0.0);
    highp vec3 loc_dd391;
    for (int loc_0db85 = 0; loc_0db85 < loc_bf766; loc_47ab9 = loc_dd391, loc_0db85++)
    {
        highp float loc_71956;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            highp float loc_955a9 = max(dot(arg_69e1b, normalize((u_view * DirectionalLightSourceShadowDirection[loc_0db85]).xyz)), 0.0);
            int loc_66a53;
            highp vec4 loc_b57a6;
            func_cb3cb(loc_0db85, loc_4b287, loc_b57a6, loc_66a53);
            highp vec4 loc_b19db = loc_b57a6;
            highp float loc_8766b;
            if (loc_66a53 != (-1))
            {
                highp float loc_0ed3d = ShadowBias[loc_66a53] + (ShadowSlopeBias[loc_66a53] * clamp(tan(acos(loc_955a9)), 0.0, 1.0));
                int loc_be19b = int(DirectionalLightSourceShadowCascadeNumber[loc_0db85].x);
                highp float loc_222e2;
                func_e68ea(loc_be19b, loc_222e2, loc_66a53, loc_b19db, loc_0ed3d);
                highp float loc_ad256;
                if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
                {
                    highp float loc_93efa;
                    func_7a524(loc_4b287, loc_955a9, loc_93efa);
                    loc_ad256 = min(loc_222e2, loc_93efa);
                }
                else
                {
                    loc_ad256 = loc_222e2;
                }
                bool loc_5d7ab = int(DirectionalLightSourceIsSun[loc_0db85].x) > 0;
                bool loc_643a4;
                if (loc_5d7ab)
                {
                    loc_643a4 = int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.y) > 0;
                }
                else
                {
                    loc_643a4 = loc_5d7ab;
                }
                highp float loc_e4c4c;
                if (loc_643a4)
                {
                    highp vec4 loc_1a6df = CloudShadowProj * vec4(loc_4b287, 1.0);
                    highp vec4 loc_09c0a = loc_1a6df;
                    loc_09c0a = loc_1a6df / vec4(loc_09c0a.w);
                    loc_09c0a.z -= ((ShadowBias.x + (ShadowSlopeBias.x * clamp(tan(acos(loc_955a9)), 0.0, 1.0))) / loc_09c0a.w);
                    highp vec2 loc_74cbe = ((vec2(loc_09c0a.x, loc_09c0a.y) * 0.5) + vec2(0.5)) * CascadeShadowResolutions.x;
                    int loc_b64c0 = clamp(int(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z + 0.5), 1, 9);
                    int loc_ed3d9 = loc_b64c0 / 2;
                    loc_09c0a.z = (loc_09c0a.z * 0.5) + 0.5;
                    loc_74cbe.y += (1.0 - CascadeShadowResolutions.x);
                    highp float loc_ac935;
                    loc_ac935 = 0.0;
                    highp float loc_6f800;
                    for (int loc_96ac8 = 0; loc_96ac8 < loc_b64c0; loc_ac935 = loc_6f800, loc_96ac8++)
                    {
                        loc_6f800 = loc_ac935;
                        highp float loc_91ddf;
                        for (int loc_75999 = 0; loc_75999 < loc_b64c0; loc_6f800 = loc_91ddf, loc_75999++)
                        {
                            highp vec3 loc_5cc81 = vec3(loc_74cbe + ((vec2(float(loc_75999 - loc_ed3d9) + 0.5, float(loc_96ac8 - loc_ed3d9) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSize.x) * CascadeShadowResolutions.x), DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w * 2.0);
                            if (ShadowQuantizationParameters.x != 0.0)
                            {
                                loc_91ddf = loc_6f800 + float(textureLod(s_ShadowCascades, loc_5cc81, 0.0).x >= loc_09c0a.z);
                            }
                            else
                            {
                                highp vec4 loc_ef698 = step(vec4(loc_09c0a.z), textureGather(s_ShadowCascades, loc_5cc81));
                                highp vec2 loc_fa89d = fract((loc_5cc81.xy * ShadowFilterOffsetAndRangeFarAndMapSize.z) + vec2(0.5));
                                loc_91ddf = loc_6f800 + mix(mix(loc_ef698.w, loc_ef698.z, loc_fa89d.x), mix(loc_ef698.x, loc_ef698.y, loc_fa89d.x), loc_fa89d.y);
                            }
                        }
                    }
                    highp float loc_e0cb0 = loc_ac935 / float(loc_b64c0 * loc_b64c0);
                    highp float loc_3715f;
                    if (loc_e0cb0 < 1.0)
                    {
                        loc_3715f = min(loc_ad256, max(loc_e0cb0, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                    }
                    else
                    {
                        loc_3715f = loc_ad256;
                    }
                    loc_e4c4c = loc_3715f;
                }
                else
                {
                    loc_e4c4c = loc_ad256;
                }
                loc_8766b = mix(loc_e4c4c, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSize.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSize.y, -arg_abe00.z));
            }
            else
            {
                loc_8766b = 1.0;
            }
            loc_71956 = loc_8766b;
        }
        else
        {
            loc_71956 = 1.0;
        }
        highp vec3 loc_a08f2;
        if (DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.x != 0.0)
        {
            int loc_1db61 = int(DirectionalLightSourceShadowCascadeNumber[loc_0db85].x);
            highp float loc_a3c1d;
            if (loc_1db61 >= 0)
            {
                highp vec4 loc_4a6c4 = DirectionalLightSourceWaterSurfaceViewProj[loc_0db85] * vec4(v_worldPos, 1.0);
                highp vec4 loc_f5c51 = loc_4a6c4;
                highp vec3 loc_18955 = loc_4a6c4.xyz / vec3(loc_f5c51.w);
                highp vec3 loc_14f1d = loc_18955;
                highp vec4 loc_fed43 = DirectionalLightSourceWaterSurfaceViewProj[loc_0db85] * vec4(v_worldPos, 1.0);
                highp vec4 loc_7aafc = loc_fed43;
                highp vec3 loc_b2964 = loc_fed43.xyz / vec3(loc_7aafc.w);
                loc_b2964.y *= (-1.0);
                highp vec2 loc_e2892 = (loc_b2964.xy + vec2(1.0)) * 0.5;
                highp float loc_c3fee = loc_e2892.x;
                highp float loc_f8aea = loc_e2892.y;
                highp float loc_f8be2 = 1.0 - loc_f8aea;
                loc_e2892 = vec2(loc_c3fee, loc_f8be2);
                highp vec4 loc_b2d02 = texture(s_ShadowCascades, vec3(loc_c3fee, loc_f8be2, float((loc_1db61 * int(DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.w)) + int(DirectionalLightWaterExtinctionEnabledAndWaterDepthMapCascadeIndex.y))));
                highp float loc_838c1 = (loc_b2d02.x * 2.0) - 1.0;
                highp float loc_08f0c;
                if (loc_14f1d.z > loc_838c1)
                {
                    loc_08f0c = length((DirectionalLightSourceInvWaterSurfaceViewProj[loc_0db85] * vec4(loc_18955.xy, loc_838c1, 1.0)).xyz - v_worldPos);
                }
                else
                {
                    loc_08f0c = 0.0;
                }
                loc_a3c1d = loc_08f0c;
            }
            else
            {
                loc_a3c1d = 0.0;
            }
            loc_a08f2 = exp((-WaterExtinctionCoefficients.xyz) * loc_a3c1d);
        }
        else
        {
            loc_a08f2 = vec3(1.0);
        }
        highp vec3 loc_af162 = normalize((u_view * DirectionalLightSourceWorldSpaceDirection[loc_0db85]).xyz);
        highp vec4 loc_4251b = DirectionalLightSourceDiffuseColorAndIlluminance[loc_0db85];
        highp float loc_b849b = max(dot(arg_69e1b, loc_af162), 0.0);
        highp float loc_d3488 = max(dot(arg_69e1b, arg_444d3), 0.0);
        highp vec3 loc_2fff8 = normalize(loc_af162 + arg_444d3);
        highp float loc_a68f1 = arg_2bc6f * arg_2bc6f;
        highp float loc_24123 = loc_a68f1 * loc_a68f1;
        highp float loc_87b4a = max(dot(arg_69e1b, loc_2fff8), 0.0);
        highp float loc_ed5c3 = max((((loc_24123 - 1.0) * loc_87b4a) * loc_87b4a) + 1.0, 9.9999997473787516355514526367188e-05);
        highp float loc_7a8a4 = loc_a68f1 * 0.5;
        loc_dd391 = loc_47ab9 + ((((((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * pow(clamp(1.0 - max(dot(arg_444d3, loc_2fff8), 0.0), 0.0, 1.0), 5.0))) * (loc_24123 / ((loc_ed5c3 * loc_ed5c3) * 3.1415927410125732421875))) * ((loc_d3488 / (((loc_d3488 * (1.0 - loc_7a8a4)) + loc_7a8a4) + 9.9999997473787516355514526367188e-05)) * (loc_b849b / (((loc_b849b * (1.0 - loc_7a8a4)) + loc_7a8a4) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_b849b) * loc_d3488) + 9.9999997473787516355514526367188e-05)) * loc_b849b) * loc_71956) * ((((DirectionalLightSourceDiffuseColorAndIlluminance[loc_0db85].xyz * loc_4251b.w) * loc_a08f2) * arg_b27b9[loc_0db85]) * DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight.x)) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_534d1 = loc_47ab9;
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
void func_aed09(inout int arg_3cd09, inout highp float arg_28e67, inout highp vec3 arg_214f6) {
    if (var_5e4e9.Lights[arg_3cd09].shadowProbeIndex < 0)
    {
        arg_28e67 = 1.0;
        return;
    }
    highp vec3 loc_3566a = v_worldPos - var_5e4e9.Lights[arg_3cd09].position.xyz;
    highp vec3 loc_27555 = loc_3566a;
    highp vec3 loc_f4d64 = abs(loc_3566a);
    highp vec3 loc_5836b = vec3(0.0);
    bool loc_ab77c = loc_f4d64.x >= loc_f4d64.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_f4d64.x >= loc_f4d64.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    if (loc_ca7f9)
    {
        loc_f4d64 = vec3(loc_f4d64.y, loc_f4d64.z, loc_f4d64.x);
        if (loc_27555.x > 0.0)
        {
            highp vec3 loc_c810d = ((loc_3566a * (1.0 / loc_3566a.x)) * 0.5) + vec3(0.5);
            loc_5836b = vec3(1.0 - loc_c810d.z, loc_c810d.y, 0.0);
        }
        else
        {
            highp vec3 loc_3d32b = ((loc_3566a * (1.0 / dot(loc_3566a, vec3(-1.0, 0.0, 0.0)))) * 0.5) + vec3(0.5);
            loc_5836b = vec3(loc_3d32b.z, loc_3d32b.y, 1.0);
        }
    }
    else
    {
        if (loc_f4d64.y >= loc_f4d64.z)
        {
            loc_f4d64 = vec3(loc_f4d64.x, loc_f4d64.z, loc_f4d64.y);
            if (loc_27555.y > 0.0)
            {
                highp vec3 loc_1939e = ((loc_3566a * (1.0 / loc_3566a.y)) * 0.5) + vec3(0.5);
                loc_5836b = vec3(loc_1939e.x, 1.0 - loc_1939e.z, 2.0);
            }
            else
            {
                highp vec3 loc_9f7b3 = ((loc_3566a * (1.0 / dot(loc_3566a, vec3(0.0, -1.0, 0.0)))) * 0.5) + vec3(0.5);
                loc_5836b = vec3(loc_9f7b3.x, loc_9f7b3.z, 3.0);
            }
        }
        else
        {
            if (loc_27555.z > 0.0)
            {
                highp vec3 loc_0db9f = ((loc_3566a * (1.0 / loc_3566a.z)) * 0.5) + vec3(0.5);
                loc_5836b = vec3(loc_0db9f.x, loc_0db9f.y, 4.0);
            }
            else
            {
                highp vec3 loc_2f24d = ((loc_3566a * (1.0 / dot(loc_3566a, vec3(0.0, 0.0, -1.0)))) * 0.5) + vec3(0.5);
                loc_5836b = vec3(1.0 - loc_2f24d.x, loc_2f24d.y, 5.0);
            }
        }
    }
    loc_f4d64.z *= (-1.0);
    highp vec4 loc_eae4d = PointLightProj * vec4(loc_f4d64, 1.0);
    loc_eae4d.z += (PointLightShadowParams1.x + (PointLightShadowParams1.y * clamp(tan(acos(dot(-normalize(loc_3566a), arg_214f6))), 0.0, 1.0)));
    loc_eae4d /= vec4(loc_eae4d.w);
    highp float loc_b74da;
    loc_b74da = 0.0;
    highp float loc_f6f3d;
    for (int loc_1139b = 0; loc_1139b < 4; loc_b74da = loc_f6f3d, loc_1139b++)
    {
        loc_f6f3d = loc_b74da;
        highp float loc_bbf51;
        for (int loc_79fcd = 0; loc_79fcd < 4; loc_f6f3d = loc_bbf51, loc_79fcd++)
        {
            highp vec2 loc_46de9 = vec2(float(loc_79fcd - 2) + 0.5, float(loc_1139b - 2) + 0.5) * PointLightShadowParams1.w;
            highp vec3 loc_f67d5 = vec3(loc_5836b.x + loc_46de9.x, (1.0 - loc_5836b.y) + loc_46de9.y, loc_5836b.z);
            highp vec3 loc_95a76 = loc_f67d5;
            highp vec3 loc_0f2c0 = loc_f67d5;
            if (loc_95a76.y > 1.0)
            {
                switch (int(loc_95a76.z))
                {
                    case 0:
                    {
                        loc_0f2c0.z = 3.0;
                        loc_0f2c0.x = 2.0 - loc_95a76.y;
                        loc_0f2c0.y = loc_95a76.x;
                        break;
                    }
                    case 1:
                    {
                        loc_0f2c0.z = 3.0;
                        loc_0f2c0.x = loc_95a76.y - 1.0;
                        loc_0f2c0.y = 1.0 - loc_95a76.x;
                        break;
                    }
                    case 2:
                    {
                        loc_0f2c0.z = 4.0;
                        loc_0f2c0.x = loc_95a76.x;
                        loc_0f2c0.y = loc_95a76.y - 1.0;
                        break;
                    }
                    case 3:
                    {
                        loc_0f2c0.z = 5.0;
                        loc_0f2c0.x = 1.0 - loc_95a76.x;
                        loc_0f2c0.y = 2.0 - loc_95a76.y;
                        break;
                    }
                    case 4:
                    {
                        loc_0f2c0.z = 3.0;
                        loc_0f2c0.x = loc_95a76.x;
                        loc_0f2c0.y = loc_95a76.y - 1.0;
                        break;
                    }
                    case 5:
                    {
                        loc_0f2c0.z = 3.0;
                        loc_0f2c0.x = 1.0 - loc_95a76.x;
                        loc_0f2c0.y = 2.0 - loc_95a76.y;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            else
            {
                if (loc_95a76.y < 0.0)
                {
                    switch (int(loc_95a76.z))
                    {
                        case 0:
                        {
                            loc_0f2c0.z = 2.0;
                            loc_0f2c0.x = 1.0 + loc_95a76.y;
                            loc_0f2c0.y = 1.0 - loc_95a76.x;
                            break;
                        }
                        case 1:
                        {
                            loc_0f2c0.z = 2.0;
                            loc_0f2c0.x = -loc_95a76.y;
                            loc_0f2c0.y = loc_95a76.x;
                            break;
                        }
                        case 2:
                        {
                            loc_0f2c0.z = 5.0;
                            loc_0f2c0.x = 1.0 - loc_95a76.x;
                            loc_0f2c0.y = -loc_95a76.y;
                            break;
                        }
                        case 3:
                        {
                            loc_0f2c0.z = 4.0;
                            loc_0f2c0.x = loc_95a76.x;
                            loc_0f2c0.y = 1.0 + loc_95a76.y;
                            break;
                        }
                        case 4:
                        {
                            loc_0f2c0.z = 2.0;
                            loc_0f2c0.x = loc_95a76.x;
                            loc_0f2c0.y = 1.0 + loc_95a76.y;
                            break;
                        }
                        case 5:
                        {
                            loc_0f2c0.z = 2.0;
                            loc_0f2c0.x = 1.0 - loc_95a76.x;
                            loc_0f2c0.y = -loc_95a76.y;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            highp vec2 loc_cbdd0 = loc_0f2c0.xy;
            if (loc_cbdd0.x > 1.0)
            {
                switch (int(loc_0f2c0.z))
                {
                    case 0:
                    {
                        loc_0f2c0.z = 5.0;
                        loc_0f2c0.x = loc_cbdd0.x - 1.0;
                        loc_0f2c0.y = loc_cbdd0.y;
                        break;
                    }
                    case 1:
                    {
                        loc_0f2c0.z = 4.0;
                        loc_0f2c0.x = loc_cbdd0.x - 1.0;
                        loc_0f2c0.y = loc_cbdd0.y;
                        break;
                    }
                    case 2:
                    {
                        loc_0f2c0.z = 0.0;
                        loc_0f2c0.x = 1.0 - loc_cbdd0.y;
                        loc_0f2c0.y = loc_cbdd0.x - 1.0;
                        break;
                    }
                    case 3:
                    {
                        loc_0f2c0.z = 0.0;
                        loc_0f2c0.x = loc_cbdd0.y;
                        loc_0f2c0.y = 2.0 - loc_cbdd0.x;
                        break;
                    }
                    case 4:
                    {
                        loc_0f2c0.z = 0.0;
                        loc_0f2c0.x = loc_cbdd0.x - 1.0;
                        loc_0f2c0.y = loc_cbdd0.y;
                        break;
                    }
                    case 5:
                    {
                        loc_0f2c0.z = 1.0;
                        loc_0f2c0.x = loc_cbdd0.x - 1.0;
                        loc_0f2c0.y = loc_cbdd0.y;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            else
            {
                if (loc_cbdd0.x < 0.0)
                {
                    switch (int(loc_0f2c0.z))
                    {
                        case 0:
                        {
                            loc_0f2c0.z = 4.0;
                            loc_0f2c0.x = 1.0 + loc_cbdd0.x;
                            loc_0f2c0.y = loc_cbdd0.y;
                            break;
                        }
                        case 1:
                        {
                            loc_0f2c0.z = 5.0;
                            loc_0f2c0.x = 1.0 + loc_cbdd0.x;
                            loc_0f2c0.y = loc_cbdd0.y;
                            break;
                        }
                        case 2:
                        {
                            loc_0f2c0.z = 1.0;
                            loc_0f2c0.x = loc_cbdd0.y;
                            loc_0f2c0.y = -loc_cbdd0.x;
                            break;
                        }
                        case 3:
                        {
                            loc_0f2c0.z = 1.0;
                            loc_0f2c0.x = 1.0 - loc_cbdd0.y;
                            loc_0f2c0.y = 1.0 + loc_cbdd0.x;
                            break;
                        }
                        case 4:
                        {
                            loc_0f2c0.z = 1.0;
                            loc_0f2c0.x = 1.0 + loc_cbdd0.x;
                            loc_0f2c0.y = loc_cbdd0.y;
                            break;
                        }
                        case 5:
                        {
                            loc_0f2c0.z = 0.0;
                            loc_0f2c0.x = 1.0 + loc_cbdd0.x;
                            loc_0f2c0.y = loc_cbdd0.y;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            highp vec3 loc_0a47c = loc_0f2c0;
            loc_0a47c.z = float(var_5e4e9.Lights[arg_3cd09].shadowProbeIndex * 6) + loc_0a47c.z;
            highp vec4 loc_185e5 = step(vec4(loc_eae4d.z), textureGather(s_PointLightShadowTextureArray, loc_0a47c));
            highp vec2 loc_b16bc = fract((loc_0a47c.xy * (1.0 / (PointLightShadowParams1.w + 9.9999997473787516355514526367188e-05))) + vec2(0.5));
            loc_bbf51 = loc_f6f3d + mix(mix(loc_185e5.w, loc_185e5.z, loc_b16bc.x), mix(loc_185e5.x, loc_185e5.y, loc_b16bc.x), loc_b16bc.y);
        }
    }
    arg_28e67 = loc_b74da * 0.0624996125698089599609375;
}
void func_3059c(inout int arg_72344, inout highp vec3 arg_62394, inout highp vec3 arg_154f5) {
    if (arg_72344 < 0)
    {
        arg_62394 = vec3(0.0);
        return;
    }
    highp vec3 loc_569de = var_5e4e9.Lights[arg_72344].position.xyz - v_worldPos;
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
    if (loc_7ba4c >= (var_5e4e9.Lights[arg_72344].position.w * var_5e4e9.Lights[arg_72344].position.w))
    {
        arg_62394 = vec3(0.0);
        return;
    }
    highp float loc_33ea0;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_144ad;
        func_aed09(arg_72344, loc_144ad, arg_154f5);
        loc_33ea0 = loc_144ad;
    }
    else
    {
        loc_33ea0 = 1.0;
    }
    if (loc_33ea0 <= 0.0)
    {
        arg_62394 = vec3(0.0);
        return;
    }
    highp float loc_fd676 = loc_7ba4c / ((var_5e4e9.Lights[arg_72344].position.w * var_5e4e9.Lights[arg_72344].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_fcfce = clamp(1.0 - (loc_fd676 * loc_fd676), 0.0, 1.0);
    highp float loc_e1ff6 = (1.0 / max(loc_7ba4c, 9.9999997473787516355514526367188e-05)) * (loc_fcfce * loc_fcfce);
    highp float loc_9ab96;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_9ab96 = loc_e1ff6 * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_e1ff6) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_9ab96 = loc_e1ff6;
    }
    arg_62394 = (((var_5e4e9.Lights[arg_72344].color.xyz * var_5e4e9.Lights[arg_72344].color.w) * loc_9ab96) * loc_33ea0) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_7aa29(inout bool arg_9a2b4, inout bool arg_b6724, inout highp vec3 arg_3289d, inout highp vec3 arg_dc0ef, inout highp vec3 arg_96daa, inout highp vec3 arg_89c41, inout highp vec3 arg_c5372, inout highp vec3 arg_1a729, inout highp float arg_e730a, inout highp vec3 arg_154f5) {
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
    highp vec3 loc_70008;
    loc_70008 = vec3(0.0);
    highp vec3 loc_855d3;
    for (int loc_bee0c = loc_9b40b; loc_bee0c < loc_fbf40; loc_70008 = loc_855d3, loc_bee0c++)
    {
        int loc_3da7e = int(var_a6966.LightLookupArray[loc_bee0c].lookup);
        if (loc_3da7e < 0)
        {
            break;
        }
        highp vec3 loc_b6fc4 = normalize((u_view * vec4(var_5e4e9.Lights[loc_3da7e].position.xyz, 1.0)).xyz - arg_89c41);
        highp vec3 loc_b2ace;
        if (arg_b6724)
        {
            highp vec3 loc_0661d;
            if (arg_9a2b4)
            {
                highp float loc_e0c4c = max(dot(arg_c5372, loc_b6fc4), 0.0);
                highp float loc_5743b = max(dot(arg_c5372, arg_1a729), 0.0);
                highp vec3 loc_e9cd8 = normalize(loc_b6fc4 + arg_1a729);
                highp float loc_59789 = arg_e730a * arg_e730a;
                highp float loc_440bc = loc_59789 * loc_59789;
                highp float loc_5d7aa = max(dot(arg_c5372, loc_e9cd8), 0.0);
                highp float loc_0067e = max((((loc_440bc - 1.0) * loc_5d7aa) * loc_5d7aa) + 1.0, 9.9999997473787516355514526367188e-05);
                highp float loc_83f9a = loc_59789 * 0.5;
                loc_0661d = ((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * pow(clamp(1.0 - max(dot(arg_1a729, loc_e9cd8), 0.0), 0.0, 1.0), 5.0))) * (loc_440bc / ((loc_0067e * loc_0067e) * 3.1415927410125732421875))) * ((loc_5743b / (((loc_5743b * (1.0 - loc_83f9a)) + loc_83f9a) + 9.9999997473787516355514526367188e-05)) * (loc_e0c4c / (((loc_e0c4c * (1.0 - loc_83f9a)) + loc_83f9a) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_e0c4c) * loc_5743b) + 9.9999997473787516355514526367188e-05)) * loc_e0c4c;
            }
            else
            {
                loc_0661d = vec3(0.0);
            }
            loc_b2ace = loc_0661d;
        }
        else
        {
            highp vec3 loc_3c265;
            if (arg_9a2b4)
            {
                highp float loc_69cf2 = max(dot(arg_c5372, loc_b6fc4), 0.0);
                highp float loc_1c302 = max(dot(arg_c5372, arg_1a729), 0.0);
                highp vec3 loc_ab5af = normalize(loc_b6fc4 + arg_1a729);
                highp float loc_22daf = arg_e730a * arg_e730a;
                highp float loc_8720a = loc_22daf * loc_22daf;
                highp float loc_d294e = max(dot(arg_c5372, loc_ab5af), 0.0);
                highp float loc_d633b = max((((loc_8720a - 1.0) * loc_d294e) * loc_d294e) + 1.0, 9.9999997473787516355514526367188e-05);
                highp float loc_7fba9 = loc_22daf * 0.5;
                loc_3c265 = ((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * pow(clamp(1.0 - max(dot(arg_1a729, loc_ab5af), 0.0), 0.0, 1.0), 5.0))) * (loc_8720a / ((loc_d633b * loc_d633b) * 3.1415927410125732421875))) * ((loc_1c302 / (((loc_1c302 * (1.0 - loc_7fba9)) + loc_7fba9) + 9.9999997473787516355514526367188e-05)) * (loc_69cf2 / (((loc_69cf2 * (1.0 - loc_7fba9)) + loc_7fba9) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_69cf2) * loc_1c302) + 9.9999997473787516355514526367188e-05)) * loc_69cf2;
            }
            else
            {
                loc_3c265 = vec3(0.0);
            }
            loc_b2ace = loc_3c265;
        }
        highp vec3 loc_a0542;
        func_3059c(loc_3da7e, loc_a0542, arg_154f5);
        loc_855d3 = loc_70008 + ((loc_b2ace * loc_a0542) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    arg_3289d = loc_70008;
}
void main() {
    int var_679de = int(gl_FrontFacing);
    highp vec2 var_c016f = v_lightmapUV;
    highp vec3 var_562d7 = normalize(-normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz));
    highp vec3 var_b5f17;
    highp float var_a8b30;
    highp float var_c0b68;
    func_afe0b(var_c0b68, var_a8b30, var_b5f17, var_679de);
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
    highp vec3 var_699ea;
    if (var_679de > 0)
    {
        var_699ea = -var_2ab3a;
    }
    else
    {
        var_699ea = var_2ab3a;
    }
    highp vec4 var_83731 = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_b8928 = var_83731;
    highp vec3 var_5709d = var_83731.xyz / vec3(var_b8928.w);
    highp vec3 var_2313e = (u_view * vec4(v_worldPos, 1.0)).xyz;
    highp vec3 var_ef458 = (u_view * vec4(var_699ea, 1.0)).xyz;
    highp vec3 var_edfc0 = var_2313e;
    highp vec3 var_5bd0a = var_5709d;
    highp vec3 var_811e1 = var_2313e;
    highp float var_7639d;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        var_7639d = (abs(var_811e1.x) + abs(var_811e1.y)) + abs(var_811e1.z);
    }
    else
    {
        var_7639d = length(var_2313e);
    }
    bool var_464cb = PointLightSpecularFadeOutParameters.x > 0.0;
    highp float var_5d160;
    if (var_464cb)
    {
        var_5d160 = smoothstep(PointLightSpecularFadeOutParameters.x, PointLightSpecularFadeOutParameters.y, var_7639d);
    }
    else
    {
        var_5d160 = 0.0;
    }
    bool var_49ba4 = !var_464cb;
    bool var_6a834;
    if (!var_49ba4)
    {
        var_6a834 = var_464cb && (var_7639d < PointLightSpecularFadeOutParameters.y);
    }
    else
    {
        var_6a834 = var_49ba4;
    }
    bool var_6ebf5 = PointLightDiffuseFadeOutParameters.x > 0.0;
    bool var_70859 = !var_6ebf5;
    bool var_b5b12;
    if (!var_70859)
    {
        var_b5b12 = var_6ebf5 && (var_7639d < PointLightDiffuseFadeOutParameters.y);
    }
    else
    {
        var_b5b12 = var_70859;
    }
    highp vec3 var_e4ba3 = -(var_2313e / vec3(length(var_2313e) + 9.9999997473787516355514526367188e-05));
    highp vec3 var_b9e11;
    if (var_5bd0a.z != 1.0)
    {
        highp vec2 var_5d689 = vec2(0.0);
        highp vec3 var_de9aa;
        func_d8106(var_c016f, var_de9aa, var_ef458, var_edfc0, var_e4ba3, var_c0b68, var_5d689);
        highp vec3 var_2f4a9 = var_2313e;
        highp vec3 var_678d4;
        func_7aa29(var_6a834, var_b5b12, var_678d4, var_2f4a9, var_5709d, var_2313e, var_ef458, var_e4ba3, var_c0b68, var_699ea);
        var_b9e11 = var_de9aa + (var_678d4 * (1.0 - var_5d160));
    }
    else
    {
        var_b9e11 = vec3(0.0);
    }
    highp vec4 var_bfc24 = vec4(0.0, 0.0, 0.0, 1.0);
    highp vec4 var_c17ec = SkyAmbientLightColorIntensity;
    highp float var_9f3c7 = var_c016f.x * var_c016f.x;
    highp vec3 var_a7a4e = ((((vec3(0.0199999995529651641845703125) + (vec3(0.980000019073486328125) * pow(clamp(1.0 - max(dot(var_562d7, var_699ea), 0.0), 0.0, 1.0), 5.0))) * (1.0 - (pow(clamp(((var_c016f.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0), 3.0) * IBLParameters.x))) * max(((clamp(vec3(var_9f3c7 + (var_bfc24.x * var_bfc24.w), (var_9f3c7 * ((((var_9f3c7 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_bfc24.y * var_bfc24.w), (var_9f3c7 * (((var_9f3c7 * var_9f3c7) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_bfc24.z * var_bfc24.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * 1.0) + ((SkyAmbientLightColorIntensity.xyz * pow(var_c016f.y, mix(5.0, 3.0, CameraLightIntensity.y))) * var_c17ec.w), vec3(0.02999999932944774627685546875))) + var_b9e11) + (((mix(vec3(0.0), vec3(0.0), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_a8b30)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x);
    highp float var_cfc7d = length(v_worldPos);
    highp vec3 var_77240 = -var_562d7;
    highp vec3 var_7e3dc;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_3de5f = clamp((((var_cfc7d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_cb5ed;
        if (var_3de5f > 0.0)
        {
            highp vec3 var_a6488;
            if (!(AtmosphericScatteringToggles.y != 0.0))
            {
                var_a6488 = FogColor.xyz;
            }
            else
            {
                highp vec4 var_da187 = SunColor;
                highp vec4 var_9cde9 = MoonColor;
                highp vec3 var_e3755 = var_77240;
                highp float var_7b136 = FogSkyBlend.x - FogSkyBlend.w;
                highp float var_d7734 = smoothstep(FogSkyBlend.y, var_7b136, var_e3755.y);
                highp float var_3c557 = smoothstep(FogSkyBlend.z - FogSkyBlend.w, var_7b136, var_e3755.y);
                highp float var_50871 = dot(var_77240, SunDir.xyz);
                highp float var_ae018 = dot(var_77240, MoonDir.xyz);
                highp float var_5301e = 0.5 * (var_50871 + 1.0);
                highp float var_9a714 = 0.5 * (var_ae018 + 1.0);
                highp float var_4e792 = clamp(pow(max(var_50871, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                highp float var_72556 = clamp(pow(max(var_ae018, 0.0), AtmosphericScattering.w), 0.0, 1.0);
                var_a6488 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3(clamp((var_d7734 * var_d7734) * var_d7734, 0.0, 1.0))) * AtmosphericScattering.x) * 0.0596831031143665313720703125) * (((var_5301e * var_5301e) * var_da187.w) + ((var_9a714 * var_9a714) * var_9cde9.w))) + (((SkyHorizonColor.xyz * clamp((var_3c557 * var_3c557) * var_3c557, 0.0, 1.0)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_da187.w) * AtmosphericScattering.y) * var_4e792) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_4e792 * 1.7999999523162841796875), 1.5))) + ((((MoonColor.xyz * var_9cde9.w) * AtmosphericScattering.z) * var_72556) * (0.0361000001430511474609375 / pow(1.809999942779541015625 - (var_72556 * 1.7999999523162841796875), 1.5)))));
            }
            var_cb5ed = mix(var_a7a4e, var_a6488, vec3(var_3de5f));
        }
        else
        {
            var_cb5ed = var_a7a4e;
        }
        var_7e3dc = var_cb5ed;
    }
    else
    {
        var_7e3dc = mix(var_a7a4e, FogColor.xyz, vec3(clamp((((var_cfc7d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0)));
    }
    highp vec3 var_94e72;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_5709d.xy + vec2(1.0)) * 0.5;
        highp vec4 var_92c8f = u_invProj * vec4(var_5709d, 1.0);
        highp float var_b4ccc = var_7d045.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_b4ccc, var_7d045.y, log((53.598148345947265625 * ((((-var_92c8f.z) / var_92c8f.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_eb2d5 = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_5363d = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        highp vec4 var_67b96 = var_5363d;
        var_94e72 = var_5363d.xyz + (var_7e3dc * var_67b96.w);
    }
    else
    {
        var_94e72 = var_7e3dc;
    }
    highp float var_c6288;
    if (var_679de > 0)
    {
        highp float var_9af11;
        if (max(dot(var_699ea, refract(normalize(normalize(v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)), -var_699ea, 1.3329999446868896484375)), 0.0) > 0.0)
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
        var_5e1c8 = var_94e72 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_5e1c8 = var_94e72;
    }
    bgfx_FragData[0] = vec4(var_5e1c8.x, var_5e1c8.y, var_5e1c8.z, vec4(var_abd4d, var_abd4d, var_abd4d, var_c6288).w);
}
