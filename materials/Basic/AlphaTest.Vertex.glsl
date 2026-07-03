#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* SampleMatTexture:
* - SAMPLE_MAT_TEXTURE__OFF (not used)
* - SAMPLE_MAT_TEXTURE__ON (not used)
*
* TransformUV0:
* - TRANSFORM_UV0__OFF
* - TRANSFORM_UV0__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 LightDirectionAndIntensity;
* - uniform vec4 MatColor;
* - uniform mat4 UV0Transform;
*/

#ifdef TRANSFORM_UV0__ON
uniform mat4 UV0Transform;
#endif
uniform mat4 u_model[4];
uniform mat4 u_view;
uniform mat4 u_viewProj;
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
out vec4 v_color0;
out vec3 v_normal;
out vec3 v_tangent;
out vec2 v_texcoord0;
out vec3 v_viewDir;
out vec3 v_wpos;
void main() {
#ifdef INSTANCING__OFF
    vec4 var_0542e = u_model[0] * vec4(a_position, 1.0);
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
    vec4 var_0542e = var_e43a8 * vec4(a_position, 1.0);
#endif
    vec3 var_58bef = normalize((u_view * vec4((u_model[0] * vec4(a_normal.xyz, 0.0)).xyz, 0.0)).xyz);
    vec3 var_7ef50 = normalize((u_view * vec4((u_model[0] * vec4(a_tangent.xyz, 0.0)).xyz, 0.0)).xyz);
    vec3 var_97a84 = cross(var_58bef, var_7ef50);
    v_bitangent = var_97a84;
    v_color0 = a_color0;
    v_normal = var_58bef;
    v_tangent = var_7ef50;
#ifdef TRANSFORM_UV0__OFF
    v_texcoord0 = a_texcoord0;
#endif
#ifdef TRANSFORM_UV0__ON
    v_texcoord0 = (UV0Transform * vec4(a_texcoord0, 0.0, 1.0)).xy;
#endif
    v_viewDir = (u_view * vec4(var_0542e.xyz, 0.0)).xyz * transpose(mat3(var_7ef50, var_97a84, var_58bef));
    v_wpos = var_0542e.xyz;
    gl_Position = u_viewProj * vec4(var_0542e.xyz, 1.0);
}
