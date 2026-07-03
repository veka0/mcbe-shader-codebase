#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLOOM_BLEND_PASS (not used)
* - BLOOM_HIGH_PASS (not used)
* - DF_DOWN_SAMPLE_PASS (not used)
* - DF_DOWN_SAMPLE_WITH_DEPTH_EROSION_PASS (not used)
* - DF_UP_SAMPLE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BlurPyramidTexture;
* - uniform lowp sampler2D s_DepthTexture;
* - uniform lowp sampler2D s_HDRi;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 BloomParams1;
* - uniform vec4 BloomParams2;
* - uniform vec4 RenderMode;
* - uniform vec4 ScreenSize;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_BlurPyramidTexture;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_a00a8 = v_texcoord0;
    highp vec2 var_70e81 = vec2(1.5 * abs(dFdx(var_a00a8.x)), 1.5 * abs(dFdy(var_a00a8.y)));
    highp vec4 var_4dee2 = texture(s_BlurPyramidTexture, v_texcoord0);
    highp vec4 var_3f45c = var_4dee2;
    highp vec4 var_b2560 = texture(s_BlurPyramidTexture, v_texcoord0 + vec2(var_70e81.x, var_70e81.y));
    highp vec4 var_1c7d2 = var_b2560;
    highp vec4 var_f6584 = texture(s_BlurPyramidTexture, v_texcoord0 + vec2(-var_70e81.x, var_70e81.y));
    highp vec4 var_baaaa = var_f6584;
    highp vec4 var_ebf04 = texture(s_BlurPyramidTexture, v_texcoord0 + vec2(var_70e81.x, -var_70e81.y));
    highp vec4 var_0de5b = var_ebf04;
    highp vec4 var_6ea97 = texture(s_BlurPyramidTexture, v_texcoord0 + vec2(-var_70e81.x, -var_70e81.y));
    highp vec4 var_55ae2 = var_6ea97;
    highp vec3 var_8552e = ((((var_4dee2.xyz * 0.5).xyz + (var_b2560.xyz * 0.125)).xyz + (var_f6584.xyz * 0.125)).xyz + (var_ebf04.xyz * 0.125)).xyz + (var_6ea97.xyz * 0.125);
    highp vec4 var_9bc86 = vec4(var_8552e.x, var_8552e.y, var_8552e.z, vec4(0.0).w);
    var_9bc86.w = max(var_3f45c.w, max(var_1c7d2.w, max(var_baaaa.w, max(var_0de5b.w, var_55ae2.w))));
    bgfx_FragColor = var_9bc86;
}
