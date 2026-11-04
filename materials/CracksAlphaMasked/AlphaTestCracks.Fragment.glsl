#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_CRACKS_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_CracksTexture;
*
* Uniforms:
* - uniform vec4 SubPixelOffset;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_CracksTexture;
in highp vec2 v_sourceTexcoord;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_980d4 = texture(s_CracksTexture, v_sourceTexcoord);
    highp vec4 var_0072b = texture(s_CracksTexture, v_texcoord0);
    highp vec4 var_f6c59 = var_0072b;
    bool var_e5bd9 = var_980d4.w < 0.5;
    bool var_86bdb;
    if (!var_e5bd9)
    {
        var_86bdb = var_f6c59.w < 0.5;
    }
    else
    {
        var_86bdb = var_e5bd9;
    }
    if (var_86bdb)
    {
        discard;
    }
    bgfx_FragData0 = var_0072b;
}
