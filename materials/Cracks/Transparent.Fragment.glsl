#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_CRACKS_PASS (not used)
* - TRANSPARENT_PASS (not used)
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
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_0072b = texture(s_CracksTexture, v_texcoord0);
    highp vec4 var_b580a = var_0072b;
    if (var_b580a.w < 0.5)
    {
        discard;
    }
    bgfx_FragData0 = var_0072b;
}
