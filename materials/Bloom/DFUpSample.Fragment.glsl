#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLOOM_BLEND_PASS (not used)
* - DF_DOWN_SAMPLE_PASS (not used)
* - DF_UP_SAMPLE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BlurPyramidTexture;
* - uniform lowp sampler2D s_HDRi;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 BloomParams;
* - uniform vec4 ScreenSize;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_BlurPyramidTexture;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_fc471 = v_texcoord0;
    highp vec2 var_e9fce = vec2(4.0 * abs(dFdx(var_fc471.x)), 4.0 * abs(dFdy(var_fc471.y)));
    bgfx_FragColor = (((((((texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(0.5 * var_e9fce.x, 0.5 * var_e9fce.y)) * 0.16599999368190765380859375) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2((-0.5) * var_e9fce.x, 0.5 * var_e9fce.y)) * 0.16599999368190765380859375)) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(0.5 * var_e9fce.x, (-0.5) * var_e9fce.y)) * 0.16599999368190765380859375)) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2((-0.5) * var_e9fce.x, (-0.5) * var_e9fce.y)) * 0.16599999368190765380859375)) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(var_e9fce.x, var_e9fce.y)) * 0.082999996840953826904296875)) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(-var_e9fce.x, var_e9fce.y)) * 0.082999996840953826904296875)) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(var_e9fce.x, -var_e9fce.y)) * 0.082999996840953826904296875)) + (texture(s_BlurPyramidTexture, v_texcoord0.xy + vec2(-var_e9fce.x, -var_e9fce.y)) * 0.082999996840953826904296875);
}
