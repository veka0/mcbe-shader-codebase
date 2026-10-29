#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
*
* Dithering:
* - DITHERING__OFF (not used)
* - DITHERING__ON (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* Seasons:
* - SEASONS__OFF (not used)
* - SEASONS__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_LightMapTexture;
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 3, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform lowp sampler2D s_SeasonsTexture;
*
* Uniforms:
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 GlobalRoughness;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 ViewPositionAndTime;
*/

uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
uniform vec4 ViewPositionAndTime;
in vec4 a_color0;
in vec2 a_texcoord1;
in vec4 a_normal;
in float a_texcoord4;
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
out vec2 v_ditheringAndMaskTinting;
flat out int v_frontFacing;
out vec3 v_lightColor;
out vec2 v_lightmapUV;
out vec3 v_normal;
flat out int v_pbrTextureId;
out vec3 v_tangent;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#ifdef INSTANCING__ON
    mat4 var_01008;
    var_01008[0] = vec4(i_data1.x, i_data2.x, i_data3.x, 0.0);
    var_01008[1] = vec4(i_data1.y, i_data2.y, i_data3.y, 0.0);
    var_01008[2] = vec4(i_data1.z, i_data2.z, i_data3.z, 0.0);
    var_01008[3] = vec4(i_data1.w, i_data2.w, i_data3.w, 1.0);
#endif
    vec3 var_c39b1 = a_color0.xyz;
#ifdef INSTANCING__OFF
    vec3 var_9891c = (u_model[0] * vec4(a_position, 1.0)).xyz + vec3(0.5);
#endif
#ifdef INSTANCING__ON
    vec3 var_9891c = (var_01008 * vec4(a_position, 1.0)).xyz + vec3(0.5);
#endif
    vec3 var_f280f = normalize(var_9891c - ViewPositionAndTime.xyz);
    vec3 var_d3ea2 = normalize(cross(vec3(0.0, 1.0, 0.0), var_f280f));
    vec3 var_96a48 = var_9891c - ((cross(var_f280f, var_d3ea2) * (var_c39b1.z - 0.5)) + (var_d3ea2 * (var_c39b1.x - 0.5)));
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_22b9d = u_proj;
    var_22b9d[2] = var_67767;
    uvec2 var_6c76e = uvec2(round(a_texcoord0 * 65535.0));
    vec2 var_45935 = vec2(float((var_6c76e.x & 32767u) << uint(1)), float((var_6c76e.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    var_45935.x += (3.0517578125e-05 * ((2.0 * float((var_6c76e.x & 32768u) >> uint(15))) - 1.0));
    var_45935.y += (3.0517578125e-05 * ((2.0 * float((var_6c76e.y & 32768u) >> uint(15))) - 1.0));
    uvec2 var_b33a4 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 var_5e4ed = var_b33a4;
    uvec2 var_09f26 = (var_b33a4 >> uvec2(8u)) & uvec2(255u);
    uvec2 var_d188a = var_b33a4 & uvec2(255u);
    uvec2 var_021ab = var_09f26 & uvec2(254u);
    vec4 var_f1f3d = vec4(vec3(float(var_021ab.x), float(var_d188a.x), float(var_021ab.y)) * vec3(0.0039215688593685626983642578125), (a_normal.w * 0.5) + 0.5);
    vec4 var_22492 = var_f1f3d;
    v_bitangent = (u_model[0] * vec4(cross(a_normal.xyz, a_tangent.xyz) * a_tangent.w, 0.0)).xyz;
    v_color0 = vec4(1.0);
    v_ditheringAndMaskTinting = vec2(notEqual((var_09f26 & uvec2(1u)), uvec2(0u)));
    v_frontFacing = 0;
    v_lightColor = (var_f1f3d.xyz * var_22492.w) * 6.0;
    v_lightmapUV = vec2(uvec2(var_5e4ed.y >> 4u, var_5e4ed.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_normal = (u_model[0] * vec4(a_normal.xyz, 0.0)).xyz;
    v_pbrTextureId = int(a_texcoord4) & 65535;
    v_tangent = (u_model[0] * vec4(a_tangent.xyz, 0.0)).xyz;
    v_texcoord0 = var_45935;
    v_worldPos = var_96a48;
    gl_Position = var_22b9d * (u_view * vec4(var_96a48, 1.0));
}
