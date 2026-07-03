#version 310 es

/*
* Available Macros:
*
* Passes:
* - DO_DEFERRED_SHADING_PASS (not used)
* - DO_INDIRECT_SPECULAR_SHADING_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BrdfLUT;
* - uniform lowp sampler2D s_CausticsTexture;
* - uniform lowp sampler2D s_ColorMetalnessSubsurface;
* - uniform lowp sampler2D s_EmissiveAmbientLinearRoughness;
* - layout(binding = 4, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
* - layout(binding = 5, std430) buffer s_LightsBuffer { Light s_Lights[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform highp sampler2DArray s_PointLightShadowTextureArray;
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
* - uniform mat4 PointLightProj;
* - uniform vec4 PointLightShadowParams1;
* - uniform vec4 PointLightSpecularFadeOutParameters;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SSRParameters;
* - uniform vec4 ShadowBias;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSize;
* - uniform vec4 ShadowPCFWidth;
* - uniform vec4 ShadowQuantizationParameters;
* - uniform vec4 ShadowSlopeBias;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SkyHorizonColor;
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
uniform highp vec4 FogAndDistanceControl;
uniform highp vec4 IBLParameters;
uniform highp vec4 IBLSkyFadeParameters;
uniform highp vec4 LastSpecularIBLIdx;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 RenderChunkFogAlpha;
uniform highp vec4 SSRParameters;
uniform highp vec4 VolumeDimensions;
uniform highp vec4 VolumeNearFar;
uniform highp vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
in highp vec3 v_projPosition;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void func_fc162(inout highp float arg_dba2b, inout highp vec3 arg_ec4b7, inout highp vec4 arg_85834) {
    highp vec3 loc_87280 = (AmbientLightParams.xyz * arg_dba2b) * AmbientLightParams.w;
    if (dot(arg_ec4b7, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) >= dot(loc_87280, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)))
    {
        arg_85834 = vec4(0.0);
        return;
    }
    arg_85834 = vec4(loc_87280, 1.0);
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
    highp vec3 var_2ea2c = normalize((u_view * vec4(var_b623b, 0.0)).xyz);
    highp vec4 var_124e5 = texture(s_ColorMetalnessSubsurface, v_texcoord0);
    highp vec4 var_ee5ba = var_124e5;
    highp float var_e1848 = clamp(2.007874011993408203125 * (var_ee5ba.w - 0.501960813999176025390625), 0.0, 1.0);
    highp vec4 var_af3e6 = texture(s_EmissiveAmbientLinearRoughness, v_texcoord0);
    highp vec3 var_4a974 = (u_invView * vec4(var_20845.xyz, 1.0)).xyz;
    highp vec3 var_8b5df = var_20845.xyz;
    highp vec3 var_9c3d8 = vec3(v_projPosition.xy, var_971b7);
    highp vec3 var_e707f = pow(max(var_124e5.xyz, vec3(0.0)), vec3(2.2000000476837158203125));
    highp vec3 var_01a33 = vec3(0.039999999105930328369140625 * (1.0 - var_e1848)) + (var_e707f * var_e1848);
    highp float var_fb10a;
    if (PreExposureEnabled.x > 0.0)
    {
        var_fb10a = texture(s_PreviousFrameAverageLuminance, vec2(0.5)).x;
    }
    else
    {
        var_fb10a = 0.0;
    }
    highp float var_f9a87 = pow(clamp(((var_af3e6.z * 16.0) - IBLSkyFadeParameters.y) / max(IBLSkyFadeParameters.x - IBLSkyFadeParameters.y, 1.0), 0.0, 1.0), 3.0) * IBLParameters.x;
    highp float var_18f5e = length(var_8b5df);
    highp vec3 var_fd31b;
    if (SSRParameters.x != 0.0)
    {
        bool var_46a60 = PreExposureEnabled.x > 0.0;
        highp vec4 var_35532 = texture(s_SSRTexture, (var_9c3d8.xy + vec2(1.0)) * 0.5);
        if (var_46a60)
        {
            highp vec3 var_417eb = var_35532.xyz / vec3((0.180000007152557373046875 / var_fb10a) + 9.9999997473787516355514526367188e-05);
            var_35532 = vec4(var_417eb.x, var_417eb.y, var_417eb.z, var_35532.w);
        }
        highp vec3 var_a5d2d = reflect(normalize(var_4a974 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_b623b);
        bool var_fb1b0 = abs(var_a5d2d.y) > abs(var_a5d2d.x);
        bool var_50203;
        if (var_fb1b0)
        {
            var_50203 = abs(var_a5d2d.y) > abs(var_a5d2d.z);
        }
        else
        {
            var_50203 = var_fb1b0;
        }
        if (var_50203)
        {
            var_a5d2d.z *= (-1.0);
        }
        else
        {
            var_a5d2d.y *= (-1.0);
        }
        highp float var_f6d0e = 1.0 - var_af3e6.w;
        highp float var_59d83 = (1.0 - (var_f6d0e * var_f6d0e)) * (IBLParameters.y - 1.0);
        int var_ae27f = int(LastSpecularIBLIdx.x);
        highp vec3 var_96496 = mix(textureLod(s_SpecularIBLRecords, vec4(var_a5d2d, float((var_ae27f + 2) % 3)), var_59d83).xyz, textureLod(s_SpecularIBLRecords, vec4(var_a5d2d, float(var_ae27f)), var_59d83).xyz, vec3(IBLParameters.w));
        highp vec3 var_a8ded;
        if (var_46a60)
        {
            var_a8ded = var_96496 * vec3(5.552470684051513671875);
        }
        else
        {
            var_a8ded = var_96496;
        }
        highp vec2 var_22f95 = texture(s_BrdfLUT, vec2(clamp(dot(var_2ea2c, -(var_8b5df / vec3(var_18f5e))), 0.0, 1.0), var_af3e6.w)).xy;
        var_fd31b = mix((var_a8ded * var_f9a87) * IBLParameters.z, var_35532.xyz, vec3(var_35532.w * SSRParameters.y)) * (((vec3(0.039999999105930328369140625 * (1.0 - var_e1848)) + (var_e707f * var_e1848)) * var_22f95.x) + vec3(var_22f95.y));
    }
    else
    {
        highp vec3 var_1f98d;
        if (IBLParameters.x != 0.0)
        {
            highp vec3 var_bc3e5 = reflect(normalize(var_4a974 - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz), var_b623b);
            bool var_6cc03 = abs(var_bc3e5.y) > abs(var_bc3e5.x);
            bool var_49a91;
            if (var_6cc03)
            {
                var_49a91 = abs(var_bc3e5.y) > abs(var_bc3e5.z);
            }
            else
            {
                var_49a91 = var_6cc03;
            }
            if (var_49a91)
            {
                var_bc3e5.z *= (-1.0);
            }
            else
            {
                var_bc3e5.y *= (-1.0);
            }
            highp float var_e38f7 = 1.0 - var_af3e6.w;
            highp float var_f9267 = (1.0 - (var_e38f7 * var_e38f7)) * (IBLParameters.y - 1.0);
            int var_0a0b1 = int(LastSpecularIBLIdx.x);
            highp vec3 var_249bf = mix(textureLod(s_SpecularIBLRecords, vec4(var_bc3e5, float((var_0a0b1 + 2) % 3)), var_f9267).xyz, textureLod(s_SpecularIBLRecords, vec4(var_bc3e5, float(var_0a0b1)), var_f9267).xyz, vec3(IBLParameters.w));
            highp vec3 var_2b961;
            if (PreExposureEnabled.x > 0.0)
            {
                var_2b961 = var_249bf * vec3(5.552470684051513671875);
            }
            else
            {
                var_2b961 = var_249bf;
            }
            highp vec3 var_05cc2 = (var_2b961 * var_f9a87) * IBLParameters.z;
            highp vec4 var_617d6;
            func_fc162(var_e1848, var_05cc2, var_617d6);
            highp vec4 var_fb83f = var_617d6;
            highp vec3 var_e28a4;
            if (var_fb83f.w == 1.0)
            {
                var_e28a4 = var_617d6.xyz;
            }
            else
            {
                var_e28a4 = var_05cc2;
            }
            highp vec2 var_637eb = texture(s_BrdfLUT, vec2(clamp(dot(var_2ea2c, -(var_8b5df / vec3(var_18f5e))), 0.0, 1.0), var_af3e6.w)).xy;
            var_1f98d = var_e28a4 * ((var_01a33 * var_637eb.x) + vec3(var_637eb.y));
        }
        else
        {
            highp vec2 var_518b5 = texture(s_BrdfLUT, vec2(clamp(dot(var_2ea2c, -(var_8b5df / vec3(var_18f5e))), 0.0, 1.0), var_af3e6.w)).xy;
            var_1f98d = ((AmbientLightParams.xyz * var_e1848) * AmbientLightParams.w) * ((var_01a33 * var_518b5.x) + vec3(var_518b5.y));
        }
        var_fd31b = var_1f98d;
    }
    highp vec3 var_51636;
    if (AtmosphericScatteringToggles.x != 0.0)
    {
        var_51636 = var_fd31b * (1.0 - clamp((((var_18f5e / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) * FogAndDistanceControl.y, 0.0, 1.0));
    }
    else
    {
        var_51636 = var_fd31b * (1.0 - clamp((((var_18f5e / FogAndDistanceControl.z) + RenderChunkFogAlpha.x) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    }
    highp vec3 var_f2e5a;
    if (VolumeScatteringEnabledAndPointLightVolumetricsEnabled.x != 0.0)
    {
        highp vec2 var_65315 = VolumeNearFar.xy;
        highp vec2 var_7d045 = (var_9c3d8.xy + vec2(1.0)) * 0.5;
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
