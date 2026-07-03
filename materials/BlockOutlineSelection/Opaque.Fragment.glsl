#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 OutlineColor;
* - uniform vec4 SubPixelOffset;
*/

precision mediump float;
precision highp int;
uniform highp vec4 OutlineColor;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = OutlineColor;
}
