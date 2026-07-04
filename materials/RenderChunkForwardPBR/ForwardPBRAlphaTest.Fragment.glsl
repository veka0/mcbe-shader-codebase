#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - FORWARD_PBR_ALPHA_TEST_PASS (not used)
* - FORWARD_PBR_OPAQUE_PASS (not used)
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
*
* Dithering:
* - DITHERING__OFF
* - DITHERING__ON
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF
* - POINT_LIGHT_SHADING__ON
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
* - uniform lowp sampler2D s_LightMapTexture;
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 10, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform lowp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SeasonsTexture;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 11, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 12, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
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
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
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
* - uniform mat4 PointLightInvProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform vec4 PointLightPreCalcValues;
* - uniform mat4 PointLightProj;
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

#ifdef POINT_LIGHT_SHADING__ON
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

int var_e7b23;
#endif
#ifdef DITHERING__ON
float var_2f370;
#endif
layout(binding = 10, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_bb228;
#ifdef POINT_LIGHT_SHADING__ON
layout(binding = 12, std430) buffer s_zLights { Light zLights[]; } var_53c75;
layout(binding = 11, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_dfd7f;
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
#ifdef POINT_LIGHT_SHADING__ON
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
#endif
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScattering;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
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
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalLightSkyLightHeuristicToggles;
uniform highp vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform highp vec4 DirectionalLightSourceShadowDirection;
uniform highp vec4 DirectionalLightSourceWorldSpaceDirection;
uniform highp vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
#ifdef DITHERING__ON
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
#endif
uniform highp vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform highp vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 FogColor;
uniform highp vec4 FogSkyBlend;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 LastSpecularIBLIdx;
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
uniform highp vec4 UndergroundFogColor;
#ifdef DITHERING__ON
uniform highp vec4 ViewPositionAndTime;
#endif
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WorldOrigin;
in highp vec3 v_bitangent;
#ifdef DITHERING__ON
in highp vec4 v_clipPosition;
#endif
in highp vec4 v_color0;
#if defined(DITHERING__ON) || defined(SEASONS__OFF)
in highp vec2 v_ditheringAndMaskTinting;
#endif
in highp vec3 v_lightColor;
in highp vec2 v_lightmapUV;
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
void func_6546f(inout highp float arg_6a625, inout highp float arg_9eee0, inout highp float arg_a50e1, inout highp float arg_d2a5b, inout highp vec3 arg_51e76) {
    if (v_pbrTextureId == 65535)
    {
        arg_6a625 = 0.0;
        arg_9eee0 = 1.0;
        arg_a50e1 = 0.0;
        arg_d2a5b = 0.0;
        arg_51e76 = vec3(0.0, 1.0, 0.0);
        return;
    }
    highp vec2 loc_59055 = vec2(var_bb228.PBRData[v_pbrTextureId].colourToNormalUvScale0, var_bb228.PBRData[v_pbrTextureId].colourToNormalUvScale1);
    highp vec2 loc_39ca3 = vec2(var_bb228.PBRData[v_pbrTextureId].colourToNormalUvBias0, var_bb228.PBRData[v_pbrTextureId].colourToNormalUvBias1);
    highp vec3 loc_b4ff6;
    if ((var_bb228.PBRData[v_pbrTextureId].flags & 4) == 4)
    {
        loc_b4ff6 = (texture(s_MatTexture, (v_texcoord0 * loc_59055) + loc_39ca3).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 loc_9252d;
        if ((var_bb228.PBRData[v_pbrTextureId].flags & 8) == 8)
        {
            highp vec2 loc_32eb7 = (v_texcoord0 * loc_59055) + loc_39ca3;
            highp vec3 loc_850fe = vec3(0.0, 0.0, 1.0);
            highp float loc_b88fd = clamp((min(var_bb228.PBRData[v_pbrTextureId].maxMipNormal - var_bb228.PBRData[v_pbrTextureId].maxMipColour, var_bb228.PBRData[v_pbrTextureId].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
            if (loc_b88fd > 0.0)
            {
                highp vec4 loc_798a3 = textureLod(s_MatTexture, loc_32eb7, 0.0);
                highp vec2 loc_4d034 = fract(loc_32eb7 * vec2(textureSize(s_MatTexture, 0)));
                loc_850fe.x = (step(0.916666686534881591796875, loc_4d034.x) * ((loc_798a3.y * 2.0) - 1.0)) + (step(loc_4d034.x, 0.083333335816860198974609375) * (1.0 - (loc_798a3.w * 2.0)));
                loc_850fe.y = (step(0.916666686534881591796875, loc_4d034.y) * ((loc_798a3.z * 2.0) - 1.0)) + (step(loc_4d034.y, 0.083333335816860198974609375) * (1.0 - (loc_798a3.x * 2.0)));
                loc_850fe.x = step(0.004999999888241291046142578125, abs(loc_850fe.x)) * loc_850fe.x;
                loc_850fe.y = step(0.004999999888241291046142578125, abs(loc_850fe.y)) * loc_850fe.y;
                loc_850fe.z = 0.25;
                highp vec3 loc_1cc05 = normalize(loc_850fe);
                highp vec2 loc_8557e = loc_1cc05.xy * loc_b88fd;
                loc_850fe = vec3(loc_8557e.x, loc_8557e.y, loc_1cc05.z);
            }
            loc_9252d = loc_850fe;
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
    if ((var_bb228.PBRData[v_pbrTextureId].flags & 1) == 1)
    {
        highp vec4 loc_300fb = texture(s_MatTexture, (v_texcoord0 * vec2(var_bb228.PBRData[v_pbrTextureId].colourToMaterialUvScale0, var_bb228.PBRData[v_pbrTextureId].colourToMaterialUvScale1)) + vec2(var_bb228.PBRData[v_pbrTextureId].colourToMaterialUvBias0, var_bb228.PBRData[v_pbrTextureId].colourToMaterialUvBias1));
        highp float loc_c4db1;
        if ((var_bb228.PBRData[v_pbrTextureId].flags & 2) == 2)
        {
            loc_c4db1 = loc_300fb.w;
        }
        else
        {
            loc_c4db1 = var_bb228.PBRData[v_pbrTextureId].uniformSubsurface;
        }
        loc_d7d8a = loc_c4db1;
        loc_00c14 = loc_300fb.y;
        loc_73c14 = loc_300fb.x;
        loc_659d6 = loc_300fb.z;
    }
    else
    {
        loc_d7d8a = var_bb228.PBRData[v_pbrTextureId].uniformSubsurface;
        loc_00c14 = var_bb228.PBRData[v_pbrTextureId].uniformEmissive;
        loc_73c14 = var_bb228.PBRData[v_pbrTextureId].uniformMetalness;
        loc_659d6 = var_bb228.PBRData[v_pbrTextureId].uniformRoughness;
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
void func_6c485(inout highp vec2 arg_ea738, inout highp vec3 arg_87514, inout highp vec3 arg_c03dc, inout highp vec3 arg_58fab, inout highp vec3 arg_adf73, inout highp vec3 arg_c100b, inout highp vec3 arg_ae81a, inout highp float arg_485b3, inout highp vec3 arg_c7286, inout highp float arg_e0484, inout highp vec3 arg_08b90, inout highp vec3 arg_bcfb6, inout highp float arg_b14d8, inout highp float arg_67b92) {
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
    highp vec4 loc_85a44 = DirectionalLightSourceDiffuseColorAndIlluminance;
    highp vec3 loc_08df4 = ((DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_85a44.w) * arg_485b3) * DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight.x;
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
    arg_87514 = ((((((vec3(1.0) - loc_00b7f) * mix(loc_947b2, max((dot(arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_d8782 * loc_d8782), 0.0), arg_67b92)) * (loc_82e5e * vec3(0.3183098733425140380859375))) * loc_0f714) + (((loc_82e5e * vec3(0.3183098733425140380859375)) * (arg_67b92 * max((dot(-arg_58fab, loc_52f44) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_65d74 * loc_65d74), 0.0))) * loc_f89fe)) * loc_08df4) * DiffuseSpecularEmissiveAmbientTermToggles.x;
    arg_c03dc = ((((((loc_00b7f * (loc_3da81 / ((loc_c16ab * loc_c16ab) * 3.1415927410125732421875))) * ((loc_fefd5 / (((loc_fefd5 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)) * (loc_947b2 / (((loc_947b2 * (1.0 - loc_4fd72)) + loc_4fd72) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_947b2) * loc_fefd5) + 9.9999997473787516355514526367188e-05)) * loc_947b2) * loc_0f714) * loc_08df4) * DiffuseSpecularEmissiveAmbientTermToggles.y;
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
void func_bbb6d(inout int arg_826b5, inout highp float arg_9eee0, inout highp float arg_6b488, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c, inout highp float arg_77c90) {
    if (var_53c75.zLights[arg_826b5].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        arg_6b488 = 1.0;
        return;
    }
    highp vec3 loc_44ea9 = arg_aee55 - var_53c75.zLights[arg_826b5].position.xyz;
    highp vec3 loc_0b3e9 = abs(loc_44ea9);
    bool loc_ab77c = loc_0b3e9.x >= loc_0b3e9.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_0b3e9.x >= loc_0b3e9.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    if (loc_ca7f9)
    {
        loc_0b3e9 = vec3(loc_0b3e9.y, loc_0b3e9.z, loc_0b3e9.x);
    }
    else
    {
        if (loc_0b3e9.y >= loc_0b3e9.z)
        {
            loc_0b3e9 = vec3(loc_0b3e9.x, loc_0b3e9.z, loc_0b3e9.y);
        }
    }
    highp vec4 loc_6114a = PointLightProj * vec4(loc_0b3e9, 1.0);
    highp float loc_2f407 = clamp(dot(normalize(-loc_44ea9), normalize(arg_1111c)), PointLightNdLFloor.x, 1.0);
    loc_6114a.z -= (PointLightShadowParams1.x + (PointLightShadowParams1.y * (sqrt(1.0 - (loc_2f407 * loc_2f407)) / loc_2f407)));
    loc_6114a /= vec4(loc_6114a.w);
    highp vec3 loc_f715f = loc_44ea9;
    bool loc_fe444 = abs(loc_f715f.y) > abs(loc_f715f.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_f715f.y) > abs(loc_f715f.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_f715f.z *= (-1.0);
    }
    else
    {
        loc_f715f.y *= (-1.0);
    }
    highp float loc_e670f = (textureLod(s_PointLightShadowTextureArray, vec4(loc_f715f, float(var_53c75.zLights[arg_826b5].shadowProbeIndex)), 0.0).x * 2.0) - 1.0;
    highp float loc_591c8;
    if (loc_e670f >= loc_6114a.z)
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
        highp vec4 loc_932a9 = PointLightInvProj * vec4(loc_6114a.xy, loc_e670f, 1.0);
        highp vec4 loc_85f94 = loc_932a9;
        highp float loc_0585d = loc_85f94.w;
        highp vec3 loc_6d5dc = loc_932a9.xyz / vec3(loc_0585d);
        loc_85f94 = vec4(loc_6d5dc.x, loc_6d5dc.y, loc_6d5dc.z, loc_932a9.w);
        loc_d7fd8 = 1.0 - smoothstep(0.0, 1.0, (length(loc_0b3e9) - length(loc_6d5dc.xyz)) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.z);
    }
    else
    {
        loc_d7fd8 = 1.0;
    }
    arg_9eee0 = loc_d7fd8;
    arg_6b488 = loc_591c8;
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
    highp vec3 loc_a4b3e = var_53c75.zLights[arg_9327a].position.xyz - v_worldPos;
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
    if (loc_9eb1a >= (var_53c75.zLights[arg_9327a].position.w * var_53c75.zLights[arg_9327a].position.w))
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
        func_bbb6d(arg_9327a, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_a011d = loc_b2a04;
        loc_cddfe = loc_412fd;
    }
    else
    {
        loc_a011d = 1.0;
        loc_cddfe = 1.0;
    }
    highp float loc_4c5a5 = loc_9eb1a / ((var_53c75.zLights[arg_9327a].position.w * var_53c75.zLights[arg_9327a].position.w) + 9.9999997473787516355514526367188e-05);
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
        highp vec3 loc_8226d = var_53c75.zLights[arg_9327a].color.xyz * loc_219c5;
        arg_e84ec = vec4(loc_8226d.x, loc_8226d.y, loc_8226d.z, arg_e84ec.w);
        arg_e84ec.w = 1.0 - (loc_9eb1a / ((var_53c75.zLights[arg_9327a].position.w * var_53c75.zLights[arg_9327a].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_0a2b9 = (var_53c75.zLights[arg_9327a].color.xyz * var_53c75.zLights[arg_9327a].color.w) * loc_219c5;
}
void func_8c92a(inout highp vec3 arg_33c3b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec4 arg_fadf1, inout highp vec3 arg_efe4b, inout highp vec3 arg_81f79, inout highp float arg_d565c, inout highp vec3 arg_58ffc, inout highp vec3 arg_cff01, inout highp float arg_5416d, inout highp vec3 arg_5a8cd, inout highp vec3 arg_4fa31, inout highp float arg_9502a) {
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
        int loc_4d5d9 = int(var_dfd7f.zLightLookupArray[loc_86630].lookup);
        if (loc_4d5d9 < 0)
        {
            break;
        }
        highp vec3 loc_ed90f = normalize((u_view * vec4(var_53c75.zLights[loc_4d5d9].position.xyz, 1.0)).xyz - arg_33c3b);
        highp float loc_1e1bf = max(dot(arg_efe4b, loc_ed90f), 0.0);
        highp float loc_af6fd = max(dot(arg_efe4b, arg_81f79), 0.0);
        highp float loc_2d61b = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp float loc_c20a0 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp vec3 loc_a125f = normalize(loc_ed90f + arg_81f79);
        highp float loc_a4858 = max(arg_d565c, 0.0500000007450580596923828125);
        highp float loc_a68f1 = loc_a4858 * loc_a4858;
        highp float loc_ad517 = loc_a68f1 * loc_a68f1;
        highp float loc_cd10e = max(dot(arg_efe4b, loc_a125f), 0.0);
        highp float loc_6be3a = (((loc_ad517 - 1.0) * loc_cd10e) * loc_cd10e) + 1.0;
        highp float loc_ad7fb = loc_a68f1 * 0.5;
        highp float loc_00ee9 = clamp(1.0 - max(dot(arg_81f79, loc_a125f), 0.0), 0.0, 1.0);
        highp float loc_a177b = loc_00ee9 * loc_00ee9;
        highp vec3 loc_d5257 = arg_58ffc + ((vec3(1.0) - arg_58ffc) * ((loc_a177b * loc_a177b) * loc_00ee9));
        highp vec3 loc_b92e1 = arg_cff01 * (1.0 - arg_5416d);
        highp vec4 loc_55c3a = vec4(0.0);
        highp vec3 loc_d62e4;
        highp float loc_39386;
        highp float loc_4feae;
        func_dbe43(loc_25712, loc_4d5d9, loc_4feae, loc_39386, loc_d62e4, arg_5a8cd, arg_4fa31, arg_9502a);
        loc_55c3a = loc_25712;
        highp vec3 loc_ef49b = loc_a468d.xyz + loc_25712.xyz;
        loc_a468d = vec4(loc_ef49b.x, loc_ef49b.y, loc_ef49b.z, loc_a468d.w);
        loc_96e3a = loc_a55d6 + loc_55c3a.w;
        loc_50935 = loc_45a05 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_9502a)) * (loc_b92e1 * vec3(0.3183098733425140380859375))) * loc_39386) + (((loc_b92e1 * vec3(0.3183098733425140380859375)) * (arg_9502a * max((dot(-arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_4feae)) * loc_d62e4) * DiffuseSpecularEmissiveAmbientTermToggles.x);
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
void func_d7f93(inout highp vec3 arg_326b5, inout highp vec3 arg_179c6, inout highp vec3 arg_a0b83, inout highp vec3 arg_757dc, inout highp vec4 arg_d4ca2, inout highp vec3 arg_b40e7, inout highp vec3 arg_6f73b, inout highp vec3 arg_56f56, inout highp vec3 arg_9c753, inout highp float arg_a995c, inout highp vec3 arg_7e9dc, inout highp vec3 arg_4e72a, inout highp float arg_e9876, inout highp vec3 arg_602b8, inout highp float arg_15153) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0))
    {
        arg_326b5 = arg_179c6;
        arg_a0b83 = arg_757dc;
        arg_d4ca2 = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    highp vec3 loc_bd0c6;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_bd0c6 = arg_b40e7;
    }
    else
    {
        loc_bd0c6 = v_worldPos;
    }
    highp vec4 loc_750c4;
    highp vec3 loc_65e40;
    highp vec3 loc_bfc29;
    func_8c92a(arg_6f73b, loc_bfc29, loc_65e40, loc_750c4, arg_56f56, arg_9c753, arg_a995c, arg_7e9dc, arg_4e72a, arg_e9876, loc_bd0c6, arg_602b8, arg_15153);
    arg_326b5 = arg_179c6 + loc_bfc29;
    arg_a0b83 = arg_757dc + loc_65e40;
    arg_d4ca2 = loc_750c4;
}
#endif
void func_f1037(inout highp vec3 arg_1c74c, inout highp float arg_19032, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec3 loc_31e57 = (arg_1c74c * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x;
    highp vec3 loc_cfa08 = mix(AmbientLightParams.xyz * AmbientLightParams.w, loc_31e57, vec3(clamp(dot(loc_31e57, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), 0.0, 1.0))) * arg_19032;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_cfa08, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_cfa08, 1.0);
}
void main() {
    highp vec4 var_7d5d9 = v_color0;
#if defined(DITHERING__ON) || defined(SEASONS__OFF)
    highp vec2 var_0a028 = v_ditheringAndMaskTinting;
#endif
    highp vec2 var_1a204 = v_lightmapUV;
#if defined(DITHERING__OFF) && defined(SEASONS__OFF)
    highp vec4 var_269bc = texture(s_MatTexture, v_texcoord0);
#endif
#if defined(DITHERING__ON) || defined(SEASONS__ON)
    highp vec4 var_5e3c6 = texture(s_MatTexture, v_texcoord0);
#endif
#ifdef DITHERING__ON
    highp vec2 var_4d996 = DitherParams2[2].xy;
    if (var_0a028.x > 0.5)
    {
        highp mat4 var_f9f4f = u_view;
        highp vec4 var_bb748 = v_clipPosition;
        highp vec2 var_b2538 = floor(((((v_clipPosition.xyz / vec3(var_bb748.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 var_4bcab = floor(var_b2538 * 0.25);
        highp vec2 var_c7867 = floor(var_b2538 * 0.5);
        highp vec2 var_087cd = floor(var_b2538);
        if (smoothstep(var_4d996.x, var_4d996.y, dot(-normalize(vec4(var_f9f4f[0].z, var_f9f4f[1].z, var_f9f4f[2].z, var_2f370).xyz), v_worldPos - ViewPositionAndTime.xyz)) <= (((((((fract((var_4bcab.x * 0.5) + ((var_4bcab.y * var_4bcab.y) * 0.75)) * 0.25) + fract((var_c7867.x * 0.5) + ((var_c7867.y * var_c7867.y) * 0.75))) * 0.25) + fract((var_087cd.x * 0.5) + ((var_087cd.y * var_087cd.y) * 0.75))) * 64.0) + 0.5) * 0.015625))
        {
            var_5e3c6.w = 0.0;
        }
    }
#endif
#if defined(DITHERING__ON) && defined(SEASONS__OFF)
    highp vec4 var_269bc = var_5e3c6;
#endif
#ifdef SEASONS__OFF
    if (var_0a028.y != 0.0)
    {
        highp vec3 var_5e4d7 = mix(var_269bc.xyz, var_269bc.xyz * v_color0.xyz, vec3(var_269bc.w)).xyz * var_7d5d9.w;
        var_269bc = vec4(var_5e4d7.x, var_5e4d7.y, var_5e4d7.z, var_269bc.w);
        var_269bc.w = 1.0;
    }
    else
    {
        highp vec3 var_55928 = var_269bc.xyz * v_color0.xyz;
        var_269bc = vec4(var_55928.x, var_55928.y, var_55928.z, var_269bc.w);
        var_269bc.w *= var_7d5d9.w;
    }
#endif
#ifdef SEASONS__ON
    highp vec3 var_2455e = v_color0.xyz;
    highp vec3 var_2b07f = (var_5e3c6.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_2455e.z))).xyz * vec3(var_7d5d9.w);
    highp vec4 var_89b93 = vec4(var_2b07f.x, var_2b07f.y, var_2b07f.z, var_5e3c6.w);
    var_89b93.w = 1.0;
    highp vec4 var_269bc = var_89b93;
#endif
    highp vec3 var_31778;
#ifdef SEASONS__OFF
    func_66b9c(var_31778, var_269bc);
#endif
#ifdef SEASONS__ON
    func_66b9c(var_31778, var_89b93);
#endif
    highp vec3 var_d2ce2;
    highp float var_5e5e9;
    highp float var_f40a8;
    highp float var_39edd;
    highp float var_4de16;
    func_6546f(var_4de16, var_39edd, var_f40a8, var_5e5e9, var_d2ce2);
    highp vec4 var_930c5 = u_view * vec4(v_worldPos, 1.0);
    highp vec4 var_e87e0 = u_proj * var_930c5;
    highp vec4 var_b8928 = var_e87e0;
    highp vec3 var_12830 = var_e87e0.xyz / vec3(var_b8928.w);
    highp vec3 var_b4b34 = normalize(var_d2ce2);
    highp vec4 var_e14aa = vec4(var_b4b34, 0.0);
    highp vec3 var_2b534 = var_930c5.xyz;
    bool var_71d55 = QuantizationParameters.y > 0.0;
    bool var_fc5fc;
    if (!var_71d55)
    {
        var_fc5fc = QuantizationParameters.w > 0.0;
    }
    else
    {
        var_fc5fc = var_71d55;
    }
    highp vec3 var_15859;
    if (var_fc5fc)
    {
        highp vec3 var_a35f2 = v_worldPos - WorldOrigin.xyz;
        highp vec3 var_66e39 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_2b534)), normalize(dFdy(var_2b534)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
        highp vec3 var_2872c = vec3(QuantizationParameters.z * 0.5) - mod(var_a35f2, vec3(QuantizationParameters.z));
        var_15859 = (var_a35f2 + (var_2872c - (var_66e39 * dot(var_2872c, var_66e39)))) + WorldOrigin.xyz;
    }
    else
    {
        var_15859 = v_worldPos;
    }
    highp vec3 var_63a6a = var_e14aa.xyz;
    highp vec3 var_73e61 = (u_view * var_e14aa).xyz;
    highp vec3 var_2b55b = v_lightColor;
    highp vec3 var_891e0;
    if ((((var_2b55b.x + var_2b55b.y) + var_2b55b.z) < 9.9999997473787516355514526367188e-05) && (var_1a204.x > 9.9999997473787516355514526367188e-05))
    {
        highp vec4 var_0bc6f = vec4(0.0);
        highp float var_9a19a = var_1a204.x * var_1a204.x;
        var_891e0 = clamp(vec3(var_9a19a + (var_0bc6f.x * var_0bc6f.w), (var_9a19a * ((((var_9a19a * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.y * var_0bc6f.w), (var_9a19a * (((var_9a19a * var_9a19a) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.z * var_0bc6f.w)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_891e0 = v_lightColor;
    }
    highp vec3 var_c5e74 = vec3(0.039999999105930328369140625 * (1.0 - var_4de16)) + (var_31778 * var_4de16);
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
    highp float var_c90aa;
    if (var_94c07)
    {
        var_c90aa = pow((texture(s_CausticsTexture, vec3((v_worldPos - WorldOrigin.xyz).xz * CausticsParameters.y, CausticsTextureParameters.y)).x * 2.0) * clamp(var_b4b34.y, 0.0, 1.0), CausticsParameters.z) * (CausticsParameters.z + 1.0);
    }
    else
    {
        var_c90aa = 1.0;
    }
    highp float var_62b20 = clamp(((var_1a204.y * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_106e2 = length(var_2b534);
    highp vec3 var_5bd0a = var_12830;
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_1cf85;
#endif
    highp vec3 var_76b67;
    highp vec3 var_e35de;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_c2de9 = -(var_2b534 / vec3(length(var_2b534) + 9.9999997473787516355514526367188e-05));
        highp float var_a712c = var_5e5e9 * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
        highp vec3 var_8bbda = var_2b534;
        highp vec3 var_a3c91;
        if (int(QuantizationParameters.y) > 0)
        {
            var_a3c91 = var_15859;
        }
        else
        {
            var_a3c91 = v_worldPos;
        }
        highp vec3 var_938e2;
        highp vec3 var_ce603;
        func_6c485(var_1a204, var_ce603, var_938e2, var_73e61, var_a3c91, var_63a6a, var_8bbda, var_c90aa, var_c2de9, var_39edd, var_c5e74, var_31778, var_4de16, var_a712c);
#ifdef POINT_LIGHT_SHADING__ON
        highp vec4 var_05431;
        highp vec3 var_aae12;
        highp vec3 var_e318f;
        func_d7f93(var_e318f, var_ce603, var_aae12, var_938e2, var_05431, var_15859, var_2b534, var_73e61, var_c2de9, var_39edd, var_c5e74, var_31778, var_4de16, var_63a6a, var_a712c);
        var_e35de = var_e318f;
#endif
#ifdef POINT_LIGHT_SHADING__OFF
        var_e35de = var_ce603;
        var_76b67 = var_938e2;
#endif
#ifdef POINT_LIGHT_SHADING__ON
        var_76b67 = var_aae12;
        var_1cf85 = var_05431;
#endif
    }
    else
    {
        var_e35de = vec3(0.0);
        var_76b67 = vec3(0.0);
#ifdef POINT_LIGHT_SHADING__ON
        var_1cf85 = vec4(0.0, 0.0, 0.0, 1.0);
#endif
    }
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_a2cfa = var_1cf85;
#endif
    highp vec4 var_62dcd = SkyAmbientLightColorIntensity;
    highp float var_83e6f = var_1a204.y * var_1a204.y;
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
    highp vec3 var_936b4;
    if (var_68aa1)
    {
        highp vec4 var_1a32d = vec4(1.0);
        highp vec4 var_ee7a5 = SkyAmbientLightColorIntensity;
        var_936b4 = max(((vec3(1.0) + (vec3(1.0) * var_1a32d.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix(1.0, 1.0, CameraLightIntensity.y)) * var_ee7a5.w), AmbientLightParams.xyz * AmbientLightParams.w) * AtmosphericScatteringToggles.z;
    }
    else
    {
        var_936b4 = vec3(0.0);
    }
    highp vec3 var_1bb57;
    highp float var_bdb1d;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        highp float var_79b3e = clamp((((length(var_2b534) / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
        highp vec3 var_138a7;
        if (var_79b3e > 0.0)
        {
            highp vec3 var_44083;
            if (AtmosphericScatteringToggles.y != 0.0)
            {
                var_44083 = FogColor.xyz * max(var_936b4, vec3(1.0));
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
                highp vec3 var_c1176 = (((mix(SkyZenithColor.xyz, SkyHorizonColor.xyz, vec3((var_070ce * var_070ce) * var_070ce)) * AtmosphericScattering.x) * 0.079577468335628509521484375) * ((var_a0aa2.w * (0.75 * ((var_99d92 * var_99d92) + 1.0))) + (var_ea036.w * (0.75 * ((var_b6eed * var_b6eed) + 1.0))))) + (((SkyHorizonColor.xyz * ((var_9281d * var_9281d) * var_9281d)) * 0.079577468335628509521484375) * (((((SunColor.xyz * var_a0aa2.w) * AtmosphericScattering.y) * var_824a6) * (0.0361000001430511474609375 / (var_3d1af * sqrt(var_3d1af)))) + ((((MoonColor.xyz * var_ea036.w) * AtmosphericScattering.z) * var_3b3ff) * (0.0361000001430511474609375 / (var_db5e0 * sqrt(var_db5e0))))));
                highp vec3 var_8e91d;
                if (AtmosphericScatteringToggles.w != 0.0)
                {
                    var_8e91d = mix(UndergroundFogColor.xyz, var_c1176, vec3(max(CameraAmbientContribution.y, var_1a204.y)));
                }
                else
                {
                    var_8e91d = var_c1176;
                }
                var_44083 = var_8e91d;
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
    highp vec4 var_7213b = vec4(var_1bb57, var_bdb1d);
    highp vec4 var_47867 = var_7213b;
    highp vec4 var_85ad1;
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
        var_85ad1 = mix(textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_8cf8f, var_115ba.y, float(var_0e80b + 1)), 0.0), vec4(clamp(var_14f4f - float(var_0e80b), 0.0, 1.0)));
    }
    else
    {
        var_85ad1 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_c6b00 = var_85ad1;
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_5779c = var_85ad1.xyz + (mix((((((var_31778 * (1.0 - var_4de16)) * max(((var_891e0 + (var_1cf85.xyz * var_a2cfa.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_83e6f * var_83e6f) * var_1a204.y, (var_1a204.y * var_1a204.y) * var_1a204.y, CameraLightIntensity.y)) * var_62dcd.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_e35de) + var_76b67) + (((mix(var_31778, vec3(dot(var_31778, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_f40a8)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_7213b.xyz, vec3(var_47867.w)) * var_c6b00.w);
#endif
    highp vec3 var_aba61;
    if (IBLParameters.x != 0.0)
    {
        highp vec3 var_a8715;
        highp vec3 var_dd3fd;
        if (QuantizationParameters.w > 0.0)
        {
            var_dd3fd = (u_view * vec4(var_15859, 1.0)).xyz;
            var_a8715 = var_15859;
        }
        else
        {
            var_dd3fd = var_2b534;
            var_a8715 = v_worldPos;
        }
        highp vec3 var_a56d9 = reflect(normalize(var_a8715 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_63a6a);
        highp float var_0f441;
        if (int(ConvolutionType.x) == 1)
        {
            highp float var_9a0e5 = 1.0 - var_39edd;
            var_0f441 = (1.0 - (var_9a0e5 * var_9a0e5)) * (IBLParameters.y - 1.0);
        }
        else
        {
            highp float var_c17b7 = 1.0 - var_39edd;
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
        highp vec3 var_713f8 = (var_99477 * (((var_62b20 * var_62b20) * var_62b20) * IBLParameters.x)) * IBLParameters.z;
        highp vec3 var_da3af;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec4 var_26642;
            func_f1037(var_891e0, var_4de16, var_713f8, var_26642);
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
        highp vec2 var_dea35 = vec2(clamp(dot(var_73e61, -normalize(var_dd3fd)), 0.0, 1.0), var_39edd);
        var_dea35.y = 1.0 - var_dea35.y;
        highp vec2 var_7d2be = texture(s_BrdfLUT, var_dea35).xy;
        highp vec3 var_fe0f6 = var_da3af * ((var_c5e74 * var_7d2be.x) + vec3(var_7d2be.y));
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
        var_aba61 = var_0ffc6;
    }
    else
    {
        var_aba61 = vec3(0.0);
    }
#ifdef POINT_LIGHT_SHADING__OFF
    highp vec3 var_56408 = vec4(var_85ad1.xyz + (mix((((((var_31778 * (1.0 - var_4de16)) * max((var_891e0 * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_83e6f * var_83e6f) * var_1a204.y, (var_1a204.y * var_1a204.y) * var_1a204.y, CameraLightIntensity.y)) * var_62dcd.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_e35de) + var_76b67) + (((mix(var_31778, vec3(dot(var_31778, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), vec3(EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.y)) * DiffuseSpecularEmissiveAmbientTermToggles.z) * vec3(var_f40a8)) * EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.x), var_7213b.xyz, vec3(var_47867.w)) * var_c6b00.w), 1.0).xyz + var_aba61;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_56408 = vec4(var_5779c, 1.0).xyz + var_aba61;
#endif
    highp vec3 var_d523d;
    if (PreExposureEnabled.x > 0.0)
    {
        var_d523d = var_56408 * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_d523d = var_56408;
    }
    bgfx_FragData0 = vec4(var_d523d, var_269bc.w);
}
