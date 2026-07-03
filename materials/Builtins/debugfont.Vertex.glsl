#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLEAR0_PASS (not used)
* - CLEAR1_PASS (not used)
* - CLEAR2_PASS (not used)
* - CLEAR3_PASS (not used)
* - CLEAR4_PASS (not used)
* - CLEAR5_PASS (not used)
* - CLEAR6_PASS (not used)
* - CLEAR7_PASS (not used)
* - DEBUGFONT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_texColor;
*
* Uniforms:
* - uniform vec4 bgfx_clear_color[8];
*/

uniform mat4 u_modelViewProj;
in vec4 a_color0;
in vec4 a_color1;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color0;
out vec4 v_color1;
out vec2 v_texcoord0;
void main() {
    v_color0 = a_color0;
    v_color1 = a_color1;
    v_texcoord0 = a_texcoord0;
    gl_Position = u_modelViewProj * vec4(a_position, 1.0);
}
