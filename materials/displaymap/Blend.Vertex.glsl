#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLEND_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_TexColor;
*
* Uniforms:
* - uniform vec4 PaperWhite;
*/

uniform mat4 u_modelViewProj;
in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    v_texcoord0 = a_texcoord0;
    gl_Position = u_modelViewProj * vec4(a_position, 1.0);
}
