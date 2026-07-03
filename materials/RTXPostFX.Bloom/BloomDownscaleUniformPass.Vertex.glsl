#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLOOM_DOWNSCALE_GAUSSIAN_PASS (not used)
* - BLOOM_DOWNSCALE_UNIFORM_PASS (not used)
* - BLOOM_FINAL_PASS (not used)
* - BLOOM_UPSCALE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_RasterColor;
* - uniform lowp sampler2D s_gBloomOriginalInput;
*
* Uniforms:
* - uniform vec4 RenderMode;
* - uniform vec4 ScreenSize;
* - uniform vec4 gBloomMultiplier;
* - uniform vec4 gViewportScale;
*/

in vec4 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    vec2 var_8e808 = a_texcoord0;
    v_texcoord0 = vec2(var_8e808.x, var_8e808.y);
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
