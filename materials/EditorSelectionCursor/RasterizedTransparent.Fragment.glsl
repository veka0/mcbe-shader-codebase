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
uniform highp vec4 FrameTime;
uniform highp vec4 MatColor;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_687b6 = MatColor;
    var_687b6.w += (sin(FrameTime.x * 6.28318023681640625) * 0.015625);
    bgfx_FragData0 = var_687b6;
}
