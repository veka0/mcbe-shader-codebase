#version 310 es

/*
* Available Macros:
*
* Passes:
* - DIRECTIONAL_LIGHTING_PASS (not used)
* - DISCRETE_INDIRECT_COMBINED_LIGHTING_PASS (not used)
* - FALLBACK_PASS (not used)
* - SURFACE_RADIANCE_UPSCALE_PASS (not used)
*
* Upscaling:
* - UPSCALING__OFF (not used)
* - UPSCALING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BiomeBlendingMap;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_DiffuseLighting;
* - uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_NormalsAndDepthLighting;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler2D s_SpecularLighting;
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
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform mat4 DirectionalLightSourceCausticsViewProj;
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
* - uniform vec4 SceneNearFar;
* - uniform vec4 SceneResolutionAndRecipResolution;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
* - uniform vec4 SkyZenithColor;
* - uniform vec4 SubPixelOffset;
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

layout(binding = 15, std430) buffer s_zLights { Light zLights[]; } var_95052;
layout(binding = 14, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_ad843;
uniform highp mat4 PointLightInvProj;
uniform highp mat4 PointLightProj;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_EmissiveAmbientLinearRoughness;
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_SceneDepth;
uniform highp samplerCubeArray s_PointLightShadowTextureArray;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 CameraLightIntensity;
uniform highp vec4 ClusterDepthBounds;
uniform highp vec4 ClusterDimensions;
uniform highp vec4 ClusterNearFarWidthHeight;
uniform highp vec4 ClusterSize;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
uniform highp vec4 ManhattanDistAttenuationEnabled;
uniform highp vec4 PointLightAttenuationWindow;
uniform highp vec4 PointLightAttenuationWindowEnabled;
uniform highp vec4 PointLightDiffuseFadeOutParameters;
uniform highp vec4 PointLightNdLFloor;
uniform highp vec4 PointLightShadowParams1;
uniform highp vec4 PointLightSpecularFadeOutParameters;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 SceneResolutionAndRecipResolution;
uniform highp vec4 SkyAmbientLightColorIntensity;
uniform highp vec4 SubPixelOffset;
uniform highp vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
uniform highp vec4 WorldOrigin;
in highp vec3 v_projPosition;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
int var_e7b23;
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
void func_72273(inout highp vec3 arg_9f603, inout highp vec2 arg_dd3ab, inout int arg_e45b8, inout int arg_fadf1, inout bool arg_d7f4c) {
    highp float loc_28341 = -arg_9f603.z;
    highp vec2 loc_88253 = arg_dd3ab;
    highp vec3 loc_fd394 = ClusterDimensions.xyz;
    highp vec2 loc_703d4 = ClusterNearFarWidthHeight.zw;
    highp vec2 loc_d7b5c = ClusterSize.xy;
    highp vec2 loc_909cb = ClusterNearFarWidthHeight.xy;
    highp vec2 loc_eee23 = ClusterDepthBounds.xy;
    highp float loc_5de3f;
    func_5d077(loc_28341, loc_909cb, loc_5de3f, loc_eee23, loc_fd394);
    highp vec3 loc_60667 = vec3(floor((loc_88253.x * loc_703d4.x) / loc_d7b5c.x), floor((loc_88253.y * loc_703d4.y) / loc_d7b5c.y), loc_5de3f);
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
void func_bbb6d(inout int arg_826b5, inout highp float arg_9eee0, inout highp float arg_6b488, inout highp vec3 arg_aee55, inout highp vec3 arg_1111c, inout highp float arg_77c90) {
    if (var_95052.zLights[arg_826b5].shadowProbeIndex < 0)
    {
        arg_9eee0 = 1.0;
        arg_6b488 = 1.0;
        return;
    }
    highp vec3 loc_44ea9 = arg_aee55 - var_95052.zLights[arg_826b5].position.xyz;
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
    highp float loc_e670f = (textureLod(s_PointLightShadowTextureArray, vec4(loc_f715f, float(var_95052.zLights[arg_826b5].shadowProbeIndex)), 0.0).x * 2.0) - 1.0;
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
void func_28d9b(inout highp vec4 arg_e84ec, inout int arg_49c8c, inout highp float arg_43b7a, inout highp float arg_7f337, inout highp vec3 arg_ec226, inout highp vec3 arg_29ac4, inout highp vec3 arg_f6a53, inout highp vec3 arg_4f9dc, inout highp float arg_8bccf) {
    arg_e84ec = vec4(0.0);
    if (arg_49c8c < 0)
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_ec226 = vec3(0.0);
        return;
    }
    highp vec3 loc_8dfd7 = var_95052.zLights[arg_49c8c].position.xyz - arg_29ac4;
    highp vec3 loc_8cb9b = loc_8dfd7;
    highp float loc_3a449;
    if (ManhattanDistAttenuationEnabled.x > 0.0)
    {
        highp float loc_1829d = (abs(loc_8cb9b.x) + abs(loc_8cb9b.y)) + abs(loc_8cb9b.z);
        loc_3a449 = loc_1829d * loc_1829d;
    }
    else
    {
        loc_3a449 = dot(loc_8dfd7, loc_8dfd7);
    }
    if (loc_3a449 >= (var_95052.zLights[arg_49c8c].position.w * var_95052.zLights[arg_49c8c].position.w))
    {
        arg_43b7a = 1.0;
        arg_7f337 = 1.0;
        arg_ec226 = vec3(0.0);
        return;
    }
    highp float loc_cddfe;
    highp float loc_a011d;
    if (DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.w != 0.0)
    {
        highp float loc_412fd;
        highp float loc_b2a04;
        func_bbb6d(arg_49c8c, loc_b2a04, loc_412fd, arg_f6a53, arg_4f9dc, arg_8bccf);
        loc_a011d = loc_b2a04;
        loc_cddfe = loc_412fd;
    }
    else
    {
        loc_a011d = 1.0;
        loc_cddfe = 1.0;
    }
    highp float loc_4c5a5 = loc_3a449 / ((var_95052.zLights[arg_49c8c].position.w * var_95052.zLights[arg_49c8c].position.w) + 9.9999997473787516355514526367188e-05);
    highp float loc_fcfce = clamp(1.0 - (loc_4c5a5 * loc_4c5a5), 0.0, 1.0);
    highp float loc_e1ff6 = (1.0 / max(loc_3a449, 9.9999997473787516355514526367188e-05)) * (loc_fcfce * loc_fcfce);
    highp float loc_4217d;
    if (PointLightAttenuationWindowEnabled.x > 0.0)
    {
        loc_4217d = loc_e1ff6 * clamp((smoothstep(PointLightAttenuationWindow.x, PointLightAttenuationWindow.y, 1.0 - loc_e1ff6) * PointLightAttenuationWindow.z) + PointLightAttenuationWindow.w, 0.0, 1.0);
    }
    else
    {
        loc_4217d = loc_e1ff6;
    }
    if (loc_cddfe > 0.0)
    {
        highp vec3 loc_8226d = var_95052.zLights[arg_49c8c].color.xyz * loc_4217d;
        arg_e84ec = vec4(loc_8226d.x, loc_8226d.y, loc_8226d.z, arg_e84ec.w);
        arg_e84ec.w = 1.0 - (loc_3a449 / ((var_95052.zLights[arg_49c8c].position.w * var_95052.zLights[arg_49c8c].position.w) + 9.9999997473787516355514526367188e-05));
    }
    arg_43b7a = loc_a011d;
    arg_7f337 = loc_cddfe;
    arg_ec226 = ((var_95052.zLights[arg_49c8c].color.xyz * var_95052.zLights[arg_49c8c].color.w) * loc_4217d) * DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle.z;
}
void func_0387a(inout bool arg_9a2b4, inout bool arg_b6724, inout highp vec3 arg_3289d, inout highp vec3 arg_98547, inout highp vec4 arg_33e52, inout highp vec3 arg_dc0ef, inout highp vec2 arg_96daa, inout highp vec3 arg_fea00, inout highp vec3 arg_e4e64, inout highp vec3 arg_061f9, inout highp vec4 arg_33915, inout highp vec3 arg_04538, inout highp float arg_a7f64, inout highp float arg_f3664, inout highp vec3 arg_e6b36, inout highp vec3 arg_b8e73, inout highp vec3 arg_775e2) {
    highp vec4 loc_fa2ec = vec4(0.0);
    if (!(arg_9a2b4 || arg_b6724))
    {
        arg_3289d = vec3(0.0);
        arg_98547 = vec3(0.0);
        arg_33e52 = loc_fa2ec;
        return;
    }
    bool loc_9f3ca;
    int loc_2aee5;
    int loc_9d2b5;
    func_72273(arg_dc0ef, arg_96daa, loc_9d2b5, loc_2aee5, loc_9f3ca);
    if (!loc_9f3ca)
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
    for (int loc_86630 = loc_2aee5; loc_86630 < loc_9d2b5; loc_983e3 = loc_7c75a, loc_33c65 = loc_ed2f2, loc_23246 = loc_62c27, loc_86630++)
    {
        int loc_dbe64 = int(var_ad843.zLightLookupArray[loc_86630].lookup);
        if (loc_dbe64 < 0)
        {
            break;
        }
        highp vec3 loc_287bb = normalize((u_view * vec4(var_95052.zLights[loc_dbe64].position.xyz, 1.0)).xyz - arg_fea00);
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
                highp float loc_dad67 = max(dot(arg_e4e64, loc_287bb), 0.0);
                highp float loc_237eb = max(dot(arg_e4e64, arg_061f9), 0.0);
                highp float loc_57238 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp float loc_2e0cd = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp vec3 loc_608b6 = normalize(loc_287bb + arg_061f9);
                highp float loc_167d6 = max(arg_33915.w, 0.0500000007450580596923828125);
                highp float loc_59789 = loc_167d6 * loc_167d6;
                highp float loc_30f4c = loc_59789 * loc_59789;
                highp float loc_7f729 = max(dot(arg_e4e64, loc_608b6), 0.0);
                highp float loc_15617 = (((loc_30f4c - 1.0) * loc_7f729) * loc_7f729) + 1.0;
                highp float loc_fabe5 = loc_59789 * 0.5;
                highp float loc_c2dc6 = clamp(1.0 - max(dot(arg_061f9, loc_608b6), 0.0), 0.0, 1.0);
                highp float loc_66601 = loc_c2dc6 * loc_c2dc6;
                highp vec3 loc_1800c = arg_04538 + ((vec3(1.0) - arg_04538) * ((loc_66601 * loc_66601) * loc_c2dc6));
                highp vec3 loc_99cf4 = vec3(1.0) * (1.0 - arg_a7f64);
                loc_0a326 = (((loc_1800c * (loc_30f4c / ((loc_15617 * loc_15617) * 3.1415927410125732421875))) * ((loc_237eb / (((loc_237eb * (1.0 - loc_fabe5)) + loc_fabe5) + 9.9999997473787516355514526367188e-05)) * (loc_dad67 / (((loc_dad67 * (1.0 - loc_fabe5)) + loc_fabe5) + 9.9999997473787516355514526367188e-05)))) / vec3(((4.0 * loc_dad67) * loc_237eb) + 9.9999997473787516355514526367188e-05)) * loc_dad67;
                loc_577c9 = (loc_99cf4 * vec3(0.3183098733425140380859375)) * (arg_f3664 * max((dot(-arg_e4e64, loc_287bb) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_2e0cd * loc_2e0cd), 0.0));
                loc_6cd2d = ((vec3(1.0) - loc_1800c) * mix(loc_dad67, max((dot(arg_e4e64, loc_287bb) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_57238 * loc_57238), 0.0), arg_f3664)) * (loc_99cf4 * vec3(0.3183098733425140380859375));
            }
            else
            {
                highp float loc_36134 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp float loc_0a512 = 1.0 + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y;
                highp vec3 loc_2f29b = vec3(1.0) * (1.0 - arg_a7f64);
                loc_0a326 = vec3(0.0);
                loc_577c9 = (loc_2f29b * vec3(0.3183098733425140380859375)) * (arg_f3664 * max((dot(-arg_e4e64, loc_287bb) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_0a512 * loc_0a512), 0.0));
                loc_6cd2d = (loc_2f29b * vec3(0.3183098733425140380859375)) * mix(max(dot(arg_e4e64, loc_287bb), 0.0), max((dot(arg_e4e64, loc_287bb) + SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.y) / (loc_36134 * loc_36134), 0.0), arg_f3664);
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
                highp float loc_58d66 = max(dot(arg_e4e64, loc_287bb), 0.0);
                highp float loc_697ca = max(dot(arg_e4e64, arg_061f9), 0.0);
                highp vec3 loc_74f40 = normalize(loc_287bb + arg_061f9);
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
        func_28d9b(loc_6407e, loc_dbe64, loc_4e3aa, loc_8e513, loc_ecd5d, arg_e6b36, arg_b8e73, arg_775e2, arg_f3664);
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
    highp vec2 var_12df4 = (floor(v_texcoord0 * SceneResolutionAndRecipResolution.xy) + vec2(0.5)) * SceneResolutionAndRecipResolution.zw;
    highp vec4 var_42da2 = texture(s_Normal, var_12df4);
    highp vec2 var_103af = var_42da2.xy;
    highp vec4 var_4f0e2 = texture(s_SceneDepth, var_12df4);
    highp float var_88b76 = (var_4f0e2.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_88b76, 1.0);
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
    highp vec4 var_1c342 = vec4(v_projPosition.xy + vec2(SubPixelOffset.x, -SubPixelOffset.y), var_88b76, 1.0);
    highp mat4 var_3ebcc = u_invProj;
    highp float var_a6256 = var_1c342.x;
    highp float var_05401 = var_1c342.y;
    highp float var_b8669 = var_1c342.w;
    highp float var_259fc = var_1c342.z;
    highp float var_f8db3 = var_1c342.w;
    highp vec4 var_fa2eb = vec4(var_a6256 * var_3ebcc[0].x, var_05401 * var_3ebcc[1].y, var_b8669 * var_3ebcc[3].z, (var_259fc * var_3ebcc[2].w) + (var_f8db3 * var_3ebcc[3].w));
    var_1c342 = var_fa2eb;
    highp float var_f7138 = var_1c342.w;
    highp vec4 var_3ee7d = var_fa2eb / vec4(var_f7138);
    var_1c342 = var_3ee7d;
    highp vec3 var_d5564 = (u_invView * vec4(var_3ee7d.xyz, 1.0)).xyz - WorldOrigin.xyz;
    highp vec3 var_e3d8f = var_3ee7d.xyz;
    highp vec3 var_eebcb = dFdx(var_e3d8f);
    highp vec3 var_211c8 = dFdy(var_e3d8f);
    highp vec3 var_61c47 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(var_eebcb), normalize(var_211c8))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_fc769 = mod(var_d5564, vec3(QuantizationParameters.z));
    highp vec2 var_3ccf7 = var_103af;
    highp vec3 var_b0cb0 = vec3(var_42da2.xy, (1.0 - abs(var_3ccf7.x)) - abs(var_3ccf7.y));
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
    highp vec3 var_17b01 = normalize((u_view * vec4(var_12b45, 0.0)).xyz);
    highp vec4 var_0ac6d = texture(s_ColorMetalnessSubsurface, var_12df4);
    highp vec4 var_4ac0e = var_0ac6d;
    highp float var_c63da = clamp(2.007874011993408203125 * (var_4ac0e.w - 0.501960813999176025390625), 0.0, 1.0);
    highp vec4 var_af108 = texture(s_EmissiveAmbientLinearRoughness, var_12df4);
    highp vec3 var_a2ac4 = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_15adc = var_20845.xyz;
    highp vec3 var_4211e = vec3(v_projPosition.xy, var_88b76);
    highp vec3 var_a4e78 = vec3(0.039999999105930328369140625 * (1.0 - var_c63da)) + (pow(max(var_0ac6d.xyz, vec3(0.0)), vec3(2.2000000476837158203125)) * var_c63da);
    highp vec3 var_5bd0a = var_4211e;
    highp vec3 var_e288f = -(var_15adc / vec3(length(var_15adc) + 9.9999997473787516355514526367188e-05));
    highp float var_4d025 = clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_4ac0e.w), 0.0, 1.0) * SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale.x;
    highp float var_2a1b2;
    highp vec4 var_9a0a9;
    highp vec3 var_508db;
    highp vec3 var_692f2;
    if (var_5bd0a.z != 1.0)
    {
        highp vec3 var_850d6 = var_15adc;
        highp float var_a89c0;
        if (ManhattanDistAttenuationEnabled.x > 0.0)
        {
            var_a89c0 = (abs(var_850d6.x) + abs(var_850d6.y)) + abs(var_850d6.z);
        }
        else
        {
            var_a89c0 = length(var_15adc);
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
        highp vec3 var_c4757;
        if (int(QuantizationParameters.y) > 0)
        {
            var_c4757 = (var_d5564 - (var_fc769 - (var_61c47 * dot(var_fc769, var_61c47)))) + WorldOrigin.xyz;
        }
        else
        {
            var_c4757 = var_a2ac4;
        }
        highp vec3 var_cdcc9 = var_15adc;
        highp vec4 var_e4833;
        highp vec3 var_4d42e;
        highp vec3 var_25d78;
        func_0387a(var_bf718, var_5423d, var_25d78, var_4d42e, var_e4833, var_cdcc9, var_12df4, var_15adc, var_17b01, var_e288f, var_af108, var_a4e78, var_c63da, var_4d025, var_a2ac4, var_c4757, var_12b45);
        var_692f2 = var_25d78 * (1.0 - var_e5d7b);
        var_508db = var_4d42e * (1.0 - var_b5de8);
        var_9a0a9 = var_e4833;
        var_2a1b2 = var_e5d7b;
    }
    else
    {
        var_692f2 = vec3(0.0);
        var_508db = vec3(0.0);
        var_9a0a9 = vec4(0.0, 0.0, 0.0, 1.0);
        var_2a1b2 = 0.0;
    }
    highp float var_57060;
    if (true)
    {
        var_57060 = PointLightDiffuseFadeOutParameters.w;
    }
    else
    {
        var_57060 = PointLightDiffuseFadeOutParameters.z + ((PointLightDiffuseFadeOutParameters.w - PointLightDiffuseFadeOutParameters.z) * var_2a1b2);
    }
    highp vec4 var_cf22a = var_9a0a9;
    highp float var_87944 = var_af108.y * var_af108.y;
    highp vec4 var_4e9b3 = SkyAmbientLightColorIntensity;
    highp float var_6bd51 = var_af108.z * var_af108.z;
    highp vec3 var_0c789 = var_4211e;
    highp float var_70ac6 = ((var_0c789.z * 0.5) + 0.5) * 65535.0;
    highp float var_dac94 = floor(var_70ac6);
    bgfx_FragData[0] = vec4(var_692f2 + (((vec3(1.0) * (1.0 - var_c63da)) * max(((clamp(vec3(var_87944 + (var_cf22a.x * var_cf22a.w), (var_87944 * ((((var_87944 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_cf22a.y * var_cf22a.w), (var_87944 * (((var_87944 * var_87944) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_cf22a.z * var_cf22a.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * var_57060) + ((SkyAmbientLightColorIntensity.xyz * mix((var_6bd51 * var_6bd51) * var_af108.z, (var_af108.z * var_af108.z) * var_af108.z, CameraLightIntensity.y)) * var_4e9b3.w), AmbientLightParams.xyz * AmbientLightParams.w)) * DiffuseSpecularEmissiveAmbientTermToggles.w), 1.0);
    bgfx_FragData[1] = vec4(var_508db, 1.0);
    bgfx_FragData[2] = vec4((var_103af * 0.5) + vec2(0.5), var_dac94 * 1.525902189314365386962890625e-05, var_70ac6 - var_dac94);
}
