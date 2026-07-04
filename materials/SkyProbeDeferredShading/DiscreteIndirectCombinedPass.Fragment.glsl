#version 310 es

/*
* Available Macros:
*
* Passes:
* - ATMOSPHERICS_PASS (not used)
* - DIRECTIONAL_EMISSIVE_COMBINED_PASS (not used)
* - DISCRETE_INDIRECT_COMBINED_PASS (not used)
* - DO_DEFERRED_SHADING_PASS (not used)
* - DO_INDIRECT_SPECULAR_SHADING_PASS (not used)
* - FALLBACK_PASS (not used)
* - VOLUMETRIC_SCATTERING_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
* - layout(binding = 4, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 5, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SSRTexture;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
* - uniform vec4 AtmosphericScattering;
* - uniform vec4 AtmosphericScatteringToggles;
* - uniform vec4 BlockBaseAmbientLightColorIntensity;
* - uniform vec4 BlockLightIndirectSpecularIntensity;
* - uniform vec4 CameraLightIntensity;
* - uniform vec4 CascadeShadowResolutions;
* - uniform vec4 CausticsParameters;
* - uniform vec4 CausticsTextureParameters;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 ConvolutionType;
* - uniform vec4 CurrentFace;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightExplicitCascadedShadowMapEnabled[2];
* - uniform vec4 DirectionalLightExplicitCascadedShadowMapIndices[2];
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform mat4 DirectionalLightSourceCausticsViewProj[2];
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance[2];
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
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection[2];
* - uniform vec4 DirectionalLightToggleAndCountAndMaxDistanceAndMaxCascadesPerLight;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MoonColor;
* - uniform vec4 MoonDir;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightAttenuationWindow;
* - uniform vec4 PointLightAttenuationWindowEnabled;
* - uniform vec4 PointLightDiffuseFadeOutParameters;
* - uniform mat4 PointLightInvProj;
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SSRParameters;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowSlopeBias;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyProbeUVFadeParameters;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 SunColor;
* - uniform vec4 SunDir;
* - uniform vec4 Time;
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

layout(binding = 5, std430) buffer s_Lights { Light Lights[]; } var_b5100;
layout(binding = 4, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_cef03;
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_EmissiveAmbientLinearRoughness;
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneDepth;
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ClusterNearFarWidthHeight;
uniform highp vec4 ClusterSize;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightDiffuseFadeOutParameters;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 PointLightSpecularFadeOutParameters;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 WorldOrigin;
in highp vec3 v_projPosition;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
int var_e7b23;
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
void func_cd404(inout highp vec3 arg_48e40, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp float loc_28341 = -arg_48e40.z;
    highp vec2 loc_1b48c = v_texcoord0;
    highp vec3 loc_fd394 = ClusterDimensions.xyz;
    highp vec2 loc_703d4 = ClusterNearFarWidthHeight.zw;
    highp vec2 loc_d7b5c = ClusterSize.xy;
    highp vec2 loc_909cb = ClusterNearFarWidthHeight.xy;
    highp float loc_5de3f;
    func_b9aa9(loc_28341, loc_909cb, loc_5de3f, arg_48e40, loc_fd394);
    highp vec3 loc_60667 = vec3(floor((loc_1b48c.x * loc_703d4.x) / loc_d7b5c.x), floor((loc_1b48c.y * loc_703d4.y) / loc_d7b5c.y), loc_5de3f);
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
void func_2bf5a(inout int arg_60bb3, inout highp float arg_9eee0, inout highp float arg_6b488, inout highp vec3 arg_0623c, inout highp vec3 arg_147a6, inout highp float arg_77c90) {
    if (var_b5100.Lights[arg_60bb3].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        arg_6b488 = 1.0;
        return;
    }
    highp vec3 loc_8d02b = arg_0623c - var_b5100.Lights[arg_60bb3].position.xyz;
    highp vec3 loc_0b3e9 = abs(loc_8d02b);
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
    highp vec4 loc_96f5f = PointLightProj * vec4(loc_0b3e9, 1.0);
    highp float loc_2b08f = dot(normalize(-loc_8d02b), normalize(arg_147a6));
    loc_96f5f.z -= (PointLightShadowParams1.x + (PointLightShadowParams1.y * clamp(sqrt(1.0 - (loc_2b08f * loc_2b08f)) / loc_2b08f, 0.0, 1.0)));
    loc_96f5f /= vec4(loc_96f5f.w);
    highp vec3 loc_778fd = loc_8d02b;
    bool loc_fe444 = abs(loc_778fd.y) > abs(loc_778fd.x);
    bool loc_befd7;
    if (loc_fe444)
    {
        loc_befd7 = abs(loc_778fd.y) > abs(loc_778fd.z);
    }
    else
    {
        loc_befd7 = loc_fe444;
    }
    if (loc_befd7)
    {
        loc_778fd.z *= (-1.0);
    }
    else
    {
        loc_778fd.y *= (-1.0);
    }
    highp float loc_4c50b = (textureLod(s_PointLightShadowTextureArray, vec4(loc_778fd, float(var_b5100.Lights[arg_60bb3].shadowProbeIndex)), 0.0).x * 2.0) - 1.0;
    highp float loc_591c8;
    if (loc_4c50b >= loc_96f5f.z)
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
        highp vec4 loc_932a9 = PointLightInvProj * vec4(loc_96f5f.xy, loc_4c50b, 1.0);
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
void func_3445c(inout highp vec4 arg_86e96, inout int arg_c4d30, inout highp float arg_43b7a, inout highp float arg_7f337, inout highp vec3 arg_24936, inout highp vec3 arg_48f3c, inout highp vec3 arg_f6a53, inout highp vec3 arg_4f9dc, inout highp float arg_8bccf) {
    arg_86e96 = vec4(0.0);
    if (arg_c4d30 < 0)
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_24936 = vec3(0.0);
        return;
    }
    highp vec3 loc_4835c = var_b5100.Lights[arg_c4d30].position.xyz - arg_48f3c;
    highp vec3 loc_8cb9b = loc_4835c;
    highp float loc_4343f;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_4343f = loc_1829d * loc_1829d;
    }
    else
    {
        loc_4343f = dot(loc_4835c, loc_4835c);
    }
    if (loc_4343f >= (var_b5100.Lights[arg_c4d30].position.w * var_b5100.Lights[arg_c4d30].position.w))
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_24936 = vec3(0.0);
        return;
    }
    highp float loc_cddfe;
    highp float loc_a011d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_412fd;
        highp float loc_b2a04;
        func_2bf5a(arg_c4d30, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_a011d = loc_b2a04;
        loc_cddfe = loc_412fd;
    }
    else
    {
        loc_a011d = 1.0;
        loc_cddfe = 1.0;
    }
    highp float loc_fd676 = loc_4343f / ((var_b5100.Lights[arg_c4d30].position.w * var_b5100.Lights[arg_c4d30].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_fcfce = clamp(1.0 - (loc_fd676 * loc_fd676), 0.0, 1.0);
    highp float loc_e1ff6 = (1.0 / max(loc_4343f, 9.9999997473787516355514526367188e-05)) * (loc_fcfce * loc_fcfce);
    highp float loc_a0a0b;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_a0a0b = loc_e1ff6 * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_e1ff6) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_a0a0b = loc_e1ff6;
    }
    if (loc_cddfe > 0.0)
    {
        highp vec3 loc_e1408 = var_b5100.Lights[arg_c4d30].color.xyz * loc_a0a0b;
        arg_86e96 = vec4(loc_e1408.x, loc_e1408.y, loc_e1408.z, arg_86e96.w);
        arg_86e96.w = 1.0 - (loc_4343f / ((var_b5100.Lights[arg_c4d30].position.w * var_b5100.Lights[arg_c4d30].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_24936 = ((var_b5100.Lights[arg_c4d30].color.xyz * var_b5100.Lights[arg_c4d30].color.w) * loc_a0a0b) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_eddbd(inout bool arg_9a2b4, inout bool arg_b6724, inout highp vec3 arg_3289d, inout highp vec3 arg_98547, inout highp vec4 arg_33e52, inout highp vec3 arg_1418f, inout highp vec3 arg_89c41, inout highp vec3 arg_e4e64, inout highp vec3 arg_061f9, inout highp vec4 arg_33915, inout highp vec3 arg_04538, inout highp vec3 arg_dd9d3, inout highp float arg_f859b, inout highp float arg_f3664, inout highp vec3 arg_e6b36, inout highp vec3 arg_b8e73, inout highp vec3 arg_775e2) {
    highp vec4 loc_fa2ec = vec4(0.0);
    if (!(arg_9a2b4 || arg_b6724))
    {
        arg_3289d = vec3(0.0);
        arg_98547 = vec3(0.0);
        arg_33e52 = loc_fa2ec;
        return;
    }
    bool loc_a0bb1;
    int loc_490eb;
    int loc_c476d;
    func_cd404(arg_1418f, loc_c476d, loc_490eb, loc_a0bb1);
    if (!loc_a0bb1)
    {
        arg_3289d = vec3(0.0);
        arg_98547 = vec3(0.0);
        arg_33e52 = loc_fa2ec;
        return;
    }
    int loc_23246;
    highp vec3 loc_33c65;
    highp vec3 loc_983e3;
    loc_983e3 = vec3(0.0);
    loc_33c65 = vec3(0.0);
    loc_23246 = 0;
    int loc_62c27;
    highp vec3 loc_ed2f2;
    highp vec3 loc_7c75a;
    highp vec4 loc_6407e;
    for (int loc_0ad25 = loc_490eb; loc_0ad25 < loc_c476d; loc_983e3 = loc_7c75a, loc_33c65 = loc_ed2f2, loc_23246 = loc_62c27, loc_0ad25++)
    {
        int loc_a00da = int(var_cef03.LightLookupArray[loc_0ad25].lookup);
        if (loc_a00da < 0)
        {
            break;
        }
        highp vec3 loc_8c356 = normalize((u_view * vec4(var_b5100.Lights[loc_a00da].position.xyz, 1.0)).xyz - arg_89c41);
        highp vec3 loc_6691c;
        highp vec3 loc_07fc6;
        highp vec3 loc_20211;
        if (arg_b6724)
        {
            highp vec3 loc_6cd2d;
            highp vec3 loc_577c9;
            highp vec3 loc_0a326;
            if (arg_9a2b4)
            {
                highp float loc_dad67 = max(dot(arg_e4e64, loc_8c356), 0.0);
                highp float loc_237eb = max(dot(arg_e4e64, arg_061f9), 0.0);
                highp float loc_57238 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp float loc_2e0cd = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp vec3 loc_608b6 = normalize(loc_8c356 + arg_061f9);
                highp float loc_167d6 = max(arg_33915.w, 0.0500000007450580596923828125);
                highp float loc_59789 = loc_167d6 * loc_167d6;
                highp float loc_30f4c = loc_59789 * loc_59789;
                highp float loc_7f729 = max(dot(arg_e4e64, loc_608b6), 0.0);
                highp float loc_15617 = (((loc_30f4c - 1.0) * loc_7f729) * loc_7f729) + 1.0;
                highp float loc_fabe5 = loc_59789 * 0.5;
                highp float loc_c2dc6 = clamp(1.0 - max(dot(arg_061f9, loc_608b6), 0.0), 0.0, 1.0);
                highp float loc_66601 = loc_c2dc6 * loc_c2dc6;
                highp vec3 loc_1800c = arg_04538 + ((vec3(1.0) - arg_04538) * ((loc_66601 * loc_66601) * loc_c2dc6));
                highp vec3 loc_e550f = arg_dd9d3 * (1.0 - arg_f859b);
                loc_0a326 = (((loc_1800c * (loc_30f4c / ((loc_15617 * loc_15617) * 3.1415927410125732421875))) * ((loc_237eb / (((loc_237eb * (1.0 - loc_fabe5)) + loc_fabe5) + 9.9999997473787516355514526367188e-05)) * (loc_dad67 / (((loc_dad67 * (1.0 - loc_fabe5)) + loc_fabe5) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_dad67) * loc_237eb) + 9.9999997473787516355514526367188e-05)) * loc_dad67;
                loc_577c9 = (loc_e550f * vec3(0.3183098733425140380859375)) * (arg_f3664 * max((dot(-arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2e0cd * loc_2e0cd), 0.0));
                loc_6cd2d = ((vec3(1.0) - loc_1800c) * mix(loc_dad67, max((dot(arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_57238 * loc_57238), 0.0), arg_f3664)) * (loc_e550f * vec3(0.3183098733425140380859375));
            }
            else
            {
                highp float loc_36134 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp float loc_0a512 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp vec3 loc_18759 = arg_dd9d3 * (1.0 - arg_f859b);
                loc_0a326 = vec3(0.0);
                loc_577c9 = (loc_18759 * vec3(0.3183098733425140380859375)) * (arg_f3664 * max((dot(-arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_0a512 * loc_0a512), 0.0));
                loc_6cd2d = (loc_18759 * vec3(0.3183098733425140380859375)) * mix(max(dot(arg_e4e64, loc_8c356), 0.0), max((dot(arg_e4e64, loc_8c356) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_36134 * loc_36134), 0.0), arg_f3664);
            }
            loc_20211 = loc_0a326;
            loc_07fc6 = loc_577c9;
            loc_6691c = loc_6cd2d;
        }
        else
        {
            highp vec3 loc_d6eaa;
            if (arg_9a2b4)
            {
                highp float loc_58d66 = max(dot(arg_e4e64, loc_8c356), 0.0);
                highp float loc_697ca = max(dot(arg_e4e64, arg_061f9), 0.0);
                highp vec3 loc_74f40 = normalize(loc_8c356 + arg_061f9);
                highp float loc_c1447 = max(arg_33915.w, 0.0500000007450580596923828125);
                highp float loc_22daf = loc_c1447 * loc_c1447;
                highp float loc_d671e = loc_22daf * loc_22daf;
                highp float loc_92683 = max(dot(arg_e4e64, loc_74f40), 0.0);
                highp float loc_d2f7c = (((loc_d671e - 1.0) * loc_92683) * loc_92683) + 1.0;
                highp float loc_1faff = loc_22daf * 0.5;
                highp float loc_b0056 = clamp(1.0 - max(dot(arg_061f9, loc_74f40), 0.0), 0.0, 1.0);
                highp float loc_feb30 = loc_b0056 * loc_b0056;
                loc_d6eaa = ((((arg_04538 + ((vec3(1.0) - arg_04538) * ((loc_feb30 * loc_feb30) * loc_b0056))) * (loc_d671e / ((loc_d2f7c * loc_d2f7c) * 3.1415927410125732421875))) * ((loc_697ca / (((loc_697ca * (1.0 - loc_1faff)) + loc_1faff) + 9.9999997473787516355514526367188e-05)) * (loc_58d66 / (((loc_58d66 * (1.0 - loc_1faff)) + loc_1faff) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_58d66) * loc_697ca) + 9.9999997473787516355514526367188e-05)) * loc_58d66;
            }
            else
            {
                loc_d6eaa = vec3(0.0);
            }
            loc_20211 = loc_d6eaa;
            loc_07fc6 = vec3(0.0);
            loc_6691c = vec3(0.0);
        }
        loc_62c27 = loc_23246 + 1;
        highp vec3 loc_ecd5d;
        highp float loc_8e513;
        highp float loc_4e3aa;
        func_3445c(loc_6407e, loc_a00da, loc_4e3aa, loc_8e513, loc_ecd5d, arg_e6b36, arg_b8e73, arg_775e2, arg_f3664);
        loc_fa2ec += loc_6407e;
        loc_ed2f2 = loc_33c65 + ((((loc_6691c * loc_8e513) + (loc_07fc6 * loc_4e3aa)) * loc_ecd5d) * DiffuseSpecularEmissiveAmbientTermToggles.x);
        loc_7c75a = loc_983e3 + (((loc_20211 * loc_8e513) * loc_ecd5d) * DiffuseSpecularEmissiveAmbientTermToggles.y);
    }
    if (loc_23246 > 0)
    {
        highp vec3 loc_6dcb8 = loc_fa2ec.xyz / vec3(float(loc_23246));
        loc_fa2ec = vec4(loc_6dcb8.x, loc_6dcb8.y, loc_6dcb8.z, loc_fa2ec.w);
        loc_fa2ec.w /= float(loc_23246);
    }
    arg_3289d = loc_33c65;
    arg_98547 = loc_983e3;
    arg_33e52 = loc_fa2ec;
}
void main() {
    highp vec4 var_d6549 = texture(s_SceneDepth, v_texcoord0);
    highp float var_f1f1d = (var_d6549.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_f1f1d, 1.0);
    highp mat4 var_3460a = u_invProj;
    highp float var_eb413 = var_df846.x;
    highp float var_ac116 = var_df846.y;
    highp float var_f2b7c = var_df846.w;
    highp float var_0357c = var_df846.z;
    highp float var_2c821 = var_df846.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_3460a[0].x, var_ac116 * var_3460a[1].y, var_f2b7c * var_3460a[3].z, (var_0357c * var_3460a[2].w) + (var_2c821 * var_3460a[3].w));
    var_df846 = var_9666f;
    highp float var_d799e = var_df846.w;
    highp vec4 var_20845 = var_9666f / vec4(var_d799e);
    var_df846 = var_20845;
    highp vec4 var_158bd = texture(s_Normal, v_texcoord0);
    highp vec2 var_745cb = var_158bd.xy;
    highp vec3 var_b0cb0 = vec3(var_158bd.xy, (1.0 - abs(var_745cb.x)) - abs(var_745cb.y));
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
    highp vec3 var_12b45 = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_c0b1d = normalize((u_view * vec4(var_12b45, 0.0)).xyz);
    highp vec4 var_124e5 = texture(s_ColorMetalnessSubsurface, v_texcoord0);
    highp vec4 var_4ac0e = var_124e5;
    highp float var_38f9f = clamp(2.007874011993408203125 * (var_4ac0e.w - 0.501960813999176025390625), 0.0, 1.0);
    highp vec4 var_bad03 = texture(s_EmissiveAmbientLinearRoughness, v_texcoord0);
    highp vec3 var_477fc = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_31004 = var_20845.xyz;
    highp vec3 var_b67af = pow(max(var_124e5.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
    highp vec3 var_66183 = vec3(0.039999999105930328369140625 * (1.0 - var_38f9f)) + (var_b67af * var_38f9f);
    highp vec3 var_45a07 = vec3(v_projPosition.xy, var_f1f1d);
    highp vec3 var_94d76;
    if (QuantizationParameters.y > 0.0)
    {
        highp vec3 var_b074b = var_477fc - WorldOrigin.xyz;
        highp vec3 var_48aa7 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_31004)), normalize(dFdy(var_31004)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
        highp vec3 var_c01aa = mod(var_b074b, vec3(QuantizationParameters.z));
        var_94d76 = (round((var_b074b - (var_c01aa - (var_48aa7 * dot(var_c01aa, var_48aa7)))) / vec3(QuantizationPrecisionRoundingParameters.y)) * QuantizationPrecisionRoundingParameters.y) + WorldOrigin.xyz;
    }
    else
    {
        var_94d76 = var_477fc;
    }
    highp vec3 var_a6325 = -(var_31004 / vec3(length(var_31004) + 9.9999997473787516355514526367188e-05));
    highp float var_4d025 = clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_4ac0e.w), 0.0, 1.0) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
    highp float var_2a1b2;
    highp vec4 var_9a0a9;
    highp vec3 var_d75ad;
    highp vec3 var_9e38b;
    if (var_45a07.z != 1.0)
    {
        highp vec3 var_850d6 = var_31004;
        highp float var_a89c0;
        if (ManhattanDistAttenuationEnabled.x > 0.0)
        {
            var_a89c0 = (abs(var_850d6.x) + abs(var_850d6.y)) + abs(var_850d6.z);
        }
        else
        {
            var_a89c0 = length(var_31004);
        }
        bool var_3ca7e = PointLightSpecularFadeOutParameters.x > 0.0;
        highp float var_b5de8;
        if (var_3ca7e)
        {
            var_b5de8 = smoothstep(PointLightSpecularFadeOutParameters.x, PointLightSpecularFadeOutParameters.y, var_a89c0);
        }
        else
        {
            var_b5de8 = 0.0;
        }
        bool var_d0403 = !var_3ca7e;
        bool var_bf718;
        if (!var_d0403)
        {
            var_bf718 = var_3ca7e && (var_a89c0 < PointLightSpecularFadeOutParameters.y);
        }
        else
        {
            var_bf718 = var_d0403;
        }
        bool var_fe0c8 = PointLightDiffuseFadeOutParameters.x > 0.0;
        highp float var_e5d7b;
        if (var_fe0c8)
        {
            var_e5d7b = smoothstep(PointLightDiffuseFadeOutParameters.x, PointLightDiffuseFadeOutParameters.y, var_a89c0);
        }
        else
        {
            var_e5d7b = 0.0;
        }
        bool var_fc9d4 = !var_fe0c8;
        bool var_5423d;
        if (!var_fc9d4)
        {
            var_5423d = var_fe0c8 && (var_a89c0 < PointLightDiffuseFadeOutParameters.y);
        }
        else
        {
            var_5423d = var_fc9d4;
        }
        highp vec3 var_cdcc9 = var_31004;
        highp vec4 var_e4833;
        highp vec3 var_4d42e;
        highp vec3 var_25d78;
        func_eddbd(var_bf718, var_5423d, var_25d78, var_4d42e, var_e4833, var_cdcc9, var_31004, var_c0b1d, var_a6325, var_bad03, var_66183, var_b67af, var_38f9f, var_4d025, var_477fc, var_94d76, var_12b45);
        var_9e38b = var_25d78 * (1.0 - var_e5d7b);
        var_d75ad = var_4d42e * (1.0 - var_b5de8);
        var_9a0a9 = var_e4833;
        var_2a1b2 = var_e5d7b;
    }
    else
    {
        var_9e38b = vec3(0.0);
        var_d75ad = vec3(0.0);
        var_9a0a9 = vec4(0.0, 0.0, 0.0, 1.0);
        var_2a1b2 = 0.0;
    }
    highp float var_ca78c;
    if (true)
    {
        var_ca78c = PointLightDiffuseFadeOutParameters.w;
    }
    else
    {
        var_ca78c = PointLightDiffuseFadeOutParameters.z + ((PointLightDiffuseFadeOutParameters.w - PointLightDiffuseFadeOutParameters.z) * var_2a1b2);
    }
    highp vec4 var_b5548 = var_9a0a9;
    highp float var_e1957 = var_bad03.y * var_bad03.y;
    highp vec4 var_817ae = SkyAmbientLightColorIntensity;
    highp float var_48e33 = var_bad03.z * var_bad03.z;
    highp vec4 var_c2874 = vec4(((((var_b67af * (1.0 - var_38f9f)) * max(((clamp(vec3(var_e1957 + (var_b5548.x * var_b5548.w), (var_e1957 * ((((var_e1957 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_b5548.y * var_b5548.w), (var_e1957 * (((var_e1957 * var_e1957) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_b5548.z * var_b5548.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * var_ca78c) + ((SkyAmbientLightColorIntensity.xyz * mix((var_48e33 * var_48e33) * var_bad03.z, (var_bad03.z * var_bad03.z) * var_bad03.z, CameraLightIntensity.y)) * var_817ae.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w) + var_9e38b) + var_d75ad, 0.0);
    highp vec4 var_38beb;
    if (PreExposureEnabled.x > 0.0)
    {
        highp vec3 var_02f69 = var_c2874.xyz * ((0.180000007152557373046875 / texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
        var_38beb = vec4(var_02f69.x, var_02f69.y, var_02f69.z, var_c2874.w);
    }
    else
    {
        var_38beb = var_c2874;
    }
    bgfx_FragColor = var_38beb;
}
