#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_CausticsTexture;
* - uniform lowp sampler2D s_MERSTexture;
* - uniform lowp sampler2D s_NormalTexture;
* - uniform lowp sampler2D s_ParticleTexture;
* - uniform highp samplerCubeArray s_PointLightShadowTextureArray;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - layout(binding = 8, std430) buffer s_zGpuEntryBufferBuffer { GpuVolumeEntry s_zGpuEntryBuffer[]; };
* - layout(binding = 9, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
* - layout(binding = 10, std430) buffer s_zLightsBuffer { Light s_zLights[]; };
* - layout(binding = 11, std430) buffer s_zVoxelBufferBuffer { VoxelNode s_zVoxelBuffer[]; };
*
* Uniforms:
* - uniform vec4 AmbientLightParams;
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
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggleAndShadowToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MERSUniforms;
* - uniform vec4 ManhattanDistAttenuationEnabled;
* - uniform vec4 MaterialID;
* - uniform vec4 NdLFloor;
* - uniform vec4 PBRTextureFlags;
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
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 Time;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterAlbedoExtinction;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WorldOrigin;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MERSTexture;
uniform highp sampler2D s_NormalTexture;
uniform highp sampler2D s_ParticleTexture;
uniform highp vec4 MERSUniforms;
uniform highp vec4 PBRTextureFlags;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec3 v_bitangent;
in highp vec4 v_color0;
in highp vec3 v_coloredLighting;
in highp vec4 v_fog;
in highp vec3 v_normal;
in highp vec3 v_tangent;
in highp vec2 v_texcoord0;
in highp vec2 v_vanillaLighting;
in highp vec3 v_worldPos;
layout(location = 0) out uvec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void func_fd1b4(inout highp vec4 arg_07931, inout bool arg_5e3ed) {
    if (arg_07931.w < 0.5)
    {
        arg_5e3ed = true;
        return;
    }
    arg_5e3ed = false;
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
    highp vec4 var_462d1 = v_color0;
    highp vec4 var_6ca24 = v_fog;
    highp vec4 var_d71e7 = texture(s_ParticleTexture, v_texcoord0);
    highp vec4 var_bdc42 = var_d71e7;
    bool var_c9230;
    func_fd1b4(var_bdc42, var_c9230);
    if (var_c9230)
    {
        discard;
    }
    highp vec4 var_c11b4 = var_d71e7 * vec4(v_color0.xyz, var_462d1.w);
    highp vec3 var_2cb07 = mix(var_c11b4.xyz, v_fog.xyz, vec3(var_6ca24.w));
    highp vec4 var_89833 = vec4(var_2cb07.x, var_2cb07.y, var_2cb07.z, var_c11b4.w);
    int var_bec18 = int(PBRTextureFlags.x);
    highp float var_b8805;
    highp float var_0d3d5;
    highp float var_245c0;
    highp float var_46b2c;
    if ((var_bec18 & 1) == 1)
    {
        highp vec4 var_4035b = texture(s_MERSTexture, v_texcoord0);
        highp float var_b362d;
        if ((var_bec18 & 2) == 2)
        {
            var_b362d = var_4035b.w;
        }
        else
        {
            var_b362d = MERSUniforms.w;
        }
        var_46b2c = var_b362d;
        var_245c0 = var_4035b.z;
        var_0d3d5 = var_4035b.y;
        var_b8805 = var_4035b.x;
    }
    else
    {
        var_46b2c = MERSUniforms.w;
        var_245c0 = MERSUniforms.z;
        var_0d3d5 = MERSUniforms.y;
        var_b8805 = MERSUniforms.x;
    }
    highp vec3 var_9e9f5;
    if ((var_bec18 & 4) == 4)
    {
        var_9e9f5 = transpose(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(v_normal)))) * ((texture(s_NormalTexture, v_texcoord0).xyz * 2.0) - vec3(1.0));
    }
    else
    {
        var_9e9f5 = v_normal;
    }
    highp vec4 var_39c01 = vec4(var_2cb07, var_89833.w);
    highp vec2 var_e52a8 = v_vanillaLighting;
    highp vec4 var_6bfdc = vec4(var_39c01.x, var_39c01.y, var_39c01.z, var_39c01.w);
    highp float var_7aa46;
    func_fb7ab(var_b8805, var_46b2c, var_7aa46);
    var_6bfdc.w = var_7aa46;
    highp vec3 var_089df = normalize(var_9e9f5);
    highp vec3 var_cd914 = var_089df;
    highp vec2 var_645ff = var_089df.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_532c2;
    if (var_cd914.z < 0.0)
    {
        var_532c2 = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_532c2 = var_645ff;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_603d8 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_603d8;
    highp vec4 var_eaa92 = u_prevViewProj * vec4(v_worldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_eaa92;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_d0ebc = ((var_eaa92 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_d0ebc;
    highp vec3 var_a461a = v_coloredLighting;
    highp vec3 var_98222;
    if ((((var_a461a.x + var_a461a.y) + var_a461a.z) < 9.9999997473787516355514526367188e-05) && (var_e52a8.x > 9.9999997473787516355514526367188e-05))
    {
        highp vec4 var_0bc6f = vec4(0.0);
        highp float var_9a19a = var_e52a8.x * var_e52a8.x;
        var_98222 = clamp(vec3(var_9a19a + (var_0bc6f.x * var_0bc6f.w), (var_9a19a * ((((var_9a19a * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.y * var_0bc6f.w), (var_9a19a * (((var_9a19a * var_9a19a) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.z * var_0bc6f.w)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_98222 = v_coloredLighting;
    }
    highp vec3 var_8f0e5 = var_98222 * vec3(0.16666667163372039794921875);
    highp vec4 var_f46ce = vec4(var_8f0e5, 0.0039215688593685626983642578125);
    highp vec2 var_8a7dd = max(var_f46ce.xy, var_f46ce.zw);
    highp float var_a7109 = ceil(clamp(max(var_8a7dd.x, var_8a7dd.y), 0.0, 1.0) * 255.0) * 0.0039215688593685626983642578125;
    uvec4 var_63c1c = uvec4(clamp(vec4(var_8f0e5 / vec3(var_a7109), var_a7109), vec4(0.0), vec4(1.0)) * 255.0);
    uvec2 var_768db = var_63c1c.xy;
    uvec2 var_f7a74 = uvec2(var_768db.x & 255u, var_768db.y & 255u);
    uvec2 var_cc1c7 = var_63c1c.zw;
    uvec2 var_8bc3e = uvec2(var_cc1c7.x & 255u, var_cc1c7.y & 255u);
    uvec2 var_12195 = uvec2((var_f7a74.x << 8u) | var_f7a74.y, (var_8bc3e.x << 8u) | var_8bc3e.y);
    uvec2 var_73d15 = uvec2(uint(clamp(var_245c0, 0.0, 1.0) * 255.0) & 255u, uint(clamp(var_0d3d5, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_73d15.x << 8u) | var_73d15.y, var_12195.x, var_12195.y, uint(clamp(var_e52a8.y, 0.0, 1.0) * 255.0));
    bgfx_FragData1 = var_6bfdc;
    bgfx_FragData2 = vec4(var_532c2, var_603d8.xy - var_d0ebc.xy);
}
