#version 310 es

/*
* Available Macros:
*
* Passes:
* - SCREEN_PASS (not used)
*
* Available Resources:
*/

precision mediump float;
precision highp int;
in highp vec4 v_color;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    bgfx_FragData0 = v_color;
}
