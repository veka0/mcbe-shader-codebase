#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 HudOpacity;
* - uniform vec4 TintColor;
*/

precision mediump float;
precision highp int;
uniform highp vec4 HudOpacity;
uniform highp vec4 TintColor;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_9a522 = TintColor;
    var_9a522.w *= HudOpacity.x;
    bgfx_FragData0 = var_9a522;
}
