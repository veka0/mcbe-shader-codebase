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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    bgfx_FragData0 = vec4(v_color0.xyz, v_color0.w);
}
