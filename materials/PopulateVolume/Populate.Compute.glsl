#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - POPULATE_PASS (not used)
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF
* - POINT_LIGHT_SHADING__ON
*
* ThreadLimit:
* - THREAD_LIMIT__LIMITED_AT128
* - THREAD_LIMIT__LIMITED_AT256
* - THREAD_LIMIT__NATIVE
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2DArray s_CurrentLightingBuffer;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_PreviousLightingBuffer;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_ScreenSpaceWaterBackFaceDepthAndNormal;
* - uniform lowp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 14, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 6, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 7, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
*
* Uniforms:
* - uniform vec4 AirAlbedoExtinction;
* - uniform vec4 AmbientContribution;
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BiomeBlendingLastUpdatePosition;
* - uniform vec4 BiomeBlendingParameters;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 CameraUnderwaterAndWaterSurfaceBiasAndFalloff;
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
* - uniform vec4 HeightFogScaleBias;
* - uniform vec4 HenyeyGreensteinG;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 JitterOffset;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 ManhattanDistAttenuationEnabled;
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
* - uniform mat4 PrevInvProj;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyAmbientSamplesConfig;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TemporalSettings;
* - uniform vec4 Time;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 VolumeShadowSettings;
* - uniform vec4 WaterAlbedoExtinction;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WaterSurfaceEnabled;
* - uniform vec4 WaterSurfaceOctaveParameters;
* - uniform vec4 WaterSurfaceParameters;
* - uniform vec4 WaterSurfaceWaveParameters;
* - uniform vec4 WorldOrigin;
*/

#ifdef POINT_LIGHT_SHADING__ON
#extension GL_EXT_texture_cube_map_array : require
#endif
#ifdef THREAD_LIMIT__LIMITED_AT128
layout(local_size_x = 8, local_size_y = 8, local_size_z = 2) in;
#endif
#ifdef THREAD_LIMIT__LIMITED_AT256
layout(local_size_x = 8, local_size_y = 8, local_size_z = 4) in;
#endif
#ifdef THREAD_LIMIT__NATIVE
layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;
#endif
#ifdef POINT_LIGHT_SHADING__ON
struct Light {
    vec4 position;
    vec4 color;
    int shadowProbeIndex;
    int pad0;
    int pad1;
    int pad2;
};

#endif
struct BiomeInfo {
    vec4 waterExtinctionCoefficients;
    vec4 waterAlbedoExtinction;
    vec4 waterSurfaceParameters;
    vec4 waterSurfaceWaveParameters;
    vec4 waterSurfaceOctaveParameters;
};

#ifdef POINT_LIGHT_SHADING__ON
struct LightData {
    float lookup;
};

