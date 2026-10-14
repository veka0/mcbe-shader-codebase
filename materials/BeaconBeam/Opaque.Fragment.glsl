#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BeaconTexture;
*
* Uniforms:
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 UVAnimation;
*/

precision mediump float;
precision highp int;
uniform highp vec4 OverlayColor;
in highp vec4 v_color;
in highp vec4 v_fog;
in highp vec4 v_light;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_423c2 = v_color;
    highp vec4 var_ba7c2 = mix(v_color, OverlayColor, vec4(OverlayColor.w));
    var_423c2.x = var_ba7c2.x;
    var_423c2.y = var_ba7c2.y;
    var_423c2.z = var_ba7c2.z;
    highp vec4 var_cad20 = var_423c2;
    highp vec4 var_a4582 = var_cad20 * v_light;
    var_423c2 = var_a4582;
    highp vec3 var_c6e56 = mix(var_a4582.xyz, v_fog.xyz, vec3(v_fog.w));
    var_423c2.x = var_c6e56.x;
    var_423c2.y = var_c6e56.y;
    var_423c2.z = var_c6e56.z;
    bgfx_FragData0 = var_423c2;
}
