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
* - uniform vec4 ShadowColor;
*/

precision mediump float;
precision highp int;
uniform highp vec4 ShadowColor;
in highp vec4 v_color0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_ce517 = v_color0;
    bgfx_FragData0 = vec4(mix(v_color0.xyz, ShadowColor.xyz, vec3(var_ce517.w)), 1.0);
}
