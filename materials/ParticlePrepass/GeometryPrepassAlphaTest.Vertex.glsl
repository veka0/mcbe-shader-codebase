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
* - INSTANCING__OFF
* - INSTANCING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_CausticsTexture;
* - layout(binding = 7, std430) buffer s_GpuEntryBufferBuffer { GpuVolumeEntry s_GpuEntryBuffer[]; };
* - uniform lowp sampler2D s_MERSTexture;
* - uniform lowp sampler2D s_NormalTexture;
* - uniform lowp sampler2D s_ParticleTexture;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform highp sampler2DArray s_ScatteringBuffer;
* - uniform highp sampler2DArray s_ShadowCascades;
* - layout(binding = 8, std430) buffer s_VoxelBufferBuffer { VoxelNode s_VoxelBuffer[]; };
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
* - uniform vec4 NdLFloor;
* - uniform vec4 PBRTextureFlags;
* - uniform mat4 PlayerShadowProj;
* - uniform vec4 PointLightNdLFloor;
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

uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
uniform vec4 SubPixelOffset;
in vec4 a_color0;
in vec4 a_normal;
in vec2 a_texcoord1;
in vec3 a_position;
in vec4 a_tangent;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec3 v_bitangent;
out vec4 v_color0;
out vec3 v_coloredLighting;
out vec4 v_fog;
out vec3 v_normal;
out vec3 v_prevWorldPos;
out vec3 v_tangent;
out vec2 v_texcoord0;
out vec2 v_vanillaLighting;
out vec3 v_worldPos;
void main() {
    vec4 var_ab86e = vec4(0.0);
    vec2 var_962be = a_texcoord1;
    uint var_acaed = uint(var_962be.x * 65535.0) & 65535u;
    uint var_ff4c7 = uint(var_962be.y * 65535.0) & 65535u;
    uvec4 var_36a75 = uvec4(var_acaed >> 8u, var_acaed & 255u, var_ff4c7 >> 8u, var_ff4c7 & 255u);
    uvec4 var_fc127 = var_36a75;
    uvec4 var_0245b = var_36a75;
#ifdef INSTANCING__OFF
    vec4 var_a67a8 = u_model[0] * vec4(a_position, 1.0);
#endif
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_e43a8;
    var_e43a8[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_e43a8[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_e43a8[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_e43a8[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
    vec4 var_a67a8 = var_e43a8 * vec4(a_position, 1.0);
#endif
    vec4 var_4938b = a_tangent;
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_8e1af = u_proj;
    var_8e1af[2] = var_67767;
    v_bitangent = (u_model[0] * vec4(cross(a_normal.xyz, a_tangent.xyz) * var_4938b.w, 0.0)).xyz;
    v_color0 = a_color0;
    v_coloredLighting = vec3(var_36a75.xyz) * vec3(0.0039215688593685626983642578125);
    v_fog = vec4(FogColor.xyz, clamp(((var_ab86e.z / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_normal = a_normal.xyz;
    v_prevWorldPos = vec3(0.0);
    v_tangent = (u_model[0] * vec4(a_tangent.xyz, 0.0)).xyz;
    v_texcoord0 = a_texcoord0;
    v_vanillaLighting = vec2(float((var_fc127.w >> uint(4)) & 15u) * 0.066666670143604278564453125, float(var_0245b.w & 15u) * 0.066666670143604278564453125);
    v_worldPos = var_a67a8.xyz;
    gl_Position = var_8e1af * (u_view * vec4(var_a67a8.xyz, 1.0));
}
