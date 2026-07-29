#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
*
* Available Resources:
*/

precision mediump float;
precision highp int;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    bgfx_FragData0 = vec4(0.0);
}
