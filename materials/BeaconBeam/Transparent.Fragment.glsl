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
uniform highp sampler2D s_BeaconTexture;
uniform highp vec4 OverlayColor;
in highp vec4 v_color;
in highp vec2 v_texCoords;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_b3bc0 = texture(s_BeaconTexture, v_texCoords);
    highp vec4 var_547af = var_b3bc0;
    highp vec4 var_e9eee = mix(var_b3bc0, OverlayColor, vec4(OverlayColor.w));
    var_547af.x = var_e9eee.x;
    var_547af.y = var_e9eee.y;
    var_547af.z = var_e9eee.z;
    highp vec4 var_0d7a8 = var_547af;
    highp vec4 var_f5aab = var_0d7a8 * v_color;
    var_547af = var_f5aab;
    bgfx_FragData0 = var_f5aab;
}
