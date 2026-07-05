#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform mat4 Bones[8];
* - uniform vec4 MatColor;
*/

uniform mat4 Bones[8];
uniform mat4 u_model[4];
uniform mat4 u_viewProj;
in float a_indices;
in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    vec4 var_2fd86 = u_viewProj * vec4(((u_model[0] * Bones[int(a_indices)]) * vec4(a_position, 1.0)).xyz, 1.0);
    var_2fd86.z -= 0.0001220703125;
    v_texcoord0 = a_texcoord0;
    gl_Position = var_2fd86;
}
