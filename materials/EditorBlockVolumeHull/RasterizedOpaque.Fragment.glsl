#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
* - RASTERIZED_OPAQUE_PASS (not used)
* - RASTERIZED_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 CameraDirection;
* - uniform vec4 MatColor;
*/

precision mediump float;
precision highp int;
uniform highp vec4 MatColor;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = MatColor;
}
