#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORCE_FORWARD_PBR_OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
* - TRANSPARENT_DEGAMMA_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
*
* Uniforms:
* - uniform mat4 CubemapRotation;
* - uniform vec4 PreExposureEnabled;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_a8ff5 = texture(s_MatTexture, v_texcoord0);
    highp vec4 var_55afb = var_a8ff5;
    bgfx_FragColor = vec4(pow(max(var_a8ff5.xyz, vec3(0.0)), vec3(2.2000000476837158203125)), var_55afb.w);
}
