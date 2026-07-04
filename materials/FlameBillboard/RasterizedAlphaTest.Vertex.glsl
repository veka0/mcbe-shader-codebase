#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_FlameAtlas;
*
* Uniforms:
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 UVOffset;
*/

uniform mat4 u_model[4];
uniform mat4 u_viewProj;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_fog;
out vec2 v_texcoord0;
void main() {
    vec4 var_ea244 = u_viewProj * vec4((u_model[0] * vec4(a_position, 1.0)).xyz, 1.0);
    vec4 var_b4024 = var_ea244;
    v_fog = vec4(FogColor.xyz, clamp(((var_b4024.z / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_texcoord0 = a_texcoord0;
    gl_Position = var_ea244;
}
