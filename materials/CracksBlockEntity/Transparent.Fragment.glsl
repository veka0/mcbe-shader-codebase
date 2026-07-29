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
* - uniform lowp sampler2D s_CracksTexture;
*
* Uniforms:
* - uniform mat4 Bones[8];
* - uniform vec4 SubPixelOffset;
* - uniform vec4 UVScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_CracksTexture;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    bgfx_FragData0 = texture(s_CracksTexture, v_texcoord0);
}
