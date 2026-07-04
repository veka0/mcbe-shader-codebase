#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 MatColor;
* - uniform vec4 SubPixelOffset;
*/

uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    mat4 var_96cfc = u_proj;
    var_96cfc[2].x += SubPixelOffset.x;
    var_96cfc[2].y -= SubPixelOffset.y;
    vec4 var_120f8 = var_96cfc * (u_view * vec4(a_position, 1.0));
    var_120f8.z -= 0.0001220703125;
    v_texcoord0 = a_texcoord0;
    gl_Position = var_120f8;
}
