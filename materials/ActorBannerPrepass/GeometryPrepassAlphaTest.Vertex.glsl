#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Change_Color:
* - CHANGE_COLOR__MULTI (not used)
* - CHANGE_COLOR__OFF (not used)
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
* Tinting:
* - TINTING__DISABLED
* - TINTING__ENABLED
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
* - uniform vec4 BannerBasePBRTextureData[4];
* - uniform vec4 BannerColors[7];
* - uniform vec4 BannerUVOffsetsAndScales[7];
* - uniform mat4 Bones[8];
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 EmissiveUniform;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
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
* - uniform vec4 UseAlphaRewrite;
* - uniform vec4 ViewPositionAndTime;
*/

#ifdef INSTANCING__OFF
uniform mat4 Bones[8];
uniform mat4 u_model[4];
#endif
uniform mat4 u_proj;
uniform mat4 u_view;
#ifdef TINTING__ENABLED
uniform vec4 BannerColors[7];
#endif
uniform vec4 BannerUVOffsetsAndScales[7];
uniform vec4 SubPixelOffset;
uniform vec4 UVAnimation;
#ifdef INSTANCING__OFF
in float a_indices;
#endif
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec3 v_bitangent;
out vec4 v_color0;
flat out int v_frontFacing;
out vec3 v_normal;
out vec3 v_prevWorldPos;
out vec3 v_tangent;
centroid out vec2 v_texcoord0;
centroid out vec4 v_texcoords;
out vec3 v_worldPos;
void main() {
    vec2 var_be3b2 = UVAnimation.xy + (a_texcoord0 * UVAnimation.zw);
#ifdef INSTANCING__OFF
    vec4 var_19bff = (u_model[0] * Bones[int(a_indices)]) * vec4(a_position, 1.0);
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
    vec4 var_19bff = var_e43a8 * vec4(a_position, 1.0);
#endif
    vec4 var_db20e = a_color0;
    mat4 var_be69c = u_proj;
    var_be69c[2].x += SubPixelOffset.x;
    var_be69c[2].y -= SubPixelOffset.y;
    int var_e5df4 = int(var_db20e.w * 255.0);
    vec2 var_838f4 = (BannerUVOffsetsAndScales[var_e5df4].zw * var_be3b2) + BannerUVOffsetsAndScales[var_e5df4].xy;
    vec2 var_ad668 = (BannerUVOffsetsAndScales[0].zw * var_be3b2) + BannerUVOffsetsAndScales[0].xy;
#ifdef TINTING__ENABLED
    vec4 var_55bfd = BannerColors[var_e5df4];
    var_55bfd.w = 1.0;
    if (var_e5df4 > 0)
    {
        var_55bfd.w = 0.0;
    }
#endif
    v_bitangent = vec3(0.0);
#ifdef TINTING__DISABLED
    v_color0 = a_color0;
#endif
#ifdef TINTING__ENABLED
    v_color0 = var_55bfd;
#endif
    v_frontFacing = 0;
    v_normal = vec3(0.0);
    v_prevWorldPos = vec3(0.0);
    v_tangent = vec3(0.0);
    v_texcoord0 = var_be3b2;
    v_texcoords = vec4(var_838f4.x, var_838f4.y, var_ad668.x, var_ad668.y);
    v_worldPos = var_19bff.xyz;
    gl_Position = var_be69c * (u_view * vec4(var_19bff.xyz, 1.0));
}
