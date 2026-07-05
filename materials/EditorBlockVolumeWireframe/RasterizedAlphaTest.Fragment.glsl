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
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_5f6ba = v_texcoord0;
    highp float var_89be8 = var_5f6ba.x + FrameTime.x;
    highp float var_b84e3 = var_89be8 - float(int(var_89be8));
    if (((var_5f6ba.y == 0.0) && (var_b84e3 > 0.4000000059604644775390625)) && (var_b84e3 < 0.60000002384185791015625))
    {
        discard;
    }
    bgfx_FragColor = MatColor;
}
