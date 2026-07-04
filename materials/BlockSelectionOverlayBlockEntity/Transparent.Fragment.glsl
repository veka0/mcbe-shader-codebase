#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform mat4 Bones[8];
* - uniform vec4 MatColor;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 MatColor;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_0b949 = texture(s_MatTexture, v_texcoord0);
    if (var_0b949.w < 0.5)
    {
        discard;
    }
    bgfx_FragColor = MatColor;
}
