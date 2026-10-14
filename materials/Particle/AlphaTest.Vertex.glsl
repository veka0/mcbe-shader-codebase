#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_ParticleTexture;
*
* Uniforms:
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
*/

#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform mat4 u_viewProj;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec4 v_color0;
out vec4 v_fog;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#ifdef INSTANCING__OFF
    vec4 var_12727 = u_model[0] * vec4(a_position, 1.0);
#endif
#ifdef INSTANCING__ON
    mat4 var_53a7d;
    var_53a7d[0] = vec4(i_data1.x, i_data2.x, i_data3.x, 0.0);
    var_53a7d[1] = vec4(i_data1.y, i_data2.y, i_data3.y, 0.0);
    var_53a7d[2] = vec4(i_data1.z, i_data2.z, i_data3.z, 0.0);
    var_53a7d[3] = vec4(i_data1.w, i_data2.w, i_data3.w, 1.0);
    vec4 var_12727 = var_53a7d * vec4(a_position, 1.0);
#endif
    vec4 var_32522 = u_viewProj * vec4(var_12727.xyz, 1.0);
    vec4 var_b4024 = var_32522;
    v_color0 = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_b4024.z / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_texcoord0 = a_texcoord0;
    v_worldPos = var_12727.xyz;
    gl_Position = var_32522;
}
