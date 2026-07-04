#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*/

precision mediump float;
precision highp int;
in highp vec4 v_Additional;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = v_Additional;
}
