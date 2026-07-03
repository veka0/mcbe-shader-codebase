#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEBUG_BLIT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 ClipPlanes;
* - uniform vec4 DebugMode;
*/

precision mediump float;
precision highp int;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = vec4(0.0);
}
