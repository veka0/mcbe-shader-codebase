#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEBUG_BLIT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform highp sampler2DArray s_RasterColor;
*
* Uniforms:
* - uniform vec4 ClipPlanes;
* - uniform vec4 DebugMode;
* - uniform vec4 TextureArrayIndex;
*/

precision mediump float;
precision highp int;
uniform highp sampler2DArray s_RasterColor;
uniform highp vec4 TextureArrayIndex;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = texture(s_RasterColor, vec3(v_texcoord0, TextureArrayIndex.x));
}
