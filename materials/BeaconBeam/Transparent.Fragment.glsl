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
    highp vec4 var_0bbb5 = texture(s_BeaconTexture, v_texCoords);
    highp vec4 var_34873 = mix(var_0bbb5, OverlayColor, vec4(OverlayColor.w));
    bgfx_FragData0 = vec4(var_34873.x, var_34873.y, var_34873.z, var_0bbb5.w) * v_color;
}
