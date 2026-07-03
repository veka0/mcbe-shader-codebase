#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLOOM_BLEND_PASS (not used)
* - DF_DOWN_SAMPLE_PASS (not used)
* - DF_UP_SAMPLE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BlurPyramidTexture;
* - uniform lowp sampler2D s_HDRi;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 BloomParams;
* - uniform vec4 ScreenSize;
* - uniform vec4 ViewportScale;
*/

uniform vec4 ViewportScale;
in vec4 a_position;
in vec2 a_texcoord0;
out vec4 v_texcoord0;
void main() {
    vec2 var_828cb = a_texcoord0 * ViewportScale.xy;
    v_texcoord0 = vec4(var_828cb.x, var_828cb.y, a_texcoord0.x, a_texcoord0.y);
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
