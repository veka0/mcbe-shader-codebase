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

precision mediump float;
precision highp int;
uniform highp sampler2D s_BlitTexture;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    bgfx_FragData0 = texture(s_BlitTexture, v_texcoord0);
}
