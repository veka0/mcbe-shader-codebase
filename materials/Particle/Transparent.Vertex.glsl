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
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_e43a8;
    var_e43a8[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_e43a8[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_e43a8[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_e43a8[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
    vec4 var_12727 = var_e43a8 * vec4(a_position, 1.0);
#endif
    vec4 var_32522 = u_viewProj * vec4(var_12727.xyz, 1.0);
    vec4 var_b4024 = var_32522;
    v_color0 = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_b4024.z / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_texcoord0 = a_texcoord0;
    v_worldPos = var_12727.xyz;
    gl_Position = var_32522;
}
