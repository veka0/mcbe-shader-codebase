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
* - uniform vec4 CurrentColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 ZShiftValue;
*/

precision mediump float;
precision highp int;
uniform highp vec4 CurrentColor;
uniform highp vec4 OverlayColor;
in highp vec4 v_color;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec3 var_dab17 = mix(vec3(1.0), OverlayColor.xyz, vec3(OverlayColor.w));
    bgfx_FragColor = (CurrentColor * v_color) * vec4(var_dab17.x, var_dab17.y, var_dab17.z, vec4(1.0).w);
}
