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

layout(binding = 6, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_47313;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MatTexture;
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
void func_a72a6(inout highp float arg_6a625, inout highp float arg_9eee0, inout highp float arg_a50e1, inout highp float arg_d2a5b, inout highp vec3 arg_51e76) {
    if (v_pbrTextureId == 65535)
    {
        arg_6a625 = 0.0;
        arg_9eee0 = 1.0;
        arg_a50e1 = 0.0;
        arg_d2a5b = 0.0;
        arg_51e76 = vec3(0.0, 1.0, 0.0);
        return;
    }
    highp vec2 loc_59055 = vec2(var_47313.PBRData[v_pbrTextureId].colourToNormalUvScale0, var_47313.PBRData[v_pbrTextureId].colourToNormalUvScale1);
    highp vec2 loc_39ca3 = vec2(var_47313.PBRData[v_pbrTextureId].colourToNormalUvBias0, var_47313.PBRData[v_pbrTextureId].colourToNormalUvBias1);
    highp vec3 loc_b4ff6;
    if ((var_47313.PBRData[v_pbrTextureId].flags & 4) == 4)
    {
        loc_b4ff6 = (texture(s_MatTexture, (v_texcoord0 * loc_59055) + loc_39ca3).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 loc_9252d;
        if ((var_47313.PBRData[v_pbrTextureId].flags & 8) == 8)
        {
            highp vec2 loc_218fe = (v_texcoord0 * loc_59055) + loc_39ca3;
            highp vec3 loc_2ae5f = vec3(0.0, 0.0, 1.0);
            highp float loc_b88fd = clamp((min(var_47313.PBRData[v_pbrTextureId].maxMipNormal - var_47313.PBRData[v_pbrTextureId].maxMipColour, var_47313.PBRData[v_pbrTextureId].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
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
    highp float loc_73c14;
    highp float loc_00c14;
    highp float loc_d7d8a;
    if ((var_47313.PBRData[v_pbrTextureId].flags & 1) == 1)
    {
        highp vec4 loc_300fb = texture(s_MatTexture, (v_texcoord0 * vec2(var_47313.PBRData[v_pbrTextureId].colourToMaterialUvScale0, var_47313.PBRData[v_pbrTextureId].colourToMaterialUvScale1)) + vec2(var_47313.PBRData[v_pbrTextureId].colourToMaterialUvBias0, var_47313.PBRData[v_pbrTextureId].colourToMaterialUvBias1));
        highp float loc_c4db1;
        if ((var_47313.PBRData[v_pbrTextureId].flags & 2) == 2)
        {
            loc_c4db1 = loc_300fb.w;
        }
        else
        {
            loc_c4db1 = var_47313.PBRData[v_pbrTextureId].uniformSubsurface;
        }
        loc_d7d8a = loc_c4db1;
        loc_00c14 = loc_300fb.y;
        loc_73c14 = loc_300fb.x;
        loc_659d6 = loc_300fb.z;
    }
    else
    {
        loc_d7d8a = var_47313.PBRData[v_pbrTextureId].uniformSubsurface;
        loc_00c14 = var_47313.PBRData[v_pbrTextureId].uniformEmissive;
        loc_73c14 = var_47313.PBRData[v_pbrTextureId].uniformMetalness;
        loc_659d6 = var_47313.PBRData[v_pbrTextureId].uniformRoughness;
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
    func_a72a6(var_5431f, var_0e0cd, var_8ed44, var_bd3b6, var_b3851);
    highp vec3 var_f75be;
    if (WaterSurfaceEnabled.x > 0.0)
    {
        highp float var_3037b = ViewPositionAndTime.w * 0.5;
        highp vec2 var_e9692 = (v_worldPos - WorldOrigin.xyz).xz;
        highp vec2 var_3f96c = var_e9692;
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
        highp vec3 var_17739 = vec3(var_3f96c.x, (var_62111 / var_1a358) * WaterSurfaceParameters.z, var_3f96c.y);
        highp float var_bf0bb;
        highp float var_6cef1;
        highp vec2 var_c2935;
        var_c2935 = var_e9692 - vec2(WaterSurfaceParameters.w, 0.0);
        var_6cef1 = 0.0;
        var_bf0bb = 0.0;
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
        for (; var_2ca1d < uint(WaterSurfaceParameters.y); var_563a6 = var_9ca59, var_b4368 = var_6df95, var_c2935 = var_1b55e, var_3441d = var_15226, var_01a31 = var_633fd, var_6cef1 = var_a3722, var_bf0bb = var_0303e, var_2ca1d++)
        {
            highp vec2 var_1c18a = vec2(sin(var_01a31), cos(var_01a31));
            highp float var_99be2 = (dot(var_1c18a, var_c2935) * var_b4368) + (var_3037b * var_3441d);
            highp float var_056e0 = pow((sin(var_99be2) + 1.0) * 0.5, WaterSurfaceWaveParameters.y);
            highp vec2 var_03816 = vec2(var_056e0, (var_056e0 * cos(var_99be2)) * (-1.0));
            var_0303e = var_bf0bb + (var_03816.x * var_563a6);
            var_a3722 = var_6cef1 + var_563a6;
            var_1b55e = var_c2935 + (((var_1c18a * var_03816.y) * var_563a6) * WaterSurfaceOctaveParameters.x);
            var_9ca59 = mix(var_563a6, 0.0, WaterSurfaceOctaveParameters.y);
            var_6df95 = var_b4368 * WaterSurfaceOctaveParameters.z;
            var_15226 = var_3441d * WaterSurfaceOctaveParameters.w;
            var_633fd = var_01a31 + 1.39900004863739013671875;
        }
        highp float var_29438;
        highp float var_2cc45;
        highp vec2 var_e6e11;
        var_e6e11 = var_e9692 + vec2(0.0, WaterSurfaceParameters.w);
        var_2cc45 = 0.0;
        var_29438 = 0.0;
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
        for (; var_392e0 < uint(WaterSurfaceParameters.y); var_47b45 = var_c3808, var_9e727 = var_203ec, var_e6e11 = var_f4997, var_e2c14 = var_40c87, var_b733c = var_9d271, var_2cc45 = var_fb35b, var_29438 = var_c5940, var_392e0++)
        {
            highp vec2 var_4a483 = vec2(sin(var_b733c), cos(var_b733c));
            highp float var_1996d = (dot(var_4a483, var_e6e11) * var_9e727) + (var_3037b * var_e2c14);
            highp float var_2db20 = pow((sin(var_1996d) + 1.0) * 0.5, WaterSurfaceWaveParameters.y);
            highp vec2 var_d4af9 = vec2(var_2db20, (var_2db20 * cos(var_1996d)) * (-1.0));
            var_c5940 = var_29438 + (var_d4af9.x * var_47b45);
            var_fb35b = var_2cc45 + var_47b45;
            var_f4997 = var_e6e11 + (((var_4a483 * var_d4af9.y) * var_47b45) * WaterSurfaceOctaveParameters.x);
            var_c3808 = mix(var_47b45, 0.0, WaterSurfaceOctaveParameters.y);
            var_203ec = var_9e727 * WaterSurfaceOctaveParameters.z;
            var_40c87 = var_e2c14 * WaterSurfaceOctaveParameters.w;
            var_9d271 = var_b733c + 1.39900004863739013671875;
        }
        var_f75be = normalize(mix(v_normal, normalize(cross(var_17739 - vec3(var_3f96c.x - WaterSurfaceParameters.w, (var_bf0bb / var_6cef1) * WaterSurfaceParameters.z, var_3f96c.y), var_17739 - vec3(var_3f96c.x, (var_29438 / var_2cc45) * WaterSurfaceParameters.z, var_3f96c.y + WaterSurfaceParameters.w))), vec3(v_normal.y)));
    }
    else
    {
        var_f75be = var_b3851;
    }
    highp vec4 var_e30b2 = vec4(texture(s_MatTexture, v_texcoord0).xyz, 1.0);
    highp vec2 var_ea830 = v_lightmapUV;
    highp vec4 var_6de71 = vec4(var_e30b2.x, var_e30b2.y, var_e30b2.z, var_e30b2.w);
    highp float var_7aa46;
    func_fb7ab(var_5431f, var_bd3b6, var_7aa46);
    var_6de71.w = var_7aa46;
    highp vec3 var_089df = normalize(var_f75be);
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
