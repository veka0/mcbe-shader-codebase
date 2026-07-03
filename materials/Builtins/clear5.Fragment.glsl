#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLEAR0_PASS (not used)
* - CLEAR1_PASS (not used)
* - CLEAR2_PASS (not used)
* - CLEAR3_PASS (not used)
* - CLEAR4_PASS (not used)
* - CLEAR5_PASS (not used)
* - CLEAR6_PASS (not used)
* - CLEAR7_PASS (not used)
* - DEBUGFONT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_texColor;
*
* Uniforms:
* - uniform vec4 bgfx_clear_color[8];
*/

precision mediump float;
precision highp int;
uniform highp vec4 bgfx_clear_color[8];
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = bgfx_clear_color[0];
}
