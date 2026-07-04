#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
*
* Change_Color:
* - CHANGE_COLOR__MULTI (not used)
* - CHANGE_COLOR__OFF (not used)
* - CHANGE_COLOR__ON (not used)
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MERSTexture;
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_MatTexture1;
* - uniform lowp sampler2D s_NormalTexture;
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform mat4 Bones[8];
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 EmissiveUniform;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 GlintColor;
* - uniform vec4 HudOpacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
* - uniform vec4 MetalnessUniform;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 PBRTextureFlags;
* - uniform mat4 PrevBones[8];
* - uniform mat4 PrevWorld;
* - uniform vec4 RoughnessUniform;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceUniform;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
* - uniform vec4 UseAlphaRewrite;
* - uniform vec4 ViewPositionAndTime;
*/

uniform mat4 Bones[8];
uniform mat4 PrevBones[8];
uniform mat4 PrevWorld;
uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
uniform vec4 UVAnimation;
uniform vec4 UVScale;
in float a_indices;
in vec4 a_color0;
in vec4 a_normal;
in vec3 a_position;
in vec4 a_tangent;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec3 v_bitangent;
out vec4 v_clipPosition;
out vec4 v_color0;
out vec4 v_layerUv;
out vec3 v_normal;
out vec3 v_prevWorldPos;
out vec3 v_tangent;
centroid out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
    int var_c8e27 = int(a_indices);
    float var_97211 = sin(UVAnimation.z);
    float var_ce25b = cos(UVAnimation.z);
    vec2 var_98b8b = (a_texcoord0 - vec2(0.5)) * mat2(vec2(var_ce25b, -var_97211), vec2(var_97211, var_ce25b));
    var_98b8b.x += UVAnimation.x;
    vec2 var_eb807 = var_98b8b;
    vec2 var_e0bbc = var_eb807 + vec2(0.5);
    var_98b8b = var_e0bbc;
    vec2 var_1a9e2 = var_e0bbc * UVScale.xy;
    float var_89ba8 = sin(UVAnimation.w);
    float var_104e7 = cos(UVAnimation.w);
    vec2 var_65238 = (a_texcoord0 - vec2(0.5)) * mat2(vec2(var_104e7, -var_89ba8), vec2(var_89ba8, var_104e7));
    var_65238.x += UVAnimation.y;
    vec2 var_0ef75 = var_65238;
    vec2 var_a930f = var_0ef75 + vec2(0.5);
    var_65238 = var_a930f;
    vec2 var_fa5b0 = var_a930f * UVScale.xy;
    mat4 var_c7bcb = u_model[0] * Bones[var_c8e27];
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_e43a8;
    var_e43a8[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_e43a8[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_e43a8[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_e43a8[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
    vec4 var_96145 = var_e43a8 * vec4(a_position, 1.0);
#endif
#ifdef INSTANCING__OFF
    vec4 var_96145 = var_c7bcb * vec4(a_position, 1.0);
#endif
    mat4 var_bab0b = u_proj;
    var_bab0b[2].x += SubPixelOffset.x;
    var_bab0b[2].y -= SubPixelOffset.y;
    vec4 var_c804c = var_bab0b * (u_view * vec4(var_96145.xyz, 1.0));
    vec4 var_4c816 = a_tangent;
    v_bitangent = (var_c7bcb * vec4(cross(a_normal.xyz, a_tangent.xyz) * var_4c816.w, 0.0)).xyz;
    v_clipPosition = var_c804c;
    v_color0 = a_color0;
    v_layerUv = vec4(var_1a9e2.x, var_1a9e2.y, var_fa5b0.x, var_fa5b0.y);
    v_normal = (var_c7bcb * vec4(a_normal.xyz, 0.0)).xyz;
    v_prevWorldPos = ((PrevWorld * PrevBones[var_c8e27]) * vec4(a_position, 1.0)).xyz;
    v_tangent = (var_c7bcb * vec4(a_tangent.xyz, 0.0)).xyz;
    v_texcoord0 = a_texcoord0;
    v_worldPos = var_96145.xyz;
    gl_Position = var_c804c;
}
