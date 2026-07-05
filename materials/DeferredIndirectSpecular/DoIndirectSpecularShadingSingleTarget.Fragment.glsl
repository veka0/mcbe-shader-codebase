#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_INDIRECT_SPECULAR_SHADING_DUAL_TARGET_PASS (not used)
* - DO_INDIRECT_SPECULAR_SHADING_SINGLE_TARGET_PASS (not used)
* - DO_INDIRECT_SPECULAR_UPSCALE_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Mode:
* - MODE__DEFAULT
* - MODE__MIXED_RES
*
* Upscaling:
* - UPSCALING__OFF (not used)
* - UPSCALING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp usampler2D s_EmissiveAmbientLinearRoughness;
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_NormalsAndDepthLighting;
* - uniform lowp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SSRTexture;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform lowp sampler2D s_SceneDepth;
* - uniform highp sampler2DArray s_ShadowCascades;
* - uniform lowp sampler3D s_SkyAmbientSamples;
* - uniform highp samplerCubeArray s_SpecularIBLRecords;
* - uniform lowp sampler2D s_SpecularLighting;
* - layout(binding = 15, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 16, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
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
* - uniform vec4 DownsampleResolutionAndRecipResolution;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 FogSkyBlend;
* - uniform vec4 IBLParameters;
* - uniform vec4 IBLSkyFadeParameters;
* - uniform vec4 LastSpecularIBLIdx;
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
* - uniform vec4 SSRParameters;
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

#extension GL_EXT_texture_cube_map_array : require
precision mediump float;
precision highp int;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SSRTexture;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform highp usampler2D s_EmissiveAmbientLinearRoughness;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 BlockLightIndirectSpecularIntensity;
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 ConvolutionType;
uniform highp vec4 DiffuseSpecularEmissiveAmbientTermToggles;
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 LastSpecularIBLIdx;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 QuantizationParameters;
uniform highp vec4 QuantizationPrecisionRoundingParameters;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 SSRParameters;
#ifdef MODE__MIXED_RES
uniform highp vec4 SceneResolutionAndRecipResolution;
#endif
uniform highp vec4 SubPixelOffset;
uniform highp vec4 ViewportScale;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WorldOrigin;
in highp vec3 v_projPosition;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
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
void func_8d80e(inout highp vec3 arg_1c74c, inout highp float arg_19032, inout highp vec4 arg_85834) {
    highp vec3 loc_31e57 = (arg_1c74c * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x;
    highp vec3 loc_4c5f3 = mix(AmbientLightParams.xyz * AmbientLightParams.w, loc_31e57, vec3(clamp(dot(loc_31e57, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)), 0.0, 1.0))) * arg_19032;
    if (0.0 >= dot(loc_4c5f3, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_4c5f3, 1.0);
}
void main() {
#ifdef MODE__DEFAULT
    highp vec4 var_b7ade = texture(s_Normal, v_texcoord0.xy);
    highp vec4 var_fe231 = texture(s_SceneDepth, v_texcoord0.xy);
#endif
#ifdef MODE__MIXED_RES
    highp vec2 var_c8bfb = (floor(v_texcoord0.xy * SceneResolutionAndRecipResolution.xy) + vec2(0.5)) * SceneResolutionAndRecipResolution.zw;
    highp vec4 var_b7ade = texture(s_Normal, var_c8bfb.xy);
    highp vec2 var_0d4a8 = var_c8bfb.xy;
    highp vec4 var_fe231 = texture(s_SceneDepth, var_c8bfb.xy);
#endif
    highp float var_48a47 = (var_fe231.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_48a47, 1.0);
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
    highp vec4 var_1c342 = vec4(v_projPosition.xy + vec2(SubPixelOffset.x, -SubPixelOffset.y), var_48a47, 1.0);
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
    highp vec3 var_38d64 = (u_invView * vec4(var_3ee7d.xyz, 1.0)).xyz - WorldOrigin.xyz;
    highp vec3 var_c6246 = var_3ee7d.xyz;
    highp vec3 var_76063 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_c6246)), normalize(dFdy(var_c6246)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
    highp vec3 var_fddd0 = vec3(QuantizationParameters.z * 0.5) - mod(var_38d64, vec3(QuantizationParameters.z));
    highp vec3 var_ec4b0 = (var_38d64 + (var_fddd0 - (var_76063 * dot(var_fddd0, var_76063)))) + WorldOrigin.xyz;
    highp vec2 var_745cb = var_b7ade.xy;
    highp vec3 var_b0cb0 = vec3(var_b7ade.xy, (1.0 - abs(var_745cb.x)) - abs(var_745cb.y));
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
    highp vec3 var_b623b = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_1f28f = normalize((u_view * vec4(var_b623b, 0.0)).xyz);
#ifdef MODE__DEFAULT
    highp vec4 var_5d63f = texture(s_ColorMetalnessSubsurface, v_texcoord0.xy);
#endif
#ifdef MODE__MIXED_RES
    highp vec4 var_5d63f = texture(s_ColorMetalnessSubsurface, var_0d4a8);
#endif
    highp vec4 var_ee5ba = var_5d63f;
    highp float var_b4a2f = clamp(2.007874011993408203125 * (var_ee5ba.w - 0.501960813999176025390625), 0.0, 1.0);
#ifdef MODE__DEFAULT
    uvec4 var_ec089 = texelFetch(s_EmissiveAmbientLinearRoughness, ivec2(vec2(textureSize(s_EmissiveAmbientLinearRoughness, 0)) * v_texcoord0.xy), 0);
#endif
#ifdef MODE__MIXED_RES
    uvec4 var_ec089 = texelFetch(s_EmissiveAmbientLinearRoughness, ivec2(vec2(textureSize(s_EmissiveAmbientLinearRoughness, 0)) * var_0d4a8), 0);
#endif
    uvec4 var_875c9 = var_ec089;
    uint var_4b676 = var_875c9.x & 65535u;
    uvec2 var_49e6b = uvec2(var_4b676 >> 8u, var_4b676 & 255u);
    highp vec2 var_0afea = vec2(float(var_49e6b.x), float(var_49e6b.y)) * vec2(0.0039215688593685626983642578125);
    uvec2 var_c02ad = var_ec089.yz;
    uint var_39af7 = var_c02ad.x & 65535u;
    uint var_32bfc = var_c02ad.y & 65535u;
    highp vec4 var_d9392 = vec4(uvec4(var_39af7 >> 8u, var_39af7 & 255u, var_32bfc >> 8u, var_32bfc & 255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 var_b0c09 = var_d9392;
    highp vec3 var_4ec1a = (var_d9392.xyz * var_b0c09.w) * 6.0;
    highp vec3 var_21abf = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_f529b = var_20845.xyz;
    highp vec3 var_599e1 = vec3(v_projPosition.xy, var_48a47);
    highp vec3 var_9e11a = var_5d63f.xyz;
    highp vec3 var_b2786;
    func_9b87e(var_b2786, var_9e11a);
    highp vec3 var_f6b87 = vec3(0.039999999105930328369140625 * (1.0 - var_b4a2f)) + (var_b2786 * var_b4a2f);
    highp float var_fb10a;
    if (PreExposureEnabled.x > 0.0)
    {
        var_fb10a = texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x;
    }
    else
    {
        var_fb10a = 0.0;
    }
    highp float var_7280d = clamp(((float(var_875c9.w) * 0.062745101749897003173828125) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_0c7d8 = ((var_7280d * var_7280d) * var_7280d) * IBLParameters.x;
    highp float var_e6705 = length(var_f529b);
    bool var_404a8 = SSRParameters.x != 0.0;
    bool var_b9d95;
    if (var_404a8)
    {
        var_b9d95 = IBLParameters.x != 0.0;
    }
    else
    {
        var_b9d95 = var_404a8;
    }
    highp vec3 var_3f03f;
    if (var_b9d95)
    {
        bool var_46a60 = PreExposureEnabled.x > 0.0;
        highp vec2 var_bcb12 = (var_599e1.xy + vec2(1.0)) * 0.5;
        var_bcb12.y = 1.0 - var_bcb12.y;
        var_bcb12 = vec2(var_bcb12.x, 1.0 - var_bcb12.y);
        highp vec3 var_7c2f6;
        highp vec3 var_23420;
        if (QuantizationParameters.w > 0.0)
        {
            highp vec4 var_d5962 = u_viewProj * vec4(var_ec4b0, 1.0);
            highp vec4 var_412ca = var_d5962;
            highp vec3 var_f4c6b = var_d5962.xyz / vec3(var_412ca.w);
            var_f4c6b.y *= (-1.0);
            highp vec2 var_9b904 = (var_f4c6b.xy + vec2(1.0)) * 0.5;
            highp float var_74cec = var_9b904.x;
            highp float var_83bc9 = var_9b904.y;
            highp vec2 var_95d93 = vec2(var_74cec, 1.0 - var_83bc9);
            var_9b904 = var_95d93;
            var_bcb12 = var_95d93;
            var_23420 = (u_view * vec4(var_ec4b0, 1.0)).xyz;
            var_7c2f6 = var_ec4b0;
        }
        else
        {
            var_23420 = var_f529b;
            var_7c2f6 = var_21abf;
        }
        highp vec4 var_87e47 = texture(s_SSRTexture, var_bcb12 * ViewportScale.xy);
        if (var_46a60)
        {
            highp vec3 var_417eb = var_87e47.xyz / vec3((0.180000007152557373046875 / var_fb10a) + 9.9999997473787516355514526367188e-05);
            var_87e47 = vec4(var_417eb.x, var_417eb.y, var_417eb.z, var_87e47.w);
        }
        highp vec3 var_a56d9 = reflect(normalize(var_7c2f6 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_b623b);
        highp float var_0f441;
        if (int(ConvolutionType.x) == 1)
        {
            highp float var_aaa45 = 1.0 - var_0afea.x;
            var_0f441 = (1.0 - (var_aaa45 * var_aaa45)) * (IBLParameters.y - 1.0);
        }
        else
        {
            highp float var_3f5dd = 1.0 - var_0afea.x;
            highp float var_e5afa = var_3f5dd * var_3f5dd;
            highp float var_d59d7 = var_e5afa * var_e5afa;
            var_0f441 = (1.0 - (var_d59d7 * var_d59d7)) * (IBLParameters.y - 1.0);
        }
        int var_ae27f = int(LastSpecularIBLIdx.x);
        highp vec3 var_67eb4 = mix(textureLod(s_SpecularIBLRecords, vec4(var_a56d9, float((var_ae27f + 2) % 3)), var_0f441).xyz, textureLod(s_SpecularIBLRecords, vec4(var_a56d9, float(var_ae27f)), var_0f441).xyz, vec3(IBLParameters.w));
        highp vec3 var_bdf29;
        if (var_46a60)
        {
            var_bdf29 = var_67eb4 * vec3(301.72412109375);
        }
        else
        {
            var_bdf29 = var_67eb4;
        }
        highp vec3 var_8c1ad = (var_bdf29 * var_0c7d8) * IBLParameters.z;
        highp vec3 var_83a0f;
        if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
        {
            highp vec4 var_26642;
            func_f1037(var_4ec1a, var_b4a2f, var_8c1ad, var_26642);
            highp vec4 var_fb83f = var_26642;
            highp vec3 var_5279b;
            if (var_fb83f.w == 1.0)
            {
                var_5279b = var_26642.xyz;
            }
            else
            {
                var_5279b = var_8c1ad;
            }
            var_83a0f = var_5279b;
        }
        else
        {
            var_83a0f = var_8c1ad;
        }
        highp vec2 var_c1478 = vec2(clamp(dot(var_1f28f, -normalize(var_23420)), 0.0, 1.0), var_0afea.x);
        var_c1478.y = 1.0 - var_c1478.y;
        highp vec2 var_f1a1e = texture(s_BrdfLUT, var_c1478).xy;
        var_3f03f = mix(var_83a0f, var_87e47.xyz, vec3(var_87e47.w * SSRParameters.y)) * ((var_f6b87 * var_f1a1e.x) + vec3(var_f1a1e.y));
    }
    else
    {
        highp vec3 var_89bfe;
        if (IBLParameters.x != 0.0)
        {
            highp vec3 var_ee8d4;
            highp vec3 var_e2d67;
            if (QuantizationParameters.w > 0.0)
            {
                var_e2d67 = (u_view * vec4(var_ec4b0, 1.0)).xyz;
                var_ee8d4 = var_ec4b0;
            }
            else
            {
                var_e2d67 = var_f529b;
                var_ee8d4 = var_21abf;
            }
            highp vec3 var_44ff1 = reflect(normalize(var_ee8d4 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_b623b);
            highp float var_622ee;
            if (int(ConvolutionType.x) == 1)
            {
                highp float var_fb43c = 1.0 - var_0afea.x;
                var_622ee = (1.0 - (var_fb43c * var_fb43c)) * (IBLParameters.y - 1.0);
            }
            else
            {
                highp float var_5e94b = 1.0 - var_0afea.x;
                highp float var_464ee = var_5e94b * var_5e94b;
                highp float var_c3581 = var_464ee * var_464ee;
                var_622ee = (1.0 - (var_c3581 * var_c3581)) * (IBLParameters.y - 1.0);
            }
            int var_0a0b1 = int(LastSpecularIBLIdx.x);
            highp vec3 var_63ae8 = mix(textureLod(s_SpecularIBLRecords, vec4(var_44ff1, float((var_0a0b1 + 2) % 3)), var_622ee).xyz, textureLod(s_SpecularIBLRecords, vec4(var_44ff1, float(var_0a0b1)), var_622ee).xyz, vec3(IBLParameters.w));
            highp vec3 var_eaaca;
            if (PreExposureEnabled.x > 0.0)
            {
                var_eaaca = var_63ae8 * vec3(301.72412109375);
            }
            else
            {
                var_eaaca = var_63ae8;
            }
            highp vec3 var_265a6 = (var_eaaca * var_0c7d8) * IBLParameters.z;
            highp vec3 var_0d46b;
            if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
            {
                highp vec4 var_bf376;
                func_f1037(var_4ec1a, var_b4a2f, var_265a6, var_bf376);
                highp vec4 var_a4557 = var_bf376;
                highp vec3 var_63a76;
                if (var_a4557.w == 1.0)
                {
                    var_63a76 = var_bf376.xyz;
                }
                else
                {
                    var_63a76 = var_265a6;
                }
                var_0d46b = var_63a76;
            }
            else
            {
                var_0d46b = var_265a6;
            }
            highp vec2 var_fabc1 = vec2(clamp(dot(var_1f28f, -normalize(var_e2d67)), 0.0, 1.0), var_0afea.x);
            var_fabc1.y = 1.0 - var_fabc1.y;
            highp vec2 var_bfc96 = texture(s_BrdfLUT, var_fabc1).xy;
            var_89bfe = var_0d46b * ((var_f6b87 * var_bfc96.x) + vec3(var_bfc96.y));
        }
        else
        {
            highp vec3 var_0fc0f;
            if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
            {
                highp vec3 var_1816e;
                if (QuantizationParameters.w > 0.0)
                {
                    var_1816e = (u_view * vec4(var_ec4b0, 1.0)).xyz;
                }
                else
                {
                    var_1816e = var_f529b;
                }
                highp vec4 var_5b282;
                func_8d80e(var_4ec1a, var_b4a2f, var_5b282);
                highp vec2 var_a54e7 = vec2(clamp(dot(var_1f28f, -normalize(var_1816e)), 0.0, 1.0), var_0afea.x);
                var_a54e7.y = 1.0 - var_a54e7.y;
                highp vec2 var_f7ae0 = texture(s_BrdfLUT, var_a54e7).xy;
                var_0fc0f = var_5b282.xyz * ((var_f6b87 * var_f7ae0.x) + vec3(var_f7ae0.y));
            }
            else
            {
                var_0fc0f = vec3(0.0);
            }
            var_89bfe = var_0fc0f;
        }
        var_3f03f = var_89bfe;
    }
    highp vec3 var_51636;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        var_51636 = var_3f03f * (1.0 - clamp((((var_e6705 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0));
    }
    else
    {
        var_51636 = var_3f03f * (1.0 - clamp((((var_e6705 / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    }
    highp vec3 var_f2e5a;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_599e1.xy + vec2(1.0)) * 0.5;
        highp vec4 var_cf4b5 = u_invProj * vec4(v_projPosition.xy, var_48a47, 1.0);
        highp float var_b4ccc = var_7d045.x;
        ivec3 var_dbde4 = ivec3(VolumeDimensions.xyz);
        highp vec3 var_9bf69 = vec3(var_b4ccc, var_7d045.y, log((53.598148345947265625 * ((((-var_cf4b5.z) / var_cf4b5.w) - var_65315.x) / (var_65315.y - var_65315.x))) + 1.0) * 0.25);
        highp float var_eb2d5 = (var_9bf69.z * float(var_dbde4.z)) - 0.5;
        int var_b2370 = clamp(int(var_eb2d5), 0, var_dbde4.z - 2);
        highp vec4 var_36b18 = mix(textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370)), 0.0), textureLod(s_ScatteringBuffer, vec3(var_b4ccc, var_7d045.y, float(var_b2370 + 1)), 0.0), vec4(clamp(var_eb2d5 - float(var_b2370), 0.0, 1.0)));
        var_f2e5a = var_51636 * var_36b18.w;
    }
    else
    {
        var_f2e5a = var_51636;
    }
    highp vec3 var_0ffa6;
    if (PreExposureEnabled.x > 0.0)
    {
        var_0ffa6 = var_f2e5a * ((0.180000007152557373046875 / var_fb10a) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_0ffa6 = var_f2e5a;
    }
    bgfx_FragData0 = vec4(var_0ffa6, 1.0);
}
