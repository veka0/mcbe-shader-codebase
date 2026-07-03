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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_a26ca = texture(s_BeaconTexture, v_texCoords);
    highp vec4 var_900ce = mix(var_a26ca, OverlayColor, vec4(OverlayColor.w));
    bgfx_FragColor = vec4(var_900ce.x, var_900ce.y, var_900ce.z, var_a26ca.w) * v_color;
}
