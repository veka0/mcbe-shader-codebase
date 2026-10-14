#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLOOM_BLEND_PASS (not used)
* - DF_DOWN_SAMPLE_PASS (not used)
* - DF_UP_SAMPLE_PASS (not used)
* - THRESHOLDED_DOWN_SAMPLE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AverageLuminance;
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
    vec4 var_c1461 = vec4(0.0);
    vec2 var_f32e0 = a_texcoord0 * ViewportScale.xy;
    var_c1461.x = var_f32e0.x;
    var_c1461.y = var_f32e0.y;
    var_c1461.z = a_texcoord0.x;
    var_c1461.w = a_texcoord0.y;
    v_texcoord0 = var_c1461;
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
