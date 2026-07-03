#version 310 es

/*
* Available Macros:
*
* Passes:
* - COLOR_POST_PROCESS_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_ColorTexture;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 ColorGrading_Gamma_PlayerUI;
* - uniform vec4 ScreenSize;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_ColorTexture;
uniform highp vec4 ColorGrading_Gamma_PlayerUI;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = vec4(clamp(pow(max(texture(s_ColorTexture, v_texcoord0.xy).xyz, vec3(0.0)), vec3(1.0) / (vec3(2.2000000476837158203125) * ColorGrading_Gamma_PlayerUI.x)), vec3(0.0), vec3(1.0)), 1.0);
}
