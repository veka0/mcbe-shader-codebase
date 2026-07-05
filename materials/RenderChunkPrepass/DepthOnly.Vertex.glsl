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
* - layout(binding = 3, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
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

#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform mat4 u_viewProj;
#ifdef RENDER_AS_BILLBOARDS__ON
uniform vec4 ViewPositionAndTime;
#endif
in vec4 a_color0;
in vec2 a_texcoord1;
in vec4 a_normal;
in vec3 a_position;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec3 v_bitangent;
out vec4 v_color0;
out vec2 v_ditheringAndMaskTinting;
out vec3 v_lightColor;
out vec2 v_lightmapUV;
out vec3 v_normal;
out vec3 v_tangent;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#if defined(INSTANCING__OFF) && defined(RENDER_AS_BILLBOARDS__OFF)
    vec4 var_9b079 = u_model[0] * vec4(a_position, 1.0);
#endif
#if defined(INSTANCING__OFF) && defined(RENDER_AS_BILLBOARDS__ON)
    vec3 var_91aa3 = (u_model[0] * vec4(a_position, 1.0)).xyz;
    vec3 var_0405a = var_91aa3 + vec3(0.5);
    vec3 var_28a72 = normalize(var_0405a - ViewPositionAndTime.xyz);
    vec3 var_e8e55 = normalize(cross(vec3(0.0, 1.0, 0.0), var_28a72));
    vec3 var_08866 = a_color0.xyz;
#endif
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_cc6b6;
    var_cc6b6[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_cc6b6[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_cc6b6[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_cc6b6[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
#endif
#if defined(INSTANCING__ON) && defined(RENDER_AS_BILLBOARDS__OFF)
    vec4 var_9b079 = var_cc6b6 * vec4(a_position, 1.0);
#endif
#if defined(INSTANCING__ON) && defined(RENDER_AS_BILLBOARDS__ON)
    vec3 var_91aa3 = (var_cc6b6 * vec4(a_position, 1.0)).xyz;
    vec3 var_0405a = var_91aa3 + vec3(0.5);
    vec3 var_28a72 = normalize(var_0405a - ViewPositionAndTime.xyz);
    vec3 var_e8e55 = normalize(cross(vec3(0.0, 1.0, 0.0), var_28a72));
    vec3 var_08866 = a_color0.xyz;
#endif
    uvec2 var_6c76e = uvec2(round(a_texcoord0 * 65535.0));
    vec2 var_45935 = vec2(float((var_6c76e.x & 32767u) << uint(1)), float((var_6c76e.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    var_45935.x += (3.0517578125e-05 * ((2.0 * float((var_6c76e.x & 32768u) >> uint(15))) - 1.0));
    var_45935.y += (3.0517578125e-05 * ((2.0 * float((var_6c76e.y & 32768u) >> uint(15))) - 1.0));
    vec4 var_57c72 = a_normal;
    uvec2 var_b33a4 = uvec2(round(a_texcoord1 * 65535.0));
    uvec2 var_5e4ed = var_b33a4;
    uvec2 var_09f26 = (var_b33a4 >> uvec2(8u)) & uvec2(255u);
    uvec2 var_ebbee = var_b33a4 & uvec2(255u);
    uvec2 var_c4862 = var_09f26 & uvec2(254u);
    vec4 var_d5790 = vec4(vec3(float(var_c4862.x), float(var_ebbee.x), float(var_c4862.y)) * vec3(0.0039215688593685626983642578125), (var_57c72.w * 0.5) + 0.5);
    vec4 var_22492 = var_d5790;
    v_bitangent = vec3(0.0);
#ifdef RENDER_AS_BILLBOARDS__OFF
    v_color0 = a_color0;
#endif
#ifdef RENDER_AS_BILLBOARDS__ON
    v_color0 = vec4(1.0);
#endif
    v_ditheringAndMaskTinting = vec2(notEqual((var_09f26 & uvec2(1u)), uvec2(0u)));
    v_lightColor = (var_d5790.xyz * var_22492.w) * 6.0;
    v_lightmapUV = vec2(uvec2(var_5e4ed.y >> 4u, var_5e4ed.y) & uvec2(15u)) * vec2(0.066666670143604278564453125);
    v_normal = vec3(0.0);
    v_tangent = vec3(0.0);
    v_texcoord0 = var_45935;
#ifdef RENDER_AS_BILLBOARDS__OFF
    v_worldPos = var_9b079.xyz;
    gl_Position = u_viewProj * vec4(var_9b079.xyz, 1.0);
#endif
#ifdef RENDER_AS_BILLBOARDS__ON
    v_worldPos = var_91aa3;
    gl_Position = u_viewProj * vec4(var_0405a - ((cross(var_28a72, var_e8e55) * (var_08866.z - 0.5)) + (var_e8e55 * (var_08866.x - 0.5))), 1.0);
#endif
}
