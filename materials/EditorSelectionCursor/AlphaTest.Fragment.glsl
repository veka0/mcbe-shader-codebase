#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS (not used)
* - RASTERIZED_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 FrameTime;
* - uniform vec4 MatColor;
*/

precision mediump float;
precision highp int;
uniform highp vec4 MatColor;
in highp float v_w;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    if (mod(v_w, 0.5) > 0.375)
    {
        discard;
    }
    bgfx_FragData0 = MatColor;
}
