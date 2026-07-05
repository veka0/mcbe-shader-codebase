#version 310 es

/*
* Available Macros:
*
* Passes:
* - CAUSTICS_MULTIPLIER_PASS (not used)
* - DIRECTIONAL_LIGHTING_PASS (not used)
* - DIRECTIONAL_LIGHTING_PASS0_PASS (not used)
* - DIRECTIONAL_LIGHTING_PASS1_PASS (not used)
* - DISCRETE_INDIRECT_COMBINED_LIGHTING_PASS (not used)
* - FALLBACK_PASS (not used)
* - SURFACE_RADIANCE_UPSCALE_PASS (not used)
* - TILE_CLASSIFICATION_PASS (not used)
*
* PointLightShading:
* - POINT_LIGHT_SHADING__OFF
* - POINT_LIGHT_SHADING__ON
*
* Upscaling:
* - UPSCALING__OFF (not used)
* - UPSCALING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_CausticsMultiplier;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_DiffuseLighting;
* - uniform lowp usampler2D s_EmissiveAmbientLinearRoughness;
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_NormalsAndDepthLighting;
* - uniform lowp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform lowp sampler2D s_SpecularLighting;
* - layout(binding = 14, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 15, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 DownsampleResolutionAndRecipResolution;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 LightingUpscaleParams;
* - uniform vec4 ManhattanDistAttenuationEnabled;
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
* - uniform vec4 SceneResolutionAndRecipResolution;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkySamplesConfig;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 TilingParams;
* - uniform vec4 Time;
* - uniform vec4 UndergroundFogColor;
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

#ifdef POINT_LIGHT_SHADING__ON
#extension GL_EXT_texture_cube_map_array : require
#endif
precision mediump float;
precision highp int;
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
layout(binding = 15, std430) buffer s_zLights { Light zLights[]; } var_24243;
layout(binding = 14, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_ad843;
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
#endif
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_SceneDepth;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
#endif
uniform highp usampler2D s_EmissiveAmbientLinearRoughness;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 ClusterDepthBounds;
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
#endif
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightNdLFloor;
uniform highp vec4 PointLightPreCalcValues;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
#endif
uniform highp vec4 SceneResolutionAndRecipResolution;
uniform highp vec4 SkyAmbientLightColorIntensity;
#ifdef POINT_LIGHT_SHADING__ON
uniform highp vec4 SubPixelOffset;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 WorldOrigin;
#endif
in highp vec3 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
#ifdef POINT_LIGHT_SHADING__ON
void func_9b87e(inout highp vec3 arg_3007f, inout highp vec3 arg_87bd1) {
    if (ColorGrading_OptimizeGammaCorrection.x != 0.0)
    {
        arg_3007f = pow(max(arg_87bd1, vec3(0.0)), vec3(2.2000000476837158203125));
        return;
    }
    else
    {
        highp vec3 loc_407b7 = arg_87bd1;
        highp vec3 loc_67ff9 = arg_87bd1 * vec3(0.077399380505084991455078125);
        highp vec3 loc_b63b1 = pow((arg_87bd1 + vec3(0.054999999701976776123046875)) * vec3(0.947867333889007568359375), vec3(2.400000095367431640625));
        highp float loc_e81ff;
        if (loc_407b7.x <= 0.040449999272823333740234375)
        {
            loc_e81ff = loc_67ff9.x;
        }
        else
        {
            loc_e81ff = loc_b63b1.x;
        }
        loc_407b7.x = loc_e81ff;
        highp float loc_007b0;
        if (loc_407b7.y <= 0.040449999272823333740234375)
        {
            loc_007b0 = loc_67ff9.y;
        }
        else
        {
            loc_007b0 = loc_b63b1.y;
        }
        loc_407b7.y = loc_007b0;
        highp float loc_fa4a6;
        if (loc_407b7.z <= 0.040449999272823333740234375)
        {
            loc_fa4a6 = loc_67ff9.z;
        }
        else
        {
            loc_fa4a6 = loc_b63b1.z;
        }
        loc_407b7.z = loc_fa4a6;
        arg_3007f = loc_407b7;
        return;
    }
}
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
    if (var_24243.zLights[arg_826b5].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        arg_6b488 = 1.0;
        return;
    }
    highp vec3 loc_44ea9 = arg_aee55 - var_24243.zLights[arg_826b5].position.xyz;
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
    highp float loc_e670f = (textureLod(s_PointLightShadowTextureArray, vec4(loc_f715f, float(var_24243.zLights[arg_826b5].shadowProbeIndex)), 0.0).x * 2.0) - 1.0;
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
void func_b155c(inout highp vec4 arg_e84ec, inout int arg_0b9bc, inout highp float arg_43b7a, inout highp float arg_7f337, inout highp vec3 arg_0a2b9, inout highp vec3 arg_29ac4, inout highp vec3 arg_f6a53, inout highp vec3 arg_4f9dc, inout highp float arg_8bccf) {
    arg_e84ec = vec4(0.0);
    if (arg_0b9bc < 0)
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_0a2b9 = vec3(0.0);
        return;
    }
    highp vec3 loc_8dfd7 = var_24243.zLights[arg_0b9bc].position.xyz - arg_29ac4;
    highp vec3 loc_8cb9b = loc_8dfd7;
    highp float loc_9eb1a;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_9eb1a = loc_1829d * loc_1829d;
    }
    else
    {
        loc_9eb1a = dot(loc_8dfd7, loc_8dfd7);
    }
    if (loc_9eb1a >= (var_24243.zLights[arg_0b9bc].position.w * var_24243.zLights[arg_0b9bc].position.w))
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
        func_bbb6d(arg_0b9bc, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_a011d = loc_b2a04;
        loc_cddfe = loc_412fd;
    }
    else
    {
        loc_a011d = 1.0;
        loc_cddfe = 1.0;
    }
    highp float loc_4c5a5 = loc_9eb1a / ((var_24243.zLights[arg_0b9bc].position.w * var_24243.zLights[arg_0b9bc].position.w) + 9.9999997473787516355514526367188e-05);
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
        highp vec3 loc_8226d = var_24243.zLights[arg_0b9bc].color.xyz * loc_219c5;
        arg_e84ec = vec4(loc_8226d.x, loc_8226d.y, loc_8226d.z, arg_e84ec.w);
        arg_e84ec.w = 1.0 - (loc_9eb1a / ((var_24243.zLights[arg_0b9bc].position.w * var_24243.zLights[arg_0b9bc].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_0a2b9 = (var_24243.zLights[arg_0b9bc].color.xyz * var_24243.zLights[arg_0b9bc].color.w) * loc_219c5;
}
void func_26bee(inout highp vec3 arg_33c3b, inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec4 arg_fadf1, inout highp vec3 arg_efe4b, inout highp vec3 arg_81f79, inout highp vec2 arg_92c2f, inout highp vec3 arg_58ffc, inout highp float arg_d96ac, inout highp vec3 arg_e6b36, inout highp vec3 arg_b8e73, inout highp vec3 arg_775e2, inout highp float arg_bfa42) {
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
    highp vec4 loc_2348f;
    for (int loc_86630 = loc_490eb; loc_86630 < loc_c476d; loc_b9311 = loc_bfd6d, loc_45a05 = loc_50935, loc_a55d6 = loc_96e3a, loc_86630++)
    {
        int loc_dbe64 = int(var_ad843.zLightLookupArray[loc_86630].lookup);
        if (loc_dbe64 < 0)
        {
            break;
        }
        highp vec3 loc_ed90f = normalize((u_view * vec4(var_24243.zLights[loc_dbe64].position.xyz, 1.0)).xyz - arg_33c3b);
        highp float loc_1e1bf = max(dot(arg_efe4b, loc_ed90f), 0.0);
        highp float loc_af6fd = max(dot(arg_efe4b, arg_81f79), 0.0);
        highp float loc_2d61b = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp float loc_c20a0 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
        highp vec3 loc_a125f = normalize(loc_ed90f + arg_81f79);
        highp float loc_69c3d = max(arg_92c2f.x, 0.0500000007450580596923828125);
        highp float loc_a68f1 = loc_69c3d * loc_69c3d;
        highp float loc_ad517 = loc_a68f1 * loc_a68f1;
        highp float loc_cd10e = max(dot(arg_efe4b, loc_a125f), 0.0);
        highp float loc_6be3a = (((loc_ad517 - 1.0) * loc_cd10e) * loc_cd10e) + 1.0;
        highp float loc_ad7fb = loc_a68f1 * 0.5;
        highp float loc_00ee9 = clamp(1.0 - max(dot(arg_81f79, loc_a125f), 0.0), 0.0, 1.0);
        highp float loc_a177b = loc_00ee9 * loc_00ee9;
        highp vec3 loc_d5257 = arg_58ffc + ((vec3(1.0) - arg_58ffc) * ((loc_a177b * loc_a177b) * loc_00ee9));
        highp vec3 loc_ec1c7 = vec3(1.0) * (1.0 - arg_d96ac);
        highp vec4 loc_55c3a = vec4(0.0);
        highp vec3 loc_49548;
        highp float loc_bbe0d;
        highp float loc_0721a;
        func_b155c(loc_2348f, loc_dbe64, loc_0721a, loc_bbe0d, loc_49548, arg_e6b36, arg_b8e73, arg_775e2, arg_bfa42);
        loc_55c3a = loc_2348f;
        highp vec3 loc_ef49b = loc_a468d.xyz + loc_2348f.xyz;
        loc_a468d = vec4(loc_ef49b.x, loc_ef49b.y, loc_ef49b.z, loc_a468d.w);
        loc_96e3a = loc_a55d6 + loc_55c3a.w;
        loc_50935 = loc_45a05 + (((((((vec3(1.0) - loc_d5257) * mix(loc_1e1bf, max((dot(arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2d61b * loc_2d61b), 0.0), arg_bfa42)) * (loc_ec1c7 * vec3(0.3183098733425140380859375))) * loc_bbe0d) + (((loc_ec1c7 * vec3(0.3183098733425140380859375)) * (arg_bfa42 * max((dot(-arg_efe4b, loc_ed90f) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_c20a0 * loc_c20a0), 0.0))) * loc_0721a)) * loc_49548) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_bfd6d = loc_b9311 + (((((((loc_d5257 * (loc_ad517 / ((loc_6be3a * loc_6be3a) * 3.1415927410125732421875))) * ((loc_af6fd / (((loc_af6fd * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)) * (loc_1e1bf / (((loc_1e1bf * (1.0 - loc_ad7fb)) + loc_ad7fb) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_1e1bf) * loc_af6fd) + 9.9999997473787516355514526367188e-05)) * loc_1e1bf) * loc_bbe0d) * loc_49548) * DiffuseSpecularEmissiveAmbientTermToggles.y);
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
void func_4f458(inout highp vec3 arg_534d1, inout highp vec3 arg_90b60, inout highp vec4 arg_d4ca2, inout highp vec3 arg_229fe, inout highp vec3 arg_29328, inout highp vec3 arg_c3199, inout highp vec3 arg_68647, inout highp vec3 arg_6f73b, inout highp vec3 arg_56f56, inout highp vec3 arg_9c753, inout highp vec2 arg_a995c, inout highp vec3 arg_7e9dc, inout highp float arg_4e72a, inout highp vec3 arg_602b8, inout highp float arg_15153) {
    if (!(DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z != 0.0))
    {
        arg_534d1 = vec3(0.0);
        arg_90b60 = vec3(0.0);
        arg_d4ca2 = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }
    highp vec3 loc_62dd1;
    if (int(QuantizationParameters.y) > 0)
    {
        loc_62dd1 = (arg_229fe + (arg_29328 - (arg_c3199 * dot(arg_29328, arg_c3199)))) + WorldOrigin.xyz;
    }
    else
    {
        loc_62dd1 = arg_68647;
    }
    highp vec4 loc_750c4;
    highp vec3 loc_46c24;
    highp vec3 loc_5ded5;
    func_26bee(arg_6f73b, loc_5ded5, loc_46c24, loc_750c4, arg_56f56, arg_9c753, arg_a995c, arg_7e9dc, arg_4e72a, arg_68647, loc_62dd1, arg_602b8, arg_15153);
    arg_534d1 = loc_5ded5;
    arg_90b60 = loc_46c24;
    arg_d4ca2 = loc_750c4;
}
#endif
void main() {
    highp vec2 var_1b7e9 = (floor(v_texcoord0.xy * SceneResolutionAndRecipResolution.xy) + vec2(0.5)) * SceneResolutionAndRecipResolution.zw;
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_af032 = texture(s_Normal, var_1b7e9.xy);
#endif
#ifdef POINT_LIGHT_SHADING__OFF
    highp vec2 var_9279d = var_1b7e9.xy;
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec2 var_0d5fa = var_af032.xy;
    highp vec2 var_9279d = var_1b7e9.xy;
    highp vec4 var_4435a = texture(s_SceneDepth, var_1b7e9.xy);
    highp float var_88b76 = (var_4435a.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_88b76, 1.0);
    highp mat4 var_4fa47 = u_invProj;
    highp mat4 var_498b7 = u_invProj;
    highp mat4 var_4882d = u_invProj;
    highp mat4 var_78c1b = u_invProj;
    highp mat4 var_40575 = u_invProj;
    highp float var_eb413 = var_df846.x;
    highp float var_ac116 = var_df846.y;
    highp float var_f2b7c = var_df846.w;
    highp float var_0357c = var_df846.z;
    highp float var_2c821 = var_df846.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_4fa47[0].x, var_ac116 * var_498b7[1].y, var_f2b7c * var_4882d[3].z, (var_0357c * var_78c1b[2].w) + (var_2c821 * var_40575[3].w));
    var_df846 = var_9666f;
    highp float var_d799e = var_df846.w;
    highp vec4 var_20845 = var_9666f / vec4(var_d799e);
    var_df846 = var_20845;
    highp vec4 var_1c342 = vec4(v_projPosition.xy + vec2(SubPixelOffset.x, -SubPixelOffset.y), var_88b76, 1.0);
    highp mat4 var_2949d = u_invProj;
    highp mat4 var_e6914 = u_invProj;
    highp mat4 var_164c7 = u_invProj;
    highp mat4 var_b5866 = u_invProj;
    highp mat4 var_bb46a = u_invProj;
    highp float var_a6256 = var_1c342.x;
    highp float var_05401 = var_1c342.y;
    highp float var_b8669 = var_1c342.w;
    highp float var_259fc = var_1c342.z;
    highp float var_f8db3 = var_1c342.w;
    highp vec4 var_fa2eb = vec4(var_a6256 * var_2949d[0].x, var_05401 * var_e6914[1].y, var_b8669 * var_164c7[3].z, (var_259fc * var_b5866[2].w) + (var_f8db3 * var_bb46a[3].w));
    var_1c342 = var_fa2eb;
    highp float var_f7138 = var_1c342.w;
    highp vec4 var_3ee7d = var_fa2eb / vec4(var_f7138);
    var_1c342 = var_3ee7d;
    highp vec3 var_c0220 = (u_invView * vec4(var_3ee7d.xyz, 1.0)).xyz - WorldOrigin.xyz;
    highp vec3 var_c6246 = var_3ee7d.xyz;
    highp vec3 var_0dd5c = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_c6246)), normalize(dFdy(var_c6246)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_2bcf8 = vec3(QuantizationParameters.z * 0.5) - mod(var_c0220, vec3(QuantizationParameters.z));
    highp vec2 var_3ccf7 = var_0d5fa;
    highp vec3 var_b0cb0 = vec3(var_af032.xy, (1.0 - abs(var_3ccf7.x)) - abs(var_3ccf7.y));
    highp vec2 var_c65e0;
    if (var_b0cb0.z < 0.0)
    {
        var_c65e0 = (vec2(1.0) - abs(var_b0cb0.yx)) * ((step(vec2(0.0), var_b0cb0.xy) * 2.0) - vec2(1.0));
    }
    else
    {
        var_c65e0 = var_b0cb0.xy;
    }
    highp vec3 var_e6b69 = var_b0cb0;
    var_b0cb0 = vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z);
    highp vec3 var_cdda2 = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_5f7dd = normalize((u_view * vec4(var_cdda2, 0.0)).xyz);
#endif
    highp vec4 var_61694 = texture(s_ColorMetalnessSubsurface, var_9279d);
#ifdef POINT_LIGHT_SHADING__ON
    highp vec4 var_4ac0e = var_61694;
    highp float var_51bb0 = clamp(2.007874011993408203125 * (var_4ac0e.w - 0.501960813999176025390625), 0.0, 1.0);
#endif
    uvec4 var_9e1cf = texelFetch(s_EmissiveAmbientLinearRoughness, ivec2(vec2(textureSize(s_EmissiveAmbientLinearRoughness, 0)) * var_9279d), 0);
    uvec4 var_1f03a = var_9e1cf;
#ifdef POINT_LIGHT_SHADING__ON
    uint var_4b676 = var_1f03a.x & 65535u;
    uvec2 var_49e6b = uvec2(var_4b676 >> 8u, var_4b676 & 255u);
    highp vec2 var_e8237 = vec2(float(var_49e6b.x), float(var_49e6b.y)) * vec2(0.0039215688593685626983642578125);
#endif
    uvec2 var_c02ad = var_9e1cf.yz;
    uint var_39af7 = var_c02ad.x & 65535u;
    uint var_32bfc = var_c02ad.y & 65535u;
    highp vec4 var_45f96 = vec4(uvec4(var_39af7 >> 8u, var_39af7 & 255u, var_32bfc >> 8u, var_32bfc & 255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 var_0eae4 = var_45f96;
    highp float var_03c43 = float(var_1f03a.w) * 0.0039215688593685626983642578125;
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_2ac29 = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_5b417 = var_20845.xyz;
    highp vec3 var_4211e = vec3(v_projPosition.xy, var_88b76);
    highp vec3 var_9e11a = var_61694.xyz;
    highp vec3 var_b2786;
    func_9b87e(var_b2786, var_9e11a);
    highp vec3 var_c7b87 = vec3(0.039999999105930328369140625 * (1.0 - var_51bb0)) + (var_b2786 * var_51bb0);
    highp vec3 var_5bd0a = var_4211e;
    highp vec3 var_68741 = -(var_5b417 / vec3(length(var_5b417) + 9.9999997473787516355514526367188e-05));
    highp float var_50757 = clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_4ac0e.w), 0.0, 1.0) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
    highp vec4 var_99f4c;
    highp vec3 var_b232b;
    highp vec3 var_97272;
    if (var_5bd0a.z != 1.0)
    {
        highp vec4 var_e9eb9;
        highp vec3 var_abdf4;
        highp vec3 var_e318f;
        func_4f458(var_e318f, var_abdf4, var_e9eb9, var_c0220, var_2bcf8, var_0dd5c, var_2ac29, var_5b417, var_5f7dd, var_68741, var_e8237, var_c7b87, var_51bb0, var_cdda2, var_50757);
        var_97272 = var_e318f;
        var_b232b = var_abdf4;
        var_99f4c = var_e9eb9;
    }
    else
    {
        var_97272 = vec3(0.0);
        var_b232b = vec3(0.0);
        var_99f4c = vec4(0.0, 0.0, 0.0, 1.0);
    }
    highp vec4 var_a6210 = var_99f4c;
#endif
    highp vec4 var_0853a = SkyAmbientLightColorIntensity;
    highp float var_83671 = var_03c43 * var_03c43;
#ifdef POINT_LIGHT_SHADING__OFF
    highp vec3 var_823f8 = vec3(v_projPosition.xy, (texture(s_SceneDepth, var_1b7e9.xy).x * 2.0) - 1.0);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    highp vec3 var_823f8 = var_4211e;
#endif
    highp float var_c0c38 = ((var_823f8.z * 0.5) + 0.5) * 65535.0;
    highp float var_fd346 = floor(var_c0c38);
#ifdef POINT_LIGHT_SHADING__OFF
    bgfx_FragData0 = vec4((texture(s_Normal, var_1b7e9.xy).xy * 0.5) + vec2(0.5), var_fd346 * 1.525902189314365386962890625e-05, var_c0c38 - var_fd346);
    bgfx_FragData1 = vec4(((vec3(1.0) * (1.0 - clamp(2.007874011993408203125 * (var_61694.w - 0.501960813999176025390625), 0.0, 1.0))) * max((((var_45f96.xyz * var_0eae4.w) * 6.0) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_83671 * var_83671) * var_03c43, (var_03c43 * var_03c43) * var_03c43, CameraLightIntensity.y)) * var_0853a.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w, 1.0);
    bgfx_FragData2 = vec4(0.0, 0.0, 0.0, 1.0);
#endif
#ifdef POINT_LIGHT_SHADING__ON
    bgfx_FragData0 = vec4((var_0d5fa * 0.5) + vec2(0.5), var_fd346 * 1.525902189314365386962890625e-05, var_c0c38 - var_fd346);
    bgfx_FragData1 = vec4(var_97272 + (((vec3(1.0) * (1.0 - var_51bb0)) * max(((((var_45f96.xyz * var_0eae4.w) * 6.0) + (var_99f4c.xyz * var_a6210.w)) * BlockBaseAmbientLightColorIntensity.w) + ((SkyAmbientLightColorIntensity.xyz * mix((var_83671 * var_83671) * var_03c43, (var_03c43 * var_03c43) * var_03c43, CameraLightIntensity.y)) * var_0853a.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w), 1.0);
    bgfx_FragData2 = vec4(var_b232b, 1.0);
#endif
}
