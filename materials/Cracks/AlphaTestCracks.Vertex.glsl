#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_CRACKS_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_CracksTexture;
*
* Uniforms:
* - uniform vec4 SubPixelOffset;
*/

uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    mat4 var_69af0 = u_proj;
    var_69af0[2].x += SubPixelOffset.x;
    var_69af0[2].y -= SubPixelOffset.y;
    v_texcoord0 = a_texcoord0;
    gl_Position = var_69af0 * (u_view * vec4(a_position, 1.0));
}
