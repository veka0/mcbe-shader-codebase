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
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_BrdfLUT;
uniform highp sampler2D s_ColorMetalnessSubsurface;
uniform highp sampler2D s_EmissiveAmbientLinearRoughness;
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SSRTexture;
uniform highp sampler2D s_SceneDepth;
uniform highp sampler2DArray s_ScatteringBuffer;
uniform highp samplerCubeArray s_SpecularIBLRecords;
uniform highp vec4 AmbientLightParams;
uniform highp vec4 AtmosphericScatteringToggles;
uniform highp vec4 BlockBaseAmbientLightColorIntensity;
uniform highp vec4 BlockLightIndirectSpecularIntensity;
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
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
uniform highp vec4 WorldOrigin;
in highp vec3 v_projPosition;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void func_be4af(inout highp vec4 arg_9c5ab, inout highp float arg_92443, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec4 loc_ece96 = vec4(0.0, 0.0, 0.0, 1.0);
    highp float loc_71733 = arg_9c5ab.y * arg_9c5ab.y;
    highp vec3 loc_d908d = (((AmbientLightParams.xyz * AmbientLightParams.w) * (1.0 - arg_9c5ab.y)) + (((clamp(vec3(loc_71733 + (loc_ece96.x * loc_ece96.w), (loc_71733 * ((((loc_71733 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_ece96.y * loc_ece96.w), (loc_71733 * (((loc_71733 * loc_71733) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_ece96.z * loc_ece96.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x) * arg_9c5ab.y)) * arg_92443;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_d908d, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_d908d, 1.0);
}
void func_2e632(inout highp vec4 arg_9c5ab, inout highp float arg_92443, inout highp vec4 arg_85834) {
    highp vec4 loc_ece96 = vec4(0.0, 0.0, 0.0, 1.0);
    highp float loc_71733 = arg_9c5ab.y * arg_9c5ab.y;
    highp vec3 loc_e444b = (((AmbientLightParams.xyz * AmbientLightParams.w) * (1.0 - arg_9c5ab.y)) + (((clamp(vec3(loc_71733 + (loc_ece96.x * loc_ece96.w), (loc_71733 * ((((loc_71733 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_ece96.y * loc_ece96.w), (loc_71733 * (((loc_71733 * loc_71733) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (loc_ece96.z * loc_ece96.w)), vec3(0.0), vec3(1.0)) * BlockBaseAmbientLightColorIntensity.w) * BlockLightIndirectSpecularIntensity.x) * arg_9c5ab.y)) * arg_92443;
    if (0.0 >= dot(loc_e444b, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_e444b, 1.0);
}
void main() {
    highp vec4 var_d6549 = texture(s_SceneDepth, v_texcoord0);
    highp float var_971b7 = (var_d6549.x * 2.0) - 1.0;
    highp vec4 var_df846 = vec4(v_projPosition.xy, var_971b7, 1.0);
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
    highp vec3 var_b623b = normalize(normalize(vec3(var_c65e0.x, var_c65e0.y, var_e6b69.z)));
    highp vec3 var_19823 = normalize((u_view * vec4(var_b623b, 0.0)).xyz);
    highp vec4 var_ba7b0 = texture(s_ColorMetalnessSubsurface, v_texcoord0);
    highp vec4 var_ee5ba = var_ba7b0;
    highp float var_6c7cf = clamp(2.007874011993408203125 * (var_ee5ba.w - 0.501960813999176025390625), 0.0, 1.0);
    highp vec4 var_81126 = texture(s_EmissiveAmbientLinearRoughness, v_texcoord0);
    highp vec3 var_64e55 = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_6da5f = var_20845.xyz;
    highp vec3 var_599e1 = vec3(v_projPosition.xy, var_971b7);
    highp vec3 var_b12e6 = vec3(0.039999999105930328369140625 * (1.0 - var_6c7cf)) + (pow(max(var_ba7b0.xyz, vec3(0.0)), vec3(2.2000000476837158203125)) * var_6c7cf);
    highp float var_fb10a;
    if (PreExposureEnabled.x > 0.0)
    {
        var_fb10a = texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x;
    }
    else
    {
        var_fb10a = 0.0;
    }
    highp float var_eca07 = clamp(((var_81126.z * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0);
    highp float var_0c7d8 = ((var_eca07 * var_eca07) * var_eca07) * IBLParameters.x;
    highp float var_e6705 = length(var_6da5f);
    highp vec3 var_3f03f;
    if (SSRParameters.x != 0.0)
    {
        bool var_46a60 = PreExposureEnabled.x > 0.0;
        highp vec2 var_fcc55 = (var_599e1.xy + vec2(1.0)) * 0.5;
        var_fcc55.y = 1.0 - var_fcc55.y;
        var_fcc55 = vec2(var_fcc55.x, 1.0 - var_fcc55.y);
        highp vec3 var_7c2f6;
        highp vec3 var_bdee4;
        if (QuantizationParameters.w > 0.0)
        {
            highp vec3 var_86ba3 = var_64e55 - WorldOrigin.xyz;
            highp vec3 var_df277 = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_6da5f)), normalize(dFdy(var_6da5f)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
            highp vec3 var_dd37a = mod(var_86ba3, vec3(QuantizationParameters.z));
            highp vec3 var_f71ab = (round((var_86ba3 - (var_dd37a - (var_df277 * dot(var_dd37a, var_df277)))) / vec3(QuantizationPrecisionRoundingParameters.y)) * QuantizationPrecisionRoundingParameters.y) + WorldOrigin.xyz;
            highp vec4 var_d5962 = u_viewProj * vec4(var_f71ab, 1.0);
            highp vec4 var_412ca = var_d5962;
            highp vec3 var_f4c6b = var_d5962.xyz / vec3(var_412ca.w);
            var_f4c6b.y *= (-1.0);
            highp vec2 var_9b904 = (var_f4c6b.xy + vec2(1.0)) * 0.5;
            highp float var_74cec = var_9b904.x;
            highp float var_83bc9 = var_9b904.y;
            highp vec2 var_95d93 = vec2(var_74cec, 1.0 - var_83bc9);
            var_9b904 = var_95d93;
            var_fcc55 = var_95d93;
            var_bdee4 = (u_view * vec4(var_f71ab, 1.0)).xyz;
            var_7c2f6 = var_f71ab;
        }
        else
        {
            var_bdee4 = var_6da5f;
            var_7c2f6 = var_64e55;
        }
        highp vec4 var_fb4ec = texture(s_SSRTexture, var_fcc55);
        if (var_46a60)
        {
            highp vec3 var_417eb = var_fb4ec.xyz / vec3((0.180000007152557373046875 / var_fb10a) + 9.9999997473787516355514526367188e-05);
            var_fb4ec = vec4(var_417eb.x, var_417eb.y, var_417eb.z, var_fb4ec.w);
        }
        highp vec3 var_a56d9 = reflect(normalize(var_7c2f6 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_b623b);
        highp float var_0f441;
        if (int(ConvolutionType.x) == 1)
        {
            highp float var_0e6b6 = 1.0 - var_81126.w;
            var_0f441 = (1.0 - (var_0e6b6 * var_0e6b6)) * (IBLParameters.y - 1.0);
        }
        else
        {
            highp float var_8084c = 1.0 - var_81126.w;
            highp float var_e5afa = var_8084c * var_8084c;
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
            func_be4af(var_81126, var_6c7cf, var_8c1ad, var_26642);
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
        highp vec2 var_e6546 = vec2(clamp(dot(var_19823, -normalize(var_bdee4)), 0.0, 1.0), var_81126.w);
        var_e6546.y = 1.0 - var_e6546.y;
        highp vec2 var_f1a1e = texture(s_BrdfLUT, var_e6546).xy;
        var_3f03f = mix(var_83a0f, var_fb4ec.xyz, vec3(var_fb4ec.w * SSRParameters.y)) * ((var_b12e6 * var_f1a1e.x) + vec3(var_f1a1e.y));
    }
    else
    {
        highp vec3 var_89bfe;
        if (IBLParameters.x != 0.0)
        {
            highp vec3 var_ee8d4;
            highp vec3 var_31061;
            if (QuantizationParameters.w > 0.0)
            {
                highp vec3 var_50300 = var_64e55 - WorldOrigin.xyz;
                highp vec3 var_a31fe = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_6da5f)), normalize(dFdy(var_6da5f)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
                highp vec3 var_227f9 = mod(var_50300, vec3(QuantizationParameters.z));
                highp vec3 var_686d8 = (round((var_50300 - (var_227f9 - (var_a31fe * dot(var_227f9, var_a31fe)))) / vec3(QuantizationPrecisionRoundingParameters.y)) * QuantizationPrecisionRoundingParameters.y) + WorldOrigin.xyz;
                var_31061 = (u_view * vec4(var_686d8, 1.0)).xyz;
                var_ee8d4 = var_686d8;
            }
            else
            {
                var_31061 = var_6da5f;
                var_ee8d4 = var_64e55;
            }
            highp vec3 var_44ff1 = reflect(normalize(var_ee8d4 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_b623b);
            highp float var_622ee;
            if (int(ConvolutionType.x) == 1)
            {
                highp float var_37c9f = 1.0 - var_81126.w;
                var_622ee = (1.0 - (var_37c9f * var_37c9f)) * (IBLParameters.y - 1.0);
            }
            else
            {
                highp float var_0f4a8 = 1.0 - var_81126.w;
                highp float var_464ee = var_0f4a8 * var_0f4a8;
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
                func_be4af(var_81126, var_6c7cf, var_265a6, var_bf376);
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
            highp vec2 var_8f64c = vec2(clamp(dot(var_19823, -normalize(var_31061)), 0.0, 1.0), var_81126.w);
            var_8f64c.y = 1.0 - var_8f64c.y;
            highp vec2 var_bfc96 = texture(s_BrdfLUT, var_8f64c).xy;
            var_89bfe = var_0d46b * ((var_b12e6 * var_bfc96.x) + vec3(var_bfc96.y));
        }
        else
        {
            highp vec3 var_0fc0f;
            if (DiffuseSpecularEmissiveAmbientTermToggles.w != 0.0)
            {
                highp vec3 var_38a48;
                if (QuantizationParameters.w > 0.0)
                {
                    highp vec3 var_b9979 = var_64e55 - WorldOrigin.xyz;
                    highp vec3 var_5df2d = normalize(round(normalize((u_invView * vec4(normalize(cross(normalize(dFdx(var_6da5f)), normalize(dFdy(var_6da5f)))), 0.0)).xyz) / vec3(QuantizationPrecisionRoundingParameters.x)) * QuantizationPrecisionRoundingParameters.x);
                    highp vec3 var_8f632 = mod(var_b9979, vec3(QuantizationParameters.z));
                    var_38a48 = (u_view * vec4((round((var_b9979 - (var_8f632 - (var_5df2d * dot(var_8f632, var_5df2d)))) / vec3(QuantizationPrecisionRoundingParameters.y)) * QuantizationPrecisionRoundingParameters.y) + WorldOrigin.xyz, 1.0)).xyz;
                }
                else
                {
                    var_38a48 = var_6da5f;
                }
                highp vec4 var_5b282;
                func_2e632(var_81126, var_6c7cf, var_5b282);
                highp vec2 var_4c0a1 = vec2(clamp(dot(var_19823, -normalize(var_38a48)), 0.0, 1.0), var_81126.w);
                var_4c0a1.y = 1.0 - var_4c0a1.y;
                highp vec2 var_f7ae0 = texture(s_BrdfLUT, var_4c0a1).xy;
                var_0fc0f = var_5b282.xyz * ((var_b12e6 * var_f7ae0.x) + vec3(var_f7ae0.y));
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
        highp vec4 var_cf4b5 = u_invProj * vec4(v_projPosition.xy, var_971b7, 1.0);
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
    highp vec3 var_ec787;
    if (PreExposureEnabled.x > 0.0)
    {
        var_ec787 = var_f2e5a * ((0.180000007152557373046875 / var_fb10a) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_ec787 = var_f2e5a;
    }
    bgfx_FragColor = vec4(var_ec787, 1.0);
}
