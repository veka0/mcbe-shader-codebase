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

precision mediump float;
precision highp int;
uniform highp sampler2D s_RasterColor;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = texture(s_RasterColor, v_texcoord0);
}
