#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLIT_PASS (not used)
* - BLIT_UNCOMPRESSED_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 ViewportScale;
*/

in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    vec4 var_c3366 = vec4(a_position, 1.0);
    vec2 var_19dcd = (var_c3366.xy * 2.0) - vec2(1.0);
    v_texcoord0 = a_texcoord0;
    gl_Position = vec4(var_19dcd.x, var_19dcd.y, var_c3366.z, var_c3366.w);
}
