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
    highp vec4 var_24474 = v_fog;
    highp vec4 var_41df3 = mix(v_color, OverlayColor, vec4(OverlayColor.w));
    highp vec4 var_d8775 = vec4(var_41df3.x, var_41df3.y, var_41df3.z, v_color.w) * v_light;
    bgfx_FragData0 = vec4(mix(var_d8775.xyz, v_fog.xyz, vec3(var_24474.w)), var_d8775.w);
}
