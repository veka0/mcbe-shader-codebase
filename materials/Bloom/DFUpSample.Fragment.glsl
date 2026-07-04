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
* - uniform vec4 RenderMode;
* - uniform vec4 ScreenSize;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_BlurPyramidTexture;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_f30bd = v_texcoord0;
    highp vec2 var_61d4e = vec2(4.0 * abs(dFdx(var_f30bd.x)), 4.0 * abs(dFdy(var_f30bd.y)));
    bgfx_FragColor = (((((((texture(s_BlurPyramidTexture, v_texcoord0 + vec2(0.5 * var_61d4e.x, 0.5 * var_61d4e.y)) * 0.16599999368190765380859375) + (texture(s_BlurPyramidTexture, v_texcoord0 + vec2((-0.5) * var_61d4e.x, 0.5 * var_61d4e.y)) * 0.16599999368190765380859375)) + (texture(s_BlurPyramidTexture, v_texcoord0 + vec2(0.5 * var_61d4e.x, (-0.5) * var_61d4e.y)) * 0.16599999368190765380859375)) + (texture(s_BlurPyramidTexture, v_texcoord0 + vec2((-0.5) * var_61d4e.x, (-0.5) * var_61d4e.y)) * 0.16599999368190765380859375)) + (texture(s_BlurPyramidTexture, v_texcoord0 + vec2(var_61d4e.x, var_61d4e.y)) * 0.082999996840953826904296875)) + (texture(s_BlurPyramidTexture, v_texcoord0 + vec2(-var_61d4e.x, var_61d4e.y)) * 0.082999996840953826904296875)) + (texture(s_BlurPyramidTexture, v_texcoord0 + vec2(var_61d4e.x, -var_61d4e.y)) * 0.082999996840953826904296875)) + (texture(s_BlurPyramidTexture, v_texcoord0 + vec2(-var_61d4e.x, -var_61d4e.y)) * 0.082999996840953826904296875);
}
