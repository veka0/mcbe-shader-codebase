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
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = texture(s_MatTexture, v_texcoord0);
}
