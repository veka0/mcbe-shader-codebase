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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec3 var_9cca5 = mix(vec3(1.0), OverlayColor.xyz, vec3(OverlayColor.w));
    bgfx_FragData0 = (CurrentColor * v_color) * vec4(var_9cca5.x, var_9cca5.y, var_9cca5.z, vec4(1.0).w);
}
