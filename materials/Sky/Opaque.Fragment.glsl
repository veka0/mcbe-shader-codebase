#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 FogColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 SkyColor;
*/

precision mediump float;
precision highp int;
in highp vec4 v_color0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_78693 = v_color0;
    bgfx_FragColor = vec4(v_color0.xyz, var_78693.w);
}
