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
* Dithering:
* - DITHERING__OFF (not used)
* - DITHERING__ON (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF
* - RENDER_AS_BILLBOARDS__ON
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
* - layout(binding = 2, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform lowp sampler2D s_SeasonsTexture;
*
* Uniforms:
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 GlobalRoughness;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 ViewPositionAndTime;
*/

uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
#ifdef RENDER_AS_BILLBOARDS__ON
uniform vec4 ViewPositionAndTime;
#endif
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
out vec4 v_clipPosition;
out vec4 v_color0;
out vec2 v_ditheringAndMaskTinting;
flat out int v_frontFacing;
out vec2 v_lightmapUV;
out vec3 v_normal;
flat out int v_pbrTextureId;
out vec3 v_tangent;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#if defined(INSTANCING__OFF) && defined(RENDER_AS_BILLBOARDS__OFF)
    vec4 var_e2d09 = u_model[0] * vec4(a_position, 1.0);
#endif
#if defined(INSTANCING__OFF) && defined(RENDER_AS_BILLBOARDS__ON)
    vec3 var_7136d = (u_model[0] * vec4(a_position, 1.0)).xyz + vec3(0.5);
    vec3 var_f280f = normalize(var_7136d - ViewPositionAndTime.xyz);
    vec3 var_d3ea2 = normalize(cross(vec3(0.0, 1.0, 0.0), var_f280f));
    vec3 var_c39b1 = a_color0.xyz;
    vec3 var_05010 = var_7136d - ((cross(var_f280f, var_d3ea2) * (var_c39b1.z - 0.5)) + (var_d3ea2 * (var_c39b1.x - 0.5)));
#endif
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_9010c;
    var_9010c[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_9010c[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_9010c[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_9010c[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
#endif
#if defined(INSTANCING__ON) && defined(RENDER_AS_BILLBOARDS__OFF)
    vec4 var_e2d09 = var_9010c * vec4(a_position, 1.0);
#endif
#if defined(INSTANCING__ON) && defined(RENDER_AS_BILLBOARDS__ON)
    vec3 var_2071d = (var_9010c * vec4(a_position, 1.0)).xyz + vec3(0.5);
    vec3 var_85f78 = normalize(var_2071d - ViewPositionAndTime.xyz);
    vec3 var_e10ad = normalize(cross(vec3(0.0, 1.0, 0.0), var_85f78));
    vec3 var_0c400 = a_color0.xyz;
    vec3 var_05010 = var_2071d - ((cross(var_85f78, var_e10ad) * (var_0c400.z - 0.5)) + (var_e10ad * (var_0c400.x - 0.5)));
#endif
    mat4 var_f3461 = u_proj;
    var_f3461[2].x += SubPixelOffset.x;
    var_f3461[2].y -= SubPixelOffset.y;
#ifdef RENDER_AS_BILLBOARDS__OFF
    vec4 var_d80ab = var_f3461 * (u_view * vec4(var_e2d09.xyz, 1.0));
#endif
#ifdef RENDER_AS_BILLBOARDS__ON
    vec4 var_d80ab = var_f3461 * (u_view * vec4(var_05010, 1.0));
#endif
    vec4 var_4938b = a_tangent;
    vec2 var_c34f1 = a_texcoord1;
    uint var_960bd = uint(floor(var_c34f1.x * 255.0));
    uint var_d0d1e = uint(floor(var_c34f1.y * 255.0));
    v_bitangent = (u_model[0] * vec4(cross(a_normal.xyz, a_tangent.xyz) * var_4938b.w, 0.0)).xyz;
    v_clipPosition = var_d80ab;
#ifdef RENDER_AS_BILLBOARDS__OFF
    v_color0 = a_color0;
#endif
#ifdef RENDER_AS_BILLBOARDS__ON
    v_color0 = vec4(1.0);
#endif
    v_ditheringAndMaskTinting = vec2(float(var_d0d1e & 1u), float(var_d0d1e & 2u));
    v_frontFacing = 0;
    v_lightmapUV = vec2(clamp(float(var_960bd & 15u) * 0.0625, 0.0, 1.0), clamp(float((var_960bd & 240u) >> uint(4)) * 0.0625, 0.0, 1.0));
    v_normal = (u_model[0] * vec4(a_normal.xyz, 0.0)).xyz;
    v_pbrTextureId = int(a_texcoord4) & 65535;
    v_tangent = (u_model[0] * vec4(a_tangent.xyz, 0.0)).xyz;
    v_texcoord0 = a_texcoord0;
#ifdef RENDER_AS_BILLBOARDS__OFF
    v_worldPos = var_e2d09.xyz;
#endif
#ifdef RENDER_AS_BILLBOARDS__ON
    v_worldPos = var_05010;
#endif
    gl_Position = var_d80ab;
}
