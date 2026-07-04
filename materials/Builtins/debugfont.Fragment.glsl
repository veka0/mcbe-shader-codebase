#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLEAR0_PASS (not used)
* - CLEAR1_PASS (not used)
* - CLEAR2_PASS (not used)
* - CLEAR3_PASS (not used)
* - CLEAR4_PASS (not used)
* - CLEAR5_PASS (not used)
* - CLEAR6_PASS (not used)
* - CLEAR7_PASS (not used)
* - DEBUGFONT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_texColor;
*
* Uniforms:
* - uniform vec4 bgfx_clear_color[8];
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_texColor;
in highp vec4 v_color0;
in highp vec4 v_color1;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_fadc3 = texture(s_texColor, v_texcoord0);
    highp vec4 var_616dd = mix(v_color0, v_color1, var_fadc3.xxxx);
    highp vec4 var_67589 = var_616dd;
    if (var_67589.w < 0.0039215688593685626983642578125)
    {
        discard;
    }
    bgfx_FragColor = var_616dd;
}
