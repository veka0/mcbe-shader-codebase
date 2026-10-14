#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_SkyTexture;
*
* Uniforms:
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 SkyColor;
* - uniform mat4 UV0Transform;
*/

uniform mat4 UV0Transform;
#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform mat4 u_viewProj;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec4 v_color0;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#ifdef INSTANCING__OFF
    vec4 var_9b079 = u_model[0] * vec4(a_position, 1.0);
#endif
#ifdef INSTANCING__ON
    mat4 var_53a7d;
    var_53a7d[0] = vec4(i_data1.x, i_data2.x, i_data3.x, 0.0);
    var_53a7d[1] = vec4(i_data1.y, i_data2.y, i_data3.y, 0.0);
    var_53a7d[2] = vec4(i_data1.z, i_data2.z, i_data3.z, 0.0);
    var_53a7d[3] = vec4(i_data1.w, i_data2.w, i_data3.w, 1.0);
    vec4 var_9b079 = var_53a7d * vec4(a_position, 1.0);
#endif
    v_color0 = a_color0;
    v_texcoord0 = (UV0Transform * vec4(a_texcoord0, 0.0, 1.0)).xy;
    v_worldPos = var_9b079.xyz;
    gl_Position = u_viewProj * vec4(var_9b079.xyz, 1.0);
}
