#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLIT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AverageLuminance;
* - uniform lowp sampler2D s_BlitTexture;
*
* Uniforms:
* - uniform vec4 ViewportScale;
*/

in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    vec4 var_91d41 = vec4(a_position, 1.0);
    vec4 var_273da = var_91d41;
    vec2 var_5ee7b = (var_91d41.xy * 2.0) - vec2(1.0);
    var_273da.x = var_5ee7b.x;
    var_273da.y = var_5ee7b.y;
    v_texcoord0 = a_texcoord0;
    gl_Position = var_273da;
}
