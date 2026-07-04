#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - POPULATE_PASS (not used)
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
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - layout(binding = 4, std430) buffer s_zBiomeInfoBufferBuffer { BiomeInfo s_zBiomeInfoBuffer[]; };
* - layout(binding = 7, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 8, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform mat4 DirectionalLightSourceCausticsViewProj;
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
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TemporalSettings;
* - uniform vec4 Time;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 VolumeShadowSettings;
* - uniform vec4 WaterAlbedoExtinction;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WorldOrigin;
*/

#extension GL_EXT_texture_cube_map_array : require
#ifdef THREAD_LIMIT__LIMITED_AT128
layout(local_size_x = 8, local_size_y = 8, local_size_z = 2) in;
#endif
#ifdef THREAD_LIMIT__LIMITED_AT256
layout(local_size_x = 8, local_size_y = 8, local_size_z = 4) in;
#endif
#ifdef THREAD_LIMIT__NATIVE
layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;
#endif
struct Light {
    vec4 position;
    vec4 color;
    int shadowProbeIndex;
    int pad0;
    int pad1;
    int pad2;
};

struct LightData {
    float lookup;
};

layout(binding = 8, std430) buffer s_zLights { Light zLights[]; } var_46109;
layout(binding = 7, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_83483;
layout(location = 0, binding = 0, rgba16f) uniform writeonly highp image2DArray s_CurrentLightingBuffer;
uniform highp sampler2D s_ScreenSpaceWaterFrontFaceDepthAndNormal;
uniform highp sampler2DArray s_PreviousLightingBuffer;
uniform highp sampler2DArray s_ShadowCascades;
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
uniform mat4 CascadesShadowProj[8];
uniform mat4 CloudShadowProj;
uniform mat4 PlayerShadowProj;
uniform mat4 PointLightProj;
uniform mat4 PrevInvProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 AirAlbedoExtinction;
uniform vec4 AmbientContribution;
uniform vec4 BlockBaseAmbientLightColorIntensity;
uniform vec4 CameraUnderwaterAndWaterSurfaceBiasAndFalloff;
uniform vec4 CascadesParameters[8];
uniform vec4 CascadesPerSet;
uniform vec4 CloudShadowsVisible;
uniform vec4 ClusterDepthBounds;
uniform vec4 ClusterDimensions;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 ClusterSize;
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
uniform vec4 ManhattanDistAttenuationEnabled;
uniform vec4 PointLightAttenuationWindow;
uniform vec4 PointLightAttenuationWindowEnabled;
uniform vec4 PointLightDiffuseFadeOutParameters;
uniform vec4 QuantizationParameters;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
uniform vec4 SkyAmbientLightColorIntensity;
uniform vec4 TemporalSettings;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform vec4 VolumeShadowSettings;
uniform vec4 WaterAlbedoExtinction;
uniform vec4 u_prevWorldPosOffset;
int var_e7b23;
void func_c5000(inout vec4 arg_4ca8e, inout int arg_6e576, inout vec3 arg_0d628, inout bool arg_5e3ed) {
    arg_4ca8e = CascadesShadowProj[arg_6e576] * vec4(arg_0d628, 1.0);
    vec4 loc_88439 = arg_4ca8e;
    bool loc_3c9c6 = loc_88439.x >= (-1.0);
    bool loc_b786b;
    if (loc_3c9c6)
    {
        loc_b786b = loc_88439.x <= 1.0;
    }
    else
    {
        loc_b786b = loc_3c9c6;
    }
    bool loc_537c4;
    if (loc_b786b)
    {
        loc_537c4 = loc_88439.y >= (-1.0);
    }
    else
    {
        loc_537c4 = loc_b786b;
    }
    bool loc_32c46;
    if (loc_537c4)
    {
        loc_32c46 = loc_88439.y <= 1.0;
    }
    else
    {
        loc_32c46 = loc_537c4;
    }
    bool loc_88a47;
    if (loc_32c46)
    {
        loc_88a47 = loc_88439.z >= (-1.0);
    }
    else
    {
        loc_88a47 = loc_32c46;
    }
    bool loc_7078d;
    if (loc_88a47)
    {
        loc_7078d = loc_88439.z <= 1.0;
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
    if (var_46109.zLights[arg_4a614].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        return;
    }
    vec3 loc_48c8d = arg_226c4 - var_46109.zLights[arg_4a614].position.xyz;
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
    if (((textureLod(s_PointLightShadowTextureArray, vec4(loc_2cd45, float(var_46109.zLights[arg_4a614].shadowProbeIndex)), 0.0).x * 2.0) - 1.0) >= loc_e89cb.z)
    {
        loc_41e57 = 1.0;
    }
    else
    {
        loc_41e57 = 0.0;
    }
    arg_9eee0 = loc_41e57;
}
void func_89655(inout int arg_604fd, inout float arg_43b7a, inout vec3 arg_ec226, inout vec3 arg_39715) {
    if (arg_604fd < 0)
    {
        arg_43b7a = 1.0;
        arg_ec226 = vec3(0.0);
        return;
    }
    vec3 loc_55323 = var_46109.zLights[arg_604fd].position.xyz - arg_39715;
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
    if (loc_2b080 >= (var_46109.zLights[arg_604fd].position.w * var_46109.zLights[arg_604fd].position.w))
    {
        arg_43b7a = 1.0;
        arg_ec226 = vec3(0.0);
        return;
    }
    float loc_b326d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        float loc_334de;
        func_c78d8(arg_604fd, loc_334de, arg_39715);
        loc_b326d = loc_334de;
    }
    else
    {
        loc_b326d = 1.0;
    }
    float loc_728c0 = loc_2b080 / ((var_46109.zLights[arg_604fd].position.w * var_46109.zLights[arg_604fd].position.w) + 9.9999997473787516355514526367188e-05);
    float loc_f4af9 = clamp(1.0 - (loc_728c0 * loc_728c0), 0.0, 1.0);
    float loc_7abdc = (1.0 / max(loc_2b080, 9.9999997473787516355514526367188e-05)) * (loc_f4af9 * loc_f4af9);
    float loc_5b8ec;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_5b8ec = loc_7abdc * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_7abdc) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_5b8ec = loc_7abdc;
    }
    arg_43b7a = loc_b326d;
    arg_ec226 = ((var_46109.zLights[arg_604fd].color.xyz * var_46109.zLights[arg_604fd].color.w) * loc_5b8ec) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
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
        int loc_99f11 = int(var_83483.zLightLookupArray[loc_97a60].lookup);
        if (loc_99f11 < 0)
        {
            break;
        }
        vec3 loc_102a3;
        float loc_b0161;
        func_89655(loc_99f11, loc_b0161, loc_102a3, arg_81f82);
        float loc_57b1f = (1.0 + (arg_1eba3 * arg_1eba3)) + ((2.0 * arg_1eba3) * dot(arg_1cde6, normalize((u_view * vec4(var_46109.zLights[loc_99f11].position.xyz, 1.0)).xyz - arg_3d3f7)));
        loc_3e87e = loc_ceaba + (((arg_e7cf5 * ((0.079577468335628509521484375 * (1.0 - (arg_1eba3 * arg_1eba3))) / (loc_57b1f * sqrt(loc_57b1f)))) * loc_b0161) * loc_102a3);
    }
    arg_534d1 = loc_ceaba;
}
void func_823f7() {
    int loc_b5e48 = int(GlobalInvocationID.x);
    int loc_45941 = int(GlobalInvocationID.y);
    int loc_beae9 = int(GlobalInvocationID.z);
    if (((loc_b5e48 >= int(VolumeDimensions.x)) || (loc_45941 >= int(VolumeDimensions.y))) || (loc_beae9 >= int(VolumeDimensions.z)))
    {
        return;
    }
    vec3 loc_6e675 = ((vec3(float(loc_b5e48), float(loc_45941), float(loc_beae9)) + vec3(0.5)) + JitterOffset.xyz) / VolumeDimensions.xyz;
    vec3 loc_1fa0b = loc_6e675;
    vec3 loc_777c2 = loc_6e675;
    vec2 loc_b796d = VolumeNearFar.xy;
    float loc_fcce6 = (exp(4.0 * loc_777c2.z) - 1.0) * 0.0186573602259159088134765625;
    vec4 loc_fbb16 = u_proj * vec4(0.0, 0.0, -(((1.0 - loc_fcce6) * loc_b796d.x) + (loc_fcce6 * loc_b796d.y)), 1.0);
    vec4 loc_e8a8c = u_invViewProj * vec4((loc_6e675.xy * 2.0) - vec2(1.0), loc_fbb16.z / loc_fbb16.w, 1.0);
    vec4 loc_dc33a = loc_e8a8c;
    vec3 loc_3d180 = loc_e8a8c.xyz / vec3(loc_dc33a.w);
    vec3 loc_45310 = loc_3d180;
    vec3 loc_3ced2 = (u_view * vec4(loc_3d180, 1.0)).xyz;
    vec2 loc_04947 = texelFetch(s_ScreenSpaceWaterFrontFaceDepthAndNormal, ivec2(loc_b5e48, loc_45941), 0).xy;
    float loc_e737b = smoothstep(-0.5, 0.5, ((((loc_1fa0b.z - loc_04947.x) * VolumeDimensions.z) * loc_04947.y) - CameraUnderwaterAndWaterSurfaceBiasAndFalloff.y) / CameraUnderwaterAndWaterSurfaceBiasAndFalloff.z);
    float loc_ac022;
    if (CameraUnderwaterAndWaterSurfaceBiasAndFalloff.x != 0.0)
    {
        loc_ac022 = 1.0 - loc_e737b;
    }
    else
    {
        loc_ac022 = loc_e737b;
    }
    float loc_305d0 = clamp((HeightFogScaleBias.x * loc_45310.y) + HeightFogScaleBias.y, 0.0, 1.0);
    float loc_42165 = mix(HenyeyGreensteinG.x, HenyeyGreensteinG.y, loc_ac022);
    float loc_1595d = length(loc_3ced2);
    float loc_cc74f = clamp((((loc_1595d / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0);
    vec3 loc_44b99 = mix(mix((AirAlbedoExtinction.xyz * loc_305d0) * AirAlbedoExtinction.w, WaterAlbedoExtinction.xyz * WaterAlbedoExtinction.w, vec3(loc_ac022)), vec3(0.0), vec3(loc_cc74f));
    float loc_cf02a = mix(mix(loc_305d0 * AirAlbedoExtinction.w, WaterAlbedoExtinction.w, loc_ac022), 0.0, loc_cc74f);
    vec3 loc_23221 = ((loc_44b99 * 0.079577468335628509521484375) * max(((BlockBaseAmbientLightColorIntensity.xyz * AmbientContribution.x) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * AmbientContribution.y) * SkyAmbientLightColorIntensity.w), vec3(AmbientContribution.z))) * DiffuseSpecularEmissiveAmbientTermToggles.w;
    vec3 loc_fb58a = -(loc_3ced2 / vec3(loc_1595d));
    bool loc_5b439 = !(DirectionalLightSkyLightHeuristicToggles.y != 0.0);
    bool loc_bc4cf;
    if (!loc_5b439)
    {
        loc_bc4cf = abs(AmbientContribution.y) > 9.9999997473787516355514526367188e-05;
    }
    else
    {
        loc_bc4cf = loc_5b439;
    }
    vec3 loc_1bbb0;
    if (loc_bc4cf)
    {
        float loc_ea5df;
        if (int(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.x) == 1)
        {
            float loc_6be82;
            loc_6be82 = 1.0;
            int loc_14db9;
            float loc_be824;
            for (int loc_94040 = 0, loc_163a5 = 0; loc_94040 < 4; loc_163a5 = loc_14db9, loc_6be82 = loc_be824, loc_94040++)
            {
                int loc_a48fd = int(CascadesPerSet[loc_94040]);
                for (int loc_bc103 = 0; loc_bc103 < loc_a48fd; loc_bc103++)
                {
                    int loc_c36a6 = loc_163a5 + loc_bc103;
                    if (loc_c36a6 >= 8)
                    {
                        loc_be824 = loc_6be82;
                        break;
                    }
                    vec4 loc_adb0c;
                    bool loc_717f9;
                    func_c5000(loc_adb0c, loc_c36a6, loc_3d180, loc_717f9);
                    vec4 loc_be452 = loc_adb0c;
                    if (!loc_717f9)
                    {
                        continue;
                    }
                    int loc_f902c;
                    if (QuantizationParameters.x != 0.0)
                    {
                        loc_f902c = 1;
                    }
                    else
                    {
                        loc_f902c = clamp(int((CascadesParameters[loc_c36a6].w * VolumeShadowSettings.x) + 0.5), 1, 9);
                    }
                    int loc_35619 = loc_f902c / 2;
                    vec2 loc_4f4b1 = ((vec2(loc_be452.x, loc_be452.y) * 0.5) + vec2(0.5)) * CascadesParameters[loc_c36a6].x;
                    float loc_6cb97 = (loc_be452.z * 0.5) + 0.5;
                    loc_4f4b1.y += (1.0 - CascadesParameters[loc_c36a6].x);
                    float loc_23a52;
                    loc_23a52 = 0.0;
                    float loc_02409;
                    for (int loc_60213 = 0; loc_60213 < loc_f902c; loc_23a52 = loc_02409, loc_60213++)
                    {
                        loc_02409 = loc_23a52;
                        float loc_e7504;
                        for (int loc_b0778 = 0; loc_b0778 < loc_f902c; loc_02409 = loc_e7504, loc_b0778++)
                        {
                            vec2 loc_ff11f = loc_4f4b1 + ((vec2(float(loc_b0778 - loc_35619) + 0.5, float(loc_60213 - loc_35619) + 0.5) * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.x) * CascadesParameters[loc_c36a6].x);
                            vec4 loc_3ce11 = textureGather(s_ShadowCascades, vec3(loc_ff11f, float(loc_c36a6)));
                            vec4 loc_8c59a = loc_3ce11;
                            if (QuantizationParameters.x != 0.0)
                            {
                                loc_e7504 = loc_02409 + float(loc_8c59a.w >= (loc_6cb97 - CascadesParameters[loc_c36a6].y));
                            }
                            else
                            {
                                vec4 loc_5b947 = step(vec4(loc_6cb97 - CascadesParameters[loc_c36a6].y), loc_3ce11);
                                vec2 loc_df983 = fract((loc_ff11f * ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.z) + vec2(0.5));
                                loc_e7504 = loc_02409 + mix(mix(loc_5b947.w, loc_5b947.z, loc_df983.x), mix(loc_5b947.x, loc_5b947.y, loc_df983.x), loc_df983.y);
                            }
                        }
                    }
                    loc_be824 = min(loc_6be82, loc_23a52 / float(loc_f902c * loc_f902c));
                    break;
                }
                loc_14db9 = loc_163a5 + loc_a48fd;
            }
            float loc_e6f42;
            if (int(FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions.x) > 0)
            {
                float loc_79d07;
                func_e5e1e(loc_3d180, loc_79d07);
                loc_e6f42 = min(loc_6be82, loc_79d07);
            }
            else
            {
                loc_e6f42 = loc_6be82;
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
            float loc_25f1a;
            if (loc_b7807)
            {
                vec4 loc_bcd0f = CloudShadowProj * vec4(loc_3d180, 1.0);
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
                float loc_fdf67 = loc_543e1 / float(loc_c86ff * loc_c86ff);
                float loc_890cf;
                if (loc_fdf67 < 1.0)
                {
                    loc_890cf = min(loc_e6f42, max(loc_fdf67, 1.0 - EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution.w));
                }
                else
                {
                    loc_890cf = loc_e6f42;
                }
                loc_25f1a = loc_890cf;
            }
            else
            {
                loc_25f1a = loc_e6f42;
            }
            loc_ea5df = mix(loc_25f1a, 1.0, smoothstep(max(0.0, ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y - 8.0), ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength.y, -0.0));
        }
        else
        {
            loc_ea5df = 1.0;
        }
        float loc_768e3 = (1.0 + (loc_42165 * loc_42165)) + ((2.0 * loc_42165) * dot(loc_fb58a, normalize((u_view * DirectionalLightSourceWorldSpaceDirection).xyz)));
        vec4 loc_4de69 = DirectionalLightSourceDiffuseColorAndIlluminance;
        loc_1bbb0 = loc_23221 + (((loc_44b99 * loc_ea5df) * ((0.079577468335628509521484375 * (1.0 - (loc_42165 * loc_42165))) / (loc_768e3 * sqrt(loc_768e3)))) * (DirectionalLightSourceDiffuseColorAndIlluminance.xyz * loc_4de69.w));
    }
    else
    {
        loc_1bbb0 = loc_23221;
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
        func_2d333(loc_2a622, loc_6e675, loc_0e452, loc_3d180, loc_42165, loc_fb58a, loc_3ced2, loc_44b99);
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
        imageStore(s_CurrentLightingBuffer, ivec3(loc_b5e48, loc_45941, loc_beae9), mix(vec4(loc_0bece, loc_cf02a), mix(textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80)), 0.0), textureLod(s_PreviousLightingBuffer, vec3(loc_d255f, loc_81f33.y, float(loc_25a80 + 1)), 0.0), vec4(clamp(loc_53f43 - float(loc_25a80), 0.0, 1.0))), vec4(mix(TemporalSettings.z, 0.0, clamp(length(clamp(loc_34735, vec3(0.0), vec3(loc_dbdb4)) - loc_34735) * TemporalSettings.y, 0.0, 1.0)))));
    }
    else
    {
        imageStore(s_CurrentLightingBuffer, ivec3(loc_b5e48, loc_45941, loc_beae9), vec4(loc_0bece, loc_cf02a));
    }
}
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    func_823f7();
}