int var_e7b23;
layout(binding = 7, std430) buffer s_zLights { Light zLights[]; } var_f8d0a;
#endif
layout(binding = 14, std430) buffer s_zBiomeInfoBuffer { BiomeInfo zBiomeInfoBuffer[]; } var_7c65b;
#ifdef POINT_LIGHT_SHADING__ON
layout(binding = 6, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_dda85;
#endif
layout(location = 0, binding = 0, rgba16f) uniform writeonly highp image2DArray s_CurrentLightingBuffer;
uniform highp sampler2D s_BiomeBlendingMap;
uniform highp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
uniform highp sampler2DArray s_PreviousLightingBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp sampler3D s_SkyAmbientSamples;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
#endif
uniform mat4 CascadesShadowProj[8];
uniform mat4 CloudShadowProj;
uniform mat4 PlayerShadowProj;
#ifdef POINT_LIGHT_SHADING__ON
uniform mat4 PointLightProj;
#endif
uniform mat4 PrevInvProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 AirAlbedoExtinction;
uniform vec4 AmbientContribution;
uniform vec4 BiomeBlendingLastUpdatePosition;
uniform vec4 BiomeBlendingParameters;
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform vec4 CameraUnderwaterAndWaterSurfaceBiasAndFalloff;
uniform vec4 CascadesParameters[8];
uniform vec4 CascadesPerSet;
uniform vec4 CloudShadowsVisible;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 ClusterDepthBounds;
uniform vec4 ClusterDimensions;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 ClusterSize;
#endif
uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform vec4 DirectionalLightSkyLightHeuristicToggles;
uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
uniform vec4 DirectionalLightSourceWorldSpaceDirection;
uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
uniform vec4 FogAndDistanceControl;
uniform vec4 HeightFogScaleBias;
uniform vec4 HenyeyGreensteinG;
uniform vec4 JitterOffset;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 ManhattanDistAttenuationEnabled;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 PointLightDiffuseFadeOutParameters;
#endif
uniform vec4 QuantizationParameters;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 SkyAmbientSamplesConfig;
uniform vec4 TemporalSettings;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
#ifdef POINT_LIGHT_SHADING__ON
uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
#endif
uniform vec4 VolumeShadowSettings;
uniform vec4 WaterAlbedoExtinction;
uniform vec4 WorldOrigin;
uniform vec4 u_prevWorldPosOffset;
void func_8ab59(inout bool arg_5e3ed) {
    if (BiomeBlendingParameters.x > 0.0)
    {
        arg_5e3ed = true;
        return;
    }
    arg_5e3ed = false;
}
void func_aa346(inout vec3 arg_9de81, inout vec4 arg_34c2e) {
    bool loc_a9f27;
    func_8ab59(loc_a9f27);
    if (loc_a9f27)
    {
        vec3 loc_72e58 = arg_9de81;
        int loc_b9c0c = int(BiomeBlendingParameters.z * 0.5);
        vec3 loc_55203 = BiomeBlendingLastUpdatePosition.xyz + WorldOrigin.xyz;
        float loc_4b4c0 = (loc_72e58.x - loc_55203.x) / BiomeBlendingLastUpdatePosition.w;
        float loc_ec4c0 = (loc_72e58.z - loc_55203.z) / BiomeBlendingLastUpdatePosition.w;
        ivec2 loc_f9dbc = ivec2(loc_b9c0c + int(floor(loc_4b4c0)), loc_b9c0c + int(floor(loc_ec4c0)));
        loc_f9dbc.x = clamp(loc_f9dbc.x, 0, int(BiomeBlendingParameters.z) - 1);
        loc_f9dbc.y = clamp(loc_f9dbc.y, 0, int(BiomeBlendingParameters.z) - 1);
        float loc_2350c = fract(loc_4b4c0);
        float loc_78620 = fract(loc_ec4c0);
        vec4 loc_9af45 = vec4((1.0 - loc_2350c) * (1.0 - loc_78620), loc_2350c * (1.0 - loc_78620), (1.0 - loc_2350c) * loc_78620, loc_2350c * loc_78620);
        arg_34c2e = (((var_7c65b.zBiomeInfoBuffer[int(round(texelFetch(s_BiomeBlendingMap, loc_f9dbc, 0).x * 255.0))].waterAlbedoExtinction * loc_9af45.x) + (var_7c65b.zBiomeInfoBuffer[int(round(texelFetch(s_BiomeBlendingMap, loc_f9dbc + ivec2(1, 0), 0).x * 255.0))].waterAlbedoExtinction * loc_9af45.y)) + (var_7c65b.zBiomeInfoBuffer[int(round(texelFetch(s_BiomeBlendingMap, loc_f9dbc + ivec2(0, 1), 0).x * 255.0))].waterAlbedoExtinction * loc_9af45.z)) + (var_7c65b.zBiomeInfoBuffer[int(round(texelFetch(s_BiomeBlendingMap, loc_f9dbc + ivec2(1), 0).x * 255.0))].waterAlbedoExtinction * loc_9af45.w);
        return;
    }
    arg_34c2e = WaterAlbedoExtinction;
}
void func_e5e1e(inout vec3 arg_9b0e1, inout float arg_7a26d) {
    vec4 loc_59f32 = PlayerShadowProj * vec4(arg_9b0e1, 1.0);
    loc_59f32.z -= CascadesParameters[0].y;
    loc_59f32.z = min(loc_59f32.z, 1.0);
    vec2 loc_5ae5f = ((vec2(loc_59f32.x, loc_59f32.y) * 0.5) + vec2(0.5)) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    int loc_64b28;
    if (QuantizationParameters.x != 0.0)
    {
        loc_64b28 = 1;
    }
    else
    {
        loc_64b28 = clamp(int((2.0 * VolumeShadowSettings.x) + 0.5), 1, 9);
    }
    int loc_a4d0e = loc_64b28 / 2;
    loc_59f32.z = (loc_59f32.z * 0.5) + 0.5;
    loc_5ae5f.y += (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    bool loc_2c837 = loc_5ae5f.x >= 0.0;
    bool loc_d06e3;
    if (loc_2c837)
    {
        loc_d06e3 = loc_5ae5f.x < FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y;
    }
    else
    {
        loc_d06e3 = loc_2c837;
    }
    bool loc_c7ec9;
    if (loc_d06e3)
    {
        loc_c7ec9 = loc_5ae5f.y >= (1.0 - FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
    }
    else
    {
        loc_c7ec9 = loc_d06e3;
    }
    bool loc_8e2b9;
    if (loc_c7ec9)
    {
        loc_8e2b9 = loc_5ae5f.y < 1.0;
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
    float loc_304c3 = dot(CascadesPerSet, vec4(1.0)) + 1.0;
    float loc_e55e0;
    loc_e55e0 = 0.0;
    float loc_edd8a;
    for (int loc_e3b31 = 0; loc_e3b31 < loc_64b28; loc_e55e0 = loc_edd8a, loc_e3b31++)
    {
        loc_edd8a = loc_e55e0;
        float loc_5e275;
        for (int loc_d3328 = 0; loc_d3328 < loc_64b28; loc_edd8a = loc_5e275, loc_d3328++)
        {
            vec2 loc_49c98 = loc_5ae5f + ((vec2(float(loc_d3328 - loc_a4d0e) + 0.5, float(loc_e3b31 - loc_a4d0e) + 0.5) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.z) * FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.y);
            vec3 loc_747f0 = vec3(loc_49c98.x, loc_49c98.y, loc_304c3);
            if (QuantizationParameters.x != 0.0)
            {
                loc_5e275 = loc_edd8a + float(textureLod(s_ShadowCascades, loc_747f0, 0.0).x >= loc_59f32.z);
            }
            else
            {
                vec4 loc_8954e = step(vec4(loc_59f32.z), textureGather(s_ShadowCascades, loc_747f0));
                vec2 loc_db73a = fract((loc_747f0.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                loc_5e275 = loc_edd8a + mix(mix(loc_8954e.w, loc_8954e.z, loc_db73a.x), mix(loc_8954e.x, loc_8954e.y, loc_db73a.x), loc_db73a.y);
            }
        }
    }
    arg_7a26d = loc_e55e0 / float(loc_64b28 * loc_64b28);
}
#ifdef POINT_LIGHT_SHADING__OFF
void func_73158() {
    int loc_b5e48 = int(GlobalInvocationID.x);
    int loc_45941 = int(GlobalInvocationID.y);
    int loc_beae9 = int(GlobalInvocationID.z);
    if (((loc_b5e48 >= int(VolumeDimensions.x)) || (loc_45941 >= int(VolumeDimensions.y))) || (loc_beae9 >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_8b342 = ((vec3(float(loc_b5e48), float(loc_45941), float(loc_beae9)) + vec3(0.5)) + JitterOffset.xyz) / VolumeDimensions.xyz;
    vec3 loc_1fa0b = loc_8b342;
    vec3 loc_777c2 = loc_8b342;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_8b342.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_caed6 = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_caed6;
    vec3 loc_16a16 = (u_view * vec4(loc_caed6, 1.0)).xyz;
    vec2 loc_04947 = texelFetch(s_ScreenSpaceWaterFrontFaceDepthAndNormal, ivec2(loc_b5e48, loc_45941), 0).xy;
    float loc_e737b = smoothstep(-0.5, 0.5, ((((loc_1fa0b.z - loc_04947.x) * VolumeDimensions.z) * loc_04947.y) - CameraUnderwaterAndWaterSurfaceBiasAndFalloff.y) / CameraUnderwaterAndWaterSurfaceBiasAndFalloff.z);
    float loc_343cf;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_343cf = 1.0 - loc_e737b;
    }
    else
    {
        loc_343cf = loc_e737b;
    }
    vec4 loc_4397b;
    func_aa346(loc_caed6, loc_4397b);
    vec4 loc_12f1c = loc_4397b;
    float loc_ebd19 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_a9dfb = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_343cf);
    float loc_9fe9d = length(loc_16a16);
    float loc_ab2d8 = clamp((((loc_9fe9d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_d93dd = mix(mix((AirAlbedoExtinction.xyz * loc_ebd19) * AirAlbedoExtinction.w, loc_4397b.xyz * loc_12f1c.w, vec3(loc_343cf)), vec3(0.0), vec3(loc_ab2d8));
    float loc_8068a = mix(mix(loc_ebd19 * AirAlbedoExtinction.w, loc_12f1c.w, loc_343cf), 0.0, loc_ab2d8);
    vec2 loc_3bb72 = AmbientContribution.xy;
    if (SkyAmbientSamplesConfig.x > 0.5)
    {
        vec3 loc_30e99 = loc_8b342;
        loc_30e99.y = 1.0 - loc_30e99.y;
        if (SkyAmbientSamplesConfig.y > 0.5)
        {
            loc_30e99.z -= SkyAmbientSamplesConfig.z;
        }
        loc_30e99.z = (exp(4.0 * loc_30e99.z) - 1.0) * 0.0186573602259159088134765625;
        loc_3bb72 = textureLod(s_SkyAmbientSamples, loc_30e99, 0.0).xy;
    }
    vec3 loc_222bb = ((loc_d93dd * 0.079577468335628509521484375) * max(((BlockBaseAmbientLightColorIntensity.xyz * loc_3bb72.x) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * loc_3bb72.y) * SkyAmbientLightColorIntensity.w), vec3(AmbientContribution.z))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    bool loc_5b439 = !(DirectionalLightSkyLightHeuristicToggles.y != 0.0);
    bool loc_7e26a;
    if (!loc_5b439)
    {
        loc_7e26a = abs(loc_3bb72.y) > 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_7e26a = loc_5b439;
    }
    vec3 loc_7175c;
    if (loc_7e26a)
    {
        float loc_af838;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            int loc_c0de4 = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
            float loc_f6ac1;
            loc_f6ac1 = 1.0;
            int loc_d7178;
            float loc_484ee;
            for (int loc_8a709 = 0, loc_0e4f2 = 0; loc_8a709 < loc_c0de4; loc_0e4f2 = loc_d7178, loc_f6ac1 = loc_484ee, loc_8a709++)
            {
                int loc_79423 = min((loc_0e4f2 + int(CascadesPerSet[loc_8a709])), 8);
                loc_484ee = loc_f6ac1;
                loc_d7178 = loc_0e4f2;
                int loc_a0458;
                float loc_5399e;
                for (; loc_d7178 < loc_79423; loc_484ee = loc_5399e, loc_d7178 = loc_a0458)
                {
                    vec4 loc_0dca3 = CascadesShadowProj[loc_d7178] * vec4(loc_caed6, 1.0);
                    vec3 loc_8d38c = abs(loc_0dca3.xyz);
                    bool loc_45980 = loc_8d38c.x <= 1.0;
                    bool loc_f1421;
                    if (loc_45980)
                    {
                        loc_f1421 = loc_8d38c.y <= 1.0;
                    }
                    else
                    {
                        loc_f1421 = loc_45980;
                    }
                    bool loc_e36b7;
                    if (loc_f1421)
                    {
                        loc_e36b7 = loc_8d38c.z <= 1.0;
                    }
                    else
                    {
                        loc_e36b7 = loc_f1421;
                    }
                    if (loc_e36b7)
                    {
                        vec4 loc_ada37 = loc_0dca3;
                        int loc_3a40c;
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_3a40c = 1;
                        }
                        else
                        {
                            loc_3a40c = clamp(int((CascadesParameters[loc_d7178].w * VolumeShadowSettings.x) + 0.5), 1, 9);
                        }
                        int loc_960ef = loc_3a40c / 2;
                        vec2 loc_445f6 = ((vec2(loc_ada37.x, loc_ada37.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_d7178].x;
                        float loc_4fba3 = (loc_ada37.z * 0.5) + 0.5;
                        loc_445f6.y += (1.0 - CascadesParameters[loc_d7178].x);
                        float loc_3555e;
                        loc_3555e = 0.0;
                        float loc_801c0;
                        for (int loc_15249 = 0; loc_15249 < loc_3a40c; loc_3555e = loc_801c0, loc_15249++)
                        {
                            loc_801c0 = loc_3555e;
                            float loc_30840;
                            for (int loc_963d2 = 0; loc_963d2 < loc_3a40c; loc_801c0 = loc_30840, loc_963d2++)
                            {
                                vec2 loc_cced5 = loc_445f6 + ((vec2(float(loc_963d2 - loc_960ef) + 0.5, float(loc_15249 - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_d7178].x);
                                vec4 loc_fe3f0 = textureGather(s_ShadowCascades, vec3(loc_cced5, float(loc_d7178)));
                                vec4 loc_26b65 = loc_fe3f0;
                                if (QuantizationParameters.x != 0.0)
                                {
                                    loc_30840 = loc_801c0 + float(loc_26b65.w >= (loc_4fba3 - CascadesParameters[loc_d7178].y));
                                }
                                else
                                {
                                    vec4 loc_2f6b4 = step(vec4(loc_4fba3 - CascadesParameters[loc_d7178].y), loc_fe3f0);
                                    vec2 loc_e2aba = fract((loc_cced5 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                    loc_30840 = loc_801c0 + mix(mix(loc_2f6b4.w, loc_2f6b4.z, loc_e2aba.x), mix(loc_2f6b4.x, loc_2f6b4.y, loc_e2aba.x), loc_e2aba.y);
                                }
                            }
                        }
                        loc_5399e = min(loc_484ee, loc_3555e / float(loc_3a40c * loc_3a40c));
                        loc_a0458 = loc_79423;
                    }
                    else
                    {
                        loc_5399e = loc_484ee;
                        loc_a0458 = loc_d7178 + 1;
                    }
                }
            }
            float loc_f828f;
            if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
            {
                float loc_ad066;
                func_e5e1e(loc_caed6, loc_ad066);
                loc_f828f = loc_ad066;
            }
            else
            {
                loc_f828f = 1.0;
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
            float loc_4a190;
            if (loc_b7807)
            {
                vec4 loc_bcd0f = CloudShadowProj * vec4(loc_caed6, 1.0);
                vec4 loc_6ef28 = loc_bcd0f;
                loc_6ef28 = loc_bcd0f / vec4(loc_6ef28.w);
                loc_6ef28.z -= (CascadesParameters[0].y / loc_6ef28.w);
                vec2 loc_76921 = ((vec2(loc_6ef28.x, loc_6ef28.y) * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
                int loc_c86ff;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_c86ff = 1;
                }
                else
                {
                    loc_c86ff = clamp(int((EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * VolumeShadowSettings.x) + 0.5), 1, 9);
                }
                int loc_7508d = loc_c86ff / 2;
                loc_6ef28.z = (loc_6ef28.z * 0.5) + 0.5;
                loc_76921.y += (1.0 - CascadesParameters[0].x);
                float loc_19cd0 = dot(CascadesPerSet, vec4(1.0));
                float loc_543e1;
                loc_543e1 = 0.0;
                float loc_0fce1;
                for (int loc_093cd = 0; loc_093cd < loc_c86ff; loc_543e1 = loc_0fce1, loc_093cd++)
                {
                    loc_0fce1 = loc_543e1;
                    float loc_16f2e;
                    for (int loc_fdb90 = 0; loc_fdb90 < loc_c86ff; loc_0fce1 = loc_16f2e, loc_fdb90++)
                    {
                        vec3 loc_d07c9 = vec3(loc_76921 + ((vec2(float(loc_fdb90 - loc_7508d) + 0.5, float(loc_093cd - loc_7508d) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_19cd0);
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_16f2e = loc_0fce1 + float(textureLod(s_ShadowCascades, loc_d07c9, 0.0).x >= loc_6ef28.z);
                        }
                        else
                        {
                            vec4 loc_2ae6b = step(vec4(loc_6ef28.z), textureGather(s_ShadowCascades, loc_d07c9));
                            vec2 loc_52300 = fract((loc_d07c9.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            loc_16f2e = loc_0fce1 + mix(mix(loc_2ae6b.w, loc_2ae6b.z, loc_52300.x), mix(loc_2ae6b.x, loc_2ae6b.y, loc_52300.x), loc_52300.y);
                        }
                    }
                }
                float loc_8a60e = loc_543e1 / float(loc_c86ff * loc_c86ff);
                float loc_26602;
                if (loc_8a60e < 1.0)
                {
                    loc_26602 = min(1.0, max(loc_8a60e, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                }
                else
                {
                    loc_26602 = 1.0;
                }
                loc_4a190 = loc_26602;
            }
            else
            {
                loc_4a190 = 1.0;
            }
            loc_af838 = mix(min(loc_f6ac1, min(loc_f828f, loc_4a190)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -0.0));
        }
        else
        {
            loc_af838 = 1.0;
        }
        float loc_44a26 = (1.0 + (loc_a9dfb * loc_a9dfb)) + ((2.0 * loc_a9dfb) * dot(-(loc_16a16 / vec3(loc_9fe9d)), normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_4de69 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_7175c = loc_222bb + (((loc_d93dd * loc_af838) * ((0.079577468335628509521484375 * (1.0 - (loc_a9dfb * loc_a9dfb))) / (loc_44a26 * sqrt(loc_44a26)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_4de69.w));
    }
    else
    {
        loc_7175c = loc_222bb;
    }
    if (TemporalSettings.x > 0.0)
    {
        vec3 loc_dfafd = (vec3(float(loc_b5e48), float(loc_45941), float(loc_beae9)) + vec3(0.5)) / VolumeDimensions.xyz;
        vec3 loc_e9300 = loc_dfafd;
        vec2 loc_9d396 = VolumeNearFar.xy;
        float loc_fcd55 = (exp(4.0 * loc_e9300.z) - 1.0) * 0.0186573602259159088134765625;
        vec4 loc_62495 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcd55) * loc_9d396.x) + (loc_fcd55 * loc_9d396.y)), 1.0);
        vec4 loc_d7f13 = u_invViewProj * vec4((loc_dfafd.xy * 2.0) - vec2(1.0), loc_62495.z / loc_62495.w, 1.0);
        vec4 loc_d1c9b = loc_d7f13;
        vec4 loc_bf151 = u_prevViewProj * vec4((loc_d7f13.xyz / vec3(loc_d1c9b.w)) - u_prevWorldPosOffset.xyz, 1.0);
        vec4 loc_d9ce7 = loc_bf151;
        vec3 loc_ec028 = loc_bf151.xyz / vec3(loc_d9ce7.w);
        vec2 loc_1fa2a = VolumeNearFar.xy;
        vec2 loc_81f33 = (loc_ec028.xy + vec2(1.0)) * 0.5;
        vec4 loc_3fd1f = PrevInvProj * vec4(loc_ec028, 1.0);
        float loc_d255f = loc_81f33.x;
        vec3 loc_33e20 = vec3(loc_d255f, loc_81f33.y, log((53.598148345947265625 * ((((-loc_3fd1f.z) / loc_3fd1f.w) - loc_1fa2a.x) / (loc_1fa2a.y - loc_1fa2a.x))) + 1.0) * 0.25);
        ivec3 loc_dbdb4 = ivec3(VolumeDimensions.xyz);
        ivec3 loc_57985 = loc_dbdb4;
        vec3 loc_96ba4 = loc_33e20;
        float loc_53f43 = (loc_96ba4.z * float(loc_57985.z)) - 0.5;
        int loc_25a80 = clamp(int(loc_53f43), 0, loc_57985.z - 2);
        vec3 loc_34735 = VolumeDimensions.xyz * loc_33e20;
        imageStore(s_CurrentLightingBuffer, ivec3(loc_b5e48, loc_45941, loc_beae9), mix(vec4(loc_7175c, loc_8068a), mix(textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80)), 0.0), textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80 + 1)), 0.0), vec4(clamp(loc_53f43 - float(loc_25a80), 0.0, 1.0))), vec4(mix(TemporalSettings.z, 0.0, clamp(length(clamp(loc_34735, vec3(0.0), vec3(loc_dbdb4)) - loc_34735) * TemporalSettings.y, 0.0, 1.0)))));
    }
    else
    {
        imageStore(s_CurrentLightingBuffer, ivec3(loc_b5e48, loc_45941, loc_beae9), vec4(loc_7175c, loc_8068a));
    }
}
#endif
#ifdef POINT_LIGHT_SHADING__ON
void func_57d96(inout float arg_958de, inout vec2 arg_e6843, inout float arg_33edf, inout vec2 arg_410bb, inout vec3 arg_e0671) {
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
void func_86391(inout vec3 arg_176e1, inout vec3 arg_580a2, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    float loc_3b38e = -arg_176e1.z;
    vec2 loc_0d359 = arg_580a2.xy;
    vec3 loc_29493 = ClusterDimensions.xyz;
    vec2 loc_69b41 = ClusterNearFarWidthHeight.zw;
    vec2 loc_f1d2d = ClusterSize.xy;
    vec2 loc_2a810 = ClusterNearFarWidthHeight.xy;
    vec2 loc_7d455 = ClusterDepthBounds.xy;
    float loc_3b169;
    func_57d96(loc_3b38e, loc_2a810, loc_3b169, loc_7d455, loc_29493);
    vec3 loc_20923 = vec3(floor((loc_0d359.x * loc_69b41.x) / loc_f1d2d.x), floor((loc_0d359.y * loc_69b41.y) / loc_f1d2d.y), loc_3b169);
    bool loc_ce27d = loc_20923.x < 0.0;
    bool loc_f15a5;
    if (!loc_ce27d)
    {
        loc_f15a5 = loc_20923.y < 0.0;
    }
    else
    {
        loc_f15a5 = loc_ce27d;
    }
    bool loc_7bab6;
    if (!loc_f15a5)
    {
        loc_7bab6 = loc_20923.z < 0.0;
    }
    else
    {
        loc_7bab6 = loc_f15a5;
    }
    bool loc_a526b;
    if (!loc_7bab6)
    {
        loc_a526b = loc_20923.x >= ClusterDimensions.x;
    }
    else
    {
        loc_a526b = loc_7bab6;
    }
    bool loc_6d7c9;
    if (!loc_a526b)
    {
        loc_6d7c9 = loc_20923.y >= ClusterDimensions.y;
    }
    else
    {
        loc_6d7c9 = loc_a526b;
    }
    bool loc_fc058;
    if (!loc_6d7c9)
    {
        loc_fc058 = loc_20923.z >= ClusterDimensions.z;
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
    int loc_14533 = int((loc_20923.x + (loc_20923.y * ClusterDimensions.x)) + ((loc_20923.z * ClusterDimensions.x) * ClusterDimensions.y)) * int(ClusterDimensions.w);
    arg_e45b8 = loc_14533 + int(ClusterDimensions.w);
    arg_fadf1 = loc_14533;
    arg_d7f4c = true;
}
void func_c78d8(inout int arg_4a614, inout float arg_9eee0, inout vec3 arg_226c4) {
    if (var_f8d0a.zLights[arg_4a614].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        return;
    }
    vec3 loc_48c8d = arg_226c4 - var_f8d0a.zLights[arg_4a614].position.xyz;
    vec3 loc_0ca8f = abs(loc_48c8d);
    bool loc_ab77c = loc_0ca8f.x >= loc_0ca8f.y;
    bool loc_ca7f9;
    if (loc_ab77c)
    {
        loc_ca7f9 = loc_0ca8f.x >= loc_0ca8f.z;
    }
    else
    {
        loc_ca7f9 = loc_ab77c;
    }
    if (loc_ca7f9)
    {
        loc_0ca8f = vec3(loc_0ca8f.y, loc_0ca8f.z, loc_0ca8f.x);
    }
    else
    {
        if (loc_0ca8f.y >= loc_0ca8f.z)
        {
            loc_0ca8f = vec3(loc_0ca8f.x, loc_0ca8f.z, loc_0ca8f.y);
        }
    }
    vec4 loc_e89cb = PointLightProj * vec4(loc_0ca8f, 1.0);
    loc_e89cb /= vec4(loc_e89cb.w);
    vec3 loc_2cd45 = loc_48c8d;
    bool loc_fe444 = abs(loc_2cd45.y) > abs(loc_2cd45.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_2cd45.y) > abs(loc_2cd45.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_2cd45.z *= (-1.0);
    }
    else
    {
        loc_2cd45.y *= (-1.0);
    }
    float loc_41e57;
    if (((textureLod(s_PointLightShadowTextureArray, vec4(loc_2cd45, float(var_f8d0a.zLights[arg_4a614].shadowProbeIndex)), 0.0).x * 2.0) - 1.0) >= loc_e89cb.z)
    {
        loc_41e57 = 1.0;
    }
    else
    {
        loc_41e57 = 0.0;
    }
    arg_9eee0 = loc_41e57;
}
void func_37ca4(inout int arg_ff970, inout float arg_43b7a, inout vec3 arg_0a2b9, inout vec3 arg_39715) {
    if (arg_ff970 < 0)
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    vec3 loc_55323 = var_f8d0a.zLights[arg_ff970].position.xyz - arg_39715;
    vec3 loc_757d0 = loc_55323;
    float loc_2b080;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        float loc_fe53a = (abs(loc_757d0.x) + abs(loc_757d0.y)) + abs(loc_757d0.z);
        loc_2b080 = loc_fe53a * loc_fe53a;
    }
    else
    {
        loc_2b080 = dot(loc_55323, loc_55323);
    }
    if (loc_2b080 >= (var_f8d0a.zLights[arg_ff970].position.w * var_f8d0a.zLights[arg_ff970].position.w))
    {
        arg_43b7a = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    float loc_b326d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        float loc_334de;
        func_c78d8(arg_ff970, loc_334de, arg_39715);
        loc_b326d = loc_334de;
    }
    else
    {
        loc_b326d = 1.0;
    }
    float loc_728c0 = loc_2b080 / ((var_f8d0a.zLights[arg_ff970].position.w * var_f8d0a.zLights[arg_ff970].position.w) + 9.9999997473787516355514526367188e-05);
    float loc_f4af9 = clamp(1.0 - (loc_728c0 * loc_728c0), 0.0, 1.0);
    float loc_7abdc = (1.0 / max(loc_2b080, 9.9999997473787516355514526367188e-05)) * (loc_f4af9 * loc_f4af9);
    float loc_5501b;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_5501b = loc_7abdc * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_7abdc) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_5501b = loc_7abdc;
    }
    arg_43b7a = loc_b326d;
    arg_0a2b9 = (var_f8d0a.zLights[arg_ff970].color.xyz * var_f8d0a.zLights[arg_ff970].color.w) * loc_5501b;
}
void func_2d333(inout vec3 arg_dc0ef, inout vec3 arg_96daa, inout vec3 arg_534d1, inout vec3 arg_81f82, inout float arg_1eba3, inout vec3 arg_1cde6, inout vec3 arg_3d3f7, inout vec3 arg_e7cf5) {
    bool loc_9f3ca;
    int loc_9b40b;
    int loc_fbf40;
    func_86391(arg_dc0ef, arg_96daa, loc_fbf40, loc_9b40b, loc_9f3ca);
    if (!loc_9f3ca)
    {
        arg_534d1 = vec3(0.0);
        return;
    }
    vec3 loc_ceaba;
    loc_ceaba = vec3(0.0);
    vec3 loc_3e87e;
    for (int loc_97a60 = loc_9b40b; loc_97a60 < loc_fbf40; loc_ceaba = loc_3e87e, loc_97a60++)
    {
        int loc_99f11 = int(var_dda85.zLightLookupArray[loc_97a60].lookup);
        if (loc_99f11 < 0)
        {
            break;
        }
        vec3 loc_102a3;
        float loc_b0161;
        func_37ca4(loc_99f11, loc_b0161, loc_102a3, arg_81f82);
        float loc_57b1f = (1.0 + (arg_1eba3 * arg_1eba3)) + ((2.0 * arg_1eba3) * dot(arg_1cde6, normalize((u_view * vec4(var_f8d0a.zLights[loc_99f11].position.xyz, 1.0)).xyz - arg_3d3f7)));
        loc_3e87e = loc_ceaba + (((arg_e7cf5 * ((0.079577468335628509521484375 * (1.0 - (arg_1eba3 * arg_1eba3))) / (loc_57b1f * sqrt(loc_57b1f)))) * loc_b0161) * loc_102a3);
    }
    arg_534d1 = loc_ceaba;
}
void func_c2c4e() {
    int loc_b5e48 = int(GlobalInvocationID.x);
    int loc_45941 = int(GlobalInvocationID.y);
    int loc_beae9 = int(GlobalInvocationID.z);
    if (((loc_b5e48 >= int(VolumeDimensions.x)) || (loc_45941 >= int(VolumeDimensions.y))) || (loc_beae9 >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_5d62d = ((vec3(float(loc_b5e48), float(loc_45941), float(loc_beae9)) + vec3(0.5)) + JitterOffset.xyz) / VolumeDimensions.xyz;
    vec3 loc_1fa0b = loc_5d62d;
    vec3 loc_777c2 = loc_5d62d;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_5d62d.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_04f2b = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_04f2b;
    vec3 loc_3ced2 = (u_view * vec4(loc_04f2b, 1.0)).xyz;
    vec2 loc_04947 = texelFetch(s_ScreenSpaceWaterFrontFaceDepthAndNormal, ivec2(loc_b5e48, loc_45941), 0).xy;
    float loc_e737b = smoothstep(-0.5, 0.5, ((((loc_1fa0b.z - loc_04947.x) * VolumeDimensions.z) * loc_04947.y) - CameraUnderwaterAndWaterSurfaceBiasAndFalloff.y) / CameraUnderwaterAndWaterSurfaceBiasAndFalloff.z);
    float loc_343cf;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_343cf = 1.0 - loc_e737b;
    }
    else
    {
        loc_343cf = loc_e737b;
    }
    vec4 loc_4397b;
    func_aa346(loc_04f2b, loc_4397b);
    vec4 loc_12f1c = loc_4397b;
    float loc_ebd19 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_42165 = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_343cf);
    float loc_1595d = length(loc_3ced2);
    float loc_ab2d8 = clamp((((loc_1595d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_b58be = mix(mix((AirAlbedoExtinction.xyz * loc_ebd19) * AirAlbedoExtinction.w, loc_4397b.xyz * loc_12f1c.w, vec3(loc_343cf)), vec3(0.0), vec3(loc_ab2d8));
    float loc_8068a = mix(mix(loc_ebd19 * AirAlbedoExtinction.w, loc_12f1c.w, loc_343cf), 0.0, loc_ab2d8);
    vec2 loc_3bb72 = AmbientContribution.xy;
    if (SkyAmbientSamplesConfig.x > 0.5)
    {
        vec3 loc_30e99 = loc_5d62d;
        loc_30e99.y = 1.0 - loc_30e99.y;
        if (SkyAmbientSamplesConfig.y > 0.5)
        {
            loc_30e99.z -= SkyAmbientSamplesConfig.z;
        }
        loc_30e99.z = (exp(4.0 * loc_30e99.z) - 1.0) * 0.0186573602259159088134765625;
        loc_3bb72 = textureLod(s_SkyAmbientSamples, loc_30e99, 0.0).xy;
    }
    vec3 loc_222bb = ((loc_b58be * 0.079577468335628509521484375) * max(((BlockBaseAmbientLightColorIntensity.xyz * loc_3bb72.x) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * loc_3bb72.y) * SkyAmbientLightColorIntensity.w), vec3(AmbientContribution.z))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    vec3 loc_fb58a = -(loc_3ced2 / vec3(loc_1595d));
    bool loc_5b439 = !(DirectionalLightSkyLightHeuristicToggles.y != 0.0);
    bool loc_7e26a;
    if (!loc_5b439)
    {
        loc_7e26a = abs(loc_3bb72.y) > 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_7e26a = loc_5b439;
    }
    vec3 loc_1bbb0;
    if (loc_7e26a)
    {
        float loc_af838;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            int loc_c0de4 = int(dot(clamp(CascadesPerSet, vec4(0.0), vec4(1.0)), vec4(1.0)));
            float loc_f6ac1;
            loc_f6ac1 = 1.0;
            int loc_d7178;
            float loc_484ee;
            for (int loc_8a709 = 0, loc_0e4f2 = 0; loc_8a709 < loc_c0de4; loc_0e4f2 = loc_d7178, loc_f6ac1 = loc_484ee, loc_8a709++)
            {
                int loc_79423 = min((loc_0e4f2 + int(CascadesPerSet[loc_8a709])), 8);
                loc_484ee = loc_f6ac1;
                loc_d7178 = loc_0e4f2;
                int loc_a0458;
                float loc_5399e;
                for (; loc_d7178 < loc_79423; loc_484ee = loc_5399e, loc_d7178 = loc_a0458)
                {
                    vec4 loc_0dca3 = CascadesShadowProj[loc_d7178] * vec4(loc_04f2b, 1.0);
                    vec3 loc_8d38c = abs(loc_0dca3.xyz);
                    bool loc_45980 = loc_8d38c.x <= 1.0;
                    bool loc_f1421;
                    if (loc_45980)
                    {
                        loc_f1421 = loc_8d38c.y <= 1.0;
                    }
                    else
                    {
                        loc_f1421 = loc_45980;
                    }
                    bool loc_e36b7;
                    if (loc_f1421)
                    {
                        loc_e36b7 = loc_8d38c.z <= 1.0;
                    }
                    else
                    {
                        loc_e36b7 = loc_f1421;
                    }
                    if (loc_e36b7)
                    {
                        vec4 loc_ada37 = loc_0dca3;
                        int loc_3a40c;
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_3a40c = 1;
                        }
                        else
                        {
                            loc_3a40c = clamp(int((CascadesParameters[loc_d7178].w * VolumeShadowSettings.x) + 0.5), 1, 9);
                        }
                        int loc_960ef = loc_3a40c / 2;
                        vec2 loc_445f6 = ((vec2(loc_ada37.x, loc_ada37.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_d7178].x;
                        float loc_4fba3 = (loc_ada37.z * 0.5) + 0.5;
                        loc_445f6.y += (1.0 - CascadesParameters[loc_d7178].x);
                        float loc_3555e;
                        loc_3555e = 0.0;
                        float loc_801c0;
                        for (int loc_15249 = 0; loc_15249 < loc_3a40c; loc_3555e = loc_801c0, loc_15249++)
                        {
                            loc_801c0 = loc_3555e;
                            float loc_30840;
                            for (int loc_963d2 = 0; loc_963d2 < loc_3a40c; loc_801c0 = loc_30840, loc_963d2++)
                            {
                                vec2 loc_cced5 = loc_445f6 + ((vec2(float(loc_963d2 - loc_960ef) + 0.5, float(loc_15249 - loc_960ef) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_d7178].x);
                                vec4 loc_fe3f0 = textureGather(s_ShadowCascades, vec3(loc_cced5, float(loc_d7178)));
                                vec4 loc_26b65 = loc_fe3f0;
                                if (QuantizationParameters.x != 0.0)
                                {
                                    loc_30840 = loc_801c0 + float(loc_26b65.w >= (loc_4fba3 - CascadesParameters[loc_d7178].y));
                                }
                                else
                                {
                                    vec4 loc_2f6b4 = step(vec4(loc_4fba3 - CascadesParameters[loc_d7178].y), loc_fe3f0);
                                    vec2 loc_e2aba = fract((loc_cced5 * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                    loc_30840 = loc_801c0 + mix(mix(loc_2f6b4.w, loc_2f6b4.z, loc_e2aba.x), mix(loc_2f6b4.x, loc_2f6b4.y, loc_e2aba.x), loc_e2aba.y);
                                }
                            }
                        }
                        loc_5399e = min(loc_484ee, loc_3555e / float(loc_3a40c * loc_3a40c));
                        loc_a0458 = loc_79423;
                    }
                    else
                    {
                        loc_5399e = loc_484ee;
                        loc_a0458 = loc_d7178 + 1;
                    }
                }
            }
            float loc_f828f;
            if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
            {
                float loc_ad066;
                func_e5e1e(loc_04f2b, loc_ad066);
                loc_f828f = loc_ad066;
            }
            else
            {
                loc_f828f = 1.0;
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
            float loc_4a190;
            if (loc_b7807)
            {
                vec4 loc_bcd0f = CloudShadowProj * vec4(loc_04f2b, 1.0);
                vec4 loc_6ef28 = loc_bcd0f;
                loc_6ef28 = loc_bcd0f / vec4(loc_6ef28.w);
                loc_6ef28.z -= (CascadesParameters[0].y / loc_6ef28.w);
                vec2 loc_76921 = ((vec2(loc_6ef28.x, loc_6ef28.y) * 0.5) + vec2(0.5)) * CascadesParameters[0].x;
                int loc_c86ff;
                if (QuantizationParameters.x != 0.0)
                {
                    loc_c86ff = 1;
                }
                else
                {
                    loc_c86ff = clamp(int((EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.z * VolumeShadowSettings.x) + 0.5), 1, 9);
                }
                int loc_7508d = loc_c86ff / 2;
                loc_6ef28.z = (loc_6ef28.z * 0.5) + 0.5;
                loc_76921.y += (1.0 - CascadesParameters[0].x);
                float loc_19cd0 = dot(CascadesPerSet, vec4(1.0));
                float loc_543e1;
                loc_543e1 = 0.0;
                float loc_0fce1;
                for (int loc_093cd = 0; loc_093cd < loc_c86ff; loc_543e1 = loc_0fce1, loc_093cd++)
                {
                    loc_0fce1 = loc_543e1;
                    float loc_16f2e;
                    for (int loc_fdb90 = 0; loc_fdb90 < loc_c86ff; loc_0fce1 = loc_16f2e, loc_fdb90++)
                    {
                        vec3 loc_d07c9 = vec3(loc_76921 + ((vec2(float(loc_fdb90 - loc_7508d) + 0.5, float(loc_093cd - loc_7508d) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[0].x), loc_19cd0);
                        if (QuantizationParameters.x != 0.0)
                        {
                            loc_16f2e = loc_0fce1 + float(textureLod(s_ShadowCascades, loc_d07c9, 0.0).x >= loc_6ef28.z);
                        }
                        else
                        {
                            vec4 loc_2ae6b = step(vec4(loc_6ef28.z), textureGather(s_ShadowCascades, loc_d07c9));
                            vec2 loc_52300 = fract((loc_d07c9.xy * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                            loc_16f2e = loc_0fce1 + mix(mix(loc_2ae6b.w, loc_2ae6b.z, loc_52300.x), mix(loc_2ae6b.x, loc_2ae6b.y, loc_52300.x), loc_52300.y);
                        }
                    }
                }
                float loc_8a60e = loc_543e1 / float(loc_c86ff * loc_c86ff);
                float loc_26602;
                if (loc_8a60e < 1.0)
                {
                    loc_26602 = min(1.0, max(loc_8a60e, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                }
                else
                {
                    loc_26602 = 1.0;
                }
                loc_4a190 = loc_26602;
            }
            else
            {
                loc_4a190 = 1.0;
            }
            loc_af838 = mix(min(loc_f6ac1, min(loc_f828f, loc_4a190)), 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - min(ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y * 0.100000001490116119384765625, 8.0)), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -0.0));
        }
        else
        {
            loc_af838 = 1.0;
        }
        float loc_768e3 = (1.0 + (loc_42165 * loc_42165)) + ((2.0 * loc_42165) * dot(loc_fb58a, normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_4de69 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_1bbb0 = loc_222bb + (((loc_b58be * loc_af838) * ((0.079577468335628509521484375 * (1.0 - (loc_42165 * loc_42165))) / (loc_768e3 * sqrt(loc_768e3)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_4de69.w));
    }
    else
    {
        loc_1bbb0 = loc_222bb;
    }
    vec3 loc_bf32c = loc_3ced2;
    float loc_8fec4;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        loc_8fec4 = (abs(loc_bf32c.x) + abs(loc_bf32c.y)) + abs(loc_bf32c.z);
    }
    else
    {
        loc_8fec4 = length(loc_3ced2);
    }
    bool loc_6ebf5 = PointLightDiffuseFadeOutParameters.x > 0.0;
    bool loc_49ba4 = !loc_6ebf5;
    bool loc_801c3;
    if (!loc_49ba4)
    {
        loc_801c3 = loc_6ebf5 && (loc_8fec4 < PointLightDiffuseFadeOutParameters.y);
    }
    else
    {
        loc_801c3 = loc_49ba4;
    }
    bool loc_15286 = VolumeScatteringEnabledAndPointLightVolumetricsEnabled.y != 0.0;
    bool loc_586db;
    if (loc_15286)
    {
        loc_586db = DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0;
    }
    else
    {
        loc_586db = loc_15286;
    }
    vec3 loc_0bece;
    if (loc_586db && loc_801c3)
    {
        vec3 loc_2a622 = loc_3ced2;
        vec3 loc_0e452;
        func_2d333(loc_2a622, loc_5d62d, loc_0e452, loc_04f2b, loc_42165, loc_fb58a, loc_3ced2, loc_b58be);
        loc_0bece = loc_1bbb0 + loc_0e452;
    }
    else
    {
        loc_0bece = loc_1bbb0;
    }
    if (TemporalSettings.x > 0.0)
    {
        vec3 loc_dfafd = (vec3(float(loc_b5e48), float(loc_45941), float(loc_beae9)) + vec3(0.5)) / VolumeDimensions.xyz;
        vec3 loc_e9300 = loc_dfafd;
        vec2 loc_9d396 = VolumeNearFar.xy;
        float loc_fcd55 = (exp(4.0 * loc_e9300.z) - 1.0) * 0.0186573602259159088134765625;
        vec4 loc_62495 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcd55) * loc_9d396.x) + (loc_fcd55 * loc_9d396.y)), 1.0);
        vec4 loc_d7f13 = u_invViewProj * vec4((loc_dfafd.xy * 2.0) - vec2(1.0), loc_62495.z / loc_62495.w, 1.0);
        vec4 loc_d1c9b = loc_d7f13;
        vec4 loc_bf151 = u_prevViewProj * vec4((loc_d7f13.xyz / vec3(loc_d1c9b.w)) - u_prevWorldPosOffset.xyz, 1.0);
        vec4 loc_d9ce7 = loc_bf151;
        vec3 loc_ec028 = loc_bf151.xyz / vec3(loc_d9ce7.w);
        vec2 loc_1fa2a = VolumeNearFar.xy;
        vec2 loc_81f33 = (loc_ec028.xy + vec2(1.0)) * 0.5;
        vec4 loc_3fd1f = PrevInvProj * vec4(loc_ec028, 1.0);
        float loc_d255f = loc_81f33.x;
        vec3 loc_33e20 = vec3(loc_d255f, loc_81f33.y, log((53.598148345947265625 * ((((-loc_3fd1f.z) / loc_3fd1f.w) - loc_1fa2a.x) / (loc_1fa2a.y - loc_1fa2a.x))) + 1.0) * 0.25);
        ivec3 loc_dbdb4 = ivec3(VolumeDimensions.xyz);
        ivec3 loc_57985 = loc_dbdb4;
        vec3 loc_96ba4 = loc_33e20;
        float loc_53f43 = (loc_96ba4.z * float(loc_57985.z)) - 0.5;
        int loc_25a80 = clamp(int(loc_53f43), 0, loc_57985.z - 2);
        vec3 loc_34735 = VolumeDimensions.xyz * loc_33e20;
        imageStore(s_CurrentLightingBuffer, ivec3(loc_b5e48, loc_45941, loc_beae9), mix(vec4(loc_0bece, loc_8068a), mix(textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80)), 0.0), textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80 + 1)), 0.0), vec4(clamp(loc_53f43 - float(loc_25a80), 0.0, 1.0))), vec4(mix(TemporalSettings.z, 0.0, clamp(length(clamp(loc_34735, vec3(0.0), vec3(loc_dbdb4)) - loc_34735) * TemporalSettings.y, 0.0, 1.0)))));
    }
    else
    {
        imageStore(s_CurrentLightingBuffer, ivec3(loc_b5e48, loc_45941, loc_beae9), vec4(loc_0bece, loc_8068a));
    }
}
#endif
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
#ifdef POINT_LIGHT_SHADING__OFF
    func_73158();
#endif
#ifdef POINT_LIGHT_SHADING__ON
    func_c2c4e();
#endif
}
