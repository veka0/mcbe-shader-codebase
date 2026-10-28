#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEBUG_BLIT_PASS (not used)
* - DEBUG_BLIT_VOXEL_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 6, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_Normal;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_RasterColor;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - layout(binding = 7, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
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
* - uniform vec4 ClipPlanes;
* - uniform mat4 CloudShadowProj;
* - uniform vec4 CloudShadowsVisible;
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 DebugMode;
* - uniform vec4 DiffuseSpecularEmissiveAmbientTermToggles;
* - uniform vec4 DirectionalLightSkyLightHeuristicToggles;
* - uniform vec4 DirectionalLightSourceDiffuseColorAndIlluminance;
* - uniform vec4 DirectionalLightSourceShadowDirection;
* - uniform vec4 DirectionalLightSourceWorldSpaceDirection;
* - uniform vec4 DirectionalLightToggleAndMaxDistanceAndMaxCascadesPerLightAndGPUBlockLightingEnabled;
* - uniform vec4 DirectionalShadowModeAndCloudShadowToggleAndPointLightToggle;
* - uniform vec4 EmissiveMultiplierAndDesaturationAndCloudPCFAndContribution;
* - uniform vec4 FirstPersonPlayerShadowsEnabledAndResolutionAndFilterWidthAndTextureDimensions;
* - uniform vec4 GpuEntryBufferCapacity;
* - uniform vec4 NdLFloor;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightNdLFloor;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 QuantizationParameters;
* - uniform vec4 QuantizationPrecisionRoundingParameters;
* - uniform vec4 ShadowFilterOffsetAndRangeFarAndMapSizeAndNormalOffsetStrength;
* - uniform vec4 SkyAmbientLightColorIntensity;
* - uniform vec4 SubsurfaceScatteringContributionAndDiffuseWrapValueAndFalloffScale;
* - uniform vec4 Time;
* - uniform vec4 ViewportScale;
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeLayer;
* - uniform vec4 VolumeNearFar;
* - uniform vec4 VolumeScatteringEnabledAndPointLightVolumetricsEnabled;
* - uniform vec4 WaterAlbedoExtinction;
* - uniform vec4 WaterExtinctionCoefficients;
* - uniform vec4 WorldOrigin;
*/

precision mediump float;
precision highp int;
struct VoxelNode {
    uint data;
};

struct GpuVolumeEntry {
    int packed_xy;
    int packed_zw;
    int hash;
    int user_data;
};

layout(binding = 7, std430) buffer s_VoxelBuffer { VoxelNode VoxelBuffer[]; } var_77fa1;
layout(binding = 6, std430) buffer s_GpuEntryBuffer { GpuVolumeEntry GpuEntryBuffer[]; } var_70434;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp sampler2D s_Normal;
uniform highp sampler2D s_RasterColor;
uniform highp vec4 GpuEntryBufferCapacity;
uniform highp vec4 VolumeLayer;
uniform highp vec4 WorldOrigin;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_33953(inout uint arg_a601e, inout highp vec3 arg_aa7d7) {
    if (var_77fa1.VoxelBuffer[arg_a601e].data == 0u)
    {
        arg_aa7d7 = vec3(0.0);
        return;
    }
    highp vec4 loc_11fc1 = vec4(uvec4(var_77fa1.VoxelBuffer[arg_a601e].data, var_77fa1.VoxelBuffer[arg_a601e].data >> 8u, var_77fa1.VoxelBuffer[arg_a601e].data >> 16u, var_77fa1.VoxelBuffer[arg_a601e].data >> 24u) & uvec4(255u)) * vec4(0.0039215688593685626983642578125);
    highp vec4 loc_3ff2a = loc_11fc1;
    arg_aa7d7 = (loc_11fc1.xyz * loc_3ff2a.w) * 6.0;
}
void main() {
    highp vec2 var_b6a7e = v_texcoord0;
    var_b6a7e = vec2(var_b6a7e.x, 1.0 - var_b6a7e.y);
    highp float var_c2b62 = var_b6a7e.x;
    highp float var_ace1a = var_b6a7e.y;
    highp vec2 var_33f11 = vec2(var_c2b62, 1.0 - var_ace1a);
    var_b6a7e = var_33f11;
    highp vec4 var_e8719 = vec4((var_33f11 * 2.0) - vec2(1.0), (texture(s_RasterColor, v_texcoord0).x * 2.0) - 1.0, 1.0);
    highp mat4 var_4fa47 = u_invProj;
    highp mat4 var_498b7 = u_invProj;
    highp mat4 var_4882d = u_invProj;
    highp mat4 var_78c1b = u_invProj;
    highp mat4 var_40575 = u_invProj;
    highp float var_eb413 = var_e8719.x;
    highp float var_ac116 = var_e8719.y;
    highp float var_f2b7c = var_e8719.w;
    highp float var_0357c = var_e8719.z;
    highp float var_2c821 = var_e8719.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_4fa47[0].x, var_ac116 * var_498b7[1].y, var_f2b7c * var_4882d[3].z, (var_0357c * var_78c1b[2].w) + (var_2c821 * var_40575[3].w));
    var_e8719 = var_9666f;
    highp float var_d799e = var_e8719.w;
    highp vec4 var_ded0e = var_9666f / vec4(var_d799e);
    var_e8719 = var_ded0e;
    highp vec4 var_158bd = texture(s_Normal, v_texcoord0);
    highp vec2 var_745cb = var_158bd.xy;
    highp vec3 var_b0cb0 = vec3(var_158bd.xy, (1.0 - abs(var_745cb.x)) - abs(var_745cb.y));
    highp vec2 var_04d49;
    if (var_b0cb0.z < 0.0)
    {
        var_04d49 = (vec2(1.0) - abs(var_b0cb0.yx)) * ((step(vec2(0.0), var_b0cb0.xy) * 2.0) - vec2(1.0));
    }
    else
    {
        var_04d49 = var_b0cb0.xy;
    }
    highp vec3 var_9a51f = var_b0cb0;
    var_b0cb0 = vec3(var_04d49.x, var_04d49.y, var_9a51f.z);
    highp vec3 var_a7b8b = ((u_invView * vec4(var_ded0e.xyz, 1.0)).xyz - WorldOrigin.xyz) + (normalize(vec3(var_04d49.x, var_04d49.y, var_9a51f.z)) * 0.20000000298023223876953125);
    ivec4 var_57533 = ivec4(ivec3(floor(vec3(ivec3(floor(var_a7b8b))) * vec3(0.0625))), int(VolumeLayer.x));
    ivec4 var_ed134 = var_57533;
    int var_b6453 = (var_ed134.x & 65535) | (var_ed134.y << 16);
    int var_3146c = (var_ed134.z & 65535) | (var_ed134.w << 16);
    ivec4 var_22622 = var_57533;
    uint var_1a3f6 = uint(var_22622.x) * 1540483477u;
    uint var_ae8c8 = uint(var_22622.y) * 1540483477u;
    uint var_08aa3 = uint(var_22622.z) * 1540483477u;
    uint var_18d3c = uint(var_22622.w) * 1540483477u;
    uint var_fc500 = ((((((2293326976u ^ ((var_1a3f6 ^ (var_1a3f6 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_ae8c8 ^ (var_ae8c8 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_08aa3 ^ (var_08aa3 >> uint(24))) * 1540483477u)) * 1540483477u) ^ ((var_18d3c ^ (var_18d3c >> uint(24))) * 1540483477u);
    uint var_7eea2 = (var_fc500 ^ (var_fc500 >> uint(13))) * 1540483477u;
    uint var_63731 = var_7eea2 ^ (var_7eea2 >> uint(15));
    uint var_8322c = (var_63731 ^ (var_63731 >> uint(16))) & 65535u;
    uint var_28df8 = var_8322c | uint(var_8322c == 0u);
    uint var_6cfcb = uint(GpuEntryBufferCapacity.x);
    int var_51ba1;
    uint var_38f07;
    bool var_064aa;
    uint var_23e5d;
    var_23e5d = 0u;
    var_064aa = false;
    var_38f07 = var_28df8 & (var_6cfcb - 1u);
    var_51ba1 = 0;
    bool var_06f21;
    uint var_8736f;
    uint var_5f390;
    uint var_ae215;
    bool var_c4f05;
    for (;;)
    {
        if (var_51ba1 < 8)
        {
            uint var_93adf = uint(var_70434.GpuEntryBuffer[var_38f07].hash) & 65535u;
            bool var_1ceed = var_93adf == var_28df8;
            bool var_bd56d;
            if (var_1ceed)
            {
                var_bd56d = var_70434.GpuEntryBuffer[var_38f07].packed_xy == var_b6453;
            }
            else
            {
                var_bd56d = var_1ceed;
            }
            bool var_e2d67;
            if (var_bd56d)
            {
                var_e2d67 = var_70434.GpuEntryBuffer[var_38f07].packed_zw == var_3146c;
            }
            else
            {
                var_e2d67 = var_bd56d;
            }
            if (var_064aa)
            {
                var_5f390 = var_23e5d;
            }
            else
            {
                uint var_4f4ff;
                if (var_e2d67)
                {
                    var_4f4ff = uint(var_70434.GpuEntryBuffer[var_38f07].user_data);
                }
                else
                {
                    var_4f4ff = var_23e5d;
                }
                var_5f390 = var_4f4ff;
            }
            var_06f21 = var_064aa || var_e2d67;
            var_8736f = (var_38f07 + 1u) & (var_6cfcb - 1u);
            if (var_06f21 || (var_93adf == 0u))
            {
                var_c4f05 = var_06f21;
                var_ae215 = var_5f390;
                break;
            }
            var_23e5d = var_5f390;
            var_064aa = var_06f21;
            var_38f07 = var_8736f;
            var_51ba1++;
            continue;
        }
        else
        {
            var_c4f05 = var_064aa;
            var_ae215 = var_23e5d;
            break;
        }
    }
    highp vec3 var_54f91;
    if (var_c4f05)
    {
        uvec3 var_ffb7a = uvec3(floor(var_a7b8b - (floor(var_a7b8b * 0.0625) * 16.0))) & uvec3(15u);
        uint var_5a78b = (var_ae215 >> 2u) + ((var_ffb7a.y + (var_ffb7a.z * 16u)) + (var_ffb7a.x * 256u));
        highp vec3 var_bf963;
        func_33953(var_5a78b, var_bf963);
        var_54f91 = var_bf963;
    }
    else
    {
        var_54f91 = vec3(0.0);
    }
    bgfx_FragData0 = vec4(pow(var_54f91, vec3(0.4545454680919647216796875)), 1.0);
}
