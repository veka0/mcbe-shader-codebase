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
* - uniform vec4 CloudColor;
* - uniform vec4 DistanceControl;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 SubPixelOffset;
*/

precision mediump float;
precision highp int;
in highp vec4 v_color0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_07fd6 = v_color0;
    bgfx_FragData0 = vec4(v_color0.xyz, var_07fd6.w);
}
