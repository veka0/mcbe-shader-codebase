#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 StarsColor;
*/

precision mediump float;
precision highp int;
uniform highp vec4 StarsColor;
in highp vec4 v_color0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_f803a = v_color0;
    bgfx_FragColor = vec4(v_color0.xyz * (StarsColor.xyz * var_f803a.w), var_f803a.w);
}
