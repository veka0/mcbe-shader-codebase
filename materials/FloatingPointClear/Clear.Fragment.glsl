#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLEAR_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 ClearColor;
*/

precision mediump float;
precision highp int;
uniform highp vec4 ClearColor;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    bgfx_FragData0 = ClearColor;
}
