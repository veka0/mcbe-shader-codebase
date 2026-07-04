#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 MatColor;
* - uniform vec4 SubPixelOffset;
*/

precision mediump float;
precision highp int;
#ifdef ALPHA_TEST__ON
uniform highp sampler2D s_MatTexture;
#endif
uniform highp vec4 MatColor;
#ifdef ALPHA_TEST__ON
in highp vec2 v_texcoord0;
#endif
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifdef ALPHA_TEST__ON
    highp vec4 var_0b949 = texture(s_MatTexture, v_texcoord0);
    if (var_0b949.w < 0.5)
    {
        discard;
    }
#endif
    bgfx_FragColor = MatColor;
}
