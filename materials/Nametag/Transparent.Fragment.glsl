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
    highp vec4 var_1abd2 = vec4(1.0);
    highp vec3 var_f0272 = mix(vec3(1.0), OverlayColor.xyz, vec3(OverlayColor.w));
    var_1abd2.x = var_f0272.x;
    var_1abd2.y = var_f0272.y;
    var_1abd2.z = var_f0272.z;
    highp vec4 var_7ea08 = var_1abd2;
    highp vec4 var_27376 = (CurrentColor * v_color) * var_7ea08;
    var_1abd2 = var_27376;
    bgfx_FragData0 = var_27376;
}
