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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp float var_8ed5a = v_texcoord0.x + FrameTime.x;
    highp float var_b882c = var_8ed5a - trunc(var_8ed5a);
    if (((v_texcoord0.y == 0.0) && (var_b882c > 0.4000000059604644775390625)) && (var_b882c < 0.60000002384185791015625))
    {
        discard;
    }
    bgfx_FragData0 = MatColor;
}
