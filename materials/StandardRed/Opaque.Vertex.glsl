#version 310 es

/*
* Available Macros:
*
* Passes:
* - CUSTOM_PASS_BASED_ON_OPAQUE_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 Ambient;
* - uniform vec4 LightAmbientColorAndIntensity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
*/

uniform mat4 u_modelView;
#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform mat4 u_view;
uniform mat4 u_viewProj;
in vec4 a_color0;
in vec4 a_normal;
in vec3 a_position;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec4 v_color0;
out vec2 v_texcoord0;
out vec3 v_viewSpaceNormal;
out vec4 v_viewSpacePosition;
out vec3 v_worldPos;
void main() {
#ifdef INSTANCING__OFF
    vec4 var_400c1 = u_model[0] * vec4(a_position, 1.0);
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
    vec4 var_400c1 = var_e43a8 * vec4(a_position, 1.0);
#endif
    v_color0 = a_color0;
    v_texcoord0 = a_texcoord0;
    v_viewSpaceNormal = (u_modelView * vec4(a_normal.xyz, 0.0)).xyz;
    v_viewSpacePosition = u_view * vec4(var_400c1.xyz, 1.0);
    v_worldPos = var_400c1.xyz;
    gl_Position = u_viewProj * vec4(var_400c1.xyz, 1.0);
}
