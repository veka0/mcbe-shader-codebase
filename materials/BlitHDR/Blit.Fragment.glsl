#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLIT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AverageLuminance;
* - uniform lowp sampler2D s_BlitTexture;
*
* Uniforms:
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_AverageLuminance;
uniform highp sampler2D s_BlitTexture;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_e55f4 = texture(s_BlitTexture, v_texcoord0);
    highp vec4 var_2f8a6 = var_e55f4;
    bgfx_FragColor = vec4(var_e55f4.xyz / vec3((0.180000007152557373046875 / texture(s_AverageLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05), var_2f8a6.w);
}
