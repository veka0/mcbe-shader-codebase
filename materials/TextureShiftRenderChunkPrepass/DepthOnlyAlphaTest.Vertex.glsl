#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
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
* - RENDER_AS_BILLBOARDS__OFF (not used)
*
* Seasons:
* - SEASONS__OFF (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_LightMapTexture;
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 3, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform lowp sampler2D s_SeasonsTexture;
* - layout(binding = 4, std430) buffer s_TextureShiftBufferDataBuffer { TextureShiftBuffer s_TextureShiftBufferData[]; };
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

#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform mat4 u_viewProj;
in vec3 a_position;
in vec2 a_texcoord0;
in vec2 a_texcoord2;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec3 v_bitangent;
out vec4 v_color0;
out vec3 v_normal;
out vec3 v_tangent;
out vec2 v_texcoord0;
flat out vec2 v_textureShift;
out vec3 v_worldPos;
void main() {
#ifdef INSTANCING__OFF
    vec4 var_9b079 = u_model[0] * vec4(a_position, 1.0);
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
    vec4 var_9b079 = var_e43a8 * vec4(a_position, 1.0);
#endif
    uvec2 var_6c76e = uvec2(round(a_texcoord0 * 65535.0));
    vec2 var_45935 = vec2(float((var_6c76e.x & 32767u) << uint(1)), float((var_6c76e.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    var_45935.x += (3.0517578125e-05 * ((2.0 * float((var_6c76e.x & 32768u) >> uint(15))) - 1.0));
    var_45935.y += (3.0517578125e-05 * ((2.0 * float((var_6c76e.y & 32768u) >> uint(15))) - 1.0));
    v_bitangent = vec3(0.0);
    v_color0 = vec4(0.0);
    v_normal = vec3(0.0);
    v_tangent = vec3(0.0);
    v_texcoord0 = var_45935;
    v_textureShift = a_texcoord2;
    v_worldPos = var_9b079.xyz;
    gl_Position = u_viewProj * vec4(var_9b079.xyz, 1.0);
}
