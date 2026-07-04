#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORWARD_PBR_TRANSPARENT_PASS (not used)
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
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_b69c4 = u_proj;
    var_b69c4[2] = var_67767;
    vec4 var_120f8 = var_b69c4 * (u_view * vec4(a_position, 1.0));
    var_120f8.z -= 0.0001220703125;
    v_texcoord0 = a_texcoord0;
    gl_Position = var_120f8;
}
